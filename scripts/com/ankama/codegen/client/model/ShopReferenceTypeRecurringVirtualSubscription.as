package com.ankama.codegen.client.model
{
   public class ShopReferenceTypeRecurringVirtualSubscription
   {
       
      
      public var recurring_article:Number = 0;
      
      public var recurring_duration:String = null;
      
      public var recurring_missingday_article:Number = 0;
      
      public function ShopReferenceTypeRecurringVirtualSubscription()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeRecurringVirtualSubscription {\n");
         _loc1_.concat("  recurring_article: ").concat(this.recurring_article).concat("\n");
         _loc1_.concat("  recurring_duration: ").concat(this.recurring_duration).concat("\n");
         _loc1_.concat("  recurring_missingday_article: ").concat(this.recurring_missingday_article).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
