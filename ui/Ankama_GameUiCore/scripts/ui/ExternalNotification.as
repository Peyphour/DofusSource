package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.ExternalNotificationApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.ContactLookRequestById;
   import d2enums.ComponentHookList;
   import d2hooks.ContactLook;
   
   public class ExternalNotification
   {
      
      private static const DEBUG:Boolean = false;
       
      
      private var _instanceId:String;
      
      private const TITLE_FONT_SIZE:uint = 12;
      
      private const MESSAGE_FONT_SIZE:uint = 12;
      
      private var _entityId:Number = -1;
      
      public var uiApi:UiApi;
      
      public var extNotifApi:ExternalNotificationApi;
      
      public var configApi:ConfigApi;
      
      public var sysApi:SystemApi;
      
      public var utilApi:UtilApi;
      
      public var ctr_extNotif:GraphicContainer;
      
      public var lbl_title:Label;
      
      public var lbl_notif:Label;
      
      public var btn_close:ButtonContainer;
      
      public var tx_slot:Texture;
      
      public var tx_iconBg:Texture;
      
      public var tx_icon:Texture;
      
      public var ed_player:EntityDisplayer;
      
      public function ExternalNotification()
      {
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:* = null;
         this._instanceId = this.uiApi.me().name;
         if(this.configApi.getConfigProperty("dofus","notificationsAlphaWindows") == true)
         {
            this.ctr_extNotif.alpha = 0.9;
         }
         this.ctr_extNotif.mouseChildren = this.ctr_extNotif.handCursor = true;
         this.uiApi.addComponentHook(this.ctr_extNotif,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ctr_extNotif,ComponentHookList.ON_ROLL_OVER);
         if(param1.title)
         {
            this.setLabelText(this.lbl_title,param1.title,this.TITLE_FONT_SIZE,this.lbl_title.cssClass);
         }
         if(param1.entityContactData)
         {
            this._entityId = param1.entityContactData.id;
            this.ed_player.visible = false;
            this.uiApi.addComponentHook(this.ed_player,"onEntityReady");
            this.sysApi.addHook(ContactLook,this.onContactLook);
            this.sysApi.sendAction(new ContactLookRequestById(param1.entityContactData.contactCategory,param1.entityContactData.id));
         }
         else if(param1.iconPath)
         {
            _loc2_ = this.sysApi.getConfigEntry("config.gfx.path") + param1.iconPath + "/";
            if(param1.iconBg)
            {
               this.tx_iconBg.uri = this.uiApi.createUri(_loc2_ + param1.iconBg + ".png");
            }
            this.tx_icon.uri = this.uiApi.createUri(_loc2_ + param1.icon + ".png");
         }
         if(param1.cssClass != "p")
         {
            this.lbl_notif.cssClass = param1.cssClass;
         }
         if(param1.css != "normal")
         {
            this.lbl_notif.css = this.uiApi.createUri(this.uiApi.me().getConstant("css") + param1.css + ".css");
         }
         this.setLabelText(this.lbl_notif,param1.message,this.MESSAGE_FONT_SIZE,param1.cssClass);
      }
      
      private function setLabelText(param1:Label, param2:String, param3:uint, param4:String) : void
      {
         if(this.sysApi.getCurrentLanguage() == "ja")
         {
            param1.useEmbedFonts = false;
         }
         param1.setCssSize(param3,param4);
         param1.appendText(param2,param4);
      }
      
      public function onContactLook(param1:Number, param2:String, param3:Object) : void
      {
         if(this._entityId == param1)
         {
            this.ed_player.entityScale = 1;
            this.ed_player.xOffset = this.ed_player.yOffset = 0;
            this.ed_player.withoutMount = true;
            this.ed_player.animation = "AnimStatique";
            this.ed_player.direction = 3;
            this.ed_player.look = param3;
         }
      }
      
      public function onEntityReady(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         if(this.ed_player == param1)
         {
            _loc2_ = this.ed_player.getSlotBounds("Tete");
            if(_loc2_)
            {
               _loc3_ = this.ed_player.getEntityBounds();
               _loc4_ = _loc3_.height / 2;
               if(_loc2_.y > 0)
               {
                  _loc4_ = _loc4_ - 10;
               }
               this.ed_player.entityScale = 2;
               this.ed_player.yOffset = _loc4_;
               this.ed_player.updateMask();
               this.ed_player.updateScaleAndOffsets();
            }
            this.ed_player.visible = true;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.extNotifApi.removeExternalNotification(this._instanceId);
               break;
            case this.ctr_extNotif:
               this.extNotifApi.removeExternalNotification(this._instanceId,true);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         if(param1 == this.ctr_extNotif)
         {
            this.extNotifApi.resetExternalNotificationDisplayTimeout(this._instanceId);
         }
      }
   }
}
