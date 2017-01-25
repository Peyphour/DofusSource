package com.ankamagames.dofus.logic.game.common.actions.craft
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeObjectUseInWorkshopAction implements Action
   {
       
      
      public var objectUID:uint;
      
      public var quantity:uint;
      
      public function ExchangeObjectUseInWorkshopAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint) : ExchangeObjectUseInWorkshopAction
      {
         var _loc3_:ExchangeObjectUseInWorkshopAction = new ExchangeObjectUseInWorkshopAction();
         _loc3_.objectUID = param1;
         _loc3_.quantity = param2;
         return _loc3_;
      }
   }
}
