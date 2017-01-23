package d2data
{
   import utils.ReadOnlyData;
   
   public class GuildWrapper extends ReadOnlyData
   {
       
      
      public function GuildWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get guildId() : uint
      {
         return _target.guildId;
      }
      
      public function get upEmblem() : EmblemWrapper
      {
         return secure(_target.upEmblem);
      }
      
      public function get backEmblem() : EmblemWrapper
      {
         return secure(_target.backEmblem);
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get enabled() : Boolean
      {
         return _target.enabled;
      }
      
      public function get creationDate() : uint
      {
         return _target.creationDate;
      }
      
      public function get leaderId() : Number
      {
         return _target.leaderId;
      }
      
      public function get nbMembers() : uint
      {
         return _target.nbMembers;
      }
      
      public function get nbConnectedMembers() : uint
      {
         return _target.nbConnectedMembers;
      }
      
      public function get experience() : Number
      {
         return _target.experience;
      }
      
      public function get expLevelFloor() : Number
      {
         return _target.expLevelFloor;
      }
      
      public function get expNextLevelFloor() : Number
      {
         return _target.expNextLevelFloor;
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
      
      public function get alliance() : AllianceWrapper
      {
         return secure(_target.alliance);
      }
      
      public function get allianceTag() : String
      {
         return _target.allianceTag;
      }
   }
}
