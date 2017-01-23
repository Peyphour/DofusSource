package ui.behavior
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.ExchangeObjectMove;
   import d2actions.ExchangeObjectTransfertAllFromInv;
   import d2actions.ExchangeObjectTransfertExistingFromInv;
   import d2actions.ExchangeObjectTransfertListFromInv;
   import d2enums.SelectMethodEnum;
   import d2hooks.AskExchangeMoveObject;
   import d2hooks.ClickItemInventory;
   import d2hooks.DoubleClickItemInventory;
   import d2hooks.ObjectSelected;
   import ui.AbstractStorageUi;
   import ui.StorageUi;
   import ui.enum.StorageState;
   
   public class ExchangeBehavior implements IStorageBehavior
   {
       
      
      private var _storage:StorageUi;
      
      private var _objectToExchange:Object;
      
      public function ExchangeBehavior()
      {
         super();
      }
      
      public function filterStatus(param1:Boolean) : void
      {
      }
      
      public function dropValidator(param1:Object, param2:Object, param3:Object) : Boolean
      {
         if(param2 is ItemWrapper && this._storage.categoryFilter != AbstractStorageUi.QUEST_CATEGORY && param1.getUi().name != param3.getUi().name)
         {
            return true;
         }
         return false;
      }
      
      public function processDrop(param1:Object, param2:Object, param3:Object) : void
      {
         if(param2.quantity > 1)
         {
            this._objectToExchange = param2;
            Api.common.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQtyDrop);
         }
         else
         {
            Api.system.sendAction(new ExchangeObjectMove(param2.objectUID,-param2.quantity));
         }
      }
      
      public function onValidQtyDrop(param1:Number) : void
      {
         Api.system.sendAction(new ExchangeObjectMove(this._objectToExchange.objectUID,-param1));
      }
      
      private function onValidQty(param1:Number) : void
      {
         this.transfertObject(this._objectToExchange.objectUID,param1);
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
               switch(param2)
               {
                  case SelectMethodEnum.CLICK:
                     Api.system.dispatchHook(ObjectSelected,_loc4_);
                     Api.system.dispatchHook(ClickItemInventory,_loc4_);
                     break;
                  case SelectMethodEnum.DOUBLE_CLICK:
                     Api.ui.hideTooltip();
                     if(Api.inventory.getItem(_loc4_.objectUID))
                     {
                        Api.system.dispatchHook(DoubleClickItemInventory,_loc4_,1);
                     }
                     break;
                  case SelectMethodEnum.CTRL_DOUBLE_CLICK:
                     if(Api.inventory.getItem(_loc4_.objectUID))
                     {
                        Api.system.dispatchHook(DoubleClickItemInventory,_loc4_,_loc4_.quantity);
                     }
                     break;
                  case SelectMethodEnum.ALT_DOUBLE_CLICK:
                     this._objectToExchange = param1.selectedItem;
                     Api.common.openQuantityPopup(1,param1.selectedItem.quantity,param1.selectedItem.quantity,this.onValidQty);
               }
         }
      }
      
      public function main(param1:Object) : void
      {
      }
      
      public function attach(param1:AbstractStorageUi) : void
      {
         if(!(param1 is StorageUi))
         {
            throw new Error("Can\'t attach a ExchangeBehavior to a non StorageUi storage");
         }
         this._storage = param1 as StorageUi;
         this._storage.questVisible = false;
         this._storage.btn_moveAllToLeft.visible = true;
      }
      
      public function detach() : void
      {
         this._storage.questVisible = true;
         Api.ui.unloadUi(UIEnum.EXCHANGE_UI);
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
         return StorageState.EXCHANGE_MOD;
      }
      
      public function get replacable() : Boolean
      {
         return false;
      }
      
      public function transfertAll() : void
      {
         Api.system.sendAction(new ExchangeObjectTransfertAllFromInv());
      }
      
      public function transfertList() : void
      {
         Api.system.sendAction(new ExchangeObjectTransfertListFromInv(this._storage.itemsDisplayed));
      }
      
      public function transfertExisting() : void
      {
         Api.system.sendAction(new ExchangeObjectTransfertExistingFromInv());
      }
      
      private function transfertObject(param1:uint, param2:int) : void
      {
         Api.system.dispatchHook(AskExchangeMoveObject,param1,param2);
         Api.system.sendAction(new ExchangeObjectMove(param1,param2));
      }
   }
}
