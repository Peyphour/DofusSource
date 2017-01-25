package com.ankama.codegen.client.model
{
   public class ShopReferenceTypePremium
   {
       
      
      public var status:String = null;
      
      public function ShopReferenceTypePremium()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypePremium {\n");
         _loc1_.concat("  status: ").concat(this.status).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
