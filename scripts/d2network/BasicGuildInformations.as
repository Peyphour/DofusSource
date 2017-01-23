package d2network
{
   public class BasicGuildInformations extends AbstractSocialGroupInfos
   {
       
      
      public function BasicGuildInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get guildId() : uint
      {
         return _target.guildId;
      }
      
      public function get guildName() : String
      {
         return _target.guildName;
      }
      
      public function get guildLevel() : uint
      {
         return _target.guildLevel;
      }
   }
}
