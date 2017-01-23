package ui.behavior
{
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.CloseInventory;
   import d2enums.SelectMethodEnum;
   import d2hooks.DoubleClickItemInventory;
   import d2hooks.ExchangeLeave;
   import d2hooks.ObjectSelected;
   import flash.utils.getTimer;
   import ui.AbstractStorageUi;
   import ui.StorageUi;
   import ui.enum.StorageState;
   
   public class SmithMagicBehavior implements IStorageBehavior
   {
       
      
      protected var _storage:StorageUi;
      
      protected var _uiName:String;
      
      protected var _objectToExchange:Object;
      
      protected var _filter:Boolean = false;
      
      protected var _smithMagicUi:Object = null;
      
      public var timer:int;
      
      public function SmithMagicBehavior()
      {
         this.timer = getTimer();
         super();
      }
      
      public function get smithMagicUi() : Object
      {
         var _loc1_:Object = null;
         if(!this._smithMagicUi)
         {
            _loc1_ = Api.ui.getUi(this.getMainUiName());
            if(_loc1_)
            {
               this._smithMagicUi = _loc1_.uiClass;
            }
         }
         return this._smithMagicUi;
      }
      
      public function filterStatus(param1:Boolean) : void
      {
         Api.system.setData("filterSmithMagicStorage",this._storage.btn_itemsFilter.selected);
         this.refreshFilter();
      }
      
      public function get filterEnabled() : Boolean
      {
         return false;
      }
      
      public function getMainUiName() : String
      {
         return UIEnum.SMITH_MAGIC;
      }
      
      public function dropValidator(param1:Object, param2:Object, param3:Object) : Boolean
      {
         return true;
      }
      
      public function processDrop(param1:Object, param2:Object, param3:Object) : void
      {
         Api.ui.getUi(this.getMainUiName()).uiClass.processDropToInventory(param1,param2,param3);
      }
      
      private function onValidQtyDrop(param1:Number) : void
      {
         Api.ui.getUi("smithMagic").uiClass.unfillSelectedSlot(param1);
      }
      
      private function onValidQty(param1:Number) : void
      {
         Api.system.dispatchHook(DoubleClickItemInventory,this._objectToExchange,param1);
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
                     if(!Api.system.getOption("displayTooltips","dofus"))
                     {
                        Api.system.dispatchHook(ObjectSelected,{"data":_loc4_});
                     }
                     break;
                  case SelectMethodEnum.DOUBLE_CLICK:
                     if(Api.inventory.getItem(_loc4_.objectUID))
                     {
                        Api.ui.hideTooltip();
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
                     this._objectToExchange = _loc4_;
                     Api.common.openQuantityPopup(1,_loc4_.quantity,_loc4_.quantity,this.onValidQty);
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
         this._storage.btn_moveAllToLeft.visible = false;
         this._storage.questVisible = false;
         this._storage.showFilter(Api.ui.getText("ui.craft.smithMagicFilter"),Api.system.getData("filterSmithMagicStorage"));
         if(this.smithMagicUi)
         {
            this.refreshFilter();
         }
      }
      
      public function detach() : void
      {
         this._storage.btn_moveAllToLeft.visible = true;
         this._storage.questVisible = true;
         this._storage.hideFilter();
         Api.system.sendAction(new CloseInventory());
      }
      
      public function onUnload() : void
      {
         Api.storage.disableSmithMagicFilter();
         Api.system.removeHook(ExchangeLeave);
         Api.ui.unloadUi("smithMagic");
      }
      
      public function onUiLoaded(param1:String) : void
      {
         switch(param1)
         {
            case "smithMagic":
               this._storage.updateInventory();
               this.refreshFilter();
         }
      }
      
      private function refreshFilter() : void
      {
         if(this._storage.btn_itemsFilter.selected)
         {
            Api.storage.enableSmithMagicFilter(this.smithMagicUi.skill);
         }
         else
         {
            Api.storage.disableSmithMagicFilter();
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
         return StorageState.SMITH_MAGIC_MOD;
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
