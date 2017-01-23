package com.ankamagames.dofus.network.types.game.character
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.BasicAllianceInformations;
   
   public class CharacterMinimalAllianceInformations extends CharacterMinimalGuildInformations
   {
       
      
      public function CharacterMinimalAllianceInformations()
      {
         super();
      }
      
      public function get alliance() : BasicAllianceInformations
      {
         return new BasicAllianceInformations();
      }
   }
}
