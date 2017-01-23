package d2network
{
   public class GuildInsiderFactSheetInformations extends GuildFactSheetInformations
   {
       
      
      public function GuildInsiderFactSheetInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get leaderName() : String
      {
         return _target.leaderName;
      }
      
      public function get nbConnectedMembers() : uint
      {
         return _target.nbConnectedMembers;
      }
      
      public function get nbTaxCollectors() : uint
      {
         return _target.nbTaxCollectors;
      }
      
      public function get lastActivity() : uint
      {
         return _target.lastActivity;
      }
      
      public function get enabled() : Boolean
      {
         return _target.enabled;
      }
   }
}
