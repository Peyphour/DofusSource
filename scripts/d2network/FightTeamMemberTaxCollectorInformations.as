package d2network
{
   public class FightTeamMemberTaxCollectorInformations extends FightTeamMemberInformations
   {
       
      
      public function FightTeamMemberTaxCollectorInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get firstNameId() : uint
      {
         return _target.firstNameId;
      }
      
      public function get lastNameId() : uint
      {
         return _target.lastNameId;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
      
      public function get guildId() : uint
      {
         return _target.guildId;
      }
      
      public function get uid() : uint
      {
         return _target.uid;
      }
   }
}
