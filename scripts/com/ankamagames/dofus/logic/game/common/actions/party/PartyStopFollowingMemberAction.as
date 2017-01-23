package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyStopFollowingMemberAction implements Action
   {
       
      
      public var playerId:Number;
      
      public var partyId:int;
      
      public function PartyStopFollowingMemberAction()
      {
         super();
      }
      
      public static function create(param1:int, param2:Number) : PartyStopFollowingMemberAction
      {
         var _loc3_:PartyStopFollowingMemberAction = new PartyStopFollowingMemberAction();
         _loc3_.partyId = param1;
         _loc3_.playerId = param2;
         return _loc3_;
      }
   }
}
