package com.ankama.codegen.client.model
{
   public class RelationGroup
   {
       
      
      public var id:Number = 0;
      
      public var name:String = null;
      
      public function RelationGroup()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class RelationGroup {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
