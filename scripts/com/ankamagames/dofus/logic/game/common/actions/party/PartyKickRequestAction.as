package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyKickRequestAction implements Action
   {
       
      
      public var playerId:Number;
      
      public var partyId:int;
      
      public function PartyKickRequestAction()
      {
         super();
      }
      
      public static function create(param1:int, param2:Number) : PartyKickRequestAction
      {
         var _loc3_:PartyKickRequestAction = new PartyKickRequestAction();
         _loc3_.partyId = param1;
         _loc3_.playerId = param2;
         return _loc3_;
      }
   }
}
