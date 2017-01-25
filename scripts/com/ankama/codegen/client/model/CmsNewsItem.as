package com.ankama.codegen.client.model
{
   public class CmsNewsItem
   {
       
      
      public var title:String = null;
      
      public var sub_title:String = null;
      
      public var begin:String = null;
      
      public var end:String = null;
      
      public var comments_count:Number = 0;
      
      public var restype:String = null;
      
      public var date:String = null;
      
      public var url:String = null;
      
      public function CmsNewsItem()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class CmsNewsItem {\n");
         _loc1_.concat("  title: ").concat(this.title).concat("\n");
         _loc1_.concat("  sub_title: ").concat(this.sub_title).concat("\n");
         _loc1_.concat("  begin: ").concat(this.begin).concat("\n");
         _loc1_.concat("  end: ").concat(this.end).concat("\n");
         _loc1_.concat("  comments_count: ").concat(this.comments_count).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  date: ").concat(this.date).concat("\n");
         _loc1_.concat("  url: ").concat(this.url).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
