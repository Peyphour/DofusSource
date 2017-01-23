package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.ScrollContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import options.OptionManager;
   
   public class OptionContainer
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var soundApi:SoundApi;
      
      public var ctr_subUi:ScrollContainer;
      
      public var lbl_subTitle:Label;
      
      public var lbl_subDescription:Label;
      
      public var btn_default:ButtonContainer;
      
      public var btn_close2:ButtonContainer;
      
      public var gd_optionCategories:Grid;
      
      public var btn_close:ButtonContainer;
      
      private var _subUi:Object;
      
      private var _currentSubUiId:String;
      
      public function OptionContainer()
      {
         super();
      }
      
      public function main(param1:String) : void
      {
         var _loc2_:OptionManager = null;
         var _loc3_:uint = 0;
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this.gd_optionCategories.autoSelectMode = 0;
         this.gd_optionCategories.dataProvider = OptionManager.getInstance().items;
         this.btn_default.soundId = SoundEnum.SPEC_BUTTON;
         this.btn_close2.soundId = SoundEnum.CANCEL_BUTTON;
         this.uiApi.addComponentHook(this.gd_optionCategories,"onSelectItem");
         this.uiApi.addComponentHook(this.btn_default,"onRelease");
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
         this.uiApi.addComponentHook(this.btn_close2,"onRelease");
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.ctr_subUi.verticalScrollSpeed = 4;
         if(param1)
         {
            _loc2_ = OptionManager.getInstance();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.items.length)
            {
               if(_loc2_.items[_loc3_].id == param1)
               {
                  this.gd_optionCategories.selectedIndex = _loc3_;
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = this.gd_optionCategories.selectedItem;
         if(this._currentSubUiId == _loc4_.ui)
         {
            return;
         }
         this.lbl_subTitle.text = _loc4_.name;
         this.lbl_subDescription.text = _loc4_.description;
         if(this._subUi)
         {
            this.uiApi.unloadUi(this._subUi.name);
         }
         if(_loc4_.ui)
         {
            this.ctr_subUi.verticalScrollbarValue = 0;
            this.btn_default.visible = true;
            this._subUi = this.uiApi.loadUiInside(_loc4_.ui,this.ctr_subUi,"subConfigUi",null);
            this._currentSubUiId = _loc4_.ui;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_default:
               if(this._subUi && Object(this._subUi.uiClass).hasOwnProperty("reset"))
               {
                  this._subUi.uiClass.reset();
               }
               break;
            case this.btn_close:
            case this.btn_close2:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function unload() : void
      {
         if(this._subUi)
         {
            this.uiApi.hideTooltip();
            this.soundApi.playSound(SoundTypeEnum.CLOSE_WINDOW);
            this.uiApi.unloadUi(this._subUi.name);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "optionMenu1":
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
         return true;
      }
      
      public function onPopupClose() : void
      {
      }
      
      public function onSelectiveClearCache() : void
      {
         this.sysApi.clearCache(true);
      }
      
      public function onCompleteClearCache() : void
      {
         this.sysApi.clearCache(false);
      }
   }
}
