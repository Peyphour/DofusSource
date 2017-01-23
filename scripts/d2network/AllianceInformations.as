package d2network
{
   public class AllianceInformations extends BasicNamedAllianceInformations
   {
       
      
      public function AllianceInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get allianceEmblem() : GuildEmblem
      {
         return secure(_target.allianceEmblem);
      }
   }
}
