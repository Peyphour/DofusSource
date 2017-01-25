package com.ankama.codegen.client.model
{
   public class ShopReferenceTypeAccountStatus
   {
       
      
      public var status:String = null;
      
      public var restype:String = null;
      
      public var value:String = null;
      
      public function ShopReferenceTypeAccountStatus()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeAccountStatus {\n");
         _loc1_.concat("  status: ").concat(this.status).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  value: ").concat(this.value).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
