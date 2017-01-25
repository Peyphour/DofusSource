package com.ankama.codegen.client.model
{
   public class ShopOrder
   {
       
      
      public var id:Number = 0;
      
      public var status:String = null;
      
      public var articles:Array;
      
      public function ShopOrder()
      {
         this.articles = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopOrder {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  status: ").concat(this.status).concat("\n");
         _loc1_.concat("  articles: ").concat(this.articles).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
