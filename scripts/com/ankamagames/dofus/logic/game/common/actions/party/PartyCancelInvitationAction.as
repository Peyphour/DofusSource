package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyCancelInvitationAction implements Action
   {
       
      
      public var guestId:Number;
      
      public var partyId:int;
      
      public function PartyCancelInvitationAction()
      {
         super();
      }
      
      public static function create(param1:int, param2:Number) : PartyCancelInvitationAction
      {
         var _loc3_:PartyCancelInvitationAction = new PartyCancelInvitationAction();
         _loc3_.partyId = param1;
         _loc3_.guestId = param2;
         return _loc3_;
      }
   }
}
