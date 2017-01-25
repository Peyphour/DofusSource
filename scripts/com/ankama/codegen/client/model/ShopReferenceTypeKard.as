package com.ankama.codegen.client.model
{
   public class ShopReferenceTypeKard
   {
       
      
      public var id:Number = 0;
      
      public var restype:String = null;
      
      public var name:String = null;
      
      public var description:String = null;
      
      public var image:String = null;
      
      public function ShopReferenceTypeKard()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeKard {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  description: ").concat(this.description).concat("\n");
         _loc1_.concat("  image: ").concat(this.image).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
