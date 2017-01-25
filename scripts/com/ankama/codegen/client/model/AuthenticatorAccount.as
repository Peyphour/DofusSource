package com.ankama.codegen.client.model
{
   public class AuthenticatorAccount
   {
       
      
      public var otp_id:Number = 0;
      
      public var otp_login:String = null;
      
      public var otp_nickname:String = null;
      
      public var otp_public_key:String = null;
      
      public var otp_login_enabled:Number = 0;
      
      public function AuthenticatorAccount()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class AuthenticatorAccount {\n");
         _loc1_.concat("  otp_id: ").concat(this.otp_id).concat("\n");
         _loc1_.concat("  otp_login: ").concat(this.otp_login).concat("\n");
         _loc1_.concat("  otp_nickname: ").concat(this.otp_nickname).concat("\n");
         _loc1_.concat("  otp_public_key: ").concat(this.otp_public_key).concat("\n");
         _loc1_.concat("  otp_login_enabled: ").concat(this.otp_login_enabled).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
