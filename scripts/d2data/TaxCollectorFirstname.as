package d2data
{
   import utils.ReadOnlyData;
   
   public class TaxCollectorFirstname extends ReadOnlyData
   {
       
      
      public function TaxCollectorFirstname(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get firstnameId() : uint
      {
         return _target.firstnameId;
      }
   }
}
