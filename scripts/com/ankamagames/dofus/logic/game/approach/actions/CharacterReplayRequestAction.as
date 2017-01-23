package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterReplayRequestAction implements Action
   {
       
      
      public var characterId:Number;
      
      public function CharacterReplayRequestAction()
      {
         super();
      }
      
      public static function create(param1:Number) : CharacterReplayRequestAction
      {
         var _loc2_:CharacterReplayRequestAction = new CharacterReplayRequestAction();
         _loc2_.characterId = param1;
         return _loc2_;
      }
   }
}
