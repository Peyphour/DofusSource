package com.ankamagames.dofus.logic.game.common.misc.inventoryView
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.StorageOptionManager;
   import com.ankamagames.dofus.logic.game.common.misc.HookLock;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   
   public class StorageEquipmentView extends StorageGenericView
   {
       
      
      public function StorageEquipmentView(param1:HookLock)
      {
         super(param1);
      }
      
      override public function get name() : String
      {
         return "storageEquipment";
      }
      
      override public function isListening(param1:ItemWrapper) : Boolean
      {
         return super.isListening(param1) && param1.category == StorageOptionManager.EQUIPMENT_CATEGORY;
      }
      
      override public function updateView() : void
      {
         super.updateView();
         if(StorageOptionManager.getInstance().currentStorageView == this)
         {
            _hookLock.addHook(InventoryHookList.StorageViewContent,[content,InventoryManager.getInstance().inventory.localKamas]);
         }
      }
   }
}
