package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.ExchangeBidHouseBuy;
   import d2actions.ExchangeBidHousePrice;
   import d2actions.MountInfoRequest;
   import d2enums.ComponentHookList;
   import d2enums.ExchangeErrorEnum;
   import d2enums.SelectMethodEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.BidObjectListUpdate;
   import d2hooks.ExchangeBidPrice;
   import d2hooks.ExchangeError;
   import d2hooks.KeyUp;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class ItemBidHouseBuy
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      public var averagePricesApi:AveragePricesApi;
      
      public var menuApi:ContextMenuApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private var _sellerBuyerDescriptor:Object;
      
      private var _listObjects:Object;
      
      private var _currentSort:int = 1;
      
      private var _item:Object;
      
      private var _selectedItem:Object;
      
      private var _currentGrid:Grid;
      
      private var _detailView:Boolean;
      
      private var _currentFilter:String;
      
      private var _allText:String;
      
      private var INPUT_SEARCH_DEFAULT_TEXT:String;
      
      public var currentCase:int = -1;
      
      public var mainCtr:GraphicContainer;
      
      public var classicItemCtr:GraphicContainer;
      
      public var detailItemCtr:GraphicContainer;
      
      public var averagePriceCtr:GraphicContainer;
      
      public var lbl_noItem:Label;
      
      public var lbl_averagePrice:Label;
      
      public var lbl_averagePriceTitle:Label;
      
      public var tx_kamas:Texture;
      
      public var lbl_tabQty1:Label;
      
      public var lbl_tabQty2:Label;
      
      public var lbl_tabQty3:Label;
      
      public var btn_tabQty1:ButtonContainer;
      
      public var btn_tabQty2:ButtonContainer;
      
      public var btn_tabQty3:ButtonContainer;
      
      public var btn_name:ButtonContainer;
      
      public var btn_price:ButtonContainer;
      
      public var btn_size:ButtonContainer;
      
      public var btn_buy:ButtonContainer;
      
      public var gd_classicList:Grid;
      
      public var gd_detailList:Grid;
      
      public var inp_search:Input;
      
      public var btn_closeSearch:ButtonContainer;
      
      public var tx_item:Texture;
      
      public var lbl_item_name:Label;
      
      public var lbl_item_level:Label;
      
      private var _progressPopupName:String;
      
      private var _searchSettimoutId:uint;
      
      public function ItemBidHouseBuy()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addHook(ExchangeBidPrice,this.onExchangeBidPrice);
         this.sysApi.addHook(BidObjectListUpdate,this.onBidObjectListUpdate);
         this.sysApi.addHook(ExchangeError,this.onExchangeError);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.VALID_UI,this.onShortcut);
         this.uiApi.addComponentHook(this.lbl_averagePriceTitle,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_averagePriceTitle,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_averagePrice,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_averagePrice,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.btn_tabQty1,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_tabQty2,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_tabQty3,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_RELEASE);
         this._allText = this.uiApi.getText("ui.common.all");
         this._sellerBuyerDescriptor = param1.sellerBuyerDescriptor;
         this.lbl_tabQty1.text = "x " + this._sellerBuyerDescriptor.quantities[0];
         this.lbl_tabQty2.text = "x " + this._sellerBuyerDescriptor.quantities[1];
         this.lbl_tabQty3.text = "x " + this._sellerBuyerDescriptor.quantities[2];
         this.gd_classicList.autoSelectMode = 0;
         this.gd_classicList.dataProvider = new Array();
         this.gd_detailList.autoSelectMode = 1;
         this.gd_detailList.dataProvider = new Array();
         this._currentGrid = this.gd_classicList;
         this.btn_buy.disabled = true;
         this.mainCtr.visible = false;
         this.btn_closeSearch.visible = false;
         this._currentFilter = null;
         this.INPUT_SEARCH_DEFAULT_TEXT = this.uiApi.getText("ui.common.search");
      }
      
      public function displayUi(param1:Boolean) : void
      {
         if(param1)
         {
            this.gd_classicList.dataProvider = new Array();
            this.gd_detailList.dataProvider = new Array();
            this.btn_buy.disabled = true;
         }
         else
         {
            this.mainCtr.visible = false;
         }
      }
      
      private function onCancelSearch() : void
      {
         clearTimeout(this._searchSettimoutId);
         if(this._progressPopupName)
         {
            this.uiApi.unloadUi(this._progressPopupName);
            this._progressPopupName = null;
         }
      }
      
      private function onBidObjectListUpdate(param1:Object, param2:Boolean = false, param3:Boolean = false) : void
      {
         if(param3)
         {
            if(this._detailView)
            {
               this._currentGrid.selectedIndex = 0;
            }
            else
            {
               this._currentGrid.selectedIndex = -1;
            }
         }
         this.currentCase = -1;
         if(this._currentGrid.selectedItem)
         {
            this.currentCase = this._currentGrid.selectedItem.currentCase;
         }
         this._listObjects = param1;
         this.refreshBidObjectList(!param2);
         if(!param2 && this._listObjects[0] != null)
         {
            this.sysApi.sendAction(new ExchangeBidHousePrice(this._listObjects[0].itemWrapper.objectGID));
            this._item = this._listObjects[0].itemWrapper;
            this.showItem(this._item as ItemWrapper);
         }
      }
      
      private function refreshbidObjectListStep(param1:Boolean, param2:String, param3:Array, param4:Dictionary, param5:uint, param6:uint = 0) : void
      {
         var _loc9_:Object = null;
         var _loc10_:* = undefined;
         var _loc11_:int = 0;
         var _loc12_:EffectInstance = null;
         var _loc7_:uint = getTimer();
         var _loc8_:int = param6;
         while(_loc8_ < param5)
         {
            if(getTimer() - _loc7_ > 20)
            {
               if(!this._progressPopupName)
               {
                  this._progressPopupName = this.modCommon.openTextPopup("",this.uiApi.getText("ui.popup.processingOject","0"),[this.uiApi.getText("ui.common.cancel")],[this.onCancelSearch],null,this.onCancelSearch);
               }
               _loc10_ = this.uiApi.getUi(this._progressPopupName);
               if(_loc10_ && _loc10_.getElement("lbl_content"))
               {
                  _loc10_.getElement("lbl_content").text = this.uiApi.getText("ui.popup.processingObject",Math.floor(_loc8_ / param5 * 100).toString());
               }
               this._searchSettimoutId = setTimeout(this.refreshbidObjectListStep,1,param1,param2,param3,param4,param5,_loc8_);
               return;
            }
            _loc9_ = this._listObjects[_loc8_];
            if(!this.filtered(param2,_loc9_.itemWrapper))
            {
               _loc11_ = 8;
               if(_loc9_.itemWrapper && _loc9_.itemWrapper.effects)
               {
                  for each(_loc12_ in _loc9_.itemWrapper.effects)
                  {
                     if(_loc12_.effectId == 1111)
                     {
                        _loc11_ = int(_loc12_.parameter0);
                     }
                  }
               }
               param3.push({
                  "itemWrapper":_loc9_.itemWrapper,
                  "name":_loc9_.itemWrapper.shortName,
                  "prices":_loc9_.prices,
                  "currentCase":-1,
                  "p1":_loc9_.prices[0],
                  "p2":_loc9_.prices[1],
                  "p3":_loc9_.prices[2],
                  "size":_loc11_
               });
            }
            if(this._detailView)
            {
               this.addToCombobox(param4,_loc9_.itemWrapper.shortName);
            }
            _loc8_++;
         }
         this.refreshbidObjectListEnd(param1,param3,param4);
         StockBidHouse.getInstance().gd_shop.focus();
      }
      
      private function refreshbidObjectListEnd(param1:Boolean, param2:Array, param3:Dictionary) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:* = null;
         this.onCancelSearch();
         if(this._currentSort < 0)
         {
            _loc4_ = this._currentSort * -1;
            if(this._currentSort == -4)
            {
               param2.sortOn("name",Array.DESCENDING);
            }
            else if(this._currentSort == -5)
            {
               param2.sortOn("size",Array.NUMERIC | Array.DESCENDING);
            }
            else
            {
               param2.sortOn("p" + _loc4_,Array.NUMERIC | Array.DESCENDING);
            }
         }
         else if(this._currentSort == 4)
         {
            param2.sortOn("name");
         }
         else if(this._currentSort == 5)
         {
            param2.sortOn("size",Array.NUMERIC);
         }
         else
         {
            param2.sortOn("p" + this._currentSort,Array.NUMERIC);
         }
         this.mainCtr.visible = true;
         this.lbl_noItem.visible = false;
         if(this._detailView)
         {
            this._currentGrid = this.gd_detailList;
            this.classicItemCtr.visible = false;
            this.detailItemCtr.visible = true;
            _loc5_ = 0;
            _loc7_ = -1;
            _loc8_ = this.gd_detailList.selectedIndex;
            if(_loc8_ < 0)
            {
               _loc8_ = 0;
            }
            if(param1)
            {
               _loc5_ = 0;
               while(_loc5_ < this.gd_detailList.dataProvider.length)
               {
                  if(!this.gd_detailList.indexIsInvisibleSlot(_loc5_))
                  {
                     _loc7_ = _loc5_;
                     _loc6_ = this.gd_detailList.dataProvider[_loc5_];
                     break;
                  }
                  _loc5_++;
               }
            }
            this.gd_detailList.dataProvider = param2;
            if(param1)
            {
               if(_loc6_)
               {
                  _loc5_ = 0;
                  while(_loc5_ < param2.length)
                  {
                     if(param2[_loc5_].name == _loc6_.name)
                     {
                        _loc7_ = _loc5_;
                        break;
                     }
                     _loc5_++;
                  }
               }
               this.gd_detailList.moveTo(_loc7_,true);
               if(this.gd_detailList.selectedIndex != _loc8_)
               {
                  this.gd_detailList.selectedIndex = _loc8_;
               }
            }
            _loc9_ = new Array();
            for(_loc10_ in param3)
            {
               _loc9_.push(_loc10_);
            }
            _loc9_.sort();
            _loc9_.unshift(this._allText);
         }
         else
         {
            this._currentGrid = this.gd_classicList;
            this.classicItemCtr.visible = true;
            this.detailItemCtr.visible = false;
            this.gd_classicList.dataProvider = param2;
         }
      }
      
      private function refreshBidObjectList(param1:Boolean = true) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Dictionary = null;
         var _loc5_:String = null;
         if(!this._listObjects || this._listObjects.length == 0)
         {
            this.mainCtr.visible = false;
         }
         else
         {
            _loc2_ = this._listObjects.length;
            _loc3_ = new Array();
            _loc4_ = new Dictionary();
            this._detailView = this.useDetailView(this._listObjects);
            if(this._currentGrid == this.gd_classicList && this._detailView || this._currentGrid == this.gd_detailList && !this._detailView)
            {
               this._currentFilter = "";
               this.inp_search.text = this.INPUT_SEARCH_DEFAULT_TEXT;
            }
            _loc5_ = !!this._currentFilter?this._currentFilter.toLowerCase():"";
            this.onCancelSearch();
            this.refreshbidObjectListStep(param1,_loc5_,_loc3_,_loc4_,_loc2_);
         }
      }
      
      private function addToCombobox(param1:Dictionary, param2:String) : void
      {
         var _loc4_:String = null;
         var _loc3_:Array = param2.split(", ");
         for each(_loc4_ in _loc3_)
         {
            if(!param1.hasOwnProperty(_loc4_))
            {
               param1[_loc4_] = true;
            }
         }
      }
      
      private function filtered(param1:String, param2:ItemWrapper) : Boolean
      {
         var _loc3_:EffectInstance = null;
         var _loc4_:Monster = null;
         if(param1.length == 0)
         {
            return false;
         }
         if(param1.length < 3)
         {
            return true;
         }
         if(param2.name.toLowerCase().indexOf(param1) != -1)
         {
            return false;
         }
         while(true)
         {
            loop0:
            for each(_loc3_ in param2.effects)
            {
               switch(_loc3_.effectId)
               {
                  case 623:
                  case 628:
                     _loc4_ = this.dataApi.getMonsterFromId(int(_loc3_.parameter2));
                     if(_loc4_ && _loc4_.name && _loc4_.name.toLowerCase().indexOf(param1) != -1)
                     {
                        break loop0;
                     }
                     continue;
                  default:
                     continue;
               }
            }
            return true;
         }
         return false;
      }
      
      private function onExchangeError(param1:int) : void
      {
         var _loc2_:ItemWrapper = null;
         if(param1 == ExchangeErrorEnum.BID_SEARCH_ERROR)
         {
            this.mainCtr.visible = true;
            this._currentGrid = this.gd_classicList;
            this.classicItemCtr.visible = false;
            this.detailItemCtr.visible = false;
            _loc2_ = StockBidHouse.getInstance().selectedStockItem;
            this.sysApi.sendAction(new ExchangeBidHousePrice(_loc2_.objectGID));
            this._item = _loc2_;
            this.showItem(_loc2_);
            this.lbl_noItem.visible = true;
         }
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this.inp_search.haveFocus && this.inp_search.text != this.INPUT_SEARCH_DEFAULT_TEXT)
         {
            if(this.inp_search.text.length)
            {
               this._currentFilter = this.utilApi.noAccent(this.inp_search.text).toLowerCase();
               this.btn_closeSearch.visible = true;
            }
            else if(this._currentFilter)
            {
               this._currentFilter = null;
               this.btn_closeSearch.visible = false;
            }
            this.refreshBidObjectList(false);
         }
      }
      
      private function onExchangeBidPrice(param1:uint, param2:int) : void
      {
         var _loc4_:Boolean = false;
         var _loc3_:int = 15;
         if(param2 != -1)
         {
            this.lbl_averagePrice.text = this.utilApi.kamasToString(param2,"");
            _loc4_ = true;
         }
         else
         {
            this.lbl_averagePrice.text = this.uiApi.getText("ui.item.averageprice.unavailable");
            _loc4_ = false;
            _loc3_ = 5;
         }
         this.lbl_averagePriceTitle.fullWidth();
         var _loc5_:Number = this.lbl_averagePrice.textWidth + this.tx_kamas.width;
         this.lbl_averagePriceTitle.x = this.mainCtr.width - _loc3_ - (this.lbl_averagePriceTitle.textWidth + _loc5_) - 10;
         this.lbl_averagePrice.x = this.lbl_averagePriceTitle.x + this.lbl_averagePriceTitle.width;
         this.tx_kamas.x = this.lbl_averagePrice.x + this.lbl_averagePrice.textWidth + 10;
         this.tx_kamas.visible = _loc4_;
         this.averagePriceCtr.visible = true;
      }
      
      private function onConfirmBuyObject() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         if(this.currentCase > -1)
         {
            _loc1_ = this._sellerBuyerDescriptor.quantities[this.currentCase];
            _loc2_ = this._selectedItem.prices[this.currentCase];
            this.sysApi.sendAction(new ExchangeBidHouseBuy(this._selectedItem.itemWrapper.objectUID,_loc1_,_loc2_));
         }
         else
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.bidhouse.bigStore"),this.uiApi.getText("ui.bidhouse.itemNotInBigStore"),[this.uiApi.getText("ui.common.ok")]);
         }
      }
      
      private function onCancelBuyObject() : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(param1 == this.btn_buy)
         {
            if(this._currentGrid.selectedItem != null && this.currentCase != -1)
            {
               this._selectedItem = this._currentGrid.selectedItem;
               _loc2_ = this.currentCase;
               _loc3_ = this._selectedItem.prices[_loc2_];
               _loc4_ = this._selectedItem.itemWrapper.name;
               if(_loc3_ > 0)
               {
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.bidhouse.doUBuyItemBigStore",this._sellerBuyerDescriptor.quantities[_loc2_] + " x " + _loc4_,this.utilApi.kamasToString(int(_loc3_ / int(this._sellerBuyerDescriptor.quantities[_loc2_]))),this.utilApi.kamasToString(_loc3_)),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmBuyObject,this.onCancelBuyObject],this.onConfirmBuyObject,this.onCancelBuyObject);
               }
            }
         }
         else if(param1 == this.btn_tabQty1 || param1 == this.btn_price)
         {
            if(this._currentSort == 1)
            {
               this._currentSort = -1;
               this.onBidObjectListUpdate(this._listObjects,true);
            }
            else
            {
               this._currentSort = 1;
               this.onBidObjectListUpdate(this._listObjects,true);
            }
         }
         else if(param1 == this.btn_tabQty2)
         {
            if(this._currentSort == 2)
            {
               this._currentSort = -2;
               this.onBidObjectListUpdate(this._listObjects,true);
            }
            else
            {
               this._currentSort = 2;
               this.onBidObjectListUpdate(this._listObjects,true);
            }
         }
         else if(param1 == this.btn_tabQty3)
         {
            if(this._currentSort == 3)
            {
               this._currentSort = -3;
               this.onBidObjectListUpdate(this._listObjects,true);
            }
            else
            {
               this._currentSort = 3;
               this.onBidObjectListUpdate(this._listObjects,true);
            }
         }
         else if(param1 == this.btn_name)
         {
            if(this._currentSort == 4)
            {
               this._currentSort = -4;
               this.onBidObjectListUpdate(this._listObjects,true);
            }
            else
            {
               this._currentSort = 4;
               this.onBidObjectListUpdate(this._listObjects,true);
            }
         }
         else if(param1 == this.btn_size)
         {
            if(this._currentSort == 5)
            {
               this._currentSort = -5;
               this.onBidObjectListUpdate(this._listObjects,true);
            }
            else
            {
               this._currentSort = 5;
               this.onBidObjectListUpdate(this._listObjects,true);
            }
         }
         else if(param1 == this.inp_search && this.inp_search.text == this.INPUT_SEARCH_DEFAULT_TEXT)
         {
            this.inp_search.text = "";
         }
         else if(param1 == this.btn_closeSearch)
         {
            this._currentFilter = null;
            this.btn_closeSearch.visible = false;
            this.inp_search.text = this.INPUT_SEARCH_DEFAULT_TEXT;
            this.refreshBidObjectList(false);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         switch(param1)
         {
            case this._currentGrid:
               if(this._currentGrid.selectedItem)
               {
                  this.onObjectSelected(this._currentGrid.selectedItem.itemWrapper);
                  if(this.currentCase != -1 && this._currentGrid.selectedItem.prices[this.currentCase] > 0)
                  {
                     this.btn_buy.disabled = false;
                  }
                  else
                  {
                     this.btn_buy.disabled = true;
                  }
                  _loc4_ = this._currentGrid.selectedItem.itemWrapper;
                  if(param2 == SelectMethodEnum.DOUBLE_CLICK)
                  {
                     if(_loc4_ && _loc4_.category != 0 && _loc4_.hasOwnProperty("isCertificate") && _loc4_.isCertificate)
                     {
                        this.sysApi.sendAction(new MountInfoRequest(_loc4_));
                     }
                  }
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc2_:uint = 7;
         var _loc3_:uint = 1;
         var _loc5_:Object = null;
         switch(param1)
         {
            case this.lbl_averagePriceTitle:
            case this.lbl_averagePrice:
               _loc4_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.bidhouse.bigStoreMiddlePrice"));
               break;
            case this.tx_item:
               _loc4_ = this._item;
               param1 = this.lbl_item_name;
               _loc5_ = {"showEffects":false};
         }
         this.uiApi.showTooltip(_loc4_,param1,false,"standard",_loc2_,_loc3_,3,null,null,_loc5_);
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onObjectSelected(param1:Object) : void
      {
         if(param1)
         {
            this._item = param1;
            this.showItem(param1 as ItemWrapper);
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         if(TradeCenter.BID_HOUSE_BUY_MODE)
         {
            switch(param1)
            {
               case "validUi":
                  return true;
            }
         }
         return false;
      }
      
      public function onChange(param1:Object) : void
      {
         if(param1 == this.inp_search && this.inp_search.haveFocus)
         {
            if(this.inp_search.text.length > 2 || this._currentFilter && this.inp_search.text.length == 0)
            {
               this._currentFilter = this.inp_search.text.toLowerCase();
               this.refreshBidObjectList(false);
            }
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         this.modContextMenu.createContextMenu(this.menuApi.create(this._item));
      }
      
      public function unload() : void
      {
         this.onCancelSearch();
         this.uiApi.unloadUi("itemBox");
      }
      
      private function useDetailView(param1:Object) : Boolean
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_.itemWrapper.name != _loc2_.itemWrapper.realName)
            {
               return true;
            }
         }
         return false;
      }
      
      private function showItem(param1:ItemWrapper) : void
      {
         this.lbl_item_name.cssClass = "whitebold";
         if(param1.etheral)
         {
            this.lbl_item_name.cssClass = "itemetheral";
         }
         if(param1.itemSetId != -1)
         {
            this.lbl_item_name.cssClass = "itemset";
         }
         this.lbl_item_name.text = param1.name;
         if(this.sysApi.getPlayerManager().hasRights)
         {
            this.lbl_item_name.text = this.lbl_item_name.text + (" (" + param1.id + ")");
         }
         this.lbl_item_level.text = this.uiApi.getText("ui.common.short.level") + " " + param1.level;
         this.tx_item.uri = param1.fullSizeIconUri;
         if(this.averagePricesApi.getItemAveragePrice(param1.id) == 0)
         {
            this.onExchangeBidPrice(param1.objectGID,-1);
         }
      }
   }
}
