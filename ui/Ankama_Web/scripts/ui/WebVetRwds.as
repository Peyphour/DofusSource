package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.items.VeteranReward;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class WebVetRwds
   {
      
      private static const DAYS_PER_YEAR:uint = 360;
      
      private static const SECONDS_PER_DAY:uint = 86400;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var timeApi:TimeApi;
      
      private var _subscriptionDurationElapsed:Number;
      
      private var _subscriptionEndDate:Number;
      
      private var _allRewards:Array;
      
      private var _remainingTime:uint;
      
      private var _lastTime:uint;
      
      private var _lastRwd:ItemWrapper;
      
      private var _nextRwd:ItemWrapper;
      
      private var _timer:Timer;
      
      private var _interactiveComponentsList:Dictionary;
      
      public var lbl_subscriptionDuration:Label;
      
      public var tx_lastRwd:Texture;
      
      public var tx_nextRwd:Texture;
      
      public var tx_lastRwdSlot:TextureBitmap;
      
      public var tx_nextRwdSlot:TextureBitmap;
      
      public var lbl_lastRwd:Label;
      
      public var lbl_remainingTime:Label;
      
      public var lbl_remainingSub:Label;
      
      public var lbl_moreInfo:Label;
      
      public var ctr_noEnoughSub:GraphicContainer;
      
      public var btn_addSub:ButtonContainer;
      
      public var lbl_enoughSub:Label;
      
      public var lbl_month1:Label;
      
      public var lbl_month3:Label;
      
      public var lbl_month6:Label;
      
      public var lbl_month9:Label;
      
      public var gd_rewards:Grid;
      
      public function WebVetRwds()
      {
         this._allRewards = new Array();
         this._interactiveComponentsList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc4_:VeteranReward = null;
         this.uiApi.addComponentHook(this.tx_lastRwdSlot,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_lastRwdSlot,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_lastRwd,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_lastRwd,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_nextRwdSlot,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_nextRwdSlot,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_nextRwd,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_nextRwd,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.gd_rewards,ComponentHookList.ON_ITEM_ROLL_OVER);
         this.uiApi.addComponentHook(this.gd_rewards,ComponentHookList.ON_ITEM_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_moreInfo,ComponentHookList.ON_RELEASE);
         var _loc2_:Object = this.dataApi.getAllVeteranRewards();
         var _loc3_:Array = new Array();
         var _loc5_:uint = 1;
         for each(_loc4_ in _loc2_)
         {
            this._allRewards.push(_loc4_);
         }
         this._allRewards.sortOn("requiredSubDays",Array.NUMERIC);
         _loc3_.push({
            "text":this.uiApi.getText("ui.veteran.year",_loc5_),
            "items":[]
         });
         for each(_loc4_ in this._allRewards)
         {
            if(_loc4_.requiredSubDays < _loc5_ * DAYS_PER_YEAR)
            {
               _loc3_[_loc5_ - 1].items.push(_loc4_.item);
            }
            else
            {
               _loc5_++;
               _loc3_.push({
                  "text":this.uiApi.getText("ui.veteran.year",_loc5_),
                  "items":[_loc4_.item]
               });
            }
         }
         this.gd_rewards.dataProvider = _loc3_;
         this.lbl_month1.text = this.uiApi.processText(this.uiApi.getText("ui.social.monthsSinceLastConnection",1),"",true);
         this.lbl_month3.text = this.uiApi.processText(this.uiApi.getText("ui.social.monthsSinceLastConnection",3),"",false);
         this.lbl_month6.text = this.uiApi.processText(this.uiApi.getText("ui.social.monthsSinceLastConnection",6),"",false);
         this.lbl_month9.text = this.uiApi.processText(this.uiApi.getText("ui.social.monthsSinceLastConnection",9),"",false);
         this.refreshSubscriberDuration();
      }
      
      public function unload() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
         }
      }
      
      public function updateRwdLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         while(_loc4_ < 5)
         {
            if(!this._interactiveComponentsList[param2["slot" + _loc4_].name])
            {
               this.uiApi.addComponentHook(param2["slot" + _loc4_],ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2["slot" + _loc4_],ComponentHookList.ON_ROLL_OUT);
            }
            this._interactiveComponentsList[param2["slot" + _loc4_].name] = !!param1?param1.items[_loc4_]:null;
            _loc4_++;
         }
         if(param1)
         {
            param2.lbl_year.text = param1.text;
            _loc4_ = 0;
            while(_loc4_ < 5)
            {
               if(param1.items[_loc4_])
               {
                  param2["slot" + _loc4_].data = param1.items[_loc4_];
               }
               else
               {
                  param2["slot" + _loc4_].data = null;
               }
               _loc4_++;
            }
         }
         else
         {
            param2.lbl_year.text = "";
            _loc4_ = 0;
            while(_loc4_ < 5)
            {
               param2["slot" + _loc4_].data = null;
               _loc4_++;
            }
         }
      }
      
      private function refreshSubscriberDuration() : void
      {
         var _loc3_:VeteranReward = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:* = null;
         var _loc9_:uint = 0;
         this._subscriptionDurationElapsed = this.sysApi.getPlayerManager().subscriptionDurationElapsed;
         this._subscriptionEndDate = this.sysApi.getPlayerManager().subscriptionEndDate;
         if(this._subscriptionDurationElapsed == 0)
         {
            this.lbl_subscriptionDuration.text = this.uiApi.getText("ui.common.none");
         }
         else
         {
            _loc5_ = Math.floor(this._subscriptionDurationElapsed / SECONDS_PER_DAY);
            _loc6_ = Math.floor(_loc5_ / 360);
            _loc7_ = Math.floor((_loc5_ - _loc6_ * 360) / 30);
            _loc5_ = _loc5_ - _loc6_ * 360 - _loc7_ * 30;
            _loc8_ = "";
            if(_loc6_ > 0)
            {
               _loc8_ = _loc8_ + this.uiApi.processText(this.uiApi.getText("ui.veteran.years",_loc6_),"m",_loc6_ <= 1);
            }
            if(_loc7_ > 0)
            {
               if(_loc8_.length > 0)
               {
                  _loc8_ = _loc8_ + ", ";
               }
               _loc8_ = _loc8_ + this.uiApi.processText(this.uiApi.getText("ui.social.monthsSinceLastConnection",_loc7_),"m",_loc7_ <= 1);
            }
            if(_loc5_ > 0)
            {
               if(_loc8_.length > 0)
               {
                  _loc8_ = _loc8_ + ", ";
               }
               _loc8_ = _loc8_ + this.uiApi.processText(this.uiApi.getText("ui.social.daysSinceLastConnection",_loc5_),"m",_loc5_ <= 1);
            }
            if(_loc8_ == "")
            {
               _loc8_ = this.uiApi.getText("ui.social.lessThanADay");
            }
            this.lbl_subscriptionDuration.text = _loc8_;
         }
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         for each(_loc3_ in this._allRewards)
         {
            if(_loc3_.requiredSubDays * SECONDS_PER_DAY <= this._subscriptionDurationElapsed)
            {
               _loc1_ = _loc3_.itemGID;
            }
            else if(_loc2_ == 0)
            {
               _loc2_ = _loc3_.itemGID;
               this._remainingTime = _loc3_.requiredSubDays * SECONDS_PER_DAY - this._subscriptionDurationElapsed;
            }
         }
         if(_loc1_ > 0)
         {
            this._lastRwd = this.dataApi.getItemWrapper(_loc1_);
            this.tx_lastRwd.uri = this._lastRwd.fullSizeIconUri;
            this.lbl_lastRwd.width = 280;
            this.lbl_lastRwd.text = this.uiApi.getText("ui.veteran.lastRewardInfo",this._lastRwd.name);
            this.tx_lastRwdSlot.visible = true;
            this.tx_lastRwd.visible = true;
         }
         else
         {
            this._lastRwd = null;
            this.lbl_lastRwd.width = 451;
            this.lbl_lastRwd.text = this.uiApi.getText("ui.veteran.noLastReward");
            this.tx_lastRwdSlot.visible = false;
            this.tx_lastRwd.visible = false;
         }
         if(_loc2_)
         {
            this._nextRwd = this.dataApi.getItemWrapper(_loc2_);
            this.tx_nextRwd.uri = this._nextRwd.fullSizeIconUri;
            if(this._remainingTime <= SECONDS_PER_DAY)
            {
               this._lastTime = getTimer();
               this._timer = new Timer(1000);
               this._timer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
               this._timer.start();
            }
            else
            {
               _loc9_ = Math.ceil(this._remainingTime / SECONDS_PER_DAY);
               this.lbl_remainingTime.text = this.uiApi.getText("ui.veteran.nextRewardInfoDays",this._nextRwd.name,_loc9_);
            }
         }
         else
         {
            this.lbl_remainingTime.text = this.uiApi.getText("ui.veteran.noNextReward");
         }
         var _loc4_:Number = new Date().time;
         if(!this._subscriptionEndDate || this._subscriptionEndDate && this._subscriptionEndDate - _loc4_ < this._remainingTime * 1000)
         {
            this.ctr_noEnoughSub.visible = true;
            this.lbl_enoughSub.visible = false;
         }
         else
         {
            this.ctr_noEnoughSub.visible = false;
            this.lbl_enoughSub.visible = true;
         }
         if(this._subscriptionEndDate == 0)
         {
            if(this.sysApi.getPlayerManager().hasRights)
            {
               this.lbl_remainingSub.text = this.uiApi.getText("ui.common.admin");
            }
            else
            {
               this.lbl_remainingSub.text = this.uiApi.getText("ui.common.non_subscriber");
            }
         }
         else if(this._subscriptionEndDate < 2051222400000)
         {
            this.lbl_remainingSub.text = this.uiApi.getText("ui.connection.subscriberUntil",this.timeApi.getDate(this._subscriptionEndDate,true,true) + " " + this.timeApi.getClock(this._subscriptionEndDate,true,true));
         }
         else
         {
            this.lbl_remainingSub.text = this.uiApi.getText("ui.common.infiniteSubscription");
         }
      }
      
      private function formatLeadingZero(param1:Number) : String
      {
         return param1 < 10?"0" + param1:param1.toString();
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_addSub)
         {
            this.sysApi.goToUrl(this.uiApi.getText("ui.link.subscribe"));
         }
         else if(param1 == this.lbl_moreInfo)
         {
            this.sysApi.goToUrl(this.uiApi.getText("ui.link.vetRewards"));
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:uint = LocationEnum.POINT_TOP;
         var _loc4_:uint = LocationEnum.POINT_BOTTOM;
         var _loc5_:String = "itemName";
         var _loc6_:Object = {};
         var _loc7_:String = "ItemTooltip";
         if(param1 == this.tx_lastRwdSlot || param1 == this.tx_lastRwd)
         {
            _loc2_ = this._lastRwd;
         }
         else if(param1 == this.tx_nextRwdSlot || param1 == this.tx_nextRwd)
         {
            _loc2_ = this._nextRwd;
         }
         else
         {
            _loc2_ = param1.data;
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(_loc2_,param1,false,"standard",_loc3_,_loc4_,4,_loc5_,null,_loc6_,_loc7_);
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:Number = getTimer() - this._lastTime;
         this._remainingTime = this._remainingTime - 1;
         if(this._remainingTime <= 0)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
            this._timer.stop();
            this.refreshSubscriberDuration();
         }
         else
         {
            _loc3_ = Math.floor(this._remainingTime / 3600);
            _loc4_ = Math.floor((this._remainingTime - _loc3_ * 3600) / 60);
            _loc5_ = this._remainingTime - _loc3_ * 3600 - _loc4_ * 60;
            _loc6_ = this.formatLeadingZero(_loc3_) + ":" + this.formatLeadingZero(_loc4_) + ":" + this.formatLeadingZero(_loc5_);
            this.lbl_remainingTime.text = this.uiApi.getText("ui.veteran.nextRewardInfoClock",this._nextRwd.name,_loc6_);
         }
      }
   }
}
