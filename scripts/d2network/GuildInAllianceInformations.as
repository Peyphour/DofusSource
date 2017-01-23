package d2network
{
   public class GuildInAllianceInformations extends GuildInformations
   {
       
      
      public function GuildInAllianceInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get nbMembers() : uint
      {
         return _target.nbMembers;
      }
      
      public function get enabled() : Boolean
      {
         return _target.enabled;
      }
   }
}
