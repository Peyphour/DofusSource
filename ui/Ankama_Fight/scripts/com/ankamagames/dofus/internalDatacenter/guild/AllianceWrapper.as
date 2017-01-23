package com.ankamagames.dofus.internalDatacenter.guild
{
   public class AllianceWrapper
   {
       
      
      public function AllianceWrapper()
      {
         super();
      }
      
      public function get allianceId() : uint
      {
         return new uint();
      }
      
      public function get upEmblem() : EmblemWrapper
      {
         return new EmblemWrapper();
      }
      
      public function get backEmblem() : EmblemWrapper
      {
         return new EmblemWrapper();
      }
      
      public function get creationDate() : uint
      {
         return new uint();
      }
      
      public function get nbGuilds() : uint
      {
         return new uint();
      }
      
      public function get nbMembers() : uint
      {
         return new uint();
      }
      
      public function get nbSubareas() : uint
      {
         return new uint();
      }
      
      public function get leaderGuildId() : uint
      {
         return new uint();
      }
      
      public function get leaderCharacterId() : Number
      {
         return new Number();
      }
      
      public function get leaderCharacterName() : String
      {
         return new String();
      }
      
      public function get motd() : String
      {
         return new String();
      }
      
      public function get formattedMotd() : String
      {
         return new String();
      }
      
      public function get motdWriterId() : Number
      {
         return new Number();
      }
      
      public function get motdWriterName() : String
      {
         return new String();
      }
      
      public function get motdTimestamp() : Number
      {
         return new Number();
      }
      
      public function get bulletin() : String
      {
         return new String();
      }
      
      public function get formattedBulletin() : String
      {
         return new String();
      }
      
      public function get bulletinWriterId() : Number
      {
         return new Number();
      }
      
      public function get bulletinWriterName() : String
      {
         return new String();
      }
      
      public function get bulletinTimestamp() : Number
      {
         return new Number();
      }
      
      public function get lastNotifiedTimestamp() : Number
      {
         return new Number();
      }
      
      public function get guilds() : Vector.<GuildFactSheetWrapper>
      {
         return new Vector.<GuildFactSheetWrapper>();
      }
      
      public function get prismIds() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get allianceTag() : String
      {
         return null;
      }
      
      public function get realAllianceTag() : String
      {
         return null;
      }
      
      public function get allianceName() : String
      {
         return null;
      }
      
      public function get realAllianceName() : String
      {
         return null;
      }
      
      public function get memberRightsNumber() : uint
      {
         return 0;
      }
      
      public function get memberRights() : Object
      {
         return null;
      }
      
      public function get isBoss() : Boolean
      {
         return false;
      }
   }
}
