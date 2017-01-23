package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TeleportBuddiesAnswerAction implements Action
   {
       
      
      public var accept:Boolean;
      
      public function TeleportBuddiesAnswerAction()
      {
         super();
      }
      
      public static function create(param1:Boolean) : TeleportBuddiesAnswerAction
      {
         var _loc2_:TeleportBuddiesAnswerAction = new TeleportBuddiesAnswerAction();
         _loc2_.accept = param1;
         return _loc2_;
      }
   }
}
