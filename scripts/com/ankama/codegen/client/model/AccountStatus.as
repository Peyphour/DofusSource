package com.ankama.codegen.client.model
{
   public class AccountStatus
   {
       
      
      public var sId:String = null;
      
      public var sValue:String = null;
      
      public function AccountStatus()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class AccountStatus {\n");
         _loc1_.concat("  sId: ").concat(this.sId).concat("\n");
         _loc1_.concat("  sValue: ").concat(this.sValue).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
