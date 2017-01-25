package com.ankama.codegen.client.model
{
   public class ShopOneClickToken
   {
       
      
      public var id:Number = 0;
      
      public var pan:String = null;
      
      public var brand:String = null;
      
      public var expiry_year:Number = 0;
      
      public var expiry_month:Number = 0;
      
      public var security_method:String = null;
      
      public var security_method_value:String = null;
      
      public var added_date:String = null;
      
      public function ShopOneClickToken()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopOneClickToken {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  pan: ").concat(this.pan).concat("\n");
         _loc1_.concat("  brand: ").concat(this.brand).concat("\n");
         _loc1_.concat("  expiry_year: ").concat(this.expiry_year).concat("\n");
         _loc1_.concat("  expiry_month: ").concat(this.expiry_month).concat("\n");
         _loc1_.concat("  security_method: ").concat(this.security_method).concat("\n");
         _loc1_.concat("  security_method_value: ").concat(this.security_method_value).concat("\n");
         _loc1_.concat("  added_date: ").concat(this.added_date).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
