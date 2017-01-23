package d2network
{
   public class FightTeamMemberMonsterInformations extends FightTeamMemberInformations
   {
       
      
      public function FightTeamMemberMonsterInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get monsterId() : int
      {
         return _target.monsterId;
      }
      
      public function get grade() : uint
      {
         return _target.grade;
      }
   }
}
