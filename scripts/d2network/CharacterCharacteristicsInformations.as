package d2network
{
   import utils.ReadOnlyData;
   
   public class CharacterCharacteristicsInformations extends ReadOnlyData
   {
       
      
      public function CharacterCharacteristicsInformations(param1:*, param2:Object)
      {
         super(param1,param2);
      }
      
      public function get experience() : Number
      {
         return _target.experience;
      }
      
      public function get experienceLevelFloor() : Number
      {
         return _target.experienceLevelFloor;
      }
      
      public function get experienceNextLevelFloor() : Number
      {
         return _target.experienceNextLevelFloor;
      }
      
      public function get kamas() : uint
      {
         return _target.kamas;
      }
      
      public function get statsPoints() : uint
      {
         return _target.statsPoints;
      }
      
      public function get additionnalPoints() : uint
      {
         return _target.additionnalPoints;
      }
      
      public function get spellsPoints() : uint
      {
         return _target.spellsPoints;
      }
      
      public function get alignmentInfos() : ActorExtendedAlignmentInformations
      {
         return secure(_target.alignmentInfos);
      }
      
      public function get lifePoints() : uint
      {
         return _target.lifePoints;
      }
      
      public function get maxLifePoints() : uint
      {
         return _target.maxLifePoints;
      }
      
      public function get energyPoints() : uint
      {
         return _target.energyPoints;
      }
      
      public function get maxEnergyPoints() : uint
      {
         return _target.maxEnergyPoints;
      }
      
      public function get actionPointsCurrent() : int
      {
         return _target.actionPointsCurrent;
      }
      
      public function get movementPointsCurrent() : int
      {
         return _target.movementPointsCurrent;
      }
      
      public function get initiative() : CharacterBaseCharacteristic
      {
         return secure(_target.initiative);
      }
      
      public function get prospecting() : CharacterBaseCharacteristic
      {
         return secure(_target.prospecting);
      }
      
      public function get actionPoints() : CharacterBaseCharacteristic
      {
         return secure(_target.actionPoints);
      }
      
      public function get movementPoints() : CharacterBaseCharacteristic
      {
         return secure(_target.movementPoints);
      }
      
      public function get strength() : CharacterBaseCharacteristic
      {
         return secure(_target.strength);
      }
      
      public function get vitality() : CharacterBaseCharacteristic
      {
         return secure(_target.vitality);
      }
      
      public function get wisdom() : CharacterBaseCharacteristic
      {
         return secure(_target.wisdom);
      }
      
      public function get chance() : CharacterBaseCharacteristic
      {
         return secure(_target.chance);
      }
      
      public function get agility() : CharacterBaseCharacteristic
      {
         return secure(_target.agility);
      }
      
      public function get intelligence() : CharacterBaseCharacteristic
      {
         return secure(_target.intelligence);
      }
      
      public function get range() : CharacterBaseCharacteristic
      {
         return secure(_target.range);
      }
      
      public function get summonableCreaturesBoost() : CharacterBaseCharacteristic
      {
         return secure(_target.summonableCreaturesBoost);
      }
      
      public function get reflect() : CharacterBaseCharacteristic
      {
         return secure(_target.reflect);
      }
      
      public function get criticalHit() : CharacterBaseCharacteristic
      {
         return secure(_target.criticalHit);
      }
      
      public function get criticalHitWeapon() : uint
      {
         return _target.criticalHitWeapon;
      }
      
      public function get criticalMiss() : CharacterBaseCharacteristic
      {
         return secure(_target.criticalMiss);
      }
      
      public function get healBonus() : CharacterBaseCharacteristic
      {
         return secure(_target.healBonus);
      }
      
      public function get allDamagesBonus() : CharacterBaseCharacteristic
      {
         return secure(_target.allDamagesBonus);
      }
      
      public function get weaponDamagesBonusPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.weaponDamagesBonusPercent);
      }
      
      public function get damagesBonusPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.damagesBonusPercent);
      }
      
      public function get trapBonus() : CharacterBaseCharacteristic
      {
         return secure(_target.trapBonus);
      }
      
      public function get trapBonusPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.trapBonusPercent);
      }
      
      public function get glyphBonusPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.glyphBonusPercent);
      }
      
      public function get runeBonusPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.runeBonusPercent);
      }
      
      public function get permanentDamagePercent() : CharacterBaseCharacteristic
      {
         return secure(_target.permanentDamagePercent);
      }
      
      public function get tackleBlock() : CharacterBaseCharacteristic
      {
         return secure(_target.tackleBlock);
      }
      
      public function get tackleEvade() : CharacterBaseCharacteristic
      {
         return secure(_target.tackleEvade);
      }
      
      public function get PAAttack() : CharacterBaseCharacteristic
      {
         return secure(_target.PAAttack);
      }
      
      public function get PMAttack() : CharacterBaseCharacteristic
      {
         return secure(_target.PMAttack);
      }
      
      public function get pushDamageBonus() : CharacterBaseCharacteristic
      {
         return secure(_target.pushDamageBonus);
      }
      
      public function get criticalDamageBonus() : CharacterBaseCharacteristic
      {
         return secure(_target.criticalDamageBonus);
      }
      
      public function get neutralDamageBonus() : CharacterBaseCharacteristic
      {
         return secure(_target.neutralDamageBonus);
      }
      
      public function get earthDamageBonus() : CharacterBaseCharacteristic
      {
         return secure(_target.earthDamageBonus);
      }
      
      public function get waterDamageBonus() : CharacterBaseCharacteristic
      {
         return secure(_target.waterDamageBonus);
      }
      
      public function get airDamageBonus() : CharacterBaseCharacteristic
      {
         return secure(_target.airDamageBonus);
      }
      
      public function get fireDamageBonus() : CharacterBaseCharacteristic
      {
         return secure(_target.fireDamageBonus);
      }
      
      public function get dodgePALostProbability() : CharacterBaseCharacteristic
      {
         return secure(_target.dodgePALostProbability);
      }
      
      public function get dodgePMLostProbability() : CharacterBaseCharacteristic
      {
         return secure(_target.dodgePMLostProbability);
      }
      
      public function get neutralElementResistPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.neutralElementResistPercent);
      }
      
      public function get earthElementResistPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.earthElementResistPercent);
      }
      
      public function get waterElementResistPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.waterElementResistPercent);
      }
      
      public function get airElementResistPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.airElementResistPercent);
      }
      
      public function get fireElementResistPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.fireElementResistPercent);
      }
      
      public function get neutralElementReduction() : CharacterBaseCharacteristic
      {
         return secure(_target.neutralElementReduction);
      }
      
      public function get earthElementReduction() : CharacterBaseCharacteristic
      {
         return secure(_target.earthElementReduction);
      }
      
      public function get waterElementReduction() : CharacterBaseCharacteristic
      {
         return secure(_target.waterElementReduction);
      }
      
      public function get airElementReduction() : CharacterBaseCharacteristic
      {
         return secure(_target.airElementReduction);
      }
      
      public function get fireElementReduction() : CharacterBaseCharacteristic
      {
         return secure(_target.fireElementReduction);
      }
      
      public function get pushDamageReduction() : CharacterBaseCharacteristic
      {
         return secure(_target.pushDamageReduction);
      }
      
      public function get criticalDamageReduction() : CharacterBaseCharacteristic
      {
         return secure(_target.criticalDamageReduction);
      }
      
      public function get pvpNeutralElementResistPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.pvpNeutralElementResistPercent);
      }
      
      public function get pvpEarthElementResistPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.pvpEarthElementResistPercent);
      }
      
      public function get pvpWaterElementResistPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.pvpWaterElementResistPercent);
      }
      
      public function get pvpAirElementResistPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.pvpAirElementResistPercent);
      }
      
      public function get pvpFireElementResistPercent() : CharacterBaseCharacteristic
      {
         return secure(_target.pvpFireElementResistPercent);
      }
      
      public function get pvpNeutralElementReduction() : CharacterBaseCharacteristic
      {
         return secure(_target.pvpNeutralElementReduction);
      }
      
      public function get pvpEarthElementReduction() : CharacterBaseCharacteristic
      {
         return secure(_target.pvpEarthElementReduction);
      }
      
      public function get pvpWaterElementReduction() : CharacterBaseCharacteristic
      {
         return secure(_target.pvpWaterElementReduction);
      }
      
      public function get pvpAirElementReduction() : CharacterBaseCharacteristic
      {
         return secure(_target.pvpAirElementReduction);
      }
      
      public function get pvpFireElementReduction() : CharacterBaseCharacteristic
      {
         return secure(_target.pvpFireElementReduction);
      }
      
      public function get spellModifications() : Object
      {
         return secure(_target.spellModifications);
      }
      
      public function get probationTime() : uint
      {
         return _target.probationTime;
      }
   }
}
