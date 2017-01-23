package ui
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemToSellInBid;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.BidHouseStringSearch;
   import d2actions.BidSwitchToBuyerMode;
   import d2actions.BidSwitchToSellerMode;
   import d2actions.CloseInventory;
   import d2actions.ExchangeBidHouseList;
   import d2actions.ExchangeBidHouseSearch;
   import d2actions.ExchangeBidHouseType;
   import d2actions.LeaveShopStock;
   import d2actions.MountInfoRequest;
   import d2enums.ComponentHookList;
   import d2enums.SelectMethodEnum;
   import d2hooks.BidObjectTypeListUpdate;
   import d2hooks.LeaveDialog;
   import d2hooks.MouseShiftClick;
   import d2hooks.OpenBidHouse;
   import d2hooks.SellerObjectListUpdate;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class StockBidHouse extends Stock
   {
      
      private static var _self:StockBidHouse;
       
      
      public var ctr_categoryButtons:GraphicContainer;
      
      public var ctr_content:GraphicContainer;
      
      public var lbl_quantityObject:Label;
      
      public var lbl_sumPrices:Label;
      
      public var tx_info:Texture;
      
      public var btn_center:ButtonContainer;
      
      public var btn_lbl_btn_center:Label;
      
      private var _sellerBuyerDescriptor:Object;
      
      private var _currentTypeObject:int;
      
      protected var _searchResult:Array;
      
      private var _bidTooltipText:String = "";
      
      private var _totalObjectSold:uint;
      
      private var _totalObjectPrice:Number;
      
      private var _timer:Timer;
      
      private var _groupCategoriesId:String;
      
      public function StockBidHouse()
      {
         super();
      }
      
      public static function getInstance() : StockBidHouse
      {
         return _self;
      }
      
      override public function main(param1:Object = null) : void
      {
         var _loc2_:ObjectItemToSellInBid = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         super.main();
         _self = this;
         sysApi.dispatchHook(OpenBidHouse);
         this._sellerBuyerDescriptor = param1.sellerBuyerDescriptor;
         sysApi.addHook(BidObjectTypeListUpdate,this.onBidObjectTypeListUpdate);
         sysApi.addHook(SellerObjectListUpdate,this.onSellerObjectListUpdate);
         sysApi.addHook(LeaveDialog,this.onLeaveDialog);
         uiApi.addComponentHook(this.lbl_quantityObject,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.lbl_quantityObject,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.lbl_sumPrices,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.lbl_sumPrices,ComponentHookList.ON_ROLL_OUT);
         gd_shop.scrollDisplay = "always";
         this.ctr_categoryButtons.visible = false;
         ed_merchant.visible = false;
         ctr_center.visible = true;
         ctr_bottomInfos.visible = true;
         this._totalObjectSold = 0;
         this._totalObjectPrice = 0;
         if(param1.objectsInfos)
         {
            this._totalObjectSold = param1.objectsInfos.length;
            for each(_loc2_ in param1.objectsInfos)
            {
               this._totalObjectPrice = this._totalObjectPrice + _loc2_.objectPrice;
            }
         }
         this._timer = new Timer(2000,1);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimerEvent);
         this.changeBidTooltip(this._sellerBuyerDescriptor);
         _objectsInStock = new Array();
         _categoryIdByItemUID = new Dictionary();
         if(param1.inventory != null)
         {
            _loc3_ = param1.inventory.length;
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               this.addItemInStock(param1.inventory[_loc4_],false);
               _loc4_++;
            }
            updateStockInventory();
         }
         if(TradeCenter.BID_HOUSE_BUY_MODE)
         {
            this.btn_lbl_btn_center.text = uiApi.getText("ui.bidhouse.bigStoreModeSell");
         }
         else
         {
            this.btn_lbl_btn_center.text = uiApi.getText("ui.bidhouse.bigStoreModeBuy");
         }
         this.changeBidHouseMode(true);
      }
      
      override public function unload() : void
      {
         _self = null;
         this._timer.stop();
         if(_searchTimer)
         {
            _searchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onSearchTimerComplete);
            _searchTimer = null;
         }
         uiApi.unloadUi(UIEnum.BIDHOUSE_BUY);
         uiApi.unloadUi(UIEnum.BIDHOUSE_SELL);
         TradeCenter.SEARCH_MODE = false;
         sysApi.sendAction(new CloseInventory());
      }
      
      public function get selectedStockItem() : ItemWrapper
      {
         if(!gd_shop.selectedItem)
         {
            return null;
         }
         return gd_shop.selectedItem.itemWrapper;
      }
      
      public function changeBidTooltip(param1:Object) : void
      {
         var _loc6_:ItemType = null;
         var _loc2_:int = param1.types.length;
         var _loc3_:Array = new Array(_loc2_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc6_ = dataApi.getItemType(param1.types[_loc4_]);
            if(_loc6_)
            {
               _loc3_[_loc4_] = _loc6_.name;
            }
            _loc4_++;
         }
         _loc3_.sort();
         var _loc5_:String = " - " + _loc3_.join("\n - ");
         this._bidTooltipText = uiApi.getText("ui.common.maxLevel") + uiApi.getText("ui.common.colon") + param1.maxItemLevel + "\n" + uiApi.getText("ui.bidhouse.bigStoreTax") + uiApi.getText("ui.common.colon") + param1.taxPercentage + "%" + "\n" + uiApi.getText("ui.bidhouse.bigStoreModificationTax") + uiApi.getText("ui.common.colon") + param1.taxModificationPercentage + "%" + "\n" + uiApi.getText("ui.bidhouse.bigStoreMaxItemPerAccount") + uiApi.getText("ui.common.colon") + param1.maxItemPerAccount + "\n" + uiApi.getText("ui.bidhouse.bigStoreMaxSellTime") + uiApi.getText("ui.common.colon") + param1.unsoldDelay + " " + uiApi.processText(uiApi.getText("ui.time.hours"),"n",param1.unsoldDelay < 2) + "\n\n" + uiApi.getText("ui.bidhouse.bigStoreTypes") + " : \n" + _loc5_;
      }
      
      public function changeBidHouseMode(param1:Boolean = false) : void
      {
         _searchCriteria = null;
         inp_search.text = "";
         if(TradeCenter.BID_HOUSE_BUY_MODE)
         {
            if(!param1)
            {
               uiApi.getUi("itemBidHouseSell").uiClass.displayUi(false);
               uiApi.getUi("itemBidHouseBuy").uiClass.displayUi(true);
            }
            this.btn_lbl_btn_center.text = uiApi.getText("ui.bidhouse.bigStoreModeSell");
            lbl_title.text = uiApi.getText("ui.bidhouse.bigStoreItemList");
            this.updateLabelQuantitySoldObject();
            this.updateCombobox();
            btnEquipable.disabled = true;
            btnConsumables.disabled = true;
            btnRessources.disabled = true;
            btnAll.disabled = true;
            gd_shop.dataProvider = new Array();
         }
         else
         {
            if(!param1)
            {
               uiApi.getUi("itemBidHouseSell").uiClass.displayUi(true);
               uiApi.getUi("itemBidHouseBuy").uiClass.displayUi(false);
            }
            gd_shop.dataProvider = new Array();
            this.btn_lbl_btn_center.text = uiApi.getText("ui.bidhouse.bigStoreModeBuy");
            lbl_title.text = uiApi.getText("ui.common.shopStock");
            this.updateLabelQuantitySoldObject();
            btnEquipable.disabled = false;
            btnConsumables.disabled = false;
            btnRessources.disabled = false;
            btnAll.disabled = false;
         }
      }
      
      protected function addItemInStock(param1:Object, param2:Boolean = true) : void
      {
         _objectsInStock.push(param1);
         var _loc3_:Object = dataApi.getItem(param1.itemWrapper.objectGID).category;
         _categoryIdByItemUID[param1.itemWrapper.objectUID] = _loc3_;
         if(param2)
         {
            this.selectTab(param1);
            updateStockInventory();
         }
      }
      
      override protected function updateCombobox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:ItemType = null;
         if(TradeCenter.BID_HOUSE_BUY_MODE)
         {
            _loc1_ = this._sellerBuyerDescriptor.types.length;
            _loc2_ = new Array(_loc1_);
            this._groupCategoriesId = "";
            _loc4_ = 0;
            while(_loc4_ < _loc1_)
            {
               _loc3_ = this._sellerBuyerDescriptor.types[_loc4_];
               _loc6_ = dataApi.getItemType(_loc3_);
               _loc2_[_loc4_] = {
                  "label":(!!_loc6_?_loc6_.name:"?"),
                  "typeId":_loc3_
               };
               this._groupCategoriesId = this._groupCategoriesId + _loc3_.toString();
               _loc4_++;
            }
            _loc2_ = _loc2_.sortOn("label");
            cb_category.dataProvider = _loc2_;
            _loc5_ = sysApi.getSetData("buyModeLastSelectedType_" + this._groupCategoriesId,0);
            cb_category.selectedIndex = _loc5_;
         }
         else
         {
            super.updateCombobox();
         }
      }
      
      private function selectTab(param1:Object) : void
      {
         var _loc2_:uint = _categoriesIdByBtnName[_currentCategoryBtn.name];
         var _loc3_:Object = dataApi.getItem(param1.objectGID);
         if(_loc3_.category != _loc2_ && _loc2_ != ALL_CATEGORY)
         {
            switch(_loc3_.category)
            {
               case EQUIPEMENT_CATEGORY:
                  _currentCategoryBtn = btnEquipable;
                  btnEquipable.selected = true;
                  break;
               case CONSUMABLES_CATEGORY:
                  _currentCategoryBtn = btnConsumables;
                  btnConsumables.selected = true;
                  break;
               case RESSOURCES_CATEGORY:
                  _currentCategoryBtn = btnRessources;
                  btnRessources.selected = true;
                  break;
               default:
                  _currentCategoryBtn = btnAll;
                  btnAll.selected = true;
            }
         }
      }
      
      protected function updateLabelQuantitySoldObject() : void
      {
         if(TradeCenter.BID_HOUSE_BUY_MODE)
         {
            this.lbl_quantityObject.visible = false;
            this.lbl_sumPrices.visible = false;
         }
         else
         {
            this.lbl_quantityObject.visible = true;
            this.lbl_sumPrices.visible = true;
            this.lbl_quantityObject.text = this._totalObjectSold + "/" + this._sellerBuyerDescriptor.maxItemPerAccount;
            this.lbl_sumPrices.text = utilApi.kamasToString(this._totalObjectPrice);
         }
      }
      
      public function onSellerObjectListUpdate(param1:Object) : void
      {
         this._totalObjectSold = param1.length;
         this._totalObjectPrice = 0;
         _objectsInStock = new Array();
         _categoryIdByItemUID = new Dictionary();
         var _loc2_:int = param1.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.addItemInStock(param1[_loc3_],false);
            this._totalObjectPrice = this._totalObjectPrice + param1[_loc3_].price;
            _loc3_++;
         }
         this.updateLabelQuantitySoldObject();
         updateStockInventory();
      }
      
      public function onBidObjectTypeListUpdate(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = param1.length;
         if(TradeCenter.SEARCH_MODE && !param2)
         {
            _objectsInStock = new Array();
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               this.addItemInStock({"itemWrapper":dataApi.getItemWrapper(param1[_loc3_])},false);
               _loc3_++;
            }
            _objectsInStock.sort(this.sortShop);
            return;
         }
         var _loc5_:Array = new Array(_loc4_);
         if(TradeCenter.SEARCH_MODE)
         {
            this._searchResult = new Array();
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_[_loc3_] = {"itemWrapper":dataApi.getItemWrapper(param1[_loc3_])};
               this._searchResult.push({"itemWrapper":dataApi.getItemWrapper(param1[_loc3_])});
               _loc3_++;
            }
         }
         else
         {
            _objectsInStock = new Array();
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_[_loc3_] = {"itemWrapper":dataApi.getItemWrapper(param1[_loc3_].GIDObject)};
               this.addItemInStock(_loc5_[_loc3_],false);
               _loc3_++;
            }
            _objectsInStock.sort(this.sortShop);
         }
         _loc5_.sort(this.sortShop);
         if(this._searchResult && this._searchResult.length)
         {
            this._searchResult.sort(this.sortShop);
         }
         gd_shop.dataProvider = _loc5_;
      }
      
      private function sortShop(param1:Object, param2:Object) : int
      {
         if(param1.itemWrapper.level < param2.itemWrapper.level)
         {
            return -1;
         }
         if(param1.itemWrapper.level > param2.itemWrapper.level)
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
      
      override public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         switch(param1)
         {
            case gd_shop:
               if(TradeCenter.BID_HOUSE_BUY_MODE)
               {
                  _loc4_ = gd_shop.selectedItem.itemWrapper;
                  if(TradeCenter.SEARCH_MODE)
                  {
                     if(param2 != GridItemSelectMethodEnum.AUTO)
                     {
                        sysApi.sendAction(new ExchangeBidHouseSearch(_loc4_.typeId,_loc4_.objectGID));
                     }
                  }
                  else
                  {
                     sysApi.sendAction(new ExchangeBidHouseList(_loc4_.objectGID));
                  }
               }
               else
               {
                  _loc4_ = gd_shop.selectedItem;
                  uiApi.getUi("itemBidHouseSell").uiClass.onSelectItemFromStockBidHouse(_loc4_);
                  if(param2 == SelectMethodEnum.DOUBLE_CLICK)
                  {
                     if(_loc4_ && _loc4_.itemWrapper && _loc4_.itemWrapper.category != 0 && _loc4_.itemWrapper.hasOwnProperty("isCertificate") && _loc4_.itemWrapper.isCertificate)
                     {
                        sysApi.sendAction(new MountInfoRequest(_loc4_.itemWrapper));
                     }
                  }
               }
               break;
            case cb_category:
               if(TradeCenter.BID_HOUSE_BUY_MODE)
               {
                  if(param1.value.typeId != 0)
                  {
                     this._currentTypeObject = param1.value.typeId;
                  }
                  sysApi.setData("buyModeLastSelectedType_" + this._groupCategoriesId,param1.selectedIndex);
                  sysApi.sendAction(new ExchangeBidHouseType(this._currentTypeObject));
               }
               else if(param3 && param2 != 2)
               {
                  _typeSelectedByCatBtnName[_currentCategoryBtn.name] = param1.value.typeId;
                  updateStockInventory();
               }
         }
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case btn_close:
               sysApi.sendAction(new LeaveShopStock());
               uiApi.unloadUi(uiApi.me().name);
               break;
            case this.btn_center:
               if(this._timer.running == false)
               {
                  this.btn_center.disabled = true;
                  this._timer.reset();
                  this._timer.start();
                  TradeCenter.SWITCH_MODE = true;
                  TradeCenter.BID_HOUSE_BUY_MODE = !TradeCenter.BID_HOUSE_BUY_MODE;
                  if(TradeCenter.SEARCH_MODE)
                  {
                     TradeCenter.SEARCH_MODE = false;
                     _searchCriteria = null;
                  }
                  if(TradeCenter.BID_HOUSE_BUY_MODE)
                  {
                     sysApi.sendAction(new BidSwitchToBuyerMode());
                  }
                  else
                  {
                     sysApi.sendAction(new BidSwitchToSellerMode());
                  }
               }
               break;
            case inp_search:
               if(inp_search.text == INPUT_SEARCH_DEFAULT_TEXT)
               {
                  inp_search.text = "";
               }
               break;
            case btn_closeSearch:
               if(inp_search.text != INPUT_SEARCH_DEFAULT_TEXT)
               {
                  inp_search.text = INPUT_SEARCH_DEFAULT_TEXT;
                  _searchCriteria = null;
                  TradeCenter.SEARCH_MODE = false;
                  updateStockInventory();
                  btn_closeSearch.visible = false;
               }
         }
         if(param1.name.indexOf("lbl_ItemName") != -1)
         {
            if(uiApi.keyIsDown(Keyboard.SHIFT) && _componentsList[param1.name])
            {
               sysApi.dispatchHook(MouseShiftClick,{"data":_componentsList[param1.name].itemWrapper});
            }
         }
      }
      
      override protected function onShortcut(param1:String) : Boolean
      {
         if(param1 == "closeUi")
         {
            sysApi.sendAction(new LeaveShopStock());
            uiApi.unloadUi(uiApi.me().name);
            return true;
         }
         return false;
      }
      
      public function isSwitching() : Boolean
      {
         return TradeCenter.SWITCH_MODE;
      }
      
      override public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         super.onRollOver(param1);
         var _loc3_:Object = {
            "point":10,
            "relativePoint":1
         };
         switch(param1)
         {
            case this.tx_info:
               uiApi.showTooltip(uiApi.textTooltipInfo(this._bidTooltipText),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
               break;
            case this.lbl_quantityObject:
               _loc2_ = uiApi.getText("ui.bidhouse.quantityObjectSold",this._totalObjectSold,this._sellerBuyerDescriptor.maxItemPerAccount);
               break;
            case this.lbl_sumPrices:
               _loc2_ = uiApi.getText("ui.bidhouse.totalPrice");
         }
         if(_loc2_)
         {
            uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
         }
      }
      
      protected function onTimerEvent(param1:TimerEvent) : void
      {
         this.btn_center.disabled = false;
      }
      
      public function onLeaveDialog() : void
      {
         uiApi.unloadUi(uiApi.me().name);
      }
      
      override protected function onSearchTimerComplete(param1:TimerEvent) : void
      {
         _searchTimer.reset();
         TradeCenter.SEARCH_MODE = true;
         if(_searchCriteria && TradeCenter.BID_HOUSE_BUY_MODE)
         {
            sysApi.sendAction(new BidHouseStringSearch(_searchCriteria));
         }
         else
         {
            updateStockInventory();
         }
      }
   }
}
