package com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TreasureHuntLegendaryRequestAction implements Action
   {
       
      
      public var legendaryId:int;
      
      public function TreasureHuntLegendaryRequestAction()
      {
         super();
      }
      
      public static function create(param1:int) : TreasureHuntLegendaryRequestAction
      {
         var _loc2_:TreasureHuntLegendaryRequestAction = new TreasureHuntLegendaryRequestAction();
         _loc2_.legendaryId = param1;
         return _loc2_;
      }
   }
}
