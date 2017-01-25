package com.ankama.codegen.client.model
{
   public class ShopReferenceTypeMusic
   {
       
      
      public var preview_path:String = null;
      
      public var complete_path:String = null;
      
      public function ShopReferenceTypeMusic()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeMusic {\n");
         _loc1_.concat("  preview_path: ").concat(this.preview_path).concat("\n");
         _loc1_.concat("  complete_path: ").concat(this.complete_path).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
