package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GameFightSpellCastAction implements Action
   {
       
      
      public var spellId:uint;
      
      public function GameFightSpellCastAction()
      {
         super();
      }
      
      public static function create(param1:uint) : GameFightSpellCastAction
      {
         var _loc2_:GameFightSpellCastAction = new GameFightSpellCastAction();
         _loc2_.spellId = param1;
         return _loc2_;
      }
   }
}
