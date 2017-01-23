package ui
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2enums.LocationEnum;
   import d2hooks.InventoryWeight;
   import d2hooks.KamasUpdate;
   import d2hooks.ShortcutsMovementAllowed;
   import d2hooks.StorageFilterUpdated;
   import d2hooks.StorageViewContent;
   import ui.behavior.CraftBehavior;
   
   public class StorageUi extends AbstractStorageUi
   {
       
      
      public var btn_itemsFilter:ButtonContainer;
      
      public var btn_label_btn_itemsFilter:Label;
      
      public var ignoreSubFilterInMain:Boolean = false;
      
      private var _saveCategory:Boolean = true;
      
      public function StorageUi()
      {
         super();
      }
      
      public function set saveCategory(param1:Boolean) : void
      {
         this._saveCategory = param1;
      }
      
      public function get saveCategory() : Boolean
      {
         return this._saveCategory;
      }
      
      override public function set categoryFilter(param1:int) : void
      {
         var _loc2_:ButtonContainer = this.getButtonFromCategory(param1);
         if(this._saveCategory)
         {
            sysApi.setData("lastStorageTab",_loc2_.name);
         }
         super.categoryFilter = param1;
         storageApi.setDisplayedCategory(categoryFilter);
         sysApi.dispatchHook(StorageFilterUpdated,grid.dataProvider,categoryFilter);
      }
      
      override public function set subFilter(param1:int) : void
      {
         var _loc3_:Object = null;
         updateSubFilter(this.getStorageTypes(categoryFilter));
         var _loc2_:Boolean = false;
         for each(_loc3_ in super.cb_category.dataProvider)
         {
            if(_loc3_.filterType == param1)
            {
               _loc2_ = true;
               break;
            }
         }
         if(!_loc2_)
         {
            param1 = -1;
         }
         storageApi.setStorageFilter(param1);
         if(this._saveCategory)
         {
            sysApi.setData("lastSubFilter",param1);
         }
         super.subFilter = param1;
      }
      
      override public function main(param1:Object) : void
      {
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc2_:Object = storageApi.getViewContent("storage");
         var _loc3_:int = playerApi.characteristics().kamas;
         var _loc4_:int = playerApi.inventoryWeight();
         var _loc5_:int = playerApi.inventoryWeightMax();
         this.hideFilter();
         var _loc6_:int = sysApi.getData("lastSubFilter");
         var _loc7_:String = sysApi.getData("lastStorageTab");
         if(_loc7_)
         {
            this.categoryFilter = this.getCategoryFromButton(this[_loc7_]);
         }
         else
         {
            _loc8_ = -1;
            for each(_loc9_ in _loc2_)
            {
               if(_loc9_.position == 63 && (_loc9_.category == EQUIPEMENT_CATEGORY || _loc9_.category == CONSUMABLES_CATEGORY || _loc9_.category == RESSOURCES_CATEGORY || _loc9_.category == QUEST_CATEGORY) && (_loc9_.category < _loc8_ || _loc8_ == -1))
               {
                  _loc8_ = _loc9_.category;
                  if(_loc8_ == 0)
                  {
                     break;
                  }
               }
            }
            if(_loc8_ == -1)
            {
               _loc8_ = EQUIPEMENT_CATEGORY;
            }
            this.categoryFilter = _loc8_;
         }
         super.main(param1);
         super.updateSubFilter(this.getStorageTypes(categoryFilter));
         if(!this.ignoreSubFilterInMain)
         {
            if(_loc6_ != 0)
            {
               this.subFilter = _loc6_;
            }
            _tabFilter[categoryFilter] = subFilter;
         }
         this.ignoreSubFilterInMain = false;
         if(param1.storageMod == "craft" && (_storageBehavior as CraftBehavior).craftUi && (_storageBehavior as CraftBehavior).craftUi.skill && (_storageBehavior as CraftBehavior).craftUi.skill.id == 209)
         {
            this.btn_itemsFilter.selected = false;
            this.btn_itemsFilter.disabled = true;
         }
         else
         {
            uiApi.addComponentHook(this.btn_itemsFilter,"onRelease");
         }
         if(!uiApi.getUi(UIEnum.SMILEY_UI))
         {
            sysApi.dispatchHook(ShortcutsMovementAllowed,true);
         }
         sysApi.addHook(StorageViewContent,this.onInventoryUpdate);
         sysApi.addHook(KamasUpdate,onKamasUpdate);
         sysApi.addHook(InventoryWeight,onInventoryWeight);
         this.onInventoryUpdate(_loc2_,_loc3_);
         onInventoryWeight(_loc4_,_loc5_);
         this.releaseHooks();
      }
      
      override public function unload() : void
      {
         sysApi.removeHook(StorageViewContent);
         sysApi.removeHook(KamasUpdate);
         sysApi.removeHook(InventoryWeight);
         if(!uiApi.getUi(UIEnum.SMILEY_UI) && sysApi.isFightContext())
         {
            sysApi.dispatchHook(ShortcutsMovementAllowed,false);
         }
         super.unload();
      }
      
      override public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         switch(param1)
         {
            case btnAll:
            case btnEquipable:
            case btnConsumables:
            case btnRessources:
               sysApi.setData("lastStorageTab",param1.name);
               break;
            case btnQuest:
               sysApi.setData("lastStorageTab",param1.name);
               onReleaseCategoryFilter(btnQuest);
               break;
            case btn_moveAllToLeft:
            case btn_moveAllToRight:
               _loc2_ = new Array();
               _loc2_.push(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.storage.getAll"),_storageBehavior.transfertAll,null,false,null,false,true));
               _loc2_.push(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.storage.getVisible"),_storageBehavior.transfertList,null,false,null,false,true));
               _loc2_.push(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.storage.getExisting"),_storageBehavior.transfertExisting,null,false,null,false,true));
               modContextMenu.createContextMenu(_loc2_);
               break;
            case this.btn_itemsFilter:
               _storageBehavior.filterStatus(this.btn_itemsFilter.selected);
         }
         super.onRelease(param1);
      }
      
      override public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         switch(param1)
         {
            case btnQuest:
               _loc2_ = uiApi.getText("ui.common.quest.objects");
               break;
            case btn_moveAllToLeft:
            case btn_moveAllToRight:
               _loc2_ = uiApi.getText("ui.storage.advancedTransferts");
         }
         if(_loc2_)
         {
            uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
         }
         else
         {
            super.onRollOver(param1);
         }
      }
      
      override public function getButtonFromCategory(param1:int) : ButtonContainer
      {
         switch(param1)
         {
            case QUEST_CATEGORY:
               return btnQuest;
            default:
               return super.getButtonFromCategory(param1);
         }
      }
      
      override public function getCategoryFromButton(param1:ButtonContainer) : int
      {
         switch(param1)
         {
            case btnQuest:
               return QUEST_CATEGORY;
            default:
               return super.getCategoryFromButton(param1);
         }
      }
      
      public function showFilter(param1:String, param2:Boolean) : void
      {
         if(this.btn_itemsFilter)
         {
            this.btn_itemsFilter.visible = true;
            ctr_common.y = -26;
            ctr_window.height = 850;
            this.btn_label_btn_itemsFilter.text = param1;
            this.btn_itemsFilter.selected = param2;
         }
      }
      
      public function hideFilter() : void
      {
         if(this.btn_itemsFilter)
         {
            this.btn_itemsFilter.visible = false;
         }
      }
      
      override protected function onInventoryUpdate(param1:Object, param2:uint) : void
      {
         _ignoreQuestItems = !questVisible;
         super.onInventoryUpdate(param1,param2);
      }
      
      override protected function getStorageTypes(param1:int) : Object
      {
         return storageApi.getStorageTypes(param1);
      }
      
      override protected function releaseHooks() : void
      {
         storageApi.releaseHooks();
      }
      
      override protected function sortOn(param1:int, param2:Boolean = false) : void
      {
         storageApi.resetSort();
         this.addSort(param1);
      }
      
      override protected function addSort(param1:int) : void
      {
         storageApi.sort(param1,false);
         this.releaseHooks();
      }
      
      override protected function getSortFields() : Object
      {
         return storageApi.getSortFields();
      }
      
      override protected function initSound() : void
      {
         btnQuest.soundId = SoundEnum.TAB;
         super.initSound();
      }
   }
}
