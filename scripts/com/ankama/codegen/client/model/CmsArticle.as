package com.ankama.codegen.client.model
{
   public class CmsArticle
   {
       
      
      public var image_url:String = null;
      
      public var subtitle:String = null;
      
      public var restype:String = null;
      
      public var category:String = null;
      
      public var id:Number = 0;
      
      public var name:String = null;
      
      public var lang:String = null;
      
      public var date:String = null;
      
      public var url:String = null;
      
      public var url_topic:String = null;
      
      public function CmsArticle()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class CmsArticle {\n");
         _loc1_.concat("  image_url: ").concat(this.image_url).concat("\n");
         _loc1_.concat("  subtitle: ").concat(this.subtitle).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  category: ").concat(this.category).concat("\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  lang: ").concat(this.lang).concat("\n");
         _loc1_.concat("  date: ").concat(this.date).concat("\n");
         _loc1_.concat("  url: ").concat(this.url).concat("\n");
         _loc1_.concat("  url_topic: ").concat(this.url_topic).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
