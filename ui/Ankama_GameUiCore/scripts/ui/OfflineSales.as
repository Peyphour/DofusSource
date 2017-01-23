package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.sales.OfflineSaleWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2enums.ShortcutHookListEnum;
   import flash.utils.Dictionary;
   
   public class OfflineSales
   {
       
      
      public var sysApi:SystemApi;
      
      public var soundApi:SoundApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var dataApi:DataApi;
      
      public var tx_border_footer_gridBlock:TextureBitmap;
      
      public var lbl_title:Label;
      
      public var btn_close:ButtonContainer;
      
      public var gd_sales:Grid;
      
      public var gd_unsoldItems:Grid;
      
      public var grid_background:TextureBitmap;
      
      public var btn_sortItemIndex:ButtonContainer;
      
      public var lbl_sortItemIndex:Label;
      
      public var btn_sortItemName:ButtonContainer;
      
      public var btn_sortUnsoldItemName:ButtonContainer;
      
      public var lbl_sortItemName:Label;
      
      public var btn_sortItemQuantity:ButtonContainer;
      
      public var lbl_sortItemQuantity:Label;
      
      public var btn_sortItemKamas:ButtonContainer;
      
      public var lbl_sortItemKamas:Label;
      
      public var btn_sortSaleType:ButtonContainer;
      
      public var lbl_sortSaleType:Label;
      
      public var ctr_totals:GraphicContainer;
      
      public var lbl_total_quantity:Label;
      
      public var lbl_total_sales:Label;
      
      public var lbl_total_kamas:Label;
      
      public var lbl_total_kamas_value:Label;
      
      public var btn_sales:ButtonContainer;
      
      public var btn_unsoldItems:ButtonContainer;
      
      private var _sales:Object;
      
      private var _unsoldItems:Object;
      
      private var _ascendingSort:Boolean;
      
      private var _sortFieldAssoc:Dictionary;
      
      private var _lastSortType:String;
      
      private var _salesInit:Boolean;
      
      private var _currentGrid:Grid;
      
      public function OfflineSales()
      {
         this._sortFieldAssoc = new Dictionary();
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.lbl_sortItemIndex.text = this.uiApi.getText("ui.sell.offlineSales.order");
         this.lbl_sortItemName.text = this.uiApi.getText("ui.sell.offlineSales.itemName");
         this.lbl_sortItemQuantity.text = this.uiApi.getText("ui.common.quantity");
         this.lbl_sortItemKamas.text = this.uiApi.getText("ui.common.kamas");
         this.lbl_sortSaleType.text = this.uiApi.getText("ui.sell.offlineSales.saleType");
         this.soundApi.playSound(SoundTypeEnum.POPUP_INFO);
         this.btn_close.soundId = SoundEnum.WINDOW_CLOSE;
         this._sortFieldAssoc[this.btn_sortItemIndex] = "index";
         this._sortFieldAssoc[this.btn_sortItemName] = this._sortFieldAssoc[this.btn_sortUnsoldItemName] = "itemName";
         this._sortFieldAssoc[this.btn_sortItemQuantity] = "quantity";
         this._sortFieldAssoc[this.btn_sortItemKamas] = "kamas";
         this._sortFieldAssoc[this.btn_sortSaleType] = "type";
         this._ascendingSort = true;
         this._sales = param1.sales;
         this._unsoldItems = param1.unsoldItems;
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onCloseUi);
         if(param1.tab == 0)
         {
            this.openOfflineSalesTab();
         }
         else if(param1.tab == 1)
         {
            this.openUnsoldItemsTab();
         }
      }
      
      public function openOfflineSalesTab() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         this.btn_sales.selected = true;
         this.gd_unsoldItems.visible = this.btn_sortUnsoldItemName.visible = false;
         this.lbl_sortItemName.width = 275;
         this.lbl_sortItemQuantity.x = this.btn_sortItemQuantity.x = 350;
         this._currentGrid = this.gd_sales;
         this._currentGrid.dataProvider = this._sales;
         this._currentGrid.visible = true;
         this.lbl_sortItemKamas.visible = this.btn_sortItemKamas.visible = this.btn_sortItemName.visible = true;
         this.tx_border_footer_gridBlock.visible = true;
         this.grid_background.height = 314;
         if(!this._salesInit)
         {
            _loc2_ = this._sales.length;
            _loc3_ = 0;
            for each(_loc4_ in this._sales)
            {
               _loc1_ = _loc1_ + _loc4_.quantity;
               _loc3_ = _loc3_ + _loc4_.kamas;
            }
            this.lbl_total_quantity.text = this.uiApi.getText("ui.sell.offlineSales.nbSoldItems",_loc1_);
            this.lbl_total_sales.text = this.uiApi.getText("ui.sell.offlineSales.nbSoldLots",_loc2_);
            this.lbl_total_kamas.text = this.uiApi.getText("ui.sell.offlineSales.nbTotalKamas");
            this.lbl_total_kamas_value.text = this.utilApi.kamasToString(_loc3_,"");
            this._salesInit = true;
         }
         this.ctr_totals.visible = true;
      }
      
      public function openUnsoldItemsTab() : void
      {
         this.btn_unsoldItems.selected = true;
         this.gd_sales.visible = this.btn_sortItemName.visible = false;
         this.btn_sortUnsoldItemName.visible = true;
         this.lbl_sortItemName.width = 420;
         this.lbl_sortItemQuantity.x = this.btn_sortItemQuantity.x = 495;
         this._currentGrid = this.gd_unsoldItems;
         this._currentGrid.dataProvider = this._unsoldItems;
         this._currentGrid.visible = true;
         this.lbl_sortItemKamas.visible = this.btn_sortItemKamas.visible = false;
         this.ctr_totals.visible = false;
         this.tx_border_footer_gridBlock.visible = false;
         this.grid_background.height = 384;
      }
      
      public function updateSaleLine(param1:OfflineSaleWrapper, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_item_index.text = param1.index;
            param2.lbl_item_name.text = "{item," + param1.itemId + "::" + param1.itemName + "}";
            param2.lbl_item_quantity.text = param1.quantity;
            if(this.btn_sales.selected)
            {
               param2.lbl_kamas.text = this.utilApi.kamasToString(param1.kamas,"");
               param2.txt_kamas.visible = true;
            }
            param2.lbl_sale_type.text = param1.type == 1 || param1.type == 3?this.uiApi.getText("ui.sell.offlineSales.bidHouse"):this.uiApi.getText("ui.common.shop");
         }
         else
         {
            param2.lbl_item_index.text = "";
            param2.lbl_item_name.text = "";
            param2.lbl_item_quantity.text = "";
            if(this.btn_sales.selected)
            {
               param2.lbl_kamas.text = "";
               param2.txt_kamas.visible = false;
            }
            param2.lbl_sale_type.text = "";
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case this.btn_close:
               this.onCloseUi(null);
               break;
            case this.btn_sortItemIndex:
            case this.btn_sortItemName:
            case this.btn_sortUnsoldItemName:
            case this.btn_sortItemQuantity:
            case this.btn_sortItemKamas:
            case this.btn_sortSaleType:
               _loc2_ = this._sortFieldAssoc[param1];
               if(_loc2_ == "index" && !this._lastSortType)
               {
                  this._ascendingSort = false;
               }
               else
               {
                  this._ascendingSort = _loc2_ != this._lastSortType?true:!this._ascendingSort;
               }
               this._currentGrid.dataProvider = this.utilApi.sort(this._currentGrid.dataProvider,_loc2_,this._ascendingSort,_loc2_ != "itemName");
               this._lastSortType = _loc2_;
               break;
            case this.btn_sales:
               this.openOfflineSalesTab();
               break;
            case this.btn_unsoldItems:
               this.openUnsoldItemsTab();
         }
      }
      
      public function onCloseUi(param1:String) : Boolean
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
         return true;
      }
      
      public function unload() : void
      {
      }
   }
}
