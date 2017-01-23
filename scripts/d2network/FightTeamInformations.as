package d2network
{
   public class FightTeamInformations extends AbstractFightTeamInformations
   {
       
      
      public function FightTeamInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get teamMembers() : Object
      {
         return secure(_target.teamMembers);
      }
   }
}
