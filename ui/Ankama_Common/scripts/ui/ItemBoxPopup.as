package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.ShowObjectLinked;
   
   public class ItemBoxPopup
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _item:Object;
      
      public var ctr_item:GraphicContainer;
      
      public var btn_close_popup:ButtonContainer;
      
      public function ItemBoxPopup()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.sysApi.addHook(ShowObjectLinked,this.onShowObjectLinked);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         if(param1.hasOwnProperty("ownedItem"))
         {
            this.updateItemBox(param1.item,param1.ownedItem);
         }
         else
         {
            this.updateItemBox(param1.item);
         }
      }
      
      public function unload() : void
      {
         this.uiApi.unloadUi("itemBoxPop");
      }
      
      private function updateItemBox(param1:Object = null, param2:Boolean = false) : void
      {
         if(param1 != this._item)
         {
            this.modCommon.createItemBox("itemBoxPop",this.ctr_item,param1,false,param2);
            this._item = param1;
         }
         else
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      private function onShowObjectLinked(param1:Object = null) : void
      {
         this.updateItemBox(param1);
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close_popup:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case ShortcutHookListEnum.CLOSE_UI:
            case ShortcutHookListEnum.VALID_UI:
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
   }
}
