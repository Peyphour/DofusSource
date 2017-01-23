package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.dofus.network.types.game.character.alignment.ActorAlignmentInformations;
   
   public class GameRolePlayCharacterInformations extends GameRolePlayHumanoidInformations
   {
       
      
      public function GameRolePlayCharacterInformations()
      {
         super();
      }
      
      public function get alignmentInfos() : ActorAlignmentInformations
      {
         return new ActorAlignmentInformations();
      }
   }
}
