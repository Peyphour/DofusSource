package com.ankamagames.dofus.network.types.game.character
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.BasicGuildInformations;
   
   public class CharacterMinimalGuildInformations extends CharacterMinimalPlusLookInformations
   {
       
      
      public function CharacterMinimalGuildInformations()
      {
         super();
      }
      
      public function get guild() : BasicGuildInformations
      {
         return new BasicGuildInformations();
      }
   }
}
