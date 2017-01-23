package d2network
{
   public class GuildInformations extends BasicGuildInformations
   {
       
      
      public function GuildInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get guildEmblem() : GuildEmblem
      {
         return secure(_target.guildEmblem);
      }
   }
}
