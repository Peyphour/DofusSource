package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2actions.ExchangeCraftPaymentModification;
   import d2hooks.PaymentCraftList;
   
   public class Payment
   {
      
      private static const _slotWidth:int = 5;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var menuApi:ContextMenuApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var playerApi:PlayedCharacterApi;
      
      public var storageApi:StorageApi;
      
      public var tx_background:Texture;
      
      public var tx_blockBg:Texture;
      
      public var gd_items:Grid;
      
      public var lbl_kamas:Label;
      
      public var sb_topArrow:ButtonContainer;
      
      public var sb_bottomArrow:ButtonContainer;
      
      public var lbl_itemsTab:Label;
      
      public var ctr_bonus:GraphicContainer;
      
      public var gd_itemsBonus:Grid;
      
      public var lbl_kamasBonus:Label;
      
      public var sb_topArrowBonus:ButtonContainer;
      
      public var sb_bottomArrowBonus:ButtonContainer;
      
      public var lbl_itemsTabBonus:Label;
      
      public var btn_close:ButtonContainer;
      
      public var btn_valid:ButtonContainer;
      
      public var dropEnabled:Boolean = true;
      
      private var _items:Object;
      
      private var _itemsBonus:Object;
      
      private var _currentItemTab:int = 0;
      
      private var _currentItemTabBonus:int = 0;
      
      private var _waitingSlot:Object;
      
      private var _waitingData:Object;
      
      private var _waitingGrid:Object;
      
      public function Payment()
      {
         this._items = new Array();
         this._itemsBonus = new Array();
         super();
      }
      
      public function get kamas() : int
      {
         return parseInt(this.lbl_kamas.text);
      }
      
      public function set kamas(param1:int) : void
      {
         if(param1 != parseInt(this.lbl_kamas.text))
         {
            this.lbl_kamas.text = param1.toString();
         }
      }
      
      public function get items() : Object
      {
         return this._items;
      }
      
      public function set items(param1:Object) : void
      {
         if(this._currentItemTab == this._items.length / _slotWidth && param1.length % _slotWidth == 0)
         {
            this._currentItemTab = param1.length / _slotWidth;
         }
         this._items = param1;
         this._refillDataProvider();
      }
      
      public function get kamasBonus() : int
      {
         return parseInt(this.lbl_kamasBonus.text);
      }
      
      public function set kamasBonus(param1:int) : void
      {
         if(param1 != parseInt(this.lbl_kamasBonus.text))
         {
            this.lbl_kamasBonus.text = param1.toString();
         }
      }
      
      public function get itemsBonus() : Object
      {
         return this._itemsBonus;
      }
      
      public function set itemsBonus(param1:Object) : void
      {
         if(this._currentItemTabBonus == this._itemsBonus.length / _slotWidth && param1.length % _slotWidth == 0)
         {
            this._currentItemTabBonus = param1.length / _slotWidth;
         }
         this._itemsBonus = param1;
         this._refillBonusDataProvider();
      }
      
      public function reset() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         for each(_loc1_ in this._items)
         {
            this.itemRemovedPayAlwaysCallback(_loc1_,_loc1_.quantity);
         }
         for each(_loc2_ in this._itemsBonus)
         {
            this.itemRemovedPaySuccessCallback(_loc2_,_loc2_.quantity);
         }
         this._items = new Array();
         this._itemsBonus = new Array();
         this._refillDataProvider();
         this.lbl_kamas.text = "0";
         this.lbl_kamasBonus.text = "0";
         this.kamasModifiedPayAlwaysCallback(0);
         this.kamasModifiedPaySuccessCallback(0);
      }
      
      public function disable(param1:Boolean) : void
      {
         this.gd_items.disabled = param1;
         this.lbl_kamas.disabled = param1;
         this.sb_topArrow.disabled = param1;
         this.sb_bottomArrow.disabled = param1;
         this.gd_itemsBonus.disabled = param1;
         this.lbl_kamasBonus.disabled = param1;
         this.sb_topArrowBonus.disabled = param1;
         this.sb_bottomArrowBonus.disabled = param1;
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addHook(PaymentCraftList,this.onPaymentCraftList);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         if(param1.paymentData)
         {
            this._items = param1.paymentData.objectsPayment;
            this._itemsBonus = param1.paymentData.objectsPaymentOnlySuccess;
            this.lbl_kamas.text = param1.paymentData.kamaPayment;
            this.lbl_kamasBonus.text = param1.paymentData.kamaPaymentOnlySuccess;
         }
         else
         {
            this._items = new Array();
            this._itemsBonus = new Array();
            this.lbl_kamas.text = "0";
            this.lbl_kamasBonus.text = "0";
         }
         if(param1.hasOwnProperty("disabled"))
         {
            this.disable(param1.disabled);
            if(!param1.disabled)
            {
               this.uiApi.addComponentHook(this.lbl_kamas,"onRelease");
               this.uiApi.addComponentHook(this.lbl_kamasBonus,"onRelease");
            }
         }
         if(!param1.bonusNeeded)
         {
            this.ctr_bonus.visible = false;
            this.tx_background.height = this.tx_background.height - 80;
            this.tx_blockBg.height = this.tx_blockBg.height - 80;
         }
         this.gd_items.renderer.dropValidatorFunction = this.dropValidatorFunction;
         this.gd_items.renderer.processDropFunction = this.processDropFunction;
         this.gd_items.renderer.removeDropSourceFunction = this.removeDropSourceFunction;
         this.gd_itemsBonus.renderer.dropValidatorFunction = this.dropValidatorFunction;
         this.gd_itemsBonus.renderer.processDropFunction = this.processDropBonusFunction;
         this.gd_itemsBonus.renderer.removeDropSourceFunction = this.removeDropSourceBonusFunction;
         this._refillDataProvider();
         this._refillBonusDataProvider();
      }
      
      public function unload() : void
      {
      }
      
      private function _refillDataProvider() : void
      {
         var _loc4_:int = 0;
         var _loc1_:int = this._items.length / _slotWidth;
         if(this._currentItemTab > this._items.length / _loc1_)
         {
            this._currentItemTab = this._items.length / _loc1_;
         }
         this.lbl_itemsTab.text = this._currentItemTab + 1 + "/" + (_loc1_ + 1);
         var _loc2_:Object = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < _slotWidth)
         {
            _loc4_ = this._currentItemTab * _slotWidth + _loc3_;
            if(this._items[_loc4_])
            {
               _loc2_.push(this._items[_loc4_]);
               _loc3_++;
               continue;
            }
            break;
         }
         this.gd_items.dataProvider = _loc2_;
      }
      
      private function _refillBonusDataProvider() : void
      {
         var _loc4_:int = 0;
         var _loc1_:int = this._itemsBonus.length / _slotWidth;
         if(this._currentItemTabBonus > this._itemsBonus.length / _loc1_)
         {
            this._currentItemTabBonus = this._itemsBonus.length / _loc1_;
         }
         this.lbl_itemsTabBonus.text = this._currentItemTabBonus + 1 + "/" + (_loc1_ + 1);
         var _loc2_:Object = new Array();
         var _loc3_:int = 0;
         while(_loc3_ < _slotWidth)
         {
            _loc4_ = this._currentItemTabBonus * _slotWidth + _loc3_;
            if(this._itemsBonus[_loc4_])
            {
               _loc2_.push(this._itemsBonus[_loc4_]);
               _loc3_++;
               continue;
            }
            break;
         }
         this.gd_itemsBonus.dataProvider = _loc2_;
      }
      
      protected function maxKamas(param1:Boolean) : uint
      {
         return this.playerApi.characteristics().kamas - (!!param1?this.kamas:this.kamasBonus);
      }
      
      public function kamasModifiedPayAlwaysCallback(param1:int) : void
      {
         this.sysApi.sendAction(new ExchangeCraftPaymentModification(param1));
      }
      
      public function itemRemovedPayAlwaysCallback(param1:Object, param2:int) : void
      {
      }
      
      public function itemAddedPayAlwaysCallback(param1:Object, param2:int) : void
      {
      }
      
      public function kamasModifiedPaySuccessCallback(param1:int) : void
      {
         this.sysApi.sendAction(new ExchangeCraftPaymentModification(param1));
      }
      
      public function itemRemovedPaySuccessCallback(param1:Object, param2:int) : void
      {
      }
      
      public function itemAddedPaySuccessCallback(param1:Object, param2:int) : void
      {
      }
      
      public function onPaymentCraftList(param1:Object, param2:Boolean) : void
      {
         var _loc3_:Object = null;
         this.storageApi.removeAllItemMasks("paymentAlways");
         this.storageApi.removeAllItemMasks("paymentSuccess");
         if(param1)
         {
            this.lbl_kamas.text = param1.kamaPayment;
            this.gd_items.dataProvider = param1.objectsPayment;
            for each(_loc3_ in param1.objectsPayment)
            {
               this.storageApi.addItemMask(_loc3_.objectUID,"paymentAlways",_loc3_.quantity);
            }
            this.lbl_kamasBonus.text = param1.kamaPaymentOnlySuccess;
            this.gd_itemsBonus.dataProvider = param1.objectsPaymentOnlySuccess;
            for each(_loc3_ in param1.objectsPaymentOnlySuccess)
            {
               this.storageApi.addItemMask(_loc3_.objectUID,"paymentSuccess",_loc3_.quantity);
            }
         }
         else
         {
            this.lbl_kamas.text = "0";
            this.gd_items.dataProvider = new Array();
            this.lbl_kamasBonus.text = "0";
            this.gd_itemsBonus.dataProvider = new Array();
         }
         this.storageApi.releaseHooks();
      }
      
      private function hasItem(param1:Object, param2:Object) : Boolean
      {
         var _loc3_:Object = null;
         for each(_loc3_ in param1)
         {
            if(_loc3_.objectUID == param2.objectUID)
            {
               return true;
            }
         }
         return false;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         switch(param1)
         {
            case this.sb_topArrow:
               if(this._currentItemTab > 0)
               {
                  this._currentItemTab--;
                  this._refillDataProvider();
               }
               break;
            case this.sb_bottomArrow:
               _loc2_ = this._items.length / _slotWidth;
               if(this._currentItemTab < _loc2_)
               {
                  this._currentItemTab++;
                  this._refillDataProvider();
               }
               break;
            case this.sb_topArrowBonus:
               if(this._currentItemTabBonus > 0)
               {
                  this._currentItemTabBonus--;
                  this._refillBonusDataProvider();
               }
               break;
            case this.sb_bottomArrowBonus:
               _loc3_ = this._itemsBonus.length / _slotWidth;
               if(this._currentItemTabBonus < _loc3_)
               {
                  this._currentItemTabBonus++;
                  this._refillBonusDataProvider();
               }
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_valid:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.lbl_kamas:
               this.modCommon.openQuantityPopup(0,this.maxKamas(false),0,this.kamasModifiedPayAlwaysCallback);
               break;
            case this.lbl_kamasBonus:
               this.modCommon.openQuantityPopup(0,this.maxKamas(true),0,this.kamasModifiedPaySuccessCallback);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         switch(param1)
         {
            case this.gd_items:
               if(param2 == 1)
               {
                  this.itemRemovedPayAlwaysCallback(param1.selectedItem,1);
               }
               break;
            case this.gd_itemsBonus:
               if(param2 == 1)
               {
                  this.itemRemovedPaySuccessCallback(param1.selectedItem,1);
               }
         }
      }
      
      public function dropValidatorFunction(param1:Object, param2:Object, param3:Object) : Boolean
      {
         if(this.dropEnabled == false)
         {
            return false;
         }
         return true;
      }
      
      public function processDropFunction(param1:Object, param2:Object, param3:Object) : void
      {
         if(this.dropEnabled == false)
         {
            return;
         }
         this._waitingSlot = param1;
         this._waitingData = param2;
         this._waitingGrid = this.gd_items;
         if(param2.quantity > 1)
         {
            this.modCommon.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQtyDropAddItem);
         }
         else
         {
            this.onValidQtyDropAddItem(1);
         }
      }
      
      public function processDropBonusFunction(param1:Object, param2:Object, param3:Object) : void
      {
         if(this.dropEnabled == false)
         {
            return;
         }
         this._waitingSlot = param1;
         this._waitingData = param2;
         this._waitingGrid = this.gd_itemsBonus;
         if(param2.quantity > 1)
         {
            this.modCommon.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQtyDropAddItem);
         }
         else
         {
            this.onValidQtyDropAddItem(1);
         }
      }
      
      public function removeDropSourceFunction(param1:Object) : void
      {
         this._waitingSlot = param1;
         this._waitingGrid = this.gd_items;
         if(param1.data.quantity > 1)
         {
            this.modCommon.openQuantityPopup(1,param1.data.quantity,param1.data.quantity,this.onValidQtyDropRemoveItem);
         }
         else
         {
            this.onValidQtyDropRemoveItem(1);
         }
      }
      
      public function removeDropSourceBonusFunction(param1:Object) : void
      {
         this._waitingSlot = param1;
         this._waitingGrid = this.gd_itemsBonus;
         if(param1.data.quantity > 1)
         {
            this.modCommon.openQuantityPopup(1,param1.data.quantity,param1.data.quantity,this.onValidQtyDropRemoveItem);
         }
         else
         {
            this.onValidQtyDropRemoveItem(1);
         }
      }
      
      public function onValidQtyDropAddItem(param1:int) : void
      {
         if(this._waitingGrid && this._waitingGrid == this.gd_items)
         {
            if(this._waitingSlot.data && this._waitingSlot.data.objectUID != this._waitingData.objectUID)
            {
               this.itemRemovedPayAlwaysCallback(this._waitingSlot.data,this._waitingSlot.data.quantity);
            }
            this.itemAddedPayAlwaysCallback(this._waitingData,param1);
         }
         else if(this._waitingGrid && this._waitingGrid == this.gd_itemsBonus)
         {
            if(this._waitingSlot.data && this._waitingSlot.data.objectUID != this._waitingData.objectUID)
            {
               this.itemRemovedPaySuccessCallback(this._waitingSlot.data,this._waitingSlot.data.quantity);
            }
            this.itemAddedPaySuccessCallback(this._waitingData,param1);
         }
      }
      
      public function onValidQtyDropRemoveItem(param1:int) : void
      {
         if(this._waitingGrid && this._waitingGrid == this.gd_items)
         {
            this.itemRemovedPayAlwaysCallback(this._waitingSlot.data,this._waitingSlot.data.quantity);
         }
         else if(this._waitingGrid && this._waitingGrid == this.gd_itemsBonus)
         {
            this.itemRemovedPaySuccessCallback(this._waitingSlot.data,param1);
         }
      }
      
      private function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         if(param2.data)
         {
            this.uiApi.showTooltip(param2.data,param2.container,false,"standard",0);
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         if(param1 == this.gd_items)
         {
            _loc3_ = param2.data;
            _loc4_ = this.menuApi.create(_loc3_);
            if(_loc4_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc4_);
            }
         }
      }
   }
}
