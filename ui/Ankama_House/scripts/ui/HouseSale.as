package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.HouseBuy;
   import d2actions.HouseSell;
   import d2actions.HouseSellFromInside;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.LeaveDialog;
   
   public class HouseSale
   {
       
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var playerApi:PlayedCharacterApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      private var _price:uint;
      
      private var _inside:Boolean;
      
      private var _buyMode:Boolean;
      
      private var _houseWrapper:Object;
      
      private var _houseName:String;
      
      public var btnClose:ButtonContainer;
      
      public var lbl_title:Label;
      
      public var btnValidate:ButtonContainer;
      
      public var btnCancelTheSale:ButtonContainer;
      
      public var inputPrice:Input;
      
      public var lblOwnerName:Label;
      
      public var lblHouseInfo:TextArea;
      
      public var tx_houseIcon:Texture;
      
      public var mask_houseIcon:GraphicContainer;
      
      public function HouseSale()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.sysApi.addHook(d2hooks.LeaveDialog,this.onLeaveDialog);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortCut);
         this._price = param1.price;
         this._inside = param1.inside;
         this._buyMode = param1.buyMode;
         this._houseWrapper = House.currentHouse;
         if(this._buyMode)
         {
            this.lbl_title.text = this.uiApi.getText("ui.common.housePurchase");
         }
         else
         {
            this.lbl_title.text = this.uiApi.getText("ui.common.houseSale");
         }
         this.inputPrice.restrict = "0-9";
         this.inputPrice.maxChars = 13;
         this.inputPrice.numberMax = ProtocolConstantsEnum.MAX_KAMA;
         if(this._price == 0)
         {
            this.btnCancelTheSale.disabled = true;
            this.inputPrice.text = this._houseWrapper.defaultPrice;
         }
         else
         {
            this.inputPrice.text = String(this._price);
            if(this._buyMode)
            {
               this.inputPrice.mouseChildren = false;
               this.btnCancelTheSale.disabled = true;
               this.btnValidate.disabled = this._price > this.playerApi.characteristics().kamas;
            }
            else
            {
               this.btnCancelTheSale.disabled = false;
               this.inputPrice.focus();
            }
         }
         if(this._houseWrapper.ownerName == "?")
         {
            this._houseName = this.uiApi.getText("ui.common.houseWithNoOwner");
         }
         else if(this._houseWrapper.ownerName == "")
         {
            this._houseName = this.uiApi.getText("ui.common.houseForSale");
         }
         else
         {
            this._houseName = this.uiApi.getText("ui.common.houseOwnerName",this._houseWrapper.ownerName);
         }
         this.lblOwnerName.text = this._houseName;
         var _loc2_:String = this._houseWrapper.name;
         if(this._houseWrapper.description)
         {
            _loc2_ = _loc2_ + ("\n\n" + this._houseWrapper.description);
         }
         this.lblHouseInfo.text = _loc2_;
         this.lblHouseInfo.wordWrap = true;
         this.tx_houseIcon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("houses") + this._houseWrapper.gfxId + ".png");
         this.tx_houseIcon.mask = this.mask_houseIcon;
         this.uiApi.addComponentHook(this.btnClose,"onRelease");
         this.uiApi.addComponentHook(this.btnValidate,"onRelease");
         this.uiApi.addComponentHook(this.btnCancelTheSale,"onRelease");
         this.sysApi.disableWorldInteraction();
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:int = 0;
         switch(param1)
         {
            case this.btnClose:
               if(!this._inside)
               {
                  this.sysApi.sendAction(new d2actions.LeaveDialog());
               }
               this.uiApi.unloadUi("houseSale");
               return;
            case this.btnValidate:
               _loc2_ = this.utilApi.stringToKamas(this.inputPrice.text,"");
               if(this._buyMode)
               {
                  this._price = _loc2_;
                  this.modCommon.openPopup(this.uiApi.getText("ui.common.housePurchase"),this.uiApi.getText("ui.common.doUBuyHouse",this._houseName,this.utilApi.kamasToString(_loc2_,"")),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmHouseBuy,null]);
               }
               else if(_loc2_ == 0)
               {
                  if(this._inside)
                  {
                     this.sysApi.sendAction(new HouseSellFromInside(_loc2_));
                  }
                  else
                  {
                     this.sysApi.sendAction(new HouseSell(_loc2_));
                  }
                  this.uiApi.unloadUi("houseSale");
               }
               else
               {
                  if(this._inside)
                  {
                     this.sysApi.sendAction(new HouseSellFromInside(_loc2_));
                  }
                  else
                  {
                     this.sysApi.sendAction(new HouseSell(_loc2_));
                  }
                  this.uiApi.unloadUi("houseSale");
               }
               return;
            case this.btnCancelTheSale:
               if(this._inside)
               {
                  this.sysApi.sendAction(new HouseSellFromInside(_loc2_,false));
               }
               else
               {
                  this.sysApi.sendAction(new HouseSell(_loc2_,false));
               }
               this.uiApi.unloadUi("houseSale");
               return;
            default:
               return;
         }
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         if(param1 == ShortcutHookListEnum.CLOSE_UI)
         {
            if(!this._inside)
            {
               this.sysApi.sendAction(new d2actions.LeaveDialog());
            }
            this.uiApi.unloadUi("houseSale");
            return true;
         }
         return false;
      }
      
      private function onConfirmHouseBuy() : void
      {
         this.sysApi.sendAction(new HouseBuy(this._price));
         this.uiApi.unloadUi("houseSale");
      }
      
      public function unload() : void
      {
         this.sysApi.enableWorldInteraction();
      }
      
      private function onLeaveDialog() : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
   }
}
