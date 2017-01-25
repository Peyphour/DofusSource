package com.ankama.codegen.client.model
{
   public class CmsPollInGame
   {
       
      
      public var item_id:Number = 0;
      
      public var title:String = null;
      
      public var description:String = null;
      
      public var url:String = null;
      
      public var criterion:String = null;
      
      public function CmsPollInGame()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class CmsPollInGame {\n");
         _loc1_.concat("  item_id: ").concat(this.item_id).concat("\n");
         _loc1_.concat("  title: ").concat(this.title).concat("\n");
         _loc1_.concat("  description: ").concat(this.description).concat("\n");
         _loc1_.concat("  url: ").concat(this.url).concat("\n");
         _loc1_.concat("  criterion: ").concat(this.criterion).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
