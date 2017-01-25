package com.ankama.codegen.client.model
{
   import flash.utils.Dictionary;
   
   public class ShopReferenceTypeNothing
   {
       
      
      public var data:Dictionary;
      
      public function ShopReferenceTypeNothing()
      {
         this.data = new Dictionary();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeNothing {\n");
         _loc1_.concat("  data: ").concat(this.data).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
