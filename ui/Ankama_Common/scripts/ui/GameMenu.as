package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.OpenMainMenu;
   import d2enums.WebLocationEnum;
   import d2hooks.LaggingNotification;
   import d2hooks.MailStatus;
   import d2hooks.OpenWebPortal;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class GameMenu
   {
      
      private static const NEW_MAIL_POPUP_DURATION:int = 15 * 1000;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var tooltipApi:TooltipApi;
      
      public var btn_abo:ButtonContainer;
      
      public var btn_options:ButtonContainer;
      
      public var btn_menu:ButtonContainer;
      
      public var btn_mp:ButtonContainer;
      
      public var btn_mpGrey:ButtonContainer;
      
      public var btn_newMail:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var ctr_newMail:GraphicContainer;
      
      public var ctr_bg:GraphicContainer;
      
      public var tx_btnMpBg:TextureBitmap;
      
      public var tx_lagometer:Texture;
      
      public var lbl_msgNumber:Label;
      
      public var lbl_newMail:Label;
      
      private var _mailUnread:uint;
      
      private var _mailTotal:uint;
      
      private var _newMailTimer:Timer;
      
      public function GameMenu()
      {
         super();
      }
      
      public function main(... rest) : void
      {
         this.sysApi.addHook(MailStatus,this.onMailStatus);
         this.sysApi.addHook(LaggingNotification,this.onLaggingNotification);
         this.uiApi.addComponentHook(this.btn_abo,"onRollOver");
         this.uiApi.addComponentHook(this.btn_abo,"onRollOut");
         this.uiApi.addComponentHook(this.btn_abo,"onRelease");
         this.uiApi.addComponentHook(this.btn_options,"onRollOver");
         this.uiApi.addComponentHook(this.btn_options,"onRollOut");
         this.uiApi.addComponentHook(this.btn_options,"onRelease");
         this.uiApi.addComponentHook(this.btn_menu,"onRollOver");
         this.uiApi.addComponentHook(this.btn_menu,"onRollOut");
         this.uiApi.addComponentHook(this.btn_menu,"onRelease");
         this.uiApi.addComponentHook(this.btn_mp,"onRollOver");
         this.uiApi.addComponentHook(this.btn_mp,"onRollOut");
         this.uiApi.addComponentHook(this.btn_mp,"onRelease");
         this.uiApi.addComponentHook(this.btn_newMail,"onRelease");
         this.uiApi.addComponentHook(this.btn_close,"onRelease");
         this.uiApi.addShortcutHook("optionMenu1",this.onShortcut);
         if(this.sysApi.getPlayerManager().subscriptionEndDate > 0 || this.sysApi.getPlayerManager().hasRights || this.sysApi.isSteamEmbed())
         {
            this.btn_abo.visible = false;
            this.ctr_bg.width = this.ctr_bg.width - 25;
            this.ctr_bg.x = this.ctr_bg.x + 25;
         }
         this.ctr_newMail.visible = false;
         this._newMailTimer = new Timer(NEW_MAIL_POPUP_DURATION,1);
         this._newMailTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerUp);
         this.tx_lagometer.visible = false;
      }
      
      private function onLaggingNotification(param1:Boolean) : void
      {
         this.tx_lagometer.visible = param1;
      }
      
      public function unload() : void
      {
         this.hideNewMailBox();
      }
      
      private function showNewMailBox() : void
      {
         this._newMailTimer.start();
         this.ctr_newMail.visible = true;
      }
      
      private function hideNewMailBox() : void
      {
         this._newMailTimer.stop();
         this._newMailTimer.reset();
         this.ctr_newMail.visible = false;
      }
      
      private function onTimerUp(param1:TimerEvent) : void
      {
         this.hideNewMailBox();
      }
      
      public function onMailStatus(param1:Boolean, param2:uint, param3:uint) : void
      {
         if(this.sysApi.isGuest())
         {
            return;
         }
         if(!this.btn_mp.visible)
         {
            this.btn_abo.x = this.btn_abo.x - 70;
            this.ctr_bg.x = this.ctr_bg.x - 65;
            this.ctr_bg.width = this.ctr_bg.width + 65;
         }
         this._mailUnread = param2;
         this._mailTotal = param3;
         var _loc4_:String = "";
         if(this._mailUnread <= 0)
         {
            this.lbl_msgNumber.cssClass = "center";
            this.btn_mpGrey.visible = true;
            this.btn_mp.visible = false;
         }
         else
         {
            this.lbl_msgNumber.cssClass = "darkboldcenter";
            this.btn_mpGrey.visible = false;
            this.btn_mp.visible = true;
         }
         this.lbl_msgNumber.visible = true;
         if(this._mailUnread <= 99)
         {
            this.lbl_msgNumber.text = this.utilApi.kamasToString(this._mailUnread,"") + _loc4_;
         }
         else
         {
            this.lbl_msgNumber.text = "99+";
         }
         if(param1)
         {
            this.showNewMailBox();
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         this.sysApi.log(8,"release sur " + param1 + " : " + param1.name);
         switch(param1)
         {
            case this.btn_mp:
            case this.btn_mpGrey:
               this.sysApi.dispatchHook(OpenWebPortal,WebLocationEnum.WEB_LOCATION_ANKABOX);
               this.btn_mp.selected = false;
               this._mailUnread = 0;
               break;
            case this.btn_menu:
               this.sysApi.sendAction(new OpenMainMenu());
               break;
            case this.btn_abo:
               this.sysApi.goToUrl(this.uiApi.getText("ui.link.subscribe"));
               break;
            case this.btn_options:
               this.modCommon.openOptionMenu(false,"performance");
               break;
            case this.btn_newMail:
               this.sysApi.dispatchHook(OpenWebPortal,WebLocationEnum.WEB_LOCATION_ANKABOX_LAST_UNREAD);
               this.hideNewMailBox();
               this.btn_mp.selected = false;
               this._mailUnread = 0;
               break;
            case this.btn_close:
               this.hideNewMailBox();
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc6_:Object = null;
         var _loc3_:uint = 7;
         var _loc4_:uint = 1;
         var _loc5_:String = null;
         switch(param1)
         {
            case this.btn_abo:
               _loc2_ = this.uiApi.getText("ui.header.subscribe");
               break;
            case this.btn_menu:
               _loc2_ = this.uiApi.getText("ui.banner.mainMenu");
               break;
            case this.btn_options:
               _loc2_ = this.uiApi.getText("ui.common.optionsMenu");
               break;
            case this.btn_mp:
            case this.btn_mpGrey:
               _loc2_ = this.uiApi.processText(this.uiApi.getText("ui.ankabox.unread",this._mailUnread),"m",this._mailUnread > 0);
         }
         _loc6_ = this.uiApi.textTooltipInfo(_loc2_);
         this.uiApi.showTooltip(_loc6_,param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "optionMenu1":
               this.modCommon.openOptionMenu(false,"performance");
               return true;
            default:
               return false;
         }
      }
   }
}
