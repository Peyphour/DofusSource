package com.ankama.codegen.client.model
{
   import flash.utils.Dictionary;
   
   public class ApiTransactionReturn
   {
       
      
      public var code:Number = 0;
      
      public var header:Dictionary;
      
      public var data:String = null;
      
      public function ApiTransactionReturn()
      {
         this.header = new Dictionary();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ApiTransactionReturn {\n");
         _loc1_.concat("  code: ").concat(this.code).concat("\n");
         _loc1_.concat("  header: ").concat(this.header).concat("\n");
         _loc1_.concat("  data: ").concat(this.data).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
