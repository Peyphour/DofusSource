package d2data
{
   import utils.ReadOnlyData;
   
   public class GuildFactSheetWrapper extends ReadOnlyData
   {
       
      
      public function GuildFactSheetWrapper(param1:*, param2:Object)
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
      
      public function get leaderId() : Number
      {
         return _target.leaderId;
      }
      
      public function get guildLevel() : uint
      {
         return _target.guildLevel;
      }
      
      public function get nbMembers() : uint
      {
         return _target.nbMembers;
      }
      
      public function get creationDate() : Number
      {
         return _target.creationDate;
      }
      
      public function get members() : Object
      {
         return secure(_target.members);
      }
      
      public function get allianceId() : uint
      {
         return _target.allianceId;
      }
      
      public function get allianceLeader() : Boolean
      {
         return _target.allianceLeader;
      }
      
      public function get nbConnectedMembers() : uint
      {
         return _target.nbConnectedMembers;
      }
      
      public function get nbTaxCollectors() : uint
      {
         return _target.nbTaxCollectors;
      }
      
      public function get lastActivity() : Number
      {
         return _target.lastActivity;
      }
      
      public function get enabled() : Boolean
      {
         return _target.enabled;
      }
      
      public function get hoursSinceLastConnection() : Number
      {
         return _target.hoursSinceLastConnection;
      }
   }
}
