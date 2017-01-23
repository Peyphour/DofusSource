package d2network
{
   import utils.ReadOnlyData;
   
   public class PaddockInformations extends ReadOnlyData
   {
       
      
      public function PaddockInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get maxOutdoorMount() : uint
      {
         return _target.maxOutdoorMount;
      }
      
      public function get maxItems() : uint
      {
         return _target.maxItems;
      }
   }
}
