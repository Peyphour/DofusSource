package com.ankama.codegen.client.model
{
   public class KardTypeAction
   {
       
      
      public var id:Number = 0;
      
      public var quantity:Number = 0;
      
      public var name:String = null;
      
      public var title:String = null;
      
      public var description:String = null;
      
      public function KardTypeAction()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class KardTypeAction {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  quantity: ").concat(this.quantity).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  title: ").concat(this.title).concat("\n");
         _loc1_.concat("  description: ").concat(this.description).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
