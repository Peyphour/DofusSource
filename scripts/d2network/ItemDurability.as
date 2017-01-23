package d2network
{
   import utils.ReadOnlyData;
   
   public class ItemDurability extends ReadOnlyData
   {
       
      
      public function ItemDurability(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get durability() : int
      {
         return _target.durability;
      }
      
      public function get durabilityMax() : int
      {
         return _target.durabilityMax;
      }
   }
}
