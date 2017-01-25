package com.ankama.codegen.client.api
{
   public final class JsonUtil
   {
       
      
      public function JsonUtil()
      {
         super();
      }
      
      public static function toJson(param1:Object) : String
      {
         return by.blooddy.crypto.serialization.JSON.encode(param1);
      }
      
      public static function fromJson(param1:String) : Object
      {
         return by.blooddy.crypto.serialization.JSON.decode(param1);
      }
   }
}
