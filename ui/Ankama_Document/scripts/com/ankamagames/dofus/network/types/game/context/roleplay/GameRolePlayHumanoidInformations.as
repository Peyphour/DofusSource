package com.ankamagames.dofus.network.types.game.context.roleplay
{
   public class GameRolePlayHumanoidInformations extends GameRolePlayNamedActorInformations
   {
       
      
      public function GameRolePlayHumanoidInformations()
      {
         super();
      }
      
      public function get humanoidInfo() : HumanInformations
      {
         return new HumanInformations();
      }
      
      public function get accountId() : uint
      {
         return new uint();
      }
   }
}
