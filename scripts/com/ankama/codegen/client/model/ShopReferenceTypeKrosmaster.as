package com.ankama.codegen.client.model
{
   public class ShopReferenceTypeKrosmaster
   {
       
      
      public var pedestal:Number = 0;
      
      public var id:Number = 0;
      
      public function ShopReferenceTypeKrosmaster()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeKrosmaster {\n");
         _loc1_.concat("  pedestal: ").concat(this.pedestal).concat("\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
