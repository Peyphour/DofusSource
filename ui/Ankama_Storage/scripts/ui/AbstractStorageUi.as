package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.LocationEnum;
   import d2enums.SelectMethodEnum;
   import d2enums.SoundTypeEnum;
   import d2hooks.DropEnd;
   import d2hooks.DropStart;
   import d2hooks.KeyUp;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import ui.behavior.IStorageBehavior;
   import ui.enum.StorageState;
   import util.StorageBehaviorManager;
   
   public class AbstractStorageUi
   {
      
      public static const ALL_CATEGORY:int = -1;
      
      public static const EQUIPEMENT_CATEGORY:int = 0;
      
      public static const CONSUMABLES_CATEGORY:int = 1;
      
      public static const RESSOURCES_CATEGORY:int = 2;
      
      public static const QUEST_CATEGORY:int = 3;
      
      public static const OTHER_CATEGORY:int = 4;
      
      public static const SUBFILTER_ID_TOKEN:int = 148;
      
      public static const SUBFILTER_ID_PRECIOUS_STONE:int = 50;
      
      protected static const SORT_ON_NONE:int = -1;
      
      protected static const SORT_ON_DEFAULT:int = 0;
      
      protected static const SORT_ON_NAME:int = 1;
      
      protected static const SORT_ON_WEIGHT:int = 2;
      
      protected static const SORT_ON_QTY:int = 3;
      
      protected static const SORT_ON_LOT_WEIGHT:int = 4;
      
      protected static const SORT_ON_AVERAGEPRICE:int = 5;
      
      protected static const SORT_ON_LOT_AVERAGEPRICE:int = 6;
      
      protected static const SORT_ON_LEVEL:int = 7;
      
      protected static const SORT_ON_ITEM_TYPE:int = 8;
      
      protected static var _tabFilter:Dictionary = new Dictionary();
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var storageApi:StorageApi;
      
      public var menuApi:ContextMenuApi;
      
      public var tooltipApi:TooltipApi;
      
      public var dataApi:DataApi;
      
      public var averagePricesApi:AveragePricesApi;
      
      public var soundApi:SoundApi;
      
      public var utilApi:UtilApi;
      
      public var playerApi:PlayedCharacterApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private var INPUT_SEARCH_DEFAULT_TEXT:String;
      
      private var _inventoryItems:Object;
      
      private var _currentCategoryFilter:int;
      
      private var _updateInventoryTimer:Timer;
      
      private var _delayUseObject:Boolean = false;
      
      private var _delayUseObjectTimer:Timer;
      
      private var _hasWorldInteraction:Boolean;
      
      private var _gridAllowDrop:Dictionary;
      
      private var _sortLabels:Array;
      
      private var _currentSort:int = -1;
      
      private var _savedSearchByCategory:Dictionary;
      
      private var _savedSortByCategory:Dictionary;
      
      protected var _storageBehavior:IStorageBehavior;
      
      protected var _storageBehaviorName:String;
      
      protected var _dataProvider:Object;
      
      protected var _searchCriteria:String;
      
      protected var _lastSearchCriteria:String;
      
      protected var _searchTimer:Timer;
      
      protected var _weight:uint;
      
      protected var _weightMax:uint;
      
      protected var _currentEstimatedValue:String;
      
      protected var _hasSlot:Boolean = false;
      
      protected var _slotsMax:uint;
      
      protected var _ignoreQuestItems:Boolean = false;
      
      public var itemsDisplayed:Vector.<uint>;
      
      public var subFilterIndex:Object;
      
      public var mainCtr:GraphicContainer;
      
      public var ctr_common:GraphicContainer;
      
      public var ctr_kamas:GraphicContainer;
      
      public var ctr_window:GraphicContainer;
      
      public var txBackground:Texture;
      
      public var tx_weightBar:Texture;
      
      public var grid:Grid;
      
      public var cb_category:ComboBox;
      
      public var lbl_kamas:Label;
      
      public var lbl_title:Label;
      
      public var btn_close:ButtonContainer;
      
      public var btn_moveAllToLeft:ButtonContainer;
      
      public var btn_moveAllToRight:ButtonContainer;
      
      public var btnAll:ButtonContainer;
      
      public var btnEquipable:ButtonContainer;
      
      public var btnConsumables:ButtonContainer;
      
      public var btnRessources:ButtonContainer;
      
      public var btnQuest:ButtonContainer;
      
      public var btnSet:ButtonContainer;
      
      public var btn_options:ButtonContainer;
      
      public var btn_checkCraft:ButtonContainer;
      
      public var btn_closeSearch:ButtonContainer;
      
      public var inp_search:Input;
      
      public var txKamaBackground:Texture;
      
      public var lbl_itemsEstimatedValue:Label;
      
      public var ctr_itemsEstimatedValue:GraphicContainer;
      
      public function AbstractStorageUi()
      {
         this._gridAllowDrop = new Dictionary();
         this._savedSearchByCategory = new Dictionary();
         this._savedSortByCategory = new Dictionary();
         this.subFilterIndex = new Object();
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:int = 0;
         this.initSound();
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.sysApi.addHook(DropStart,this.onDropStart);
         this.sysApi.addHook(DropEnd,this.onDropEnd);
         this.uiApi.addComponentHook(this.btnAll,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btnAll,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btnAll,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btnEquipable,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btnEquipable,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btnEquipable,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btnConsumables,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btnConsumables,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btnConsumables,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btnRessources,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btnRessources,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btnRessources,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btnQuest,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btnQuest,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btnQuest,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_checkCraft,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_checkCraft,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_options,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_options,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.cb_category,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.ctr_kamas,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.lbl_kamas,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_kamas,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_itemsEstimatedValue,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_itemsEstimatedValue,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ctr_itemsEstimatedValue,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_itemsEstimatedValue,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_weightBar,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_weightBar,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_moveAllToLeft,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_moveAllToLeft,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_moveAllToLeft,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_moveAllToRight,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_moveAllToRight,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_moveAllToRight,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.grid,ComponentHookList.ON_ITEM_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.grid,ComponentHookList.ON_ITEM_ROLL_OVER);
         this.uiApi.addComponentHook(this.grid,ComponentHookList.ON_ITEM_ROLL_OUT);
         this.uiApi.addComponentHook(this.grid,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addShortcutHook("closeUi",this.onShortCut);
         this.grid.renderer.dropValidatorFunction = this.dropValidator;
         this.grid.renderer.processDropFunction = this.processDrop;
         this.grid.renderer.removeDropSourceFunction = this.removeDropSourceFunction;
         this.grid.renderer.allowDrop = true;
         this._sortLabels = new Array();
         this._sortLabels[SORT_ON_NAME] = this.uiApi.getText("ui.common.sortBy.name");
         this._sortLabels[SORT_ON_WEIGHT] = this.uiApi.getText("ui.common.sortBy.weight");
         this._sortLabels[SORT_ON_LOT_WEIGHT] = this.uiApi.getText("ui.common.sortBy.weight.lot");
         this._sortLabels[SORT_ON_QTY] = this.uiApi.getText("ui.common.sortBy.quantity");
         this._sortLabels[SORT_ON_AVERAGEPRICE] = this.uiApi.getText("ui.common.sortBy.averageprice");
         this._sortLabels[SORT_ON_LOT_AVERAGEPRICE] = this.uiApi.getText("ui.common.sortBy.averageprice.lot");
         this._sortLabels[SORT_ON_LEVEL] = this.uiApi.getText("ui.common.sortBy.level");
         this._sortLabels[SORT_ON_ITEM_TYPE] = this.uiApi.getText("ui.common.sortBy.category");
         if(!this._searchTimer)
         {
            this._searchTimer = new Timer(200,1);
            this._searchTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onSearchTimerComplete);
         }
         this.INPUT_SEARCH_DEFAULT_TEXT = this.uiApi.getText("ui.search.inventory");
         this.inp_search.text = this.INPUT_SEARCH_DEFAULT_TEXT;
         this.questVisible = true;
         this.presetVisible = false;
         this.btn_moveAllToLeft.visible = false;
         this.btn_moveAllToRight.visible = false;
         this.btn_closeSearch.visible = false;
         if(this._hasSlot && this._slotsMax != 0)
         {
            _loc2_ = Math.floor(100 * this._inventoryItems.length / this._slotsMax);
            this.tx_weightBar.gotoAndStop = _loc2_ > 100?100:_loc2_;
         }
         this.switchBehavior(param1.storageMod);
         if(param1.storageMod == "craft")
         {
            this.btn_checkCraft.visible = false;
         }
      }
      
      public function unload() : void
      {
         this._searchCriteria = null;
         this._lastSearchCriteria = null;
         if(this._searchTimer)
         {
            this._searchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onSearchTimerComplete);
            this._searchTimer = null;
         }
         if(this._updateInventoryTimer)
         {
            this._updateInventoryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onUpdateTimerComplete);
            this._updateInventoryTimer = null;
         }
         if(this.uiApi.getUi("quantityPopup"))
         {
            this.uiApi.unloadUi("quantityPopup");
         }
         if(this._storageBehavior)
         {
            this._storageBehavior.onUnload();
         }
         this._storageBehavior.detach();
         this._storageBehavior = null;
         this.soundApi.playSound(SoundTypeEnum.INVENTORY_CLOSE);
         this.uiApi.hideTooltip();
         this.uiApi.unloadUi("livingObject");
         if(this.uiApi.getUi("checkCraft"))
         {
            this.uiApi.unloadUi("checkCraft");
         }
         if(this._hasWorldInteraction)
         {
            Api.system.enableWorldInteraction();
         }
      }
      
      public function getWeightMax() : uint
      {
         return this._weightMax;
      }
      
      public function getWeight() : uint
      {
         return this._weight;
      }
      
      public function set categoryFilter(param1:int) : void
      {
         this.saveTabState();
         if(!this.questVisible && param1 == QUEST_CATEGORY)
         {
            param1 = EQUIPEMENT_CATEGORY;
         }
         this._currentCategoryFilter = param1;
         this.resumeTabState();
         var _loc2_:ButtonContainer = this.getButtonFromCategory(param1);
         _loc2_.selected = true;
         if(this.subFilter != 0)
         {
            this.subFilter = this.subFilter;
         }
         else if(_tabFilter[param1])
         {
            this.subFilter = _tabFilter[param1];
         }
         else
         {
            this.subFilter = -1;
         }
      }
      
      private function resumeTabState() : void
      {
         var _loc1_:Object = this._savedSearchByCategory[this._currentCategoryFilter];
         if(_loc1_ && _loc1_ != this._currentCategoryFilter)
         {
            this.inp_search.text = this._savedSearchByCategory[this._currentCategoryFilter];
         }
         else
         {
            this.inp_search.text = this.INPUT_SEARCH_DEFAULT_TEXT;
         }
         this._searchCriteria = this._savedSearchByCategory[this._currentCategoryFilter];
         var _loc2_:Object = this._savedSortByCategory[this._currentCategoryFilter];
         if(_loc2_ && _loc2_ != this._currentSort)
         {
            this._currentSort = int(_loc2_);
            this.sortOn(int(_loc2_));
         }
         else if(!_loc2_ && this._currentSort != SORT_ON_NONE)
         {
            this._currentSort = -1;
            this.sortOn(SORT_ON_NONE);
         }
      }
      
      private function saveTabState() : void
      {
         this._savedSearchByCategory[this._currentCategoryFilter] = this._searchCriteria;
         this._savedSortByCategory[this._currentCategoryFilter] = this._currentSort;
      }
      
      public function get categoryFilter() : int
      {
         return this._currentCategoryFilter;
      }
      
      public function set subFilter(param1:int) : void
      {
         var _loc2_:ButtonContainer = this.getButtonFromCategory(this.categoryFilter);
         this.subFilterIndex[_loc2_.name] = param1;
      }
      
      public function get subFilter() : int
      {
         var _loc1_:ButtonContainer = this.getButtonFromCategory(this.categoryFilter);
         return this.subFilterIndex[_loc1_.name];
      }
      
      public function get currentStorageBehavior() : IStorageBehavior
      {
         return this._storageBehavior;
      }
      
      public function set questVisible(param1:Boolean) : void
      {
         this.btnQuest.visible = param1;
         if(!this.btnQuest.visible && this.categoryFilter == QUEST_CATEGORY)
         {
            this.categoryFilter = EQUIPEMENT_CATEGORY;
         }
         this.replaceCategoryButtons();
      }
      
      public function get questVisible() : Boolean
      {
         return this.btnQuest.visible;
      }
      
      public function set presetVisible(param1:Boolean) : void
      {
         this.btnSet.visible = param1;
         this.replaceCategoryButtons();
      }
      
      public function get presetVisible() : Boolean
      {
         return this.btnSet.visible;
      }
      
      public function get kamas() : int
      {
         return this.utilApi.stringToKamas(this.lbl_kamas.text,"");
      }
      
      protected function onInventoryUpdate(param1:Object, param2:uint) : void
      {
         this._inventoryItems = param1;
         if(this.cb_category && this.cb_category.dataProvider && (!this._inventoryItems || !this._inventoryItems.length) && this.subFilter != -1)
         {
            this.cb_category.selectedItem = this.cb_category.dataProvider[0];
            this.onSelectItem(this.cb_category,SelectMethodEnum.CLICK,true);
            return;
         }
         this.onKamasUpdate(param2);
         if(!this._updateInventoryTimer)
         {
            this._updateInventoryTimer = new Timer(50,1);
            this._updateInventoryTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onUpdateTimerComplete);
         }
         if(!this._updateInventoryTimer.running)
         {
            this._updateInventoryTimer.start();
         }
      }
      
      protected function onKamasUpdate(param1:uint) : void
      {
         this.lbl_kamas.text = this.utilApi.kamasToString(param1,"");
      }
      
      protected function onInventoryWeight(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         this._weight = param1;
         this._weightMax = param2;
         if(this.tx_weightBar)
         {
            _loc3_ = Math.floor(100 * param1 / param2);
            if(_loc3_ > 100)
            {
               _loc3_ = 100;
            }
            this.tx_weightBar.gotoAndStop = _loc3_;
         }
      }
      
      protected function onUpdateTimerComplete(param1:TimerEvent) : void
      {
         this._updateInventoryTimer.reset();
         this.updateInventory();
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this.inp_search.haveFocus && this.inp_search.text != this.INPUT_SEARCH_DEFAULT_TEXT)
         {
            if(this.inp_search.text.length)
            {
               this._searchCriteria = this.utilApi.noAccent(this.inp_search.text).toLowerCase();
               this.btn_closeSearch.visible = true;
            }
            else if(this._searchCriteria)
            {
               this._searchCriteria = null;
               this._lastSearchCriteria = null;
               this.btn_closeSearch.visible = false;
            }
            this._searchTimer.reset();
            this._searchTimer.start();
         }
      }
      
      protected function onDropStart(param1:Object) : void
      {
         if(param1.getUi() == this.uiApi.me())
         {
            this._hasWorldInteraction = Api.system.hasWorldInteraction();
            if(this._hasWorldInteraction)
            {
               Api.system.disableWorldInteraction();
            }
         }
      }
      
      protected function onDropEnd(param1:Object) : void
      {
         if(param1.getUi() == this.uiApi.me())
         {
            if(this._hasWorldInteraction)
            {
               Api.system.enableWorldInteraction();
            }
         }
      }
      
      protected function dropValidator(param1:Object, param2:Object, param3:Object) : Boolean
      {
         return this._storageBehavior.dropValidator(param1,param2,param3);
      }
      
      protected function processDrop(param1:Object, param2:Object, param3:Object) : void
      {
         return this._storageBehavior.processDrop(param1,param2,param3);
      }
      
      protected function removeDropSourceFunction(param1:Object) : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         switch(param1)
         {
            case this.btnAll:
            case this.btnEquipable:
            case this.btnConsumables:
            case this.btnRessources:
               this.setDropAllowed(true,"filter");
               this.onReleaseCategoryFilter(param1 as ButtonContainer);
               break;
            case this.btn_checkCraft:
               this.onReleaseCheckCraftBtn();
               break;
            case this.btn_options:
               _loc2_ = new Array();
               this.fillContextMenu(_loc2_,null,false);
               _loc2_.unshift(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.common.options")));
               this.modContextMenu.createContextMenu(_loc2_);
               break;
            case this.inp_search:
               if(this.inp_search.text == this.INPUT_SEARCH_DEFAULT_TEXT)
               {
                  this.inp_search.text = "";
               }
               break;
            case this.btn_closeSearch:
               if(this.inp_search.text != this.INPUT_SEARCH_DEFAULT_TEXT)
               {
                  this.inp_search.text = this.INPUT_SEARCH_DEFAULT_TEXT;
                  this._searchCriteria = null;
                  this._lastSearchCriteria = null;
                  this.updateInventory();
                  this.btn_closeSearch.visible = false;
               }
               break;
            case this.btn_close:
               this.onClose();
               break;
            default:
               this._storageBehavior.onRelease(param1);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         switch(param1)
         {
            case this.btnAll:
               _loc2_ = this.uiApi.getText("ui.common.all");
               break;
            case this.btnEquipable:
               _loc2_ = this.uiApi.getText("ui.common.equipement");
               break;
            case this.btnConsumables:
               _loc2_ = this.uiApi.getText("ui.common.usableItems");
               break;
            case this.btnRessources:
               _loc2_ = this.uiApi.getText("ui.common.ressources");
               break;
            case this.btnQuest:
               _loc2_ = this.uiApi.getText("ui.common.quest.objects");
               break;
            case this.btn_moveAllToLeft:
            case this.btn_moveAllToRight:
               _loc2_ = this.uiApi.getText("ui.storage.advancedTransferts");
               break;
            case this.tx_weightBar:
               if(this._hasSlot)
               {
                  _loc2_ = this.uiApi.getText("ui.common.player.slot",this._slotsMax <= 0?"0":this.utilApi.kamasToString(this._inventoryItems.length,""),this.utilApi.kamasToString(this._slotsMax,""));
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.common.player.weight",this.utilApi.kamasToString(this._weight,""),this.utilApi.kamasToString(this._weightMax,""));
               }
               break;
            case this.lbl_itemsEstimatedValue:
            case this.ctr_itemsEstimatedValue:
               _loc2_ = this.uiApi.getText("ui.storage.estimatedValue");
               break;
            case this.lbl_kamas:
               _loc2_ = this.uiApi.getText("ui.storage.ownedKamas");
               break;
            case this.btn_checkCraft:
               _loc2_ = this.uiApi.getText("ui.craft.possibleRecipesTitle");
               break;
            case this.btn_options:
               _loc2_ = this.uiApi.getText("ui.common.options");
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         switch(param1)
         {
            case this.cb_category:
               if(param3 && param2 != SelectMethodEnum.AUTO && param2 != SelectMethodEnum.MANUAL)
               {
                  _loc4_ = param1.value;
                  this.subFilter = _loc4_.filterType;
                  _tabFilter[this.categoryFilter] = _loc4_.filterType;
                  this.releaseHooks();
               }
               return;
            default:
               this._storageBehavior.onSelectItem(param1,param2,param3);
               return;
         }
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         var _loc4_:Object = null;
         if(param2.data == null)
         {
            return;
         }
         var _loc3_:Object = param2.data;
         if(this._storageBehaviorName != StorageState.BAG_MOD)
         {
            _loc4_ = this.menuApi.create(_loc3_);
         }
         else
         {
            _loc4_ = this.menuApi.create(_loc3_,"item",[{"ownedItem":true}]);
         }
         var _loc5_:Boolean = _loc4_.content[0].disabled;
         this.fillContextMenu(_loc4_.content,_loc3_,_loc5_);
         this.modContextMenu.createContextMenu(_loc4_);
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         if(param2.data)
         {
            this.displayItemTooltip(this.grid,param2.data);
         }
      }
      
      protected function displayItemTooltip(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc5_:String = null;
         var _loc7_:* = undefined;
         if(!param3)
         {
            param3 = new Object();
         }
         var _loc4_:ItemTooltipSettings = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
         if(_loc4_ == null)
         {
            _loc4_ = this.tooltipApi.createItemSettings();
            this.sysApi.setData("itemTooltipSettings",_loc4_,DataStoreEnum.BIND_ACCOUNT);
         }
         var _loc6_:* = this.sysApi.getObjectVariables(_loc4_);
         for each(_loc5_ in _loc6_)
         {
            param3[_loc5_] = _loc4_[_loc5_];
         }
         _loc7_ = param1["localToGlobal"](new Point(0,0));
         this.uiApi.showTooltip(param2,param1,false,"standard",_loc7_.x > 500?uint(LocationEnum.POINT_TOPRIGHT):uint(LocationEnum.POINT_TOPLEFT),_loc7_.x > 500?uint(LocationEnum.POINT_TOPLEFT):uint(LocationEnum.POINT_TOPRIGHT),20,null,null,param3);
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      protected function onShortCut(param1:String) : Boolean
      {
         if(param1 == "closeUi")
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         return false;
      }
      
      public function getButtonFromCategory(param1:int) : ButtonContainer
      {
         switch(param1)
         {
            case ALL_CATEGORY:
               return this.btnAll;
            case EQUIPEMENT_CATEGORY:
               return this.btnEquipable;
            case CONSUMABLES_CATEGORY:
               return this.btnConsumables;
            case RESSOURCES_CATEGORY:
               return this.btnRessources;
            default:
               throw new Error("Invalid category : " + param1);
         }
      }
      
      public function getCategoryFromButton(param1:ButtonContainer) : int
      {
         switch(param1)
         {
            case this.btnAll:
               return ALL_CATEGORY;
            case this.btnEquipable:
               return EQUIPEMENT_CATEGORY;
            case this.btnConsumables:
               return CONSUMABLES_CATEGORY;
            case this.btnRessources:
               return RESSOURCES_CATEGORY;
            default:
               throw new Error("Invalid button : " + param1);
         }
      }
      
      public function switchBehavior(param1:String) : void
      {
         if(this._storageBehavior)
         {
            this._storageBehavior.detach();
         }
         this._storageBehavior = StorageBehaviorManager.makeBehavior(param1);
         this._storageBehavior.attach(this);
         this._storageBehaviorName = param1;
      }
      
      public function updateInventory() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Boolean = false;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         if(this._inventoryItems)
         {
            _loc4_ = new Array();
            this.itemsDisplayed = new Vector.<uint>();
            this.updateSubFilter(this.getStorageTypes(this.categoryFilter));
            if(this._searchCriteria)
            {
               _loc5_ = this._lastSearchCriteria && this._lastSearchCriteria.length < this._searchCriteria.length && this._searchCriteria.indexOf(this._lastSearchCriteria) != -1;
               _loc6_ = !!_loc5_?this.grid.dataProvider:this._inventoryItems;
               _loc2_ = _loc6_.length;
               _loc3_ = 0;
               for(; _loc3_ < _loc2_; _loc3_++)
               {
                  _loc1_ = _loc6_[_loc3_];
                  if(this._ignoreQuestItems && !_loc5_)
                  {
                     if(_loc1_.category == QUEST_CATEGORY)
                     {
                        continue;
                     }
                  }
                  if(_loc1_.undiatricalName.indexOf(this._searchCriteria) != -1 || _loc1_.searchContent.length > 0 && _loc1_.searchContent.indexOf(this._searchCriteria) != -1)
                  {
                     _loc4_.push(_loc1_);
                     this.itemsDisplayed.push(_loc1_.objectUID);
                     continue;
                  }
               }
               this.grid.dataProvider = _loc4_;
               this._lastSearchCriteria = this._searchCriteria;
            }
            else
            {
               _loc2_ = this._inventoryItems.length;
               _loc3_ = 0;
               for(; _loc3_ < _loc2_; _loc3_++)
               {
                  _loc1_ = this._inventoryItems[_loc3_];
                  if(this._ignoreQuestItems)
                  {
                     if(_loc1_.category == QUEST_CATEGORY)
                     {
                        continue;
                     }
                     _loc4_.push(_loc1_);
                  }
                  this.itemsDisplayed.push(_loc1_.objectUID);
               }
               if(this._ignoreQuestItems)
               {
                  this._inventoryItems = _loc4_;
               }
               this.grid.dataProvider = this._inventoryItems;
               this._lastSearchCriteria = null;
            }
            this._ignoreQuestItems = false;
            if(this._hasSlot && this._slotsMax != 0)
            {
               _loc7_ = Math.floor(100 * this._inventoryItems.length / this._slotsMax);
               this.tx_weightBar.gotoAndStop = _loc7_ > 100?100:_loc7_;
            }
            this.updateItemsEstimatedValue();
         }
      }
      
      public function name() : String
      {
         return this.uiApi.me().name;
      }
      
      protected function releaseHooks() : void
      {
         throw new Error("Error : releaseHooks is an abstract method. It\'s shouldn\'t be called");
      }
      
      public function setDropAllowed(param1:Boolean, param2:String) : void
      {
         var _loc3_:Boolean = false;
         this._gridAllowDrop[param2] = param1;
         for each(_loc3_ in this._gridAllowDrop)
         {
            if(!_loc3_)
            {
               this.grid.renderer.allowDrop = false;
               return;
            }
         }
         this.grid.renderer.allowDrop = true;
      }
      
      protected function onReleaseCategoryFilter(param1:ButtonContainer) : void
      {
         this._lastSearchCriteria = null;
         this.categoryFilter = this.getCategoryFromButton(param1);
         this.releaseHooks();
      }
      
      protected function onReleaseCheckCraftBtn() : void
      {
         var _loc1_:Object = this.uiApi.getUi("checkCraft");
         if(!_loc1_)
         {
            this.uiApi.loadUi("Ankama_Job::checkCraft","checkCraft",{"storage":this._storageBehaviorName});
         }
         else if(_loc1_.uiClass.storage != this._storageBehaviorName)
         {
            _loc1_.uiClass.main({"storage":this._storageBehaviorName});
         }
         else
         {
            this.uiApi.unloadUi("checkCraft");
         }
      }
      
      protected function onClose() : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      protected function fillContextMenu(param1:Array, param2:Object, param3:Boolean) : void
      {
         var _loc8_:Array = null;
         var _loc9_:* = undefined;
         var _loc4_:ItemTooltipSettings = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
         if(!_loc4_)
         {
            _loc4_ = this.tooltipApi.createItemSettings();
            this.sysApi.setData("itemTooltipSettings",_loc4_,DataStoreEnum.BIND_ACCOUNT);
         }
         if(param1.length)
         {
            param1.push(this.modContextMenu.createContextMenuSeparatorObject());
         }
         if(Api.system.getOption("displayTooltips","dofus"))
         {
            param1.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.tooltip"),null,null,false,[this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.name"),this.onTooltipDisplayOption,["header"],param3,null,_loc4_.header,false),this.modContextMenu.createContextMenuItemObject(this.uiApi.processText(this.uiApi.getText("ui.common.effects"),"",false),this.onTooltipDisplayOption,["effects"],param3,null,_loc4_.effects,false),this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.conditions"),this.onTooltipDisplayOption,["conditions"],param3,null,_loc4_.conditions,false),this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.description"),this.onTooltipDisplayOption,["description"],param3,null,_loc4_.description,false),this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.item.averageprice"),this.onTooltipDisplayOption,["averagePrice"],param3,null,_loc4_.averagePrice,false)],param3));
         }
         var _loc5_:int = this.getSortFields()[0];
         var _loc6_:Object = this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.sort"),null,null,false,null,param3);
         var _loc7_:Array = new Array();
         _loc7_.push(this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.sortBy.default"),this.updateSort,[SORT_ON_NONE],param3,null,_loc5_ == SORT_ON_NONE,true));
         for(_loc9_ in this._sortLabels)
         {
            _loc7_.push(this.modContextMenu.createContextMenuItemObject(this._sortLabels[_loc9_],this.updateSort,[_loc9_],param3,null,_loc5_ == _loc9_,true));
            if(_loc5_ != SORT_ON_NONE && _loc9_ != _loc5_)
            {
               if(!_loc8_)
               {
                  _loc8_ = new Array();
               }
               _loc8_.push(this.modContextMenu.createContextMenuItemObject(this._sortLabels[_loc9_],this.addSort,[_loc9_],false,null,this.getSortFields().indexOf(_loc9_) != -1,true));
            }
         }
         _loc7_.push(this.modContextMenu.createContextMenuSeparatorObject(),this.modContextMenu.createContextMenuItemObject(this.uiApi.getText("ui.common.sort.secondary"),null,null,_loc5_ == SORT_ON_NONE,_loc8_,false));
         _loc6_.child = _loc7_;
         param1.push(_loc6_);
      }
      
      protected function getSortFields() : Object
      {
         throw new Error("getSortField is abstract function, it must be implemented");
      }
      
      protected function getStorageTypes(param1:int) : Object
      {
         throw new Error("Error : getStorageTypes is abstract function. It must be override");
      }
      
      protected function initSound() : void
      {
         this.btnAll.soundId = SoundEnum.TAB;
         this.btnEquipable.soundId = SoundEnum.TAB;
         this.btnConsumables.soundId = SoundEnum.TAB;
         this.btnRessources.soundId = SoundEnum.TAB;
         this.btn_close.isMute = true;
      }
      
      private function onTooltipDisplayOption(param1:String) : void
      {
         var _loc2_:ItemTooltipSettings = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
         _loc2_[param1] = !_loc2_[param1];
         this.sysApi.setData("itemTooltipSettings",_loc2_,DataStoreEnum.BIND_ACCOUNT);
      }
      
      protected function updateSubFilter(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc2_:Array = new Array();
         for each(_loc5_ in param1)
         {
            _loc4_ = {
               "label":_loc5_.name,
               "filterType":_loc5_.id
            };
            if(_loc5_.id == this.subFilterIndex[this.getButtonFromCategory(this.categoryFilter).name])
            {
               _loc3_ = _loc4_;
            }
            _loc2_.push(_loc4_);
         }
         _loc4_ = {
            "label":this.uiApi.getText("ui.common.allTypesForObject"),
            "filterType":-1
         };
         if(!_loc3_)
         {
            _loc3_ = _loc4_;
         }
         _loc2_.unshift(_loc4_);
         this.cb_category.dataProvider = _loc2_;
         if(this.cb_category.value != _loc3_)
         {
            this.cb_category.value = _loc3_;
         }
      }
      
      private function updateItemsEstimatedValue() : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(this.grid.dataProvider.length == 0)
         {
            this.ctr_itemsEstimatedValue.visible = false;
            return;
         }
         this.ctr_itemsEstimatedValue.visible = true;
         var _loc1_:Number = 0;
         for each(_loc2_ in this.grid.dataProvider)
         {
            _loc3_ = this.averagePricesApi.getItemAveragePrice(_loc2_.objectGID);
            _loc1_ = _loc1_ + _loc3_ * _loc2_.quantity;
         }
         this._currentEstimatedValue = this.utilApi.kamasToString(_loc1_);
         this.lbl_itemsEstimatedValue.text = this._currentEstimatedValue;
      }
      
      private function updateSort(param1:int, param2:Boolean = false) : void
      {
         this._currentSort = param1;
         this.sortOn(param1,param2);
      }
      
      protected function sortOn(param1:int, param2:Boolean = false) : void
      {
         throw new Error("sortOn is an abstract method, it shouldn\'t be called");
      }
      
      protected function addSort(param1:int) : void
      {
         throw new Error("addSort is an abstract method, it shouldn\'t be called");
      }
      
      private function replaceCategoryButtons() : void
      {
         var _loc6_:ButtonContainer = null;
         var _loc1_:Array = new Array();
         _loc1_.push(this.btnAll);
         _loc1_.push(this.btnEquipable);
         _loc1_.push(this.btnConsumables);
         _loc1_.push(this.btnRessources);
         if(this.questVisible)
         {
            _loc1_.push(this.btnQuest);
         }
         if(this.presetVisible)
         {
            _loc1_.push(this.btnSet);
         }
         var _loc2_:int = _loc1_.length * this.btnAll.width + (_loc1_.length - 1);
         var _loc3_:int = 6 * this.btnAll.width + 5;
         var _loc4_:int = int((_loc3_ - _loc2_) / 2);
         var _loc5_:int = 0;
         for each(_loc6_ in _loc1_)
         {
            _loc6_.x = _loc4_ + _loc5_;
            _loc5_ = _loc5_ + (_loc6_.width + 1);
         }
      }
      
      private function onSearchTimerComplete(param1:TimerEvent) : void
      {
         this._searchTimer.reset();
         this.updateInventory();
      }
   }
}
