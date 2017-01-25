package com.ankamagames.dofus.logic.game.common.actions.craft
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeCraftPaymentModificationAction implements Action
   {
       
      
      public var kamas:uint;
      
      public function ExchangeCraftPaymentModificationAction()
      {
         super();
      }
      
      public static function create(param1:uint) : ExchangeCraftPaymentModificationAction
      {
         var _loc2_:ExchangeCraftPaymentModificationAction = new ExchangeCraftPaymentModificationAction();
         _loc2_.kamas = param1;
         return _loc2_;
      }
   }
}
