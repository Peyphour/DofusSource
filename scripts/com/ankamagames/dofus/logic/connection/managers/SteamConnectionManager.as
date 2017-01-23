package com.ankamagames.dofus.logic.connection.managers
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.updaterv2.IUpdaterMessageHandler;
   import com.ankamagames.dofus.kernel.updaterv2.UpdaterApi;
   import com.ankamagames.dofus.kernel.updaterv2.messages.IUpdaterInputMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.UpdaterAuthenticationErrorEnum;
   import com.ankamagames.dofus.kernel.updaterv2.messages.impl.ApiTokenMessage;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationWithTicketAction;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import flash.utils.getQualifiedClassName;
   
   public class SteamConnectionManager implements IUpdaterMessageHandler
   {
      
      private static const WEB_GAME_ID:int = 1;
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(SteamConnectionManager));
      
      private static const instance:SteamConnectionManager = new SteamConnectionManager();
       
      
      private var _updaterIsConnected:Boolean = false;
      
      private var _api:UpdaterApi;
      
      public function SteamConnectionManager()
      {
         super();
         if(!this._api)
         {
            this._api = new UpdaterApi(this);
         }
      }
      
      public static function getInstance() : SteamConnectionManager
      {
         return instance;
      }
      
      public function handleConnectionOpened() : void
      {
         this._updaterIsConnected = true;
      }
      
      public function handleMessage(param1:IUpdaterInputMessage) : void
      {
         var _loc2_:ApiTokenMessage = null;
         var _loc3_:int = 0;
         var _loc4_:LoginValidationWithTicketAction = null;
         _log.info("From updater : " + getQualifiedClassName(param1));
         switch(true)
         {
            case param1 is ApiTokenMessage:
               _loc2_ = param1 as ApiTokenMessage;
               if(_loc2_.error != UpdaterAuthenticationErrorEnum.NO_ERROR)
               {
                  this.handleError(_loc2_.error);
               }
               else
               {
                  _loc3_ = OptionManager.getOptionManager("dofus")["autoConnectType"];
                  if(_loc3_ == 2)
                  {
                     PlayerManager.getInstance().allowAutoConnectCharacter = true;
                     PlayerManager.getInstance().autoConnectOfASpecificCharacterId = -1;
                  }
                  _loc4_ = LoginValidationWithTicketAction.create(_loc2_.getToken(),_loc3_ != 0,0);
                  Kernel.getWorker().process(_loc4_);
               }
         }
      }
      
      public function handleConnectionClosed() : void
      {
         this._updaterIsConnected = false;
      }
      
      public function requestApiToken(param1:String) : void
      {
         this.api.getIdentificationToken("",WEB_GAME_ID);
         KernelEventsManager.getInstance().processCallback(HookList.ConnectionTimerStart);
      }
      
      public function get api() : UpdaterApi
      {
         return this._api;
      }
      
      private function handleError(param1:int) : void
      {
         switch(param1)
         {
            case UpdaterAuthenticationErrorEnum.AUTHENTICATION_FAILED:
               _log.error("Echec de l\'authentification");
               break;
            case UpdaterAuthenticationErrorEnum.AUTHENTICATION_DECLINED:
               _log.error("Authentification Décliné");
               break;
            case UpdaterAuthenticationErrorEnum.AUTHENTICATION_REQUIRED:
               _log.error("Vous devez ètres authentifié pour vous authentifié Oo");
               break;
            case UpdaterAuthenticationErrorEnum.ACCOUNT_BANNED:
               _log.error("Votre compte à été banni");
               break;
            case UpdaterAuthenticationErrorEnum.ACCOUNT_LOCKED:
               _log.error("Votre compte à été vérouillé");
               break;
            case UpdaterAuthenticationErrorEnum.ACCOUNT_DELETED:
               _log.error("Ce compte à été supprimé");
               break;
            case UpdaterAuthenticationErrorEnum.IP_BLACKLISTED:
               _log.error("Votre Ip à été bannis");
               break;
            case UpdaterAuthenticationErrorEnum.SERVER_UNREACHABLE:
               _log.error("Impossilve de joindre les serveur d\'authentification");
               break;
            default:
               _log.error("Le service d\'authentification a rencontré un erreur inatendu");
         }
      }
   }
}
