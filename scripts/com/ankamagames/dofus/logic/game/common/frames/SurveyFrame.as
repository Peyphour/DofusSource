package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.dofus.logic.game.common.actions.SurveyNotificationAnswerAction;
   import com.ankamagames.dofus.misc.utils.SurveyManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   
   public class SurveyFrame implements Frame
   {
       
      
      public function SurveyFrame()
      {
         super();
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:SurveyNotificationAnswerAction = null;
         switch(true)
         {
            case param1 is SurveyNotificationAnswerAction:
               _loc2_ = param1 as SurveyNotificationAnswerAction;
               SurveyManager.getInstance().markSurveyAsDone(_loc2_.surveyId,_loc2_.accept);
               return true;
            default:
               return false;
         }
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
   }
}
