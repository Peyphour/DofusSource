package com.ankama.codegen.client.model
{
   public class ShopReferenceTypeVirtualGift
   {
       
      
      public var image:String = null;
      
      public var description:String = null;
      
      public var name:String = null;
      
      public var id:Number = 0;
      
      public function ShopReferenceTypeVirtualGift()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeVirtualGift {\n");
         _loc1_.concat("  image: ").concat(this.image).concat("\n");
         _loc1_.concat("  description: ").concat(this.description).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
