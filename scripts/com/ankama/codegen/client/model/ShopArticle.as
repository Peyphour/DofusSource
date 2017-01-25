package com.ankama.codegen.client.model
{
   public class ShopArticle
   {
       
      
      public var id:Number = 0;
      
      public var key:String = null;
      
      public var name:String = null;
      
      public var subtitle:String = null;
      
      public var description:String = null;
      
      public var currency:String = null;
      
      public var original_price:Number = 0;
      
      public var price:Number = 0;
      
      public var startdate:Date = null;
      
      public var enddate:Date = null;
      
      public var stock:Number = 0;
      
      public var image:Array;
      
      public var references:Array;
      
      public var promo:Array;
      
      public var media:Array;
      
      public var metas:Array;
      
      public function ShopArticle()
      {
         this.image = new Array();
         this.references = new Array();
         this.promo = new Array();
         this.media = new Array();
         this.metas = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopArticle {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  key: ").concat(this.key).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  subtitle: ").concat(this.subtitle).concat("\n");
         _loc1_.concat("  description: ").concat(this.description).concat("\n");
         _loc1_.concat("  currency: ").concat(this.currency).concat("\n");
         _loc1_.concat("  original_price: ").concat(this.original_price).concat("\n");
         _loc1_.concat("  price: ").concat(this.price).concat("\n");
         _loc1_.concat("  startdate: ").concat(this.startdate).concat("\n");
         _loc1_.concat("  enddate: ").concat(this.enddate).concat("\n");
         _loc1_.concat("  stock: ").concat(this.stock).concat("\n");
         _loc1_.concat("  image: ").concat(this.image).concat("\n");
         _loc1_.concat("  references: ").concat(this.references).concat("\n");
         _loc1_.concat("  promo: ").concat(this.promo).concat("\n");
         _loc1_.concat("  media: ").concat(this.media).concat("\n");
         _loc1_.concat("  metas: ").concat(this.metas).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
