package d2network
{
   import utils.ReadOnlyData;
   
   public class TaxCollectorName extends ReadOnlyData
   {
       
      
      public function TaxCollectorName(param1:*, param2:Object)
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
   }
}
