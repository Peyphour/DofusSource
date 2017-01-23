package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.InputComboBox;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.ModuleDeleteRequest;
   import d2actions.ModuleInstallRequest;
   import d2actions.ModuleListRequest;
   import d2actions.ResetGame;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.StrataEnum;
   import d2hooks.ApisHooksActionsList;
   import d2hooks.KeyUp;
   import d2hooks.ModuleInstallationError;
   import d2hooks.ModuleInstallationProgress;
   import d2hooks.ModuleList;
   import flash.utils.Dictionary;
   
   public class ModuleMarketplace
   {
      
      private static const ERROR_JSON_URL_INVALID:int = 1;
      
      private static const ERROR_JSON_NOT_FOUND:int = 2;
      
      private static const ERROR_MODULE_ARCHIVE_INVALID:int = 3;
      
      private static const ERROR_MODULE_UPATE:int = 4;
      
      private static const ERROR_MODULE_DELETE:int = 5;
      
      private static const ERROR_MODULE_INSTALL:int = 6;
      
      private static const ERROR_MODULE_DM_NOT_FOUND:int = 7;
      
      private static const ERROR_MODULE_URL_INVALID:int = 8;
      
      private static const URL_REGEX:RegExp = /^http(s)?:\/\/((\d+\.\d+\.\d+\.\d+)|(([\w-]+\.)+([a-z,A-Z][\w-]*)))(:[1-9][0-9]*)?(\/([\w-.\/:%+@&=]+[\w- .\/?:%+@&=]*)?)?(#(.*))?$/i;
      
      private static const WHITESPACE_TRIM_REGEX:RegExp = /^\s*(.*?)\s*$/g;
       
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var sysApi:SystemApi;
      
      public var utilApi:UtilApi;
      
      public var mainCtr:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var lbl_title:Label;
      
      public var icb_url:InputComboBox;
      
      public var gdModules:Grid;
      
      public var tx_bg:Texture;
      
      public var tx_bg1:Texture;
      
      public var tx_inputUrl:Texture;
      
      public var btn_fetch:ButtonContainer;
      
      public var cbx_categories:ComboBox;
      
      public var searchCtr:GraphicContainer;
      
      public var tx_search:Texture;
      
      public var input_search:Input;
      
      public var lbl_infos:Label;
      
      public var lbl_moduleName:Label;
      
      public var lbl_moduleAuthor:Label;
      
      public var lbl_moduleVersion:Label;
      
      public var lbl_moduleDofusVersion:Label;
      
      public var lbl_moduleCategory:Label;
      
      public var lbl_moduleDescription:Label;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _componentsList:Dictionary;
      
      private var _currentUrl:String;
      
      private var _activePopupName:String;
      
      private var _lastSelection:int;
      
      private var _activateModuleAfterInstall:Boolean;
      
      private var _isUpdating:Boolean;
      
      private var _moduleList:Array;
      
      private var _filteredModuleList:Array;
      
      private var _categories:Array;
      
      private var _lastSearchCriteria:String;
      
      public function ModuleMarketplace()
      {
         this._componentsList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.uiApi.addComponentHook(this.btn_fetch,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_fetch,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.icb_url,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.cbx_categories,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.sysApi.addHook(ModuleList,this.onModuleList);
         this.sysApi.addHook(ModuleInstallationProgress,this.onModuleInstallationProgress);
         this.sysApi.addHook(ModuleInstallationError,this.onModuleInstallationError);
         this.sysApi.addHook(ApisHooksActionsList,this.onApisHooksActionsList);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         var _loc2_:* = this.sysApi.getData("LastModuleDepotUrls",DataStoreEnum.BIND_ACCOUNT);
         if(_loc2_ && _loc2_.length > 0)
         {
            this.icb_url.input.text = _loc2_[0];
            this.icb_url.dataProvider = _loc2_;
            this.btn_fetch.focus();
         }
      }
      
      public function unload() : void
      {
         this._moduleList = null;
         this._categories = null;
         var _loc1_:Object = this.uiApi.getUi("subConfigUi");
         if(_loc1_ && _loc1_.uiClass)
         {
            _loc1_.uiClass.update();
         }
      }
      
      public function update() : void
      {
         this._lastSelection = this.gdModules.selectedIndex;
         this.sysApi.sendAction(new ModuleListRequest(this._currentUrl));
      }
      
      public function showModuleDetails(param1:Object) : void
      {
         this._lastSelection = this.gdModules.selectedIndex;
         if(param1)
         {
            this.lbl_moduleName.text = param1.name;
            this.lbl_moduleAuthor.text = param1.author;
            this.lbl_moduleVersion.text = this.uiApi.getText("ui.common.version") + this.uiApi.getText("ui.common.colon") + param1.version;
            this.lbl_moduleDofusVersion.text = this.uiApi.getText("ui.module.marketplace.dofusversion",param1.dofusVersion);
            if(param1.category && param1.category.indexOf(",") != -1)
            {
               this.lbl_moduleCategory.text = this.uiApi.getText("ui.common.categories") + this.uiApi.getText("ui.common.colon") + param1.category;
            }
            else
            {
               this.lbl_moduleCategory.text = this.uiApi.getText("ui.common.category") + this.uiApi.getText("ui.common.colon") + param1.category;
            }
            this.lbl_moduleDescription.text = this.uiApi.getText("ui.common.description") + this.uiApi.getText("ui.common.colon") + "\n" + param1.description;
         }
         else
         {
            this.lbl_moduleName.text = "";
            this.lbl_moduleAuthor.text = "";
            this.lbl_moduleVersion.text = "";
            this.lbl_moduleDofusVersion.text = "";
            this.lbl_moduleCategory.text = "";
            this.lbl_moduleDescription.text = "";
         }
      }
      
      public function startInstall(param1:Object, param2:Boolean = false) : void
      {
         this._isUpdating = param2;
         if(this._isUpdating)
         {
            this._activePopupName = this.modCommon.openNoButtonPopup(this.uiApi.getText("ui.module.marketplace.updatemodule"),this.uiApi.getText("ui.module.marketplace.updatemodulemsg",param1.name,param1.version) + "\n" + this.uiApi.getText("ui.queue.wait"));
         }
         else
         {
            this._activePopupName = this.modCommon.openNoButtonPopup(this.uiApi.getText("ui.module.marketplace.installmodule"),this.uiApi.getText("ui.module.marketplace.installmodulemsg",param1.name) + "\n" + this.uiApi.getText("ui.queue.wait"));
         }
         this.sysApi.sendAction(new ModuleInstallRequest(param1.url));
      }
      
      public function startUninstall(param1:Object) : void
      {
         this._activePopupName = this.modCommon.openNoButtonPopup(this.uiApi.getText("ui.module.marketplace.uninstallmodule"),this.uiApi.getText("ui.module.marketplace.uninstallmodulemsg",param1.name) + "\n" + this.uiApi.getText("ui.queue.wait"));
         this.uiApi.setModuleEnable(param1.id,false);
         this.sysApi.sendAction(new ModuleDeleteRequest(param1.id));
         this._lastSelection = this.gdModules.selectedIndex;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         var _loc5_:Vector.<String> = null;
         var _loc6_:String = null;
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_fetch:
               _loc2_ = this.icb_url.input.text;
               if(URL_REGEX.test(_loc2_))
               {
                  this.sysApi.sendAction(new ModuleListRequest(_loc2_));
               }
               else
               {
                  this.onModuleInstallationError(ERROR_JSON_URL_INVALID);
               }
               break;
            default:
               if(param1.name.indexOf("btn_removeUrl") != -1)
               {
                  _loc3_ = this._componentsList[param1.name];
                  _loc4_ = this.sysApi.getData("LastModuleDepotUrls",DataStoreEnum.BIND_ACCOUNT);
                  _loc5_ = new Vector.<String>();
                  for each(_loc6_ in _loc4_)
                  {
                     if(_loc6_ != _loc3_)
                     {
                        _loc5_.push(_loc6_);
                     }
                  }
                  this.sysApi.setData("LastModuleDepotUrls",_loc5_,DataStoreEnum.BIND_ACCOUNT);
                  this.icb_url.dataProvider = _loc5_;
                  this.icb_url.selectedIndex = 0;
               }
         }
      }
      
      public function updateUrlLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(!this._componentsList[param2.btn_removeUrl.name])
         {
            this.uiApi.addComponentHook(param2.btn_removeUrl,"onRelease");
            this.uiApi.addComponentHook(param2.btn_removeUrl,"onRollOut");
            this.uiApi.addComponentHook(param2.btn_removeUrl,"onRollOver");
         }
         this._componentsList[param2.btn_removeUrl.name] = param1;
         if(param1)
         {
            param2.lbl_url.text = param1;
            param2.btn_removeUrl.visible = true;
            param2.btn_url.selected = param3;
         }
         else
         {
            param2.lbl_url.text = "";
            param2.btn_removeUrl.visible = false;
            param2.btn_url.selected = false;
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         if(param3 && param1 == this.cbx_categories)
         {
            if(param1.selectedIndex > 0)
            {
               this._filteredModuleList = new Array();
               _loc4_ = param1.selectedItem;
               for each(_loc6_ in this._moduleList)
               {
                  if(_loc6_["category"])
                  {
                     _loc5_ = _loc6_.category;
                  }
                  else if(_loc6_["categories"])
                  {
                     _loc5_ = _loc6_.categories;
                  }
                  if(_loc5_.indexOf(_loc4_) != -1)
                  {
                     this._filteredModuleList.push(_loc6_);
                  }
               }
               this.gdModules.dataProvider = this._filteredModuleList;
            }
            else
            {
               this.gdModules.dataProvider = this._moduleList;
               this._filteredModuleList = null;
            }
            this.showModuleDetails(null);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case this.btn_fetch:
               _loc2_ = this.uiApi.getText("ui.module.marketplace.fetch");
               break;
            default:
               if(param1.name.indexOf("btn_removeUrl") != -1)
               {
                  _loc2_ = this.uiApi.getText("ui.module.marketplace.tooltip.uninstall");
                  this.icb_url.closeOnClick = false;
               }
         }
         if(_loc2_ && _loc2_.length > 1)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",6,1,0,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
         if(param1.name.indexOf("btn_removeUrl") != -1)
         {
            this.icb_url.closeOnClick = true;
         }
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this.searchCtr.visible && this.input_search.haveFocus)
         {
            this.filterModules(this.input_search.text.toLowerCase());
         }
      }
      
      public function onModuleList(param1:*) : void
      {
         this.updateModuleList(param1);
         this._currentUrl = this.icb_url.input.text;
         if(this.icb_url.dataProvider.indexOf(this._currentUrl) == -1)
         {
            this.icb_url.dataProvider.push(this._currentUrl);
         }
         this.sysApi.setData("LastModuleDepotUrls",this.icb_url.dataProvider,DataStoreEnum.BIND_ACCOUNT);
      }
      
      public function onModuleInstallationProgress(param1:Number) : void
      {
         if(param1 == 1 || param1 == -1)
         {
            this.uiApi.unloadUi(this._activePopupName);
            if(param1 == 1 && this._activateModuleAfterInstall)
            {
               this.uiApi.setModuleEnable(this.gdModules.selectedItem.id,true);
               if(this.sysApi.isInGame())
               {
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.module.marketplace.reboot"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onRestartOk]);
               }
            }
            this.sysApi.sendAction(new ModuleListRequest(this._currentUrl));
         }
      }
      
      public function onModuleInstallationError(param1:int) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = this.uiApi.getText("ui.common.error");
         switch(param1)
         {
            case ERROR_JSON_URL_INVALID:
               _loc3_ = this.uiApi.getText("ui.module.marketplace.error.invalidurl");
               this.updateModuleList([]);
               break;
            case ERROR_JSON_NOT_FOUND:
               _loc3_ = this.uiApi.getText("ui.module.marketplace.error.missingjson");
               this.updateModuleList([]);
               break;
            case ERROR_MODULE_ARCHIVE_INVALID:
               _loc3_ = this.uiApi.getText("ui.module.marketplace.error.invalidzip");
               this.uiApi.unloadUi(this._activePopupName);
               break;
            case ERROR_MODULE_UPATE:
               _loc3_ = this.uiApi.getText("ui.module.marketplace.error.update");
               this.uiApi.unloadUi(this._activePopupName);
               break;
            case ERROR_MODULE_DELETE:
               _loc3_ = this.uiApi.getText("ui.module.marketplace.error.uninstall");
               this.uiApi.unloadUi(this._activePopupName);
               break;
            case ERROR_MODULE_INSTALL:
               _loc3_ = this.uiApi.getText("ui.module.marketplace.error.install");
               this.uiApi.unloadUi(this._activePopupName);
               break;
            case ERROR_MODULE_URL_INVALID:
               _loc3_ = this.uiApi.getText("ui.module.marketplace.error.invalidurl2");
               this.uiApi.unloadUi(this._activePopupName);
               break;
            default:
               _loc3_ = this.uiApi.getText("ui.module.marketplace.error");
         }
         this.modCommon.openPopup(_loc2_,_loc3_,[this.uiApi.getText("ui.common.ok")]);
      }
      
      public function onApisHooksActionsList(param1:Object) : void
      {
         this.uiApi.loadUi("moduleInfo",null,{
            "module":this.gdModules.selectedItem,
            "details":param1,
            "visibleBtns":true,
            "activationCallback":this.activationCallbackFunction,
            "isUpdate":this._isUpdating
         },StrataEnum.STRATA_TOP);
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "optionMenu1":
            case "closeUi":
               if(!this.uiApi.getUi(this._activePopupName))
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
         }
         return true;
      }
      
      private function updateModuleList(param1:*) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:* = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         this.lbl_moduleName.text = "";
         this.lbl_moduleAuthor.text = "";
         this._categories = new Array();
         this._moduleList = new Array();
         for each(_loc2_ in param1)
         {
            _loc3_ = new Object();
            this._moduleList.push(_loc3_);
            for(_loc4_ in _loc2_)
            {
               _loc3_[_loc4_] = _loc2_[_loc4_];
            }
            _loc3_.id = _loc3_.author + "_" + _loc3_.name;
            if(_loc3_["category"] || _loc3_["categories"])
            {
               _loc5_ = _loc3_.category.split(",");
               for each(_loc6_ in _loc5_)
               {
                  _loc6_ = _loc6_.replace(WHITESPACE_TRIM_REGEX,"$1");
                  if(this._categories.indexOf(_loc6_) == -1)
                  {
                     this._categories.push(_loc6_);
                  }
               }
            }
         }
         if(this._moduleList.length == 0)
         {
            this.showModuleDetails(null);
            this.gdModules.visible = false;
            this.lbl_infos.visible = true;
            this.lbl_infos.text = this.uiApi.getText("ui.module.marketplace.nomodule");
            return;
         }
         this.lbl_infos.visible = false;
         this.gdModules.visible = true;
         this._moduleList.sortOn(["upToDate","exist","name"]);
         this.gdModules.dataProvider = this._moduleList;
         this.gdModules.selectedIndex = this._lastSelection;
         this.showModuleDetails(this.gdModules.selectedItem);
         this._categories.sort();
         this._categories.unshift(this.uiApi.getText("ui.common.allTypesForObject"));
         this.cbx_categories.dataProvider = this._categories;
         this.cbx_categories.selectedIndex = 0;
         this.cbx_categories.visible = this.searchCtr.visible = this._moduleList.length > 0;
         this.input_search.text = "";
      }
      
      private function activationCallbackFunction() : void
      {
         this._activateModuleAfterInstall = true;
      }
      
      private function onRestartOk() : void
      {
         this.sysApi.sendAction(new ResetGame());
      }
      
      private function filterModules(param1:String) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         if(param1)
         {
            _loc2_ = this._lastSearchCriteria && this._lastSearchCriteria.length < param1.length && param1.indexOf(this._lastSearchCriteria) != -1;
            _loc3_ = !!_loc2_?this.gdModules.dataProvider:!!this._filteredModuleList?this._filteredModuleList:this._moduleList;
            _loc4_ = new Array();
            for each(_loc5_ in _loc3_)
            {
               if(_loc5_.name.toLowerCase().indexOf(param1) != -1)
               {
                  _loc4_.push(_loc5_);
               }
            }
            this.gdModules.dataProvider = _loc4_;
            this._lastSearchCriteria = param1;
            this.showModuleDetails(null);
         }
         else
         {
            this.gdModules.dataProvider = !!this._filteredModuleList?this._filteredModuleList:this._moduleList;
            this.gdModules.selectedIndex = this._lastSelection;
            this.showModuleDetails(this.gdModules.selectedItem);
         }
      }
   }
}
