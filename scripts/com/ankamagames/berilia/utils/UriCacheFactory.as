package com.ankamagames.berilia.utils
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.types.Uri;
   import flash.utils.getQualifiedClassName;
   
   public class UriCacheFactory
   {
      
      private static var _log:Logger = Log.getLogger(getQualifiedClassName(UriCacheFactory));
      
      private static var _aCache:Array = new Array();
       
      
      public function UriCacheFactory()
      {
         super();
      }
      
      public static function init(param1:String, param2:ICache) : ICache
      {
         _aCache[param1] = param2;
         return param2;
      }
      
      public static function getCacheFromUri(param1:Uri) : ICache
      {
         var _loc3_:* = null;
         var _loc2_:String = param1.normalizedUri;
         for(_loc3_ in _aCache)
         {
            if(_loc2_.indexOf(_loc3_) != -1)
            {
               return _aCache[_loc3_];
            }
         }
         return null;
      }
      
      public static function get caches() : Array
      {
         return _aCache;
      }
   }
}
