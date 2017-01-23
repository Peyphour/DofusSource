package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   
   public class BasicItemCard
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var menuApi:ContextMenuApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      protected var _currentObject:Object;
      
      protected var _currentPrice:uint = 0;
      
      protected const PRICE_LIMIT:int = 2000000000;
      
      public var mainCtr:Object;
      
      public var ctr_inputQty:GraphicContainer;
      
      public var ctr_inputPrice:GraphicContainer;
      
      public var input_quantity:Input;
      
      public var input_price:Input;
      
      public var lbl_price:Label;
      
      public var lbl_totalPrice:Label;
      
      public var btn_lbl_btn_valid:Label;
      
      public var lbl_item_name:Label;
      
      public var lbl_item_level:Label;
      
      public var tx_inputQuantity:TextureBitmap;
      
      public var tx_kama:Texture;
      
      public var btn_valid:ButtonContainer;
      
      public var btn_remove:ButtonContainer;
      
      public var btn_modify:ButtonContainer;
      
      public var tx_item:Texture;
      
      public function BasicItemCard()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.btn_valid.soundId = SoundEnum.STORE_SELL_BUTTON;
         this.btn_remove.soundId = SoundEnum.STORE_SELL_BUTTON;
         this.btn_modify.soundId = SoundEnum.STORE_SELL_BUTTON;
         this.uiApi.addComponentHook(this.input_quantity,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.input_price,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.tx_item,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_item,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.tx_item,ComponentHookList.ON_RIGHT_CLICK);
         this.hideCard();
         this.input_quantity.maxChars = 9;
         this.input_quantity.restrictChars = "0-9";
         this.input_price.maxChars = 13;
         this.input_price.numberMax = this.PRICE_LIMIT;
         this.input_price.restrictChars = "0-9  ";
         this.btn_modify.visible = false;
         this.btn_remove.visible = false;
      }
      
      public function get uiVisible() : Boolean
      {
         return this.uiApi.me().visible;
      }
      
      public function onRelease(param1:Object) : void
      {
      }
      
      public function unload() : void
      {
         this.uiApi.unloadUi("itemBox_" + this.uiApi.me().name);
      }
      
      public function onChange(param1:GraphicContainer) : void
      {
         var _loc2_:int = 0;
         if(param1 == this.input_price)
         {
            _loc2_ = this.utilApi.stringToKamas(this.input_price.text,"");
            this.input_price.text = this.utilApi.kamasToString(_loc2_,"");
         }
         else if(param1 == this.input_quantity)
         {
            _loc2_ = this.utilApi.stringToKamas(this.input_quantity.text,"");
            this.input_quantity.text = this.utilApi.kamasToString(_loc2_,"");
         }
      }
      
      protected function checkPlayerFund(param1:int, param2:int = 0) : void
      {
         var _loc4_:Object = null;
         var _loc5_:ItemWrapper = null;
         var _loc3_:int = 0;
         if(param2 == 0)
         {
            _loc3_ = this.playerApi.characteristics().kamas;
         }
         else
         {
            _loc4_ = this.playerApi.getInventory();
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.objectGID == param2)
               {
                  _loc3_ = _loc5_.quantity;
                  break;
               }
            }
         }
         if(this._currentPrice * param1 > _loc3_)
         {
            this.lbl_totalPrice.cssClass = "redright";
            this.btn_valid.disabled = true;
         }
         else
         {
            this.lbl_totalPrice.cssClass = "right";
            this.btn_valid.disabled = false;
         }
      }
      
      public function onObjectSelected(param1:Object = null) : void
      {
         if(param1 == null)
         {
            this.hideCard();
         }
         else
         {
            this.hideCard(false);
            this._currentObject = param1;
            this.lbl_item_name.cssClass = "whitebold";
            if(this._currentObject.etheral)
            {
               this.lbl_item_name.cssClass = "itemetheral";
            }
            if(this._currentObject.itemSetId != -1)
            {
               this.lbl_item_name.cssClass = "itemset";
            }
            this.lbl_item_name.text = this._currentObject.name;
            if(this.sysApi.getPlayerManager().hasRights)
            {
               this.lbl_item_name.text = this.lbl_item_name.text + (" (" + this._currentObject.id + ")");
            }
            this.lbl_item_level.text = this.uiApi.getText("ui.common.short.level") + " " + this._currentObject.level;
            this.tx_item.uri = this._currentObject.fullSizeIconUri;
            this.input_price.text = "0";
            this.input_price.setSelection(0,8388607);
            this.lbl_price.text = "0";
            this.input_quantity.text = "1";
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         var _loc5_:Object = null;
         switch(param1)
         {
            case this.tx_item:
               _loc2_ = this._currentObject;
               _loc3_ = LocationEnum.POINT_TOPRIGHT;
               _loc4_ = LocationEnum.POINT_TOPLEFT;
               _loc5_ = {"showEffects":false};
         }
         this.uiApi.showTooltip(_loc2_,param1,false,"standard",_loc3_,_loc4_,3,null,null,_loc5_);
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Object = this.menuApi.create(this._currentObject);
         if(_loc2_.content.length > 0)
         {
            this.modContextMenu.createContextMenu(_loc2_);
         }
      }
      
      protected function hideCard(param1:Boolean = true) : void
      {
         this.mainCtr.visible = !param1;
      }
   }
}
