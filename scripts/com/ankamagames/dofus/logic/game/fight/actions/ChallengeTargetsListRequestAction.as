package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChallengeTargetsListRequestAction implements Action
   {
       
      
      public var challengeId:uint;
      
      public function ChallengeTargetsListRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : ChallengeTargetsListRequestAction
      {
         var _loc2_:ChallengeTargetsListRequestAction = new ChallengeTargetsListRequestAction();
         _loc2_.challengeId = param1;
         return _loc2_;
      }
   }
}
