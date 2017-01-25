package com.ankama.codegen.client.model
{
   public class ShopMedia
   {
       
      
      public var id:Number = 0;
      
      public var key:String = null;
      
      public var lang:String = null;
      
      public var restype:String = null;
      
      public var param:String = null;
      
      public var order:Number = 0;
      
      public var url:String = null;
      
      public function ShopMedia()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopMedia {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  key: ").concat(this.key).concat("\n");
         _loc1_.concat("  lang: ").concat(this.lang).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  param: ").concat(this.param).concat("\n");
         _loc1_.concat("  order: ").concat(this.order).concat("\n");
         _loc1_.concat("  url: ").concat(this.url).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
