package d2data
{
   public class WeaponWrapper extends ItemWrapper
   {
       
      
      public function WeaponWrapper(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get apCost() : int
      {
         return _target.apCost;
      }
      
      public function get minRange() : int
      {
         return _target.minRange;
      }
      
      public function get range() : int
      {
         return _target.range;
      }
      
      public function get maxCastPerTurn() : uint
      {
         return _target.maxCastPerTurn;
      }
      
      public function get castInLine() : Boolean
      {
         return _target.castInLine;
      }
      
      public function get castInDiagonal() : Boolean
      {
         return _target.castInDiagonal;
      }
      
      public function get castTestLos() : Boolean
      {
         return _target.castTestLos;
      }
      
      public function get criticalHitProbability() : int
      {
         return _target.criticalHitProbability;
      }
      
      public function get criticalHitBonus() : int
      {
         return _target.criticalHitBonus;
      }
      
      public function get criticalFailureProbability() : int
      {
         return _target.criticalFailureProbability;
      }
   }
}
