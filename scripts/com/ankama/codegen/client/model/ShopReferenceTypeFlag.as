package com.ankama.codegen.client.model
{
   public class ShopReferenceTypeFlag
   {
       
      
      public var flag_id:Number = 0;
      
      public function ShopReferenceTypeFlag()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeFlag {\n");
         _loc1_.concat("  flag_id: ").concat(this.flag_id).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
