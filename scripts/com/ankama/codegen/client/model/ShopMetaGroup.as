package com.ankama.codegen.client.model
{
   public class ShopMetaGroup
   {
       
      
      public var id:Number = 0;
      
      public var key:String = null;
      
      public var name:String = null;
      
      public var metas:Array;
      
      public function ShopMetaGroup()
      {
         this.metas = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopMetaGroup {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  key: ").concat(this.key).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  metas: ").concat(this.metas).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
