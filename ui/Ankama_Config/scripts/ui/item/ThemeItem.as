package ui.item
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.ComponentHookList;
   
   public class ThemeItem
   {
      
      private static var lastSelectedTexture:Texture;
      
      private static var currentlySelectedData:Object;
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var configApi:ConfigApi;
      
      public var mainCtr:GraphicContainer;
      
      public var lbl_name:Label;
      
      public var lbl_desc:Label;
      
      public var lbl_compatibility:Label;
      
      public var lbl_made:Label;
      
      public var lbl_themeVersion:Label;
      
      public var btn_install:ButtonContainer;
      
      public var btn_delete:ButtonContainer;
      
      public var btn_update:ButtonContainer;
      
      public var tx_bg:Texture;
      
      public var tx_selected:Texture;
      
      public var tx_previewUrl:Texture;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _data:Object;
      
      private var _selected:Boolean;
      
      private var _uiClass:Object;
      
      private var _upToDateColor:int;
      
      private var _notUpToDateColor:int;
      
      public function ThemeItem()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this._data = param1.data;
         this._selected = param1.selected;
         this._uiClass = param1.grid.getUi().uiClass;
         this.update(this._data,this._selected);
         this.uiApi.addComponentHook(this.mainCtr,ComponentHookList.ON_RELEASE);
         var _loc2_:* = this.uiApi.me().getConstant("upToDateColor");
         this._upToDateColor = int(_loc2_);
         this._notUpToDateColor = int(this.uiApi.me().getConstant("notUpToDateColor"));
      }
      
      public function unload() : void
      {
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function update(param1:Object, param2:Boolean) : void
      {
         var _loc3_:Array = null;
         this._data = param1;
         if(param1)
         {
            this.lbl_name.text = param1.name;
            this.lbl_desc.text = param1.description;
            this.lbl_compatibility.text = this.uiApi.getText("ui.option.compatibility") + " : " + param1.dofusVersion;
            _loc3_ = param1.dofusVersion.split(".");
            if(_loc3_ && _loc3_.length >= 0 && _loc3_[0] == this.sysApi.getCurrentVersion().major && _loc3_[1] == this.sysApi.getCurrentVersion().minor)
            {
               this.lbl_compatibility.cssClass = "bonus";
            }
            else
            {
               this.lbl_compatibility.cssClass = "malus";
            }
            this.lbl_themeVersion.text = param1.version;
            this.lbl_made.text = this.uiApi.getText("ui.theme.authoranddate",param1.creationDate,param1.author,param1.modificationDate);
            this.btn_delete.visible = param1.exist;
            this.btn_delete.softDisabled = this.configApi.getCurrentTheme() == param1.author + "_" + param1.name;
            this.uiApi.addComponentHook(this.btn_delete,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(this.btn_delete,ComponentHookList.ON_ROLL_OUT);
            this.btn_install.visible = !param1.exist;
            this.btn_update.visible = !this.btn_install.visible && !param1.upToDate;
            this.tx_bg.visible = param1.exist;
            this.tx_bg.bgColor = !!param1.upToDate?this._upToDateColor:this._notUpToDateColor;
            this.tx_previewUrl.visible = true;
            this.tx_previewUrl.uri = this.uiApi.createUri(param1.previewUrl);
         }
         else
         {
            this.lbl_name.text = "";
            this.lbl_desc.text = "";
            this.lbl_compatibility.text = "";
            this.lbl_made.text = "";
            this.lbl_themeVersion.text = "";
            this.btn_delete.visible = false;
            this.btn_install.visible = false;
            this.btn_update.visible = false;
            this.tx_bg.visible = false;
            this.tx_previewUrl.visible = false;
         }
         this.tx_selected.visible = param2;
         lastSelectedTexture = this.tx_selected;
      }
      
      public function onRelease(param1:Object) : void
      {
         if(this._data && currentlySelectedData != this._data)
         {
            if(lastSelectedTexture)
            {
               lastSelectedTexture.visible = false;
            }
            currentlySelectedData = this._data;
            this.tx_selected.visible = true;
            lastSelectedTexture = this.tx_selected;
         }
         switch(param1)
         {
            case this.btn_install:
               this._uiClass.startInstall(this._data);
               break;
            case this.btn_delete:
               this.modCommon.openPopup(this.uiApi.getText("ui.module.marketplace.uninstallmodule"),this.uiApi.getText("ui.module.marketplace.uninstallmodulewarning",this._data.name),[this.uiApi.getText("ui.common.ok"),this.uiApi.getText("ui.common.cancel")],[this.onDeleteOk]);
               break;
            case this.btn_update:
               this._uiClass.startInstall(this._data,true);
         }
      }
      
      private function onDeleteOk() : void
      {
         this._uiClass.startUninstall(this._data);
      }
      
      public function onRollOver(param1:Object) : void
      {
         if(param1 && param1.name.indexOf("btn_delete") != -1)
         {
            if(param1.softDisabled)
            {
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this.uiApi.getText("ui.theme.marketplace.removeTip")),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
            }
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function select(param1:Boolean) : void
      {
      }
   }
}
