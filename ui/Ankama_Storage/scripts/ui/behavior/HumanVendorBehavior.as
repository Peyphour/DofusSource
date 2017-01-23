package ui.behavior
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.ExchangeObjectMove;
   import d2actions.MountInfoRequest;
   import d2enums.SelectMethodEnum;
   import d2hooks.AskExchangeMoveObject;
   import d2hooks.ClickItemInventory;
   import ui.AbstractStorageUi;
   import ui.StorageUi;
   import ui.enum.StorageState;
   
   public class HumanVendorBehavior implements IStorageBehavior
   {
       
      
      private var _storage:StorageUi;
      
      private var _objectToExchange:Object;
      
      public function HumanVendorBehavior()
      {
         super();
      }
      
      public function filterStatus(param1:Boolean) : void
      {
      }
      
      public function dropValidator(param1:Object, param2:Object, param3:Object) : Boolean
      {
         if(param2 is ItemWrapper && this._storage.categoryFilter != AbstractStorageUi.QUEST_CATEGORY)
         {
            if(param2.position != 63)
            {
               return true;
            }
         }
         return false;
      }
      
      public function processDrop(param1:Object, param2:Object, param3:Object) : void
      {
         Api.system.dispatchHook(ClickItemInventory,param2);
      }
      
      public function onValidQtyDrop(param1:Number) : void
      {
      }
      
      private function onValidQty(param1:Number) : void
      {
         Api.system.dispatchHook(AskExchangeMoveObject,this._objectToExchange.objectUID,param1);
         Api.system.sendAction(new ExchangeObjectMove(this._objectToExchange.objectUID,param1));
      }
      
      public function onRelease(param1:Object) : void
      {
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Boolean = false;
         var _loc6_:* = undefined;
         switch(param1)
         {
            case this._storage.grid:
               _loc4_ = this._storage.grid.selectedItem;
               _loc5_ = true;
               if(_loc4_ is ItemWrapper)
               {
                  for each(_loc6_ in _loc4_.effects)
                  {
                     if(_loc6_.effectId == 982 || _loc6_.effectId == 983)
                     {
                        _loc5_ = false;
                     }
                  }
               }
               else
               {
                  _loc5_ = false;
               }
               switch(param2)
               {
                  case SelectMethodEnum.CLICK:
                     if(_loc5_)
                     {
                        Api.system.dispatchHook(ClickItemInventory,_loc4_);
                     }
                     else
                     {
                        Api.system.dispatchHook(ClickItemInventory,null);
                     }
                     break;
                  case SelectMethodEnum.DOUBLE_CLICK:
                     if(_loc5_)
                     {
                        Api.ui.hideTooltip();
                        if(_loc4_ && _loc4_.category != 0 && _loc4_.hasOwnProperty("isCertificate") && _loc4_.isCertificate)
                        {
                           Api.system.sendAction(new MountInfoRequest(_loc4_));
                        }
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
         this._storage.setDropAllowed(false,"behavior");
         this._storage.questVisible = false;
         this._storage.btn_moveAllToLeft.visible = false;
      }
      
      public function detach() : void
      {
         this._storage.setDropAllowed(true,"behavior");
         this._storage.questVisible = true;
         this._storage.btn_moveAllToLeft.visible = true;
         Api.ui.unloadUi(UIEnum.HUMAN_VENDOR_STOCK);
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
         return StorageState.HUMAN_VENDOR_MOD;
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
