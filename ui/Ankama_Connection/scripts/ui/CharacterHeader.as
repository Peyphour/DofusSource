package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2enums.BuildTypeEnum;
   import d2enums.ComponentHookList;
   import d2hooks.AuthenticationTicket;
   import d2hooks.ServersList;
   
   public class CharacterHeader
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var timeApi:TimeApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var tx_bg:Texture;
      
      public var ctr_main:GraphicContainer;
      
      public var btn_subscribe:ButtonContainer;
      
      public var lbl_pseudo:Label;
      
      public var lbl_abo:Label;
      
      public var lbl_server:Label;
      
      public var tx_logo:Texture;
      
      public var tx_background:Texture;
      
      private var _subscriberMode:Boolean;
      
      public function CharacterHeader()
      {
         super();
      }
      
      public function main(... rest) : void
      {
         this.sysApi.addHook(AuthenticationTicket,this.onAuthenticationTicket);
         this.sysApi.addHook(ServersList,this.onServersList);
         this.uiApi.addComponentHook(this.lbl_abo,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_abo,ComponentHookList.ON_ROLL_OUT);
         this.showHeader(rest[0]);
         this.btn_subscribe.soundId = SoundEnum.SPEC_BUTTON;
      }
      
      public function unload() : void
      {
      }
      
      public function showHeader(param1:Boolean) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         this.ctr_main.visible = param1;
         if(param1)
         {
            _loc2_ = this.sysApi.getConfigKey("subscriberMode");
            if(_loc2_ === false || _loc2_ == "false" || this.sysApi.isSteamEmbed())
            {
               this.lbl_abo.visible = false;
               this.btn_subscribe.visible = false;
            }
            this.playerDisplay();
            if(this.sysApi.getBuildType() != BuildTypeEnum.BETA && (this.sysApi.getOs() == "Windows" && this.sysApi.getOsVersion() == "2000" || this.sysApi.getOs() == "Mac OS" && this.sysApi.getCpu() == "PowerPC"))
            {
               if(!this.sysApi.getData("lastOsWarning"))
               {
                  this.sysApi.setData("lastOsWarning",0);
               }
               _loc3_ = this.sysApi.getData("lastOsWarning");
               _loc4_ = new Date().getTime();
               if(_loc3_ == 0 || _loc4_ - _loc3_ > 604800000)
               {
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.report.oldOs.popup"),[this.uiApi.getText("ui.common.ok")],[this.voidFunction],this.voidFunction);
                  this.sysApi.setData("lastOsWarning",_loc4_);
               }
            }
         }
      }
      
      private function playerDisplay() : void
      {
         if(this.sysApi.isGuest())
         {
            this.lbl_pseudo.text = this.uiApi.getText("ui.header.dofusPseudo") + this.uiApi.getText("ui.common.colon");
         }
         else
         {
            this.lbl_pseudo.text = this.uiApi.getText("ui.header.dofusPseudo") + this.uiApi.getText("ui.common.colon") + this.sysApi.getPlayerManager().nickname;
         }
         if(this.sysApi.getPlayerManager().subscriptionEndDate == 0)
         {
            if(this.sysApi.getPlayerManager().hasRights)
            {
               this.lbl_abo.text = this.uiApi.getText("ui.common.admin");
            }
            else if(this.sysApi.isGuest())
            {
               this.lbl_abo.text = this.uiApi.getText("ui.guest.guestMode");
            }
            else
            {
               this.lbl_abo.text = this.uiApi.getText("ui.common.non_subscriber");
            }
         }
         else if(this.sysApi.getPlayerManager().subscriptionEndDate < 2051222400000)
         {
            this.lbl_abo.text = this.uiApi.getText("ui.common.until",this.timeApi.getDate(this.sysApi.getPlayerManager().subscriptionEndDate,true,true) + " " + this.timeApi.getClock(this.sysApi.getPlayerManager().subscriptionEndDate,true,true));
         }
         else
         {
            this.lbl_abo.text = this.uiApi.getText("ui.common.infiniteSubscription");
         }
         this.lbl_server.text = this.uiApi.getText("ui.header.server") + this.uiApi.getText("ui.common.colon");
         var _loc1_:Server = this.sysApi.getCurrentServer();
         if(_loc1_)
         {
            this.lbl_server.text = this.lbl_server.text + _loc1_.name;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_subscribe:
               this.sysApi.goToUrl(this.uiApi.getText("ui.link.subscribe"));
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         switch(param1)
         {
            case this.lbl_abo:
               if(this.sysApi.getPlayerManager().subscriptionEndDate > 0)
               {
                  this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this.uiApi.getText("ui.header.subscriptionEndDate")),param1,false,"standard",2,8,0,null,null,null,"TextInfo");
               }
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onAuthenticationTicket() : void
      {
         this.playerDisplay();
      }
      
      public function onServersList(param1:Object) : void
      {
         this.playerDisplay();
      }
      
      public function validPoll(param1:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc2_:* = "ID:" + this.sysApi.getPlayerManager().accountId + ",";
         if(param1.length)
         {
            _loc2_ = _loc2_ + "A:";
         }
         for each(_loc3_ in param1)
         {
            _loc2_ = _loc2_ + (_loc3_ + ",");
         }
         _loc2_ = _loc2_.substr(0,_loc2_.length - 1);
         if(this.sysApi.getOs() == "Windows" && this.sysApi.getOsVersion() == "2000")
         {
            _loc4_ = this.sysApi.sendStatisticReport("SondageWindows2000",_loc2_);
         }
         else if(this.sysApi.getOs() == "Mac OS" && this.sysApi.getCpu() == "PowerPC")
         {
            this.sysApi.sendStatisticReport("SondageMacPPC",_loc2_);
         }
      }
      
      public function voidFunction() : void
      {
      }
   }
}
