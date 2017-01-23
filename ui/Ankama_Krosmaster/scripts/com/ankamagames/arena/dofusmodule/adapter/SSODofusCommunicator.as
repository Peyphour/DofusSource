package com.ankamagames.arena.dofusmodule.adapter
{
   import com.ankamagames.arena.dofusmodule.event.SSODofusEvent;
   import d2actions.KrosmasterTokenRequest;
   import d2api.SystemApi;
   import d2enums.KrosmasterErrorEnum;
   import d2hooks.KrosmasterAuthToken;
   import d2hooks.KrosmasterAuthTokenError;
   import flash.events.EventDispatcher;
   
   public class SSODofusCommunicator extends EventDispatcher implements ISSOCommunicator
   {
      
      public static const EVT_SSO_TOKEN_RECEIVED:String = "com.ankamagames.arena.dofusmodule.adapter.SSODofusCommunicator.EVT_SSO_TOKEN_RECEIVED";
       
      
      private var _sysApi:SystemApi;
      
      public function SSODofusCommunicator(param1:SystemApi)
      {
         super();
         this._sysApi = param1;
         this.init();
      }
      
      public function destroy() : void
      {
         this._sysApi = null;
      }
      
      public function ssoTokenRequest() : void
      {
         this._sysApi.sendAction(new KrosmasterTokenRequest());
      }
      
      public function onErrorReceived(param1:int) : void
      {
         trace("SSO COMMUNICATOR : error : " + param1);
         switch(param1)
         {
            case KrosmasterErrorEnum.KROSMASTER_ERROR_ICE_KO:
               trace("SSO COMMUNICATOR : error : ICE_KO");
               break;
            case KrosmasterErrorEnum.KROSMASTER_ERROR_ICE_REFUSED:
               trace("SSO COMMUNICATOR : error : ICE_REFUSED");
               break;
            default:
               trace("SSO COMMUNICATOR : error : UNDEFINED");
         }
      }
      
      public function onTokenReceived(param1:String) : void
      {
         trace("SSO COMMUNICATOR : received : " + param1);
         dispatchEvent(new SSODofusEvent(EVT_SSO_TOKEN_RECEIVED,this._sysApi.getNickname(),param1,1));
      }
      
      private function init() : void
      {
         this._sysApi.addHook(KrosmasterAuthToken,this.onTokenReceived);
         this._sysApi.addHook(KrosmasterAuthTokenError,this.onErrorReceived);
      }
   }
}
