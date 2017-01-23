package d2network
{
   public class HumanOptionGuild extends HumanOption
   {
       
      
      public function HumanOptionGuild(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get guildInformations() : GuildInformations
      {
         return secure(_target.guildInformations);
      }
   }
}
