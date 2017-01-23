package d2network
{
   public class FriendOnlineInformations extends FriendInformations
   {
       
      
      public function FriendOnlineInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get playerId() : Number
      {
         return _target.playerId;
      }
      
      public function get playerName() : String
      {
         return _target.playerName;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get alignmentSide() : int
      {
         return _target.alignmentSide;
      }
      
      public function get breed() : int
      {
         return _target.breed;
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
      
      public function get guildInfo() : GuildInformations
      {
         return secure(_target.guildInfo);
      }
      
      public function get moodSmileyId() : uint
      {
         return _target.moodSmileyId;
      }
      
      public function get status() : PlayerStatus
      {
         return secure(_target.status);
      }
   }
}
