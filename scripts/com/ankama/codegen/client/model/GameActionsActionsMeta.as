package com.ankama.codegen.client.model
{
   public class GameActionsActionsMeta
   {
       
      
      public var destination_account_id:Number = 0;
      
      public var restype:String = null;
      
      public var quantity:Number = 0;
      
      public var theme_id:Number = 0;
      
      public var id:Number = 0;
      
      public var description:GameActionsDescription = null;
      
      public var account_id:Number = 0;
      
      public var server_id:Number = 0;
      
      public var user_id:Number = 0;
      
      public var uid:String = null;
      
      public var item_id:Number = 0;
      
      public var effect:String = null;
      
      public var kard_id:Number = 0;
      
      public var figure_id:Number = 0;
      
      public var pedestral_id:Number = 0;
      
      public var bind_type:String = null;
      
      public function GameActionsActionsMeta()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsActionsMeta {\n");
         _loc1_.concat("  destination_account_id: ").concat(this.destination_account_id).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  quantity: ").concat(this.quantity).concat("\n");
         _loc1_.concat("  theme_id: ").concat(this.theme_id).concat("\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  description: ").concat(this.description).concat("\n");
         _loc1_.concat("  account_id: ").concat(this.account_id).concat("\n");
         _loc1_.concat("  server_id: ").concat(this.server_id).concat("\n");
         _loc1_.concat("  user_id: ").concat(this.user_id).concat("\n");
         _loc1_.concat("  uid: ").concat(this.uid).concat("\n");
         _loc1_.concat("  item_id: ").concat(this.item_id).concat("\n");
         _loc1_.concat("  effect: ").concat(this.effect).concat("\n");
         _loc1_.concat("  kard_id: ").concat(this.kard_id).concat("\n");
         _loc1_.concat("  figure_id: ").concat(this.figure_id).concat("\n");
         _loc1_.concat("  pedestral_id: ").concat(this.pedestral_id).concat("\n");
         _loc1_.concat("  bind_type: ").concat(this.bind_type).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
