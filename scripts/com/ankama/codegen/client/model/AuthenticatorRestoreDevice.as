package com.ankama.codegen.client.model
{
   public class AuthenticatorRestoreDevice
   {
       
      
      public var device_id:Number = 0;
      
      public var accounts:Array;
      
      public var device_restore_code:String = null;
      
      public function AuthenticatorRestoreDevice()
      {
         this.accounts = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class AuthenticatorRestoreDevice {\n");
         _loc1_.concat("  device_id: ").concat(this.device_id).concat("\n");
         _loc1_.concat("  accounts: ").concat(this.accounts).concat("\n");
         _loc1_.concat("  device_restore_code: ").concat(this.device_restore_code).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
