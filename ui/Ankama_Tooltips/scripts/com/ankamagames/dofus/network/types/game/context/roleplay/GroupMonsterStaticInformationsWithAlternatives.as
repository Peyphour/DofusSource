package com.ankamagames.dofus.network.types.game.context.roleplay
{
   public class GroupMonsterStaticInformationsWithAlternatives extends GroupMonsterStaticInformations
   {
       
      
      public function GroupMonsterStaticInformationsWithAlternatives()
      {
         super();
      }
      
      public function get alternatives() : Vector.<AlternativeMonstersInGroupLightInformations>
      {
         return new Vector.<AlternativeMonstersInGroupLightInformations>();
      }
   }
}
