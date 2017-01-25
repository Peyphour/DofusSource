package com.ankama.codegen.client.model
{
   public class ErrorRelation
   {
      
      public static const ReasonEnum_ALREADY_EXISTS:String = "ALREADY_EXISTS";
      
      public static const ReasonEnum_BLACKLISTED:String = "BLACKLISTED";
      
      public static const ReasonEnum_NOT_EXISTS:String = "NOT_EXISTS";
      
      public static const ReasonEnum_NOT_REQUESTED:String = "NOT_REQUESTED";
      
      public static const ReasonEnum_SAME_ACCOUNT:String = "SAME_ACCOUNT";
      
      public static const ReasonEnum_UNKNOWN_ACCOUNT:String = "UNKNOWN_ACCOUNT";
      
      public static const ReasonEnum_BAD_GROUP:String = "BAD_GROUP";
      
      public static const ReasonEnum_MAXIMUM:String = "MAXIMUM";
       
      
      public var reason:String = null;
      
      public function ErrorRelation()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ErrorRelation {\n");
         _loc1_.concat("  reason: ").concat(this.reason).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
