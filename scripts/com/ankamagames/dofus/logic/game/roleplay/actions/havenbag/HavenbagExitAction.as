package com.ankamagames.dofus.logic.game.roleplay.actions.havenbag
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HavenbagExitAction implements Action
   {
       
      
      public function HavenbagExitAction()
      {
         super();
      }
      
      public static function create() : HavenbagExitAction
      {
         var _loc1_:HavenbagExitAction = new HavenbagExitAction();
         return _loc1_;
      }
   }
}
