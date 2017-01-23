package com.ankamagames.dofus.network.types.game.context.roleplay
{
   public class GameRolePlayMerchantInformations extends GameRolePlayNamedActorInformations
   {
       
      
      public function GameRolePlayMerchantInformations()
      {
         super();
      }
      
      public function get sellType() : uint
      {
         return new uint();
      }
      
      public function get options() : Vector.<HumanOption>
      {
         return new Vector.<HumanOption>();
      }
   }
}
