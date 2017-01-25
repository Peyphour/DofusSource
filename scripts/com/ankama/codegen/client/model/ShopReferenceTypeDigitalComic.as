package com.ankama.codegen.client.model
{
   public class ShopReferenceTypeDigitalComic
   {
       
      
      public var viewer_id:Number = 0;
      
      public function ShopReferenceTypeDigitalComic()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeDigitalComic {\n");
         _loc1_.concat("  viewer_id: ").concat(this.viewer_id).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
