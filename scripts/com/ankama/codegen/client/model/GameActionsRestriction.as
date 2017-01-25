package com.ankama.codegen.client.model
{
   public class GameActionsRestriction
   {
       
      
      public var id:Number = 0;
      
      public var name:String = null;
      
      public var conditions:String = null;
      
      public function GameActionsRestriction()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsRestriction {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  conditions: ").concat(this.conditions).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
