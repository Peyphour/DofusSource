package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import d2actions.LivingObjectFeed;
   import d2actions.MountFeedRequest;
   import d2enums.DataStoreEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.ObjectDeleted;
   import d2hooks.ObjectQuantity;
   
   public class FeedUi
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var soundApi:SoundApi;
      
      public var storageApi:StorageApi;
      
      public var tooltipApi:TooltipApi;
      
      public var utilApi:UtilApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _foodList:Object;
      
      private var _typeToFeed:int = 0;
      
      private var _item:ItemWrapper;
      
      private var _mountId:int;
      
      private var _mountLocation:int;
      
      private var _feeding:int;
      
      public var btn_closeFeed:ButtonContainer;
      
      public var btn_feedOk:ButtonContainer;
      
      public var grid_food:Grid;
      
      public var lbl_selectItem:Label;
      
      public var ctr_quantity:GraphicContainer;
      
      public var inp_quantity:Input;
      
      public var btn_min:ButtonContainer;
      
      public var btn_max:ButtonContainer;
      
      public var lbl_quantity:Label;
      
      public var icon_quantity:Texture;
      
      public var tx_icon_ctr_window:Texture;
      
      public function FeedUi()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.btn_closeFeed.soundId = SoundEnum.WINDOW_CLOSE;
         this.sysApi.addHook(ObjectQuantity,this.onObjectQuantity);
         this.sysApi.addHook(ObjectDeleted,this.onObjectDeleted);
         this.uiApi.addComponentHook(this.btn_feedOk,"onRelease");
         this.uiApi.addComponentHook(this.grid_food,"onSelectItem");
         this.uiApi.addShortcutHook(ShortcutHookListEnum.VALID_UI,this.onValidUi);
         this.ctr_quantity.visible = false;
         this.inp_quantity.text = "" + Common.getInstance().lastFoodQuantity;
         this._typeToFeed = param1.type;
         if(this._typeToFeed == 3)
         {
            this._mountId = param1.mountId;
            this._mountLocation = param1.mountLocation;
            this._foodList = param1.foodList;
            if(this.storageApi.getFakeItemMount())
            {
               this.tx_icon_ctr_window.uri = this.storageApi.getFakeItemMount().iconUri;
            }
            else
            {
               this.tx_icon_ctr_window.visible = false;
            }
         }
         else
         {
            this._item = param1.item;
            this.tx_icon_ctr_window.uri = this._item.iconUri;
            if(this._item.type.superTypeId == 12)
            {
               this._foodList = this.storageApi.getPetFood(this._item.objectGID);
               this._typeToFeed = 1;
            }
            else
            {
               this._foodList = this.storageApi.getLivingObjectFood(this._item.type.id);
               this._typeToFeed = 2;
               this.inp_quantity.text = "1";
            }
         }
         if(this._foodList && this._foodList.length)
         {
            this.grid_food.dataProvider = this._foodList;
            this.btn_feedOk.disabled = true;
            this.grid_food.selectedIndex = -1;
         }
         else
         {
            this.grid_food.dataProvider = new Array();
            this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.item.errorNoFoodLivingItem",this._item.name),[this.uiApi.getText("ui.common.ok")],[this.uiApi.unloadUi(this.uiApi.me().name)]);
         }
         if(this.icon_quantity && this.lbl_quantity)
         {
            this.icon_quantity.x = this.lbl_quantity.x + this.lbl_quantity.textWidth + 8;
         }
      }
      
      public function unload() : void
      {
         this.uiApi.hideTooltip();
         this.uiApi.unloadUi("itemBoxFood");
      }
      
      private function onConfirmFeed(param1:Number = 1) : void
      {
         if(this._typeToFeed == 3)
         {
            param1 = this.utilApi.stringToKamas(this.inp_quantity.text,"");
            this.sysApi.sendAction(new MountFeedRequest(this._mountId,this._mountLocation,this.grid_food.selectedItem.objectUID,param1));
         }
         else
         {
            this.sysApi.sendAction(new LivingObjectFeed(this._item.objectUID,this.grid_food.selectedItem.objectUID,param1));
         }
         Common.getInstance().lastFoodQuantity = param1;
      }
      
      public function onValidUi(param1:String) : Boolean
      {
         if(this.grid_food.selectedItem && (!this.inp_quantity.haveFocus || !this._feeding))
         {
            this._feeding = 1;
            this.onRelease(this.btn_feedOk);
            return true;
         }
         this._feeding = Math.max(0,--this._feeding);
         return false;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(param1 == this.btn_closeFeed)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
         else if(param1 == this.btn_feedOk)
         {
            _loc2_ = this.utilApi.stringToKamas(this.inp_quantity.text,"");
            if(this._typeToFeed == 2)
            {
               this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.item.confirmFoodLivingItem"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmFeed,null],this.onConfirmFeed);
            }
            else if(this.grid_food.selectedItem.quantity < _loc2_)
            {
               this.onConfirmFeed(this.grid_food.selectedItem.quantity);
            }
            else
            {
               this.onConfirmFeed(_loc2_);
            }
         }
         else if(param1 == this.btn_max)
         {
            if(this.grid_food.selectedIndex > -1)
            {
               this.inp_quantity.text = this.utilApi.kamasToString(this.grid_food.dataProvider[this.grid_food.selectedIndex].quantity,"");
            }
         }
         else if(param1 == this.btn_min)
         {
            this.inp_quantity.text = "1";
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.grid_food)
         {
            if(this.grid_food.selectedItem)
            {
               this.lbl_selectItem.visible = false;
               this.btn_feedOk.disabled = false;
               this.ctr_quantity.visible = true;
               if(this._typeToFeed == 2)
               {
                  this.ctr_quantity.disabled = true;
               }
               if(int(this.inp_quantity.text) > this.grid_food.selectedItem.quantity)
               {
                  this.inp_quantity.text = this.utilApi.kamasToString(this.grid_food.selectedItem.quantity,"");
               }
               this.icon_quantity.uri = this.grid_food.selectedItem.iconUri;
               this.inp_quantity.focus();
               if(param2 == GridItemSelectMethodEnum.DOUBLE_CLICK)
               {
                  this.onConfirmFeed(1);
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
            }
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:ItemTooltipSettings = null;
         var _loc4_:Object = null;
         if(param2.data)
         {
            _loc3_ = this.sysApi.getData("itemTooltipSettings",DataStoreEnum.BIND_ACCOUNT) as ItemTooltipSettings;
            if(!_loc3_)
            {
               _loc3_ = this.tooltipApi.createItemSettings();
               this.sysApi.setData("itemTooltipSettings",_loc3_,DataStoreEnum.BIND_ACCOUNT);
            }
            _loc4_ = param2.data;
            if(!_loc3_.header && !_loc3_.conditions && !_loc3_.effects && !_loc3_.description && !_loc3_.averagePrice)
            {
               _loc4_ = param2.data;
            }
            this.uiApi.showTooltip(_loc4_,param2.container,false,"standard",8,0,0,"itemName",null,{
               "showEffects":true,
               "header":true
            },"ItemInfo");
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      private function onObjectQuantity(param1:ItemWrapper, param2:int, param3:int) : void
      {
         if(param1 && this._foodList)
         {
            if(this._typeToFeed == 3)
            {
               this._foodList = this.storageApi.getRideFoods();
            }
            else if(this._typeToFeed == 1)
            {
               this._foodList = this.storageApi.getPetFood(this._item.objectGID);
            }
            else
            {
               this._foodList = this.storageApi.getLivingObjectFood(this._item.type.id);
            }
            this.grid_food.dataProvider = this._foodList;
            this.btn_feedOk.disabled = true;
         }
      }
      
      private function onObjectDeleted(param1:Object) : void
      {
         if(param1 && this._foodList)
         {
            if(this._typeToFeed == 3)
            {
               this._foodList = this.storageApi.getRideFoods();
            }
            else if(this._typeToFeed == 1)
            {
               this._foodList = this.storageApi.getPetFood(this._item.objectGID);
            }
            else
            {
               this._foodList = this.storageApi.getLivingObjectFood(this._item.type.id);
            }
            this.grid_food.dataProvider = this._foodList;
            this.btn_feedOk.disabled = true;
            if(this._foodList && this._foodList.length)
            {
               this.grid_food.selectedIndex = 0;
               this.inp_quantity.text = "1";
            }
            else
            {
               this.ctr_quantity.visible = false;
               this.uiApi.unloadUi("itemBoxFood");
            }
         }
      }
   }
}
