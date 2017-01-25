package com.ankama.codegen.client.model
{
   public class GameActionsAccountConsumed
   {
       
      
      public var actions:Array;
      
      public var updated_date:Date = null;
      
      public var id:Number = 0;
      
      public var account_id:Number = 0;
      
      public var game_id:Number = 0;
      
      public var server_id:Number = 0;
      
      public var user_id:Number = 0;
      
      public var definition_id:Number = 0;
      
      public var external_type:String = null;
      
      public var external_id:Number = 0;
      
      public var added_date:Date = null;
      
      public function GameActionsAccountConsumed()
      {
         this.actions = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsAccountConsumed {\n");
         _loc1_.concat("  actions: ").concat(this.actions).concat("\n");
         _loc1_.concat("  updated_date: ").concat(this.updated_date).concat("\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  account_id: ").concat(this.account_id).concat("\n");
         _loc1_.concat("  game_id: ").concat(this.game_id).concat("\n");
         _loc1_.concat("  server_id: ").concat(this.server_id).concat("\n");
         _loc1_.concat("  user_id: ").concat(this.user_id).concat("\n");
         _loc1_.concat("  definition_id: ").concat(this.definition_id).concat("\n");
         _loc1_.concat("  external_type: ").concat(this.external_type).concat("\n");
         _loc1_.concat("  external_id: ").concat(this.external_id).concat("\n");
         _loc1_.concat("  added_date: ").concat(this.added_date).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
