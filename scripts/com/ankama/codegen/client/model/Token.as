package com.ankama.codegen.client.model
{
   public class Token
   {
       
      
      public var token:String = null;
      
      public function Token()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class Token {\n");
         _loc1_.concat("  token: ").concat(this.token).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
