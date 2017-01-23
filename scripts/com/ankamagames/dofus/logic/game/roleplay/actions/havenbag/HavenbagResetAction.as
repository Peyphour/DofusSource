package com.ankamagames.dofus.logic.game.roleplay.actions.havenbag
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HavenbagResetAction implements Action
   {
       
      
      public function HavenbagResetAction()
      {
         super();
      }
      
      public static function create() : HavenbagResetAction
      {
         var _loc1_:HavenbagResetAction = new HavenbagResetAction();
         return _loc1_;
      }
   }
}
