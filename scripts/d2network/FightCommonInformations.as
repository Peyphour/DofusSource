package d2network
{
   import utils.ReadOnlyData;
   
   public class FightCommonInformations extends ReadOnlyData
   {
       
      
      public function FightCommonInformations(param1:*, param2:Object)
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
      
      public function get fightTeams() : Object
      {
         return secure(_target.fightTeams);
      }
      
      public function get fightTeamsPositions() : Object
      {
         return secure(_target.fightTeamsPositions);
      }
      
      public function get fightTeamsOptions() : Object
      {
         return secure(_target.fightTeamsOptions);
      }
   }
}
