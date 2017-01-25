package com.ankama.codegen.client.model
{
   public class ShopPromo
   {
       
      
      public var name:String = null;
      
      public var description:String = null;
      
      public var image:String = null;
      
      public var start_date:Date = null;
      
      public var end_date:Date = null;
      
      public var gifts:Array;
      
      public function ShopPromo()
      {
         this.gifts = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopPromo {\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  description: ").concat(this.description).concat("\n");
         _loc1_.concat("  image: ").concat(this.image).concat("\n");
         _loc1_.concat("  start_date: ").concat(this.start_date).concat("\n");
         _loc1_.concat("  end_date: ").concat(this.end_date).concat("\n");
         _loc1_.concat("  gifts: ").concat(this.gifts).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
