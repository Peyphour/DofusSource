package com.ankama.codegen.client.model
{
   public class SessionLogin
   {
       
      
      public var id:Number = 0;
      
      public var account:Account = null;
      
      public var game:GameAccount = null;
      
      public function SessionLogin()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class SessionLogin {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  account: ").concat(this.account).concat("\n");
         _loc1_.concat("  game: ").concat(this.game).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
