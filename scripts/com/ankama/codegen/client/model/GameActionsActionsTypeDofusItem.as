package com.ankama.codegen.client.model
{
   public class GameActionsActionsTypeDofusItem
   {
       
      
      public var item_id:Number = 0;
      
      public var effect:String = null;
      
      public var restype:String = null;
      
      public var quantity:Number = 0;
      
      public function GameActionsActionsTypeDofusItem()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsActionsTypeDofusItem {\n");
         _loc1_.concat("  item_id: ").concat(this.item_id).concat("\n");
         _loc1_.concat("  effect: ").concat(this.effect).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  quantity: ").concat(this.quantity).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
