package com.ankama.codegen.client.model
{
   public class SteamAccountMeta
   {
       
      
      public var dlc_id:Number = 0;
      
      public var dlc:SteamDLC = null;
      
      public var account_id:Number = 0;
      
      public var added_date:Date = null;
      
      public var added_ip:Number = 0;
      
      public var deleted_date:Date = null;
      
      public var app_id:Number = 0;
      
      public var order_id:Number = 0;
      
      public function SteamAccountMeta()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class SteamAccountMeta {\n");
         _loc1_.concat("  dlc_id: ").concat(this.dlc_id).concat("\n");
         _loc1_.concat("  dlc: ").concat(this.dlc).concat("\n");
         _loc1_.concat("  account_id: ").concat(this.account_id).concat("\n");
         _loc1_.concat("  added_date: ").concat(this.added_date).concat("\n");
         _loc1_.concat("  added_ip: ").concat(this.added_ip).concat("\n");
         _loc1_.concat("  deleted_date: ").concat(this.deleted_date).concat("\n");
         _loc1_.concat("  app_id: ").concat(this.app_id).concat("\n");
         _loc1_.concat("  order_id: ").concat(this.order_id).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
