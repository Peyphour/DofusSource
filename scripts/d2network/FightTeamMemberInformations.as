package d2network
{
   import utils.ReadOnlyData;
   
   public class FightTeamMemberInformations extends ReadOnlyData
   {
       
      
      public function FightTeamMemberInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : Number
      {
         return _target.id;
      }
   }
}
