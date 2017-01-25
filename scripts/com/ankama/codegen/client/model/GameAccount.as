package com.ankama.codegen.client.model
{
   public class GameAccount
   {
       
      
      public var total_time_elapsed:Number = 0;
      
      public var subscribed:Boolean = false;
      
      public var first_subscription_date:Date = null;
      
      public var expiration_date:Date = null;
      
      public var ban_end_date:Date = null;
      
      public var added_date:Date = null;
      
      public var login_date:Date = null;
      
      public var login_ip:String = null;
      
      public function GameAccount()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameAccount {\n");
         _loc1_.concat("  total_time_elapsed: ").concat(this.total_time_elapsed).concat("\n");
         _loc1_.concat("  subscribed: ").concat(this.subscribed).concat("\n");
         _loc1_.concat("  first_subscription_date: ").concat(this.first_subscription_date).concat("\n");
         _loc1_.concat("  expiration_date: ").concat(this.expiration_date).concat("\n");
         _loc1_.concat("  ban_end_date: ").concat(this.ban_end_date).concat("\n");
         _loc1_.concat("  added_date: ").concat(this.added_date).concat("\n");
         _loc1_.concat("  login_date: ").concat(this.login_date).concat("\n");
         _loc1_.concat("  login_ip: ").concat(this.login_ip).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
