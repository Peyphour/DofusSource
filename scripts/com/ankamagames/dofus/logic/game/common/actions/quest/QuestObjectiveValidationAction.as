package com.ankamagames.dofus.logic.game.common.actions.quest
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class QuestObjectiveValidationAction implements Action
   {
       
      
      public var questId:int;
      
      public var objectiveId:int;
      
      public function QuestObjectiveValidationAction()
      {
         super();
      }
      
      public static function create(param1:int, param2:int) : QuestObjectiveValidationAction
      {
         var _loc3_:QuestObjectiveValidationAction = new QuestObjectiveValidationAction();
         _loc3_.questId = param1;
         _loc3_.objectiveId = param2;
         return _loc3_;
      }
   }
}
