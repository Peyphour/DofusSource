package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GameContextKickAction implements Action
   {
       
      
      public var targetId:Number;
      
      public function GameContextKickAction()
      {
         super();
      }
      
      public static function create(param1:Number) : GameContextKickAction
      {
         var _loc2_:GameContextKickAction = new GameContextKickAction();
         _loc2_.targetId = param1;
         return _loc2_;
      }
   }
}
