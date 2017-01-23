package com.ankamagames.dofus.network.types.game.context.roleplay
{
   public class GameRolePlayGroupMonsterWaveInformations extends GameRolePlayGroupMonsterInformations
   {
       
      
      public function GameRolePlayGroupMonsterWaveInformations()
      {
         super();
      }
      
      public function get nbWaves() : uint
      {
         return new uint();
      }
      
      public function get alternatives() : Vector.<GroupMonsterStaticInformations>
      {
         return new Vector.<GroupMonsterStaticInformations>();
      }
   }
}
