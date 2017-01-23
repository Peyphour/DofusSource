package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   
   public class MonsterInGroupInformations extends MonsterInGroupLightInformations
   {
       
      
      public function MonsterInGroupInformations()
      {
         super();
      }
      
      public function get look() : EntityLook
      {
         return new EntityLook();
      }
   }
}
