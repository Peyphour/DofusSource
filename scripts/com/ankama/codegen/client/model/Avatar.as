package com.ankama.codegen.client.model
{
   public class Avatar
   {
       
      
      public var url:String = null;
      
      public function Avatar()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class Avatar {\n");
         _loc1_.concat("  url: ").concat(this.url).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
