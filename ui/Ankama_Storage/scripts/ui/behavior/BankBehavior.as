package ui.behavior
{
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.ExchangeObjectMove;
   import d2actions.ExchangeObjectMoveKama;
   import d2actions.ExchangeObjectTransfertAllFromInv;
   import d2actions.ExchangeObjectTransfertExistingFromInv;
   import d2actions.ExchangeObjectTransfertListFromInv;
   import d2enums.SelectMethodEnum;
   import d2hooks.ClickItemInventory;
   import d2hooks.ShowObjectLinked;
   import ui.AbstractStorageUi;
   import ui.enum.StorageState;
   
   public class BankBehavior implements IStorageBehavior
   {
       
      
      protected var _storage:AbstractStorageUi;
      
      private var _objectToExchange:Object;
      
      public function BankBehavior()
      {
         super();
      }
      
      public function filterStatus(param1:Boolean) : void
      {
      }
      
      public function dropValidator(param1:Object, param2:Object, param3:Object) : Boolean
      {
         return true;
      }
      
      public function processDrop(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         if(this.dropValidator(param1,param2,param3))
         {
            if(param2.quantity > 1)
            {
               this._objectToExchange = param2;
               _loc4_ = param2.quantity;
               _loc5_ = this._storage.getWeightMax() - this._storage.getWeight();
               if(param2.realWeight * param2.quantity > _loc5_)
               {
                  _loc4_ = Math.floor(_loc5_ / param2.realWeight);
               }
               Api.common.openQuantityPopup(1,_loc4_,_loc4_,this.onValidNegativQty);
            }
            else
            {
               Api.system.sendAction(new ExchangeObjectMove(param2.objectUID,-1));
            }
         }
      }
      
      private function onValidNegativQty(param1:Number) : void
      {
         Api.system.sendAction(new ExchangeObjectMove(this._objectToExchange.objectUID,-param1));
      }
      
      public function onValidQtyDrop(param1:Number) : void
      {
      }
      
      private function onValidQty(param1:Number) : void
      {
         Api.system.sendAction(new ExchangeObjectMove(this._objectToExchange.objectUID,param1));
      }
      
      private function onValidQtyKama(param1:Number) : void
      {
         Api.system.sendAction(new ExchangeObjectMoveKama(param1));
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case this._storage.ctr_kamas:
               _loc2_ = Api.player.characteristics().kamas;
               if(_loc2_ > 0)
               {
                  Api.common.openQuantityPopup(1,_loc2_,_loc2_,this.onValidQtyKama);
               }
         }
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
                     Api.system.dispatchHook(ClickItemInventory,_loc4_);
                     if(!Api.system.getOption("displayTooltips","dofus"))
                     {
                        Api.system.dispatchHook(ShowObjectLinked,_loc4_);
                     }
                     break;
                  case SelectMethodEnum.DOUBLE_CLICK:
                     Api.ui.hideTooltip();
                     if(Api.inventory.getItem(_loc4_.objectUID))
                     {
                        Api.system.sendAction(new ExchangeObjectMove(_loc4_.objectUID,1));
                     }
                     break;
                  case SelectMethodEnum.CTRL_DOUBLE_CLICK:
                     if(Api.inventory.getItem(_loc4_.objectUID))
                     {
                        Api.system.sendAction(new ExchangeObjectMove(_loc4_.objectUID,_loc4_.quantity));
                     }
                     break;
                  case SelectMethodEnum.ALT_DOUBLE_CLICK:
                     this._objectToExchange = param1.selectedItem;
                     Api.common.openQuantityPopup(1,param1.selectedItem.quantity,param1.selectedItem.quantity,this.onValidQty);
               }
         }
      }
      
      public function attach(param1:AbstractStorageUi) : void
      {
         this._storage = param1;
         Api.system.disableWorldInteraction();
         this._storage.questVisible = false;
         this._storage.btn_moveAllToLeft.visible = true;
         var _loc2_:uint = Api.player.characteristics().kamas;
         if(_loc2_ > 0)
         {
            this._storage.ctr_kamas.mouseEnabled = true;
            this._storage.ctr_kamas.handCursor = true;
         }
      }
      
      public function detach() : void
      {
         Api.system.enableWorldInteraction();
         this._storage.questVisible = true;
         this._storage.btn_moveAllToLeft.visible = false;
      }
      
      public function onUnload() : void
      {
         Api.ui.unloadUi(UIEnum.BANK_UI);
      }
      
      public function getStorageUiName() : String
      {
         return UIEnum.STORAGE_UI;
      }
      
      public function getName() : String
      {
         return StorageState.BANK_MOD;
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
