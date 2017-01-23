package com.ankamagames.dofus.logic.game.roleplay.actions.havenbag
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HavenbagInvitePlayerAnswerAction implements Action
   {
       
      
      public var hostId:Number;
      
      public var accept:Boolean;
      
      public function HavenbagInvitePlayerAnswerAction()
      {
         super();
      }
      
      public static function create(param1:Number, param2:Boolean) : HavenbagInvitePlayerAnswerAction
      {
         var _loc3_:HavenbagInvitePlayerAnswerAction = new HavenbagInvitePlayerAnswerAction();
         _loc3_.hostId = param1;
         _loc3_.accept = param2;
         return _loc3_;
      }
   }
}
