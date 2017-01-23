package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.tooltip.LocationEnum;
   import d2actions.CloseInventory;
   import d2actions.ExchangeShopStockMouvmentRemove;
   import d2actions.LeaveDialogRequest;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.SelectMethodEnum;
   import d2hooks.ClickItemStore;
   import d2hooks.CloseStore;
   import d2hooks.KeyUp;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class Stock
   {
      
      public static const EQUIPEMENT_CATEGORY:uint = 0;
      
      public static const CONSUMABLES_CATEGORY:uint = 1;
      
      public static const RESSOURCES_CATEGORY:uint = 2;
      
      public static const ALL_CATEGORY:uint = uint.MAX_VALUE;
      
      public static const OTHER_CATEGORY:uint = 4;
      
      public static const SORT_ON_PRICE:String = "price";
      
      public static const SORT_ON_WEIGHT:String = "weight";
      
      public static const SORT_ON_QTY:String = "quantity";
      
      public static const SORT_ON_NAME:String = "name";
      
      public static const SORT_ON_DEFAULT:String = "objectUID";
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      public var menuApi:ContextMenuApi;
      
      public var soundApi:SoundApi;
      
      public var inventoryApi:InventoryApi;
      
      public var tooltipApi:TooltipApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var ctr_common:GraphicContainer;
      
      public var ctr_window:GraphicContainer;
      
      public var tx_icon_ctr_window:Texture;
      
      public var lbl_title:Label;
      
      public var btn_close:ButtonContainer;
      
      public var tx_bgEntity:Texture;
      
      public var ed_merchant:EntityDisplayer;
      
      public var btnEquipable:ButtonContainer;
      
      public var btnConsumables:ButtonContainer;
      
      public var btnRessources:ButtonContainer;
      
      public var btnAll:ButtonContainer;
      
      public var cb_category:ComboBox;
      
      public var gd_shop:Grid;
      
      public var ctr_search:GraphicContainer;
      
      public var inp_search:Input;
      
      public var btn_closeSearch:ButtonContainer;
      
      public var btn_itemsFilter:ButtonContainer;
      
      public var ctr_center:GraphicContainer;
      
      public var ctr_bottomInfos:GraphicContainer;
      
      protected var _searchCriteria:String;
      
      protected var _searchTimer:Timer;
      
      protected var _categoriesIdByBtnName:Dictionary;
      
      protected var _typeSelectedByCatBtnName:Dictionary;
      
      protected var _objectsInStock:Array;
      
      protected var _categoryIdByItemUID:Dictionary;
      
      protected var _currentCategoryBtn:Object;
      
      protected var _waitingObject:Object;
      
      protected var _componentsList:Dictionary;
      
      protected var _tokenType:int;
      
      protected var INPUT_SEARCH_DEFAULT_TEXT:String;
      
      public function Stock()
      {
         this._categoriesIdByBtnName = new Dictionary();
         this._typeSelectedByCatBtnName = new Dictionary();
         this._categoryIdByItemUID = new Dictionary();
         this._componentsList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc5_:Object = null;
         this.btnEquipable.soundId = SoundEnum.TAB;
         this.btnConsumables.soundId = SoundEnum.TAB;
         this.btnRessources.soundId = SoundEnum.TAB;
         this.btnAll.soundId = SoundEnum.TAB;
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this.uiApi.addComponentHook(this.btnAll,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btnAll,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btnEquipable,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btnEquipable,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btnConsumables,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btnConsumables,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btnRessources,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btnRessources,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.cb_category,ComponentHookList.ON_SELECT_ITEM);
         this.ctr_center.visible = false;
         this.ctr_bottomInfos.visible = false;
         this.btn_closeSearch.visible = false;
         this.gd_shop.scrollDisplay = "auto";
         this.gd_shop.autoSelectMode = 0;
         this._currentCategoryBtn = this.btnAll;
         this.btnAll.selected = true;
         if(!param1 || param1.tokenId)
         {
            this.ctr_search.y = 670;
            this.gd_shop.height = 595;
         }
         if(param1 && param1.tokenId)
         {
            this._tokenType = param1.tokenId;
            this.btn_itemsFilter.visible = true;
         }
         this.INPUT_SEARCH_DEFAULT_TEXT = this.uiApi.getText("ui.search.list");
         this.inp_search.text = this.INPUT_SEARCH_DEFAULT_TEXT;
         this._categoriesIdByBtnName[this.btnEquipable.name] = EQUIPEMENT_CATEGORY;
         this._categoriesIdByBtnName[this.btnConsumables.name] = CONSUMABLES_CATEGORY;
         this._categoriesIdByBtnName[this.btnRessources.name] = RESSOURCES_CATEGORY;
         this._categoriesIdByBtnName[this.btnAll.name] = ALL_CATEGORY;
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16733440,0.5);
         var _loc3_:Vector.<Number> = new Vector.<Number>();
         _loc3_.push(15,2,55,38,95,2,15,-40,95,-40);
         var _loc4_:Vector.<int> = new Vector.<int>();
         _loc4_.push(0,1,2,0,3,2,3,4,2);
         _loc2_.graphics.drawTriangles(_loc3_,_loc4_);
         _loc2_.graphics.endFill();
         this.ctr_common.addChild(_loc2_);
         this.ed_merchant.mask = _loc2_;
         this.ed_merchant.withoutMount = true;
         if(!this._searchTimer)
         {
            this._searchTimer = new Timer(200,1);
            this._searchTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onSearchTimerComplete);
         }
         this._objectsInStock = new Array();
         if(param1)
         {
            for each(_loc5_ in param1.objects)
            {
               this._objectsInStock.push(_loc5_);
            }
            this._objectsInStock.sort(this.shopStockSort);
            this.updateStockInventory();
         }
      }
      
      public function unload() : void
      {
         if(this._searchTimer)
         {
            this._searchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onSearchTimerComplete);
            this._searchTimer = null;
         }
         this.sysApi.sendAction(new LeaveDialogRequest());
         this.sysApi.sendAction(new CloseInventory());
         this.sysApi.enableWorldInteraction();
         this.uiApi.hideTooltip();
      }
      
      public function updateItemLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:ItemWrapper = null;
         param2.slot_item.allowDrag = false;
         if(!this._componentsList[param2.slot_item.name])
         {
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_RIGHT_CLICK);
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.slot_item,ComponentHookList.ON_ROLL_OUT);
         }
         this._componentsList[param2.slot_item.name] = param1;
         if(!this._componentsList[param2.btn_item.name])
         {
            this.uiApi.addComponentHook(param2.btn_item,ComponentHookList.ON_RIGHT_CLICK);
            this.uiApi.addComponentHook(param2.btn_item,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_item,ComponentHookList.ON_ROLL_OUT);
         }
         this._componentsList[param2.btn_item.name] = param1;
         if(!this._componentsList[param2.lbl_ItemName.name])
         {
            this.uiApi.addComponentHook(param2.lbl_ItemName,ComponentHookList.ON_RELEASE);
         }
         this._componentsList[param2.lbl_ItemName.name] = param1;
         if(!this._componentsList[param2.slot_TokenPrice.name])
         {
            this.uiApi.addComponentHook(param2.slot_TokenPrice,ComponentHookList.ON_RIGHT_CLICK);
            this.uiApi.addComponentHook(param2.slot_TokenPrice,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.slot_TokenPrice,ComponentHookList.ON_ROLL_OUT);
         }
         this._componentsList[param2.slot_TokenPrice.name] = param1;
         if(param1)
         {
            param2.btn_item.selected = param3;
            _loc4_ = param1.itemWrapper;
            if(!this._tokenType)
            {
               if(!param1.hasOwnProperty("price") || isNaN(Number(param1.price)) || param1.price == null || param1.price == 0)
               {
                  param2.lbl_ItemPrice.text = "";
                  param2.tx_kama.visible = false;
               }
               else
               {
                  param2.lbl_ItemPrice.text = this.utilApi.kamasToString(param1.price,"");
                  param2.tx_kama.visible = true;
               }
               _loc5_ = param2.lbl_ItemPrice.x + param2.lbl_ItemPrice.width - param2.lbl_ItemName.x - 10 - param2.lbl_ItemPrice.textfield.textWidth;
            }
            else
            {
               _loc5_ = param2.slot_TokenPrice.x - param2.lbl_ItemName.x - 5;
               param2.tx_kama.visible = false;
            }
            param2.lbl_ItemName.width = _loc5_;
            param2.lbl_ItemName.text = _loc4_.shortName;
            if(_loc4_.etheral)
            {
               param2.lbl_ItemName.cssClass = "itemetheral";
            }
            else if(_loc4_.itemSetId != -1)
            {
               param2.lbl_ItemName.cssClass = "itemset";
            }
            else
            {
               param2.lbl_ItemName.cssClass = "p";
            }
            if(param1.hasOwnProperty("criterion") && param1.criterion && !param1.criterion.isRespected)
            {
               param2.lbl_ItemName.cssClass = "malus";
            }
            if(this._tokenType)
            {
               param2.lbl_ItemPrice.visible = false;
               param2.slot_TokenPrice.visible = true;
               _loc6_ = this.dataApi.getItemWrapper(this._tokenType,0,0,param1.price);
               param2.slot_TokenPrice.data = _loc6_;
            }
            else
            {
               param2.slot_TokenPrice.visible = false;
               if(param1.hasOwnProperty("price"))
               {
                  param2.lbl_ItemPrice.visible = true;
                  param2.lbl_ItemPrice.text = this.utilApi.kamasToString(param1.price,"");
               }
               else
               {
                  param2.lbl_ItemPrice.visible = false;
               }
            }
            param2.slot_item.data = _loc4_;
            param2.tx_backgroundItem.visible = true;
         }
         else
         {
            param2.lbl_ItemName.text = "";
            param2.lbl_ItemPrice.text = "";
            param2.slot_item.data = null;
            param2.tx_backgroundItem.visible = false;
            param2.btn_item.selected = false;
            param2.slot_TokenPrice.data = null;
            param2.tx_kama.visible = false;
         }
      }
      
      protected function updateStockInventory() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc1_:uint = this._categoriesIdByBtnName[this._currentCategoryBtn.name];
         this.updateCombobox();
         var _loc2_:Array = new Array();
         if(this._tokenType)
         {
            _loc3_ = this.inventoryApi.getItemQty(this._tokenType);
         }
         for each(_loc4_ in this._objectsInStock)
         {
            if((_loc1_ == ALL_CATEGORY || _loc4_.itemWrapper.category == _loc1_) && (!this.cb_category.value || this.cb_category.value.typeId == -1 || this.cb_category.value.typeId == _loc4_.itemWrapper.typeId) && (!this._searchCriteria || _loc4_.itemWrapper.undiatricalName.indexOf(this._searchCriteria) != -1) && (!this.btn_itemsFilter.selected || _loc4_.criterion && _loc4_.criterion.isRespected && (!this._tokenType || _loc4_.price <= _loc3_)))
            {
               _loc2_.push(_loc4_);
            }
         }
         this.gd_shop.dataProvider = _loc2_;
      }
      
      protected function updateCombobox() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:ItemType = null;
         var _loc1_:Dictionary = new Dictionary();
         var _loc2_:uint = this._categoriesIdByBtnName[this._currentCategoryBtn.name];
         for each(_loc3_ in this._objectsInStock)
         {
            if(_loc2_ == ALL_CATEGORY || _loc3_.itemWrapper.category == _loc2_)
            {
               _loc1_[_loc3_.itemWrapper.typeId] = _loc3_.itemWrapper.type;
            }
         }
         _loc4_ = new Array();
         for each(_loc7_ in _loc1_)
         {
            _loc6_ = {
               "label":_loc7_.name,
               "typeId":_loc7_.id
            };
            if(_loc7_.id == this._typeSelectedByCatBtnName[this._currentCategoryBtn.name])
            {
               _loc5_ = _loc6_;
            }
            _loc4_.push(_loc6_);
         }
         _loc4_ = _loc4_.sortOn("label",Array.CASEINSENSITIVE);
         _loc6_ = {
            "label":this.uiApi.getText("ui.common.allTypesForObject"),
            "typeId":-1
         };
         if(!_loc5_)
         {
            _loc5_ = _loc6_;
         }
         _loc4_.unshift(_loc6_);
         this.cb_category.dataProvider = _loc4_;
         this.cb_category.value = _loc5_;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         switch(param1)
         {
            case this.btnEquipable:
            case this.btnConsumables:
            case this.btnRessources:
            case this.btnAll:
               this._currentCategoryBtn = param1;
               this.updateStockInventory();
               if(this.gd_shop.dataProvider.length > 0)
               {
                  this.gd_shop.selectedIndex = -1;
               }
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
                  this.updateStockInventory();
                  this.btn_closeSearch.visible = false;
                  TradeCenter.SEARCH_MODE = false;
               }
               break;
            case this.btn_itemsFilter:
               this.updateStockInventory();
               break;
            case this.gd_shop:
               _loc2_ = this.gd_shop.selectedItem;
               _loc3_ = this.uiApi.keyIsDown(Keyboard.CONTROL);
               _loc4_ = this.uiApi.keyIsDown(Keyboard.SHIFT);
               if(_loc3_ && _loc4_)
               {
                  this.sysApi.sendAction(new ExchangeShopStockMouvmentRemove(_loc2_.objectUID,_loc2_.quantity));
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc5_:ItemTooltipSettings = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_RIGHT,
            "relativePoint":LocationEnum.POINT_RIGHT
         };
         var _loc4_:int = 9;
         switch(param1)
         {
            case this.btnEquipable:
               _loc2_ = this.uiApi.getText("ui.common.equipement");
               break;
            case this.btnConsumables:
               _loc2_ = this.uiApi.getText("ui.common.usableItems");
               break;
            case this.btnRessources:
               _loc2_ = this.uiApi.getText("ui.common.ressources");
               break;
            case this.btnAll:
               _loc2_ = this.uiApi.getText("ui.common.all");
               break;
            default:
               if(param1.name.indexOf("slot_") != -1)
               {
                  _loc5_ = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
                  if(_loc5_ == null)
                  {
                     _loc5_ = this.tooltipApi.createItemSettings();
                     this.sysApi.setData("itemTooltipSettings",_loc5_,DataStoreEnum.BIND_ACCOUNT);
                  }
                  _loc5_.showEffects = true;
                  if(!TradeCenter.BID_HOUSE_BUY_MODE || this.uiApi.me().name.toLowerCase().indexOf("myself") != -1)
                  {
                     _loc5_.showEffects = false;
                  }
                  if(this.sysApi.getOption("displayTooltips","dofus"))
                  {
                     this.uiApi.showTooltip(param1.data,param1,false,"standard",3,3,0,null,null,_loc5_);
                  }
                  else
                  {
                     this.uiApi.showTooltip(param1.data,param1,false,"standard",LocationEnum.POINT_BOTTOMRIGHT,LocationEnum.POINT_TOPRIGHT,0,"itemName",null,_loc5_,"ItemInfo");
                  }
               }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,_loc4_,null,null,null,"TextInfo");
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
            case this.gd_shop:
               _loc4_ = this.gd_shop.selectedItem;
               if(!_loc4_)
               {
                  return;
               }
               switch(param2)
               {
                  case SelectMethodEnum.CLICK:
                     this.sysApi.dispatchHook(ClickItemStore,_loc4_,this._tokenType);
                     break;
                  case SelectMethodEnum.DOUBLE_CLICK:
               }
               break;
            case this.cb_category:
               if(param3 && param2 != 2)
               {
                  this._typeSelectedByCatBtnName[this._currentCategoryBtn.name] = param1.value.typeId;
                  this.updateStockInventory();
               }
         }
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
      }
      
      public function onItemUseOnCell(param1:Object) : void
      {
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1.name.indexOf("slot_") != -1)
         {
            _loc2_ = param1.data;
            _loc3_ = this.menuApi.create(_loc2_);
            if(_loc3_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc3_);
            }
         }
         else if(param1.name.indexOf("btn_item") != -1)
         {
            _loc2_ = this._componentsList[param1.name];
            if(!_loc2_)
            {
               return;
            }
            _loc3_ = this.menuApi.create(_loc2_.itemWrapper);
            if(_loc3_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc3_);
            }
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         if(!param2.data)
         {
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this.inp_search.haveFocus && this.inp_search.text != this.INPUT_SEARCH_DEFAULT_TEXT)
         {
            if(this.inp_search.text.length)
            {
               this._searchCriteria = this.utilApi.noAccent(this.inp_search.text).toLowerCase();
               this.btn_closeSearch.visible = true;
               this._searchTimer.reset();
               this._searchTimer.start();
            }
            else if(this._searchCriteria)
            {
               this._searchCriteria = null;
               this.btn_closeSearch.visible = false;
               this.inp_search.text = "";
               this.updateStockInventory();
               TradeCenter.SEARCH_MODE = false;
            }
         }
      }
      
      protected function showTransfertUI(param1:Boolean = true) : void
      {
         if(param1)
         {
            this.soundApi.playSound(SoundTypeEnum.MERCHANT_TRANSFERT_OPEN);
         }
         else
         {
            this.soundApi.playSound(SoundTypeEnum.MERCHANT_TRANSFERT_CLOSE);
         }
      }
      
      protected function onShortcut(param1:String) : Boolean
      {
         if(param1 == "closeUi")
         {
            this.sysApi.dispatchHook(CloseStore);
            return true;
         }
         if(param1 == "validUi")
         {
            this.inp_search.focus();
            return true;
         }
         return false;
      }
      
      protected function shopStockSort(param1:Object, param2:Object) : int
      {
         if(param1.price < param2.price)
         {
            return -1;
         }
         if(param1.price > param2.price)
         {
            return 1;
         }
         if(param1.itemWrapper.typeId < param2.itemWrapper.typeId)
         {
            return -1;
         }
         if(param1.itemWrapper.typeId > param2.itemWrapper.typeId)
         {
            return 1;
         }
         if(param1.itemWrapper.name < param2.itemWrapper.name)
         {
            return -1;
         }
         if(param1.itemWrapper.name > param2.itemWrapper.name)
         {
            return 1;
         }
         return 0;
      }
      
      protected function onSearchTimerComplete(param1:TimerEvent) : void
      {
         this._searchTimer.reset();
         TradeCenter.SEARCH_MODE = true;
         this.updateStockInventory();
      }
   }
}
