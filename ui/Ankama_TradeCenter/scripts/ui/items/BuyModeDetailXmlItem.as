package ui.items
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.StatesEnum;
   
   public class BuyModeDetailXmlItem
   {
       
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var menuApi:ContextMenuApi;
      
      public var tooltipApi:TooltipApi;
      
      private var _grid:Object;
      
      private var _data;
      
      private var _item:Object;
      
      private var _selectedQuantity:int = 1;
      
      public var btn_item:ButtonContainer;
      
      public var lbl_name:Label;
      
      public var lbl_size:Label;
      
      public var lbl_price:Label;
      
      public function BuyModeDetailXmlItem()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this._grid = param1.grid;
         this._data = param1.data;
         this.uiApi.addComponentHook(this.btn_item,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_item,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_item,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_item,ComponentHookList.ON_RIGHT_CLICK);
         this.update(this._data,false);
      }
      
      public function unload() : void
      {
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function update(param1:*, param2:Boolean) : void
      {
         this._data = param1;
         if(param1 != null)
         {
            this._item = param1.itemWrapper;
            if(param1.prices.length == 0 || param1.prices[0] <= 0)
            {
               this.sysApi.log(8,"Erreur : utilisation d\'un hotel de ventes à effets détaillés sans objet en lot par 1");
            }
            this.lbl_name.text = param1.itemWrapper.shortName;
            this.lbl_name.cssClass = "medium";
            this.lbl_size.text = param1.size;
            this.lbl_price.text = this.utilApi.kamasToString(param1.prices[0]);
            this.btn_item.selected = param2;
         }
         else
         {
            this._item = null;
            this.btn_item.selected = false;
            this.lbl_name.text = "";
            this.lbl_price.text = "";
            this.lbl_size.text = "";
            this.lbl_name.cssClass = "medium";
         }
      }
      
      private function onSelectedItem(param1:Object) : void
      {
         if(this.data)
         {
            if(param1 == this.btn_item)
            {
               this._selectedQuantity = 1;
               this.btn_item.state = StatesEnum.STATE_SELECTED;
               this.lbl_name.cssClass = "medium";
               this.btn_item.selected = true;
               this.uiApi.getUi("itemBidHouseBuy").uiClass.currentCase = 0;
               this.uiApi.getUi("itemBidHouseBuy").uiClass.btn_buy.disabled = false;
            }
            else
            {
               this.lbl_name.cssClass = "medium";
               this.btn_item.selected = false;
               this.uiApi.getUi("itemBidHouseBuy").uiClass.btn_buy.disabled = true;
            }
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         this.onSelectedItem(param1);
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc4_:Object = null;
         var _loc2_:uint = 7;
         var _loc3_:uint = 4;
         var _loc5_:ItemTooltipSettings = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
         if(_loc5_ == null)
         {
            _loc5_ = this.tooltipApi.createItemSettings();
            this.sysApi.setData("itemTooltipSettings",_loc5_,DataStoreEnum.BIND_ACCOUNT);
         }
         _loc5_.showEffects = true;
         this.uiApi.showTooltip(this._item,param1,false,"standard",_loc2_,_loc3_,3,null,null,_loc5_);
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRightClick(param1:Object) : void
      {
         this.modContextMenu.createContextMenu(this.menuApi.create(this._item));
      }
   }
}
