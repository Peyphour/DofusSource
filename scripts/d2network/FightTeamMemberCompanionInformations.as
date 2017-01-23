package d2network
{
   public class FightTeamMemberCompanionInformations extends FightTeamMemberInformations
   {
       
      
      public function FightTeamMemberCompanionInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get companionId() : uint
      {
         return _target.companionId;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get masterId() : int
      {
         return _target.masterId;
      }
   }
}
