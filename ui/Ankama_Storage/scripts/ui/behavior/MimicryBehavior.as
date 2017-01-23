package ui.behavior
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2enums.SelectMethodEnum;
   import d2hooks.ObjectSelected;
   import ui.AbstractStorageUi;
   import ui.StorageUi;
   import ui.enum.StorageState;
   
   public class MimicryBehavior implements IStorageBehavior
   {
       
      
      private var _storage:StorageUi;
      
      private var _waitingObject:Object;
      
      private var _mimicryUi:Object;
      
      protected var _showFilter:Boolean = true;
      
      public function MimicryBehavior()
      {
         super();
      }
      
      public function filterStatus(param1:Boolean) : void
      {
      }
      
      public function get mimicryUi() : Object
      {
         if(!this._mimicryUi)
         {
            this._mimicryUi = Api.ui.getUi("mimicry").uiClass;
         }
         return this._mimicryUi;
      }
      
      public function dropValidator(param1:Object, param2:Object, param3:Object) : Boolean
      {
         return true;
      }
      
      public function processDrop(param1:Object, param2:Object, param3:Object) : void
      {
         this.mimicryUi.processDropToInventory(param1,param2,param3);
      }
      
      public function onRelease(param1:Object) : void
      {
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:ItemWrapper = null;
         var _loc5_:ItemWrapper = null;
         switch(param1)
         {
            case this._storage.grid:
               _loc4_ = this._storage.grid.selectedItem;
               if(!_loc4_)
               {
                  return;
               }
               _loc5_ = Api.data.getItemWrapper(_loc4_.objectGID,_loc4_.position,_loc4_.objectUID,1,_loc4_.effectsList);
               switch(param2)
               {
                  case SelectMethodEnum.CLICK:
                     if(!Api.system.getOption("displayTooltips","dofus"))
                     {
                        Api.system.dispatchHook(ObjectSelected,{"data":_loc5_});
                     }
                     break;
                  case SelectMethodEnum.DOUBLE_CLICK:
                  case SelectMethodEnum.CTRL_DOUBLE_CLICK:
                  case SelectMethodEnum.ALT_DOUBLE_CLICK:
                     if(Api.inventory.getItem(_loc5_.objectUID) && _loc5_.category == 0)
                     {
                        Api.ui.hideTooltip();
                        this.mimicryUi.fillAutoSlot(_loc5_);
                     }
               }
               break;
         }
      }
      
      public function attach(param1:AbstractStorageUi) : void
      {
         if(!(param1 is StorageUi))
         {
            throw new Error("Can\'t attach a MimicryBehavior to a non StorageUi storage");
         }
         this._storage = param1 as StorageUi;
         Api.system.disableWorldInteraction();
         this._storage.categoryFilter = 0;
         this._storage.btn_moveAllToLeft.visible = false;
         this._storage.questVisible = false;
      }
      
      public function detach() : void
      {
         Api.system.enableWorldInteraction();
         this._storage.btn_moveAllToLeft.visible = true;
         this._storage.questVisible = true;
      }
      
      public function onUnload() : void
      {
         if(Api.ui.getUi("mimicry"))
         {
            Api.ui.unloadUi("mimicry");
         }
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
         return StorageState.MIMICRY_MOD;
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
