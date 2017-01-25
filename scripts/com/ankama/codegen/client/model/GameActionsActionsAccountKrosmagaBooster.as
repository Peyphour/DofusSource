package com.ankama.codegen.client.model
{
   public class GameActionsActionsAccountKrosmagaBooster
   {
       
      
      public var booster_guid:String = null;
      
      public var server_id:Number = 0;
      
      public var restype:String = null;
      
      public var quantity:Number = 0;
      
      public var uid:String = null;
      
      public function GameActionsActionsAccountKrosmagaBooster()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsActionsAccountKrosmagaBooster {\n");
         _loc1_.concat("  booster_guid: ").concat(this.booster_guid).concat("\n");
         _loc1_.concat("  server_id: ").concat(this.server_id).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  quantity: ").concat(this.quantity).concat("\n");
         _loc1_.concat("  uid: ").concat(this.uid).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
