package d2network
{
   import utils.ReadOnlyData;
   
   public class AllianceVersatileInformations extends ReadOnlyData
   {
       
      
      public function AllianceVersatileInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get allianceId() : uint
      {
         return _target.allianceId;
      }
      
      public function get nbGuilds() : uint
      {
         return _target.nbGuilds;
      }
      
      public function get nbMembers() : uint
      {
         return _target.nbMembers;
      }
      
      public function get nbSubarea() : uint
      {
         return _target.nbSubarea;
      }
   }
}
