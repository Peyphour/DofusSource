package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.uiApi.ConnectionApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.ChangeCharacter;
   import d2actions.ChangeServer;
   import d2actions.LoginWithSteam;
   import d2actions.QuitGame;
   import d2actions.ResetGame;
   import d2enums.BuildTypeEnum;
   import d2enums.IdentificationFailureReasonEnum;
   import d2hooks.AgreementsRequired;
   import d2hooks.AlreadyConnected;
   import d2hooks.AuthenticationTicketAccepted;
   import d2hooks.AuthenticationTicketRefused;
   import d2hooks.AuthentificationStart;
   import d2hooks.BreedsAvailable;
   import d2hooks.CharacterCreationStart;
   import d2hooks.CharacterImpossibleSelection;
   import d2hooks.CharacterSelectionStart;
   import d2hooks.CharactersListUpdated;
   import d2hooks.ConnectionTimerStart;
   import d2hooks.GameStart;
   import d2hooks.GiftList;
   import d2hooks.IdentificationFailed;
   import d2hooks.IdentificationFailedForBadVersion;
   import d2hooks.IdentificationFailedWithDuration;
   import d2hooks.IdentificationSuccess;
   import d2hooks.InformationPopup;
   import d2hooks.LoginQueueStatus;
   import d2hooks.NicknameRegistration;
   import d2hooks.OpenMainMenu;
   import d2hooks.QueueStatus;
   import d2hooks.SelectedServerRefused;
   import d2hooks.ServerConnectionFailed;
   import d2hooks.ServerSelectionStart;
   import d2hooks.ServersList;
   import d2hooks.TutorielAvailable;
   import d2hooks.UnexpectedSocketClosure;
   import d2hooks.UpdaterConnectionFailed;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import ui.CharacterCreation;
   import ui.CharacterHeader;
   import ui.CharacterSelection;
   import ui.GiftMenu;
   import ui.Login;
   import ui.LoginThirdParty;
   import ui.PreGameMainMenu;
   import ui.PseudoChoice;
   import ui.SecretPopup;
   import ui.ServerForm;
   import ui.ServerListSelection;
   import ui.ServerPopup;
   import ui.ServerSelection;
   import ui.ServerTypeSelection;
   import ui.UnavailableCharacterPopup;
   import ui.UserAgreement;
   import ui.items.GiftCharacterSelectionItem;
   
   public class Connection extends Sprite
   {
      
      public static var loginUiName:String = "login";
      
      private static var _self:Connection;
      
      public static var TUTORIAL_SELECTION:Boolean = false;
      
      public static var TUTORIAL_SELECTION_IS_AVAILABLE:Boolean = false;
      
      public static var BREEDS_AVAILABLE:int;
      
      public static var BREEDS_VISIBLE:int;
      
      public static var waitingForCreation:Boolean = false;
      
      public static var waitingForCharactersList:Boolean = false;
      
      public static var loginMustBeSaved:int;
       
      
      protected var login:Login;
      
      protected var loginThirdParty:LoginThirdParty;
      
      protected var serverSelection:ServerSelection;
      
      protected var serverTypeSelection:ServerTypeSelection;
      
      protected var serverListSelection:ServerListSelection;
      
      protected var serverForm:ServerForm;
      
      protected var serverPopup:ServerPopup;
      
      protected var characterCreation:CharacterCreation;
      
      protected var characterHeader:CharacterHeader;
      
      protected var characterSelection:ui.CharacterSelection;
      
      protected var pseudoChoice:PseudoChoice;
      
      protected var preGameMainMenu:PreGameMainMenu;
      
      protected var giftMenu:GiftMenu;
      
      protected var secretPopup:SecretPopup;
      
      protected var userAgreement:UserAgreement;
      
      protected var unavailableCharacterPopup:UnavailableCharacterPopup;
      
      protected var giftCharaSelectItem:GiftCharacterSelectionItem;
      
      public var uiApi:UiApi;
      
      public var sysApi:SystemApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var connecApi:ConnectionApi;
      
      public var dataApi:DataApi;
      
      public var timeApi:TimeApi;
      
      public var previousUi:String = "";
      
      public var currentUi:String = null;
      
      public var _charaList:Object;
      
      public var _serversList:Object;
      
      public var _sPopup:String;
      
      private var _timeoutTimer:Timer;
      
      private var _timeoutPopupName:String;
      
      public function Connection()
      {
         super();
      }
      
      public static function getInstance() : Connection
      {
         return _self;
      }
      
      public function main() : void
      {
         this.sysApi.addHook(AuthentificationStart,this.onAuthentificationStart);
         this.sysApi.addHook(ServerSelectionStart,this.onServerSelectionStart);
         this.sysApi.addHook(CharacterSelectionStart,this.onCharacterSelectionStart);
         this.sysApi.addHook(CharacterCreationStart,this.onCharacterCreationStart);
         this.sysApi.addHook(ServersList,this.onServersList);
         this.sysApi.addHook(SelectedServerRefused,this.onSelectedServerRefused);
         this.sysApi.addHook(GameStart,this.onGameStart);
         this.sysApi.addHook(GiftList,this.onGiftList);
         this.sysApi.addHook(CharactersListUpdated,this.onCharactersListUpdated);
         this.sysApi.addHook(CharacterImpossibleSelection,this.onCharacterImpossibleSelection);
         this.sysApi.addHook(TutorielAvailable,this.onTutorielAvailable);
         this.sysApi.addHook(BreedsAvailable,this.onBreedsAvailable);
         this.sysApi.addHook(OpenMainMenu,this.onOpenMainMenu);
         this.sysApi.addHook(ConnectionTimerStart,this.onConnectionTimerStart);
         this.sysApi.addHook(ServerConnectionFailed,this.onServerConnectionFailed);
         this.sysApi.addHook(UnexpectedSocketClosure,this.onUnexpectedSocketClosure);
         this.sysApi.addHook(AlreadyConnected,this.onAlreadyConnected);
         this.sysApi.addHook(UpdaterConnectionFailed,this.onUpdaterConnectionFailed);
         this.sysApi.addHook(LoginQueueStatus,this.removeTimer);
         this.sysApi.addHook(QueueStatus,this.removeTimer);
         this.sysApi.addHook(NicknameRegistration,this.removeTimer);
         this.sysApi.addHook(IdentificationSuccess,this.onIdentificationSuccess);
         this.sysApi.addHook(IdentificationFailed,this.onIdentificationFailed);
         this.sysApi.addHook(IdentificationFailedWithDuration,this.onIdentificationFailed);
         this.sysApi.addHook(IdentificationFailedForBadVersion,this.onIdentificationFailedForBadVersion);
         this.sysApi.addHook(AuthenticationTicketAccepted,this.onConnectionStart);
         this.sysApi.addHook(AuthenticationTicketRefused,this.removeTimer);
         this.sysApi.addHook(InformationPopup,this.onInformationPopup);
         if(this.sysApi.getConfigEntry("config.community.current") != "ja")
         {
            this.sysApi.addHook(AgreementsRequired,this.onAgreementsRequired);
         }
         this.uiApi.addShortcutHook("closeUi",this.onOpenMainMenu);
         if(this.sysApi.getConfigEntry("config.loginMode") == "web")
         {
            loginUiName = "loginThirdParty";
         }
         loginMustBeSaved = this.sysApi.getData("saveLogin");
         _self = this;
      }
      
      public function unload() : void
      {
         this.removeTimer();
         _self = null;
         this._charaList = null;
         this._serversList = null;
      }
      
      public function connexionEnd() : void
      {
         this.onGameStart();
      }
      
      public function characterCreationStart() : void
      {
         waitingForCreation = true;
         this.onCharacterCreationStart();
      }
      
      public function displayHeader(param1:Boolean = true) : void
      {
         var _loc2_:Object = this.uiApi.getUi("characterHeader");
         if(!_loc2_)
         {
            this.uiApi.loadUi("characterHeader","characterHeader",param1);
         }
         else if(param1)
         {
            if(_loc2_.uiClass)
            {
               _loc2_.uiClass.showHeader(true);
            }
         }
      }
      
      private function onAgreementsRequired(param1:Object) : void
      {
         if(!this.uiApi.getUi("userAgreement"))
         {
            this.uiApi.loadUi("userAgreement","userAgreement",param1,3);
         }
      }
      
      private function onAuthentificationStart(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         this.displayHeader(false);
         if(this.sysApi.isSteamEmbed() && !param1)
         {
            this.sysApi.sendAction(new LoginWithSteam());
         }
         this.uiApi.loadUi(loginUiName,null,[this._sPopup,!param1],1,null,true);
         if(this.sysApi.getBuildType() != BuildTypeEnum.BETA && !this.sysApi.isStreaming() && (this.sysApi.getOs() == "Linux" || this.sysApi.getOs() == "Mac OS") && !this.sysApi.isUpdaterVersion2OrUnknown())
         {
            this.sysApi.log(2,"sysApi.getOs() " + this.sysApi.getOs());
            if(!this.sysApi.getData("lastUpdaterMigrationWarning"))
            {
               this.sysApi.setData("lastUpdaterMigrationWarning",0);
            }
            _loc2_ = this.sysApi.getData("lastUpdaterMigrationWarning");
            _loc3_ = new Date().getTime();
            if(this.sysApi.getBuildType() == BuildTypeEnum.TESTING && (_loc2_ == 0 || _loc3_ - _loc2_ > 7200000) || _loc3_ >= 1393920000000 && (_loc2_ == 0 || _loc3_ - _loc2_ > 172800000))
            {
               this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.report.updaterMigration.popup"),[this.uiApi.getText("ui.common.ok")],[this.onPopupWait],this.onPopupWait,null,null,false,true);
               this.sysApi.setData("lastUpdaterMigrationWarning",_loc3_);
            }
         }
      }
      
      public function openPreviousUi() : void
      {
         switch(this.previousUi)
         {
            case "characterCreation":
            case loginUiName:
               this.onPreviousUiStart();
               break;
            case "serverListSelection":
            case "serverSelection":
            case "serverTypeSelection":
               this.sysApi.sendAction(new ChangeServer());
               break;
            case "characterSelection":
            default:
               if(this._charaList && this._charaList.length > 0)
               {
                  waitingForCharactersList = true;
                  this.onCharacterSelectionStart(this._charaList);
               }
               else if(this.sysApi.getCurrentServer())
               {
                  this.sysApi.sendAction(new ChangeCharacter(this.sysApi.getCurrentServer().id));
               }
               else
               {
                  this.sysApi.sendAction(new ChangeServer());
               }
         }
      }
      
      private function unlockLogin() : void
      {
         var _loc1_:Object = this.uiApi.getUi("login");
         if(_loc1_ && _loc1_.uiClass)
         {
            _loc1_.uiClass.disableUi(false);
         }
      }
      
      private function onConnectionStart() : void
      {
         if(this.uiApi.getUi(loginUiName))
         {
            this.previousUi = loginUiName;
            this.uiApi.unloadUi(loginUiName);
            this.uiApi.unloadUi(UIEnum.WEB_PORTAL);
         }
      }
      
      private function onCharacterSelectionStart(param1:Object) : void
      {
         if(!this.uiApi.getUi("characterCreation") || waitingForCharactersList)
         {
            if(TUTORIAL_SELECTION)
            {
               if(TUTORIAL_SELECTION_IS_AVAILABLE)
               {
                  TUTORIAL_SELECTION = false;
                  this.sysApi.sendAction(new d2actions.CharacterSelection(param1[0].id,true));
               }
               else
               {
                  this.sysApi.sendAction(new d2actions.CharacterSelection(param1[0].id,false));
               }
            }
            else
            {
               this._charaList = param1;
               this.displayHeader();
               if(!this.uiApi.getUi("characterSelection"))
               {
                  this.uiApi.loadUi("characterSelection","characterSelection",this._charaList);
               }
               this.previousUi = this.currentUi;
               this.currentUi = "characterSelection";
               if(this.previousUi)
               {
                  this.uiApi.unloadUi(this.previousUi);
               }
            }
            waitingForCharactersList = false;
         }
      }
      
      private function onCharacterCreationStart(param1:Object = null) : void
      {
         if(waitingForCreation || param1 && param1[0] && param1[0][0] == "create" && param1[1] == true || param1 && param1[0] && param1[0][0] != "create")
         {
            this.displayHeader();
            if(!this.uiApi.getUi("characterCreation"))
            {
               this.uiApi.loadUi("characterCreation","characterCreation",param1);
               this.previousUi = this.currentUi;
               this.currentUi = "characterCreation";
               if(this.previousUi)
               {
                  this.uiApi.unloadUi(this.previousUi);
               }
            }
            waitingForCreation = false;
         }
      }
      
      private function onServerSelectionStart(param1:Object = null) : void
      {
         waitingForCreation = param1[1];
         this.displayHeader();
         switch(param1[0])
         {
            case 1:
               this.uiApi.loadUi("serverListSelection");
               this.previousUi = this.currentUi;
               this.currentUi = "serverListSelection";
               if(this.previousUi)
               {
                  this.uiApi.unloadUi(this.previousUi);
               }
               break;
            case 2:
               this.uiApi.loadUi("serverTypeSelection");
               this.previousUi = this.currentUi;
               this.currentUi = "serverTypeSelection";
               if(this.previousUi)
               {
                  this.uiApi.unloadUi(this.previousUi);
               }
               break;
            case 0:
            default:
               this.uiApi.loadUi("serverSelection");
               this.previousUi = this.currentUi;
               this.currentUi = "serverSelection";
               if(this.previousUi)
               {
                  this.uiApi.unloadUi(this.previousUi);
               }
         }
      }
      
      private function onServersList(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         this._serversList = param1;
         if(!this.uiApi.getUi("serverSelection") && !this.uiApi.getUi("serverListSelection") && !this.uiApi.getUi("serverTypeSelection"))
         {
            _loc2_ = new Array();
            for each(_loc3_ in this.connecApi.getUsedServers())
            {
               _loc2_.push(_loc3_);
            }
            if(_loc2_.length > 0 && !waitingForCreation)
            {
               this.displayHeader();
               this.uiApi.loadUi("serverSelection");
               this.previousUi = this.currentUi;
               this.currentUi = "serverSelection";
               if(this.previousUi)
               {
                  this.uiApi.unloadUi(this.previousUi);
               }
            }
            else
            {
               this.onServerSelectionStart([2,true]);
            }
         }
      }
      
      private function onPreviousUiStart() : void
      {
         this.displayHeader();
         this.uiApi.loadUi(this.previousUi);
         var _loc1_:String = this.previousUi;
         this.previousUi = this.currentUi;
         this.currentUi = _loc1_;
         if(this.previousUi)
         {
            this.uiApi.unloadUi(this.previousUi);
         }
      }
      
      private function onGameStart() : void
      {
         this.uiApi.unloadUi(this.currentUi);
         this.uiApi.unloadUi("characterSelection");
         this.uiApi.unloadUi("characterHeader");
         this._charaList = null;
      }
      
      private function onOpenMainMenu(param1:String = "") : Boolean
      {
         if(!this.uiApi.getUi("preGameMainMenu"))
         {
            this.uiApi.loadUi("preGameMainMenu",null,[],3);
         }
         else
         {
            this.uiApi.unloadUi("preGameMainMenu");
         }
         return true;
      }
      
      private function onGiftList(param1:Object, param2:Object) : void
      {
         if(!this.uiApi.getUi("giftMenu"))
         {
            this.uiApi.loadUi("giftMenu","giftMenu",{
               "gift":param1,
               "chara":param2
            },2);
         }
         this.previousUi = this.currentUi;
         this.currentUi = "giftMenu";
         if(this.previousUi)
         {
            this.uiApi.unloadUi(this.previousUi);
         }
      }
      
      private function onTutorielAvailable(param1:Boolean) : void
      {
         TUTORIAL_SELECTION_IS_AVAILABLE = param1;
      }
      
      private function onBreedsAvailable(param1:int, param2:int) : void
      {
         BREEDS_AVAILABLE = param1;
         BREEDS_VISIBLE = param2;
      }
      
      public function onCharactersListUpdated(param1:Object) : void
      {
         var _loc2_:* = undefined;
         this._charaList = new Array();
         for each(_loc2_ in param1)
         {
            this._charaList.push(_loc2_);
         }
      }
      
      public function onConnectionTimerStart() : void
      {
         if(this._timeoutTimer)
         {
            this._timeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeOut);
            this._timeoutTimer.reset();
            this._timeoutTimer = null;
         }
         this._timeoutTimer = new Timer(10000,1);
         this._timeoutTimer.start();
         this._timeoutTimer.addEventListener(TimerEvent.TIMER,this.onTimeOut);
      }
      
      public function onCharacterImpossibleSelection(param1:Number) : void
      {
      }
      
      public function onSelectedServerRefused(param1:int, param2:String, param3:Object) : void
      {
         var _loc4_:* = null;
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         this.removeTimer();
         switch(param2)
         {
            case "AccountRestricted":
               _loc4_ = this.uiApi.getText("ui.server.cantChoose.serverForbidden");
               break;
            case "CommunityRestricted":
               _loc4_ = this.uiApi.getText("ui.server.cantChoose.communityRestricted");
               break;
            case "LocationRestricted":
               _loc4_ = this.uiApi.getText("ui.server.cantChoose.locationRestricted");
               break;
            case "SubscribersOnly":
               _loc4_ = this.uiApi.getText("ui.server.cantChoose.communityNonSubscriberRestricted");
               break;
            case "RegularPlayersOnly":
               _loc4_ = this.uiApi.getText("ui.server.cantChoose.regularPlayerRestricted");
               break;
            case "StatusOffline":
               this.sysApi.log(2,"StatusOffline");
               _loc4_ = this.uiApi.getText("ui.server.cantChoose.serverDown");
               break;
            case "StatusStarting":
               this.sysApi.log(2,"StatusStarting");
               _loc4_ = this.uiApi.getText("ui.server.cantChoose.serverDown");
               break;
            case "StatusNojoin":
               this.sysApi.log(2,"StatusNojoin");
               _loc4_ = this.uiApi.getText("ui.server.cantChoose.serverForbidden");
               break;
            case "StatusSaving":
               this.sysApi.log(2,"StatusSaving");
               _loc4_ = this.uiApi.getText("ui.server.cantChoose.serverSaving");
               break;
            case "StatusStoping":
               this.sysApi.log(2,"StatusStoping");
               _loc4_ = this.uiApi.getText("ui.server.cantChoose.serverDown");
               break;
            case "StatusFull":
               _loc4_ = this.uiApi.getText("ui.server.cantChoose.serverFull") + "\n\n";
               _loc5_ = "";
               for each(_loc6_ in param3)
               {
                  _loc5_ = _loc5_ + (this.dataApi.getServer(_loc6_).name + ", ");
               }
               if(_loc5_ != "")
               {
                  _loc5_ = _loc5_.substr(0,_loc5_.length - 2);
               }
               else
               {
                  _loc5_ = this.uiApi.getText("ui.common.none").toLocaleLowerCase();
               }
               _loc4_ = _loc4_ + this.uiApi.getText("ui.server.serversAccessibles",_loc5_);
               break;
            case "NoReason":
            case "StatusUnknown":
               _loc4_ = this.uiApi.getText("ui.popup.connectionRefused");
         }
         if(_loc4_)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),_loc4_,[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
         }
      }
      
      public function onIdentificationFailed(param1:uint, param2:Number = 0) : void
      {
         var _loc3_:String = null;
         this.removeTimer();
         if(param1 > 0)
         {
            switch(param1)
            {
               case IdentificationFailureReasonEnum.BANNED:
                  if(param2 == 0)
                  {
                     this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.banned"),[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  }
                  else
                  {
                     this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.bannedWithDuration",this.timeApi.getDate(param2,true) + " " + this.timeApi.getClock(param2,false,true)),[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  }
                  break;
               case IdentificationFailureReasonEnum.IN_MAINTENANCE:
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.inMaintenance"),[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  break;
               case IdentificationFailureReasonEnum.KICKED:
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.kicked"),[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  break;
               case IdentificationFailureReasonEnum.UNKNOWN_AUTH_ERROR:
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.unknown"),[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  break;
               case IdentificationFailureReasonEnum.WRONG_CREDENTIALS:
                  _loc3_ = !!this.sysApi.isGuest()?this.uiApi.getText("ui.popup.accessDenied.guestAccountNotFound"):this.uiApi.getText("ui.popup.accessDenied.wrongCredentials");
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),_loc3_,[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  break;
               case IdentificationFailureReasonEnum.BAD_IPRANGE:
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.badIpRange"),[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  break;
               case IdentificationFailureReasonEnum.TOO_MANY_ON_IP:
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.toomanyonip"),[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  break;
               case IdentificationFailureReasonEnum.TIME_OUT:
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.timeout"),[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  break;
               case IdentificationFailureReasonEnum.CREDENTIALS_RESET:
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.credentialsReset"),[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  break;
               case IdentificationFailureReasonEnum.EMAIL_UNVALIDATED:
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.unvalidatedEmail"),[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  break;
               case IdentificationFailureReasonEnum.SERVICE_UNAVAILABLE:
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.serviceUnavailable"),[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  break;
               case IdentificationFailureReasonEnum.OTP_TIMEOUT:
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.otpTimeout"),[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  break;
               case IdentificationFailureReasonEnum.SPARE:
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),"",[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
                  break;
               case IdentificationFailureReasonEnum.LOCKED:
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.locked"),[this.uiApi.getText("ui.common.ok")],[],null,null,null,false,true);
            }
         }
         this.unlockLogin();
      }
      
      public function onIdentificationSuccess(param1:String) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         this.removeTimer();
         if(param1 && param1.length > 0)
         {
            if(param1.indexOf("[") != -1 && param1.indexOf("]") != -1)
            {
               return;
            }
            _loc2_ = this.sysApi.getData("LastLogins");
            if(loginMustBeSaved > -1)
            {
               _loc3_ = new Array();
               for(_loc4_ in _loc2_)
               {
                  if(_loc2_[_loc4_] && _loc2_[_loc4_].toLowerCase() == param1.toLowerCase())
                  {
                     _loc2_.splice(_loc4_,1);
                     break;
                  }
               }
               _loc3_.push(param1);
               for each(_loc5_ in _loc2_)
               {
                  if(_loc3_.length < 10 && _loc3_.indexOf(_loc5_) == -1)
                  {
                     _loc3_.push(_loc5_);
                  }
               }
               this.sysApi.setData("LastLogins",_loc3_);
            }
            else if(_loc2_ && _loc2_.length > 0)
            {
               _loc6_ = new Array();
               for each(_loc7_ in _loc2_)
               {
                  if(_loc7_ && _loc7_.toLowerCase() != param1.toLowerCase())
                  {
                     _loc6_.push(_loc7_);
                  }
               }
               this.sysApi.setData("LastLogins",_loc6_);
            }
         }
      }
      
      public function onIdentificationFailedForBadVersion(param1:uint, param2:Object) : void
      {
         this.removeTimer();
         if(param1 == IdentificationFailureReasonEnum.BAD_VERSION)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.accessDenied.badVersion",this.sysApi.getCurrentVersion(),param2.major + "." + param2.minor + "." + param2.release + "." + param2.revision + "." + param2.patch),[this.uiApi.getText("ui.common.ok")]);
         }
         this.unlockLogin();
      }
      
      public function onServerConnectionFailed(param1:uint = 0) : void
      {
         this.removeTimer();
         if(param1 == 4)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.accessDenied"),this.uiApi.getText("ui.popup.silentServer"),[this.uiApi.getText("ui.common.ok")]);
         }
         else
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.popup.connectionFailed.text"),[this.uiApi.getText("ui.common.ok")]);
         }
         this.unlockLogin();
      }
      
      public function onUnexpectedSocketClosure() : void
      {
         this.removeTimer();
         this._sPopup = "unexpectedSocketClosure";
         this.modCommon.openPopup(this.uiApi.getText("ui.popup.unexpectedSocketClosure"),this.uiApi.getText("ui.popup.unexpectedSocketClosure.text"),[this.uiApi.getText("ui.common.ok")]);
         this.unlockLogin();
      }
      
      public function onAlreadyConnected() : void
      {
         this.removeTimer();
         this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.connection.disconnectAccount"),[this.uiApi.getText("ui.common.ok")]);
         this.unlockLogin();
      }
      
      public function onInformationPopup(param1:String) : void
      {
         this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),param1,[this.uiApi.getText("ui.common.ok")]);
      }
      
      public function onTimeOut(param1:TimerEvent) : void
      {
         this.removeTimer();
         this._timeoutPopupName = this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.popup.accessDenied.timeout"),[this.uiApi.getText("ui.common.wait"),this.uiApi.getText("ui.common.interrupt")],[this.onPopupWait,this.onPopupInterrupt],this.onPopupWait,this.onPopupInterrupt);
      }
      
      public function onPopupWait() : void
      {
      }
      
      public function onPopupInterrupt() : void
      {
         this.sysApi.sendAction(new ResetGame());
      }
      
      private function onUpdaterRequired() : void
      {
         this.sysApi.sendAction(new QuitGame());
      }
      
      public function removeTimer(... rest) : void
      {
         if(this._timeoutTimer)
         {
            this._timeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeOut);
            this._timeoutTimer.reset();
            this._timeoutTimer = null;
         }
      }
      
      private function onUpdaterConnectionFailed() : void
      {
         if(this.sysApi.isSteamEmbed())
         {
            if(this._timeoutTimer)
            {
               this._timeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTimeOut);
               this._timeoutTimer.reset();
               this._timeoutTimer = null;
            }
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.connection.updaterRequired"),[this.uiApi.getText("ui.common.ok")],[this.onUpdaterRequired],this.onUpdaterRequired,this.onUpdaterRequired);
         }
         else
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.connection.updaterConnectionFailed"),[this.uiApi.getText("ui.common.ok")]);
         }
      }
   }
}
