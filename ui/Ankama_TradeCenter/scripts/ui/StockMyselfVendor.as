package ui
{
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.ExchangeObjectModifyPriced;
   import d2actions.ExchangeShowVendorTax;
   import d2actions.MountInfoRequest;
   import d2enums.SelectMethodEnum;
   import d2hooks.ClickItemInventory;
   import d2hooks.ClickItemShopHV;
   import d2hooks.ExchangeLeave;
   import d2hooks.ExchangeShopStockAddQuantity;
   import d2hooks.ExchangeShopStockMovementRemoved;
   import d2hooks.ExchangeShopStockRemoveQuantity;
   import d2hooks.ExchangeShopStockUpdate;
   
   public class StockMyselfVendor extends Stock
   {
      
      public static var MODE:String = "";
      
      public static const STOCK:String = "stock";
      
      public static const HUMAN_VENDOR:String = "human_vendor";
       
      
      public var btn_center:ButtonContainer;
      
      public var btn_lbl_btn_center:Label;
      
      private var _item:Object;
      
      private var _objectToRemove:Object;
      
      public function StockMyselfVendor()
      {
         super();
      }
      
      override public function main(param1:Object = null) : void
      {
         super.main({
            "objects":param1.objects,
            "look":param1.look
         });
         sysApi.addHook(ExchangeShopStockUpdate,this.onExchangeShopStockUpdate);
         sysApi.addHook(ExchangeLeave,this.onExchangeLeave);
         if(MODE == "")
         {
            MODE = STOCK;
            sysApi.addHook(ExchangeShopStockMovementRemoved,this.onExchangeShopStockMovementRemoved);
            sysApi.addHook(ClickItemInventory,this.onClickItemInventory);
            sysApi.addHook(ClickItemShopHV,this.onClickItemShopHV);
            sysApi.addHook(ExchangeShopStockAddQuantity,this.onExchangeShopStockAddQuantity);
            sysApi.addHook(ExchangeShopStockRemoveQuantity,this.onExchangeShopStockRemoveQuantity);
         }
         sysApi.disableWorldInteraction();
         ctr_center.visible = true;
         lbl_title.text = uiApi.getText("ui.common.shop");
         this.btn_lbl_btn_center.text = uiApi.getText("ui.humanVendor.switchToMerchantMode");
      }
      
      override public function unload() : void
      {
         uiApi.unloadUi(UIEnum.MYSELF_VENDOR);
         super.unload();
      }
      
      private function selectItem(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc2_:uint = 0;
         for each(_loc3_ in gd_shop.dataProvider)
         {
            if(param1.objectUID == _loc3_.itemWrapper.objectUID)
            {
               gd_shop.selectedIndex = _loc2_;
               sysApi.dispatchHook(ClickItemShopHV,param1.itemWrapper,param1.price);
               gd_shop.dataProvider[_loc2_].select();
               return;
            }
            _loc2_++;
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
         updateStockInventory();
      }
      
      protected function onExchangeShopStockUpdate(param1:Object, param2:Object = null) : void
      {
         var _loc3_:Object = null;
         _objectsInStock = new Array();
         for each(_loc3_ in param1)
         {
            _objectsInStock.push(_loc3_);
         }
         _objectsInStock.sort(shopStockSort);
         if(param2 != null)
         {
            this.selectTab(param2);
            soundApi.playSound(SoundTypeEnum.SWITCH_RIGHT_TO_LEFT);
         }
         else
         {
            showTransfertUI(false);
            updateStockInventory();
         }
      }
      
      public function onClickItemShopHV(param1:Object, param2:uint = 0) : void
      {
         this._item = param1;
      }
      
      public function onClickItemInventory(param1:Object) : void
      {
         this._item = param1;
      }
      
      public function onExchangeShopStockMovementRemoved(param1:uint) : void
      {
         if(this._item.objectUID == param1)
         {
            this._item = null;
            if(gd_shop.dataProvider.length > 0)
            {
               showTransfertUI(true);
               gd_shop.selectedIndex = 0;
               sysApi.dispatchHook(ClickItemShopHV,gd_shop.selectedItem.itemWrapper,gd_shop.selectedItem.price);
            }
            else
            {
               showTransfertUI(false);
            }
         }
      }
      
      public function onExchangeShopStockAddQuantity() : void
      {
         soundApi.playSound(SoundTypeEnum.SWITCH_RIGHT_TO_LEFT);
      }
      
      public function onExchangeShopStockRemoveQuantity() : void
      {
         soundApi.playSound(SoundTypeEnum.SWITCH_LEFT_TO_RIGHT);
      }
      
      override public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         switch(param1)
         {
            case gd_shop:
               _loc4_ = gd_shop.selectedItem;
               switch(param2)
               {
                  case SelectMethodEnum.CLICK:
                     sysApi.dispatchHook(ClickItemShopHV,_loc4_.itemWrapper,_loc4_.price);
                     showTransfertUI(true);
                     break;
                  case SelectMethodEnum.DOUBLE_CLICK:
                     sysApi.sendAction(new ExchangeObjectModifyPriced(_loc4_.itemWrapper.objectUID,-1,_loc4_.price));
                     if(_loc4_ && _loc4_.itemWrapper && _loc4_.itemWrapper.category != 0 && _loc4_.itemWrapper.hasOwnProperty("isCertificate") && _loc4_.itemWrapper.isCertificate)
                     {
                        sysApi.sendAction(new MountInfoRequest(_loc4_.itemWrapper));
                     }
                     break;
                  case SelectMethodEnum.CTRL_DOUBLE_CLICK:
                     sysApi.sendAction(new ExchangeObjectModifyPriced(_loc4_.itemWrapper.objectUID,-_loc4_.itemWrapper.quantity,_loc4_.price));
                     break;
                  case SelectMethodEnum.ALT_DOUBLE_CLICK:
                     this._objectToRemove = _loc4_;
                     modCommon.openQuantityPopup(1,_loc4_.itemWrapper.quantity,_loc4_.itemWrapper.quantity,this.onValidQty);
               }
               break;
            case cb_category:
               super.onSelectItem(param1,param2,param3);
         }
      }
      
      private function onValidQty(param1:Number) : void
      {
         sysApi.sendAction(new ExchangeObjectModifyPriced(this._objectToRemove.itemWrapper.objectUID,-param1,this._objectToRemove.price));
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case btn_close:
               uiApi.unloadUi(uiApi.me().name);
               break;
            case this.btn_center:
               sysApi.sendAction(new ExchangeShowVendorTax());
         }
         super.onRelease(param1);
      }
      
      public function onDoubleClick(param1:Object) : void
      {
      }
      
      public function onExchangeLeave(param1:Boolean) : void
      {
         uiApi.unloadUi(uiApi.me().name);
      }
   }
}
