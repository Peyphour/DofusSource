package com.ankamagames.dofus.misc.utils
{
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.misc.utils.events.ApiKeyReadyEvent;
   import com.ankamagames.dofus.network.messages.web.haapi.HaapiApiKeyRequestMessage;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class HaapiKeyManager extends EventDispatcher
   {
      
      private static var _instance:HaapiKeyManager;
      
      public static const GAME_ID:Number = 1;
       
      
      private var _apiKeys:Dictionary;
      
      public function HaapiKeyManager()
      {
         super();
         this._apiKeys = new Dictionary();
      }
      
      public static function getInstance() : HaapiKeyManager
      {
         if(!_instance)
         {
            _instance = new HaapiKeyManager();
         }
         return _instance;
      }
      
      public function getApiKey(param1:uint) : String
      {
         return this._apiKeys[param1];
      }
      
      public function askApiKey(param1:uint) : void
      {
         var _loc2_:HaapiApiKeyRequestMessage = new HaapiApiKeyRequestMessage();
         _loc2_.initHaapiApiKeyRequestMessage(param1);
         ConnectionsHandler.getConnection().send(_loc2_);
      }
      
      public function saveApiKey(param1:uint, param2:String) : void
      {
         this._apiKeys[param1] = param2;
         dispatchEvent(new ApiKeyReadyEvent(param1,param2));
      }
   }
}
