package d2data
{
   import utils.ReadOnlyData;
   
   public class SpellLevel extends ReadOnlyData
   {
       
      
      public function SpellLevel(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get id() : uint
      {
         return _target.id;
      }
      
      public function get spellId() : uint
      {
         return _target.spellId;
      }
      
      public function get grade() : uint
      {
         return _target.grade;
      }
      
      public function get spellBreed() : uint
      {
         return _target.spellBreed;
      }
      
      public function get apCost() : uint
      {
         return _target.apCost;
      }
      
      public function get minRange() : uint
      {
         return _target.minRange;
      }
      
      public function get range() : uint
      {
         return _target.range;
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
      
      public function get criticalHitProbability() : uint
      {
         return _target.criticalHitProbability;
      }
      
      public function get criticalFailureProbability() : uint
      {
         return _target.criticalFailureProbability;
      }
      
      public function get needFreeCell() : Boolean
      {
         return _target.needFreeCell;
      }
      
      public function get needTakenCell() : Boolean
      {
         return _target.needTakenCell;
      }
      
      public function get needFreeTrapCell() : Boolean
      {
         return _target.needFreeTrapCell;
      }
      
      public function get rangeCanBeBoosted() : Boolean
      {
         return _target.rangeCanBeBoosted;
      }
      
      public function get maxStack() : int
      {
         return _target.maxStack;
      }
      
      public function get maxCastPerTurn() : uint
      {
         return _target.maxCastPerTurn;
      }
      
      public function get maxCastPerTarget() : uint
      {
         return _target.maxCastPerTarget;
      }
      
      public function get minCastInterval() : uint
      {
         return _target.minCastInterval;
      }
      
      public function get initialCooldown() : uint
      {
         return _target.initialCooldown;
      }
      
      public function get globalCooldown() : int
      {
         return _target.globalCooldown;
      }
      
      public function get minPlayerLevel() : uint
      {
         return _target.minPlayerLevel;
      }
      
      public function get criticalFailureEndsTurn() : Boolean
      {
         return _target.criticalFailureEndsTurn;
      }
      
      public function get hideEffects() : Boolean
      {
         return _target.hideEffects;
      }
      
      public function get hidden() : Boolean
      {
         return _target.hidden;
      }
      
      public function get playAnimation() : Boolean
      {
         return _target.playAnimation;
      }
      
      public function get statesRequired() : Object
      {
         return secure(_target.statesRequired);
      }
      
      public function get statesForbidden() : Object
      {
         return secure(_target.statesForbidden);
      }
      
      public function get effects() : Object
      {
         return secure(_target.effects);
      }
      
      public function get criticalEffect() : Object
      {
         return secure(_target.criticalEffect);
      }
   }
}
