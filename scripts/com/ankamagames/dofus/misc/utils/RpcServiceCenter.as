package com.ankamagames.dofus.misc.utils
{
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.external.ExternalInterface;
   import flash.utils.getQualifiedClassName;
   
   public class RpcServiceCenter
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RpcServiceCenter));
      
      private static const WEB_API_BASE_URL:String = "http://api.ankama.";
      
      private static const AUTHORIZED_DOMAIN_EXTENSION:Array = ["com","lan","tst"];
      
      private static var _self:RpcServiceCenter;
      
      private static var _rpcServices:Vector.<RpcServiceManager>;
       
      
      private var _mainRpcServiceManager:RpcServiceManager;
      
      private var _currentApiDomain:String;
      
      private var _currentApiDomainExtension:String;
      
      public function RpcServiceCenter()
      {
         super();
      }
      
      public static function getInstance() : RpcServiceCenter
      {
         if(!_self)
         {
            _self = new RpcServiceCenter();
         }
         return _self;
      }
      
      public function makeRpcCall(param1:String, param2:String, param3:String, param4:String, param5:*, param6:Function, param7:Boolean = true, param8:Boolean = true, param9:Boolean = true) : void
      {
         var _loc10_:RpcServiceManager = null;
         if(param7)
         {
            _log.debug("makeRpcCall on a new service");
            _loc10_ = this.getRpcService(param1,param2,param3);
         }
         else
         {
            _log.debug("makeRpcCall on the main service");
            if(!this._mainRpcServiceManager)
            {
               this._mainRpcServiceManager = new RpcServiceManager(param1,param2,param3);
            }
            else
            {
               this._mainRpcServiceManager.type = param2;
               this._mainRpcServiceManager.service = param1;
            }
            _loc10_ = this._mainRpcServiceManager;
         }
         _loc10_.callMethod(param4,param5,param6,param8,param9);
      }
      
      public function get apiDomain() : String
      {
         if(!this._currentApiDomain)
         {
            this._currentApiDomain = WEB_API_BASE_URL + this.apiDomainExtension;
         }
         return this._currentApiDomain;
      }
      
      public function get apiDomainExtension() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Array = null;
         if(!this._currentApiDomainExtension)
         {
            switch(BuildInfos.BUILD_TYPE)
            {
               case BuildTypeEnum.BETA:
               case BuildTypeEnum.RELEASE:
                  this._currentApiDomainExtension = "com";
                  break;
               case BuildTypeEnum.TESTING:
                  this._currentApiDomainExtension = "lan";
                  break;
               default:
                  this._currentApiDomainExtension = "tst";
            }
            if(AirScanner.isStreamingVersion() && BuildInfos.BUILD_TYPE > BuildTypeEnum.TESTING)
            {
               if(ExternalInterface.available)
               {
                  _loc1_ = "";
                  _loc2_ = ExternalInterface.call("eval","location.hostname") as String;
                  if(_loc2_)
                  {
                     _loc3_ = _loc2_.split(".");
                     if(_loc3_.length)
                     {
                        _loc1_ = _loc3_.pop();
                     }
                     if(AUTHORIZED_DOMAIN_EXTENSION.indexOf(_loc1_) != -1)
                     {
                        this._currentApiDomainExtension = _loc1_;
                     }
                  }
               }
            }
         }
         return this._currentApiDomainExtension;
      }
      
      public function get secureApiDomain() : String
      {
         return this.apiDomain.replace("http:","https:");
      }
      
      private function getRpcService(param1:String, param2:String, param3:String) : RpcServiceManager
      {
         var _loc4_:RpcServiceManager = null;
         var _loc5_:RpcServiceManager = null;
         if(!_rpcServices)
         {
            _rpcServices = new Vector.<RpcServiceManager>();
         }
         for each(_loc4_ in _rpcServices)
         {
            if(!_loc4_.busy)
            {
               _loc4_.service = param1;
               _loc4_.type = param2;
               return _loc4_;
            }
         }
         _loc5_ = new RpcServiceManager(param1,param2,param3);
         _rpcServices.push(_loc5_);
         return _loc5_;
      }
   }
}
