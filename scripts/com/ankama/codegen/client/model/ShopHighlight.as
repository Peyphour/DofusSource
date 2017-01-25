package com.ankama.codegen.client.model
{
   public class ShopHighlight
   {
       
      
      public var id:Number = 0;
      
      public var image:Array;
      
      public var mode:String = null;
      
      public var restype:String = null;
      
      public var link:String = null;
      
      public var description:String = null;
      
      public var name:String = null;
      
      public var external_category:ShopCategory = null;
      
      public var external_article:ShopArticle = null;
      
      public var external_gondolahead:ShopGondolaHead = null;
      
      public var external_direct:String = null;
      
      public function ShopHighlight()
      {
         this.image = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopHighlight {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  image: ").concat(this.image).concat("\n");
         _loc1_.concat("  mode: ").concat(this.mode).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  link: ").concat(this.link).concat("\n");
         _loc1_.concat("  description: ").concat(this.description).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  external_category: ").concat(this.external_category).concat("\n");
         _loc1_.concat("  external_article: ").concat(this.external_article).concat("\n");
         _loc1_.concat("  external_gondolahead: ").concat(this.external_gondolahead).concat("\n");
         _loc1_.concat("  external_direct: ").concat(this.external_direct).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
