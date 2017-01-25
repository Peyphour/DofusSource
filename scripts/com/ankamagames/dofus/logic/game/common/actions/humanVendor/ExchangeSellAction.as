package com.ankamagames.dofus.logic.game.common.actions.humanVendor
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeSellAction implements Action
   {
       
      
      public var objectUID:uint;
      
      public var quantity:uint;
      
      public function ExchangeSellAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint) : ExchangeSellAction
      {
         var _loc3_:ExchangeSellAction = new ExchangeSellAction();
         _loc3_.objectUID = param1;
         _loc3_.quantity = param2;
         return _loc3_;
      }
   }
}
