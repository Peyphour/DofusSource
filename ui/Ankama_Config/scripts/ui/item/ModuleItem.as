package ui.item
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import d2enums.ComponentHookList;
   
   public class ModuleItem
   {
      
      private static var lastSelectedTexture:Texture;
      
      private static var currentlySelectedData:Object;
       
      
      public var uiApi:UiApi;
      
      public var mainCtr:GraphicContainer;
      
      public var lbl_name:Label;
      
      public var lbl_lastUpdate:Label;
      
      public var btn_install:ButtonContainer;
      
      public var btn_delete:ButtonContainer;
      
      public var btn_update:ButtonContainer;
      
      public var tx_bg:Texture;
      
      public var tx_selected:Texture;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _data:Object;
      
      private var _selected:Boolean;
      
      private var _uiClass:Object;
      
      public function ModuleItem()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this._data = param1.data;
         this._selected = param1.selected;
         this._uiClass = param1.grid.getUi().uiClass;
         this.update(this._data,this._selected);
         this.uiApi.addComponentHook(this.mainCtr,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.mainCtr,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.mainCtr,ComponentHookList.ON_RELEASE);
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
         this._data = param1;
         if(param1)
         {
            this.lbl_name.text = param1.name + " (" + param1.author + ")";
            this.lbl_lastUpdate.text = param1.lastUpdateDate;
            this.btn_delete.visible = param1.exist;
            this.btn_install.visible = !param1.exist;
            this.btn_update.visible = !this.btn_install.visible && !param1.upToDate;
            this.tx_bg.visible = param1.exist;
            this.tx_bg.bgColor = !!param1.upToDate?6074716:14633259;
         }
         else
         {
            this.lbl_name.text = "";
            this.lbl_lastUpdate.text = "";
            this.btn_delete.visible = false;
            this.btn_install.visible = false;
            this.btn_update.visible = false;
            this.tx_bg.visible = false;
         }
         this.tx_selected.visible = param2;
         lastSelectedTexture = this.tx_selected;
      }
      
      public function onRelease(param1:Object) : void
      {
         if(this._data && currentlySelectedData != this._data)
         {
            this._uiClass.showModuleDetails(this._data);
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
         switch(param1)
         {
            case this.mainCtr:
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         switch(param1)
         {
            case this.mainCtr:
         }
      }
      
      public function select(param1:Boolean) : void
      {
      }
   }
}
