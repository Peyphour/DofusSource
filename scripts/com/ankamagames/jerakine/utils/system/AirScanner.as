package com.ankamagames.jerakine.utils.system
{
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   
   public class AirScanner
   {
      
      private static var _initialized:Boolean = false;
      
      private static var _hasAir:Boolean;
      
      private static var _isStreaming:Boolean;
       
      
      public function AirScanner()
      {
         super();
      }
      
      public static function init(param1:Boolean = false) : void
      {
         if(!_initialized)
         {
            initialize();
            _isStreaming = param1;
         }
      }
      
      private static function initialize() : void
      {
         _initialized = true;
         var _loc1_:LoaderContext = new LoaderContext();
         if(_loc1_.hasOwnProperty("allowLoadBytesCodeExecution"))
         {
            _hasAir = true;
         }
         else
         {
            _hasAir = false;
         }
         var _loc2_:String = Capabilities.version.substr(0,3);
         if(_loc2_ != "LNX" && _loc2_ != "WIN" && _loc2_ != "MAC")
         {
            _hasAir = false;
         }
      }
      
      public static function hasAir() : Boolean
      {
         if(!_initialized)
         {
            initialize();
            _isStreaming = false;
         }
         return _hasAir;
      }
      
      public static function isStreamingVersion() : Boolean
      {
         if(!_initialized)
         {
            initialize();
            _isStreaming = false;
         }
         return _isStreaming;
      }
      
      public static function allowByteCodeExecution(param1:LoaderContext, param2:Boolean) : void
      {
         if(param1.hasOwnProperty("allowCodeImport"))
         {
            param1["allowCodeImport"] = param2;
         }
         else
         {
            param1["allowLoadBytesCodeExecution"] = param2;
         }
      }
   }
}
