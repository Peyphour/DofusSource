package com.ankama.codegen.client.model
{
   public class OAuthProvider
   {
       
      
      public var id:Number = 0;
      
      public var name:String = null;
      
      public var clientid:String = null;
      
      public var secret:String = null;
      
      public var redirect:String = null;
      
      public var access:Array;
      
      public function OAuthProvider()
      {
         this.access = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class OAuthProvider {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  clientid: ").concat(this.clientid).concat("\n");
         _loc1_.concat("  secret: ").concat(this.secret).concat("\n");
         _loc1_.concat("  redirect: ").concat(this.redirect).concat("\n");
         _loc1_.concat("  access: ").concat(this.access).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
