package com.ankamagames.dofus.logic.game.common.actions.taxCollector
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GameRolePlayTaxCollectorFightRequestAction implements Action
   {
       
      
      public var taxCollectorId:uint;
      
      public function GameRolePlayTaxCollectorFightRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : GameRolePlayTaxCollectorFightRequestAction
      {
         var _loc2_:GameRolePlayTaxCollectorFightRequestAction = new GameRolePlayTaxCollectorFightRequestAction();
         _loc2_.taxCollectorId = param1;
         return _loc2_;
      }
   }
}
