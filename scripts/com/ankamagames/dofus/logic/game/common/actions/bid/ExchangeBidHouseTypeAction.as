package com.ankamagames.dofus.logic.game.common.actions.bid
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeBidHouseTypeAction implements Action
   {
       
      
      public var type:uint;
      
      public function ExchangeBidHouseTypeAction()
      {
         super();
      }
      
      public static function create(param1:uint) : ExchangeBidHouseTypeAction
      {
         var _loc2_:ExchangeBidHouseTypeAction = new ExchangeBidHouseTypeAction();
         _loc2_.type = param1;
         return _loc2_;
      }
   }
}
