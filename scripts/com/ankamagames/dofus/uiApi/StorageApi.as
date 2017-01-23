package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.datacenter.livingObjects.Pet;
   import com.ankamagames.dofus.datacenter.mounts.RideFood;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.MountWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.MountFrame;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.StorageOptionManager;
   import com.ankamagames.dofus.logic.game.common.misc.IInventoryView;
   import com.ankamagames.dofus.network.enums.ShortcutBarEnum;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class StorageApi implements IApi
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(StorageApi));
      
      private static var _lastItemPosition:Array = new Array();
      
      public static const ITEM_TYPE_TO_SERVER_POSITION:Array = [[],[0],[1],[2,4],[3],[5],[],[15],[1],[],[6],[7],[8],[9,10,11,12,13,14],[],[20],[21],[22,23],[24,25],[26],[27],[16],[],[28],[8,16],[30]];
       
      
      public function StorageApi()
      {
         super();
      }
      
      [Untrusted]
      public function itemSuperTypeToServerPosition(param1:uint) : Array
      {
         return ITEM_TYPE_TO_SERVER_POSITION[param1];
      }
      
      [Untrusted]
      public function getLivingObjectFood(param1:int) : Vector.<ItemWrapper>
      {
         var _loc6_:ItemWrapper = null;
         var _loc2_:Vector.<ItemWrapper> = new Vector.<ItemWrapper>();
         var _loc3_:Vector.<ItemWrapper> = InventoryManager.getInstance().inventory.getView("storage").content;
         var _loc4_:int = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            if(!_loc6_.isLivingObject && _loc6_.type.id == param1)
            {
               _loc2_.push(_loc6_);
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getPetFood(param1:int) : Vector.<ItemWrapper>
      {
         var _loc4_:Vector.<ItemWrapper> = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:Vector.<int> = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:ItemWrapper = null;
         var _loc2_:Vector.<ItemWrapper> = new Vector.<ItemWrapper>();
         var _loc3_:Pet = Pet.getPetById(param1);
         if(_loc3_)
         {
            _loc4_ = InventoryManager.getInstance().inventory.getView("storage").content;
            _loc5_ = Pet.getPetById(param1).foodItems;
            _loc6_ = Pet.getPetById(param1).foodTypes;
            _loc7_ = _loc4_.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = _loc4_[_loc8_];
               if(_loc5_.indexOf(_loc9_.objectGID) > -1 || _loc6_.indexOf(_loc9_.typeId) > -1)
               {
                  _loc2_.push(_loc9_);
               }
               _loc8_++;
            }
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getRideFoods() : Array
      {
         var _loc6_:RideFood = null;
         var _loc7_:ItemWrapper = null;
         var _loc8_:Item = null;
         var _loc1_:Array = new Array();
         var _loc2_:Vector.<ItemWrapper> = InventoryManager.getInstance().inventory.getView("storage").content;
         var _loc3_:Array = RideFood.getRideFoods();
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         for each(_loc6_ in _loc3_)
         {
            if(_loc6_.gid != 0)
            {
               _loc4_.push(_loc6_.gid);
            }
            if(_loc6_.typeId != 0)
            {
               _loc5_.push(_loc6_.typeId);
            }
         }
         for each(_loc7_ in _loc2_)
         {
            _loc8_ = Item.getItemById(_loc7_.objectGID);
            if(_loc4_.indexOf(_loc7_.objectGID) != -1 || _loc5_.indexOf(_loc8_.typeId) != -1)
            {
               _loc1_.push(_loc7_);
            }
         }
         return _loc1_;
      }
      
      [Untrusted]
      public function getViewContent(param1:String) : Vector.<ItemWrapper>
      {
         var _loc2_:IInventoryView = InventoryManager.getInstance().inventory.getView(param1);
         if(_loc2_)
         {
            return _loc2_.content;
         }
         return null;
      }
      
      [Untrusted]
      public function getShortcutBarContent(param1:uint) : Array
      {
         if(param1 == ShortcutBarEnum.GENERAL_SHORTCUT_BAR)
         {
            return InventoryManager.getInstance().shortcutBarItems;
         }
         if(param1 == ShortcutBarEnum.SPELL_SHORTCUT_BAR)
         {
            return InventoryManager.getInstance().shortcutBarSpells;
         }
         return new Array();
      }
      
      [Untrusted]
      public function getFakeItemMount() : MountWrapper
      {
         if(PlayedCharacterManager.getInstance().mount)
         {
            return MountWrapper.create();
         }
         return null;
      }
      
      [Untrusted]
      public function getBestEquipablePosition(param1:Object) : int
      {
         var _loc4_:int = 0;
         var _loc5_:ItemType = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:int = param1.type.superTypeId;
         if(param1 && (param1.isLivingObject || param1.isWrapperObject))
         {
            _loc4_ = 0;
            if(param1.isLivingObject)
            {
               _loc4_ = param1.livingObjectCategory;
            }
            else
            {
               _loc4_ = param1.wrapperObjectCategory;
            }
            _loc5_ = ItemType.getItemTypeById(_loc4_);
            if(_loc5_)
            {
               _loc2_ = _loc5_.superTypeId;
            }
         }
         var _loc3_:Object = this.itemSuperTypeToServerPosition(_loc2_);
         if(_loc3_ && _loc3_.length)
         {
            _loc6_ = this.getViewContent("equipment");
            _loc7_ = -1;
            for each(_loc8_ in _loc3_)
            {
               if(_loc6_[_loc8_] && _loc6_[_loc8_].objectGID == param1.objectGID && (param1.typeId != 9 || param1.belongsToSet))
               {
                  _loc7_ = _loc8_;
                  break;
               }
            }
            if(_loc7_ == -1)
            {
               for each(_loc8_ in _loc3_)
               {
                  if(!_loc6_[_loc8_])
                  {
                     _loc7_ = _loc8_;
                     break;
                  }
               }
            }
            if(_loc7_ == -1)
            {
               if(!_lastItemPosition[param1.type.superTypeId])
               {
                  _lastItemPosition[param1.type.superTypeId] = 0;
               }
               _loc9_ = ++_lastItemPosition[param1.type.superTypeId];
               if(_loc9_ >= _loc3_.length)
               {
                  _loc9_ = 0;
               }
               _lastItemPosition[param1.type.superTypeId] = _loc9_;
               _loc7_ = _loc3_[_loc9_];
            }
         }
         return _loc7_;
      }
      
      [Untrusted]
      public function addItemMask(param1:int, param2:String, param3:int) : void
      {
         InventoryManager.getInstance().inventory.addItemMask(param1,param2,param3);
      }
      
      [Untrusted]
      public function removeItemMask(param1:int, param2:String) : void
      {
         InventoryManager.getInstance().inventory.removeItemMask(param1,param2);
      }
      
      [Untrusted]
      public function removeAllItemMasks(param1:String) : void
      {
         InventoryManager.getInstance().inventory.removeAllItemMasks(param1);
      }
      
      [Untrusted]
      public function releaseHooks() : void
      {
         InventoryManager.getInstance().inventory.releaseHooks();
      }
      
      [Untrusted]
      public function releaseBankHooks() : void
      {
         InventoryManager.getInstance().bankInventory.releaseHooks();
      }
      
      [Untrusted]
      public function dracoTurkyInventoryWeight() : uint
      {
         var _loc1_:MountFrame = Kernel.getWorker().getFrame(MountFrame) as MountFrame;
         return _loc1_.inventoryWeight;
      }
      
      [Untrusted]
      public function dracoTurkyMaxInventoryWeight() : uint
      {
         var _loc1_:MountFrame = Kernel.getWorker().getFrame(MountFrame) as MountFrame;
         return _loc1_.inventoryMaxWeight;
      }
      
      [Untrusted]
      public function getStorageTypes(param1:int) : Array
      {
         var _loc4_:Object = null;
         var _loc2_:Array = new Array();
         var _loc3_:Dictionary = StorageOptionManager.getInstance().getCategoryTypes(param1);
         if(!_loc3_)
         {
            return null;
         }
         for each(_loc4_ in _loc3_)
         {
            _loc2_.push(_loc4_);
         }
         _loc2_.sort(this.sortStorageTypes);
         return _loc2_;
      }
      
      private function sortStorageTypes(param1:Object, param2:Object) : int
      {
         return -StringUtils.noAccent(param2.name).localeCompare(StringUtils.noAccent(param1.name));
      }
      
      [Untrusted]
      public function getBankStorageTypes(param1:int) : Array
      {
         var _loc4_:Object = null;
         var _loc2_:Array = new Array();
         var _loc3_:Dictionary = StorageOptionManager.getInstance().getBankCategoryTypes(param1);
         if(!_loc3_)
         {
            return null;
         }
         for each(_loc4_ in _loc3_)
         {
            _loc2_.push(_loc4_);
         }
         _loc2_.sortOn("name");
         return _loc2_;
      }
      
      [Untrusted]
      public function setDisplayedCategory(param1:int) : void
      {
         StorageOptionManager.getInstance().category = param1;
      }
      
      [Untrusted]
      public function setDisplayedBankCategory(param1:int) : void
      {
         StorageOptionManager.getInstance().bankCategory = param1;
      }
      
      [Untrusted]
      public function getDisplayedCategory() : int
      {
         return StorageOptionManager.getInstance().category;
      }
      
      [Untrusted]
      public function getDisplayedBankCategory() : int
      {
         return StorageOptionManager.getInstance().bankCategory;
      }
      
      [Untrusted]
      public function setStorageFilter(param1:int) : void
      {
         StorageOptionManager.getInstance().filter = param1;
      }
      
      [Untrusted]
      public function setBankStorageFilter(param1:int) : void
      {
         StorageOptionManager.getInstance().bankFilter = param1;
      }
      
      [Untrusted]
      public function getStorageFilter() : int
      {
         return StorageOptionManager.getInstance().filter;
      }
      
      [Untrusted]
      public function getBankStorageFilter() : int
      {
         return StorageOptionManager.getInstance().bankFilter;
      }
      
      [Untrusted]
      public function updateStorageView() : void
      {
         StorageOptionManager.getInstance().updateStorageView();
      }
      
      [Untrusted]
      public function updateBankStorageView() : void
      {
         StorageOptionManager.getInstance().updateBankStorageView();
      }
      
      [Untrusted]
      public function sort(param1:int, param2:Boolean) : void
      {
         StorageOptionManager.getInstance().sortRevert = param2;
         StorageOptionManager.getInstance().sortField = param1;
      }
      
      [Untrusted]
      public function resetSort() : void
      {
         StorageOptionManager.getInstance().resetSort();
      }
      
      [Untrusted]
      public function sortBank(param1:int, param2:Boolean) : void
      {
         StorageOptionManager.getInstance().sortBankRevert = param2;
         StorageOptionManager.getInstance().sortBankField = param1;
      }
      
      [Untrusted]
      public function resetBankSort() : void
      {
         StorageOptionManager.getInstance().resetBankSort();
      }
      
      [Untrusted]
      public function getSortFields() : Array
      {
         return StorageOptionManager.getInstance().sortFields;
      }
      
      [Untrusted]
      public function getSortBankFields() : Array
      {
         return StorageOptionManager.getInstance().sortBankFields;
      }
      
      [Untrusted]
      public function unsort() : void
      {
         StorageOptionManager.getInstance().sortField = StorageOptionManager.SORT_FIELD_NONE;
      }
      
      [Untrusted]
      public function unsortBank() : void
      {
         StorageOptionManager.getInstance().sortBankField = StorageOptionManager.SORT_FIELD_NONE;
      }
      
      [Untrusted]
      public function enableBidHouseFilter(param1:Object, param2:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc3_:Vector.<uint> = new Vector.<uint>();
         for each(_loc4_ in param1)
         {
            _loc3_.push(_loc4_);
         }
         StorageOptionManager.getInstance().enableBidHouseFilter(_loc3_,param2);
      }
      
      [Untrusted]
      public function disableBidHouseFilter() : void
      {
         StorageOptionManager.getInstance().disableBidHouseFilter();
      }
      
      [Untrusted]
      public function getIsBidHouseFilterEnabled() : Boolean
      {
         return StorageOptionManager.getInstance().getIsBidHouseFilterEnabled();
      }
      
      [Untrusted]
      public function enableSmithMagicFilter(param1:Object) : void
      {
         StorageOptionManager.getInstance().enableSmithMagicFilter(param1 as Skill);
      }
      
      [Untrusted]
      public function disableSmithMagicFilter() : void
      {
         StorageOptionManager.getInstance().disableSmithMagicFilter();
      }
      
      [Untrusted]
      public function getIsCraftFilterEnabled() : Boolean
      {
         return StorageOptionManager.getInstance().getIsCraftFilterEnabled();
      }
      
      [Untrusted]
      public function enableCraftFilter(param1:Object, param2:int) : void
      {
         StorageOptionManager.getInstance().enableCraftFilter(param1 as Skill,param2);
      }
      
      [Untrusted]
      public function disableCraftFilter() : void
      {
         StorageOptionManager.getInstance().disableCraftFilter();
      }
      
      [Untrusted]
      public function getIsSmithMagicFilterEnabled() : Boolean
      {
         return StorageOptionManager.getInstance().getIsSmithMagicFilterEnabled();
      }
      
      [Untrusted]
      public function getItemMaskCount(param1:int, param2:String) : int
      {
         return InventoryManager.getInstance().inventory.getItemMaskCount(param1,param2);
      }
   }
}
