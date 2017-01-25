package com.ankama.codegen.client.model
{
   public class AuthenticatorDevice
   {
       
      
      public var device_id:Number = 0;
      
      public var device_restore_code:String = null;
      
      public var device_uid:String = null;
      
      public var device_type:String = null;
      
      public var device_name:String = null;
      
      public var device_version:String = null;
      
      public var device_deleted_date:Number = 0;
      
      public var device_deleted_deviceid:Number = 0;
      
      public function AuthenticatorDevice()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class AuthenticatorDevice {\n");
         _loc1_.concat("  device_id: ").concat(this.device_id).concat("\n");
         _loc1_.concat("  device_restore_code: ").concat(this.device_restore_code).concat("\n");
         _loc1_.concat("  device_uid: ").concat(this.device_uid).concat("\n");
         _loc1_.concat("  device_type: ").concat(this.device_type).concat("\n");
         _loc1_.concat("  device_name: ").concat(this.device_name).concat("\n");
         _loc1_.concat("  device_version: ").concat(this.device_version).concat("\n");
         _loc1_.concat("  device_deleted_date: ").concat(this.device_deleted_date).concat("\n");
         _loc1_.concat("  device_deleted_deviceid: ").concat(this.device_deleted_deviceid).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
