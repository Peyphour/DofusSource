package com.ankamagames.dofus.logic.game.common.actions.exchange
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeReadyCrushAction implements Action
   {
       
      
      public var isReady:Boolean;
      
      public var focusActionId:uint;
      
      public function ExchangeReadyCrushAction()
      {
         super();
      }
      
      public static function create(param1:Boolean, param2:uint) : ExchangeReadyCrushAction
      {
         var _loc3_:ExchangeReadyCrushAction = new ExchangeReadyCrushAction();
         _loc3_.isReady = param1;
         _loc3_.focusActionId = param2;
         return _loc3_;
      }
   }
}
