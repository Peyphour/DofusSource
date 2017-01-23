package d2network
{
   import utils.ReadOnlyData;
   
   public class FightResultListEntry extends ReadOnlyData
   {
       
      
      public function FightResultListEntry(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get outcome() : uint
      {
         return _target.outcome;
      }
      
      public function get wave() : uint
      {
         return _target.wave;
      }
      
      public function get rewards() : FightLoot
      {
         return secure(_target.rewards);
      }
   }
}
