package com.ankama.codegen.client.model
{
   public class OAuthKey
   {
       
      
      public var access_token:String = null;
      
      public var refresh_token:String = null;
      
      public var expires_in:Number = 0;
      
      public var token_type:String = null;
      
      public function OAuthKey()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class OAuthKey {\n");
         _loc1_.concat("  access_token: ").concat(this.access_token).concat("\n");
         _loc1_.concat("  refresh_token: ").concat(this.refresh_token).concat("\n");
         _loc1_.concat("  expires_in: ").concat(this.expires_in).concat("\n");
         _loc1_.concat("  token_type: ").concat(this.token_type).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
