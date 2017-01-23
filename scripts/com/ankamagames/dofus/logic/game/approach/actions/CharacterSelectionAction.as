package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterSelectionAction implements Action
   {
       
      
      public var characterId:Number;
      
      public var btutoriel:Boolean;
      
      public function CharacterSelectionAction()
      {
         super();
      }
      
      public static function create(param1:Number, param2:Boolean) : CharacterSelectionAction
      {
         var _loc3_:CharacterSelectionAction = new CharacterSelectionAction();
         _loc3_.characterId = param1;
         _loc3_.btutoriel = param2;
         return _loc3_;
      }
   }
}
