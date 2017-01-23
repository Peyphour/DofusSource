package d2data
{
   import utils.ReadOnlyData;
   
   public class IgnoredWrapper extends ReadOnlyData
   {
       
      
      public function IgnoredWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get accountId() : uint
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
      
      public function get breed() : uint
      {
         return _target.breed;
      }
      
      public function get sex() : uint
      {
         return _target.sex;
      }
      
      public function get level() : int
      {
         return _target.level;
      }
      
      public function get alignmentSide() : int
      {
         return _target.alignmentSide;
      }
      
      public function get guildName() : String
      {
         return _target.guildName;
      }
      
      public function get achievementPoints() : int
      {
         return _target.achievementPoints;
      }
   }
}
