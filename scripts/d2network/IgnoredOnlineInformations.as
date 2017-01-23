package d2network
{
   public class IgnoredOnlineInformations extends IgnoredInformations
   {
       
      
      public function IgnoredOnlineInformations(param1:*, param2:Object)
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
      
      public function get breed() : int
      {
         return _target.breed;
      }
      
      public function get sex() : Boolean
      {
         return _target.sex;
      }
   }
}
