package com.ankama.codegen.client.model
{
   public class GameActionsActionsDeliveredKrosmagaGod
   {
       
      
      public var god_id:Number = 0;
      
      public var server_id:Number = 0;
      
      public var restype:String = null;
      
      public var quantity:Number = 0;
      
      public var game:Number = 0;
      
      public var user_id:Number = 0;
      
      public var date:Date = null;
      
      public var uid:String = null;
      
      public function GameActionsActionsDeliveredKrosmagaGod()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsActionsDeliveredKrosmagaGod {\n");
         _loc1_.concat("  god_id: ").concat(this.god_id).concat("\n");
         _loc1_.concat("  server_id: ").concat(this.server_id).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  quantity: ").concat(this.quantity).concat("\n");
         _loc1_.concat("  game: ").concat(this.game).concat("\n");
         _loc1_.concat("  user_id: ").concat(this.user_id).concat("\n");
         _loc1_.concat("  date: ").concat(this.date).concat("\n");
         _loc1_.concat("  uid: ").concat(this.uid).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
