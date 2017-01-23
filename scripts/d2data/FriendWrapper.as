package d2data
{
   import utils.ReadOnlyData;
   
   public class FriendWrapper extends ReadOnlyData
   {
       
      
      public function FriendWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get accountId() : int
      {
         return _target.accountId;
      }
      
      public function get state() : int
      {
         return _target.state;
      }
      
      public function get lastConnection() : uint
      {
         return _target.lastConnection;
      }
      
      public function get online() : Boolean
      {
         return _target.online;
      }
      
      public function get type() : String
      {
         return _target.type;
      }
      
      public function get playerId() : Number
      {
         return _target.playerId;
      }
      
      public function get playerName() : String
      {
         return _target.playerName;
      }
      
      public function get level() : int
      {
         return _target.level;
      }
      
      public function get moodSmileyId() : int
      {
         return _target.moodSmileyId;
      }
      
      public function get alignmentSide() : int
      {
         return _target.alignmentSide;
      }
      
      public function get breed() : uint
      {
         return _target.breed;
      }
      
      public function get sex() : uint
      {
         return _target.sex;
      }
      
      public function get realGuildName() : String
      {
         return _target.realGuildName;
      }
      
      public function get guildName() : String
      {
         return _target.guildName;
      }
      
      public function get guildId() : int
      {
         return _target.guildId;
      }
      
      public function get guildUpEmblem() : EmblemWrapper
      {
         return secure(_target.guildUpEmblem);
      }
      
      public function get guildBackEmblem() : EmblemWrapper
      {
         return secure(_target.guildBackEmblem);
      }
      
      public function get achievementPoints() : int
      {
         return _target.achievementPoints;
      }
      
      public function get statusId() : uint
      {
         return _target.statusId;
      }
      
      public function get awayMessage() : String
      {
         return _target.awayMessage;
      }
   }
}
