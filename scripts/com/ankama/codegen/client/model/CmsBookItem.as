package com.ankama.codegen.client.model
{
   public class CmsBookItem
   {
       
      
      public var title:String = null;
      
      public var sub_title:String = null;
      
      public var summary:String = null;
      
      public var wizcorp_data:Array;
      
      public var wizcorp_id:String = null;
      
      public function CmsBookItem()
      {
         this.wizcorp_data = new Array();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class CmsBookItem {\n");
         _loc1_.concat("  title: ").concat(this.title).concat("\n");
         _loc1_.concat("  sub_title: ").concat(this.sub_title).concat("\n");
         _loc1_.concat("  summary: ").concat(this.summary).concat("\n");
         _loc1_.concat("  wizcorp_data: ").concat(this.wizcorp_data).concat("\n");
         _loc1_.concat("  wizcorp_id: ").concat(this.wizcorp_id).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
