package d2network
{
   import utils.ReadOnlyData;
   
   public class MonsterBoosts extends ReadOnlyData
   {
       
      
      public function MonsterBoosts(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get xpBoost() : uint
      {
         return _target.xpBoost;
      }
      
      public function get dropBoost() : uint
      {
         return _target.dropBoost;
      }
   }
}
