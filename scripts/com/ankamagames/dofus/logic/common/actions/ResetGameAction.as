package com.ankamagames.dofus.logic.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ResetGameAction implements Action
   {
       
      
      public var messageToShow:String;
      
      public function ResetGameAction()
      {
         super();
      }
      
      public static function create(param1:String = "") : ResetGameAction
      {
         var _loc2_:ResetGameAction = new ResetGameAction();
         _loc2_.messageToShow = param1;
         return _loc2_;
      }
   }
}
