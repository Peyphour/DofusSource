package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyAcceptInvitationAction implements Action
   {
       
      
      public var partyId:int;
      
      public function PartyAcceptInvitationAction()
      {
         super();
      }
      
      public static function create(param1:int) : PartyAcceptInvitationAction
      {
         var _loc2_:PartyAcceptInvitationAction = new PartyAcceptInvitationAction();
         _loc2_.partyId = param1;
         return _loc2_;
      }
   }
}
