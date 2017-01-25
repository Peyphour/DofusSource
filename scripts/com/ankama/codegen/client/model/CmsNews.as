package com.ankama.codegen.client.model
{
   public class CmsNews
   {
       
      
      public var item_id:Number = 0;
      
      public var image_url:String = null;
      
      public var title:String = null;
      
      public var sub_title:String = null;
      
      public var url:String = null;
      
      public var restype:String = null;
      
      public var date:String = null;
      
      public function CmsNews()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class CmsNews {\n");
         _loc1_.concat("  item_id: ").concat(this.item_id).concat("\n");
         _loc1_.concat("  image_url: ").concat(this.image_url).concat("\n");
         _loc1_.concat("  title: ").concat(this.title).concat("\n");
         _loc1_.concat("  sub_title: ").concat(this.sub_title).concat("\n");
         _loc1_.concat("  url: ").concat(this.url).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  date: ").concat(this.date).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
