package d2data
{
   import utils.ReadOnlyData;
   
   public class AllianceWrapper extends ReadOnlyData
   {
       
      
      public function AllianceWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get allianceId() : uint
      {
         return _target.allianceId;
      }
      
      public function get upEmblem() : EmblemWrapper
      {
         return secure(_target.upEmblem);
      }
      
      public function get backEmblem() : EmblemWrapper
      {
         return secure(_target.backEmblem);
      }
      
      public function get enabled() : Boolean
      {
         return _target.enabled;
      }
      
      public function get creationDate() : uint
      {
         return _target.creationDate;
      }
      
      public function get nbGuilds() : uint
      {
         return _target.nbGuilds;
      }
      
      public function get nbMembers() : uint
      {
         return _target.nbMembers;
      }
      
      public function get nbSubareas() : uint
      {
         return _target.nbSubareas;
      }
      
      public function get leaderGuildId() : uint
      {
         return _target.leaderGuildId;
      }
      
      public function get leaderCharacterId() : Number
      {
         return _target.leaderCharacterId;
      }
      
      public function get leaderCharacterName() : String
      {
         return _target.leaderCharacterName;
      }
      
      public function get motd() : String
      {
         return _target.motd;
      }
      
      public function get formattedMotd() : String
      {
         return _target.formattedMotd;
      }
      
      public function get motdWriterId() : Number
      {
         return _target.motdWriterId;
      }
      
      public function get motdWriterName() : String
      {
         return _target.motdWriterName;
      }
      
      public function get motdTimestamp() : Number
      {
         return _target.motdTimestamp;
      }
      
      public function get bulletin() : String
      {
         return _target.bulletin;
      }
      
      public function get formattedBulletin() : String
      {
         return _target.formattedBulletin;
      }
      
      public function get bulletinWriterId() : Number
      {
         return _target.bulletinWriterId;
      }
      
      public function get bulletinWriterName() : String
      {
         return _target.bulletinWriterName;
      }
      
      public function get bulletinTimestamp() : Number
      {
         return _target.bulletinTimestamp;
      }
      
      public function get lastNotifiedTimestamp() : Number
      {
         return _target.lastNotifiedTimestamp;
      }
      
      public function get guilds() : Object
      {
         return secure(_target.guilds);
      }
      
      public function get prismIds() : Object
      {
         return secure(_target.prismIds);
      }
   }
}
