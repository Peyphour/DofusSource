package d2network
{
   import utils.ReadOnlyData;
   
   public class FightLoot extends ReadOnlyData
   {
       
      
      public function FightLoot(param1:*, param2:Object)
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
