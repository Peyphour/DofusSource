package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.types.game.guild.GuildEmblem;
   
   public class AllianceInformations extends BasicNamedAllianceInformations
   {
       
      
      public function AllianceInformations()
      {
         super();
      }
      
      public function get allianceEmblem() : GuildEmblem
      {
         return new GuildEmblem();
      }
   }
}
