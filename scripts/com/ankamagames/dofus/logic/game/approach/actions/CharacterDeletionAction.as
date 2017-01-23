package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterDeletionAction implements Action
   {
       
      
      public var id:Number;
      
      public var answer:String;
      
      public function CharacterDeletionAction()
      {
         super();
      }
      
      public static function create(param1:Number, param2:String) : CharacterDeletionAction
      {
         var _loc3_:CharacterDeletionAction = new CharacterDeletionAction();
         _loc3_.id = param1;
         _loc3_.answer = param2;
         return _loc3_;
      }
   }
}
