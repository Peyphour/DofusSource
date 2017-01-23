package d2data
{
   import utils.ReadOnlyData;
   
   public class MonsterMiniBoss extends ReadOnlyData
   {
       
      
      public function MonsterMiniBoss(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : int
      {
         return _target.id;
      }
      
      public function get monsterReplacingId() : int
      {
         return _target.monsterReplacingId;
      }
   }
}
