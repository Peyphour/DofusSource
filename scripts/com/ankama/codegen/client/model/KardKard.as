package com.ankama.codegen.client.model
{
   public class KardKard
   {
       
      
      public var id:Number = 0;
      
      public var name:String = null;
      
      public var description:String = null;
      
      public var restype:String = null;
      
      public var kard_multiple:Array;
      
      public var kard_krosmaster:KardTypeKrosmaster = null;
      
      public var kard_action:KardTypeAction = null;
      
      public function KardKard()
      {
         this.kard_multiple = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class KardKard {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  description: ").concat(this.description).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  kard_multiple: ").concat(this.kard_multiple).concat("\n");
         _loc1_.concat("  kard_krosmaster: ").concat(this.kard_krosmaster).concat("\n");
         _loc1_.concat("  kard_action: ").concat(this.kard_action).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
