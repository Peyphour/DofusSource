package com.ankama.codegen.client.model
{
   public class ShopReferenceTypeVirtualSubscriptionLevel
   {
       
      
      public var server_id:String = null;
      
      public var level:Number = 0;
      
      public function ShopReferenceTypeVirtualSubscriptionLevel()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeVirtualSubscriptionLevel {\n");
         _loc1_.concat("  server_id: ").concat(this.server_id).concat("\n");
         _loc1_.concat("  level: ").concat(this.level).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
