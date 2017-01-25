package com.ankamagames.dofus.logic.game.common.misc.inventoryView
{
   import com.ankamagames.dofus.datacenter.jobs.Recipe;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.StorageOptionManager;
   import com.ankamagames.dofus.logic.game.common.misc.HookLock;
   import com.ankamagames.dofus.logic.game.common.misc.IStorageView;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import flash.utils.Dictionary;
   
   public class StorageCraftFilterView extends StorageGenericView
   {
       
      
      private var _ingredients:Dictionary;
      
      private var _skillId:int;
      
      private var _jobLevel:int;
      
      private var _parent:IStorageView;
      
      public function StorageCraftFilterView(param1:HookLock, param2:IStorageView, param3:int, param4:int)
      {
         var _loc6_:Recipe = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         super(param1);
         var _loc5_:Array = Recipe.getAllRecipesForSkillId(param3,param4);
         this._ingredients = new Dictionary();
         for each(_loc6_ in _loc5_)
         {
            _loc7_ = false;
            for each(_loc8_ in _loc6_.ingredientIds)
            {
               this._ingredients[_loc8_] = true;
            }
         }
         this._ingredients[7508] = true;
         this._skillId = param3;
         this._jobLevel = param4;
         this._parent = param2;
      }
      
      override public function get name() : String
      {
         return "storageCraftFilter";
      }
      
      override public function isListening(param1:ItemWrapper) : Boolean
      {
         return this._parent.isListening(param1) && this._ingredients.hasOwnProperty(param1.objectGID);
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
