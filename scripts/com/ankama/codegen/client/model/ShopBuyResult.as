package com.ankama.codegen.client.model
{
   public class ShopBuyResult
   {
      
      public static const Order_statusEnum_PENDING:String = "PENDING";
      
      public static const Order_statusEnum_CANCELED:String = "CANCELED";
      
      public static const Order_statusEnum_TO_PREPARE:String = "TO_PREPARE";
      
      public static const Order_statusEnum_IN_PROGRESS:String = "IN_PROGRESS";
      
      public static const Order_statusEnum_PROCESSED:String = "PROCESSED";
       
      
      public var balance:Array;
      
      public var order_id:Number = 0;
      
      public var order_status:String = null;
      
      public function ShopBuyResult()
      {
         this.balance = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopBuyResult {\n");
         _loc1_.concat("  balance: ").concat(this.balance).concat("\n");
         _loc1_.concat("  order_id: ").concat(this.order_id).concat("\n");
         _loc1_.concat("  order_status: ").concat(this.order_status).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
