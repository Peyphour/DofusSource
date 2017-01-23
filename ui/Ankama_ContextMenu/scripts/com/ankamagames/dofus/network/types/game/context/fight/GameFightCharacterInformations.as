package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.dofus.network.types.game.character.alignment.ActorAlignmentInformations;
   
   public class GameFightCharacterInformations extends GameFightFighterNamedInformations
   {
       
      
      public function GameFightCharacterInformations()
      {
         super();
      }
      
      public function get level() : uint
      {
         return new uint();
      }
      
      public function get alignmentInfos() : ActorAlignmentInformations
      {
         return new ActorAlignmentInformations();
      }
      
      public function get breed() : int
      {
         return new int();
      }
      
      public function get sex() : Boolean
      {
         return new Boolean();
      }
   }
}
