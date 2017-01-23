package com.ankamagames.dofus.misc.utils
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.pools.PoolableURLLoader;
   import com.ankamagames.jerakine.pools.PoolsManager;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class HaapiDebugManager
   {
      
      public static const HARDWARE_DATA_TYPE:String = "hardware";
      
      public static const UI_DATA_TYPE:String = "ui";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(HaapiDebugManager));
      
      private static var _singleton:HaapiDebugManager;
      
      private static var _apiUrl:String;
       
      
      private var _loaders:Dictionary;
      
      public function HaapiDebugManager()
      {
         super();
         var _loc1_:String = RpcServiceCenter.getInstance().apiDomainExtension;
         _apiUrl = "https://haapi.ankama." + _loc1_ + "/json/Debug/v1/Log/Log";
         this._loaders = new Dictionary();
      }
      
      public static function getInstance() : HaapiDebugManager
      {
         if(!_singleton)
         {
            _singleton = new HaapiDebugManager();
         }
         return _singleton;
      }
      
      public function submitData(param1:String, param2:String, param3:Function = null, param4:Function = null) : void
      {
         var completeFct:Function = null;
         var errorFct:Function = null;
         var type:String = param1;
         var data:String = param2;
         var callbackSuccess:Function = param3;
         var callbackError:Function = param4;
         if(!type || !data)
         {
            _log.error("Can\'t send empty data or undefined type!");
            return;
         }
         var urlVars:URLVariables = new URLVariables();
         urlVars.game_id = HaapiKeyManager.GAME_ID;
         urlVars.message = data;
         urlVars.type = type;
         var request:URLRequest = new URLRequest(_apiUrl);
         request.data = urlVars;
         request.method = URLRequestMethod.POST;
         var loader:PoolableURLLoader = PoolsManager.getInstance().getURLLoaderPool().checkOut() as PoolableURLLoader;
         completeFct = function(param1:Event):void
         {
            onApiSuccess(param1,callbackSuccess,completeFct,errorFct);
         };
         errorFct = function(param1:ErrorEvent):void
         {
            onApiError(param1,callbackError,completeFct,errorFct);
         };
         loader.addEventListener(Event.COMPLETE,completeFct);
         loader.addEventListener(IOErrorEvent.IO_ERROR,errorFct);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorFct);
         loader.load(request);
      }
      
      private function onApiSuccess(param1:Event, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:PoolableURLLoader = param1.target as PoolableURLLoader;
         _loc5_.removeEventListener(Event.COMPLETE,param3);
         _loc5_.removeEventListener(IOErrorEvent.IO_ERROR,param4);
         _loc5_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,param4);
         PoolsManager.getInstance().getURLLoaderPool().checkIn(_loc5_);
         _log.debug("Data successfully submitted");
         if(param2 != null)
         {
            param2();
         }
      }
      
      private function onApiError(param1:ErrorEvent, param2:Function, param3:Function, param4:Function) : void
      {
         var _loc5_:PoolableURLLoader = param1.target as PoolableURLLoader;
         _loc5_.removeEventListener(Event.COMPLETE,param3);
         _loc5_.removeEventListener(IOErrorEvent.IO_ERROR,param4);
         _loc5_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,param4);
         PoolsManager.getInstance().getURLLoaderPool().checkIn(_loc5_);
         _log.debug("Failed to submit data, error:\n" + param1.text);
         if(param2 != null)
         {
            param2();
         }
      }
   }
}
