package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PaddockSellRequestAction implements Action
   {
       
      
      public var price:uint;
      
      public var forSale:Boolean;
      
      public function PaddockSellRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Boolean = true) : PaddockSellRequestAction
      {
         var _loc3_:PaddockSellRequestAction = new PaddockSellRequestAction();
         _loc3_.price = param1;
         _loc3_.forSale = param2;
         return _loc3_;
      }
   }
}
