package com.ankama.codegen.client.model
{
   public class ShopHome
   {
       
      
      public var categories:Array;
      
      public var gondolahead_main:Array;
      
      public var gondolahead_article:Array;
      
      public var hightlight_carousel:Array;
      
      public var hightlight_image:Array;
      
      public function ShopHome()
      {
         this.categories = new Array();
         this.gondolahead_main = new Array();
         this.gondolahead_article = new Array();
         this.hightlight_carousel = new Array();
         this.hightlight_image = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopHome {\n");
         _loc1_.concat("  categories: ").concat(this.categories).concat("\n");
         _loc1_.concat("  gondolahead_main: ").concat(this.gondolahead_main).concat("\n");
         _loc1_.concat("  gondolahead_article: ").concat(this.gondolahead_article).concat("\n");
         _loc1_.concat("  hightlight_carousel: ").concat(this.hightlight_carousel).concat("\n");
         _loc1_.concat("  hightlight_image: ").concat(this.hightlight_image).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
