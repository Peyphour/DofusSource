package d2network
{
   import utils.ReadOnlyData;
   
   public class TaxCollectorStaticInformations extends ReadOnlyData
   {
       
      
      public function TaxCollectorStaticInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get firstNameId() : uint
      {
         return _target.firstNameId;
      }
      
      public function get lastNameId() : uint
      {
         return _target.lastNameId;
      }
      
      public function get guildIdentity() : GuildInformations
      {
         return secure(_target.guildIdentity);
      }
   }
}
