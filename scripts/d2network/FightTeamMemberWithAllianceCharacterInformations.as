package d2network
{
   public class FightTeamMemberWithAllianceCharacterInformations extends FightTeamMemberCharacterInformations
   {
       
      
      public function FightTeamMemberWithAllianceCharacterInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get allianceInfos() : BasicAllianceInformations
      {
         return secure(_target.allianceInfos);
      }
   }
}
