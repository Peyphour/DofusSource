package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PartyShowMenuAction implements Action
   {
       
      
      public var playerId:Number;
      
      public var partyId:int;
      
      public function PartyShowMenuAction()
      {
         super();
      }
      
      public static function create(param1:Number, param2:int) : PartyShowMenuAction
      {
         var _loc3_:PartyShowMenuAction = new PartyShowMenuAction();
         _loc3_.playerId = param1;
         _loc3_.partyId = param2;
         return _loc3_;
      }
   }
}
