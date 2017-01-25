package com.ankamagames.dofus.logic.game.common.misc.inventoryView
{
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.StorageOptionManager;
   import com.ankamagames.dofus.logic.game.common.misc.HookLock;
   import com.ankamagames.dofus.logic.game.common.misc.IStorageView;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   
   public class StorageSmithMagicFilterView extends StorageGenericView
   {
      
      private static const SMITHMAGIC_RUNE_ID:int = 78;
      
      private static const SMITHMAGIC_POTION_ID:int = 26;
      
      private static const SMITHMAGIC_ORB_ID:int = 189;
      
      private static const SIGNATURE_RUNE_ID:int = 7508;
       
      
      private var _skill:Skill;
      
      private var _parent:IStorageView;
      
      public function StorageSmithMagicFilterView(param1:HookLock, param2:IStorageView, param3:Skill)
      {
         super(param1);
         this._skill = param3;
         this._parent = param2;
      }
      
      override public function get name() : String
      {
         return "storageSmithMagicFilter";
      }
      
      override public function isListening(param1:ItemWrapper) : Boolean
      {
         return this._parent.isListening(param1) && super.isListening(param1) && (this._skill.modifiableItemTypeIds.indexOf(param1.typeId) != -1 || param1.typeId == SMITHMAGIC_RUNE_ID || param1.typeId == SMITHMAGIC_POTION_ID || param1.typeId == SMITHMAGIC_ORB_ID || param1.objectGID == SIGNATURE_RUNE_ID);
      }
      
      override public function updateView() : void
      {
         super.updateView();
         if(StorageOptionManager.getInstance().currentStorageView == this)
         {
            _hookLock.addHook(InventoryHookList.StorageViewContent,[content,InventoryManager.getInstance().inventory.localKamas]);
         }
      }
      
      public function set parent(param1:IStorageView) : void
      {
         this._parent = param1;
      }
      
      public function get parent() : IStorageView
      {
         return this._parent;
      }
   }
}
