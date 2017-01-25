package com.ankama.codegen.client.api.auth
{
   import flash.utils.Dictionary;
   
   public class ApiKeyAuth implements Authentication
   {
       
      
      private var location:String;
      
      private var paramName:String;
      
      private var apiKey:String;
      
      private var apiKeyPrefix:String;
      
      public function ApiKeyAuth(param1:String, param2:String)
      {
         super();
         this.location = param1;
         this.paramName = param2;
      }
      
      public function getLocation() : String
      {
         return this.location;
      }
      
      public function getParamName() : String
      {
         return this.paramName;
      }
      
      public function getApiKey() : String
      {
         return this.apiKey;
      }
      
      public function setApiKey(param1:String) : void
      {
         this.apiKey = param1;
      }
      
      public function getApiKeyPrefix() : String
      {
         return this.apiKeyPrefix;
      }
      
      public function setApiKeyPrefix(param1:String) : void
      {
         this.apiKeyPrefix = param1;
      }
      
      public function applyToParams(param1:Dictionary, param2:Dictionary) : void
      {
         var _loc3_:String = null;
         if(this.apiKeyPrefix != null)
         {
            _loc3_ = this.apiKeyPrefix + " " + this.apiKey;
         }
         else
         {
            _loc3_ = this.apiKey;
         }
         if(this.location == "query")
         {
            param1[this.paramName] = _loc3_;
         }
         else if(this.location == "header")
         {
            param2[this.paramName] = _loc3_;
         }
      }
   }
}
