package com.ankama.codegen.client.model
{
   public class CharacterExportResponse
   {
       
      
      public var status:Number = 0;
      
      public function CharacterExportResponse()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class CharacterExportResponse {\n");
         _loc1_.concat("  status: ").concat(this.status).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
