package com.ankama.codegen.client.model
{
   public class GameActionsCategory
   {
       
      
      public var id:Number = 0;
      
      public var parent_id:Number = 0;
      
      public var name:String = null;
      
      public function GameActionsCategory()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsCategory {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  parent_id: ").concat(this.parent_id).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
