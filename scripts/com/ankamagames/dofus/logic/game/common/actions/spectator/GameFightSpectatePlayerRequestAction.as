package com.ankamagames.dofus.logic.game.common.actions.spectator
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GameFightSpectatePlayerRequestAction implements Action
   {
       
      
      public var playerId:Number;
      
      public function GameFightSpectatePlayerRequestAction()
      {
         super();
      }
      
      public static function create(param1:Number) : GameFightSpectatePlayerRequestAction
      {
         var _loc2_:GameFightSpectatePlayerRequestAction = new GameFightSpectatePlayerRequestAction();
         _loc2_.playerId = param1;
         return _loc2_;
      }
   }
}
