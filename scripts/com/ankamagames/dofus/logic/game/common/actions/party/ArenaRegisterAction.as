package com.ankamagames.dofus.logic.game.common.actions.party
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ArenaRegisterAction implements Action
   {
       
      
      public var fightTypeId:uint;
      
      public function ArenaRegisterAction()
      {
         super();
      }
      
      public static function create(param1:uint) : ArenaRegisterAction
      {
         var _loc2_:ArenaRegisterAction = new ArenaRegisterAction();
         _loc2_.fightTypeId = param1;
         return _loc2_;
      }
   }
}
