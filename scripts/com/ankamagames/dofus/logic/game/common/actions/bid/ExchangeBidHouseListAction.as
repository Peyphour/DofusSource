package com.ankamagames.dofus.logic.game.common.actions.bid
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeBidHouseListAction implements Action
   {
       
      
      public var id:uint;
      
      public function ExchangeBidHouseListAction()
      {
         super();
      }
      
      public static function create(param1:uint) : ExchangeBidHouseListAction
      {
         var _loc2_:ExchangeBidHouseListAction = new ExchangeBidHouseListAction();
         _loc2_.id = param1;
         return _loc2_;
      }
   }
}
