package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.types.game.social.AbstractSocialGroupInfos;
   
   public class BasicGuildInformations extends AbstractSocialGroupInfos
   {
       
      
      public function BasicGuildInformations()
      {
         super();
      }
      
      public function get guildId() : uint
      {
         return new uint();
      }
      
      public function get guildName() : String
      {
         return new String();
      }
      
      public function get guildLevel() : uint
      {
         return new uint();
      }
   }
}
