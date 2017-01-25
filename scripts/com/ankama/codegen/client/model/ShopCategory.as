package com.ankama.codegen.client.model
{
   public class ShopCategory
   {
       
      
      public var id:Number = 0;
      
      public var key:String = null;
      
      public var name:String = null;
      
      public var displaymode:String = null;
      
      public var description:String = null;
      
      public var url:String = null;
      
      public var child:Array;
      
      public function ShopCategory()
      {
         this.child = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopCategory {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  key: ").concat(this.key).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  displaymode: ").concat(this.displaymode).concat("\n");
         _loc1_.concat("  description: ").concat(this.description).concat("\n");
         _loc1_.concat("  url: ").concat(this.url).concat("\n");
         _loc1_.concat("  child: ").concat(this.child).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
