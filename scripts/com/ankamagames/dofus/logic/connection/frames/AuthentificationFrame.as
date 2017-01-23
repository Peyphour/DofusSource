package com.ankamagames.dofus.logic.connection.frames
{
   import by.blooddy.crypto.MD5;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.Constants;
   import com.ankamagames.dofus.internalDatacenter.connection.SubscriberGift;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.net.DisconnectionReasonEnum;
   import com.ankamagames.dofus.logic.common.actions.BrowserDomainReadyAction;
   import com.ankamagames.dofus.logic.common.frames.AuthorizedFrame;
   import com.ankamagames.dofus.logic.common.frames.ChangeCharacterFrame;
   import com.ankamagames.dofus.logic.common.frames.DisconnectionHandlerFrame;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.connection.actions.LoginAsGuestAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAsGuestAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationWithSteamAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationWithTicketAction;
   import com.ankamagames.dofus.logic.connection.actions.NicknameChoiceRequestAction;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.connection.managers.GuestModeManager;
   import com.ankamagames.dofus.logic.connection.managers.SpecialBetaAuthentification;
   import com.ankamagames.dofus.logic.connection.managers.SteamConnectionManager;
   import com.ankamagames.dofus.logic.connection.managers.StoreUserDataManager;
   import com.ankamagames.dofus.logic.game.approach.actions.NewsLoginRequestAction;
   import com.ankamagames.dofus.logic.game.approach.actions.SubscribersGiftListRequestAction;
   import com.ankamagames.dofus.logic.game.approach.managers.PartManager;
   import com.ankamagames.dofus.logic.game.approach.managers.PartManagerV2;
   import com.ankamagames.dofus.logic.game.common.frames.ProtectPishingFrame;
   import com.ankamagames.dofus.logic.game.common.managers.SteamManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.enums.IdentificationFailureReasonEnum;
   import com.ankamagames.dofus.network.messages.connection.HelloConnectMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationFailedBannedMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationFailedForBadVersionMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationFailedMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationSuccessMessage;
   import com.ankamagames.dofus.network.messages.connection.IdentificationSuccessWithLoginTokenMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameAcceptedMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameChoiceRequestMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameRefusedMessage;
   import com.ankamagames.dofus.network.messages.connection.register.NicknameRegistrationMessage;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.json.JSONDecoder;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.ServerConnection;
   import com.ankamagames.jerakine.network.messages.ServerConnectionFailedMessage;
   import com.ankamagames.jerakine.resources.adapters.impl.SignedFileAdapter;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.crypto.Base64;
   import com.ankamagames.jerakine.utils.crypto.Signature;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.CommandLineArguments;
   import flash.events.Event;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class AuthentificationFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AuthentificationFrame));
      
      private static var _lastTicket:String;
       
      
      private var _loader:IResourceLoader;
      
      private var _contextLoader:LoaderContext;
      
      private var _dispatchModuleHook:Boolean;
      
      private var _connexionSequence:Array;
      
      private var _autoConnect:Boolean = false;
      
      private var commonMod:Object;
      
      private var _lastLoginHash:String;
      
      private var _lva:LoginValidationAction;
      
      private var _streamingBetaAccess:Boolean = false;
      
      public function AuthentificationFrame(param1:Boolean = true)
      {
         this.commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
         super();
         this._dispatchModuleHook = param1;
         this._contextLoader = new LoaderContext();
         this._contextLoader.checkPolicyFile = true;
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoad);
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:DisconnectionHandlerFrame = null;
         var _loc5_:Frame = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         this.processInvokeArgs();
         if(AirScanner.isStreamingVersion() && !GuestModeManager.getInstance().forceGuestMode && !this._autoConnect)
         {
            Dofus.getInstance().strLoaderComplete();
         }
         if(this._dispatchModuleHook)
         {
            PartManagerV2.getInstance().init();
            if(AirScanner.isStreamingVersion())
            {
               _loc1_ = OptionManager.getOptionManager("dofus")["legalAgreementTou"];
               _loc2_ = XmlConfig.getInstance().getEntry("config.lang.current") + "#" + (I18n.getUiText("ui.legal.tou1") + I18n.getUiText("ui.legal.tou2")).length;
               _loc3_ = new Array();
               if(_loc1_ != _loc2_)
               {
                  _loc3_.push("tou");
               }
               if(_loc3_.length > 0)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.AgreementsRequired,_loc3_);
               }
            }
            if(GuestModeManager.getInstance().forceGuestMode)
            {
               GuestModeManager.getInstance().logAsGuest();
            }
            else
            {
               if(Kernel.getWorker().contains(ProtectPishingFrame))
               {
                  _log.error("Oh oh ! ProtectPishingFrame is still here, it shoudln\'t be. Who else is in here ?");
                  for each(_loc5_ in Kernel.getWorker().framesList)
                  {
                     _loc6_ = getQualifiedClassName(_loc5_);
                     _loc7_ = _loc6_.split("::");
                     _log.error(" - " + _loc7_[_loc7_.length - 1]);
                  }
                  Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(ProtectPishingFrame));
               }
               _loc4_ = Kernel.getWorker().getFrame(DisconnectionHandlerFrame) as DisconnectionHandlerFrame;
               KernelEventsManager.getInstance().processCallback(HookList.AuthentificationStart,_loc4_.mustShowSteamLoginInterface);
            }
         }
         return true;
      }
      
      private function onStreamingBetaAuthentification(param1:Event) : void
      {
         var _loc4_:Boolean = true;
         if(SpecialBetaAuthentification(param1.target).haveAccess)
         {
            this._streamingBetaAccess = true;
            if(!_loc3_)
            {
               this.process(this._lva);
            }
            else
            {
               addr129:
               while(true)
               {
                  if(_loc4_)
                  {
                     addr86:
                     while(true)
                     {
                        loop1:
                        while(true)
                        {
                           if(!_loc3_)
                           {
                              addr48:
                              while(true)
                              {
                                 _loc2_.openPopup(I18n.getUiText("ui.popup.information"),"You are trying to access to a private beta but your account is not allowed.",[I18n.getUiText("ui.common.ok")]);
                                 if(_loc4_)
                                 {
                                    if(!_loc4_)
                                    {
                                       addr70:
                                       return;
                                    }
                                    break loop1;
                                 }
                                 continue loop1;
                              }
                           }
                        }
                     }
                  }
               }
            }
            return;
         }
         if(UiModuleManager.getInstance().isDevMode)
         {
            if(!_loc3_)
            {
               UiModuleManager.getInstance().isDevMode = false;
            }
            if(_loc3_)
            {
               §§goto(addr48);
            }
            else
            {
               this.process(this._lva);
               if(_loc3_)
               {
                  §§goto(addr86);
               }
            }
            §§goto(addr70);
         }
         while(true)
         {
            this._streamingBetaAccess = false;
            if(!_loc3_)
            {
               if(!_loc3_)
               {
               }
               §§push(KernelEventsManager.getInstance());
               §§push(HookList.IdentificationFailed);
               §§push(0);
               if(_loc3_)
               {
                  §§push((§§pop() - 1 + 1 + 48 - 82) * 3);
               }
               §§pop().processCallback(§§pop(),§§pop());
            }
            §§goto(addr129);
         }
      }
      
      public function process(param1:Message) : Boolean
      {
         var bdra:BrowserDomainReadyAction = null;
         var lva:LoginValidationAction = null;
         var connexionPorts:Array = null;
         var ports:String = null;
         var connectionHostsEntry:String = null;
         var connexionHosts:Array = null;
         var tmpHosts:Array = null;
         var defaultPort:uint = 0;
         var firstConnexionSequence:Array = null;
         var connInfo:Object = null;
         var scfMsg:ServerConnectionFailedMessage = null;
         var hcmsg:HelloConnectMessage = null;
         var iMsg:IdentificationMessage = null;
         var dhf:DisconnectionHandlerFrame = null;
         var time:int = 0;
         var elapsedTimesSinceConnectionFail:Vector.<uint> = null;
         var failureTimes:Array = null;
         var ismsg:IdentificationSuccessMessage = null;
         var updaterV2:Boolean = false;
         var iffbvmsg:IdentificationFailedForBadVersionMessage = null;
         var ifbmsg:IdentificationFailedBannedMessage = null;
         var ifmsg:IdentificationFailedMessage = null;
         var nrmsg:NicknameRegistrationMessage = null;
         var nrfmsg:NicknameRefusedMessage = null;
         var namsg:NicknameAcceptedMessage = null;
         var ncra:NicknameChoiceRequestAction = null;
         var ncrmsg:NicknameChoiceRequestMessage = null;
         var sglra:SubscribersGiftListRequestAction = null;
         var uri:Uri = null;
         var lang:String = null;
         var nlra:NewsLoginRequestAction = null;
         var uri2:Uri = null;
         var lang2:String = null;
         var token:String = null;
         var fakeLvwta:LoginValidationWithTicketAction = null;
         var sba:SpecialBetaAuthentification = null;
         var porc:String = null;
         var connectionHostsSignatureEntry:String = null;
         var output:ByteArray = null;
         var signedData:ByteArray = null;
         var signature:Signature = null;
         var validHosts:Boolean = false;
         var tmpHost:String = null;
         var randomHost:Object = null;
         var host:String = null;
         var port:uint = 0;
         var rawParam:String = null;
         var params:Array = null;
         var tmp:Array = null;
         var param:String = null;
         var tmp2:Array = null;
         var formerPort:uint = 0;
         var retryConnInfo:Object = null;
         var i:int = 0;
         var elapsedSeconds:Number = NaN;
         var lengthModsTou:String = null;
         var newLengthModsTou:String = null;
         var files:Array = null;
         var msg:Message = param1;
         switch(true)
         {
            case msg is LoginAsGuestAction:
               GuestModeManager.getInstance().logAsGuest();
               return true;
            case msg is LoginValidationWithSteamAction:
               SteamConnectionManager.getInstance().requestApiToken(SteamManager.getInstance().steamUserId);
               return true;
            case msg is BrowserDomainReadyAction:
               bdra = BrowserDomainReadyAction(msg);
               if(bdra.browser.content)
               {
                  try
                  {
                     token = bdra.browser.content.getElementById("token").innerHTML;
                  }
                  catch(error:Error)
                  {
                     _log.fatal("Could not find authentication token on " + bdra.browser.location + " (" + error.message + ")");
                  }
                  if(token)
                  {
                     fakeLvwta = LoginValidationWithTicketAction.create(token,false);
                     this.process(fakeLvwta);
                  }
                  else
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailed,IdentificationFailureReasonEnum.SERVICE_UNAVAILABLE);
                  }
                  bdra.browser.clearLocation();
               }
               return true;
            case msg is LoginValidationAction:
               lva = LoginValidationAction(msg);
               GuestModeManager.getInstance().isLoggingAsGuest = lva is LoginValidationAsGuestAction;
               if(this._lastLoginHash != MD5.hash(lva.username))
               {
                  this._streamingBetaAccess = false;
                  UiModuleManager.getInstance().isDevMode = XmlConfig.getInstance().getEntry("config.dev.mode");
               }
               if(BuildInfos.BUILD_TYPE < BuildTypeEnum.TESTING && (UiModuleManager.getInstance().isDevMode && this._lastLoginHash != MD5.hash(lva.username)))
               {
                  this._lastLoginHash = MD5.hash(lva.username);
                  this._lva = lva;
                  sba = new SpecialBetaAuthentification(lva.username,!!AirScanner.isStreamingVersion()?SpecialBetaAuthentification.STREAMING:SpecialBetaAuthentification.MODULES);
                  sba.addEventListener(Event.INIT,this.onStreamingBetaAuthentification);
                  return true;
               }
               this._lastLoginHash = MD5.hash(lva.username);
               connexionPorts = new Array();
               ports = XmlConfig.getInstance().getEntry("config.connection.port");
               for each(porc in ports.split(","))
               {
                  connexionPorts.push(int(porc));
               }
               connectionHostsEntry = XmlConfig.getInstance().getEntry("config.connection.host");
               if(BuildInfos.BUILD_TYPE < BuildTypeEnum.INTERNAL)
               {
                  connectionHostsSignatureEntry = XmlConfig.getInstance().getEntry("config.connection.host.signature");
                  output = new ByteArray();
                  try
                  {
                     signedData = Base64.decodeToByteArray(connectionHostsSignatureEntry);
                  }
                  catch(error:Error)
                  {
                     _log.warn("Host signature has not been properly encoded in Base64.");
                     commonMod.openPopup(I18n.getUiText("ui.common.error"),I18n.getUiText("ui.popup.connectionFailed.unauthenticatedHost"),[I18n.getUiText("ui.common.ok")]);
                     KernelEventsManager.getInstance().processCallback(HookList.SelectedServerFailed);
                     return false;
                  }
                  signedData.position = signedData.length;
                  signedData.writeUTFBytes(connectionHostsEntry);
                  signedData.position = 0;
                  signature = new Signature(SignedFileAdapter.defaultSignatureKey);
                  validHosts = signature.verify(signedData,output);
                  if(!validHosts)
                  {
                     _log.warn("Host signature could not be verified, connection refused.");
                     this.commonMod.openPopup(I18n.getUiText("ui.common.error"),I18n.getUiText("ui.popup.connectionFailed.unauthenticatedHost"),[I18n.getUiText("ui.common.ok")]);
                     KernelEventsManager.getInstance().processCallback(HookList.SelectedServerFailed);
                     return false;
                  }
               }
               connexionHosts = connectionHostsEntry.split(",");
               tmpHosts = [];
               for each(tmpHost in connexionHosts)
               {
                  tmpHosts.push({
                     "host":tmpHost,
                     "random":Math.random()
                  });
               }
               tmpHosts.sortOn("random",Array.NUMERIC);
               connexionHosts = [];
               for each(randomHost in tmpHosts)
               {
                  connexionHosts.push(randomHost.host);
               }
               defaultPort = uint(StoreDataManager.getInstance().getData(Constants.DATASTORE_COMPUTER_OPTIONS,"connectionPortDefault"));
               this._connexionSequence = [];
               firstConnexionSequence = [];
               for each(host in connexionHosts)
               {
                  for each(port in connexionPorts)
                  {
                     if(defaultPort == port)
                     {
                        firstConnexionSequence.push({
                           "host":host,
                           "port":port
                        });
                     }
                     else
                     {
                        this._connexionSequence.push({
                           "host":host,
                           "port":port
                        });
                     }
                  }
               }
               this._connexionSequence = firstConnexionSequence.concat(this._connexionSequence);
               if(Constants.EVENT_MODE)
               {
                  rawParam = Constants.EVENT_MODE_PARAM;
                  if(rawParam && rawParam.charAt(0) != "!")
                  {
                     rawParam = Base64.decode(rawParam);
                     params = [];
                     tmp = rawParam.split(",");
                     for each(param in tmp)
                     {
                        tmp2 = param.split(":");
                        params[tmp2[0]] = tmp2[1];
                     }
                     if(params["login"])
                     {
                        lva.username = params["login"];
                     }
                     if(params["password"])
                     {
                        lva.password = params["password"];
                     }
                  }
               }
               AuthentificationManager.getInstance().setValidationAction(lva);
               connInfo = this._connexionSequence.shift();
               ConnectionsHandler.connectToLoginServer(connInfo.host,connInfo.port);
               return true;
            case msg is ServerConnectionFailedMessage:
               scfMsg = ServerConnectionFailedMessage(msg);
               if(AirScanner.isStreamingVersion())
               {
                  Dofus.getInstance().strLoaderComplete();
               }
               if(scfMsg.failedConnection == ConnectionsHandler.getConnection().getSubConnection(scfMsg))
               {
                  PlayerManager.getInstance().destroy();
                  (ConnectionsHandler.getConnection().mainConnection as ServerConnection).stopConnectionTimeout();
                  formerPort = scfMsg.failedConnection.port;
                  if(this._connexionSequence)
                  {
                     retryConnInfo = this._connexionSequence.shift();
                     if(retryConnInfo)
                     {
                        ConnectionsHandler.connectToLoginServer(retryConnInfo.host,retryConnInfo.port);
                     }
                     else
                     {
                        KernelEventsManager.getInstance().processCallback(HookList.ServerConnectionFailed,DisconnectionReasonEnum.UNEXPECTED);
                     }
                  }
               }
               return true;
            case msg is HelloConnectMessage:
               hcmsg = HelloConnectMessage(msg);
               AuthentificationManager.getInstance().setPublicKey(hcmsg.key);
               AuthentificationManager.getInstance().setSalt(hcmsg.salt);
               AuthentificationManager.getInstance().initAESKey();
               iMsg = AuthentificationManager.getInstance().getIdentificationMessage();
               _log.info("Current version : " + iMsg.version.major + "." + iMsg.version.minor + "." + iMsg.version.release + "." + iMsg.version.revision + "." + iMsg.version.patch);
               dhf = Kernel.getWorker().getFrame(DisconnectionHandlerFrame) as DisconnectionHandlerFrame;
               time = Math.round(getTimer() / 1000);
               elapsedTimesSinceConnectionFail = new Vector.<uint>();
               failureTimes = StoreDataManager.getInstance().getData(Constants.DATASTORE_MODULE_DEBUG,"connection_fail_times");
               if(failureTimes)
               {
                  i = 0;
                  while(i < failureTimes.length)
                  {
                     elapsedSeconds = time - failureTimes[i];
                     if(elapsedSeconds <= 3600)
                     {
                        elapsedTimesSinceConnectionFail[i] = elapsedSeconds;
                     }
                     i++;
                  }
                  dhf.resetConnectionAttempts();
               }
               iMsg.failedAttempts = elapsedTimesSinceConnectionFail;
               ConnectionsHandler.getConnection().send(iMsg);
               KernelEventsManager.getInstance().processCallback(HookList.ConnectionTimerStart);
               TimeManager.getInstance().reset();
               return true;
            case msg is IdentificationSuccessMessage:
               ismsg = IdentificationSuccessMessage(msg);
               if(ismsg is IdentificationSuccessWithLoginTokenMessage)
               {
                  AuthentificationManager.getInstance().nextToken = IdentificationSuccessWithLoginTokenMessage(ismsg).loginToken;
               }
               if(ismsg.login)
               {
                  AuthentificationManager.getInstance().username = ismsg.login;
               }
               PlayerManager.getInstance().accountId = ismsg.accountId;
               PlayerManager.getInstance().communityId = ismsg.communityId;
               PlayerManager.getInstance().hasRights = ismsg.hasRights;
               PlayerManager.getInstance().nickname = ismsg.nickname;
               PlayerManager.getInstance().subscriptionEndDate = ismsg.subscriptionEndDate;
               PlayerManager.getInstance().subscriptionDurationElapsed = ismsg.subscriptionElapsedDuration;
               PlayerManager.getInstance().secretQuestion = ismsg.secretQuestion;
               PlayerManager.getInstance().accountCreation = ismsg.accountCreation;
               PlayerManager.getInstance().havenbagAvailableRooms = ismsg.havenbagAvailableRoom;
               StoreDataManager.getInstance().setData(Constants.DATASTORE_COMPUTER_OPTIONS,"lastNickname",ismsg.nickname);
               try
               {
                  _log.info("Timestamp subscription end date : " + PlayerManager.getInstance().subscriptionEndDate + " ( " + TimeManager.getInstance().formatDateIRL(PlayerManager.getInstance().subscriptionEndDate,true) + " " + TimeManager.getInstance().formatClock(PlayerManager.getInstance().subscriptionEndDate,false,true) + " )");
               }
               catch(e:Error)
               {
               }
               AuthorizedFrame(Kernel.getWorker().getFrame(AuthorizedFrame)).hasRights = ismsg.hasRights;
               updaterV2 = CommandLineArguments.getInstance().getArgument("updater_version") == "v2";
               if(PlayerManager.getInstance().subscriptionEndDate > 0 || PlayerManager.getInstance().hasRights)
               {
                  if(updaterV2)
                  {
                     PartManagerV2.getInstance().activateComponent("all");
                     PartManagerV2.getInstance().activateComponent("subscribed");
                  }
                  else
                  {
                     PartManager.getInstance().checkAndDownload("all");
                     PartManager.getInstance().checkAndDownload("subscribed");
                  }
               }
               if(PlayerManager.getInstance().hasRights)
               {
                  if(updaterV2)
                  {
                     PartManagerV2.getInstance().activateComponent("admin");
                  }
                  else
                  {
                     PartManager.getInstance().checkAndDownload("admin");
                  }
                  lengthModsTou = OptionManager.getOptionManager("dofus")["legalAgreementModsTou"];
                  newLengthModsTou = XmlConfig.getInstance().getEntry("config.lang.current") + "#" + I18n.getUiText("ui.legal.modstou").length;
                  files = new Array();
                  if(lengthModsTou != newLengthModsTou)
                  {
                     files.push("modstou");
                  }
                  if(files.length > 0)
                  {
                     PlayerManager.getInstance().allowAutoConnectCharacter = false;
                     KernelEventsManager.getInstance().processCallback(HookList.AgreementsRequired,files);
                  }
               }
               else if(updaterV2)
               {
                  if(PartManagerV2.getInstance().hasComponent("admin"))
                  {
                     PartManagerV2.getInstance().activateComponent("admin",false);
                  }
               }
               StoreUserDataManager.getInstance().gatherUserData();
               Kernel.getWorker().removeFrame(this);
               Kernel.getWorker().addFrame(new ChangeCharacterFrame());
               Kernel.getWorker().addFrame(new ServerSelectionFrame());
               KernelEventsManager.getInstance().processCallback(HookList.IdentificationSuccess,!!ismsg.login?ismsg.login:"");
               return true;
            case msg is IdentificationFailedForBadVersionMessage:
               iffbvmsg = IdentificationFailedForBadVersionMessage(msg);
               if(AirScanner.isStreamingVersion())
               {
                  Dofus.getInstance().strLoaderComplete();
               }
               PlayerManager.getInstance().destroy();
               ConnectionsHandler.closeConnection();
               KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailedForBadVersion,iffbvmsg.reason,iffbvmsg.requiredVersion);
               if(!this._dispatchModuleHook)
               {
                  this._dispatchModuleHook = true;
                  this.pushed();
               }
               return true;
            case msg is IdentificationFailedBannedMessage:
               ifbmsg = IdentificationFailedBannedMessage(msg);
               if(AirScanner.isStreamingVersion())
               {
                  Dofus.getInstance().strLoaderComplete();
               }
               PlayerManager.getInstance().destroy();
               ConnectionsHandler.closeConnection();
               KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailedWithDuration,ifbmsg.reason,ifbmsg.banEndDate);
               if(!this._dispatchModuleHook)
               {
                  this._dispatchModuleHook = true;
                  this.pushed();
               }
               return true;
            case msg is IdentificationFailedMessage:
               ifmsg = IdentificationFailedMessage(msg);
               if(AirScanner.isStreamingVersion())
               {
                  Dofus.getInstance().strLoaderComplete();
               }
               PlayerManager.getInstance().destroy();
               ConnectionsHandler.closeConnection();
               if(ifmsg.reason == IdentificationFailureReasonEnum.WRONG_CREDENTIALS && GuestModeManager.getInstance().isLoggingAsGuest)
               {
                  GuestModeManager.getInstance().clearStoredCredentials();
               }
               KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailed,ifmsg.reason);
               if(!this._dispatchModuleHook)
               {
                  this._dispatchModuleHook = true;
                  this.pushed();
               }
               return true;
            case msg is NicknameRegistrationMessage:
               nrmsg = NicknameRegistrationMessage(msg);
               if(AirScanner.isStreamingVersion())
               {
                  Dofus.getInstance().strLoaderComplete();
               }
               KernelEventsManager.getInstance().processCallback(HookList.NicknameRegistration);
               return true;
            case msg is NicknameRefusedMessage:
               nrfmsg = NicknameRefusedMessage(msg);
               if(AirScanner.isStreamingVersion())
               {
                  Dofus.getInstance().strLoaderComplete();
               }
               KernelEventsManager.getInstance().processCallback(HookList.NicknameRefused,nrfmsg.reason);
               return true;
            case msg is NicknameAcceptedMessage:
               namsg = NicknameAcceptedMessage(msg);
               KernelEventsManager.getInstance().processCallback(HookList.NicknameAccepted);
               return true;
            case msg is NicknameChoiceRequestAction:
               ncra = NicknameChoiceRequestAction(msg);
               ncrmsg = new NicknameChoiceRequestMessage();
               ncrmsg.initNicknameChoiceRequestMessage(ncra.nickname);
               ConnectionsHandler.getConnection().send(ncrmsg);
               return true;
            case msg is SubscribersGiftListRequestAction:
               if(CommandLineArguments.getInstance().hasArgument("functional-test"))
               {
                  return true;
               }
               sglra = SubscribersGiftListRequestAction(msg);
               lang = XmlConfig.getInstance().getEntry("config.lang.current");
               if(lang == "de" || lang == "en" || lang == "es" || lang == "pt" || lang == "fr" || lang == "uk" || lang == "ru")
               {
                  uri = new Uri(XmlConfig.getInstance().getEntry("config.subscribersGift") + "subscriberGifts_" + lang + ".xml");
               }
               else
               {
                  uri = new Uri(XmlConfig.getInstance().getEntry("config.subscribersGift") + "subscriberGifts_en.xml");
               }
               uri.loaderContext = this._contextLoader;
               this._loader.load(uri);
               return true;
            case msg is NewsLoginRequestAction:
               nlra = NewsLoginRequestAction(msg);
               lang2 = XmlConfig.getInstance().getEntry("config.lang.current");
               if(lang2 == "de" || lang2 == "en" || lang2 == "es" || lang2 == "pt" || lang2 == "fr" || lang2 == "uk" || lang2 == "it" || lang2 == "ru")
               {
                  uri2 = new Uri(XmlConfig.getInstance().getEntry("config.loginNews") + "news_" + lang2 + ".xml");
               }
               else
               {
                  uri2 = new Uri(XmlConfig.getInstance().getEntry("config.loginNews") + "news_en.xml");
               }
               uri2.loaderContext = this._contextLoader;
               this._loader.load(uri2);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         Berilia.getInstance().unloadUi("Login");
         if(AirScanner.isStreamingVersion())
         {
            Dofus.getInstance().strLoaderComplete();
         }
         this._loader.removeEventListener(ResourceErrorEvent.ERROR,this.onLoadError);
         this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onLoad);
         return true;
      }
      
      private function processInvokeArgs() : void
      {
         var _loc4_:Boolean = false;
         var _loc2_:LoginValidationWithTicketAction = null;
         this._autoConnect = false;
         if(CommandLineArguments.getInstance().hasArgument("ticket"))
         {
            if(!_loc4_)
            {
               §§push(CommandLineArguments.getInstance().getArgument("ticket"));
               if(!_loc4_)
               {
                  §§push(§§pop());
                  if(_loc3_)
                  {
                     §§push(_lastTicket);
                  }
               }
               if(§§pop() == _loc1_)
               {
                  return;
               }
               addr96:
               while(true)
               {
                  this._autoConnect = true;
                  if(_loc4_)
                  {
                     break;
                  }
                  _log.info("Use ticket from launch param\'s");
                  if(!_loc4_)
                  {
                  }
                  _lastTicket = _loc1_;
               }
            }
            while(true)
            {
               if(!_loc4_)
               {
               }
               _loc2_ = LoginValidationWithTicketAction.create(_loc1_,true);
               if(_loc3_)
               {
                  if(_loc3_)
                  {
                  }
                  this.process(_loc2_);
               }
               if(!_loc3_)
               {
                  §§goto(addr96);
               }
            }
         }
      }
      
      private function onLoad(param1:ResourceLoadedEvent) : void
      {
         var _loc5_:Boolean = true;
         var gift:* = undefined;
         if(_loc6_)
         {
            loop0:
            while(true)
            {
               var subGift:SubscriberGift = null;
               if(!_loc6_)
               {
               }
               addr44:
               while(true)
               {
                  var e:ResourceLoadedEvent = param1;
                  if(_loc6_)
                  {
                     addr52:
                     while(true)
                     {
                        var jsonArray:* = undefined;
                        if(_loc6_)
                        {
                           break loop0;
                        }
                        continue loop0;
                     }
                  }
                  break loop0;
               }
            }
            §§push(_loc2_);
            §§push(new Array());
            if(_loc5_)
            {
               §§push(§§pop());
            }
            var /*UnknownSlot*/:* = §§pop();
            if(_loc5_)
            {
            }
            try
            {
               var jdsonD:JSONDecoder = new JSONDecoder(e.resource,true);
               if(!_loc6_)
               {
                  jsonArray = jdsonD.getValue();
               }
            }
            catch(error:Error)
            {
               if(_loc5_)
               {
                  §§push(_log);
                  §§push("Cannot read Json ");
                  if(_loc5_)
                  {
                     §§push(§§pop() + e.uri);
                     if(_loc5_)
                     {
                        §§push("(");
                        if(_loc5_)
                        {
                           §§push(§§pop() + §§pop());
                           if(!_loc5_)
                           {
                           }
                           addr125:
                           §§push(")");
                        }
                        §§push(§§pop() + §§pop());
                     }
                     addr127:
                     §§pop().error(§§pop());
                  }
                  §§push(§§pop() + error.message);
                  if(!_loc6_)
                  {
                     §§goto(addr125);
                  }
                  §§goto(addr127);
               }
               return;
            }
            §§push(_loc2_);
            §§push(0);
            if(!_loc5_)
            {
               §§push(§§pop() * 57 * 13 * 57);
            }
            var /*UnknownSlot*/:* = §§pop();
            if(!_loc6_)
            {
               §§push(0);
               if(!_loc5_)
               {
                  §§push(-(-§§pop() + 1 + 1 + 51 + 1) - 1);
               }
               if(!_loc6_)
               {
                  if(_loc5_)
                  {
                     while(§§hasnext(jsonArray,_loc3_))
                     {
                        if(!_loc5_)
                        {
                           addr176:
                           while(true)
                           {
                              §§push(i);
                              if(!_loc6_)
                              {
                                 §§push(§§pop() + 1);
                              }
                              var i:int = §§pop();
                              if(!_loc6_)
                              {
                                 if(!_loc6_)
                                 {
                                 }
                                 addr207:
                                 subGift = new SubscriberGift(gift.article_name,gift.article_price,gift.article_pricecrossed,gift.article_visual,gift["new"],gift.promo,gift.redirect,gift.title,gift.url);
                                 if(_loc5_)
                                 {
                                    if(!_loc6_)
                                    {
                                    }
                                    subGiftList.push(subGift);
                                    break;
                                 }
                                 break;
                              }
                              break;
                           }
                           if(!_loc6_)
                           {
                           }
                           continue;
                        }
                        while(true)
                        {
                           gift = §§nextvalue(_loc3_,_loc4_);
                           if(!_loc6_)
                           {
                              if(_loc6_)
                              {
                                 §§goto(addr207);
                              }
                              else
                              {
                                 §§goto(addr176);
                              }
                           }
                           §§goto(addr256);
                        }
                     }
                  }
               }
               if(_loc6_)
               {
               }
               addr271:
               return;
            }
            KernelEventsManager.getInstance().processCallback(HookList.SubscribersList,subGiftList);
            §§goto(addr271);
         }
         while(true)
         {
            jdsonD = null;
            if(!_loc5_)
            {
               §§goto(addr44);
            }
            §§goto(addr52);
         }
      }
      
      private function onLoadError(param1:ResourceErrorEvent) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Boolean = false;
         if(!_loc3_)
         {
            §§push(_log);
            §§push("Cannot load xml ");
            if(_loc2_)
            {
               §§push(§§pop() + param1.uri);
               if(_loc2_)
               {
                  §§push("(");
                  if(!_loc3_)
                  {
                     §§push(§§pop() + §§pop());
                     if(!_loc2_)
                     {
                     }
                  }
                  addr43:
                  §§push(§§pop() + §§pop());
               }
               §§push(§§pop() + param1.errorMsg);
               if(!_loc3_)
               {
                  §§goto(addr43);
                  §§push(")");
               }
            }
            §§pop().error(§§pop());
         }
      }
   }
}
