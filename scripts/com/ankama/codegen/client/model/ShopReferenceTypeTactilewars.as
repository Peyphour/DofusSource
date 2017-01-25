package com.ankama.codegen.client.model
{
   public class ShopReferenceTypeTactilewars
   {
       
      
      public var item:String = null;
      
      public var rarity:Number = 0;
      
      public function ShopReferenceTypeTactilewars()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class ShopReferenceTypeTactilewars {\n");
         _loc1_.concat("  item: ").concat(this.item).concat("\n");
         _loc1_.concat("  rarity: ").concat(this.rarity).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
