package ui
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import d2actions.ExchangeBuy;
   import d2actions.ExchangeSell;
   import d2hooks.BuyOk;
   import d2hooks.ClickItemInventory;
   import d2hooks.ClickItemStore;
   import d2hooks.ObjectDeleted;
   import d2hooks.SellOk;
   
   public class ItemNpcStore extends BasicItemCard
   {
       
      
      private var _mode:Boolean;
      
      private var _token:int;
      
      public function ItemNpcStore()
      {
         super();
      }
      
      override public function main(param1:Object = null) : void
      {
         super.main(param1);
         sysApi.addHook(ClickItemStore,this.onClickItemStore);
         sysApi.addHook(ClickItemInventory,this.onClickItemInventory);
         sysApi.addHook(ObjectDeleted,this.onObjectDeleted);
         sysApi.addHook(SellOk,this.onSellOk);
         sysApi.addHook(BuyOk,this.onBuyOk);
         super.tx_inputQuantity.visible = true;
         super.input_quantity.numberMax = 999999999;
         if(this._token != 0)
         {
            super.tx_kama.visible = false;
         }
      }
      
      override public function unload() : void
      {
         super.unload();
      }
      
      override public function onRelease(param1:Object) : void
      {
         var _loc2_:RegExp = null;
         var _loc3_:String = null;
         switch(param1)
         {
            case btn_valid:
               _loc2_ = /^\s*(.*?)\s*$/g;
               input_quantity.text = input_quantity.text.replace(_loc2_,"$1");
               input_price.text = input_price.text.replace(_loc2_,"$1");
               _loc3_ = "";
               if(this._token)
               {
                  _loc3_ = "x " + dataApi.getItemName(this._token);
               }
               if(this._mode)
               {
                  if(utilApi.stringToKamas(input_quantity.text,"") <= 0 || utilApi.stringToKamas(input_quantity.text,"") > _currentObject.quantity)
                  {
                     modCommon.openPopup(uiApi.getText("ui.common.error"),uiApi.getText("ui.error.invalidQuantity"),[uiApi.getText("ui.common.ok")]);
                     break;
                  }
                  if(!_loc3_)
                  {
                     modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.bidhouse.doUSellItemWithoutTax",input_quantity.text + " x " + _currentObject.name,utilApi.kamasToString(_currentPrice),utilApi.kamasToString(_currentPrice * utilApi.stringToKamas(input_quantity.text,"")),utilApi.kamasToString(0)),[uiApi.getText("ui.common.yes"),uiApi.getText("ui.common.no")],[this.onConfirmSellObject,this.onCancel],this.onConfirmSellObject,this.onCancel);
                  }
                  else
                  {
                     modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.bidhouse.doUSellItemWithoutTax",input_quantity.text + " x " + _currentObject.name,utilApi.kamasToString(_currentPrice,_loc3_),utilApi.kamasToString(_currentPrice * utilApi.stringToKamas(input_quantity.text,""),_loc3_),utilApi.kamasToString(0)),[uiApi.getText("ui.common.yes"),uiApi.getText("ui.common.no")],[this.onConfirmSellObject,this.onCancel],this.onConfirmSellObject,this.onCancel);
                  }
               }
               else
               {
                  if(utilApi.stringToKamas(input_quantity.text,"") <= 0)
                  {
                     modCommon.openPopup(uiApi.getText("ui.common.error"),uiApi.getText("ui.error.invalidQuantity"),[uiApi.getText("ui.common.ok")]);
                     break;
                  }
                  if(_loc3_ == "")
                  {
                     modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.bidhouse.doUBuyItemBigStore",input_quantity.text + " x " + _currentObject.name,utilApi.kamasToString(_currentPrice),utilApi.kamasToString(_currentPrice * utilApi.stringToKamas(input_quantity.text,""))),[uiApi.getText("ui.common.yes"),uiApi.getText("ui.common.no")],[this.onConfirmBuyObject,this.onCancel],this.onConfirmBuyObject,this.onCancel);
                  }
                  else
                  {
                     modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.bidhouse.doUBuyItemBigStore",input_quantity.text + " x " + _currentObject.name,utilApi.kamasToString(_currentPrice,_loc3_),utilApi.kamasToString(_currentPrice * utilApi.stringToKamas(input_quantity.text,""),_loc3_)),[uiApi.getText("ui.common.yes"),uiApi.getText("ui.common.no")],[this.onConfirmBuyObject,this.onCancel],this.onConfirmBuyObject,this.onCancel);
                  }
               }
         }
      }
      
      private function onConfirmSellObject() : void
      {
         sysApi.sendAction(new ExchangeSell(_currentObject.objectUID,utilApi.stringToKamas(input_quantity.text,"")));
      }
      
      private function onConfirmBuyObject() : void
      {
         sysApi.sendAction(new ExchangeBuy(_currentObject.objectGID,utilApi.stringToKamas(input_quantity.text,"")));
      }
      
      private function onCancel() : void
      {
      }
      
      public function onObjectDeleted(param1:Object) : void
      {
         if(_currentObject.objectUID == param1.objectUID)
         {
            _currentObject = null;
            super.hideCard();
         }
      }
      
      public function onClickItemStore(param1:Object, param2:int) : void
      {
         this._mode = false;
         onObjectSelected(param1.itemWrapper);
         ctr_inputPrice.visible = false;
         btn_lbl_btn_valid.text = uiApi.getText("ui.common.buy");
         var _loc3_:Object = dataApi.getItem(param1.itemWrapper.objectGID);
         _currentPrice = param1.price;
         this._token = param2;
         if(this._token != 0)
         {
            tx_kama.visible = false;
         }
         if(param2)
         {
            lbl_price.text = utilApi.kamasToString(_currentPrice,"");
         }
         else
         {
            lbl_price.text = utilApi.kamasToString(_currentPrice);
         }
         input_quantity.text = "1";
         input_quantity.focus();
         input_quantity.setSelection(0,8388607);
         if(param2)
         {
            lbl_totalPrice.text = utilApi.kamasToString(_currentPrice,"");
         }
         else
         {
            lbl_totalPrice.text = utilApi.kamasToString(_currentPrice,"");
         }
      }
      
      public function onClickItemInventory(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         this._mode = true;
         if(this._token == 0)
         {
            sysApi.log(2,"clic inventaire");
            onObjectSelected(param1);
            ctr_inputPrice.visible = false;
            btn_lbl_btn_valid.text = uiApi.getText("ui.common.sell");
            if(param1 != null)
            {
               _loc2_ = dataApi.getItem(param1.objectGID);
               _loc3_ = 0;
               _currentPrice = _loc2_.price;
               if(_currentPrice > 0)
               {
                  if(_currentPrice / TradeCenter.SELLING_RATIO < 1)
                  {
                     _loc3_ = 1;
                  }
                  else
                  {
                     _loc3_ = Math.floor(_currentPrice / TradeCenter.SELLING_RATIO);
                  }
               }
               _currentPrice = _loc3_;
               lbl_price.text = utilApi.kamasToString(_currentPrice);
               input_quantity.text = "1";
               input_quantity.focus();
               input_quantity.setSelection(0,8388607);
               lbl_totalPrice.text = utilApi.kamasToString(_currentPrice,"");
            }
         }
      }
      
      override public function onChange(param1:GraphicContainer) : void
      {
         var _loc2_:int = 0;
         if(param1 == input_quantity)
         {
            _loc2_ = utilApi.stringToKamas(input_quantity.text);
            if(this._mode)
            {
               if(_loc2_ > _currentObject.quantity)
               {
                  input_quantity.text = _currentObject.quantity;
                  _loc2_ = _currentObject.quantity;
               }
            }
            if(this._token)
            {
               lbl_totalPrice.text = utilApi.kamasToString(_currentPrice * _loc2_,"");
            }
            else
            {
               lbl_totalPrice.text = utilApi.kamasToString(_currentPrice * _loc2_,"");
            }
            if(!this._mode)
            {
               super.checkPlayerFund(_loc2_,this._token);
            }
            else
            {
               super.checkPlayerFund(0);
            }
         }
      }
      
      private function onSellOk() : void
      {
         hideCard();
      }
      
      private function onBuyOk() : void
      {
         hideCard();
      }
   }
}
