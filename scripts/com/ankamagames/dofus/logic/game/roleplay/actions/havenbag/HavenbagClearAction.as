package com.ankamagames.dofus.logic.game.roleplay.actions.havenbag
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HavenbagClearAction implements Action
   {
       
      
      public function HavenbagClearAction()
      {
         super();
      }
      
      public static function create() : HavenbagClearAction
      {
         var _loc1_:HavenbagClearAction = new HavenbagClearAction();
         return _loc1_;
      }
   }
}
