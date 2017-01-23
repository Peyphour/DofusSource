package com.ankamagames.dofus.network.types.game.guild
{
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalInformations;
   import com.ankamagames.dofus.network.types.game.character.status.PlayerStatus;
   
   public class GuildMember extends CharacterMinimalInformations
   {
       
      
      public function GuildMember()
      {
         super();
      }
      
      public function get breed() : int
      {
         return new int();
      }
      
      public function get sex() : Boolean
      {
         return new Boolean();
      }
      
      public function get rank() : uint
      {
         return new uint();
      }
      
      public function get givenExperience() : Number
      {
         return new Number();
      }
      
      public function get experienceGivenPercent() : uint
      {
         return new uint();
      }
      
      public function get rights() : uint
      {
         return new uint();
      }
      
      public function get connected() : uint
      {
         return new uint();
      }
      
      public function get alignmentSide() : int
      {
         return new int();
      }
      
      public function get hoursSinceLastConnection() : uint
      {
         return new uint();
      }
      
      public function get moodSmileyId() : uint
      {
         return new uint();
      }
      
      public function get accountId() : uint
      {
         return new uint();
      }
      
      public function get achievementPoints() : int
      {
         return new int();
      }
      
      public function get status() : PlayerStatus
      {
         return new PlayerStatus();
      }
   }
}
