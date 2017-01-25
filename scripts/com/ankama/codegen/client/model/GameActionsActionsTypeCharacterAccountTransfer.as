package com.ankama.codegen.client.model
{
   public class GameActionsActionsTypeCharacterAccountTransfer
   {
       
      
      public var destination_account_id:Number = 0;
      
      public var restype:String = null;
      
      public var quantity:Number = 0;
      
      public function GameActionsActionsTypeCharacterAccountTransfer()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsActionsTypeCharacterAccountTransfer {\n");
         _loc1_.concat("  destination_account_id: ").concat(this.destination_account_id).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  quantity: ").concat(this.quantity).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
