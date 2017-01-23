package ui.behavior
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.MountInfoRequest;
   import d2actions.ObjectDrop;
   import d2actions.ObjectSetPosition;
   import d2actions.OpenIdols;
   import d2enums.SelectMethodEnum;
   import ui.AbstractStorageUi;
   import ui.EquipmentUi;
   import ui.enum.StorageState;
   
   public class StorageClassicBehavior implements IStorageBehavior
   {
       
      
      private var _storage:EquipmentUi;
      
      private var _waitingObject:Object;
      
      public function StorageClassicBehavior()
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
         if(param2.quantity == 1)
         {
            Api.system.sendAction(new ObjectSetPosition(param2.objectUID,63,1));
         }
         else
         {
            this._waitingObject = param2;
            Api.common.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQty);
         }
      }
      
      public function onRelease(param1:Object) : void
      {
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         if(param1 == this._storage.grid)
         {
            _loc4_ = this._storage.grid.selectedItem;
            switch(param2)
            {
               case SelectMethodEnum.CLICK:
                  break;
               case SelectMethodEnum.DOUBLE_CLICK:
                  Api.ui.hideTooltip();
                  this.doubleClickGridItem(_loc4_);
                  break;
               case SelectMethodEnum.CTRL_DOUBLE_CLICK:
                  this.doubleClickGridItem(_loc4_);
            }
         }
      }
      
      public function attach(param1:AbstractStorageUi) : void
      {
         if(!(param1 is EquipmentUi))
         {
            throw new Error("Can\'t attach a StorageClassicBehavior to a non EquipmentUi storage");
         }
         this._storage = param1 as EquipmentUi;
      }
      
      public function detach() : void
      {
      }
      
      public function onUnload() : void
      {
      }
      
      public function getStorageUiName() : String
      {
         return UIEnum.EQUIPMENT_UI;
      }
      
      public function getName() : String
      {
         return StorageState.BAG_MOD;
      }
      
      public function get replacable() : Boolean
      {
         return true;
      }
      
      private function onValidQtyDrop(param1:Number) : void
      {
         if(!Api.player.isInExchange())
         {
            Api.system.sendAction(new ObjectDrop(this._waitingObject.objectUID,this._waitingObject.objectGID,param1));
         }
      }
      
      private function onValidQty(param1:Number) : void
      {
         Api.system.sendAction(new ObjectSetPosition(this._waitingObject.objectUID,63,param1));
      }
      
      public function doubleClickGridItem(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(param1 && param1.category == 0)
         {
            _loc2_ = Api.storage.getBestEquipablePosition(param1);
            if(_loc2_ > -1)
            {
               Api.system.sendAction(new ObjectSetPosition(param1.objectUID,_loc2_,1));
            }
         }
         else if(param1)
         {
            if(param1.usable || param1.targetable)
            {
               this._storage.useItem(param1);
            }
            else if(param1.typeId == 178)
            {
               Api.system.sendAction(new OpenIdols());
            }
            else if(param1.hasOwnProperty("isCertificate") && param1.isCertificate)
            {
               Api.system.sendAction(new MountInfoRequest(param1));
            }
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
