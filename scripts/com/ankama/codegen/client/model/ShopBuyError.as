package com.ankama.codegen.client.model
{
   public class ShopBuyError
   {
      
      public static const ReasonEnum_NOPRICE:String = "NOPRICE";
      
      public static const ReasonEnum_STOCKMISSING:String = "STOCKMISSING";
      
      public static const ReasonEnum_PAIDFAILED:String = "PAIDFAILED";
      
      public static const ReasonEnum_CANCELFAILED:String = "CANCELFAILED";
      
      public static const ReasonEnum_MISSINGMONEY:String = "MISSINGMONEY";
      
      public static const ReasonEnum_PARTNER_ERROR:String = "PARTNER_ERROR";
      
      public static const ReasonEnum_PARTNER_MISSING:String = "PARTNER_MISSING";
      
      public static const ReasonEnum_PARTNER_NOORDER:String = "PARTNER_NOORDER";
      
      public static const ReasonEnum_RECEIPT_ALREADY_VALIDATED:String = "RECEIPT_ALREADY_VALIDATED";
      
      public static const ReasonEnum_STEAM_NOT_TRUSTED_USER:String = "STEAM_NOT_TRUSTED_USER";
      
      public static const ReasonEnum_PAYMENT_CODE_NOT_SENT:String = "PAYMENT_CODE_NOT_SENT";
       
      
      public var reason:String = null;
      
      public var order_id:Number = 0;
      
      public function ShopBuyError()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopBuyError {\n");
         _loc1_.concat("  reason: ").concat(this.reason).concat("\n");
         _loc1_.concat("  order_id: ").concat(this.order_id).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
