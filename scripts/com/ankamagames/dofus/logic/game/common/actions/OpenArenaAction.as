package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OpenArenaAction implements Action
   {
       
      
      public function OpenArenaAction()
      {
         super();
      }
      
      public static function create() : OpenArenaAction
      {
         var _loc1_:OpenArenaAction = new OpenArenaAction();
         return _loc1_;
      }
   }
}
