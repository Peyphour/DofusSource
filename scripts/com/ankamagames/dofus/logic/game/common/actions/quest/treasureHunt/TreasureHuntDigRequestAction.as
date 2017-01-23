package com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TreasureHuntDigRequestAction implements Action
   {
       
      
      public var questType:int;
      
      public function TreasureHuntDigRequestAction()
      {
         super();
      }
      
      public static function create(param1:int) : TreasureHuntDigRequestAction
      {
         var _loc2_:TreasureHuntDigRequestAction = new TreasureHuntDigRequestAction();
         _loc2_.questType = param1;
         return _loc2_;
      }
   }
}
