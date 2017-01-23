package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.BindsApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import enum.EnumTab;
   
   public class SpellBase
   {
      
      private static var _shortcutColor:String;
       
      
      public var bindsApi:BindsApi;
      
      public var soundApi:SoundApi;
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      private var _currentTabUi:String = "";
      
      private var _currentParams:Object;
      
      public var uiCtr:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var btn_tabSpell:ButtonContainer;
      
      public var btn_tabElementarySpell:ButtonContainer;
      
      public var btn_tabFinishMove:ButtonContainer;
      
      public function SpellBase()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.btn_close.soundId = SoundEnum.CANCEL_BUTTON;
         this.soundApi.playSound(SoundTypeEnum.GRIMOIRE_OPEN);
         this.btn_tabSpell.soundId = SoundEnum.TAB;
         this.btn_tabElementarySpell.soundId = SoundEnum.TAB;
         this.btn_tabFinishMove.soundId = SoundEnum.TAB;
         this.uiApi.addComponentHook(this.btn_tabSpell,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabSpell,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tabSpell,"onRollOut");
         this.uiApi.addComponentHook(this.btn_tabElementarySpell,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabElementarySpell,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tabElementarySpell,"onRollOut");
         this.uiApi.addComponentHook(this.btn_tabFinishMove,"onRelease");
         this.uiApi.addComponentHook(this.btn_tabFinishMove,"onRollOver");
         this.uiApi.addComponentHook(this.btn_tabFinishMove,"onRollOut");
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         if(param1 != null)
         {
            this.openTab(param1[0],param1[1],param1[1],this.uiApi.me().restoreSnapshotAfterLoading);
         }
      }
      
      public function unload() : void
      {
         this.uiApi.hideTooltip();
         if(this.soundApi)
         {
            this.soundApi.playSound(SoundTypeEnum.CLOSE_WINDOW);
         }
         this.closeTab(this._currentTabUi);
      }
      
      public function getTab() : String
      {
         return this._currentTabUi;
      }
      
      public function openTab(param1:String = "", param2:int = 0, param3:Object = null, param4:Boolean = true) : void
      {
         if(param1 != "" && this._currentTabUi == param1 && (!param3 || !param3.hasOwnProperty("variantsList") || this._currentParams.variantsList == param3.variantsList))
         {
            this.closeSpellBase();
            return;
         }
         if(this._currentTabUi != "")
         {
            this.uiApi.unloadUi("subSpellUi");
         }
         if(param1 == "")
         {
            this._currentTabUi = EnumTab.SPELLSLIST_TAB;
            param3 = {"variantsList":true};
         }
         else
         {
            this._currentTabUi = param1;
         }
         this.uiCtr.getUi().restoreSnapshotAfterLoading = param4;
         this._currentParams = param3;
         this.uiApi.loadUiInside(this._currentTabUi,this.uiCtr,"subSpellUi",param3);
      }
      
      private function getButtonByTab(param1:String) : Object
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case EnumTab.SPELLSLIST_TAB:
               _loc2_ = this.btn_tabSpell;
               break;
            case EnumTab.FINISHMOVES_TAB:
               _loc2_ = this.btn_tabFinishMove;
         }
         return _loc2_;
      }
      
      private function closeTab(param1:String) : void
      {
         this.uiApi.unloadUi("subSpellUi");
      }
      
      private function closeSpellBase() : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.closeSpellBase();
               break;
            case this.btn_tabSpell:
               this.openTab(EnumTab.SPELLSLIST_TAB,0,{"variantsList":true});
               break;
            case this.btn_tabElementarySpell:
               this.openTab(EnumTab.SPELLSLIST_TAB,0,{"variantsList":false});
               break;
            case this.btn_tabFinishMove:
               this.openTab(EnumTab.FINISHMOVES_TAB);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.closeSpellBase();
               return true;
            default:
               return false;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
   }
}
