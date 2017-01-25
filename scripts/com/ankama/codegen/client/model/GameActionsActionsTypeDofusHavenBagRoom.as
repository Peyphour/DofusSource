package com.ankama.codegen.client.model
{
   public class GameActionsActionsTypeDofusHavenBagRoom
   {
       
      
      public var restype:String = null;
      
      public var quantity:Number = 0;
      
      public function GameActionsActionsTypeDofusHavenBagRoom()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsActionsTypeDofusHavenBagRoom {\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  quantity: ").concat(this.quantity).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
