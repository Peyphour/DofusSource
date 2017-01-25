package com.ankama.codegen.client.api
{
   import flash.utils.Dictionary;
   
   public class ApiError extends Error
   {
       
      
      private var code:int = 0;
      
      private var responseHeaders:Dictionary = null;
      
      private var responseBody:String = "";
      
      public function ApiError(param1:int = 0, param2:String = "", param3:Dictionary = null, param4:String = "")
      {
         super();
         this.code = param1;
         this.message = param2;
         this.responseHeaders = param3;
         this.responseBody = param4;
      }
      
      public function getCode() : int
      {
         return this.code;
      }
      
      public function getMessage() : String
      {
         return message;
      }
      
      public function getResponseHeaders() : Dictionary
      {
         return this.responseHeaders;
      }
      
      public function getResponseBody() : String
      {
         return this.responseBody;
      }
      
      public function toString() : String
      {
         return "ApiError{" + this.responseBody + "\'" + "}";
      }
   }
}
