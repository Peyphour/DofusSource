package com.ankama.codegen.client.model
{
   public class GameActionsActionsTypeKrosmasterFigure
   {
       
      
      public var figure_id:Number = 0;
      
      public var pedestral_id:Number = 0;
      
      public var restype:String = null;
      
      public var quantity:Number = 0;
      
      public function GameActionsActionsTypeKrosmasterFigure()
      {
         super();
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_.concat("class GameActionsActionsTypeKrosmasterFigure {\n");
         _loc1_.concat("  figure_id: ").concat(this.figure_id).concat("\n");
         _loc1_.concat("  pedestral_id: ").concat(this.pedestral_id).concat("\n");
         _loc1_.concat("  restype: ").concat(this.restype).concat("\n");
         _loc1_.concat("  quantity: ").concat(this.quantity).concat("\n");
         _loc1_.concat("}\n");
         return _loc1_;
      }
   }
}
