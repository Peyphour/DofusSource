package d2network
{
   public class HouseInformationsExtended extends HouseInformations
   {
       
      
      public function HouseInformationsExtended(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get guildInfo() : GuildInformations
      {
         return secure(_target.guildInfo);
      }
   }
}
