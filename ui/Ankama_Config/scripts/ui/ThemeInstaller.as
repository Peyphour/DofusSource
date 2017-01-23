package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.InputComboBox;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.ThemeDeleteRequest;
   import d2actions.ThemeInstallRequest;
   import d2actions.ThemeListRequest;
   import d2enums.BuildTypeEnum;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2hooks.FocusChange;
   import d2hooks.KeyDown;
   import d2hooks.KeyUp;
   import d2hooks.ThemeInstallationError;
   import d2hooks.ThemeInstallationProgress;
   import d2hooks.ThemeList;
   import flash.utils.Dictionary;
   
   public class ThemeInstaller
   {
      
      private static const URL_REGEX:RegExp = /^http(s)?:\/\/((\d+\.\d+\.\d+\.\d+)|(([\w-]+\.)+([a-z,A-Z][\w-]*)))(:[1-9][0-9]*)?(\/([\w-.\/:%+@&=]+[\w- .\/?:%+@&=]*)?)?(#(.*))?$/i;
      
      private static const WHITESPACE_TRIM_REGEX:RegExp = /^\s*(.*?)\s*$/g;
      
      private static const ERROR_JSON_URL_INVALID:int = 1;
      
      private static const ERROR_JSON_NOT_FOUND:int = 2;
      
      private static const ERROR_THEME_ARCHIVE_INVALID:int = 3;
      
      private static const ERROR_THEME_UPATE:int = 4;
      
      private static const ERROR_THEME_DELETE:int = 5;
      
      private static const ERROR_THEME_INSTALL:int = 6;
      
      private static const ERROR_THEME_DM_NOT_FOUND:int = 7;
      
      private static const ERROR_THEME_URL_INVALID:int = 8;
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var lbl_infos:Label;
      
      public var lbl_currentUrl:Label;
      
      public var icbx_url:InputComboBox;
      
      public var tx_help:TextureBitmap;
      
      public var ctn_help_tooltip:GraphicContainer;
      
      public var inp_filter:Input;
      
      public var btn_closeSearch:ButtonContainer;
      
      public var btn_label_cb_version:Label;
      
      public var cb_version:ButtonContainer;
      
      public var mainCtr:GraphicContainer;
      
      public var ctr_more_info:GraphicContainer;
      
      public var btn_close:ButtonContainer;
      
      public var lbl_title:Label;
      
      public var gdModules:Grid;
      
      public var tx_bg:Texture;
      
      public var tx_bg1:Texture;
      
      public var tx_inputUrl:Texture;
      
      public var btn_fetch:ButtonContainer;
      
      public var cbx_categories:ComboBox;
      
      private var _themeList:Array;
      
      private var _keyWords:Array;
      
      private var _lastSelection:int;
      
      private var _activePopupName:String;
      
      private var _isUpdating:Boolean;
      
      private var _searchCriteria:String = "";
      
      private var _componentsList:Dictionary;
      
      private var _popupText:String;
      
      public function ThemeInstaller()
      {
         this._componentsList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addHook(ThemeList,this.onThemeList);
         this.sysApi.addHook(ThemeInstallationProgress,this.onThemeInstallationProgress);
         this.sysApi.addHook(ThemeInstallationError,this.onThemeInstallationError);
         this.uiApi.addComponentHook(this.tx_help,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_help,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.inp_filter,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ctr_more_info,ComponentHookList.ON_RELEASE);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.sysApi.addHook(KeyDown,this.onKeyDown);
         this.sysApi.addHook(FocusChange,this.onFocusChange);
         this.ctn_help_tooltip.visible = false;
         this.inp_filter.text = this.uiApi.getText("ui.common.search.input");
         this.btn_closeSearch.visible = false;
         this.btn_label_cb_version.text = this.uiApi.getText("ui.option.compatibility") + " : " + this.sysApi.getCurrentVersion().major + "." + this.sysApi.getCurrentVersion().minor;
         var _loc2_:Array = this.sysApi.getData("lastThemeListUrls",DataStoreEnum.BIND_COMPUTER);
         if(_loc2_ && _loc2_.length > 0)
         {
            this.icbx_url.input.text = _loc2_[0];
            this.icbx_url.dataProvider = _loc2_;
            this.onRelease(this.btn_fetch);
         }
         else
         {
            this.icbx_url.input.text = "http://";
         }
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               if(this.icbx_url.input.haveFocus)
               {
                  this.onRelease(this.btn_fetch);
                  return true;
               }
               break;
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
         }
         return false;
      }
      
      public function updateUrlLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:String = !!param2.hasOwnProperty("btn_removeUrl")?"":"2";
         if(!this._componentsList[param2["btn_removeUrl" + _loc4_].name])
         {
            this.uiApi.addComponentHook(param2["btn_removeUrl" + _loc4_],"onRelease");
            this.uiApi.addComponentHook(param2["btn_removeUrl" + _loc4_],"onRollOut");
            this.uiApi.addComponentHook(param2["btn_removeUrl" + _loc4_],"onRollOver");
         }
         this._componentsList[param2["btn_removeUrl" + _loc4_].name] = param1;
         if(param1)
         {
            param2["lbl_url" + _loc4_].text = param1;
            param2["btn_removeUrl" + _loc4_].visible = true;
            if(param3)
            {
               param2["btn_url" + _loc4_].selected = true;
            }
            else
            {
               param2["btn_url" + _loc4_].selected = false;
            }
         }
         else
         {
            param2["lbl_url" + _loc4_].text = "";
            param2["btn_removeUrl" + _loc4_].visible = false;
            param2["btn_url" + _loc4_].selected = false;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.cb_version:
               this.applyFilter();
               break;
            case this.ctr_more_info:
               this.sysApi.goToUrl(this.uiApi.getText("ui.link.themes.moreInfo"));
               break;
            case this.btn_fetch:
               _loc2_ = this.icbx_url.input.text;
               this._themeList = [];
               this._keyWords = [];
               this.gdModules.dataProvider = [];
               this.cbx_categories.dataProvider = [];
               this.cb_version.selected = false;
               this.inp_filter.text = this.uiApi.getText("ui.common.search.input");
               this.btn_closeSearch.visible = false;
               if(URL_REGEX.test(_loc2_))
               {
                  if(_loc2_.search("zip") == _loc2_.length - 3)
                  {
                     this.startInstall({
                        "url":_loc2_,
                        "name":_loc2_
                     });
                  }
                  else
                  {
                     _loc3_ = [];
                     _loc4_ = this.icbx_url.dataProvider;
                     _loc5_ = true;
                     for each(_loc6_ in _loc4_)
                     {
                        if(_loc6_ == _loc2_)
                        {
                           _loc5_ = false;
                        }
                        _loc3_.push(_loc6_);
                     }
                     if(_loc5_)
                     {
                        _loc3_.unshift(_loc2_);
                     }
                     this.icbx_url.dataProvider = _loc3_;
                     this.sysApi.setData("lastThemeListUrls",_loc3_,DataStoreEnum.BIND_COMPUTER);
                     this.sysApi.sendAction(new ThemeListRequest(_loc2_));
                  }
               }
               else if(this.sysApi.getBuildType() == BuildTypeEnum.DEBUG)
               {
                  if(_loc2_.search("zip") == _loc2_.length - 3)
                  {
                     this.startInstall({
                        "url":"file://" + _loc2_,
                        "name":_loc2_
                     });
                  }
                  else
                  {
                     this.sysApi.sendAction(new ThemeListRequest("file://" + _loc2_));
                  }
               }
               break;
            case this.btn_closeSearch:
               this.inp_filter.text = this.uiApi.getText("ui.common.search.input");
               this.btn_closeSearch.visible = false;
               this._searchCriteria = "";
               this.applyFilter();
               break;
            case this.inp_filter:
               if(this.uiApi.getText("ui.common.search.input") == this.inp_filter.text)
               {
                  this.inp_filter.text = "";
               }
               break;
            default:
               if(param1.name.indexOf("btn_removeUrl") != -1)
               {
                  _loc7_ = this._componentsList[param1.name];
                  _loc8_ = this.sysApi.getData("lastThemeListUrls");
                  _loc9_ = new Array();
                  for each(_loc6_ in _loc8_)
                  {
                     if(_loc6_ != _loc7_)
                     {
                        _loc9_.push(_loc6_);
                     }
                  }
                  this.sysApi.setData("lastThemeListUrls",_loc9_);
                  this.icbx_url.dataProvider = _loc9_;
                  this.icbx_url.selectedIndex = 0;
               }
         }
         if(param1 != this.inp_filter && this.inp_filter && this.inp_filter.text.length == 0)
         {
            this.inp_filter.text = this.uiApi.getText("ui.common.search.input");
            this.btn_closeSearch.visible = false;
            this.gdModules.dataProvider = this._themeList;
         }
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this.inp_filter.haveFocus)
         {
            this._searchCriteria = this.inp_filter.text.toLowerCase();
            if(!this._searchCriteria || !this._searchCriteria.length)
            {
               this._searchCriteria = "";
               this.btn_closeSearch.visible = false;
               this.gdModules.dataProvider = this._themeList;
            }
            else
            {
               this.btn_closeSearch.visible = true;
               this.applyFilter();
            }
         }
      }
      
      public function onKeyDown(param1:Object, param2:uint) : void
      {
         if(!this.inp_filter.haveFocus)
         {
         }
      }
      
      public function onFocusChange(param1:Object) : void
      {
      }
      
      public function onRollOver(param1:Object) : void
      {
         switch(param1)
         {
            case this.tx_help:
               this.ctn_help_tooltip.visible = true;
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         switch(param1)
         {
            case this.tx_help:
               this.ctn_help_tooltip.visible = false;
         }
         this.uiApi.hideTooltip();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         switch(param1)
         {
            case this.cbx_categories:
               this.applyFilter();
         }
      }
      
      public function startInstall(param1:Object, param2:Boolean = false) : void
      {
         this._isUpdating = param2;
         if(this._isUpdating)
         {
            this._popupText = this.uiApi.getText("ui.module.marketplace.updatemodulemsg",param1.name,param1.version) + "\n" + this.uiApi.getText("ui.queue.wait");
         }
         else
         {
            this._popupText = this.uiApi.getText("ui.module.marketplace.installmodulemsg",param1.name) + "\n" + this.uiApi.getText("ui.queue.wait");
         }
         this._activePopupName = this.modCommon.openNoButtonPopup(this.uiApi.getText("ui.theme.updatetheme"),this._popupText);
         this.sysApi.sendAction(new ThemeInstallRequest(param1.url));
      }
      
      public function startUninstall(param1:Object) : void
      {
         this._activePopupName = this.modCommon.openNoButtonPopup(this.uiApi.getText("ui.module.marketplace.uninstallmodule"),this.uiApi.getText("ui.module.marketplace.uninstallmodulemsg",param1.name) + "\n" + this.uiApi.getText("ui.queue.wait"));
         this.sysApi.sendAction(new ThemeDeleteRequest(param1.author + "_" + param1.name));
         this._lastSelection = this.gdModules.selectedIndex;
      }
      
      public function onThemeList(param1:*) : void
      {
         this.updateThemeList(param1);
      }
      
      public function onThemeInstallationProgress(param1:Number) : void
      {
         var _loc2_:* = undefined;
         if(param1 == 1 || param1 == -1)
         {
            this.uiApi.unloadUi(this._activePopupName);
            if(this.icbx_url.input.text.toLowerCase().search("zip") != this.icbx_url.input.text.length - 3)
            {
               this.onRelease(this.btn_fetch);
            }
         }
         else
         {
            _loc2_ = this.uiApi.getUi(this._activePopupName);
            if(_loc2_ && _loc2_.uiClass)
            {
               _loc2_.uiClass.content = this._popupText + Math.ceil(param1 * 100) + "%";
            }
         }
      }
      
      public function onThemeInstallationError(param1:int) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = this.uiApi.getText("ui.common.error");
         switch(param1)
         {
            case ERROR_JSON_URL_INVALID:
               this.sysApi.setData("lastThemeListUrl","",DataStoreEnum.BIND_COMPUTER);
               _loc3_ = this.uiApi.getText("ui.module.marketplace.error.invalidurl");
               this.updateThemeList([]);
               break;
            case ERROR_JSON_NOT_FOUND:
               this.sysApi.setData("lastThemeListUrl","",DataStoreEnum.BIND_COMPUTER);
               _loc3_ = this.uiApi.getText("ui.module.marketplace.error.missingjson");
               this.updateThemeList([]);
               break;
            case ERROR_THEME_ARCHIVE_INVALID:
               _loc3_ = this.uiApi.getText("ui.theme.error.invalidzip");
               this.uiApi.unloadUi(this._activePopupName);
               break;
            case ERROR_THEME_UPATE:
               _loc3_ = this.uiApi.getText("ui.theme.error.update");
               this.uiApi.unloadUi(this._activePopupName);
               break;
            case ERROR_THEME_DELETE:
               _loc3_ = this.uiApi.getText("ui.theme.error.uninstall");
               this.uiApi.unloadUi(this._activePopupName);
               break;
            case ERROR_THEME_INSTALL:
               _loc3_ = this.uiApi.getText("ui.theme.error.install");
               this.uiApi.unloadUi(this._activePopupName);
               break;
            case ERROR_THEME_URL_INVALID:
               _loc3_ = this.uiApi.getText("ui.theme.error.invalidurl2");
               this.uiApi.unloadUi(this._activePopupName);
               break;
            default:
               _loc3_ = this.uiApi.getText("ui.module.marketplace.error");
         }
         this.modCommon.openPopup(_loc2_,_loc3_,[this.uiApi.getText("ui.common.ok")]);
      }
      
      private function applyFilter() : void
      {
         var _loc1_:Array = null;
         if(this._themeList && this._themeList.length)
         {
            _loc1_ = this._themeList.filter(this.filterFunction);
            if(this.cbx_categories.selectedIndex != 0)
            {
               _loc1_ = _loc1_.filter(this.filterKeyWord);
            }
            this.gdModules.dataProvider = _loc1_;
         }
      }
      
      private function filterFunction(param1:*, param2:int, param3:Array) : Boolean
      {
         var _loc4_:Array = null;
         if(this.cb_version.selected)
         {
            _loc4_ = param1.dofusVersion.split(".");
            if(!_loc4_ || _loc4_.length < 2 || this.sysApi.getCurrentVersion().major != _loc4_[0] || this.sysApi.getCurrentVersion().minor != _loc4_[1])
            {
               return false;
            }
         }
         if(this._searchCriteria == "")
         {
            return true;
         }
         return param1.name.toLowerCase().indexOf(this._searchCriteria) >= 0 || param1.author.toLowerCase().indexOf(this._searchCriteria) >= 0;
      }
      
      private function filterKeyWord(param1:*, param2:int, param3:Array) : Boolean
      {
         var _loc5_:String = null;
         var _loc4_:Array = param1.keyWords.split(",");
         for each(_loc5_ in _loc4_)
         {
            if(this.cbx_categories.selectedItem == _loc5_.replace(WHITESPACE_TRIM_REGEX,"$1"))
            {
               return true;
            }
         }
         return false;
      }
      
      private function updateThemeList(param1:*) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:* = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         this._keyWords = new Array();
         this._themeList = new Array();
         for each(_loc2_ in param1)
         {
            _loc3_ = new Object();
            this._themeList.push(_loc3_);
            for(_loc4_ in _loc2_)
            {
               _loc3_[_loc4_] = _loc2_[_loc4_];
            }
            _loc5_ = new Array();
            if(_loc3_["keyWords"])
            {
               _loc5_ = _loc3_.keyWords.split(",");
            }
            for each(_loc6_ in _loc5_)
            {
               _loc6_ = _loc6_.replace(WHITESPACE_TRIM_REGEX,"$1");
               if(this._keyWords.indexOf(_loc6_) == -1)
               {
                  this._keyWords.push(_loc6_);
               }
            }
         }
         if(this._themeList.length == 0)
         {
            this.gdModules.visible = false;
            this.lbl_infos.visible = true;
            this.lbl_infos.text = this.uiApi.getText("ui.module.marketplace.nomodule");
            return;
         }
         this.lbl_infos.visible = false;
         this.gdModules.visible = true;
         this._themeList.sortOn(["dofusVersion","name"],[Array.DESCENDING,Array.CASEINSENSITIVE]);
         this.gdModules.dataProvider = this._themeList;
         this.gdModules.selectedIndex = this._lastSelection;
         this._keyWords.sort();
         this._keyWords.unshift(this.uiApi.getText("ui.common.allTypesForObject"));
         this.cbx_categories.dataProvider = this._keyWords;
         this.cbx_categories.selectedIndex = 0;
         this.cbx_categories.visible = this._themeList.length > 0;
         this.cbx_categories.selectedIndex = 0;
      }
   }
}
