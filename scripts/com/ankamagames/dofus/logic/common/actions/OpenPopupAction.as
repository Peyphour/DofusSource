package com.ankamagames.dofus.logic.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OpenPopupAction implements Action
   {
       
      
      public var messageToShow:String;
      
      public function OpenPopupAction()
      {
         super();
      }
      
      public static function create(param1:String = "") : OpenPopupAction
      {
         var _loc2_:OpenPopupAction = new OpenPopupAction();
         _loc2_.messageToShow = param1;
         return _loc2_;
      }
   }
}
