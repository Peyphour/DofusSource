package com.ankamagames.dofus.logic.game.common.actions.dare
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class DareListRequestAction implements Action
   {
       
      
      public function DareListRequestAction()
      {
         super();
      }
      
      public static function create() : DareListRequestAction
      {
         var _loc1_:DareListRequestAction = new DareListRequestAction();
         return _loc1_;
      }
   }
}
