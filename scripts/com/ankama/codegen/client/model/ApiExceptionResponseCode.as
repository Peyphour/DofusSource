package com.ankama.codegen.client.model
{
   public class ApiExceptionResponseCode
   {
       
      
      public var detail:String = null;
      
      public function ApiExceptionResponseCode()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ApiExceptionResponseCode {\n");
         _loc1_.concat("  detail: ").concat(this.detail).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
