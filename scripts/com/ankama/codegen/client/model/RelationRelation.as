package com.ankama.codegen.client.model
{
   public class RelationRelation
   {
       
      
      public var account:Account = null;
      
      public var restype:String = null;
      
      public var group:RelationGroup = null;
      
      public var alias:String = null;
      
      public function RelationRelation()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class RelationRelation {\n");
         _loc1_.concat("  account: ").concat(this.account).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  group: ").concat(this.group).concat("\n");
         _loc1_.concat("  alias: ").concat(this.alias).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
