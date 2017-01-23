package d2network
{
   public class AllianceFactSheetInformations extends AllianceInformations
   {
       
      
      public function AllianceFactSheetInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get creationDate() : uint
      {
         return _target.creationDate;
      }
   }
}
