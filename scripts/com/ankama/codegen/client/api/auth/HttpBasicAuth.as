package com.ankama.codegen.client.api.auth
{
   import flash.utils.Dictionary;
   import mx.utils.Base64Encoder;
   
   public class HttpBasicAuth implements Authentication
   {
       
      
      private var username:String;
      
      private var password:String;
      
      public function HttpBasicAuth()
      {
         super();
      }
      
      public function getUsername() : String
      {
         return this.username;
      }
      
      public function setUsername(param1:String) : void
      {
         this.username = param1;
      }
      
      public function getPassword() : String
      {
         return this.password;
      }
      
      public function setPassword(param1:String) : void
      {
         this.password = param1;
      }
      
      public function applyToParams(param1:Dictionary, param2:Dictionary) : void
      {
         var b64:Base64Encoder = null;
         var queryParams:Dictionary = param1;
         var headerParams:Dictionary = param2;
         var str:String = (this.username == null?"":this.username) + ":" + (this.password == null?"":this.password);
         try
         {
            b64 = new Base64Encoder();
            b64.encodeUTFBytes(str);
            headerParams["Authorization"] = "Basic " + b64.toString();
            return;
         }
         catch(e:Error)
         {
            throw e;
         }
      }
   }
}
