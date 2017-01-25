package com.ankama.codegen.client.model
{
   public class ShopReferenceTypeVideo
   {
       
      
      public var duration:Number = 0;
      
      public var media_id:Number = 0;
      
      public var cid:String = null;
      
      public function ShopReferenceTypeVideo()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeVideo {\n");
         _loc1_.concat("  duration: ").concat(this.duration).concat("\n");
         _loc1_.concat("  media_id: ").concat(this.media_id).concat("\n");
         _loc1_.concat("  cid: ").concat(this.cid).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
