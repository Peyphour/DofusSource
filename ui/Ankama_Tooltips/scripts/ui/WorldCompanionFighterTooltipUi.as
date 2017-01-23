package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import utils.TooltipUtil;
   
   public class WorldCompanionFighterTooltipUi
   {
       
      
      private var _timerHide:Timer;
      
      public var tooltipApi:TooltipApi;
      
      public var uiApi:UiApi;
      
      public var chatApi:ChatApi;
      
      public var dataApi:DataApi;
      
      private var _inPrefight:Boolean;
      
      private var _showName:Boolean;
      
      private var _icons:Vector.<Texture>;
      
      public var lbl_text:Object;
      
      public var lbl_title:Object;
      
      public var lbl_damage:Label;
      
      public var lbl_fightStatus:Label;
      
      public var backgroundCtr:Object;
      
      public var mainCtr:GraphicContainer;
      
      public function WorldCompanionFighterTooltipUi()
      {
         this._icons = new Vector.<Texture>(0);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this._showName = param1.makerParam && param1.makerParam.hasOwnProperty("showName")?Boolean(param1.makerParam.showName):true;
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
         var _loc6_:Texture = null;
         var _loc7_:Number = NaN;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc10_:* = null;
         this._inPrefight = Api.fight.preFightIsActive();
         if(this._inPrefight)
         {
            this.lbl_text.text = Api.fight.getFighterName(param1.data.contextualId);
            this.lbl_title.text = Api.ui.getText("ui.common.level") + " " + Api.fight.getFighterLevel(param1.data.contextualId);
         }
         else
         {
            this.lbl_title.text = "";
            if(param1.data.stats.shieldPoints > 0)
            {
               this.lbl_text.text = "";
               this.lbl_text.appendText((!!this._showName?Api.fight.getFighterName(param1.data.contextualId) + " ":"") + "(" + param1.data.stats.lifePoints + "+");
               this.lbl_text.appendText(param1.data.stats.shieldPoints,"shield");
               this.lbl_text.appendText(")","p");
            }
            else
            {
               this.lbl_text.text = (!!this._showName?Api.fight.getFighterName(param1.data.contextualId) + " ":"") + "(" + param1.data.stats.lifePoints + ")";
            }
         }
         this.lbl_text.fullWidth();
         this.lbl_title.fullWidth();
         this.lbl_title.y = 20;
         var _loc3_:int = (this.lbl_title.width - this.lbl_text.width) / 2;
         if(_loc3_ < 0)
         {
            _loc3_ = _loc3_ * -1;
            this.lbl_title.x = _loc3_;
            this.lbl_text.x = 0;
         }
         else
         {
            this.lbl_title.x = 0;
            this.lbl_text.x = _loc3_;
         }
         if(!param2)
         {
            _loc7_ = this.getMaxLabelWidth();
            if(this.lbl_text.width == _loc7_)
            {
               this.backgroundCtr.width = _loc7_ + 12;
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
         var _loc4_:Number = this.getMaxLabelWidth();
         var _loc5_:Number = 0;
         for each(_loc6_ in this._icons)
         {
            _loc6_.remove();
         }
         this._icons.length = 0;
         this.lbl_fightStatus.width = 1;
         this.lbl_fightStatus.removeFromParent();
         if(param1.makerParam && param1.makerParam.fightStatus)
         {
            this.mainCtr.addContent(this.lbl_fightStatus);
            this.lbl_fightStatus.y = this.lbl_text.y + 20;
            _loc8_ = this.chatApi.getChatColors();
            _loc9_ = this.dataApi.getSpellState(param1.makerParam.fightStatus).name;
            _loc10_ = "<font color=\"#" + _loc8_[10].toString(16) + "\">" + _loc9_ + "</font>";
            this.lbl_fightStatus.appendText(_loc10_);
            this.lbl_fightStatus.fullWidth();
            _loc4_ = this.getMaxLabelWidth();
            this.lbl_text.x = _loc4_ / 2 - this.lbl_text.width / 2;
            this.lbl_fightStatus.x = _loc4_ / 2 - this.lbl_fightStatus.width / 2;
            this.backgroundCtr.height = this.backgroundCtr.height + this.lbl_fightStatus.height;
         }
         this.lbl_damage.width = 1;
         this.lbl_damage.removeFromParent();
         if(param1.makerParam && param1.makerParam.spellDamage)
         {
            this.mainCtr.addContent(this.lbl_damage);
            this.lbl_damage.y = !param1.makerParam.fightStatus?Number(this.lbl_text.y + 20):Number(this.lbl_fightStatus.y + 20);
            this.lbl_damage.appendText(param1.makerParam.spellDamage);
            this.lbl_damage.fullWidth();
            _loc5_ = TooltipUtil.showDamagePreviewIcons(this.lbl_damage,this.getMaxLabelWidth(),param1.makerParam.spellDamage.effectIcons,this._icons,this.mainCtr);
            _loc4_ = this.getMaxLabelWidth();
            this.lbl_text.x = _loc4_ / 2 - this.lbl_text.width / 2 + _loc5_;
            this.lbl_damage.x = _loc4_ / 2 - this.lbl_damage.width / 2 + _loc5_;
            this.backgroundCtr.height = this.backgroundCtr.height + this.lbl_damage.height;
         }
         this.backgroundCtr.width = _loc4_ + 12 + _loc5_;
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
