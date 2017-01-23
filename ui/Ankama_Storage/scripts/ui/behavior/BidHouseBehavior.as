package ui.behavior
{
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.LeaveShopStock;
   import d2actions.MountInfoRequest;
   import d2enums.SelectMethodEnum;
   import ui.AbstractStorageUi;
   import ui.StorageUi;
   import ui.enum.StorageState;
   
   public class BidHouseBehavior implements IStorageBehavior
   {
       
      
      private var _storage:StorageUi;
      
      private var _bidHouseFilter:Boolean = false;
      
      public function BidHouseBehavior()
      {
         super();
      }
      
      public function filterStatus(param1:Boolean) : void
      {
         Api.system.setData("filterBidHouseStorage",param1);
         this.refreshFilter();
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
      
      public function onRelease(param1:Object) : void
      {
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         switch(param1)
         {
            case this._storage.grid:
               _loc4_ = this._storage.grid.selectedItem;
               if(param2 == SelectMethodEnum.CLICK)
               {
                  Api.ui.getUi("itemBidHouseSell").uiClass.onSelectItemFromInventory(_loc4_);
               }
               else if(param2 == SelectMethodEnum.DOUBLE_CLICK)
               {
                  Api.ui.hideTooltip();
                  if(_loc4_ && _loc4_.category != 0 && _loc4_.hasOwnProperty("isCertificate") && _loc4_.isCertificate)
                  {
                     Api.system.sendAction(new MountInfoRequest(_loc4_));
                  }
               }
         }
      }
      
      public function attach(param1:AbstractStorageUi) : void
      {
         if(!(param1 is StorageUi))
         {
            throw new Error("Can\'t attach a BidHouseBehavior to a non StorageUi storage");
         }
         this._storage = param1 as StorageUi;
         Api.system.disableWorldInteraction();
         this._storage.questVisible = false;
         this._storage.setDropAllowed(false,"behavior");
         this._storage.btn_moveAllToLeft.visible = false;
         this._storage.showFilter(Api.ui.getText("ui.bidhouse.bigStoreFilter"),Api.system.getData("filterBidHouseStorage"));
         this.refreshFilter();
      }
      
      public function detach() : void
      {
         Api.system.enableWorldInteraction();
         Api.storage.disableBidHouseFilter();
         this._storage.questVisible = true;
         this._storage.setDropAllowed(true,"behavior");
         this._storage.hideFilter();
         this._storage.btn_moveAllToLeft.visible = true;
      }
      
      public function onUnload() : void
      {
         if(Api.ui.getUi(UIEnum.BIDHOUSE_STOCK) && !Api.ui.getUi(UIEnum.BIDHOUSE_STOCK).uiClass.isSwitching())
         {
            Api.system.sendAction(new LeaveShopStock());
            Api.ui.unloadUi(UIEnum.BIDHOUSE_STOCK);
         }
      }
      
      private function refreshFilter() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(this._storage.btn_itemsFilter.selected && Api.ui.getUi("itemBidHouseSell").uiClass)
         {
            _loc1_ = Api.ui.getUi("itemBidHouseSell");
            _loc2_ = _loc1_.uiClass;
            _loc3_ = _loc2_._sellerDescriptor;
            Api.storage.enableBidHouseFilter(_loc3_.types,_loc3_.maxItemLevel);
         }
         else
         {
            Api.storage.disableBidHouseFilter();
         }
         Api.storage.updateStorageView();
         Api.storage.releaseHooks();
      }
      
      public function getStorageUiName() : String
      {
         return UIEnum.STORAGE_UI;
      }
      
      public function getName() : String
      {
         return StorageState.BID_HOUSE_MOD;
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
