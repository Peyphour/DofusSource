package d2network
{
   public class FriendInformations extends AbstractContactInformations
   {
       
      
      public function FriendInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get playerState() : uint
      {
         return _target.playerState;
      }
      
      public function get lastConnection() : uint
      {
         return _target.lastConnection;
      }
      
      public function get achievementPoints() : int
      {
         return _target.achievementPoints;
      }
   }
}
