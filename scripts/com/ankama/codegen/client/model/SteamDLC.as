package com.ankama.codegen.client.model
{
   public class SteamDLC
   {
       
      
      public var id:Number = 0;
      
      public var game_id:Number = 0;
      
      public var app_id:Number = 0;
      
      public var definition_id:Number = 0;
      
      public var deleted_date:Date = null;
      
      public function SteamDLC()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class SteamDLC {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  game_id: ").concat(this.game_id).concat("\n");
         _loc1_.concat("  app_id: ").concat(this.app_id).concat("\n");
         _loc1_.concat("  definition_id: ").concat(this.definition_id).concat("\n");
         _loc1_.concat("  deleted_date: ").concat(this.deleted_date).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
