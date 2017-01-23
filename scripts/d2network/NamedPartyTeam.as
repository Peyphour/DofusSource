package d2network
{
   import utils.ReadOnlyData;
   
   public class NamedPartyTeam extends ReadOnlyData
   {
       
      
      public function NamedPartyTeam(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get teamId() : uint
      {
         return _target.teamId;
      }
      
      public function get partyName() : String
      {
         return _target.partyName;
      }
   }
}
