package d2network
{
   public class FightTeamMemberCharacterInformations extends FightTeamMemberInformations
   {
       
      
      public function FightTeamMemberCharacterInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get name() : String
      {
         return _target.name;
      }
      
      public function get level() : uint
      {
         return _target.level;
      }
   }
}
