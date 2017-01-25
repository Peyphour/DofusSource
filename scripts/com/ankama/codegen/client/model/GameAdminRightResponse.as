package com.ankama.codegen.client.model
{
   public class GameAdminRightResponse
   {
       
      
      public var rights:Array;
      
      public function GameAdminRightResponse()
      {
         this.rights = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameAdminRightResponse {\n");
         _loc1_.concat("  rights: ").concat(this.rights).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
