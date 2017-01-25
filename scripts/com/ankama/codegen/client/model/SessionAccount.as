package com.ankama.codegen.client.model
{
   public class SessionAccount
   {
       
      
      public var id:Number = 0;
      
      public var account_id:Number = 0;
      
      public var game_id:Number = 0;
      
      public var date:Date = null;
      
      public var ip:String = null;
      
      public var country:String = null;
      
      public var isp_id:Number = 0;
      
      public var duration:Number = 0;
      
      public var type_id:Number = 0;
      
      public var server_id:Number = 0;
      
      public var character_id:Number = 0;
      
      public function SessionAccount()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class SessionAccount {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  account_id: ").concat(this.account_id).concat("\n");
         _loc1_.concat("  game_id: ").concat(this.game_id).concat("\n");
         _loc1_.concat("  date: ").concat(this.date).concat("\n");
         _loc1_.concat("  ip: ").concat(this.ip).concat("\n");
         _loc1_.concat("  country: ").concat(this.country).concat("\n");
         _loc1_.concat("  isp_id: ").concat(this.isp_id).concat("\n");
         _loc1_.concat("  duration: ").concat(this.duration).concat("\n");
         _loc1_.concat("  type_id: ").concat(this.type_id).concat("\n");
         _loc1_.concat("  server_id: ").concat(this.server_id).concat("\n");
         _loc1_.concat("  character_id: ").concat(this.character_id).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
