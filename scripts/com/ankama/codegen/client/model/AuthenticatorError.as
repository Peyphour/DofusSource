package com.ankama.codegen.client.model
{
   public class AuthenticatorError
   {
      
      public static const ReasonEnum_DEVICE_DELETED:String = "DEVICE_DELETED";
      
      public static const ReasonEnum_NOTEXISTS:String = "NOTEXISTS";
       
      
      public var reason:String = null;
      
      public var message:String = null;
      
      public function AuthenticatorError()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class AuthenticatorError {\n");
         _loc1_.concat("  reason: ").concat(this.reason).concat("\n");
         _loc1_.concat("  message: ").concat(this.message).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
