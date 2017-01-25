package com.ankama.codegen.client.model
{
   public class AuthenticatorHelp
   {
       
      
      public var question:String = null;
      
      public var answer:String = null;
      
      public function AuthenticatorHelp()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class AuthenticatorHelp {\n");
         _loc1_.concat("  question: ").concat(this.question).concat("\n");
         _loc1_.concat("  answer: ").concat(this.answer).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
