package com.ankama.codegen.client.model
{
   public class ShopPaymentHkCodeSendResult
   {
       
      
      public var success:Boolean = false;
      
      public function ShopPaymentHkCodeSendResult()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopPaymentHkCodeSendResult {\n");
         _loc1_.concat("  success: ").concat(this.success).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
