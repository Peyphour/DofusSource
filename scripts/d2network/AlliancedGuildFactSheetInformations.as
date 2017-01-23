package d2network
{
   public class AlliancedGuildFactSheetInformations extends GuildInformations
   {
       
      
      public function AlliancedGuildFactSheetInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get allianceInfos() : BasicNamedAllianceInformations
      {
         return secure(_target.allianceInfos);
      }
   }
}
