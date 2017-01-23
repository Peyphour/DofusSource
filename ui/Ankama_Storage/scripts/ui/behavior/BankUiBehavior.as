package ui.behavior
{
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.ExchangeObjectMove;
   import d2actions.ExchangeObjectMoveKama;
   import d2actions.ExchangeObjectTransfertAllToInv;
   import d2actions.ExchangeObjectTransfertExistingToInv;
   import d2actions.ExchangeObjectTransfertListToInv;
   import d2hooks.ClickItemInventory;
   import d2hooks.ShowObjectLinked;
   import ui.AbstractStorageUi;
   import ui.BankUi;
   import ui.enum.StorageState;
   
   public class BankUiBehavior implements IStorageBehavior
   {
       
      
      protected var _bank:BankUi;
      
      private var _objectToExchange:Object;
      
      public function BankUiBehavior()
      {
         super();
      }
      
      public function filterStatus(param1:Boolean) : void
      {
      }
      
      public function dropValidator(param1:Object, param2:Object, param3:Object) : Boolean
      {
         if(param2.position != 63)
         {
            return false;
         }
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
               if(this._bank.getWeightMax() > 0)
               {
                  _loc5_ = this._bank.getWeightMax() - this._bank.getWeight();
                  if(param2.realWeight * param2.quantity > _loc5_)
                  {
                     _loc4_ = Math.floor(_loc5_ / param2.realWeight);
                  }
               }
               Api.common.openQuantityPopup(1,_loc4_,_loc4_,this.onValidQty);
            }
            else
            {
               Api.system.sendAction(new ExchangeObjectMove(param2.objectUID,1));
            }
         }
      }
      
      private function onValidNegativeQty(param1:Number) : void
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
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this._bank.ctr_kamas:
               if(this._bank.kamas > 0)
               {
                  Api.common.openQuantityPopup(1,this._bank.kamas,this._bank.kamas,this.onValidQtyKama);
               }
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         switch(param1)
         {
            case this._bank.grid:
               _loc4_ = this._bank.grid.selectedItem;
               if(param2 == 0)
               {
                  Api.system.dispatchHook(ClickItemInventory,_loc4_);
                  if(!Api.system.getOption("displayTooltips","dofus"))
                  {
                     Api.system.dispatchHook(ShowObjectLinked,_loc4_);
                  }
               }
               else if(param2 == 1)
               {
                  if(this.bankContainItem(_loc4_.objectUID))
                  {
                     Api.system.sendAction(new ExchangeObjectMove(_loc4_.objectUID,-1));
                  }
               }
               else if(param2 == 9)
               {
                  if(this.bankContainItem(_loc4_.objectUID))
                  {
                     _loc5_ = Api.player.inventoryWeight();
                     _loc6_ = Api.player.inventoryWeightMax();
                     _loc7_ = _loc4_.quantity;
                     _loc8_ = _loc6_ - _loc5_;
                     if(_loc4_.realWeight * _loc4_.quantity > _loc8_)
                     {
                        _loc7_ = Math.floor(_loc8_ / _loc4_.realWeight);
                     }
                     Api.system.sendAction(new ExchangeObjectMove(_loc4_.objectUID,-_loc7_));
                  }
               }
               else if(param2 == 10)
               {
                  this._objectToExchange = param1.selectedItem;
                  Api.common.openQuantityPopup(1,param1.selectedItem.quantity,param1.selectedItem.quantity,this.onValidNegativeQty);
               }
         }
      }
      
      public function attach(param1:AbstractStorageUi) : void
      {
         if(!(param1 is BankUi))
         {
            throw new Error("Can\'t attach a BankUiBehavior to a non BankUi storage");
         }
         this._bank = param1 as BankUi;
         this._bank.questVisible = false;
         this._bank.btn_moveAllToRight.visible = true;
         this._bank.ctr_kamas.mouseEnabled = true;
         this._bank.ctr_kamas.handCursor = true;
      }
      
      public function detach() : void
      {
         this._bank.questVisible = true;
         this._bank.btn_moveAllToRight.visible = false;
      }
      
      public function onUnload() : void
      {
      }
      
      public function getStorageUiName() : String
      {
         return UIEnum.BANK_UI;
      }
      
      public function getName() : String
      {
         return StorageState.BANK_UI_MOD;
      }
      
      public function get replacable() : Boolean
      {
         return false;
      }
      
      private function onValidQtyKama(param1:Number) : void
      {
         Api.system.sendAction(new ExchangeObjectMoveKama(-param1));
      }
      
      private function bankContainItem(param1:uint) : Boolean
      {
         var _loc3_:int = 0;
         var _loc2_:* = this._bank.grid.dataProvider;
         var _loc4_:int = _loc2_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(_loc2_[_loc3_].objectUID == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function transfertAll() : void
      {
         Api.system.sendAction(new ExchangeObjectTransfertAllToInv());
      }
      
      public function transfertList() : void
      {
         Api.system.sendAction(new ExchangeObjectTransfertListToInv(this._bank.itemsDisplayed));
      }
      
      public function transfertExisting() : void
      {
         Api.system.sendAction(new ExchangeObjectTransfertExistingToInv());
      }
   }
}
