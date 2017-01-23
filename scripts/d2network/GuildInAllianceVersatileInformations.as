package d2network
{
   public class GuildInAllianceVersatileInformations extends GuildVersatileInformations
   {
       
      
      public function GuildInAllianceVersatileInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get allianceId() : uint
      {
         return _target.allianceId;
      }
   }
}
