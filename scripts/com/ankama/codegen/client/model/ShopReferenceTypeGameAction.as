package com.ankama.codegen.client.model
{
   import flash.utils.Dictionary;
   
   public class ShopReferenceTypeGameAction
   {
       
      
      public var data:Dictionary;
      
      public function ShopReferenceTypeGameAction()
      {
         this.data = new Dictionary();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeGameAction {\n");
         _loc1_.concat("  data: ").concat(this.data).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
