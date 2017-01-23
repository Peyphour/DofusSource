package ui.behavior
{
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import ui.AbstractStorageUi;
   import ui.StorageUi;
   import ui.enum.StorageState;
   
   public class TokenStoneShopBehavior implements IStorageBehavior
   {
       
      
      private var _storage:StorageUi;
      
      public function TokenStoneShopBehavior()
      {
         super();
      }
      
      public function filterStatus(param1:Boolean) : void
      {
      }
      
      public function dropValidator(param1:Object, param2:Object, param3:Object) : Boolean
      {
         return false;
      }
      
      public function processDrop(param1:Object, param2:Object, param3:Object) : void
      {
      }
      
      public function onValidQtyDrop(param1:Number) : void
      {
      }
      
      public function onValidQty(param1:Number) : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
      }
      
      public function attach(param1:AbstractStorageUi) : void
      {
         if(!(param1 is StorageUi))
         {
            throw new Error("Can\'t attach a BidHouseBehavior to a non StorageUi storage");
         }
         this._storage = param1 as StorageUi;
         this._storage.setDropAllowed(false,"behavior");
         this._storage.btn_moveAllToRight.visible = false;
         this._storage.ignoreSubFilterInMain = true;
         this._storage.saveCategory = false;
         this._storage.categoryFilter = AbstractStorageUi.RESSOURCES_CATEGORY;
         this._storage.subFilter = AbstractStorageUi.SUBFILTER_ID_PRECIOUS_STONE;
         this._storage.saveCategory = true;
      }
      
      public function detach() : void
      {
         this._storage.setDropAllowed(true,"behavior");
         this._storage.btn_moveAllToRight.visible = true;
         Api.ui.unloadUi(UIEnum.NPC_STOCK);
      }
      
      public function onUnload() : void
      {
      }
      
      public function getStorageUiName() : String
      {
         return UIEnum.STORAGE_UI;
      }
      
      public function getName() : String
      {
         return StorageState.TOKEN_STONE_SHOP_MOD;
      }
      
      public function get replacable() : Boolean
      {
         return false;
      }
      
      public function transfertAll() : void
      {
      }
      
      public function transfertList() : void
      {
      }
      
      public function transfertExisting() : void
      {
      }
   }
}
