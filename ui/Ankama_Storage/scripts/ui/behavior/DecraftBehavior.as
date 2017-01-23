package ui.behavior
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.ExchangeObjectMove;
   import d2actions.ExchangeObjectTransfertAllFromInv;
   import d2actions.ExchangeObjectTransfertExistingFromInv;
   import d2actions.ExchangeObjectTransfertListFromInv;
   import d2enums.SelectMethodEnum;
   import d2hooks.DoubleClickItemInventory;
   import ui.AbstractStorageUi;
   import ui.StorageUi;
   import ui.enum.StorageState;
   
   public class DecraftBehavior implements IStorageBehavior
   {
       
      
      private var _storage:StorageUi;
      
      private var _objectToCrush:Object;
      
      public function DecraftBehavior()
      {
         super();
      }
      
      public function filterStatus(param1:Boolean) : void
      {
      }
      
      public function dropValidator(param1:Object, param2:Object, param3:Object) : Boolean
      {
         if(param2 is ItemWrapper && (!Api.ui.getUi(UIEnum.RUNE_MAKER) || (param2 as ItemWrapper).category == 0) && param1.getUi().name != param3.getUi().name)
         {
            return true;
         }
         return false;
      }
      
      public function processDrop(param1:Object, param2:Object, param3:Object) : void
      {
         if(param2.quantity > 1)
         {
            this._objectToCrush = param2;
            Api.common.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQty);
         }
         else
         {
            Api.system.sendAction(new ExchangeObjectMove(param2.objectUID,-1));
         }
      }
      
      public function onValidQtyDrop(param1:Number) : void
      {
      }
      
      private function onValidQty(param1:Number) : void
      {
         Api.system.sendAction(new ExchangeObjectMove(this._objectToCrush.objectUID,-param1));
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
                  case SelectMethodEnum.DOUBLE_CLICK:
                     Api.ui.hideTooltip();
                     Api.system.dispatchHook(DoubleClickItemInventory,_loc4_,1);
                     break;
                  case SelectMethodEnum.CTRL_DOUBLE_CLICK:
                     Api.system.dispatchHook(DoubleClickItemInventory,_loc4_,_loc4_.quantity);
                     break;
                  case SelectMethodEnum.ALT_DOUBLE_CLICK:
                     this._objectToCrush = param1.selectedItem;
                     Api.common.openQuantityPopup(1,param1.selectedItem.quantity,param1.selectedItem.quantity,this.onValidQty);
               }
         }
      }
      
      public function attach(param1:AbstractStorageUi) : void
      {
         if(!(param1 is StorageUi))
         {
            throw new Error("Can\'t attach a DecraftBehavior to a non StorageUi storage");
         }
         this._storage = param1 as StorageUi;
         this._storage.questVisible = false;
         this._storage.btn_moveAllToLeft.visible = true;
      }
      
      public function detach() : void
      {
         this._storage.questVisible = true;
         this._storage.btn_moveAllToLeft.visible = true;
      }
      
      public function onUnload() : void
      {
         Api.ui.unloadUi(UIEnum.RUNE_MAKER);
         Api.ui.unloadUi(UIEnum.RECYCLE);
      }
      
      public function isDefaultBehavior() : Boolean
      {
         return false;
      }
      
      public function getStorageUiName() : String
      {
         return UIEnum.STORAGE_UI;
      }
      
      public function getName() : String
      {
         return StorageState.DECRAFT_MOD;
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
   }
}
