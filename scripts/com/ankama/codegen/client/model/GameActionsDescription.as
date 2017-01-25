package com.ankama.codegen.client.model
{
   public class GameActionsDescription
   {
       
      
      public var lang:Array;
      
      public var text:Array;
      
      public function GameActionsDescription()
      {
         this.lang = new Array();
         this.text = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsDescription {\n");
         _loc1_.concat("  lang: ").concat(this.lang).concat("\n");
         _loc1_.concat("  text: ").concat(this.text).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
