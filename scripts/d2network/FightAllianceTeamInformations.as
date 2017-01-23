package d2network
{
   public class FightAllianceTeamInformations extends FightTeamInformations
   {
       
      
      public function FightAllianceTeamInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get relation() : uint
      {
         return _target.relation;
      }
   }
}
