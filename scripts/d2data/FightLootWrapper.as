package d2data
{
   import utils.ReadOnlyData;
   
   public class FightLootWrapper extends ReadOnlyData
   {
       
      
      public function FightLootWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get objects() : Object
      {
         return secure(_target.objects);
      }
      
      public function get kamas() : uint
      {
         return _target.kamas;
      }
   }
}
