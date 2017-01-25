package com.ankama.codegen.client.model
{
   public class ErrorAccountLogin
   {
      
      public static const ReasonEnum_BAN:String = "BAN";
      
      public static const ReasonEnum_BLACKLIST:String = "BLACKLIST";
      
      public static const ReasonEnum_LOCKED:String = "LOCKED";
      
      public static const ReasonEnum_DELETED:String = "DELETED";
      
      public static const ReasonEnum_RESETANKAMA:String = "RESETANKAMA";
      
      public static const ReasonEnum_OTPTIMEFAILED:String = "OTPTIMEFAILED";
      
      public static const ReasonEnum_SECURITYCARD:String = "SECURITYCARD";
      
      public static const ReasonEnum_BRUTEFORCE:String = "BRUTEFORCE";
      
      public static const ReasonEnum_FAILED:String = "FAILED";
      
      public static const ReasonEnum_PARTNER:String = "PARTNER";
      
      public static const ReasonEnum_MAILNOVALID:String = "MAILNOVALID";
      
      public static const ReasonEnum_BETACLOSED:String = "BETACLOSED";
      
      public static const ReasonEnum_NOACCOUNT:String = "NOACCOUNT";
      
      public static const ReasonEnum_ACCOUNT_LINKED:String = "ACCOUNT_LINKED";
      
      public static const ReasonEnum_ACCOUNT_INVALID:String = "ACCOUNT_INVALID";
      
      public static const ReasonEnum_ACCOUNT_SHIELDED:String = "ACCOUNT_SHIELDED";
       
      
      public var reason:String = null;
      
      public function ErrorAccountLogin()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ErrorAccountLogin {\n");
         _loc1_.concat("  reason: ").concat(this.reason).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
