package d2network
{
   import utils.ReadOnlyData;
   
   public class GameFightMinimalStats extends ReadOnlyData
   {
       
      
      public function GameFightMinimalStats(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get lifePoints() : uint
      {
         return _target.lifePoints;
      }
      
      public function get maxLifePoints() : uint
      {
         return _target.maxLifePoints;
      }
      
      public function get baseMaxLifePoints() : uint
      {
         return _target.baseMaxLifePoints;
      }
      
      public function get permanentDamagePercent() : uint
      {
         return _target.permanentDamagePercent;
      }
      
      public function get shieldPoints() : uint
      {
         return _target.shieldPoints;
      }
      
      public function get actionPoints() : int
      {
         return _target.actionPoints;
      }
      
      public function get maxActionPoints() : int
      {
         return _target.maxActionPoints;
      }
      
      public function get movementPoints() : int
      {
         return _target.movementPoints;
      }
      
      public function get maxMovementPoints() : int
      {
         return _target.maxMovementPoints;
      }
      
      public function get summoner() : Number
      {
         return _target.summoner;
      }
      
      public function get summoned() : Boolean
      {
         return _target.summoned;
      }
      
      public function get neutralElementResistPercent() : int
      {
         return _target.neutralElementResistPercent;
      }
      
      public function get earthElementResistPercent() : int
      {
         return _target.earthElementResistPercent;
      }
      
      public function get waterElementResistPercent() : int
      {
         return _target.waterElementResistPercent;
      }
      
      public function get airElementResistPercent() : int
      {
         return _target.airElementResistPercent;
      }
      
      public function get fireElementResistPercent() : int
      {
         return _target.fireElementResistPercent;
      }
      
      public function get neutralElementReduction() : int
      {
         return _target.neutralElementReduction;
      }
      
      public function get earthElementReduction() : int
      {
         return _target.earthElementReduction;
      }
      
      public function get waterElementReduction() : int
      {
         return _target.waterElementReduction;
      }
      
      public function get airElementReduction() : int
      {
         return _target.airElementReduction;
      }
      
      public function get fireElementReduction() : int
      {
         return _target.fireElementReduction;
      }
      
      public function get criticalDamageFixedResist() : int
      {
         return _target.criticalDamageFixedResist;
      }
      
      public function get pushDamageFixedResist() : int
      {
         return _target.pushDamageFixedResist;
      }
      
      public function get pvpNeutralElementResistPercent() : int
      {
         return _target.pvpNeutralElementResistPercent;
      }
      
      public function get pvpEarthElementResistPercent() : int
      {
         return _target.pvpEarthElementResistPercent;
      }
      
      public function get pvpWaterElementResistPercent() : int
      {
         return _target.pvpWaterElementResistPercent;
      }
      
      public function get pvpAirElementResistPercent() : int
      {
         return _target.pvpAirElementResistPercent;
      }
      
      public function get pvpFireElementResistPercent() : int
      {
         return _target.pvpFireElementResistPercent;
      }
      
      public function get pvpNeutralElementReduction() : int
      {
         return _target.pvpNeutralElementReduction;
      }
      
      public function get pvpEarthElementReduction() : int
      {
         return _target.pvpEarthElementReduction;
      }
      
      public function get pvpWaterElementReduction() : int
      {
         return _target.pvpWaterElementReduction;
      }
      
      public function get pvpAirElementReduction() : int
      {
         return _target.pvpAirElementReduction;
      }
      
      public function get pvpFireElementReduction() : int
      {
         return _target.pvpFireElementReduction;
      }
      
      public function get dodgePALostProbability() : uint
      {
         return _target.dodgePALostProbability;
      }
      
      public function get dodgePMLostProbability() : uint
      {
         return _target.dodgePMLostProbability;
      }
      
      public function get tackleBlock() : int
      {
         return _target.tackleBlock;
      }
      
      public function get tackleEvade() : int
      {
         return _target.tackleEvade;
      }
      
      public function get fixedDamageReflection() : int
      {
         return _target.fixedDamageReflection;
      }
      
      public function get invisibilityState() : uint
      {
         return _target.invisibilityState;
      }
   }
}
