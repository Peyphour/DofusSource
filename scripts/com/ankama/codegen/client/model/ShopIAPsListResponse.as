package com.ankama.codegen.client.model
{
   public class ShopIAPsListResponse
   {
       
      
      public var key:String = null;
      
      public var restype:String = null;
      
      public function ShopIAPsListResponse()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopIAPsListResponse {\n");
         _loc1_.concat("  key: ").concat(this.key).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
