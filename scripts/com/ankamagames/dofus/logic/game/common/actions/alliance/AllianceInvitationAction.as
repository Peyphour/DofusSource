package com.ankamagames.dofus.logic.game.common.actions.alliance
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AllianceInvitationAction implements Action
   {
       
      
      public var targetId:Number;
      
      public function AllianceInvitationAction()
      {
         super();
      }
      
      public static function create(param1:Number) : AllianceInvitationAction
      {
         var _loc2_:AllianceInvitationAction = new AllianceInvitationAction();
         _loc2_.targetId = param1;
         return _loc2_;
      }
   }
}
