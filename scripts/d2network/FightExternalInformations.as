package d2network
{
   import utils.ReadOnlyData;
   
   public class FightExternalInformations extends ReadOnlyData
   {
       
      
      public function FightExternalInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get fightId() : int
      {
         return _target.fightId;
      }
      
      public function get fightType() : uint
      {
         return _target.fightType;
      }
      
      public function get fightStart() : uint
      {
         return _target.fightStart;
      }
      
      public function get fightSpectatorLocked() : Boolean
      {
         return _target.fightSpectatorLocked;
      }
      
      public function get fightTeams() : Object
      {
         return secure(_target.fightTeams);
      }
      
      public function get fightTeamsOptions() : Object
      {
         return secure(_target.fightTeamsOptions);
      }
   }
}
