package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   
   public class GameFightFighterInformations extends GameContextActorInformations
   {
       
      
      public function GameFightFighterInformations()
      {
         super();
      }
      
      public function get teamId() : uint
      {
         return new uint();
      }
      
      public function get wave() : uint
      {
         return new uint();
      }
      
      public function get alive() : Boolean
      {
         return new Boolean();
      }
      
      public function get stats() : GameFightMinimalStats
      {
         return new GameFightMinimalStats();
      }
      
      public function get previousPositions() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
   }
}
