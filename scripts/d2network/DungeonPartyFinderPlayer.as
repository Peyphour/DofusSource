package d2network
{
   import utils.ReadOnlyData;
   
   public class DungeonPartyFinderPlayer extends ReadOnlyData
   {
       
      
      public function DungeonPartyFinderPlayer(param1:*, param2:Object)
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
      
      public function get level() : uint
      {
         return _target.level;
      }
   }
}
