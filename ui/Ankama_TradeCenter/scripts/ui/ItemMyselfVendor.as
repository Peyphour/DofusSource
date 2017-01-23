package ui
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.ExchangeObjectModifyPriced;
   import d2actions.ExchangeShopStockMouvmentAdd;
   import d2actions.ExchangeShopStockMouvmentRemove;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.ClickItemInventory;
   import d2hooks.ClickItemShopHV;
   import d2hooks.ExchangeShopStockUpdate;
   import d2hooks.ObjectDeleted;
   
   public class ItemMyselfVendor extends BasicItemCard
   {
      
      public static const SELL_MOD:String = "sell_mod";
      
      public static const MODIFY_REMOVE_MOD:String = "modify_remove_mod";
      
      private static var _self:ItemMyselfVendor;
       
      
      public var soundApi:SoundApi;
      
      public var inventoryApi:InventoryApi;
      
      private var _currentMod:String;
      
      public function ItemMyselfVendor()
      {
         super();
      }
      
      public static function getInstance() : ItemMyselfVendor
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
         btn_valid.soundId = SoundEnum.MERCHANT_SELL_BUTTON;
         btn_remove.soundId = SoundEnum.MERCHANT_REMOVE_SELL_BUTTON;
         sysApi.addHook(ClickItemInventory,this.onClickItemInventory);
         sysApi.addHook(ClickItemShopHV,this.onClickItemShopHV);
         sysApi.addHook(ObjectDeleted,this.onObjectDeleted);
         sysApi.addHook(ExchangeShopStockUpdate,this.onExchangeShopStockUpdate);
         uiApi.addShortcutHook(ShortcutHookListEnum.VALID_UI,this.onShortcut);
         _self = this;
         lbl_price.visible = false;
         btn_lbl_btn_valid.text = uiApi.getText("ui.common.putOnSell");
      }
      
      private function switchMode(param1:Boolean) : void
      {
         btn_valid.visible = param1;
         btn_modify.visible = !param1;
         btn_remove.visible = !param1;
      }
      
      private function displayObject(param1:Object) : void
      {
         onObjectSelected(param1);
         if(param1)
         {
            if(_currentPrice > 0)
            {
               input_price.text = utilApi.kamasToString(_currentPrice,"");
            }
            else
            {
               input_price.text = "0";
            }
            input_quantity.text = utilApi.kamasToString(_currentObject.quantity,"");
            input_price.focus();
            input_price.setSelection(0,8388607);
            lbl_totalPrice.text = utilApi.kamasToString(_currentPrice * param1.quantity,"");
         }
      }
      
      private function checkQuantity() : Boolean
      {
         var _loc1_:RegExp = /^\s*(.*?)\s*$/g;
         input_quantity.text = input_quantity.text.replace(_loc1_,"$1");
         input_price.text = input_price.text.replace(_loc1_,"$1");
         if(input_quantity.text == "" || input_price.text == "")
         {
            modCommon.openPopup(uiApi.getText("ui.common.error"),uiApi.getText("ui.error.allFieldsRequired"),[uiApi.getText("ui.common.ok")]);
            return false;
         }
         if(utilApi.stringToKamas(input_quantity.text,"") <= 0)
         {
            modCommon.openPopup(uiApi.getText("ui.common.error"),uiApi.getText("ui.error.invalidQuantity"),[uiApi.getText("ui.common.ok")]);
            return false;
         }
         if(utilApi.stringToKamas(input_price.text,"") <= 0)
         {
            modCommon.openPopup(uiApi.getText("ui.common.error"),uiApi.getText("ui.error.invalidPrice"),[uiApi.getText("ui.common.ok")]);
            return false;
         }
         return true;
      }
      
      override public function onRelease(param1:Object) : void
      {
         var _loc2_:* = false;
         var _loc3_:* = false;
         switch(param1)
         {
            case btn_valid:
               if(this.checkQuantity())
               {
                  sysApi.sendAction(new ExchangeShopStockMouvmentAdd(_currentObject.objectUID,utilApi.stringToKamas(input_quantity.text,""),utilApi.stringToKamas(input_price.text,"")));
               }
               break;
            case btn_modify:
               _loc2_ = utilApi.stringToKamas(input_quantity.text,"") != _currentObject.quantity;
               _loc3_ = utilApi.stringToKamas(input_price.text,"") != _currentPrice;
               if(this.checkQuantity())
               {
                  if(_loc2_ && _loc3_)
                  {
                     sysApi.sendAction(new ExchangeObjectModifyPriced(_currentObject.objectUID,int(input_quantity.text),utilApi.stringToKamas(input_price.text,"")));
                  }
                  else
                  {
                     if(_loc2_)
                     {
                        sysApi.sendAction(new ExchangeObjectModifyPriced(_currentObject.objectUID,utilApi.stringToKamas(input_quantity.text,""),0));
                     }
                     if(_loc3_)
                     {
                        sysApi.sendAction(new ExchangeObjectModifyPriced(_currentObject.objectUID,0,utilApi.stringToKamas(input_price.text,"")));
                     }
                  }
               }
               break;
            case btn_remove:
               sysApi.sendAction(new ExchangeShopStockMouvmentRemove(_currentObject.objectUID,utilApi.stringToKamas(input_quantity.text,"")));
         }
      }
      
      override public function unload() : void
      {
         super.unload();
      }
      
      override public function onChange(param1:GraphicContainer) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param1 == input_quantity)
         {
            _loc2_ = this.inventoryApi.getItemQty(_currentObject.objectGID);
            _loc3_ = _currentObject.quantity;
            switch(this._currentMod)
            {
               case SELL_MOD:
                  if(utilApi.stringToKamas(input_quantity.text,"") > _loc3_)
                  {
                     input_quantity.text = utilApi.kamasToString(_loc3_,"");
                  }
                  break;
               case MODIFY_REMOVE_MOD:
                  if(utilApi.stringToKamas(input_quantity.text,"") > _loc2_ + _loc3_)
                  {
                     input_quantity.text = utilApi.kamasToString(_loc2_ + _loc3_,"");
                  }
            }
            lbl_totalPrice.text = utilApi.kamasToString(utilApi.stringToKamas(input_price.text,"") * utilApi.stringToKamas(input_quantity.text,""),"");
         }
         else if(param1 == input_price)
         {
            lbl_totalPrice.text = utilApi.kamasToString(utilApi.stringToKamas(input_price.text,"") * utilApi.stringToKamas(input_quantity.text,""),"");
         }
      }
      
      public function onObjectDeleted(param1:Object) : void
      {
         if(_currentObject.objectUID == param1.objectUID)
         {
            hideCard();
         }
      }
      
      public function onClickItemShopHV(param1:Object, param2:uint = 0) : void
      {
         if(!uiVisible)
         {
            this.soundApi.playSound(SoundTypeEnum.MERCHANT_TRANSFERT_OPEN);
         }
         this._currentMod = MODIFY_REMOVE_MOD;
         _currentPrice = param2;
         this.switchMode(false);
         this.displayObject(param1);
      }
      
      public function onClickItemInventory(param1:Object) : void
      {
         if(!uiVisible)
         {
            this.soundApi.playSound(SoundTypeEnum.MERCHANT_TRANSFERT_OPEN);
         }
         this._currentMod = SELL_MOD;
         _currentPrice = 0;
         this.switchMode(true);
         this.displayObject(param1);
      }
      
      protected function onExchangeShopStockUpdate(param1:Object, param2:Object = null) : void
      {
         if(param2 && param2.objectGID == _currentObject.objectGID && param2.objectUID == _currentObject.objectUID)
         {
            _currentObject = param2;
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case ShortcutHookListEnum.CLOSE_UI:
               break;
            case ShortcutHookListEnum.VALID_UI:
               if(this._currentMod == SELL_MOD)
               {
                  this.onRelease(btn_valid);
               }
               else if(input_price.haveFocus || input_quantity.haveFocus)
               {
                  this.onRelease(btn_modify);
               }
               return true;
         }
         return false;
      }
   }
}
