package ui
{
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import d2actions.ThemeDeleteRequest;
   import d2enums.BuildTypeEnum;
   import d2enums.ComponentHookList;
   import d2enums.StatesEnum;
   import d2enums.StrataEnum;
   import d2hooks.ThemeInstallationProgress;
   import flash.utils.Dictionary;
   import types.ConfigProperty;
   
   public class ConfigTheme extends ConfigUi
   {
       
      
      public var output:Object;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _themes:Array;
      
      private var _choosenTheme:String;
      
      private var _choosenThemeObj;
      
      private var _selectedThemeId:String;
      
      private var _themeBtnList:Dictionary;
      
      private var _officialIconUri;
      
      public var grid_theme:Grid;
      
      public var lbl_name:Label;
      
      public var lbl_themeVersion:Label;
      
      public var lbl_author:Label;
      
      public var lbl_description:TextArea;
      
      public var tx_preview:Texture;
      
      public var btn_installTheme:ButtonContainer;
      
      public var btn_applyTheme:ButtonContainer;
      
      public var btn_deleteTheme:ButtonContainer;
      
      public var lbl_versionCompatibility:Label;
      
      public function ConfigTheme()
      {
         this._themeBtnList = new Dictionary(true);
         super();
      }
      
      public function main(param1:*) : void
      {
         var _loc2_:* = sysApi.getConfigEntry("config.ui.common.themes") + "darkStone/texture/tx_logo_ankama.png";
         this._officialIconUri = uiApi.createUri(_loc2_);
         uiApi.addComponentHook(this.btn_deleteTheme,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btn_deleteTheme,ComponentHookList.ON_ROLL_OUT);
         sysApi.addHook(ThemeInstallationProgress,this.onThemeInstallationProgress);
         sysApi.toggleThemeInstaller();
         var _loc3_:Array = new Array();
         _loc3_.push(new ConfigProperty("grid_theme","currentUiSkin","dofus"));
         init(_loc3_);
         this.onThemeInstallationProgress(1);
         showDefaultBtn(false);
      }
      
      public function onThemeInstallationProgress(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:uint = 0;
         if(param1 == 1 || param1 == -1)
         {
            this._selectedThemeId = configApi.getCurrentTheme();
            this._themes = new Array();
            _loc2_ = -1;
            for each(_loc3_ in configApi.getAllThemes())
            {
               if(_loc3_ && (_loc3_.type == 1 || sysApi.getBuildType() != BuildTypeEnum.RELEASE && sysApi.getConfigEntry("config.dev.mode")))
               {
                  this._themes.push(_loc3_);
               }
            }
            this._themes.sortOn(["type","official","name"],[Array.DESCENDING | Array.NUMERIC,Array.DESCENDING | Array.NUMERIC,Array.NUMERIC]);
            _loc4_ = 0;
            for each(_loc3_ in this._themes)
            {
               if(_loc3_.fileName == this._selectedThemeId)
               {
                  _loc2_ = _loc4_;
                  break;
               }
               _loc4_++;
            }
            if(_loc2_ < 0)
            {
               for each(_loc3_ in this._themes)
               {
                  if(_loc3_.official && _loc3_.type > 0)
                  {
                     this._choosenTheme = _loc3_.fileName;
                     this._choosenThemeObj = _loc3_;
                     break;
                  }
               }
               this.modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.option.resetGameForNewSkin"),[uiApi.getText("ui.common.ok")],[this.onConfirmChangeTheme]);
            }
            this.grid_theme.dataProvider = this._themes;
            this.grid_theme.selectedIndex = _loc2_;
         }
      }
      
      public function unload() : void
      {
         sysApi.toggleThemeInstaller();
      }
      
      private function saveOptions() : void
      {
      }
      
      private function undoOptions() : void
      {
      }
      
      private function displayTheme(param1:*) : void
      {
         var _loc4_:* = undefined;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:String = param1.description;
         if(_loc2_.indexOf("[") != -1 && _loc2_.indexOf("]") != -1)
         {
            _loc2_ = uiApi.getText(_loc2_.slice(1,-1));
         }
         this.lbl_description.text = _loc2_;
         var _loc3_:String = param1.name;
         if(_loc3_.indexOf("[") != -1 && _loc3_.indexOf("]") != -1)
         {
            _loc3_ = uiApi.getText(_loc3_.slice(1,-1));
         }
         this.lbl_name.text = _loc3_;
         this.lbl_themeVersion.text = param1.version[0] + "." + param1.version[1] + "." + param1.version[2];
         this.lbl_themeVersion.visible = !param1.official;
         if(param1.creationDate && param1.modificationDate && param1.author)
         {
            this.lbl_author.text = uiApi.getText("ui.theme.authoranddate",param1.creationDate,param1.author,param1.modificationDate);
         }
         else
         {
            this.lbl_author.text = param1.author;
            if(param1.modificationDate)
            {
               this.lbl_author.text = this.lbl_author.text + (" - " + uiApi.getText("ui.prism.lastVulnerabilityChange",param1.modificationDate));
            }
         }
         if(param1.official)
         {
            this.lbl_versionCompatibility.visible = false;
         }
         else
         {
            this.lbl_versionCompatibility.visible = true;
            this.lbl_versionCompatibility.text = uiApi.getText("ui.option.compatibility") + uiApi.getText("ui.common.colon") + param1.dofusVersion[0] + "." + param1.dofusVersion[1];
            _loc4_ = param1.dofusVersion;
            if(_loc4_ && _loc4_.length >= 0 && _loc4_[0] == sysApi.getCurrentVersion().major && _loc4_[1] == sysApi.getCurrentVersion().minor)
            {
               this.lbl_versionCompatibility.cssClass = "bonus";
            }
            else
            {
               this.lbl_versionCompatibility.cssClass = "malus";
            }
         }
         if(param1.previewUri != "")
         {
            this.tx_preview.uri = param1.previewRealUri;
         }
         else
         {
            this.tx_preview.uri = null;
         }
         if(param1.fileName != this._selectedThemeId && param1.type == 1)
         {
            this.btn_applyTheme.disabled = false;
         }
         else
         {
            this.btn_applyTheme.disabled = true;
         }
         if(param1.official)
         {
            this.btn_deleteTheme.visible = false;
         }
         else
         {
            this.btn_deleteTheme.visible = true;
            this.btn_deleteTheme.softDisabled = this._selectedThemeId == param1.fileName;
         }
      }
      
      public function updateThemeLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:String = null;
         if(param1)
         {
            param2.btn_theme.visible = true;
            param2.btn_theme.selected = param3;
            param2.btn_theme.state = !!param3?StatesEnum.STATE_SELECTED:StatesEnum.STATE_NORMAL;
            _loc4_ = param1;
            _loc5_ = _loc4_.name;
            if(_loc5_.indexOf("[") != -1 && _loc5_.indexOf("]") != -1)
            {
               _loc5_ = uiApi.getText(_loc5_.slice(1,-1));
            }
            param2.lbl_name.text = _loc5_;
            param2.tx_selected.visible = this._selectedThemeId == _loc4_.fileName;
            if(param1.type != 1)
            {
               param2.lbl_name.softDisabled = true;
            }
            else
            {
               param2.lbl_name.softDisabled = false;
            }
            param2.tx_official.visible = _loc4_.official;
            if(param2.tx_official.visible && !param2.tx_official.uri)
            {
               param2.tx_official.uri = this._officialIconUri;
            }
         }
         else
         {
            param2.lbl_name.text = "";
            param2.btn_theme.visible = false;
            param2.tx_selected.visible = false;
            param2.tx_official.visible = false;
            param2.tx_official.uri = null;
         }
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_installTheme:
               if(uiApi.getUi("themeInstaller"))
               {
                  uiApi.unloadUi("themeInstaller");
               }
               uiApi.loadUi("themeInstaller",null,{},StrataEnum.STRATA_TOP);
               break;
            case this.btn_deleteTheme:
               this._choosenTheme = this.grid_theme.selectedItem.folderFullPath;
               this.modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.module.marketplace.uninstallmodulewarning",this.grid_theme.selectedItem.name),[uiApi.getText("ui.common.yes"),uiApi.getText("ui.common.no")],[this.onConfirmDeleteTheme,null]);
               break;
            case this.btn_applyTheme:
               this._choosenTheme = this.grid_theme.selectedItem.folderFullPath;
               this._choosenThemeObj = this.grid_theme.selectedItem;
               this.modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.option.resetGameForNewSkin"),[uiApi.getText("ui.common.yes"),uiApi.getText("ui.common.no")],[this.onConfirmChangeTheme,null]);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         switch(param1)
         {
            case this.grid_theme:
               this.displayTheme(this.grid_theme.selectedItem);
         }
      }
      
      public function onConfirmChangeTheme() : void
      {
         setProperty("dofus","currentUiSkin",!!this._choosenThemeObj.official?this._choosenThemeObj.name:this._choosenTheme);
         sysApi.reset();
      }
      
      public function onConfirmDeleteTheme() : void
      {
         sysApi.sendAction(new ThemeDeleteRequest(this._choosenTheme));
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 == this.btn_deleteTheme)
         {
            if(this.btn_deleteTheme.softDisabled)
            {
               _loc2_ = uiApi.getText("ui.theme.marketplace.removeTip");
            }
         }
         else
         {
            _loc2_ = uiApi.getText("ui.option.themeApply");
         }
         if(_loc2_)
         {
            uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         uiApi.hideTooltip();
      }
   }
}
