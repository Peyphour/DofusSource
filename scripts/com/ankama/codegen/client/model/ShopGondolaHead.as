package com.ankama.codegen.client.model
{
   public class ShopGondolaHead
   {
       
      
      public var image:Array;
      
      public var home:Boolean = false;
      
      public var main:Boolean = false;
      
      public var link:String = null;
      
      public var name:String = null;
      
      public var id:Number = 0;
      
      public function ShopGondolaHead()
      {
         this.image = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopGondolaHead {\n");
         _loc1_.concat("  image: ").concat(this.image).concat("\n");
         _loc1_.concat("  home: ").concat(this.home).concat("\n");
         _loc1_.concat("  main: ").concat(this.main).concat("\n");
         _loc1_.concat("  link: ").concat(this.link).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
