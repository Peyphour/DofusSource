package d2network
{
   public class FightTeamLightInformations extends AbstractFightTeamInformations
   {
       
      
      public function FightTeamLightInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get teamMembersCount() : uint
      {
         return _target.teamMembersCount;
      }
      
      public function get meanLevel() : uint
      {
         return _target.meanLevel;
      }
      
      public function get hasFriend() : Boolean
      {
         return _target.hasFriend;
      }
      
      public function get hasGuildMember() : Boolean
      {
         return _target.hasGuildMember;
      }
      
      public function get hasAllianceMember() : Boolean
      {
         return _target.hasAllianceMember;
      }
      
      public function get hasGroupMember() : Boolean
      {
         return _target.hasGroupMember;
      }
      
      public function get hasMyTaxCollector() : Boolean
      {
         return _target.hasMyTaxCollector;
      }
   }
}
