package d2network
{
   public class AlliancePrismInformation extends PrismInformation
   {
       
      
      public function AlliancePrismInformation(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get alliance() : AllianceInformations
      {
         return secure(_target.alliance);
      }
   }
}
