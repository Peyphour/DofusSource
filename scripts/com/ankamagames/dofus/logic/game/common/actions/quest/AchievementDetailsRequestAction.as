package com.ankamagames.dofus.logic.game.common.actions.quest
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AchievementDetailsRequestAction implements Action
   {
       
      
      public var achievementId:int;
      
      public function AchievementDetailsRequestAction()
      {
         super();
      }
      
      public static function create(param1:int) : AchievementDetailsRequestAction
      {
         var _loc2_:AchievementDetailsRequestAction = new AchievementDetailsRequestAction();
         _loc2_.achievementId = param1;
         return _loc2_;
      }
   }
}
