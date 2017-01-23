package ui
{
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2actions.ExchangeBidHousePrice;
   import d2actions.ExchangeObjectModifyPriced;
   import d2actions.ExchangeShopStockMouvmentAdd;
   import d2actions.ExchangeShopStockMouvmentRemove;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2hooks.ExchangeBidPriceForSeller;
   import d2hooks.ObjectDeleted;
   import d2hooks.SellerObjectListUpdate;
   
   public class ItemBidHouseSell extends BasicItemCard
   {
      
      private static const RELATION_MINI_FOR_WARNING_POPUP:int = 5;
      
      private static var _lastSell:Object;
       
      
      public var soundApi:SoundApi;
      
      public var _sellerDescriptor:Object;
      
      private var _exchangeQuantity:uint;
      
      private var _itemName:String;
      
      private var _mode:Boolean;
      
      private var _price:uint;
      
      private var _averagePrice:int = -1;
      
      private var _oldPrice:uint;
      
      private var _tax:uint;
      
      private var _maxQuantityReached:Boolean = false;
      
      private var _currentObjectToRemove:Object;
      
      private var _priceWarningPopupName:String;
      
      public var lbl_error:Label;
      
      public var lbl_quantity:Label;
      
      public var lbl_taxTimeTitle:Label;
      
      public var lbl_taxTime:Label;
      
      public var lbl_averagePrice:Label;
      
      public var lbl_averagePriceTitle:Label;
      
      public var lbl_currentPriceQty0:Label;
      
      public var lbl_currentPriceQty1:Label;
      
      public var lbl_currentPriceQty2:Label;
      
      public var lbl_currentPrice0:Label;
      
      public var lbl_currentPrice1:Label;
      
      public var lbl_currentPrice2:Label;
      
      public var lbl_noCurrentPrice:Label;
      
      public var cb_quantity:ComboBox;
      
      public var ctr_sellingGroup:Object;
      
      public var tx_miniPricesWarning:Texture;
      
      public var ctr_minimumPrices:GraphicContainer;
      
      public function ItemBidHouseSell()
      {
         super();
      }
      
      override public function main(param1:Object = null) : void
      {
         super.main(param1);
         sysApi.addHook(ExchangeBidPriceForSeller,this.onExchangeBidPriceForSeller);
         sysApi.addHook(SellerObjectListUpdate,this.onSellerObjectListUpdate);
         sysApi.addHook(ObjectDeleted,this.onObjectDeleted);
         uiApi.addShortcutHook("validUi",this.onShortcut);
         uiApi.addComponentHook(this.tx_miniPricesWarning,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.tx_miniPricesWarning,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.lbl_averagePriceTitle,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.lbl_averagePriceTitle,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.lbl_averagePrice,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.lbl_averagePrice,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.lbl_currentPriceQty0,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.lbl_currentPriceQty0,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.lbl_currentPriceQty1,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.lbl_currentPriceQty1,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.lbl_currentPriceQty2,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.lbl_currentPriceQty2,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.lbl_currentPrice0,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.lbl_currentPrice0,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.lbl_currentPrice1,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.lbl_currentPrice1,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.lbl_currentPrice2,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.lbl_currentPrice2,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.lbl_taxTimeTitle,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.lbl_taxTimeTitle,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(btn_valid,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(btn_valid,ComponentHookList.ON_ROLL_OUT);
         ctr_inputQty.visible = false;
         this._sellerDescriptor = param1.sellerBuyerDescriptor;
         this.lbl_currentPriceQty0.text = "x " + this._sellerDescriptor.quantities[0];
         this.lbl_currentPriceQty1.text = "x " + this._sellerDescriptor.quantities[1];
         this.lbl_currentPriceQty2.text = "x " + this._sellerDescriptor.quantities[2];
      }
      
      public function onSelectItemFromInventory(param1:Object) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:uint = 0;
         if(TradeCenter.BID_HOUSE_BUY_MODE)
         {
            return;
         }
         this._mode = true;
         onObjectSelected(param1);
         this._itemName = param1.name;
         this.lbl_quantity.visible = false;
         this.cb_quantity.visible = true;
         if(param1.name == param1.realName)
         {
            this.cb_quantity.disabled = false;
         }
         else
         {
            this.cb_quantity.disabled = true;
         }
         this.ctr_sellingGroup.visible = false;
         this.lbl_error.visible = false;
         btn_valid.softDisabled = true;
         this.lbl_taxTime.text = "";
         this.lbl_taxTimeTitle.text = uiApi.getText("ui.bidhouse.bigStoreTax") + uiApi.getText("ui.common.colon");
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:int = this._sellerDescriptor.types.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(this._sellerDescriptor.types[_loc5_] == _currentObject.typeId)
            {
               _loc2_ = true;
               for each(_loc6_ in _currentObject.effects)
               {
                  if(_loc6_.effectId == 981 || _loc6_.effectId == 982 || _loc6_.effectId == 983)
                  {
                     _loc3_ = true;
                  }
               }
               break;
            }
            _loc5_++;
         }
         if(!_loc2_)
         {
            this.lbl_error.text = uiApi.getText("ui.bidhouse.badType");
            this.lbl_error.visible = true;
         }
         else if(_loc3_)
         {
            this.lbl_error.text = uiApi.getText("ui.bidhouse.badExchange");
            this.lbl_error.visible = true;
         }
         else if(_currentObject.level > this._sellerDescriptor.maxItemLevel)
         {
            this.lbl_error.text = uiApi.getText("ui.bidhouse.badLevel");
            this.lbl_error.visible = true;
         }
         else
         {
            _loc7_ = new Array();
            _loc8_ = TradeCenter.QUANTITIES.length;
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               _loc10_ = TradeCenter.QUANTITIES[_loc9_];
               if(_currentObject.quantity >= _loc10_)
               {
                  _loc7_.push({
                     "label":String(_loc10_),
                     "quantity":_loc9_ + 1
                  });
               }
               _loc9_++;
            }
            this.cb_quantity.dataProvider = _loc7_;
            if(param1.name == param1.realName)
            {
               if(TradeCenter.SALES_QUANTITIES[param1.objectGID] && TradeCenter.SALES_QUANTITIES[param1.objectGID] <= this.cb_quantity.dataProvider.length)
               {
                  this.cb_quantity.selectedIndex = TradeCenter.SALES_QUANTITIES[param1.objectGID] - 1;
               }
               else
               {
                  this.cb_quantity.selectedIndex = _loc7_.length - 1;
               }
            }
            else
            {
               this.cb_quantity.selectedIndex = 0;
            }
            btn_valid.visible = true;
            btn_remove.visible = false;
            btn_modify.visible = false;
            if(this._maxQuantityReached)
            {
               btn_valid.softDisabled = true;
            }
            else
            {
               btn_valid.softDisabled = false;
            }
            if(TradeCenter.SALES_PRICES[param1.objectGID] && TradeCenter.SALES_PRICES[param1.objectGID][this.cb_quantity.value.quantity - 1])
            {
               input_price.text = utilApi.kamasToString(TradeCenter.SALES_PRICES[param1.objectGID][this.cb_quantity.value.quantity - 1],"");
            }
            else
            {
               input_price.text = "0";
            }
            input_price.focus();
            input_price.setSelection(0,8388607);
            this.updateTax();
            this.ctr_sellingGroup.visible = true;
         }
         sysApi.sendAction(new ExchangeBidHousePrice(_currentObject.objectGID));
         uiApi.getUi("stockBidHouse").uiClass.gd_shop.selectedIndex = -1;
      }
      
      public function onSelectItemFromStockBidHouse(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._mode = false;
         onObjectSelected(param1.itemWrapper);
         this.cb_quantity.visible = false;
         this.lbl_quantity.visible = true;
         this.ctr_sellingGroup.visible = true;
         this.lbl_error.visible = false;
         this._exchangeQuantity = TradeCenter.QUANTITIES.indexOf(_currentObject.quantity);
         var _loc2_:Object = dataApi.getItem(_currentObject.objectGID);
         this._itemName = _loc2_.name;
         input_price.text = param1.price;
         this._oldPrice = param1.price;
         input_price.focus();
         input_price.setSelection(0,8388607);
         this.lbl_quantity.text = _currentObject.quantity.toString();
         sysApi.sendAction(new ExchangeBidHousePrice(_currentObject.objectGID));
         this.lbl_taxTimeTitle.text = uiApi.getText("ui.bidhouse.bigStoreTime") + uiApi.getText("ui.common.colon");
         this.lbl_taxTime.text = Math.round(param1.unsoldDelay / 3600) + " " + uiApi.getText("ui.common.hourShort");
         btn_valid.visible = false;
         btn_remove.visible = true;
         btn_modify.visible = true;
      }
      
      public function displayUi(param1:Boolean) : void
      {
         if(!param1)
         {
            hideCard();
         }
      }
      
      private function updateTax() : void
      {
         var _loc1_:int = utilApi.stringToKamas(input_price.text,"");
         if(this._mode || _loc1_ != this._oldPrice)
         {
            if(this._sellerDescriptor.taxPercentage == 0)
            {
               this._tax = 0;
            }
            else if(this._mode)
            {
               this._tax = Math.max(1,int(_loc1_ * this._sellerDescriptor.taxPercentage / 100 + 0.5));
            }
            else if(this._oldPrice < _loc1_)
            {
               this._tax = Math.max(1,int((_loc1_ - this._oldPrice) * this._sellerDescriptor.taxPercentage / 100 + 0.5));
            }
            else
            {
               this._tax = Math.max(1,int(_loc1_ * this._sellerDescriptor.taxModificationPercentage / 100 + 0.5));
            }
            this.lbl_taxTime.text = utilApi.kamasToString(this._tax);
            if(this._mode)
            {
               this.lbl_taxTimeTitle.text = uiApi.getText("ui.bidhouse.bigStoreTax") + uiApi.getText("ui.common.colon");
            }
            else
            {
               this.lbl_taxTimeTitle.text = uiApi.getText("ui.bidhouse.bigStoreModificationTax") + uiApi.getText("ui.common.colon");
            }
            if(this._tax > playerApi.characteristics().kamas)
            {
               btn_valid.softDisabled = true;
               this.lbl_taxTimeTitle.cssClass = "red";
            }
            else
            {
               if(!this._maxQuantityReached)
               {
                  btn_valid.softDisabled = false;
               }
               this.lbl_taxTimeTitle.cssClass = "p";
            }
         }
      }
      
      private function onConfirmSellObject() : void
      {
         sysApi.sendAction(new ExchangeShopStockMouvmentAdd(_currentObject.objectUID,TradeCenter.QUANTITIES[this._exchangeQuantity],this._price));
         if(!TradeCenter.SALES_PRICES[_currentObject.objectGID])
         {
            TradeCenter.SALES_PRICES[_currentObject.objectGID] = new Array();
         }
         TradeCenter.SALES_PRICES[_currentObject.objectGID][this._exchangeQuantity] = this._price;
         if(this._exchangeQuantity < this.cb_quantity.dataProvider.length)
         {
            TradeCenter.SALES_QUANTITIES[_currentObject.objectGID] = this._exchangeQuantity + 1;
         }
         var _loc1_:Object = uiApi.textTooltipInfo(uiApi.getText("ui.bidhouse.successSell"));
         uiApi.showTooltip(_loc1_,btn_valid,true,"standard",7,1,3,null,null,null,"TextInfo");
      }
      
      private function onConfirmModifyObject() : void
      {
         sysApi.sendAction(new ExchangeObjectModifyPriced(_currentObject.objectUID,TradeCenter.QUANTITIES[this._exchangeQuantity],this._price));
         if(!TradeCenter.SALES_PRICES[_currentObject.objectGID])
         {
            TradeCenter.SALES_PRICES[_currentObject.objectGID] = new Array();
         }
         TradeCenter.SALES_PRICES[_currentObject.objectGID][this._exchangeQuantity] = this._price;
         if(this._exchangeQuantity < this.cb_quantity.dataProvider.length)
         {
            TradeCenter.SALES_QUANTITIES[_currentObject.objectGID] = this._exchangeQuantity + 1;
         }
         hideCard();
      }
      
      private function onConfirmWithdrawObject() : void
      {
         sysApi.sendAction(new ExchangeShopStockMouvmentRemove(this._currentObjectToRemove.objectUID,-TradeCenter.QUANTITIES[this._exchangeQuantity]));
         hideCard();
      }
      
      private function onCancelSellObject() : void
      {
      }
      
      private function putOnSell() : void
      {
         var _loc1_:Number = this._price / int(TradeCenter.QUANTITIES[this._exchangeQuantity]);
         if(this._averagePrice > -1 && _loc1_ * RELATION_MINI_FOR_WARNING_POPUP < this._averagePrice || _loc1_ > this._averagePrice * RELATION_MINI_FOR_WARNING_POPUP)
         {
            modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.bidhouse.doUSellItemBigStore",TradeCenter.QUANTITIES[this._exchangeQuantity] + " x " + _currentObject.name,utilApi.kamasToString(_loc1_),utilApi.kamasToString(this._price),utilApi.kamasToString(this._tax)),[uiApi.getText("ui.common.yes"),uiApi.getText("ui.common.no")],[this.onConfirmSellObject,this.onCancelSellObject],this.onConfirmSellObject,this.onCancelSellObject);
         }
         else
         {
            this.onConfirmSellObject();
         }
      }
      
      private function putOnSellAgain() : void
      {
         var _loc1_:Number = this._price / int(TradeCenter.QUANTITIES[this._exchangeQuantity]);
         if(this._averagePrice > -1 && _loc1_ * RELATION_MINI_FOR_WARNING_POPUP < this._averagePrice || _loc1_ > this._averagePrice * RELATION_MINI_FOR_WARNING_POPUP)
         {
            modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.bidhouse.doUModifyPriceInMarket",TradeCenter.QUANTITIES[this._exchangeQuantity] + " x " + _currentObject.name,utilApi.kamasToString(this._oldPrice),utilApi.kamasToString(this._price),utilApi.kamasToString(this._tax)),[uiApi.getText("ui.common.yes"),uiApi.getText("ui.common.no")],[this.onConfirmModifyObject,this.onCancelSellObject],this.onConfirmModifyObject,this.onCancelSellObject);
         }
         else
         {
            this.onConfirmModifyObject();
         }
      }
      
      private function withdrawFromSell() : void
      {
         modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.bidhouse.doUWithdrawItemBigStore",TradeCenter.QUANTITIES[this._exchangeQuantity] + " x " + this._currentObjectToRemove.name,utilApi.kamasToString(this._price / int(TradeCenter.QUANTITIES[this._exchangeQuantity]))),[uiApi.getText("ui.common.yes"),uiApi.getText("ui.common.no")],[this.onConfirmWithdrawObject,this.onCancelSellObject],this.onConfirmWithdrawObject,this.onCancelSellObject);
      }
      
      private function onExchangeBidPriceForSeller(param1:uint, param2:int, param3:Object, param4:Boolean) : void
      {
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         this._averagePrice = param2;
         if(param2 != -1)
         {
            this.lbl_averagePrice.text = utilApi.kamasToString(param2);
         }
         else
         {
            this.lbl_averagePrice.text = uiApi.getText("ui.item.averageprice.unavailable");
         }
         this.tx_miniPricesWarning.visible = !param4;
         var _loc5_:Boolean = false;
         var _loc6_:Vector.<uint> = new Vector.<uint>();
         for each(_loc7_ in param3)
         {
            _loc6_.push(_loc7_);
         }
         if(param3 && _loc6_.length == this._sellerDescriptor.quantities.length)
         {
            for each(_loc8_ in _loc6_)
            {
               if(_loc8_ > 0)
               {
                  _loc5_ = true;
                  break;
               }
            }
         }
         if(!_loc5_)
         {
            this.ctr_minimumPrices.visible = false;
            this.lbl_noCurrentPrice.visible = true;
         }
         else
         {
            if(_loc6_[0] == 0)
            {
               this.lbl_currentPrice0.text = "-";
            }
            else
            {
               this.lbl_currentPrice0.text = utilApi.kamasToString(_loc6_[0]);
            }
            if(_loc6_[1] == 0)
            {
               this.lbl_currentPrice1.text = "-";
            }
            else
            {
               this.lbl_currentPrice1.text = utilApi.kamasToString(_loc6_[1]);
            }
            if(_loc6_[2] == 0)
            {
               this.lbl_currentPrice2.text = "-";
            }
            else
            {
               this.lbl_currentPrice2.text = utilApi.kamasToString(_loc6_[2]);
            }
            this.ctr_minimumPrices.visible = true;
            this.lbl_noCurrentPrice.visible = false;
         }
      }
      
      public function onSellerObjectListUpdate(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         for each(_loc3_ in param1)
         {
            _loc2_++;
         }
         if(_loc2_ >= this._sellerDescriptor.maxItemPerAccount)
         {
            this._maxQuantityReached = true;
         }
         else
         {
            this._maxQuantityReached = false;
         }
         if(this._maxQuantityReached && this._mode)
         {
            btn_valid.softDisabled = true;
         }
         else
         {
            btn_valid.softDisabled = false;
         }
      }
      
      public function onObjectDeleted(param1:Object) : void
      {
         if(_currentObject && _currentObject.objectUID == param1.objectUID)
         {
            _currentObject = null;
            hideCard();
         }
      }
      
      override public function onRelease(param1:Object) : void
      {
         var _loc2_:* = false;
         if(param1 == btn_valid && this._mode)
         {
            this._price = utilApi.stringToKamas(input_price.text,"");
            if(this._price > 0)
            {
               this.putOnSell();
            }
         }
         else if(param1 == btn_remove && !this._mode)
         {
            this._currentObjectToRemove = _currentObject;
            this.withdrawFromSell();
         }
         else if(param1 == btn_modify && !this._mode)
         {
            this._price = utilApi.stringToKamas(input_price.text,"");
            _loc2_ = this._price != this._oldPrice;
            if(_loc2_ && this._price > 0)
            {
               this.putOnSellAgain();
            }
         }
      }
      
      override public function onRollOver(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         var _loc5_:Object = null;
         switch(param1)
         {
            case this.lbl_averagePriceTitle:
            case this.lbl_averagePrice:
               _loc2_ = uiApi.textTooltipInfo(uiApi.getText("ui.bidhouse.bigStoreMiddlePrice"));
               break;
            case this.tx_miniPricesWarning:
               _loc2_ = uiApi.textTooltipInfo(uiApi.getText("ui.bidhouse.warningMinimumPrice"));
               break;
            case this.lbl_currentPrice0:
            case this.lbl_currentPrice1:
            case this.lbl_currentPrice2:
            case this.lbl_currentPriceQty0:
            case this.lbl_currentPriceQty1:
            case this.lbl_currentPriceQty2:
               _loc2_ = uiApi.textTooltipInfo(uiApi.getText("ui.bidhouse.minimumPrice"));
               break;
            case this.lbl_taxTimeTitle:
               if(this._tax <= playerApi.characteristics().kamas)
               {
                  return;
               }
               _loc2_ = uiApi.textTooltipInfo(uiApi.getText("ui.bidhouse.noKamaForTax"));
               break;
            case tx_item:
               _loc2_ = _currentObject;
               _loc3_ = LocationEnum.POINT_TOPRIGHT;
               _loc4_ = LocationEnum.POINT_TOPLEFT;
               _loc5_ = {"showEffects":false};
               break;
            case btn_valid:
               if(!btn_valid.softDisabled)
               {
                  return;
               }
               if(this._maxQuantityReached)
               {
                  _loc2_ = uiApi.textTooltipInfo(uiApi.getText("ui.bidhouse.maxQuantityReached"));
               }
               else if(this._tax > playerApi.characteristics().kamas)
               {
                  _loc2_ = uiApi.textTooltipInfo(uiApi.getText("ui.bidhouse.noKamaForTax"));
               }
               break;
         }
         uiApi.showTooltip(_loc2_,param1,false,"standard",_loc3_,_loc4_,3,null,null,_loc5_);
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.cb_quantity)
         {
            this._exchangeQuantity = param1.value.quantity - 1;
            if(TradeCenter.SALES_PRICES[_currentObject.objectGID] && TradeCenter.SALES_PRICES[_currentObject.objectGID][this._exchangeQuantity])
            {
               input_price.text = utilApi.kamasToString(TradeCenter.SALES_PRICES[_currentObject.objectGID][this._exchangeQuantity],"");
               input_price.focus();
               input_price.setSelection(0,8388607);
               this.updateTax();
            }
            else
            {
               input_price.text = "0";
               this.updateTax();
            }
         }
      }
      
      override public function onChange(param1:GraphicContainer) : void
      {
         var _loc2_:int = 0;
         if(param1 == input_price && input_price.haveFocus)
         {
            this.updateTax();
            if(!this._priceWarningPopupName)
            {
               _loc2_ = utilApi.stringToKamas(input_price.text,"");
               if(_loc2_ >= PRICE_LIMIT)
               {
                  this._priceWarningPopupName = modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.bidhouse.priceWarning"),[uiApi.getText("ui.common.ok")],[this.onPriceWarningClose],this.onPriceWarningClose,this.onPriceWarningClose);
               }
            }
         }
      }
      
      private function onPriceWarningClose() : void
      {
         this._priceWarningPopupName = null;
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         var _loc2_:* = false;
         if(!TradeCenter.BID_HOUSE_BUY_MODE)
         {
            switch(param1)
            {
               case "validUi":
                  if(!uiVisible || !_currentObject)
                  {
                     return false;
                  }
                  this.soundApi.playSoundById(SoundEnum.STORE_SELL_BUTTON);
                  if(this.ctr_sellingGroup.visible && this._mode)
                  {
                     this._price = utilApi.stringToKamas(input_price.text,"");
                     if(this._price > 0)
                     {
                        this.putOnSell();
                        btn_valid.focus();
                     }
                  }
                  else
                  {
                     this._price = utilApi.stringToKamas(input_price.text,"");
                     _loc2_ = this._price != this._oldPrice;
                     if(_loc2_ && this._price > 0)
                     {
                        this.putOnSellAgain();
                     }
                  }
                  return true;
            }
         }
         return false;
      }
   }
}
