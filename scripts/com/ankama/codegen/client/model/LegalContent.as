package com.ankama.codegen.client.model
{
   public class LegalContent
   {
       
      
      public var current_version:String = null;
      
      public var texts:Array;
      
      public function LegalContent()
      {
         this.texts = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class LegalContent {\n");
         _loc1_.concat("  current_version: ").concat(this.current_version).concat("\n");
         _loc1_.concat("  texts: ").concat(this.texts).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
