package com.ankama.codegen.client.model
{
   public class CharacterAddScreenshotResponse
   {
       
      
      public var status:Boolean = false;
      
      public var item_id:Number = 0;
      
      public var url:String = null;
      
      public function CharacterAddScreenshotResponse()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class CharacterAddScreenshotResponse {\n");
         _loc1_.concat("  status: ").concat(this.status).concat("\n");
         _loc1_.concat("  item_id: ").concat(this.item_id).concat("\n");
         _loc1_.concat("  url: ").concat(this.url).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
