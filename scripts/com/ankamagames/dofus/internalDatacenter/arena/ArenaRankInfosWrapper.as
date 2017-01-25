package com.ankamagames.dofus.internalDatacenter.arena
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.fight.arena.ArenaRankInfos;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class ArenaRankInfosWrapper implements IDataCenter
   {
       
      
      public var rank:int;
      
      public var maxRank:int;
      
      public var todayFightCount:int;
      
      public var todayVictoryCount:int;
      
      public function ArenaRankInfosWrapper()
      {
         super();
      }
      
      public static function create(param1:ArenaRankInfos) : ArenaRankInfosWrapper
      {
         var _loc2_:ArenaRankInfosWrapper = new ArenaRankInfosWrapper();
         _loc2_.rank = param1.rank;
         _loc2_.maxRank = param1.bestRank;
         _loc2_.todayFightCount = param1.fightcount;
         _loc2_.todayVictoryCount = param1.victoryCount;
         return _loc2_;
      }
   }
}
