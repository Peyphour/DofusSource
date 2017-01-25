package com.ankama.codegen.client.model
{
   public class ShopReferenceTypeCharTransfer
   {
       
      
      public var game:Number = 0;
      
      public var server_to:Number = 0;
      
      public function ShopReferenceTypeCharTransfer()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeCharTransfer {\n");
         _loc1_.concat("  game: ").concat(this.game).concat("\n");
         _loc1_.concat("  server_to: ").concat(this.server_to).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
