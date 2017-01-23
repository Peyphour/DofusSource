package com.ankamagames.dofus.logic.game.roleplay.actions.havenbag
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HavenbagSaveAction implements Action
   {
       
      
      public function HavenbagSaveAction()
      {
         super();
      }
      
      public static function create() : HavenbagSaveAction
      {
         var _loc1_:HavenbagSaveAction = new HavenbagSaveAction();
         return _loc1_;
      }
   }
}
