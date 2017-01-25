package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PaddockMoveItemRequestAction implements Action
   {
       
      
      public var object:Object;
      
      public function PaddockMoveItemRequestAction()
      {
         super();
      }
      
      public static function create(param1:Object) : PaddockMoveItemRequestAction
      {
         var _loc2_:PaddockMoveItemRequestAction = new PaddockMoveItemRequestAction();
         _loc2_.object = param1;
         return _loc2_;
      }
   }
}
