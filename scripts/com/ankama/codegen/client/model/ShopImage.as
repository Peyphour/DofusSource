package com.ankama.codegen.client.model
{
   public class ShopImage
   {
       
      
      public var width:Number = 0;
      
      public var height:Number = 0;
      
      public var url:String = null;
      
      public function ShopImage()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopImage {\n");
         _loc1_.concat("  width: ").concat(this.width).concat("\n");
         _loc1_.concat("  height: ").concat(this.height).concat("\n");
         _loc1_.concat("  url: ").concat(this.url).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
