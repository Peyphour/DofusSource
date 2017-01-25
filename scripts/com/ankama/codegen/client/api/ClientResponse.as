package com.ankama.codegen.client.api
{
   public class ClientResponse
   {
      
      private static const API_ERROR_MSG:String = "Api error response: ";
       
      
      public var isSuccess:Boolean;
      
      public var payload:Object;
      
      public var errorMessage:String;
      
      public var requestId:String;
      
      public function ClientResponse()
      {
         super();
      }
      
      private static function getFriendlyMessage(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = param1;
         if(param1 == null)
         {
            return null;
         }
         var _loc4_:Array = param1.match(/(?<=HTTP\/1.1 )[0-9][0-9][0-9]/);
         if(_loc4_ != null && _loc4_.length == 1)
         {
            _loc3_ = String(_loc4_[0]);
         }
         var _loc5_:Array = param1.match(/(?<=HTTP\/1.1 [0-9][0-9][0-9] )[^]*/);
         if(_loc5_ != null && _loc5_.length == 1)
         {
            _loc2_ = API_ERROR_MSG + String(_loc5_[0]);
         }
         return _loc2_;
      }
      
      public function Response(param1:Boolean, param2:Object = null, param3:String = null, param4:String = null) : void
      {
         this.isSuccess = param1;
         this.payload = param2;
         this.errorMessage = getFriendlyMessage(param3);
      }
      
      public function toString() : String
      {
         return "Response (requestId:" + this.requestId + "; isSuccess:" + this.isSuccess + "; errorMessage:" + this.errorMessage + "; payload:" + this.payload + ")";
      }
   }
}
