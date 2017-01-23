package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import d2hooks.GuestLimitationPopup;
   import d2hooks.GuestMode;
   import d2hooks.NonSubscriberPopup;
   import d2hooks.OpenWebService;
   import d2hooks.SubscriptionZone;
   
   public class PayZone
   {
      
      public static const PAY_ZONE_MODE:int = 0;
      
      public static const GUEST_MODE:int = 1;
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      private var _mode:int;
      
      private var _link:String;
      
      public var imagePopupWindow:GraphicContainer;
      
      public var btn_topLeft:ButtonContainer;
      
      public var btn_link:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var bgTexturebtn_topLeft:Texture;
      
      public var lbl_title:Label;
      
      public var lbl_description:Label;
      
      public var btn_lbl_btn_link:Label;
      
      public function PayZone()
      {
         super();
      }
      
      public function main(param1:Array) : void
      {
         this.sysApi.addHook(NonSubscriberPopup,this.onNonSubscriberPopup);
         this.sysApi.addHook(SubscriptionZone,this.onSubscriptionZone);
         this.sysApi.addHook(GuestLimitationPopup,this.onGuestLimitationPopup);
         this.sysApi.addHook(GuestMode,this.onGuestMode);
         this.uiApi.addComponentHook(this.btn_topLeft,"onRollOver");
         this.uiApi.addComponentHook(this.btn_topLeft,"onRollOut");
         this._mode = param1[0];
         if(this._mode == PAY_ZONE_MODE)
         {
            this.bgTexturebtn_topLeft.uri = this.uiApi.createUri(this.uiApi.me().getConstant("uri_payzone"));
            this.lbl_title.text = this.uiApi.getText("ui.payzone.title");
            this.lbl_description.text = this.uiApi.getText("ui.payzone.description");
            this.btn_lbl_btn_link.text = !!this.sysApi.isSteamEmbed()?this.uiApi.getText("ui.header.subscribe"):this.uiApi.getText("ui.payzone.btn");
            this._link = this.uiApi.getText("ui.link.members");
         }
         else if(this._mode == GUEST_MODE)
         {
            this.bgTexturebtn_topLeft.uri = this.uiApi.createUri(this.uiApi.me().getConstant("uri_guest"));
            this.lbl_title.text = this.uiApi.getText("ui.guest.guestMode");
            this.lbl_description.text = this.uiApi.getText("ui.guest.description");
            this.btn_lbl_btn_link.text = this.uiApi.getText("ui.guest.register");
         }
         if(param1.length > 1)
         {
            this.showPopup(param1[1]);
            this.btn_topLeft.visible = !param1[1];
         }
      }
      
      public function unload() : void
      {
      }
      
      private function showPopup(param1:Boolean) : void
      {
         this.imagePopupWindow.visible = param1;
         this.uiApi.me().render();
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.imagePopupWindow.visible = false;
               break;
            case this.btn_link:
               if(this.sysApi.isSteamEmbed())
               {
                  this.sysApi.dispatchHook(OpenWebService,"webShop",{"categoryId":544});
               }
               else if(this._mode == GUEST_MODE)
               {
                  this.sysApi.convertGuestAccount();
               }
               else
               {
                  this.sysApi.goToUrl(this._link);
               }
               this.imagePopupWindow.visible = false;
               break;
            case this.btn_topLeft:
               this.imagePopupWindow.visible = true;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case this.btn_topLeft:
               if(this._mode == GUEST_MODE)
               {
                  _loc2_ = this.uiApi.getText("ui.guest.register");
               }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,10,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onGuestLimitationPopup() : void
      {
         this.imagePopupWindow.visible = true;
      }
      
      private function onGuestMode(param1:Boolean) : void
      {
         if(param1)
         {
            this.btn_topLeft.visible = true;
            this.imagePopupWindow.visible = true;
         }
         else if(this.uiApi)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onNonSubscriberPopup() : void
      {
         this.imagePopupWindow.visible = true;
      }
      
      private function onSubscriptionZone(param1:Boolean) : void
      {
         if(param1)
         {
            this.btn_topLeft.visible = true;
            this.imagePopupWindow.visible = true;
         }
         else if(this.uiApi)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
   }
}
