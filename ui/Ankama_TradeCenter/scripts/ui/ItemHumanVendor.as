package ui
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import d2actions.ExchangeBuy;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.BuyOk;
   import d2hooks.ClickItemShopHV;
   
   public class ItemHumanVendor extends BasicItemCard
   {
      
      private static var _self:ItemHumanVendor;
       
      
      private var _popup:String;
      
      public function ItemHumanVendor()
      {
         super();
      }
      
      public static function getInstance() : ItemHumanVendor
      {
         if(_self == null)
         {
            return null;
         }
         return _self;
      }
      
      override public function main(param1:Object = null) : void
      {
         super.main(param1);
         sysApi.addHook(ClickItemShopHV,this.onClickItemShopHV);
         uiApi.addShortcutHook(ShortcutHookListEnum.VALID_UI,this.onShortcut);
         sysApi.addHook(BuyOk,this.onBuyOk);
         _self = this;
         ctr_inputPrice.visible = false;
         btn_lbl_btn_valid.text = uiApi.getText("ui.common.buy");
      }
      
      override public function unload() : void
      {
         if(this._popup)
         {
            uiApi.unloadUi(this._popup);
         }
         super.unload();
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case btn_valid:
               if(utilApi.stringToKamas(input_quantity.text,"") > _currentObject.quantity || utilApi.stringToKamas(input_quantity.text,"") == 0)
               {
                  this._popup = modCommon.openPopup(uiApi.getText("ui.common.error"),uiApi.getText("ui.error.invalidQuantity"),[uiApi.getText("ui.common.ok")],[this.onCancel],this.onCancel,this.onCancel);
                  break;
               }
               this._popup = modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.bidhouse.doUBuyItemBigStore",input_quantity.text + " x " + _currentObject.name,utilApi.kamasToString(_currentPrice),utilApi.kamasToString(_currentPrice * utilApi.stringToKamas(input_quantity.text,""))),[uiApi.getText("ui.common.yes"),uiApi.getText("ui.common.no")],[this.onConfirmBuyObject,this.onCancel],this.onConfirmBuyObject,this.onCancel);
               break;
         }
      }
      
      private function onConfirmBuyObject() : void
      {
         this._popup = null;
         sysApi.sendAction(new ExchangeBuy(_currentObject.objectUID,utilApi.stringToKamas(input_quantity.text,"")));
      }
      
      private function onCancel() : void
      {
         this._popup = null;
      }
      
      public function onClickItemShopHV(param1:Object, param2:uint = 0) : void
      {
         _currentPrice = param2;
         onObjectSelected(param1);
         lbl_price.text = utilApi.kamasToString(_currentPrice,"");
         input_quantity.text = "1";
         input_quantity.setSelection(0,8388607);
         input_quantity.focus();
         lbl_totalPrice.text = utilApi.kamasToString(_currentPrice,"");
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case ShortcutHookListEnum.VALID_UI:
               if(input_quantity.haveFocus)
               {
                  this.onRelease(btn_valid);
                  return true;
               }
               break;
         }
         return false;
      }
      
      override public function onChange(param1:GraphicContainer) : void
      {
         if(param1 == input_quantity)
         {
            if(utilApi.stringToKamas(input_quantity.text,"") > _currentObject.quantity)
            {
               lbl_totalPrice.text = utilApi.kamasToString(_currentPrice * _currentObject.quantity,"");
               input_quantity.text = utilApi.kamasToString(_currentObject.quantity,"");
            }
            else
            {
               lbl_totalPrice.text = utilApi.kamasToString(_currentPrice * utilApi.stringToKamas(input_quantity.text,""),"");
            }
            super.checkPlayerFund(utilApi.stringToKamas(input_quantity.text));
         }
      }
      
      private function onBuyOk() : void
      {
         hideCard();
      }
   }
}
