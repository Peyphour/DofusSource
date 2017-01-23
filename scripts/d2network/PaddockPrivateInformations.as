package d2network
{
   public class PaddockPrivateInformations extends PaddockAbandonnedInformations
   {
       
      
      public function PaddockPrivateInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get guildInfo() : GuildInformations
      {
         return secure(_target.guildInfo);
      }
   }
}
