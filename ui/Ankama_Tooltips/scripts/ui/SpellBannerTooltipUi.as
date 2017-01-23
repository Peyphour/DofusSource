package ui
{
   import com.ankamagames.dofus.modules.utils.SpellTooltipSettings;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2enums.DataStoreEnum;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class SpellBannerTooltipUi extends TooltipPinableBaseUi
   {
      
      private static var _shortcutColor:String;
       
      
      public var tooltipApi:TooltipApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var lbl_content:Object;
      
      private var _spellWrapper:Object;
      
      private var _shortcutKey:String;
      
      private var _timerShowSpellTooltip:Timer;
      
      public function SpellBannerTooltipUi()
      {
         super();
      }
      
      override public function main(param1:Object = null) : void
      {
         if(!_shortcutColor)
         {
            _shortcutColor = sysApi.getConfigEntry("colors.shortcut");
            _shortcutColor = _shortcutColor.replace("0x","#");
         }
         this._spellWrapper = param1.data.spellWrapper;
         this._shortcutKey = param1.data.shortcutKey;
         this.lbl_content.text = this._spellWrapper.name;
         if(this._shortcutKey && this._shortcutKey != "")
         {
            this.lbl_content.text = this.lbl_content.text + (" <font color=\'" + _shortcutColor + "\'>(" + this._shortcutKey + ")</font>");
         }
         this.lbl_content.multiline = false;
         this.lbl_content.wordWrap = false;
         this.lbl_content.fullWidth();
         backgroundCtr.width = this.lbl_content.textfield.width + 12;
         this.tooltipApi.place(param1.position,param1.point,param1.relativePoint,param1.offset);
         var _loc2_:int = sysApi.getOption("largeTooltipDelay","dofus");
         this._timerShowSpellTooltip = new Timer(_loc2_,1);
         this._timerShowSpellTooltip.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._timerShowSpellTooltip.start();
         super.main(param1);
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _loc2_:String = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         if(this._timerShowSpellTooltip)
         {
            this._timerShowSpellTooltip.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timerShowSpellTooltip.stop();
            this._timerShowSpellTooltip = null;
         }
         var _loc3_:int = this._spellWrapper.playerCriticalFailureRate;
         if(this._spellWrapper.isSpellWeapon)
         {
            _loc8_ = this.playerApi.getWeapon();
            if(_loc8_)
            {
               _loc2_ = "SpellBanner-" + this._spellWrapper.id + "#" + this.tooltipApi.getSpellTooltipCache() + "," + this._shortcutKey + "," + this._spellWrapper.playerCriticalRate + "," + _loc3_ + "," + _loc8_.objectUID + "," + _loc8_.setCount + "," + this._spellWrapper.versionNum;
            }
            else
            {
               _loc2_ = "SpellBanner-" + this._spellWrapper.id + "#-" + this._shortcutKey + "," + this._shortcutKey + "," + this._spellWrapper.playerCriticalRate + "," + _loc3_ + "," + this._spellWrapper.versionNum;
            }
         }
         else
         {
            _loc2_ = "SpellBanner-" + this._spellWrapper.id + "," + this._spellWrapper.spellLevel + "#" + this.tooltipApi.getSpellTooltipCache() + "," + this._spellWrapper.playerCriticalRate + "," + this._spellWrapper.maximalRangeWithBoosts + "," + this._shortcutKey + "," + _loc3_ + "," + this._spellWrapper.versionNum;
         }
         var _loc4_:SpellTooltipSettings = sysApi.getData("spellTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as SpellTooltipSettings;
         if(!_loc4_)
         {
            _loc4_ = this.tooltipApi.createSpellSettings();
            sysApi.setData("spellTooltipSettings",_loc4_,DataStoreEnum.BIND_ACCOUNT);
         }
         var _loc5_:Object = new Object();
         for each(_loc6_ in sysApi.getObjectVariables(_loc4_))
         {
            if(_loc6_ == "header")
            {
               _loc5_["name"] = _loc4_[_loc6_];
            }
            else
            {
               _loc5_[_loc6_] = _loc4_[_loc6_];
            }
         }
         _loc5_.smallSpell = true;
         _loc5_.contextual = true;
         _loc5_.noBg = false;
         _loc5_.shortcutKey = this._shortcutKey;
         _loc7_ = uiApi.getUi(UIEnum.BANNER).getElement(!!sysApi.isFightContext()?"tooltipFightPlacer":"tooltipRoleplayPlacer");
         uiApi.showTooltip(this._spellWrapper,_loc7_,false,"spellBanner",8,2,3,null,null,_loc5_,_loc2_);
         uiApi.hideTooltip(uiApi.me().name);
      }
      
      public function unload() : void
      {
         if(this._timerShowSpellTooltip)
         {
            this._timerShowSpellTooltip.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._timerShowSpellTooltip.stop();
            this._timerShowSpellTooltip = null;
         }
      }
   }
}
