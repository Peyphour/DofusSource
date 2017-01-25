package com.ankama.codegen.client.model
{
   public class ForumTopic
   {
       
      
      public var id:Number = 0;
      
      public var title:String = null;
      
      public var content:String = null;
      
      public var pinned:Boolean = false;
      
      public var added_date:Date = null;
      
      public function ForumTopic()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ForumTopic {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  title: ").concat(this.title).concat("\n");
         _loc1_.concat("  content: ").concat(this.content).concat("\n");
         _loc1_.concat("  pinned: ").concat(this.pinned).concat("\n");
         _loc1_.concat("  added_date: ").concat(this.added_date).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
