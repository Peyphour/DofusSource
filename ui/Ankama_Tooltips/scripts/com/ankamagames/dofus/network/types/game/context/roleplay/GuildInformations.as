package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   
   public class GuildInformations extends BasicGuildInformations
   {
       
      
      public function GuildInformations()
      {
         super();
      }
      
      public function get guildEmblem() : GuildEmblem
      {
         return new GuildEmblem();
      }
   }
}
