package com.ankama.codegen.client.model
{
   public class HaapiException
   {
       
      
      public var status:int = 0;
      
      public var message:String = null;
      
      public var restype:String = null;
      
      public var stack_trace:Array;
      
      public var code:int = 0;
      
      public var detail:String = null;
      
      public function HaapiException()
      {
         this.stack_trace = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class HaapiException {\n");
         _loc1_.concat("  status: ").concat(this.status).concat("\n");
         _loc1_.concat("  message: ").concat(this.message).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  stack_trace: ").concat(this.stack_trace).concat("\n");
         _loc1_.concat("  code: ").concat(this.code).concat("\n");
         _loc1_.concat("  detail: ").concat(this.detail).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
