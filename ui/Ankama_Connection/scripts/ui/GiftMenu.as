package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.modules.utils.ItemTooltipSettings;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import d2actions.GiftAssignRequest;
   import d2enums.ComponentHookList;
   import d2enums.DataStoreEnum;
   import d2enums.LocationEnum;
   import d2hooks.GiftAssigned;
   import flash.utils.Dictionary;
   
   public class GiftMenu
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      public var tooltipApi:TooltipApi;
      
      private var _giftsObjectsList:Dictionary;
      
      private var _btnAcceptGiftList:Dictionary;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _giftList:Array;
      
      private var _charaList:Array;
      
      private var _characterSelected:Boolean = false;
      
      public var btn_assignAllgifts:ButtonContainer;
      
      public var btn_not_now:ButtonContainer;
      
      public var gd_gifts:Grid;
      
      public var gd_character_select:Grid;
      
      public function GiftMenu()
      {
         this._giftsObjectsList = new Dictionary(true);
         this._btnAcceptGiftList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this.sysApi.addHook(GiftAssigned,this.onGiftAssigned);
         this.uiApi.addComponentHook(this.btn_assignAllgifts,"onRelease");
         this.uiApi.addComponentHook(this.btn_not_now,"onRelease");
         this.uiApi.addComponentHook(this.gd_character_select,"onSelectItem");
         this._charaList = new Array();
         this._giftList = new Array();
         if(param1)
         {
            for each(_loc2_ in param1.chara)
            {
               this._charaList.push(_loc2_);
            }
            for each(_loc3_ in param1.gift)
            {
               this._giftList.push(_loc3_);
            }
         }
         this.gd_character_select.autoSelectMode = 0;
         this.gd_character_select.dataProvider = this._charaList;
         this.btn_assignAllgifts.disabled = true;
         this.updateGifts();
      }
      
      public function unload() : void
      {
         this.uiApi.unloadUi("itemBox");
         this.uiApi.unloadUi("itemRecipes");
         this.uiApi.unloadUi("itemsSet");
         this.uiApi.hideTooltip();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Array = null;
         this.sysApi.log(2,"onSelectItem " + param1.name);
         switch(param1)
         {
            case this.gd_character_select:
               this._characterSelected = true;
               for each(_loc4_ in this._btnAcceptGiftList)
               {
                  _loc4_[0].softDisabled = false;
               }
               this.btn_assignAllgifts.disabled = false;
         }
      }
      
      private function updateGifts() : void
      {
         if(this._giftList.length == 0 && this.uiApi.getUi("giftMenu"))
         {
            this.uiApi.unloadUi("giftMenu");
         }
         this.gd_gifts.dataProvider = this._giftList;
      }
      
      public function updateGiftLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_giftName.text = param1.title;
            param2.gd_items_slot.dataProvider = param1.items;
            if(!this._btnAcceptGiftList[param2.btn_acceptOne.name])
            {
               this.uiApi.addComponentHook(param2.btn_acceptOne,ComponentHookList.ON_RELEASE);
               this.uiApi.addComponentHook(param2.btn_acceptOne,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.btn_acceptOne,ComponentHookList.ON_ROLL_OUT);
            }
            this._btnAcceptGiftList[param2.btn_acceptOne.name] = [param2.btn_acceptOne,param1.uid];
            param2.btn_acceptOne.softDisabled = !this._characterSelected;
            param2.ctr_gift.visible = true;
         }
         else
         {
            param2.ctr_gift.visible = false;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_assignAllgifts:
               this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.connection.assignAllGiftConfirmationPopupText",this.gd_character_select.selectedItem.name),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirm]);
               break;
            case this.btn_not_now:
               if(this.uiApi.getUi("giftMenu"))
               {
                  this.uiApi.unloadUi(this.uiApi.me().name);
               }
               break;
            default:
               if(param1.name.indexOf("btn_acceptOne") != -1)
               {
                  this.sysApi.sendAction(new GiftAssignRequest(this._btnAcceptGiftList[param1.name][1],this.gd_character_select.selectedItem.id));
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         if(param1.name.indexOf("btn_acceptOne") != -1)
         {
            if(!param1.softDisabled)
            {
               _loc2_ = this.uiApi.getText("ui.connection.getGift",this.gd_character_select.selectedItem.name);
            }
            else
            {
               _loc2_ = this.uiApi.getText("ui.connection.selectedCharacterNeeded");
            }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:ItemTooltipSettings = null;
         var _loc4_:* = undefined;
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
               _loc4_ = param2.data.name;
            }
            this.uiApi.showTooltip(param2.data,param2.container,false,"standard",8,0,0,"itemName",null,{},"ItemInfo",false,4,1,"giftMenu");
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         return true;
      }
      
      public function onConfirm() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this._giftList)
         {
            this.sysApi.sendAction(new GiftAssignRequest(_loc1_.uid,this.gd_character_select.selectedItem.id));
         }
      }
      
      private function onGiftAssigned(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         for each(_loc3_ in this._giftList)
         {
            if(_loc3_.uid == param1)
            {
               _loc2_ = this._giftList.indexOf(_loc3_);
               break;
            }
         }
         this._giftList.splice(_loc2_,1);
         if(this._giftList.length == 0)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
         else
         {
            this.updateGifts();
         }
      }
   }
}
