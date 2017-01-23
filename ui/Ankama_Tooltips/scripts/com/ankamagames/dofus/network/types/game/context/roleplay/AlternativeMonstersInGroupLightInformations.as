package com.ankamagames.dofus.network.types.game.context.roleplay
{
   public class AlternativeMonstersInGroupLightInformations
   {
       
      
      public function AlternativeMonstersInGroupLightInformations()
      {
         super();
      }
      
      public function get playerCount() : int
      {
         return new int();
      }
      
      public function get monsters() : Vector.<MonsterInGroupLightInformations>
      {
         return new Vector.<MonsterInGroupLightInformations>();
      }
   }
}
