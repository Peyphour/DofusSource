package com.ankama.codegen.client.model
{
   public class ForumPost
   {
       
      
      public var id:Number = 0;
      
      public var content:String = null;
      
      public var added_date:Date = null;
      
      public function ForumPost()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ForumPost {\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  content: ").concat(this.content).concat("\n");
         _loc1_.concat("  added_date: ").concat(this.added_date).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
