package d2network
{
   public class TaxCollectorWaitingForHelpInformations extends TaxCollectorComplementaryInformations
   {
       
      
      public function TaxCollectorWaitingForHelpInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get waitingForHelpInfo() : ProtectedEntityWaitingForHelpInfo
      {
         return secure(_target.waitingForHelpInfo);
      }
   }
}
