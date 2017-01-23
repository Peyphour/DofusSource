package d2network
{
   import utils.ReadOnlyData;
   
   public class AdditionalTaxCollectorInformations extends ReadOnlyData
   {
       
      
      public function AdditionalTaxCollectorInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get collectorCallerName() : String
      {
         return _target.collectorCallerName;
      }
      
      public function get date() : uint
      {
         return _target.date;
      }
   }
}
