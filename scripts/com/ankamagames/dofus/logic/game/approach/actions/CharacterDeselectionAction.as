package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterDeselectionAction implements Action
   {
       
      
      public function CharacterDeselectionAction()
      {
         super();
      }
      
      public static function create() : CharacterDeselectionAction
      {
         var _loc1_:CharacterDeselectionAction = new CharacterDeselectionAction();
         return _loc1_;
      }
   }
}
