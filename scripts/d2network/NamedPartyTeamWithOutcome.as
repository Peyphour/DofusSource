package d2network
{
   import utils.ReadOnlyData;
   
   public class NamedPartyTeamWithOutcome extends ReadOnlyData
   {
       
      
      public function NamedPartyTeamWithOutcome(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get team() : NamedPartyTeam
      {
         return secure(_target.team);
      }
      
      public function get outcome() : uint
      {
         return _target.outcome;
      }
   }
}
