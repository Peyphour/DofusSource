package com.ankama.codegen.client.model
{
   public class MoneyBalance
   {
      
      public static const CurrencyEnum_OGR:String = "OGR";
      
      public static const CurrencyEnum_KRZ:String = "KRZ";
      
      public static const CurrencyEnum_FRG:String = "FRG";
      
      public static const CurrencyEnum_GOU:String = "GOU";
       
      
      public var currency:String = null;
      
      public var amount:Number = 0;
      
      public function MoneyBalance()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class MoneyBalance {\n");
         _loc1_.concat("  currency: ").concat(this.currency).concat("\n");
         _loc1_.concat("  amount: ").concat(this.amount).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
