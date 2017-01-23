package d2network
{
   public class TaxCollectorStaticExtendedInformations extends TaxCollectorStaticInformations
   {
       
      
      public function TaxCollectorStaticExtendedInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get allianceIdentity() : AllianceInformations
      {
         return secure(_target.allianceIdentity);
      }
   }
}
