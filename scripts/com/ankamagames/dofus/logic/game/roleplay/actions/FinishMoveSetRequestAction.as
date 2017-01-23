package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class FinishMoveSetRequestAction implements Action
   {
       
      
      public var enabledFinishedMoves:Vector.<int>;
      
      public var disabledFinishedMoves:Vector.<int>;
      
      public function FinishMoveSetRequestAction()
      {
         super();
      }
      
      public static function create(param1:Vector.<int>, param2:Vector.<int>) : FinishMoveSetRequestAction
      {
         var _loc3_:FinishMoveSetRequestAction = new FinishMoveSetRequestAction();
         _loc3_.enabledFinishedMoves = param1;
         _loc3_.disabledFinishedMoves = param2;
         return _loc3_;
      }
   }
}
