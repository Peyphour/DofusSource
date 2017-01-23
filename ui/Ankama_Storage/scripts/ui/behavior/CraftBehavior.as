package ui.behavior
{
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.LeaveDialogRequest;
   import d2enums.SelectMethodEnum;
   import d2hooks.ExchangeLeave;
   import d2hooks.ObjectSelected;
   import ui.AbstractStorageUi;
   import ui.StorageUi;
   import ui.enum.StorageState;
   
   public class CraftBehavior implements IStorageBehavior
   {
       
      
      private var _storage:StorageUi;
      
      private var _waitingObject:Object;
      
      private var _craftUi:Object;
      
      protected var _showFilter:Boolean = true;
      
      public function CraftBehavior()
      {
         super();
      }
      
      public function filterStatus(param1:Boolean) : void
      {
         Api.system.setData("filterCraftStorage",this._storage.btn_itemsFilter.selected);
         this.refreshFilter();
      }
      
      public function get craftUi() : Object
      {
         if(!this._craftUi)
         {
            this._craftUi = Api.ui.getUi("craft").uiClass;
         }
         return this._craftUi;
      }
      
      public function dropValidator(param1:Object, param2:Object, param3:Object) : Boolean
      {
         return true;
      }
      
      public function processDrop(param1:Object, param2:Object, param3:Object) : void
      {
         this.craftUi.processDropToInventory(param1,param2,param3);
      }
      
      public function onValidQty(param1:Number) : void
      {
         var _loc2_:Object = Api.ui.getUi("craft").uiClass;
         _loc2_.fillAutoSlot(this._waitingObject,param1);
      }
      
      public function onRelease(param1:Object) : void
      {
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
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
                        _loc5_ = Api.ui.getUi("craft").uiClass;
                        _loc5_.fillAutoSlot(_loc4_,1);
                     }
                     break;
                  case SelectMethodEnum.CTRL_DOUBLE_CLICK:
                     if(Api.inventory.getItem(_loc4_.objectUID))
                     {
                        _loc6_ = Api.ui.getUi("craft").uiClass;
                        _loc6_.fillAutoSlot(_loc4_,_loc4_.quantity);
                     }
                     break;
                  case SelectMethodEnum.ALT_DOUBLE_CLICK:
                     this._waitingObject = _loc4_;
                     Api.common.openQuantityPopup(1,_loc4_.quantity,_loc4_.quantity,this.onValidQty);
               }
         }
      }
      
      public function attach(param1:AbstractStorageUi) : void
      {
         if(!(param1 is StorageUi))
         {
            throw new Error("Can\'t attach a CraftBehavior to a non StorageUi storage");
         }
         this._storage = param1 as StorageUi;
         Api.system.disableWorldInteraction();
         this._storage.btn_moveAllToLeft.visible = false;
         this._storage.questVisible = false;
         if(this._showFilter)
         {
            this._storage.showFilter(Api.ui.getText("ui.craft.craftFilter"),Api.system.getData("filterCraftStorage"));
         }
         this.refreshFilter();
      }
      
      public function detach() : void
      {
         Api.system.enableWorldInteraction();
         this._storage.btn_moveAllToLeft.visible = true;
         this._storage.questVisible = true;
      }
      
      public function onUnload() : void
      {
         Api.storage.disableCraftFilter();
         Api.system.removeHook(ExchangeLeave);
         if(Api.ui.getUi(UIEnum.CRAFT))
         {
            Api.ui.unloadUi(UIEnum.CRAFT);
         }
         else if(Api.ui.getUi(UIEnum.CRAFT_COOP))
         {
            Api.ui.unloadUi(UIEnum.CRAFT_COOP);
         }
         Api.system.sendAction(new LeaveDialogRequest());
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
         return StorageState.CRAFT_MOD;
      }
      
      public function get replacable() : Boolean
      {
         return false;
      }
      
      private function refreshFilter() : void
      {
         if(this.craftUi && this.craftUi.skill && this.craftUi.skill.id == 209)
         {
            return;
         }
         if(this._showFilter)
         {
            if(this._storage.btn_itemsFilter.selected)
            {
               Api.storage.enableCraftFilter(this.craftUi.skill,this.craftUi.jobLevel);
            }
            else
            {
               Api.storage.disableCraftFilter();
            }
            Api.storage.updateStorageView();
            Api.storage.releaseHooks();
         }
         else
         {
            Api.storage.disableCraftFilter();
         }
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
