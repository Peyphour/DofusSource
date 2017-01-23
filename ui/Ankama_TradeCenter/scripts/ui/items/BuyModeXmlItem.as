package ui.items
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.StatesEnum;
   
   public class BuyModeXmlItem
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
      
      public var slot_icon:Slot;
      
      public var btn_q1:ButtonContainer;
      
      public var btn_q2:ButtonContainer;
      
      public var btn_q3:ButtonContainer;
      
      public var lbl_q1:Label;
      
      public var lbl_q2:Label;
      
      public var lbl_q3:Label;
      
      public var tx_kamas1:Texture;
      
      public var tx_kamas2:Texture;
      
      public var tx_kamas3:Texture;
      
      private var _tooltipTarget;
      
      public function BuyModeXmlItem()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this._grid = param1.grid;
         this._data = param1.data;
         this.slot_icon.allowDrag = false;
         this.uiApi.addComponentHook(this.btn_q1,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_q2,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_q3,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.slot_icon,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.slot_icon,ComponentHookList.ON_RIGHT_CLICK);
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
         var _loc3_:int = 0;
         this._data = param1;
         if(param1 != null)
         {
            this._item = param1.itemWrapper;
            this.slot_icon.data = this._item;
            this.updateComponents(1,!(param1.prices.length == 0 || param1.prices[0] <= 0),param1.prices[0]);
            this.updateComponents(2,!(param1.prices.length < 2 || param1.prices[1] <= 0),param1.prices[1]);
            this.updateComponents(3,!(param1.prices.length < 3 || param1.prices[2] <= 0),param1.prices[2]);
            if(param2)
            {
               _loc3_ = this.uiApi.getUi("itemBidHouseBuy").uiClass.currentCase;
               if(_loc3_ >= 0)
               {
                  this.onSelectedItem(this["btn_q" + (_loc3_ + 1)]);
               }
            }
            else
            {
               this.btn_q1.selected = false;
               this.btn_q2.selected = false;
               this.btn_q3.selected = false;
               this.lbl_q1.cssClass = "mediumcenter";
               this.lbl_q2.cssClass = "mediumcenter";
               this.lbl_q3.cssClass = "mediumcenter";
            }
         }
         else
         {
            this._item = null;
            this.btn_q1.selected = false;
            this.btn_q2.selected = false;
            this.btn_q3.selected = false;
            this.btn_q1.disabled = true;
            this.btn_q2.disabled = true;
            this.btn_q3.disabled = true;
            this.slot_icon.data = null;
            this.lbl_q1.text = "";
            this.lbl_q2.text = "";
            this.lbl_q3.text = "";
            this.lbl_q1.cssClass = "mediumcenter";
            this.lbl_q2.cssClass = "mediumcenter";
            this.lbl_q3.cssClass = "mediumcenter";
            this.tx_kamas1.visible = this.tx_kamas2.visible = this.tx_kamas3.visible = false;
         }
      }
      
      private function updateComponents(param1:uint, param2:Boolean, param3:Number) : void
      {
         var _loc7_:Number = NaN;
         var _loc4_:Label = this["lbl_q" + param1];
         var _loc5_:ButtonContainer = this["btn_q" + param1];
         var _loc6_:Texture = this["tx_kamas" + param1];
         if(!param2)
         {
            _loc4_.text = "-";
            _loc5_.disabled = true;
            _loc5_.selected = false;
            _loc4_.cssClass = "mediumcenter";
            _loc4_.x = _loc5_.x + _loc5_.width / 2 - _loc4_.textWidth / 2;
            _loc6_.visible = false;
         }
         else
         {
            _loc4_.text = this.utilApi.kamasToString(param3,"");
            _loc4_.fullWidth();
            _loc7_ = _loc4_.textWidth + _loc6_.width + 10;
            _loc4_.x = _loc5_.x + _loc5_.width / 2 - _loc7_ / 2;
            _loc6_.x = _loc4_.x + _loc4_.textWidth + 10;
            _loc6_.visible = true;
            _loc5_.disabled = false;
         }
      }
      
      private function onSelectedItem(param1:Object) : void
      {
         if(param1 == this.btn_q1)
         {
            this._selectedQuantity = 1;
            this.btn_q1.selected = true;
            this.btn_q2.selected = false;
            this.btn_q3.selected = false;
            this.btn_q1.state = StatesEnum.STATE_SELECTED;
            this.lbl_q1.cssClass = "mediumcenter";
            this.lbl_q2.cssClass = "mediumcenter";
            this.lbl_q3.cssClass = "mediumcenter";
            this.uiApi.getUi("itemBidHouseBuy").uiClass.currentCase = 0;
            this.uiApi.getUi("itemBidHouseBuy").uiClass.btn_buy.disabled = false;
         }
         else if(param1 == this.btn_q2)
         {
            this._selectedQuantity = 2;
            this.btn_q1.selected = false;
            this.btn_q2.selected = true;
            this.btn_q3.selected = false;
            this.btn_q2.state = StatesEnum.STATE_SELECTED;
            this.lbl_q1.cssClass = "mediumcenter";
            this.lbl_q2.cssClass = "mediumcenter";
            this.lbl_q3.cssClass = "mediumcenter";
            this.uiApi.getUi("itemBidHouseBuy").uiClass.currentCase = 1;
            this.uiApi.getUi("itemBidHouseBuy").uiClass.btn_buy.disabled = false;
         }
         else if(param1 == this.btn_q3)
         {
            this._selectedQuantity = 3;
            this.btn_q1.selected = false;
            this.btn_q2.selected = false;
            this.btn_q3.selected = true;
            this.btn_q3.state = StatesEnum.STATE_SELECTED;
            this.lbl_q1.cssClass = "mediumcenter";
            this.lbl_q2.cssClass = "mediumcenter";
            this.lbl_q3.cssClass = "mediumcenter";
            this.uiApi.getUi("itemBidHouseBuy").uiClass.currentCase = 2;
            this.uiApi.getUi("itemBidHouseBuy").uiClass.btn_buy.disabled = false;
         }
         else
         {
            this.uiApi.getUi("itemBidHouseBuy").uiClass.btn_buy.disabled = true;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.slot_icon && this.data.prices.length > 0)
         {
            if(this.data.prices[0] > 0)
            {
               param1 = this.btn_q1;
            }
            else if(this.data.prices[1] > 0)
            {
               param1 = this.btn_q2;
            }
            else if(this.data.prices[2] > 0)
            {
               param1 = this.btn_q3;
            }
         }
         this.onSelectedItem(param1);
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc4_:String = null;
         var _loc2_:* = new Object();
         var _loc3_:ItemTooltipSettings = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
         if(_loc3_ == null)
         {
            _loc3_ = this.tooltipApi.createItemSettings();
            this.sysApi.setData("itemTooltipSettings",_loc3_,DataStoreEnum.BIND_ACCOUNT);
         }
         _loc3_.showEffects = false;
         var _loc5_:* = this.sysApi.getObjectVariables(_loc3_);
         for each(_loc4_ in _loc5_)
         {
            _loc2_[_loc4_] = _loc3_[_loc4_];
         }
         if(!this._tooltipTarget)
         {
            this._tooltipTarget = this.uiApi.getUi("itemBidHouseBuy").getElement("lbl_item_name");
         }
         this.uiApi.showTooltip(this._item,!!this._tooltipTarget?this._tooltipTarget:this.slot_icon,false,"standard",8,0,0,null,null,_loc2_);
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1 == this.slot_icon)
         {
            _loc2_ = param1.data;
            _loc3_ = this.menuApi.create(_loc2_);
            if(_loc3_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc3_);
            }
         }
      }
   }
}
