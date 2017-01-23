package com.ankamagames.dofus.logic.game.common.actions.roleplay
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JoinFightRequestAction implements Action
   {
       
      
      public var fightId:uint;
      
      public var teamLeaderId:Number;
      
      public function JoinFightRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Number) : JoinFightRequestAction
      {
         var _loc3_:JoinFightRequestAction = new JoinFightRequestAction();
         _loc3_.fightId = param1;
         _loc3_.teamLeaderId = param2;
         return _loc3_;
      }
   }
}
