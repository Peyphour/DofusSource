package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class SurveyNotificationAnswerAction implements Action
   {
       
      
      public var surveyId:uint;
      
      public var accept:Boolean;
      
      public function SurveyNotificationAnswerAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Boolean) : SurveyNotificationAnswerAction
      {
         var _loc3_:SurveyNotificationAnswerAction = new SurveyNotificationAnswerAction();
         _loc3_.surveyId = param1;
         _loc3_.accept = param2;
         return _loc3_;
      }
   }
}
