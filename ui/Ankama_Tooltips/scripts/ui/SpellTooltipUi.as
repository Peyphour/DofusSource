package ui
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.datacenter.spells.SpellPair;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import d2enums.SpellShapeEnum;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import makers.SpellTooltipMaker;
   
   public class SpellTooltipUi extends TooltipPinableBaseUi
   {
      
      protected static var MARGIN:int;
       
      
      public var tooltipApi:TooltipApi;
      
      private var _skip:Boolean = true;
      
      private var _timerHide:Timer;
      
      private var _timerDisplay:Timer;
      
      private var _spell;
      
      public var lbl_content:Label;
      
      public var tx_icon:Texture;
      
      public var tx_spellZoneIcon:Texture;
      
      public function SpellTooltipUi()
      {
         super();
      }
      
      override public function main(param1:Object = null) : void
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         MARGIN = this.lbl_content.x;
         var _loc2_:Object = uiApi.me();
         this._spell = param1.data;
         var _loc3_:String = "tooltip_item";
         var _loc4_:String = sysApi.getActiveFontType();
         if(_loc4_ && _loc4_ != "default")
         {
            _loc3_ = _loc3_ + ("-" + _loc4_);
         }
         uiApi.setLabelStyleSheet(this.lbl_content,sysApi.getConfigEntry("config.ui.skin") + "css/" + _loc3_ + ".css");
         this.lbl_content.multiline = true;
         this.lbl_content.text = param1.tooltip.htmlText;
         if(!(param1.data is SpellPair))
         {
            if(this.tx_icon)
            {
               this.tx_icon.uri = param1.data.iconUri;
            }
            _loc5_ = this.getSpellZoneIconUri();
            if(_loc5_)
            {
               this.tx_spellZoneIcon.uri = _loc5_;
               if(param1.makerParam && param1.makerParam.hasOwnProperty("CC_EC") && !param1.makerParam.CC_EC || this._spell.spellLevelInfos.criticalHitProbability == 0)
               {
                  this.tx_spellZoneIcon.y = parseInt(uiApi.me().getConstant("spellZoneIconNoCriticalY"));
               }
               else
               {
                  this.tx_spellZoneIcon.y = parseInt(uiApi.me().getConstant("spellZoneIconY"));
               }
            }
            else if(this.tx_spellZoneIcon)
            {
               this.tx_spellZoneIcon.visible = false;
            }
         }
         if(param1.makerParam && param1.makerParam.hasOwnProperty("width"))
         {
            this.lbl_content.width = param1.makerParam.width;
         }
         if(param1.autoHide)
         {
            this._timerHide = new Timer(2500);
            this._timerHide.addEventListener(TimerEvent.TIMER,this.onTimer);
            this._timerHide.start();
         }
         if(SpellTooltipMaker.SPELL_TAB_MODE)
         {
            SpellTooltipMaker.SPELL_TAB_MODE = false;
            if(uiApi.getUi("spellTab"))
            {
               uiApi.getUi("spellTab").getElement("toolTipContainer").addContent(_loc2_);
            }
            else if(uiApi.getUi("companionTab"))
            {
               uiApi.getUi("companionTab").getElement("ctr_spellTooltip").addContent(_loc2_);
            }
         }
         if(uiApi.me().height > uiApi.getStageHeight() && param1.makerParam && param1.makerParam.description)
         {
            _loc6_ = param1.tooltip.htmlText;
            _loc7_ = _loc6_.indexOf("<p class=\'description\'>" + 17);
            _loc8_ = _loc6_.indexOf("</p>",_loc7_);
            _loc6_ = _loc6_.replace(this._spell.description,"[" + String.fromCharCode(8230) + "]");
            this.lbl_content.text = _loc6_;
         }
         if(backgroundCtr)
         {
            backgroundCtr.height = this.lbl_content.contentHeight + MARGIN * 2;
         }
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset);
         super.main(param1);
         if((!param1 || !param1.makerParam || !param1.makerParam.hasOwnProperty("pinnable") || !param1.makerParam.pinnable) && !isPin)
         {
            _loc9_ = sysApi.getOption("spellTooltipDelay","dofus");
            if(_loc9_ > 0)
            {
               mainCtr.visible = false;
               this._timerDisplay = new Timer(_loc9_);
               this._timerDisplay.addEventListener(TimerEvent.TIMER,this.onTimerDisplay);
               this._timerDisplay.start();
            }
            else if(_loc9_ == -1)
            {
               uiApi.unloadUi(_loc2_.name);
               return;
            }
         }
      }
      
      protected function onTimerDisplay(param1:TimerEvent) : void
      {
         this._timerDisplay.removeEventListener(TimerEvent.TIMER,this.onTimerDisplay);
         mainCtr.visible = true;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this._timerHide.removeEventListener(TimerEvent.TIMER,this.onTimer);
         uiApi.hideTooltip(uiApi.me().name);
      }
      
      public function unload() : void
      {
         if(this._timerDisplay)
         {
            this._timerDisplay.removeEventListener(TimerEvent.TIMER,this.onTimerDisplay);
            this._timerDisplay.stop();
            this._timerDisplay = null;
         }
         if(this._timerHide)
         {
            this._timerHide.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timerHide.stop();
            this._timerHide = null;
         }
      }
      
      private function getSpellZoneIconUri() : Object
      {
         var _loc3_:Object = null;
         var _loc4_:* = null;
         if(!this._spell || !this._spell.hasOwnProperty("spellZoneEffects") || !this._spell.spellZoneEffects || !this._spell.spellZoneEffects.length || !this._spell.spellZoneEffects[0])
         {
            return null;
         }
         var _loc1_:Object = this._spell.spellZoneEffects[0];
         var _loc2_:uint = _loc1_.zoneSize;
         for each(_loc3_ in this._spell.spellZoneEffects)
         {
            if(_loc3_.zoneShape != 0 && _loc3_.zoneSize < 63 && (_loc3_.zoneSize > _loc2_ || _loc3_.zoneSize == _loc2_ && _loc1_.zoneShape == SpellShapeEnum.P))
            {
               _loc2_ = _loc3_.zoneSize;
               _loc1_ = _loc3_;
            }
         }
         switch(_loc1_.zoneShape)
         {
            case SpellShapeEnum.minus:
               _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|diagonal";
               break;
            case SpellShapeEnum.A:
            case SpellShapeEnum.a:
               _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|everyone";
               break;
            case SpellShapeEnum.C:
               if(_loc1_.zoneSize == 63)
               {
                  _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|everyone";
               }
               else
               {
                  _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|circle";
               }
               break;
            case SpellShapeEnum.D:
               _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|checkerboard";
               break;
            case SpellShapeEnum.L:
               _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|line";
               break;
            case SpellShapeEnum.O:
               _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|ring";
               break;
            case SpellShapeEnum.Q:
               _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|cross2";
               break;
            case SpellShapeEnum.T:
               _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|line2";
               break;
            case SpellShapeEnum.U:
               _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|alfcircle";
               break;
            case SpellShapeEnum.V:
               _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|cone";
               break;
            case SpellShapeEnum.X:
               _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|cross";
               break;
            case SpellShapeEnum.G:
               _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|square";
               break;
            case SpellShapeEnum.plus:
               _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|plus";
               break;
            case SpellShapeEnum.star:
               _loc4_ = sysApi.getConfigEntry("config.content.path") + "gfx/characteristics/spellAreas.swf|star";
               break;
            case SpellShapeEnum.P:
         }
         if(_loc4_)
         {
            return uiApi.createUri(_loc4_);
         }
         return null;
      }
   }
}
