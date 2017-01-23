package com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TreasureHuntGiveUpRequestAction implements Action
   {
       
      
      public var questType:int;
      
      public function TreasureHuntGiveUpRequestAction()
      {
         super();
      }
      
      public static function create(param1:int) : TreasureHuntGiveUpRequestAction
      {
         var _loc2_:TreasureHuntGiveUpRequestAction = new TreasureHuntGiveUpRequestAction();
         _loc2_.questType = param1;
         return _loc2_;
      }
   }
}
