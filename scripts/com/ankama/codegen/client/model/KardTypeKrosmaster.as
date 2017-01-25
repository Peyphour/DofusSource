package com.ankama.codegen.client.model
{
   public class KardTypeKrosmaster
   {
       
      
      public var id:Number = 0;
      
      public var name:String = null;
      
      public var pedestal_id:Number = 0;
      
      public var pedestal_name:String = null;
      
      public function KardTypeKrosmaster()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class KardTypeKrosmaster {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  pedestal_id: ").concat(this.pedestal_id).concat("\n");
         _loc1_.concat("  pedestal_name: ").concat(this.pedestal_name).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
