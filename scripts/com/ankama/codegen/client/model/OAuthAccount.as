package com.ankama.codegen.client.model
{
   public class OAuthAccount
   {
       
      
      public var provider_id:Number = 0;
      
      public var account_id:Number = 0;
      
      public var code:String = null;
      
      public var added_date:Date = null;
      
      public var added_ip:Number = 0;
      
      public var deleted_date:Date = null;
      
      public function OAuthAccount()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class OAuthAccount {\n");
         _loc1_.concat("  provider_id: ").concat(this.provider_id).concat("\n");
         _loc1_.concat("  account_id: ").concat(this.account_id).concat("\n");
         _loc1_.concat("  code: ").concat(this.code).concat("\n");
         _loc1_.concat("  added_date: ").concat(this.added_date).concat("\n");
         _loc1_.concat("  added_ip: ").concat(this.added_ip).concat("\n");
         _loc1_.concat("  deleted_date: ").concat(this.deleted_date).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
