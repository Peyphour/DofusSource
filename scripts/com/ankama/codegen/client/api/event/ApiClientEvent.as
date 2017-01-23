package com.ankama.codegen.client.api.event
{
   import flash.events.Event;
   
   public class ApiClientEvent extends Event
   {
      
      public static const API_CALL_SUCCESS:String = "api_call_success";
      
      public static const API_CALL_ERROR:String = "api_call_error";
      
      public static const API_CALL_RESULT:String = "api_call_result";
       
      
      private var _result:Object;
      
      private var _errorMsg:String;
      
      public function ApiClientEvent(param1:String, param2:Object = null, param3:String = "")
      {
         super(param1,false,false);
         this._result = param2;
         this._errorMsg = param3;
      }
      
      public function get result() : Object
      {
         return this._result;
      }
      
      public function get errorMsg() : String
      {
         return this._errorMsg;
      }
   }
}
