package com.ankama.codegen.client.model
{
   public class SessionAccountsPaged
   {
       
      
      public var total:Number = 0;
      
      public var page_size:Number = 0;
      
      public var page_previous:Number = 0;
      
      public var page_current:Number = 0;
      
      public var page_next:Number = 0;
      
      public var page_last:Number = 0;
      
      public var accounts:Array;
      
      public function SessionAccountsPaged()
      {
         this.accounts = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class SessionAccountsPaged {\n");
         _loc1_.concat("  total: ").concat(this.total).concat("\n");
         _loc1_.concat("  page_size: ").concat(this.page_size).concat("\n");
         _loc1_.concat("  page_previous: ").concat(this.page_previous).concat("\n");
         _loc1_.concat("  page_current: ").concat(this.page_current).concat("\n");
         _loc1_.concat("  page_next: ").concat(this.page_next).concat("\n");
         _loc1_.concat("  page_last: ").concat(this.page_last).concat("\n");
         _loc1_.concat("  accounts: ").concat(this.accounts).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
