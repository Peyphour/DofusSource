package com.ankama.codegen.client.model
{
   public class GameActionsActionsTypeDofusHavenBagPod
   {
       
      
      public var restype:String = null;
      
      public var quantity:Number = 0;
      
      public function GameActionsActionsTypeDofusHavenBagPod()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsActionsTypeDofusHavenBagPod {\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  quantity: ").concat(this.quantity).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
