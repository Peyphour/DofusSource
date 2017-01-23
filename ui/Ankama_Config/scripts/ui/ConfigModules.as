package ui
{
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import d2actions.InstalledModuleListRequest;
   import d2actions.ModuleDeleteRequest;
   import d2actions.ResetGame;
   import d2enums.ComponentHookList;
   import d2enums.SelectMethodEnum;
   import d2enums.StrataEnum;
   import d2hooks.InstalledModuleList;
   import d2hooks.ModuleInstallationProgress;
   import flash.utils.Dictionary;
   import types.ConfigProperty;
   
   public class ConfigModules extends ConfigUi
   {
       
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _modules:Array;
      
      private var _modulesBtnList:Dictionary;
      
      private var _lastCheckBoxClicked:ButtonContainer;
      
      private var _activePopupName:String;
      
      private var _moduleBeingDeleted:Object;
      
      public var gd_modules:Grid;
      
      public var btn_hideAnkamaModules:ButtonContainer;
      
      public var btn_marketplace:ButtonContainer;
      
      public function ConfigModules()
      {
         this._modulesBtnList = new Dictionary(true);
         super();
      }
      
      public function main(param1:*) : void
      {
         uiApi.addComponentHook(this.gd_modules,"onItemRollOver");
         uiApi.addComponentHook(this.gd_modules,"onItemRollOut");
         uiApi.addComponentHook(this.gd_modules,ComponentHookList.ON_SELECT_ITEM);
         uiApi.addComponentHook(this.btn_hideAnkamaModules,ComponentHookList.ON_RELEASE);
         sysApi.toggleModuleInstaller();
         sysApi.addHook(ModuleInstallationProgress,this.onModuleInstallationProgress);
         sysApi.addHook(InstalledModuleList,this.onInstalledModuleList);
         this.btn_hideAnkamaModules.selected = true;
         var _loc2_:Array = new Array();
         _loc2_.push(new ConfigProperty("grid_theme","currentUiSkin","dofus"));
         init(_loc2_);
         this.updateDataProvider();
         showDefaultBtn(false);
      }
      
      public function unload() : void
      {
         sysApi.toggleModuleInstaller();
         this._modules = null;
         this._lastCheckBoxClicked = null;
      }
      
      public function update() : void
      {
         this.updateDataProvider();
      }
      
      public function updateModuleLine(param1:*, param2:*, param3:Boolean) : void
      {
         var data:* = param1;
         var componentsRef:* = param2;
         var selected:Boolean = param3;
         if(!this._modulesBtnList[componentsRef.btn_activate.name])
         {
            uiApi.addComponentHook(componentsRef.btn_activate,"onRelease");
            uiApi.addComponentHook(componentsRef.btn_delete,"onRelease");
         }
         this._modulesBtnList[componentsRef.btn_activate.name] = data;
         if(data)
         {
            componentsRef.btn_module.selected = selected;
            componentsRef.btn_module.softDisabled = false;
            if(data.trusted)
            {
               componentsRef.lbl_author.cssClass = "p0right";
            }
            else
            {
               componentsRef.lbl_author.cssClass = "right";
            }
            componentsRef.btn_delete.visible = !data.trusted;
            componentsRef.btn_activate.visible = true;
            componentsRef.btn_activate.disabled = data.trusted && data.enable;
            if(!data.name)
            {
               componentsRef.lbl_name.text = data.id;
            }
            else
            {
               componentsRef.lbl_name.text = data.name;
            }
            componentsRef.lbl_author.text = data.author;
            if(data.shortDescription && data.shortDescription.indexOf("ui.module.") == 0)
            {
               componentsRef.lbl_shortDesc.text = uiApi.getText(data.shortDescription);
            }
            else
            {
               componentsRef.lbl_shortDesc.text = data.shortDescription;
            }
            try
            {
               if(data.iconUri && data.iconUri.path)
               {
                  componentsRef.tx_icon.uri = data.iconUri;
               }
               else
               {
                  componentsRef.tx_icon.uri = null;
               }
            }
            catch(error:Error)
            {
               componentsRef.tx_icon.uri = null;
            }
            componentsRef.btn_activate.selected = data.enable;
         }
         else
         {
            componentsRef.lbl_name.text = "";
            componentsRef.lbl_author.text = "";
            componentsRef.lbl_shortDesc.text = "";
            componentsRef.tx_icon.uri = null;
            componentsRef.btn_activate.selected = false;
            componentsRef.btn_activate.visible = false;
            componentsRef.btn_module.selected = false;
            componentsRef.btn_module.softDisabled = true;
            componentsRef.btn_delete.visible = false;
         }
      }
      
      private function updateDataProvider() : void
      {
         var _loc3_:UiModule = null;
         sysApi.sendAction(new InstalledModuleListRequest());
      }
      
      private function onDeleteOk() : void
      {
         this._activePopupName = this.modCommon.openNoButtonPopup(uiApi.getText("ui.module.marketplace.uninstallmodule"),uiApi.getText("ui.module.marketplace.uninstallmodulemsg",this._moduleBeingDeleted.name) + "\n" + uiApi.getText("ui.queue.wait"));
         uiApi.setModuleEnable(this._moduleBeingDeleted.id,false);
         sysApi.sendAction(new ModuleDeleteRequest(this._moduleBeingDeleted.id));
      }
      
      private function onRestartOk() : void
      {
         sysApi.sendAction(new ResetGame());
      }
      
      private function onModuleInstallationProgress(param1:Number) : void
      {
         if(param1 == -1)
         {
            uiApi.unloadUi(this._activePopupName);
            this.updateDataProvider();
         }
      }
      
      private function onInstalledModuleList(param1:*) : void
      {
         var _loc5_:Boolean = false;
         var _loc6_:* = undefined;
         var _loc2_:* = !this.btn_hideAnkamaModules.selected;
         var _loc3_:XML = new XML(param1);
         var _loc4_:Array = new Array();
         for each(_loc6_ in _loc3_.children())
         {
            _loc5_ = _loc6_.isTrusted.toString() == "true"?true:false;
            if(_loc2_ || !_loc5_)
            {
               _loc4_.push({
                  "name":_loc6_.name.toString(),
                  "author":_loc6_.author.toString(),
                  "id":_loc6_.author.toString() + "_" + _loc6_.name.toString(),
                  "trusted":_loc5_,
                  "enable":(_loc6_.isEnabled.toString() == "true"?true:false),
                  "shortDescription":_loc6_.shortDescription.toString(),
                  "iconUri":uiApi.createUri(_loc6_.iconUri.toString()),
                  "description":_loc6_.description.toString(),
                  "version":_loc6_.version.toString(),
                  "dofusVersion":_loc6_.dofusVersion.toString()
               });
            }
         }
         this.gd_modules.dataProvider = _loc4_;
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_marketplace:
               uiApi.loadUi("moduleMarketplace",null,{},StrataEnum.STRATA_TOP);
               break;
            case this.btn_hideAnkamaModules:
               this.updateDataProvider();
               break;
            default:
               if(param1.name.indexOf("btn_activate") != -1)
               {
                  this._lastCheckBoxClicked = param1 as ButtonContainer;
                  if(!param1.selected)
                  {
                     uiApi.setModuleEnable(this._modulesBtnList[param1.name].id,true);
                     if(sysApi.isInGame())
                     {
                        this.modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.module.marketplace.reboot"),[uiApi.getText("ui.common.yes"),uiApi.getText("ui.common.no")],[this.onRestartOk]);
                     }
                  }
                  else
                  {
                     uiApi.setModuleEnable(this._modulesBtnList[param1.name].id,false);
                  }
                  this.updateDataProvider();
               }
               else if(param1.name.indexOf("btn_delete") != -1)
               {
                  this._lastCheckBoxClicked = param1 as ButtonContainer;
                  this._moduleBeingDeleted = this._modulesBtnList[param1.name.replace("btn_delete","btn_activate")];
                  this.modCommon.openPopup(uiApi.getText("ui.module.marketplace.uninstallmodule"),uiApi.getText("ui.module.marketplace.uninstallmodulewarning",this._moduleBeingDeleted.name),[uiApi.getText("ui.common.ok"),uiApi.getText("ui.common.cancel")],[this.onDeleteOk]);
               }
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:* = null;
         if(param2.data && param2.data.description)
         {
            _loc3_ = "";
            if(param2.data.version)
            {
               _loc3_ = "v " + param2.data.version + "\n";
            }
            if(param2.data.description.indexOf("ui.module.") == 0)
            {
               _loc3_ = _loc3_ + uiApi.getText(param2.data.description);
            }
            else
            {
               _loc3_ = _loc3_ + param2.data.description;
            }
            uiApi.showTooltip(uiApi.textTooltipInfo(_loc3_),param2.container,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         uiApi.hideTooltip();
      }
      
      public function onRollOver(param1:Object) : void
      {
         uiApi.showTooltip(uiApi.textTooltipInfo(uiApi.getText("ui.option.modulesSwitch")),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         uiApi.hideTooltip();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param2 == SelectMethodEnum.AUTO || !param3)
         {
            return;
         }
         if(this._lastCheckBoxClicked)
         {
            this._lastCheckBoxClicked = null;
            return;
         }
         uiApi.loadUi("moduleInfo",null,{
            "module":Grid(param1).selectedItem,
            "details":null,
            "visibleBtns":false,
            "activationCallback":null,
            "isUpdate":false
         },StrataEnum.STRATA_TOP);
      }
   }
}
