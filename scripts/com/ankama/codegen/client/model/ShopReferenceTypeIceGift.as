package com.ankama.codegen.client.model
{
   import flash.utils.Dictionary;
   
   public class ShopReferenceTypeIceGift
   {
       
      
      public var image:String = null;
      
      public var description:String = null;
      
      public var name:String = null;
      
      public var id:Number = 0;
      
      public var metas:Dictionary;
      
      public function ShopReferenceTypeIceGift()
      {
         this.metas = new Dictionary();
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeIceGift {\n");
         _loc1_.concat("  image: ").concat(this.image).concat("\n");
         _loc1_.concat("  description: ").concat(this.description).concat("\n");
         _loc1_.concat("  name: ").concat(this.name).concat("\n");
         _loc1_.concat("  id: ").concat(this.id).concat("\n");
         _loc1_.concat("  metas: ").concat(this.metas).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
