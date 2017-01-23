package com.ankamagames.dofus.network.types.game.context.roleplay
{
   public class GroupMonsterStaticInformations
   {
       
      
      public function GroupMonsterStaticInformations()
      {
         super();
      }
      
      public function get mainCreatureLightInfos() : MonsterInGroupLightInformations
      {
         return new MonsterInGroupLightInformations();
      }
      
      public function get underlings() : Vector.<MonsterInGroupInformations>
      {
         return new Vector.<MonsterInGroupInformations>();
      }
   }
}
