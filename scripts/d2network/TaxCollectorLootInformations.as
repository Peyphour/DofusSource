package d2network
{
   public class TaxCollectorLootInformations extends TaxCollectorComplementaryInformations
   {
       
      
      public function TaxCollectorLootInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get kamas() : uint
      {
         return _target.kamas;
      }
      
      public function get experience() : Number
      {
         return _target.experience;
      }
      
      public function get pods() : uint
      {
         return _target.pods;
      }
      
      public function get itemsValue() : uint
      {
         return _target.itemsValue;
      }
   }
}
