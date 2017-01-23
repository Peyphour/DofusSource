package d2network
{
   import utils.ReadOnlyData;
   
   public class GuildVersatileInformations extends ReadOnlyData
   {
       
      
      public function GuildVersatileInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get guildId() : uint
      {
         return _target.guildId;
      }
      
      public function get leaderId() : Number
      {
         return _target.leaderId;
      }
      
      public function get guildLevel() : uint
      {
         return _target.guildLevel;
      }
      
      public function get nbMembers() : uint
      {
         return _target.nbMembers;
      }
   }
}
