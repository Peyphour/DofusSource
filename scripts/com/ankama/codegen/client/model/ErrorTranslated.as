package com.ankama.codegen.client.model
{
   public class ErrorTranslated
   {
       
      
      public var key:String = null;
      
      public var text:String = null;
      
      public function ErrorTranslated()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ErrorTranslated {\n");
         _loc1_.concat("  key: ").concat(this.key).concat("\n");
         _loc1_.concat("  text: ").concat(this.text).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
