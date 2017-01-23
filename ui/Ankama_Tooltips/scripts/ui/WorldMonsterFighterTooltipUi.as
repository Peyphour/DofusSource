package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import utils.TooltipUtil;
   
   public class WorldMonsterFighterTooltipUi
   {
       
      
      private var _timerHide:Timer;
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var fightApi:FightApi;
      
      public var sysApi:SystemApi;
      
      public var chatApi:ChatApi;
      
      public var dataApi:DataApi;
      
      private var _inPrefight:Boolean;
      
      private var _icons:Vector.<Texture>;
      
      public var lbl_text:Label;
      
      public var lbl_title:Label;
      
      public var lbl_damage:Label;
      
      public var lbl_fightStatus:Label;
      
      public var backgroundCtr:Object;
      
      public var mainCtr:GraphicContainer;
      
      public function WorldMonsterFighterTooltipUi()
      {
         this._icons = new Vector.<Texture>(0);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.updateContent(param1,true);
         var _loc2_:uint = param1.makerParam && param1.makerParam.cellId?uint(param1.makerParam.cellId):uint(param1.data.disposition.cellId);
         var _loc3_:Object = param1.makerParam && param1.makerParam.offsetRect?param1.makerParam.offsetRect:null;
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset,true,_loc2_,_loc3_);
         if(param1.autoHide)
         {
            this._timerHide = new Timer(2500);
            this._timerHide.addEventListener(TimerEvent.TIMER,this.onTimer);
            this._timerHide.start();
         }
      }
      
      public function updateContent(param1:Object, param2:Boolean = false) : void
      {
         var _loc7_:Texture = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:Monster = null;
         var _loc11_:Number = NaN;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         var _loc14_:* = null;
         var _loc3_:Boolean = !!this.fightApi.isMouseOverFighter(param1.data.contextualId)?true:false;
         this._inPrefight = Api.fight.preFightIsActive();
         if(this._inPrefight)
         {
            _loc8_ = "";
            _loc9_ = Api.fight.getMonsterId(param1.data.contextualId);
            if(_loc9_ > -1)
            {
               _loc10_ = Api.data.getMonsterFromId(_loc9_);
               if(_loc10_.isBoss)
               {
                  _loc8_ = Api.ui.getText("ui.item.boss");
               }
               else if(_loc10_.isMiniBoss)
               {
                  _loc8_ = Api.ui.getText("ui.item.miniboss");
               }
            }
            if(_loc8_ != "")
            {
               _loc8_ = _loc8_ + (" " + Api.ui.getText("ui.common.short.level"));
            }
            else
            {
               _loc8_ = _loc8_ + Api.ui.getText("ui.common.level");
            }
            this.lbl_text.text = Api.fight.getFighterName(param1.data.contextualId);
            this.lbl_title.text = _loc8_ + " " + Api.fight.getFighterLevel(param1.data.contextualId);
         }
         else
         {
            this.lbl_title.text = "";
            if(param1.data.stats.shieldPoints > 0)
            {
               this.lbl_text.text = "";
               this.lbl_text.appendText((!!_loc3_?Api.fight.getFighterName(param1.data.contextualId) + " ":"") + "(" + param1.data.stats.lifePoints + "+");
               this.lbl_text.appendText(param1.data.stats.shieldPoints,"shield");
               this.lbl_text.appendText(")","p");
            }
            else
            {
               this.lbl_text.text = (!!_loc3_?Api.fight.getFighterName(param1.data.contextualId) + " ":"") + "(" + param1.data.stats.lifePoints + ")";
            }
         }
         this.lbl_text.fullWidth();
         this.lbl_title.fullWidth();
         this.lbl_title.y = 20;
         var _loc4_:int = (this.lbl_title.width - this.lbl_text.width) / 2;
         if(_loc4_ < 0)
         {
            _loc4_ = _loc4_ * -1;
            this.lbl_title.x = _loc4_;
            this.lbl_text.x = 0;
         }
         else
         {
            this.lbl_title.x = 0;
            this.lbl_text.x = _loc4_;
         }
         if(!param2)
         {
            _loc11_ = this.getMaxLabelWidth();
            if(this.lbl_text.width == _loc11_)
            {
               this.backgroundCtr.width = _loc11_ + 12;
            }
            this.lbl_text.x = this.backgroundCtr.width / 2 - this.lbl_text.width / 2;
            return;
         }
         this.backgroundCtr.height = 35;
         if(this.lbl_title.text != "")
         {
            this.backgroundCtr.height = this.backgroundCtr.height + 20;
         }
         this.lbl_damage.text = "";
         this.lbl_fightStatus.text = "";
         var _loc5_:Number = this.getMaxLabelWidth();
         var _loc6_:Number = 0;
         this.lbl_fightStatus.width = 1;
         this.lbl_fightStatus.removeFromParent();
         if(param1.makerParam && param1.makerParam.fightStatus)
         {
            this.mainCtr.addContent(this.lbl_fightStatus);
            this.lbl_fightStatus.y = this.lbl_text.y + 20;
            _loc12_ = this.chatApi.getChatColors();
            _loc13_ = this.dataApi.getSpellState(param1.makerParam.fightStatus).name;
            _loc14_ = "<font color=\"#" + _loc12_[10].toString(16) + "\">" + _loc13_ + "</font>";
            this.lbl_fightStatus.appendText(_loc14_);
            this.lbl_fightStatus.fullWidth();
            _loc5_ = this.getMaxLabelWidth();
            this.lbl_text.x = _loc5_ / 2 - this.lbl_text.width / 2;
            this.lbl_fightStatus.x = _loc5_ / 2 - this.lbl_fightStatus.width / 2;
            this.backgroundCtr.height = this.backgroundCtr.height + this.lbl_fightStatus.height;
         }
         for each(_loc7_ in this._icons)
         {
            _loc7_.remove();
         }
         this._icons.length = 0;
         this.lbl_damage.width = 1;
         this.lbl_damage.removeFromParent();
         if(param1.makerParam && param1.makerParam.spellDamage)
         {
            this.mainCtr.addContent(this.lbl_damage);
            this.lbl_damage.y = !param1.makerParam.fightStatus?Number(this.lbl_text.y + 20):Number(this.lbl_fightStatus.y + 20);
            this.lbl_damage.appendText(param1.makerParam.spellDamage);
            this.lbl_damage.fullWidth();
            _loc6_ = TooltipUtil.showDamagePreviewIcons(this.lbl_damage,this.getMaxLabelWidth(),param1.makerParam.spellDamage.effectIcons,this._icons,this.mainCtr);
            _loc5_ = this.getMaxLabelWidth();
            this.lbl_text.x = _loc5_ / 2 - this.lbl_text.width / 2 + _loc6_;
            this.lbl_damage.x = _loc5_ / 2 - this.lbl_damage.width / 2 + _loc6_;
            this.backgroundCtr.height = this.backgroundCtr.height + this.lbl_damage.height;
         }
         this.backgroundCtr.width = _loc5_ + 12 + _loc6_;
      }
      
      private function getMaxLabelWidth() : Number
      {
         var _loc1_:Number = NaN;
         if(this.lbl_title.text != "")
         {
            _loc1_ = this.lbl_title.width;
         }
         if(this.lbl_text.text != "" && (isNaN(_loc1_) || this.lbl_text.width > _loc1_))
         {
            _loc1_ = this.lbl_text.width;
         }
         if(this.lbl_damage.text != "" && (isNaN(_loc1_) || this.lbl_damage.width > _loc1_))
         {
            _loc1_ = this.lbl_damage.width;
         }
         if(this.lbl_fightStatus.text != "" && (isNaN(_loc1_) || this.lbl_fightStatus.width > _loc1_))
         {
            _loc1_ = this.lbl_fightStatus.width;
         }
         return _loc1_;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this._timerHide.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.uiApi.hideTooltip(this.uiApi.me().name);
      }
      
      public function unload() : void
      {
         if(this._timerHide)
         {
            this._timerHide.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timerHide.stop();
            this._timerHide = null;
         }
      }
   }
}
