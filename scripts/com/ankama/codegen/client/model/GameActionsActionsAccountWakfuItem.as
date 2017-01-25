package com.ankama.codegen.client.model
{
   public class GameActionsActionsAccountWakfuItem
   {
       
      
      public var item_id:Number = 0;
      
      public var bind_type:String = null;
      
      public var restype:String = null;
      
      public var quantity:Number = 0;
      
      public var uid:String = null;
      
      public function GameActionsActionsAccountWakfuItem()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsActionsAccountWakfuItem {\n");
         _loc1_.concat("  item_id: ").concat(this.item_id).concat("\n");
         _loc1_.concat("  bind_type: ").concat(this.bind_type).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  quantity: ").concat(this.quantity).concat("\n");
         _loc1_.concat("  uid: ").concat(this.uid).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
