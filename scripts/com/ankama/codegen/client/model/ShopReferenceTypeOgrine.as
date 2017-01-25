package com.ankama.codegen.client.model
{
   public class ShopReferenceTypeOgrine
   {
       
      
      public var forbiddens:Array;
      
      public function ShopReferenceTypeOgrine()
      {
         this.forbiddens = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeOgrine {\n");
         _loc1_.concat("  forbiddens: ").concat(this.forbiddens).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
