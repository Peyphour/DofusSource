package com.ankamagames.berilia.api
{
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import flash.system.ApplicationDomain;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class ApiBinder
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ApiBinder));
      
      private static var _apiClass:Array = new Array();
      
      private static var _apiInstance:Array = new Array();
      
      private static var _apiData:Array = new Array();
      
      private static var _isComplexFctCache:Dictionary = new Dictionary();
       
      
      public function ApiBinder()
      {
         super();
      }
      
      public static function addApi(param1:String, param2:Class) : void
      {
         _apiClass[getQualifiedClassName(param2)] = param2;
      }
      
      public static function removeApi(param1:Class) : void
      {
         delete _apiClass[getQualifiedClassName(param1)];
      }
      
      public static function reset() : void
      {
         _apiInstance = [];
         _apiData = [];
      }
      
      public static function addApiData(param1:String, param2:*) : void
      {
         _apiData[param1] = param2;
      }
      
      public static function getApiData(param1:String) : *
      {
         return _apiData[param1];
      }
      
      public static function removeApiData(param1:String) : void
      {
         _apiData[param1] = null;
      }
      
      public static function initApi(param1:Object, param2:UiModule, param3:ApplicationDomain = null) : String
      {
         var _loc4_:Object = null;
         var _loc6_:XML = null;
         var _loc7_:* = undefined;
         var _loc8_:String = null;
         addApiData("module",param2);
         var _loc5_:XML = DescribeTypeCache.typeDescription(param1);
         for each(_loc6_ in _loc5_..variable)
         {
            if(_apiClass[_loc6_.@type.toString()])
            {
               _loc4_ = getApiInstance(_loc6_.@type.toString());
               param2.apiList.push(_loc4_);
               param1[_loc6_.@name] = _loc4_;
            }
            else
            {
               for each(_loc7_ in _loc6_.metadata)
               {
                  if(_loc7_.@name == "Module")
                  {
                     if(_loc7_.arg.@key == "name")
                     {
                        _loc8_ = _loc7_.arg.@value;
                        if(!UiModuleManager.getInstance().getModules()[_loc8_])
                        {
                           throw new ApiError("Module " + _loc8_ + " does not exist (in " + param2.id + ")");
                        }
                        if(param2.trusted || _loc8_ == "Ankama_Common" || _loc8_ == "Ankama_ContextMenu" || !UiModuleManager.getInstance().getModules()[_loc8_].trusted)
                        {
                           param1[_loc6_.@name] = new ModuleReference(UiModule(UiModuleManager.getInstance().getModules()[_loc8_]).mainClass,SecureCenter.ACCESS_KEY);
                           continue;
                        }
                        throw new ApiError(param2.id + ", untrusted module cannot acces to trusted modules " + _loc8_);
                     }
                     throw new ApiError(param2.id + " module, unknow property \"" + _loc7_.arg.@key + "\" in Api tag");
                  }
               }
            }
         }
         return null;
      }
      
      private static function getApiInstance(param1:String) : Object
      {
         var _loc2_:XML = null;
         var _loc3_:Boolean = false;
         var _loc4_:XML = null;
         var _loc5_:Object = null;
         var _loc6_:XML = null;
         var _loc7_:* = undefined;
         if(_apiInstance[param1] && _apiInstance[param1])
         {
            return _apiInstance[param1];
         }
         if(_apiClass[param1])
         {
            _loc2_ = DescribeTypeCache.typeDescription(_apiClass[param1]);
            _loc3_ = false;
            for each(_loc4_ in _loc2_..metadata)
            {
               if(_loc4_.@name == "InstanciedApi")
               {
                  _loc3_ = true;
                  break;
               }
            }
            _loc5_ = new (_apiClass[param1] as Class)();
            for each(_loc6_ in _loc2_..accessor)
            {
               for each(_loc7_ in _loc6_.metadata)
               {
                  if(_loc7_.@name == "ApiData")
                  {
                     _loc5_[_loc6_.@name] = _apiData[_loc7_.arg.@value];
                     break;
                  }
               }
            }
            if(!_loc3_)
            {
               _apiInstance[param1] = _loc5_;
            }
            return _loc5_;
         }
         _log.error("Api [" + param1 + "] is not avaible");
         return null;
      }
      
      private static function isComplexFct(param1:XML) : Boolean
      {
         var _loc4_:String = null;
         var _loc2_:String = param1.@declaredBy + "_" + param1.@name;
         if(_isComplexFctCache[_loc2_] != null)
         {
            return _isComplexFctCache[_loc2_];
         }
         var _loc3_:Array = ["int","uint","Number","Boolean","String","void"];
         if(_loc3_.indexOf(param1.@returnType.toString()) == -1)
         {
            _isComplexFctCache[_loc2_] = false;
            return false;
         }
         for each(_loc4_ in param1..parameter..@type)
         {
            if(_loc3_.indexOf(_loc4_) == -1)
            {
               _isComplexFctCache[_loc2_] = false;
               return false;
            }
         }
         _isComplexFctCache[_loc2_] = true;
         return true;
      }
      
      private static function createDepreciatedMethod(param1:Function, param2:String, param3:String) : Function
      {
         var fct:Function = param1;
         var fctName:String = param2;
         var help:String = param3;
         return function(... rest):*
         {
            var _loc2_:* = new Error();
            if(_loc2_.getStackTrace())
            {
               _log.fatal(fctName + " is a deprecated api function, called at " + _loc2_.getStackTrace().split("at ")[2] + (!!help.length?help + "\n":""));
            }
            else
            {
               _log.fatal(fctName + " is a deprecated api function. No stack trace available");
            }
            return CallWithParameters.callR(fct,rest);
         };
      }
   }
}
