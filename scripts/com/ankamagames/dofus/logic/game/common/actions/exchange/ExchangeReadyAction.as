package com.ankamagames.dofus.logic.game.common.actions.exchange
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeReadyAction implements Action
   {
       
      
      public var isReady:Boolean;
      
      public function ExchangeReadyAction()
      {
         super();
      }
      
      public static function create(param1:Boolean) : ExchangeReadyAction
      {
         var _loc2_:ExchangeReadyAction = new ExchangeReadyAction();
         _loc2_.isReady = param1;
         return _loc2_;
      }
   }
}
