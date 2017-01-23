package d2network
{
   public class PartyMemberArenaInformations extends PartyMemberInformations
   {
       
      
      public function PartyMemberArenaInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get rank() : uint
      {
         return _target.rank;
      }
   }
}
