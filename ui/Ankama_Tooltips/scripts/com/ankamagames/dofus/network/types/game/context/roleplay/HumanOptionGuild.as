package com.ankamagames.dofus.network.types.game.context.roleplay
{
   public class HumanOptionGuild extends HumanOption
   {
       
      
      public function HumanOptionGuild()
      {
         super();
      }
      
      public function get guildInformations() : GuildInformations
      {
         return new GuildInformations();
      }
   }
}
