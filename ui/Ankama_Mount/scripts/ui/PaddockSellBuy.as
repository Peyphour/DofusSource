package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.uiApi.MountApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.LeaveExchangeMount;
   import d2actions.PaddockBuyRequest;
   import d2actions.PaddockSellRequest;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.LeaveDialog;
   
   public class PaddockSellBuy
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var mountApi:MountApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var utilApi:UtilApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _buyMode:Boolean;
      
      private var _price:uint;
      
      public var btn_close:ButtonContainer;
      
      public var btn_cancelSell:ButtonContainer;
      
      public var btn_ok:ButtonContainer;
      
      public var btn_lbl_btn_cancelSell:Label;
      
      public var lbl_title:Label;
      
      public var lbl_info:TextArea;
      
      public var lbl_input:Input;
      
      public var tx_input:Object;
      
      public function PaddockSellBuy()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
         this.uiApi.addComponentHook(this.btn_ok,"onRelease");
         this.uiApi.addComponentHook(this.btn_cancelSell,"onRelease");
         this.sysApi.addHook(LeaveDialog,this.onLeaveDialog);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortCut);
         this.lbl_input.restrictChars = "0-9";
         this.lbl_input.maxChars = 13;
         this.lbl_input.numberMax = ProtocolConstantsEnum.MAX_KAMA;
         this._price = param1.price;
         this._buyMode = !param1.sellMode;
         if(this._buyMode)
         {
            this.lbl_title.text = this.uiApi.getText("ui.mount.paddockPurchase");
            this.lbl_input.text = this._price.toString();
            this.lbl_input.mouseChildren = false;
            this.btn_lbl_btn_cancelSell.text = this.uiApi.getText("ui.common.cancel");
         }
         else
         {
            this.lbl_title.text = this.uiApi.getText("ui.mount.paddockSell");
            this.lbl_input.text = this._price.toString();
            this.lbl_input.focus();
            this.btn_cancelSell.visible = true;
            this.btn_lbl_btn_cancelSell.text = this.uiApi.getText("ui.common.cancelTheSale");
         }
         var _loc2_:Object = this.mountApi.getCurrentPaddock();
         this.lbl_info.text = this.uiApi.getText("ui.mount.paddockDescription",_loc2_.maxOutdoorMount,_loc2_.maxItems);
      }
      
      public function unload() : void
      {
      }
      
      private function onConfirmBuy() : void
      {
         this.sysApi.sendAction(new PaddockBuyRequest(this._price));
      }
      
      private function onConfirmSell() : void
      {
         this.sysApi.sendAction(new PaddockSellRequest(this.utilApi.stringToKamas(this.lbl_input.text,"")));
      }
      
      private function onCancelBuy() : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
         if(param1 == this.btn_close)
         {
            this.sysApi.sendAction(new LeaveExchangeMount());
         }
         else if(param1 == this.btn_ok)
         {
            if(this._buyMode)
            {
               this.modCommon.openPopup(this.uiApi.getText("ui.mount.paddockPurchase"),this.uiApi.getText("ui.mount.doUBuyPaddock",this.utilApi.kamasToString(this._price)),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmBuy,this.onCancelBuy],this.onConfirmBuy,this.onCancelBuy);
            }
            else
            {
               this.modCommon.openPopup(this.uiApi.getText("ui.mount.paddockSell"),this.uiApi.getText("ui.mount.doUSellPaddock",this.utilApi.kamasToString(this.utilApi.stringToKamas(this.lbl_input.text,""),"")),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmSell,this.onCancelBuy],this.onConfirmSell,this.onCancelBuy);
            }
         }
         else if(param1 == this.btn_cancelSell)
         {
            if(this._buyMode)
            {
               this.sysApi.sendAction(new LeaveExchangeMount());
            }
            else
            {
               this.sysApi.sendAction(new PaddockSellRequest(0,false));
            }
         }
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         if(param1 == ShortcutHookListEnum.CLOSE_UI)
         {
            this.sysApi.sendAction(new LeaveExchangeMount());
            return true;
         }
         return false;
      }
      
      private function onLeaveDialog() : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
   }
}
