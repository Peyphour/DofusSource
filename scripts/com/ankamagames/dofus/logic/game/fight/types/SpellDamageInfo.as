package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.datacenter.effects.Effect;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceMinMax;
   import com.ankamagames.dofus.internalDatacenter.items.WeaponWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.FightersStateManager;
   import com.ankamagames.dofus.logic.game.fight.managers.SpellZoneManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.logic.game.fight.miscs.DamageUtil;
   import com.ankamagames.dofus.network.enums.CharacterSpellModificationTypeEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.IZone;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class SpellDamageInfo
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellDamageInfo));
       
      
      private var _targetId:Number;
      
      private var _targetInfos:GameFightFighterInformations;
      
      private var _originalTargetsIds:Vector.<Number>;
      
      private var _effectsModifications:Vector.<EffectModification>;
      
      private var _criticalEffectsModifications:Vector.<EffectModification>;
      
      public var isWeapon:Boolean;
      
      public var isHealingSpell:Boolean;
      
      public var casterId:Number;
      
      public var casterLevel:int;
      
      public var casterStrength:int;
      
      public var casterChance:int;
      
      public var casterAgility:int;
      
      public var casterIntelligence:int;
      
      public var casterLifePoints:uint;
      
      public var casterBaseMaxLifePoints:uint;
      
      public var casterMaxLifePoints:uint;
      
      public var casterLifePointsAfterNormalMinDamage:uint;
      
      public var casterLifePointsAfterNormalMaxDamage:uint;
      
      public var casterLifePointsAfterCriticalMinDamage:uint;
      
      public var casterLifePointsAfterCriticalMaxDamage:uint;
      
      public var casterErosionLifePoints:int;
      
      public var casterMovementPoints:int;
      
      public var casterMaxMovementPoints:int;
      
      public var targetLifePoints:uint;
      
      public var targetBaseMaxLifePoints:uint;
      
      public var targetMaxLifePoints:uint;
      
      public var targetLifePointsAfterNormalMinDamage:uint;
      
      public var targetLifePointsAfterNormalMaxDamage:uint;
      
      public var targetLifePointsAfterCriticalMinDamage:uint;
      
      public var targetLifePointsAfterCriticalMaxDamage:uint;
      
      public var casterStrengthBonus:int;
      
      public var casterChanceBonus:int;
      
      public var casterAgilityBonus:int;
      
      public var casterIntelligenceBonus:int;
      
      public var casterCriticalStrengthBonus:int;
      
      public var casterCriticalChanceBonus:int;
      
      public var casterCriticalAgilityBonus:int;
      
      public var casterCriticalIntelligenceBonus:int;
      
      public var casterCriticalHit:int;
      
      public var casterCriticalHitWeapon:int;
      
      public var casterHealBonus:int;
      
      public var casterAllDamagesBonus:int;
      
      public var casterDamagesBonus:int;
      
      public var casterSpellDamagesBonus:int;
      
      public var casterWeaponDamagesBonus:int;
      
      public var casterTrapBonus:int;
      
      public var casterTrapBonusPercent:int;
      
      public var casterGlyphBonusPercent:int;
      
      public var casterPermanentDamagePercent:int;
      
      public var casterPushDamageBonus:int;
      
      public var casterCriticalPushDamageBonus:int;
      
      public var casterCriticalDamageBonus:int;
      
      public var casterNeutralDamageBonus:int;
      
      public var casterEarthDamageBonus:int;
      
      public var casterWaterDamageBonus:int;
      
      public var casterAirDamageBonus:int;
      
      public var casterFireDamageBonus:int;
      
      public var casterDamageBoostPercent:int;
      
      public var casterDamageDeboostPercent:int;
      
      public var casterStates:Array;
      
      public var casterStatus:FighterStatus;
      
      public var spell:Object;
      
      public var spellEffects:Vector.<EffectInstance>;
      
      public var spellCriticalEffects:Vector.<EffectInstance>;
      
      public var spellCenterCell:int;
      
      public var neutralDamage:SpellDamage;
      
      public var earthDamage:SpellDamage;
      
      public var fireDamage:SpellDamage;
      
      public var waterDamage:SpellDamage;
      
      public var airDamage:SpellDamage;
      
      public var hpBasedDamage:SpellDamage;
      
      public var interceptedDamage:SpellDamage;
      
      public var spellWeaponCriticalBonus:int;
      
      public var weaponShapeEfficiencyPercent:Object;
      
      public var heal:SpellDamage;
      
      public var shield:SpellDamage;
      
      public var spellHasCriticalDamage:Boolean;
      
      public var spellHasCriticalHeal:Boolean;
      
      public var criticalHitRate:int;
      
      public var spellHasRandomEffects:Boolean;
      
      public var spellDamageModification:CharacterSpellModification;
      
      public var minimizedEffects:Boolean;
      
      public var maximizedEffects:Boolean;
      
      public var triggeredSpell:TriggeredSpell;
      
      public var spellHasLifeSteal:Boolean;
      
      public var spellHasTriggered:Boolean;
      
      public var targetLevel:int;
      
      public var targetIsMonster:Boolean;
      
      public var targetIsInvulnerable:Boolean;
      
      public var targetIsInvulnerableToMelee:Boolean;
      
      public var targetIsInvulnerableToRange:Boolean;
      
      public var targetIsUnhealable:Boolean;
      
      public var targetCell:int = -1;
      
      public var targetShieldPoints:uint;
      
      public var targetTriggeredShieldPoints:uint;
      
      public var targetNeutralElementResistPercent:int;
      
      public var targetEarthElementResistPercent:int;
      
      public var targetWaterElementResistPercent:int;
      
      public var targetAirElementResistPercent:int;
      
      public var targetFireElementResistPercent:int;
      
      public var targetBuffs:Array;
      
      public var targetStates:Array;
      
      public var targetStatus:FighterStatus;
      
      public var targetNeutralElementReduction:int;
      
      public var targetEarthElementReduction:int;
      
      public var targetWaterElementReduction:int;
      
      public var targetAirElementReduction:int;
      
      public var targetFireElementReduction:int;
      
      public var targetCriticalDamageFixedResist:int;
      
      public var targetPushDamageFixedResist:int;
      
      public var targetErosionLifePoints:int;
      
      public var targetSpellMinErosionLifePoints:int;
      
      public var targetSpellMaxErosionLifePoints:int;
      
      public var targetSpellMinCriticalErosionLifePoints:int;
      
      public var targetSpellMaxCriticalErosionLifePoints:int;
      
      public var targetErosionPercentBonus:int;
      
      public var pushedEntities:Vector.<PushedEntity>;
      
      public var splashDamages:Vector.<SplashDamage>;
      
      public var criticalSplashDamages:Vector.<SplashDamage>;
      
      public var reflectDamages:Vector.<ReflectDamage>;
      
      public var sharedDamage:SpellDamage;
      
      public var damageSharingTargets:Vector.<Number>;
      
      public var portalsSpellEfficiencyBonus:Number = 1;
      
      public var spellTargetEffectsDurationReduction:int;
      
      public var spellTargetEffectsDurationCriticalReduction:int;
      
      public var interceptedDamages:Vector.<InterceptedDamage>;
      
      public var interceptedEntityId:Number;
      
      public var distanceBetweenCasterAndTarget:int;
      
      public var isInterceptedDamage:Boolean;
      
      public function SpellDamageInfo()
      {
         this.interceptedDamages = new Vector.<InterceptedDamage>();
         super();
      }
      
      public static function fromCurrentPlayer(param1:Object, param2:Number = NaN, param3:int = -1) : SpellDamageInfo
      {
         var _loc4_:SpellDamageInfo = null;
         var _loc9_:EffectInstance = null;
         var _loc10_:EffectInstanceDice = null;
         var _loc11_:EffectInstanceMinMax = null;
         var _loc12_:EffectDamage = null;
         var _loc13_:Boolean = false;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc23_:BasicBuff = null;
         var _loc25_:Vector.<BasicBuff> = null;
         var _loc26_:* = undefined;
         var _loc27_:SpellWrapper = null;
         var _loc28_:Boolean = false;
         var _loc29_:int = 0;
         var _loc32_:GameFightFighterInformations = null;
         var _loc33_:IZone = null;
         var _loc34_:Vector.<uint> = null;
         var _loc35_:uint = 0;
         var _loc36_:Array = null;
         var _loc37_:AnimatedCharacter = null;
         var _loc38_:EffectInstance = null;
         var _loc39_:WeaponWrapper = null;
         var _loc40_:Boolean = false;
         var _loc41_:InterceptedDamage = null;
         var _loc5_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         _loc4_ = new SpellDamageInfo();
         _loc4_._originalTargetsIds = new Vector.<Number>(0);
         _loc4_.casterId = CurrentPlayedFighterManager.getInstance().currentFighterId;
         _loc4_.targetId = param2;
         _loc4_.casterStates = FightersStateManager.getInstance().getStates(_loc4_.casterId);
         _loc4_.casterStatus = FightersStateManager.getInstance().getStatus(_loc4_.casterId);
         _loc4_.casterLevel = PlayedCharacterManager.getInstance().infos.level;
         _loc4_.spell = param1;
         _loc4_.spellEffects = param1.effects;
         _loc4_.spellCriticalEffects = param1.criticalEffect;
         _loc4_.isWeapon = !(param1 is SpellWrapper) || param1.id == 0;
         _loc4_.casterLifePoints = PlayedCharacterManager.getInstance().characteristics.lifePoints;
         _loc4_.casterBaseMaxLifePoints = _loc4_.casterMaxLifePoints = PlayedCharacterManager.getInstance().characteristics.maxLifePoints;
         if(_loc5_)
         {
            _loc32_ = _loc5_.entitiesFrame.getEntityInfos(_loc4_.casterId) as GameFightFighterInformations;
            _loc4_.casterLifePoints = _loc32_.stats.lifePoints;
            _loc4_.casterBaseMaxLifePoints = _loc32_.stats.baseMaxLifePoints;
            _loc4_.casterMaxLifePoints = _loc32_.stats.maxLifePoints;
            _loc4_.casterErosionLifePoints = _loc4_.casterBaseMaxLifePoints - _loc4_.casterMaxLifePoints;
            _loc33_ = SpellZoneManager.getInstance().getSpellZone(param1,false,false);
            _loc33_.direction = MapPoint.fromCellId(_loc32_.disposition.cellId).advancedOrientationTo(MapPoint.fromCellId(FightContextFrame.currentCell),false);
            _loc34_ = _loc33_.getCells(param3);
            for each(_loc35_ in _loc34_)
            {
               _loc36_ = EntitiesManager.getInstance().getEntitiesOnCell(_loc35_,AnimatedCharacter);
               for each(_loc37_ in _loc36_)
               {
                  if(_loc5_.entitiesFrame.getEntityInfos(_loc37_.id) && _loc4_._originalTargetsIds.indexOf(_loc37_.id) == -1 && DamageUtil.isDamagedOrHealedBySpell(_loc4_.casterId,_loc37_.id,param1,param3))
                  {
                     _loc4_._originalTargetsIds.push(_loc37_.id);
                  }
               }
            }
            if(_loc4_._originalTargetsIds.indexOf(_loc4_.casterId) == -1 && param1 is SpellWrapper && (param1 as SpellWrapper).canTargetCasterOutOfZone)
            {
               _loc4_._originalTargetsIds.push(_loc4_.casterId);
            }
            if(param1 is SpellWrapper)
            {
               for each(_loc38_ in param1.effects)
               {
                  if(_loc38_.targetMask.indexOf("E263") != -1 && _loc33_.radius == 63 && _loc4_._targetInfos.disposition.cellId == -1)
                  {
                     _loc4_._originalTargetsIds.push(param2);
                     break;
                  }
               }
            }
         }
         var _loc6_:* = _loc4_.targetId == _loc4_.casterId;
         var _loc7_:CharacterCharacteristicsInformations = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations();
         _loc4_.casterMovementPoints = _loc7_.movementPointsCurrent;
         _loc4_.casterMaxMovementPoints = _loc7_.movementPoints.base + _loc7_.movementPoints.additionnal + _loc7_.movementPoints.objectsAndMountBonus + _loc7_.movementPoints.alignGiftBonus + _loc7_.movementPoints.contextModif;
         _loc4_.casterStrength = _loc7_.strength.base + _loc7_.strength.additionnal + _loc7_.strength.objectsAndMountBonus + _loc7_.strength.alignGiftBonus + _loc7_.strength.contextModif;
         _loc4_.casterChance = _loc7_.chance.base + _loc7_.chance.additionnal + _loc7_.chance.objectsAndMountBonus + _loc7_.chance.alignGiftBonus + _loc7_.chance.contextModif;
         _loc4_.casterAgility = _loc7_.agility.base + _loc7_.agility.additionnal + _loc7_.agility.objectsAndMountBonus + _loc7_.agility.alignGiftBonus + _loc7_.agility.contextModif;
         _loc4_.casterIntelligence = _loc7_.intelligence.base + _loc7_.intelligence.additionnal + _loc7_.intelligence.objectsAndMountBonus + _loc7_.intelligence.alignGiftBonus + _loc7_.intelligence.contextModif;
         _loc4_.casterCriticalHit = _loc7_.criticalHit.base + _loc7_.criticalHit.additionnal + _loc7_.criticalHit.objectsAndMountBonus + _loc7_.criticalHit.alignGiftBonus + _loc7_.criticalHit.contextModif;
         _loc4_.casterCriticalHitWeapon = _loc7_.criticalHitWeapon;
         _loc4_.casterHealBonus = _loc7_.healBonus.base + _loc7_.healBonus.additionnal + _loc7_.healBonus.objectsAndMountBonus + _loc7_.healBonus.alignGiftBonus + _loc7_.healBonus.contextModif;
         _loc4_.casterAllDamagesBonus = _loc7_.allDamagesBonus.base + _loc7_.allDamagesBonus.additionnal + _loc7_.allDamagesBonus.objectsAndMountBonus + _loc7_.allDamagesBonus.alignGiftBonus + _loc7_.allDamagesBonus.contextModif;
         _loc4_.casterDamagesBonus = _loc7_.damagesBonusPercent.base + _loc7_.damagesBonusPercent.additionnal + _loc7_.damagesBonusPercent.objectsAndMountBonus + _loc7_.damagesBonusPercent.alignGiftBonus + _loc7_.damagesBonusPercent.contextModif;
         _loc4_.casterTrapBonus = _loc7_.trapBonus.base + _loc7_.trapBonus.additionnal + _loc7_.trapBonus.objectsAndMountBonus + _loc7_.trapBonus.alignGiftBonus + _loc7_.trapBonus.contextModif;
         _loc4_.casterTrapBonusPercent = _loc7_.trapBonusPercent.base + _loc7_.trapBonusPercent.additionnal + _loc7_.trapBonusPercent.objectsAndMountBonus + _loc7_.trapBonusPercent.alignGiftBonus + _loc7_.trapBonusPercent.contextModif;
         _loc4_.casterGlyphBonusPercent = _loc7_.glyphBonusPercent.base + _loc7_.glyphBonusPercent.additionnal + _loc7_.glyphBonusPercent.objectsAndMountBonus + _loc7_.glyphBonusPercent.alignGiftBonus + _loc7_.glyphBonusPercent.contextModif;
         _loc4_.casterPermanentDamagePercent = _loc7_.permanentDamagePercent.base + _loc7_.permanentDamagePercent.additionnal + _loc7_.permanentDamagePercent.objectsAndMountBonus + _loc7_.permanentDamagePercent.alignGiftBonus + _loc7_.permanentDamagePercent.contextModif;
         _loc4_.casterPushDamageBonus = _loc7_.pushDamageBonus.base + _loc7_.pushDamageBonus.additionnal + _loc7_.pushDamageBonus.objectsAndMountBonus + _loc7_.pushDamageBonus.alignGiftBonus + _loc7_.pushDamageBonus.contextModif;
         _loc4_.casterCriticalPushDamageBonus = _loc7_.pushDamageBonus.base + _loc7_.pushDamageBonus.additionnal + _loc7_.pushDamageBonus.objectsAndMountBonus + _loc7_.pushDamageBonus.alignGiftBonus;
         _loc4_.casterCriticalDamageBonus = _loc7_.criticalDamageBonus.base + _loc7_.criticalDamageBonus.additionnal + _loc7_.criticalDamageBonus.objectsAndMountBonus + _loc7_.criticalDamageBonus.alignGiftBonus + _loc7_.criticalDamageBonus.contextModif;
         _loc4_.casterNeutralDamageBonus = _loc7_.neutralDamageBonus.base + _loc7_.neutralDamageBonus.additionnal + _loc7_.neutralDamageBonus.objectsAndMountBonus + _loc7_.neutralDamageBonus.alignGiftBonus + _loc7_.neutralDamageBonus.contextModif;
         _loc4_.casterEarthDamageBonus = _loc7_.earthDamageBonus.base + _loc7_.earthDamageBonus.additionnal + _loc7_.earthDamageBonus.objectsAndMountBonus + _loc7_.earthDamageBonus.alignGiftBonus + _loc7_.earthDamageBonus.contextModif;
         _loc4_.casterWaterDamageBonus = _loc7_.waterDamageBonus.base + _loc7_.waterDamageBonus.additionnal + _loc7_.waterDamageBonus.objectsAndMountBonus + _loc7_.waterDamageBonus.alignGiftBonus + _loc7_.waterDamageBonus.contextModif;
         _loc4_.casterAirDamageBonus = _loc7_.airDamageBonus.base + _loc7_.airDamageBonus.additionnal + _loc7_.airDamageBonus.objectsAndMountBonus + _loc7_.airDamageBonus.alignGiftBonus + _loc7_.airDamageBonus.contextModif;
         _loc4_.casterFireDamageBonus = _loc7_.fireDamageBonus.base + _loc7_.fireDamageBonus.additionnal + _loc7_.fireDamageBonus.objectsAndMountBonus + _loc7_.fireDamageBonus.alignGiftBonus + _loc7_.fireDamageBonus.contextModif;
         if(_loc5_)
         {
            _loc4_.portalsSpellEfficiencyBonus = DamageUtil.getPortalsSpellEfficiencyBonus(FightContextFrame.currentCell);
         }
         _loc4_.neutralDamage = DamageUtil.getSpellElementDamage(param1,DamageUtil.NEUTRAL_ELEMENT,_loc4_.casterId,param2,param3);
         _loc4_.earthDamage = DamageUtil.getSpellElementDamage(param1,DamageUtil.EARTH_ELEMENT,_loc4_.casterId,param2,param3);
         _loc4_.fireDamage = DamageUtil.getSpellElementDamage(param1,DamageUtil.FIRE_ELEMENT,_loc4_.casterId,param2,param3);
         _loc4_.waterDamage = DamageUtil.getSpellElementDamage(param1,DamageUtil.WATER_ELEMENT,_loc4_.casterId,param2,param3);
         _loc4_.airDamage = DamageUtil.getSpellElementDamage(param1,DamageUtil.AIR_ELEMENT,_loc4_.casterId,param2,param3);
         _loc4_.spellHasCriticalDamage = _loc4_.isWeapon && !_loc6_ || _loc4_.neutralDamage.hasCriticalDamage || _loc4_.earthDamage.hasCriticalDamage || _loc4_.fireDamage.hasCriticalDamage || _loc4_.waterDamage.hasCriticalDamage || _loc4_.airDamage.hasCriticalDamage;
         var _loc8_:int = _loc4_.isWeapon && param1.id != 0?int(55 - PlayedCharacterManager.getInstance().currentWeapon.criticalHitProbability - _loc4_.casterCriticalHit):int(param1.playerCriticalRate);
         if(_loc8_ > 54)
         {
            _loc8_ = 54;
         }
         _loc4_.criticalHitRate = 55 - 1 / (1 / _loc8_);
         _loc4_.criticalHitRate = _loc4_.criticalHitRate > 100?100:int(_loc4_.criticalHitRate);
         _loc4_.shield = new SpellDamage();
         if(_loc6_)
         {
            _loc4_.reflectDamages = _loc4_.getReflectDamages();
            _loc4_.spellHasLifeSteal = _loc4_.hasLifeSteal();
         }
         _loc4_.hpBasedDamage = new SpellDamage();
         _loc4_.heal = new SpellDamage();
         for each(_loc9_ in param1.effects)
         {
            if(DamageUtil.HEALING_EFFECTS_IDS.indexOf(_loc9_.effectId) != -1 && (_loc9_.effectId != 90 || param2 != _loc4_.casterId))
            {
               if(_loc4_.isWeapon && !_loc6_ || DamageUtil.verifySpellEffectMask(_loc4_.casterId,param2,_loc9_,param3))
               {
                  _loc13_ = true;
               }
            }
            else if(_loc9_.category == DamageUtil.DAMAGE_EFFECT_CATEGORY && (_loc4_.isWeapon && !_loc6_ || DamageUtil.verifySpellEffectMask(_loc4_.casterId,param2,_loc9_,param3)))
            {
               _loc13_ = false;
               break;
            }
         }
         _loc4_.isHealingSpell = _loc13_;
         _loc14_ = getMinimumDamageEffectOrder(_loc4_.casterId,param2,param1.effects,param3);
         _loc17_ = param1.effects.length;
         _loc15_ = 0;
         while(_loc15_ < _loc17_)
         {
            _loc9_ = param1.effects[_loc15_];
            if(_loc4_.isWeapon && !_loc6_ || DamageUtil.verifySpellEffectMask(_loc4_.casterId,param2,_loc9_,param3))
            {
               _loc10_ = _loc9_ as EffectInstanceDice;
               if(DamageUtil.HEALING_EFFECTS_IDS.indexOf(_loc9_.effectId) != -1 && (_loc9_.effectId != 90 || param2 != _loc4_.casterId))
               {
                  _loc12_ = new EffectDamage(_loc9_.effectId,-1,_loc9_.random,_loc9_.duration);
                  _loc12_.spellEffectOrder = _loc15_;
                  if(_loc9_.effectId == 90)
                  {
                     _loc4_.heal.addEffectDamage(_loc12_);
                     _loc12_.lifePointsAddedBasedOnLifePercent = _loc12_.lifePointsAddedBasedOnLifePercent + _loc10_.diceNum * _loc4_.casterLifePoints / 100;
                  }
                  else
                  {
                     _loc4_.heal.addEffectDamage(_loc12_);
                     if(_loc9_.effectId == 1109)
                     {
                        if(_loc4_.targetInfos)
                        {
                           _loc12_.lifePointsAddedBasedOnLifePercent = _loc12_.lifePointsAddedBasedOnLifePercent + _loc10_.diceNum * _loc4_.targetInfos.stats.maxLifePoints / 100;
                        }
                     }
                     else if(_loc9_ is EffectInstanceDice)
                     {
                        _loc12_.minLifePointsAdded = _loc12_.minLifePointsAdded + _loc10_.diceNum;
                        _loc12_.maxLifePointsAdded = _loc12_.maxLifePointsAdded + (_loc10_.diceSide == 0?_loc10_.diceNum:_loc10_.diceSide);
                     }
                     else if(_loc9_ is EffectInstanceMinMax)
                     {
                        _loc11_ = _loc9_ as EffectInstanceMinMax;
                        _loc12_.minLifePointsAdded = _loc12_.minLifePointsAdded + _loc11_.min;
                        _loc12_.maxLifePointsAdded = _loc12_.maxLifePointsAdded + _loc11_.max;
                     }
                  }
               }
               else if(DamageUtil.IMMEDIATE_BOOST_EFFECTS_IDS.indexOf(_loc9_.effectId) != -1 && _loc15_ < _loc14_)
               {
                  switch(_loc9_.effectId)
                  {
                     case 266:
                        _loc4_.casterChanceBonus = _loc4_.casterChanceBonus + _loc10_.diceNum;
                        break;
                     case 268:
                        _loc4_.casterAgilityBonus = _loc4_.casterAgilityBonus + _loc10_.diceNum;
                        break;
                     case 269:
                        _loc4_.casterIntelligenceBonus = _loc4_.casterIntelligenceBonus + _loc10_.diceNum;
                        break;
                     case 271:
                        _loc4_.casterStrengthBonus = _loc4_.casterStrengthBonus + _loc10_.diceNum;
                        break;
                     case 414:
                        _loc4_.casterPushDamageBonus = _loc4_.casterPushDamageBonus + _loc10_.diceNum;
                  }
               }
               else if(_loc9_.triggers == "I" && (DamageUtil.TARGET_HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc9_.effectId) != -1 || DamageUtil.HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc9_.effectId) != -1))
               {
                  _loc12_ = new EffectDamage(_loc9_.effectId,_loc9_.effectElement,_loc9_.random,_loc9_.duration);
                  _loc12_.spellEffectOrder = _loc15_;
                  _loc4_.hpBasedDamage.addEffectDamage(_loc12_);
                  _loc12_.minDamage = _loc12_.maxDamage = _loc10_.diceNum;
               }
               else if(DamageUtil.SHIELD_GAIN_EFFECTS_IDS.indexOf(_loc9_.effectId) != -1)
               {
                  _loc12_ = new EffectDamage(_loc9_.effectId,-1,_loc9_.random,_loc9_.duration);
                  _loc12_.spellEffectOrder = _loc15_;
                  _loc4_.shield.addEffectDamage(_loc12_);
                  if(_loc9_.effectId == 1039)
                  {
                     _loc12_.minShieldPointsAdded = _loc12_.maxShieldPointsAdded = _loc10_.diceNum * _loc4_.casterMaxLifePoints / 100;
                  }
                  else if(_loc9_.effectId == 1040)
                  {
                     if(_loc9_ is EffectInstanceDice)
                     {
                        _loc12_.minShieldPointsAdded = _loc12_.minShieldPointsAdded + _loc10_.diceNum;
                        _loc12_.maxShieldPointsAdded = _loc12_.maxShieldPointsAdded + (_loc10_.diceSide == 0?_loc10_.diceNum:_loc10_.diceSide);
                     }
                     else if(_loc9_ is EffectInstanceMinMax)
                     {
                        _loc11_ = _loc9_ as EffectInstanceMinMax;
                        _loc12_.minShieldPointsAdded = _loc12_.minShieldPointsAdded + _loc11_.min;
                        _loc12_.maxShieldPointsAdded = _loc12_.maxShieldPointsAdded + _loc11_.max;
                     }
                  }
               }
               if((_loc14_ == -1 || _loc15_ < _loc14_) && _loc9_.effectId == 1075)
               {
                  _loc4_.spellTargetEffectsDurationReduction = _loc10_.diceNum;
               }
            }
            _loc15_++;
         }
         var _loc18_:int = _loc4_.heal.effectDamages.length;
         var _loc19_:int = _loc4_.shield.effectDamages.length;
         var _loc20_:int = !!param1.criticalEffect?int(param1.criticalEffect.length):0;
         var _loc21_:int = _loc20_ > 0?int(getMinimumDamageEffectOrder(_loc4_.casterId,param2,param1.criticalEffect,param3)):0;
         _loc15_ = 0;
         while(_loc15_ < _loc20_)
         {
            _loc9_ = param1.criticalEffect[_loc15_];
            if(DamageUtil.verifySpellEffectMask(_loc4_.casterId,param2,_loc9_,param3))
            {
               _loc10_ = _loc9_ as EffectInstanceDice;
               if(DamageUtil.HEALING_EFFECTS_IDS.indexOf(_loc9_.effectId) != -1 && (_loc9_.effectId != 90 || param2 != _loc4_.casterId))
               {
                  if(_loc9_.effectId == 90)
                  {
                     if(_loc15_ < _loc18_)
                     {
                        _loc12_ = _loc4_.heal.effectDamages[_loc15_];
                     }
                     else
                     {
                        _loc12_ = new EffectDamage(_loc9_.effectId,-1,_loc9_.random,_loc9_.duration);
                        _loc12_.spellEffectOrder = _loc15_;
                        _loc4_.heal.addEffectDamage(_loc12_);
                     }
                  }
                  if(_loc9_.effectId == 1109)
                  {
                     if(_loc4_.targetInfos)
                     {
                        _loc12_.criticalLifePointsAddedBasedOnLifePercent = _loc12_.criticalLifePointsAddedBasedOnLifePercent + _loc10_.diceNum * _loc4_.targetInfos.stats.maxLifePoints / 100;
                     }
                  }
                  else if(_loc9_.effectId == 90 && param2 != _loc4_.casterId)
                  {
                     _loc12_.criticalLifePointsAddedBasedOnLifePercent = _loc12_.criticalLifePointsAddedBasedOnLifePercent + _loc10_.diceNum * _loc4_.casterLifePoints / 100;
                  }
                  else if(_loc9_ is EffectInstanceDice)
                  {
                     _loc12_.minCriticalLifePointsAdded = _loc12_.minCriticalLifePointsAdded + _loc10_.diceNum;
                     _loc12_.maxCriticalLifePointsAdded = _loc12_.maxCriticalLifePointsAdded + (_loc10_.diceSide == 0?_loc10_.diceNum:_loc10_.diceSide);
                  }
                  else if(_loc9_ is EffectInstanceMinMax)
                  {
                     _loc11_ = _loc9_ as EffectInstanceMinMax;
                     _loc12_.minCriticalLifePointsAdded = _loc12_.minCriticalLifePointsAdded + _loc11_.min;
                     _loc12_.maxCriticalLifePointsAdded = _loc12_.maxCriticalLifePointsAdded + _loc11_.max;
                  }
                  _loc4_.spellHasCriticalHeal = true;
               }
               else if(DamageUtil.IMMEDIATE_BOOST_EFFECTS_IDS.indexOf(_loc9_.effectId) != -1 && _loc15_ < _loc21_)
               {
                  switch(_loc9_.effectId)
                  {
                     case 266:
                        _loc4_.casterCriticalChanceBonus = _loc4_.casterCriticalChanceBonus + _loc10_.diceNum;
                        break;
                     case 268:
                        _loc4_.casterCriticalAgilityBonus = _loc4_.casterCriticalAgilityBonus + _loc10_.diceNum;
                        break;
                     case 269:
                        _loc4_.casterCriticalIntelligenceBonus = _loc4_.casterCriticalIntelligenceBonus + _loc10_.diceNum;
                        break;
                     case 271:
                        _loc4_.casterCriticalStrengthBonus = _loc4_.casterCriticalStrengthBonus + _loc10_.diceNum;
                        break;
                     case 414:
                        _loc4_.casterCriticalPushDamageBonus = _loc4_.casterCriticalPushDamageBonus + _loc10_.diceNum;
                  }
               }
               else if(_loc9_.triggers == "I" && (DamageUtil.TARGET_HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc9_.effectId) != -1 || DamageUtil.HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc9_.effectId) != -1))
               {
                  _loc12_ = _loc4_.hpBasedDamage.effectDamages[_loc16_];
                  _loc16_++;
                  _loc12_.minCriticalDamage = _loc12_.maxCriticalDamage = _loc10_.diceNum;
                  _loc4_.spellHasCriticalDamage = _loc4_.hpBasedDamage.hasCriticalDamage = _loc12_.hasCritical = true;
               }
               else if(DamageUtil.SHIELD_GAIN_EFFECTS_IDS.indexOf(_loc9_.effectId) != -1)
               {
                  if(_loc15_ < _loc19_)
                  {
                     _loc12_ = _loc4_.shield.effectDamages[_loc15_];
                  }
                  else
                  {
                     _loc12_ = new EffectDamage(_loc9_.effectId,-1,_loc9_.random,_loc9_.duration);
                     _loc12_.spellEffectOrder = _loc15_;
                     _loc4_.shield.addEffectDamage(_loc12_);
                  }
                  if(_loc9_.effectId == 1039)
                  {
                     _loc12_.minCriticalShieldPointsAdded = _loc12_.maxCriticalShieldPointsAdded = _loc10_.diceNum * _loc4_.casterMaxLifePoints / 100;
                  }
                  else if(_loc9_.effectId == 1040)
                  {
                     if(_loc9_ is EffectInstanceDice)
                     {
                        _loc12_.minCriticalShieldPointsAdded = _loc12_.minCriticalShieldPointsAdded + _loc10_.diceNum;
                        _loc12_.maxCriticalShieldPointsAdded = _loc12_.maxCriticalShieldPointsAdded + (_loc10_.diceSide == 0?_loc10_.diceNum:_loc10_.diceSide);
                     }
                     else if(_loc9_ is EffectInstanceMinMax)
                     {
                        _loc11_ = _loc9_ as EffectInstanceMinMax;
                        _loc12_.minCriticalShieldPointsAdded = _loc12_.minCriticalShieldPointsAdded + _loc11_.min;
                        _loc12_.maxCriticalShieldPointsAdded = _loc12_.maxCriticalShieldPointsAdded + _loc11_.max;
                     }
                  }
               }
               if((_loc21_ == -1 || _loc15_ < _loc21_) && _loc9_.effectId == 1075)
               {
                  _loc4_.spellTargetEffectsDurationCriticalReduction = _loc10_.diceNum;
               }
            }
            _loc15_++;
         }
         _loc4_.spellHasRandomEffects = _loc4_.neutralDamage.hasRandomEffects || _loc4_.earthDamage.hasRandomEffects || _loc4_.fireDamage.hasRandomEffects || _loc4_.waterDamage.hasRandomEffects || _loc4_.airDamage.hasRandomEffects || _loc4_.heal.hasRandomEffects;
         if(_loc4_.isWeapon && param1.id != 0)
         {
            _loc39_ = PlayedCharacterManager.getInstance().currentWeapon;
            _loc4_.spellWeaponCriticalBonus = _loc39_.criticalHitBonus;
            if(_loc39_.type.id == 7)
            {
               _loc4_.weaponShapeEfficiencyPercent = 25;
            }
         }
         _loc4_.spellCenterCell = param3;
         var _loc22_:Array = BuffManager.getInstance().getAllBuff(_loc4_.casterId);
         var _loc24_:Dictionary = groupBuffsBySpell(_loc22_);
         var _loc30_:int = -1;
         var _loc31_:int = 0;
         for(_loc26_ in _loc24_)
         {
            _loc25_ = _loc24_[_loc26_];
            if(_loc26_ == param1.id)
            {
               _loc27_ = param1 as SpellWrapper;
               _loc28_ = false;
               for each(_loc23_ in _loc25_)
               {
                  if(_loc23_.stack && _loc23_.stack.length == _loc27_.spellLevelInfos.maxStack)
                  {
                     applyBuffModification(_loc4_,_loc23_.stack[0].actionId,-_loc23_.stack[0].param1);
                     _loc28_ = true;
                  }
               }
               if(!_loc28_)
               {
                  _loc31_ = 1;
                  _loc30_ = _loc29_ = _loc25_[0].castingSpell.castingSpellId;
                  for each(_loc23_ in _loc25_)
                  {
                     if(_loc30_ != _loc23_.castingSpell.castingSpellId)
                     {
                        _loc30_ = _loc23_.castingSpell.castingSpellId;
                        _loc31_++;
                     }
                  }
                  if(_loc31_ == _loc27_.spellLevelInfos.maxStack)
                  {
                     for each(_loc23_ in _loc25_)
                     {
                        if(_loc23_.castingSpell.castingSpellId == _loc29_)
                        {
                           applyBuffModification(_loc4_,_loc23_.actionId,-_loc23_.param1);
                           continue;
                        }
                        break;
                     }
                  }
               }
            }
            _loc4_.interceptedDamages.length = 0;
            for each(_loc23_ in _loc25_)
            {
               if(_loc23_.effect.category != DamageUtil.DAMAGE_EFFECT_CATEGORY)
               {
                  switch(_loc23_.actionId)
                  {
                     case 1054:
                        _loc4_.casterSpellDamagesBonus = _loc4_.casterSpellDamagesBonus + _loc23_.param1;
                        continue;
                     case 1144:
                        _loc4_.casterWeaponDamagesBonus = _loc4_.casterWeaponDamagesBonus + _loc23_.param1;
                        continue;
                     case 1171:
                        _loc4_.casterDamageBoostPercent = _loc4_.casterDamageBoostPercent + _loc23_.param1;
                        continue;
                     case 1172:
                        _loc4_.casterDamageDeboostPercent = _loc4_.casterDamageDeboostPercent + _loc23_.param1;
                        continue;
                     case 781:
                        _loc4_.minimizedEffects = true;
                        continue;
                     case ActionIdConverter.ACTION_CHARACTER_SACRIFY:
                        if(_loc4_.targetId != _loc23_.source)
                        {
                           _loc40_ = false;
                           for each(_loc41_ in _loc4_.interceptedDamages)
                           {
                              if(_loc41_.buffId == _loc23_.id)
                              {
                                 _loc40_ = true;
                              }
                           }
                           if(!_loc40_)
                           {
                              _loc4_.interceptedDamages.push(new InterceptedDamage(_loc23_.id,_loc23_.source,_loc4_.casterId));
                           }
                        }
                        continue;
                     default:
                        continue;
                  }
               }
               else
               {
                  continue;
               }
            }
         }
         _loc4_.spellDamageModification = CurrentPlayedFighterManager.getInstance().getSpellModifications(param1.id,CharacterSpellModificationTypeEnum.DAMAGE);
         return _loc4_;
      }
      
      private static function applyBuffModification(param1:SpellDamageInfo, param2:int, param3:int) : void
      {
         switch(param2)
         {
            case 118:
               param1.casterStrength = param1.casterStrength + param3;
               break;
            case 119:
               param1.casterAgility = param1.casterAgility + param3;
               break;
            case 123:
               param1.casterChance = param1.casterChance + param3;
               break;
            case 126:
               param1.casterIntelligence = param1.casterIntelligence + param3;
               break;
            case 414:
               param1.casterPushDamageBonus = param1.casterPushDamageBonus + param3;
         }
      }
      
      private static function groupBuffsBySpell(param1:Array) : Dictionary
      {
         var _loc2_:Dictionary = null;
         var _loc3_:BasicBuff = null;
         for each(_loc3_ in param1)
         {
            if(!_loc2_)
            {
               _loc2_ = new Dictionary();
            }
            if(!_loc2_[_loc3_.castingSpell.spell.id])
            {
               _loc2_[_loc3_.castingSpell.spell.id] = new Vector.<BasicBuff>(0);
            }
            _loc2_[_loc3_.castingSpell.spell.id].push(_loc3_);
         }
         return _loc2_;
      }
      
      private static function getMinimumDamageEffectOrder(param1:Number, param2:Number, param3:Vector.<EffectInstance>, param4:int) : int
      {
         var _loc5_:EffectInstance = null;
         var _loc7_:int = 0;
         var _loc6_:uint = param3.length;
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_ = param3[_loc7_];
            if((_loc5_.category == 2 || DamageUtil.HEALING_EFFECTS_IDS.indexOf(_loc5_.effectId) != -1 || _loc5_.effectId == 5) && DamageUtil.verifySpellEffectMask(param1,param2,_loc5_,param4))
            {
               return _loc7_;
            }
            _loc7_++;
         }
         return -1;
      }
      
      public function getEffectModification(param1:int, param2:int, param3:Boolean) : EffectModification
      {
         var _loc4_:int = 0;
         var _loc5_:int = !!this._effectsModifications?int(this._effectsModifications.length):0;
         var _loc6_:int = !!this._criticalEffectsModifications?int(this._criticalEffectsModifications.length):0;
         var _loc7_:int = param2;
         if(!param3 && this._effectsModifications)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(this._effectsModifications[_loc4_].effectId == param1)
               {
                  if(_loc7_ == 0)
                  {
                     return this._effectsModifications[_loc4_];
                  }
                  _loc7_--;
               }
               _loc4_++;
            }
         }
         else if(this._criticalEffectsModifications)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               if(this._criticalEffectsModifications[_loc4_].effectId == param1)
               {
                  if(_loc7_ == 0)
                  {
                     return this._criticalEffectsModifications[_loc4_];
                  }
                  _loc7_--;
               }
               _loc4_++;
            }
         }
         return null;
      }
      
      public function get targetId() : Number
      {
         return this._targetId;
      }
      
      public function set targetId(param1:Number) : void
      {
         var _loc3_:BasicBuff = null;
         this._targetId = param1;
         var _loc2_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         if(_loc2_)
         {
            this.targetLevel = _loc2_.getFighterLevel(this._targetId);
            this._targetInfos = _loc2_.entitiesFrame.getEntityInfos(this._targetId) as GameFightFighterInformations;
         }
         if(this.targetInfos)
         {
            this.targetIsMonster = this.targetInfos is GameFightMonsterInformations;
            this.targetShieldPoints = this.targetInfos.stats.shieldPoints;
            this.targetNeutralElementResistPercent = this.targetInfos.stats.neutralElementResistPercent + (!this.targetIsMonster?this.targetInfos.stats.pvpNeutralElementResistPercent:0);
            this.targetEarthElementResistPercent = this.targetInfos.stats.earthElementResistPercent + (!this.targetIsMonster?this.targetInfos.stats.pvpEarthElementResistPercent:0);
            this.targetWaterElementResistPercent = this.targetInfos.stats.waterElementResistPercent + (!this.targetIsMonster?this.targetInfos.stats.pvpWaterElementResistPercent:0);
            this.targetAirElementResistPercent = this.targetInfos.stats.airElementResistPercent + (!this.targetIsMonster?this.targetInfos.stats.pvpAirElementResistPercent:0);
            this.targetFireElementResistPercent = this.targetInfos.stats.fireElementResistPercent + (!this.targetIsMonster?this.targetInfos.stats.pvpFireElementResistPercent:0);
            this.targetNeutralElementReduction = this.targetInfos.stats.neutralElementReduction + (!this.targetIsMonster?this.targetInfos.stats.pvpNeutralElementReduction:0);
            this.targetEarthElementReduction = this.targetInfos.stats.earthElementReduction + (!this.targetIsMonster?this.targetInfos.stats.pvpEarthElementReduction:0);
            this.targetWaterElementReduction = this.targetInfos.stats.waterElementReduction + (!this.targetIsMonster?this.targetInfos.stats.pvpWaterElementReduction:0);
            this.targetAirElementReduction = this.targetInfos.stats.airElementReduction + (!this.targetIsMonster?this.targetInfos.stats.pvpAirElementReduction:0);
            this.targetFireElementReduction = this.targetInfos.stats.fireElementReduction + (!this.targetIsMonster?this.targetInfos.stats.pvpFireElementReduction:0);
            this.targetCriticalDamageFixedResist = this.targetInfos.stats.criticalDamageFixedResist;
            this.targetPushDamageFixedResist = this.targetInfos.stats.pushDamageFixedResist;
            this.targetErosionLifePoints = this.targetInfos.stats.baseMaxLifePoints - this.targetInfos.stats.maxLifePoints;
            this.targetLifePoints = this.targetInfos.stats.lifePoints;
            this.targetBaseMaxLifePoints = this.targetInfos.stats.baseMaxLifePoints;
            this.targetMaxLifePoints = this.targetInfos.stats.maxLifePoints;
            this.targetCell = this.targetInfos.disposition.cellId;
            this.distanceBetweenCasterAndTarget = this.targetCell != -1?int(MapPoint.fromCellId(_loc2_.entitiesFrame.getEntityInfos(this.casterId).disposition.cellId).distanceToCell(MapPoint.fromCellId(this.targetCell))):-1;
         }
         this.targetBuffs = BuffManager.getInstance().getAllBuff(this._targetId);
         this.targetIsInvulnerable = false;
         this.targetIsUnhealable = false;
         this.targetStates = FightersStateManager.getInstance().getStates(param1);
         this.targetStatus = FightersStateManager.getInstance().getStatus(param1);
         this.targetIsInvulnerable = this.targetStatus.invulnerable;
         this.targetIsInvulnerableToMelee = this.targetStatus.invulnerableMelee;
         this.targetIsInvulnerableToRange = this.targetStatus.invulnerableRange;
         this.targetIsUnhealable = this.targetStatus.incurable;
         for each(_loc3_ in this.targetBuffs)
         {
            if(_loc3_.actionId == 776)
            {
               this.targetErosionPercentBonus = this.targetErosionPercentBonus + _loc3_.param1;
            }
            if(_loc3_.actionId == 782)
            {
               this.maximizedEffects = true;
            }
         }
      }
      
      public function get targetInfos() : GameFightFighterInformations
      {
         return this._targetInfos;
      }
      
      public function get originalTargetsIds() : Vector.<Number>
      {
         if(!this._originalTargetsIds)
         {
            this._originalTargetsIds = new Vector.<Number>(0);
         }
         return this._originalTargetsIds;
      }
      
      public function set originalTargetsIds(param1:Vector.<Number>) : void
      {
         this._originalTargetsIds = param1;
      }
      
      public function get triggeredSpells() : Vector.<TriggeredSpell>
      {
         var _loc1_:Vector.<TriggeredSpell> = null;
         var _loc2_:Vector.<TriggeredSpell> = this.getTriggeredSpells(this.spellEffects);
         var _loc3_:Vector.<TriggeredSpell> = this.getTargetBuffsTriggeredSpells(this.spellEffects);
         if(_loc2_ || _loc3_)
         {
            _loc1_ = new Vector.<TriggeredSpell>();
            if(_loc2_)
            {
               _loc1_ = _loc1_.concat(_loc2_);
            }
            if(_loc3_)
            {
               _loc1_ = _loc1_.concat(_loc3_);
            }
         }
         return _loc1_;
      }
      
      public function get criticalTriggeredSpells() : Vector.<TriggeredSpell>
      {
         var _loc1_:Vector.<TriggeredSpell> = null;
         var _loc2_:Vector.<TriggeredSpell> = this.getTriggeredSpells(this.spellCriticalEffects);
         var _loc3_:Vector.<TriggeredSpell> = this.getTargetBuffsTriggeredSpells(this.spellCriticalEffects);
         if(_loc2_ || _loc3_)
         {
            _loc1_ = new Vector.<TriggeredSpell>();
            if(_loc2_)
            {
               _loc1_ = _loc1_.concat(_loc2_);
            }
            if(_loc3_)
            {
               _loc1_ = _loc1_.concat(_loc3_);
            }
         }
         return _loc1_;
      }
      
      private function getTriggeredSpells(param1:Vector.<EffectInstance>) : Vector.<TriggeredSpell>
      {
         var _loc2_:BasicBuff = null;
         var _loc3_:Vector.<TriggeredSpell> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:EffectInstance = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         if(!param1)
         {
            return null;
         }
         var _loc10_:uint = param1.length;
         _loc9_ = 0;
         for(; _loc9_ < _loc10_; _loc9_++)
         {
            _loc6_ = param1[_loc9_];
            if(DamageUtil.verifySpellEffectMask(this.casterId,this.targetId,_loc6_,this.spellCenterCell) && DamageUtil.verifyEffectTrigger(this.casterId,this.targetId,param1,_loc6_,false,_loc6_.triggers,this.spellCenterCell))
            {
               switch(_loc6_.effectId)
               {
                  case ActionIdConverter.ACTION_TARGET_CASTS_SPELL:
                  case ActionIdConverter.ACTION_TARGET_CASTS_SPELL_WITH_ANIM:
                     if(_loc6_.duration > 0)
                     {
                        continue;
                     }
                     _loc7_ = _loc8_ = this.targetId;
                     break;
                  case ActionIdConverter.ACTION_CASTER_EXECUTE_SPELL:
                     _loc7_ = this.casterId;
                     _loc8_ = this.targetId;
                     break;
                  case ActionIdConverter.ACTION_TARGET_EXECUTE_SPELL_ON_SOURCE:
                     _loc7_ = this.targetId;
                     _loc8_ = this.casterId;
                     break;
                  default:
                     continue;
               }
               _loc4_ = int(_loc6_.parameter0);
               _loc5_ = int(_loc6_.parameter1);
               if(!_loc3_)
               {
                  _loc3_ = new Vector.<TriggeredSpell>();
               }
               _loc3_.push(TriggeredSpell.create(_loc6_.triggers,_loc4_,_loc5_,_loc7_,_loc8_,_loc6_.effectId,_loc9_,false));
               continue;
            }
         }
         return _loc3_;
      }
      
      private function getTargetBuffsTriggeredSpells(param1:Vector.<EffectInstance>) : Vector.<TriggeredSpell>
      {
         var _loc2_:BasicBuff = null;
         var _loc3_:Vector.<TriggeredSpell> = null;
         var _loc4_:int = 0;
         for each(_loc2_ in this.targetBuffs)
         {
            if((!_loc2_.hasOwnProperty("delay") || _loc2_["delay"] == 0) && (_loc2_.effect.effectId == ActionIdConverter.ACTION_TARGET_CASTS_SPELL || _loc2_.effect.effectId == ActionIdConverter.ACTION_TARGET_CASTS_SPELL_WITH_ANIM || _loc2_.effect.effectId == ActionIdConverter.ACTION_TARGET_EXECUTE_SPELL_ON_SOURCE) && DamageUtil.verifyBuffTriggers(_loc2_,param1,this.casterId,this.targetId,this.isWeapon,this.spellCenterCell,null))
            {
               if(!_loc3_)
               {
                  _loc3_ = new Vector.<TriggeredSpell>(0);
               }
               _loc4_ = int(_loc2_.effect.parameter0);
               _loc3_.push(TriggeredSpell.create(_loc2_.effect.triggers,_loc4_,int(_loc2_.effect.parameter1),this.targetId,this.targetId,_loc2_.effect.effectId,0,false));
            }
         }
         return _loc3_;
      }
      
      public function addTriggeredSpellsEffects(param1:Vector.<TriggeredSpell>, param2:Boolean) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:TriggeredSpell = null;
         var _loc7_:EffectInstance = null;
         var _loc8_:EffectInstance = null;
         var _loc9_:int = 0;
         var _loc10_:EffectModification = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc5_:int = this.spellEffects.length;
         var _loc6_:int = !!this.spellCriticalEffects?int(this.spellCriticalEffects.length):0;
         for each(_loc4_ in param1)
         {
            _loc11_ = 0;
            _loc12_ = 0;
            _loc9_ = 0;
            while(_loc9_ < _loc5_)
            {
               _loc7_ = this.spellEffects[_loc9_];
               if(_loc7_.random == 0 && DamageUtil.verifyEffectTrigger(this.casterId,this.targetId,this.spellEffects,_loc7_,this.isWeapon,_loc4_.triggers,this.spellCenterCell))
               {
                  for each(_loc8_ in _loc4_.spell.effects)
                  {
                     _loc13_ = DamageUtil.verifySpellEffectMask(_loc4_.spell.playerId,this.casterId,_loc8_,this.spellCenterCell,this.casterId);
                     _loc14_ = DamageUtil.verifySpellEffectMask(_loc4_.spell.playerId,_loc4_.spell.playerId,_loc8_,this.spellCenterCell,this.casterId);
                     if(DamageUtil.TRIGGERED_EFFECTS_IDS.indexOf(_loc8_.effectId) != -1)
                     {
                        if(!this._effectsModifications)
                        {
                           this._effectsModifications = new Vector.<EffectModification>(0);
                        }
                        _loc10_ = _loc9_ + 1 <= this._effectsModifications.length?this._effectsModifications[_loc9_]:null;
                        if(!_loc10_)
                        {
                           _loc10_ = new EffectModification(_loc7_.effectId);
                           if(!param2)
                           {
                              this._effectsModifications.push(_loc10_);
                           }
                           else
                           {
                              this._criticalEffectsModifications.push(_loc10_);
                           }
                        }
                        if(Effect.getEffectById(_loc8_.effectId).active && _loc13_)
                        {
                           switch(_loc8_.effectId)
                           {
                              case 138:
                                 _loc10_.damagesBonus = _loc10_.damagesBonus + _loc11_;
                                 _loc11_ = _loc11_ + (_loc8_ as EffectInstanceDice).diceNum;
                           }
                        }
                        if(_loc14_)
                        {
                           switch(_loc8_.effectId)
                           {
                              case 1040:
                                 _loc10_.shieldPoints = _loc10_.shieldPoints + _loc12_;
                                 _loc12_ = _loc12_ + (_loc8_ as EffectInstanceDice).diceNum;
                           }
                        }
                        _loc3_ = true;
                     }
                  }
               }
               _loc9_++;
            }
         }
         return _loc3_;
      }
      
      public function getDamageSharingTargets() : Vector.<Number>
      {
         var _loc1_:Vector.<Number> = null;
         var _loc2_:BasicBuff = null;
         var _loc3_:BasicBuff = null;
         var _loc4_:Vector.<Number> = null;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         var _loc7_:Boolean = false;
         var _loc8_:SplashDamage = null;
         if(this.splashDamages)
         {
            for each(_loc8_ in this.splashDamages)
            {
               if(_loc8_.targets.indexOf(this.targetId) != -1)
               {
                  _loc7_ = true;
                  break;
               }
            }
         }
         for each(_loc2_ in this.targetBuffs)
         {
            if(_loc2_.actionId == 1061 && (DamageUtil.verifyBuffTriggers(_loc2_,this.spellEffects,this.casterId,this.targetId,this.isWeapon,this.spellCenterCell,this.splashDamages) || _loc7_))
            {
               _loc1_ = new Vector.<Number>(0);
               if(this._originalTargetsIds.indexOf(this.targetId) != -1 || _loc7_)
               {
                  _loc1_.push(this.targetId);
               }
               _loc4_ = (Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).getEntitiesIdsList();
               for each(_loc5_ in _loc4_)
               {
                  if(_loc5_ != this.targetId)
                  {
                     _loc6_ = BuffManager.getInstance().getAllBuff(_loc5_);
                     for each(_loc3_ in _loc6_)
                     {
                        if(_loc3_.actionId == 1061)
                        {
                           _loc1_.push(_loc5_);
                           break;
                        }
                     }
                  }
               }
               break;
            }
         }
         return _loc1_;
      }
      
      public function getReflectDamages() : Vector.<ReflectDamage>
      {
         var _loc1_:Vector.<ReflectDamage> = null;
         var _loc2_:Vector.<ReflectDamage> = null;
         var _loc3_:Vector.<ReflectDamage> = null;
         var _loc5_:ReflectValues = null;
         var _loc6_:Number = NaN;
         var _loc4_:SpellDamage = new SpellDamage();
         for each(_loc6_ in this._originalTargetsIds)
         {
            _loc5_ = DamageUtil.getReflectDamageValues(_loc6_);
            if(_loc6_ != this.casterId && _loc5_)
            {
               if(_loc5_.reflectValue > 0)
               {
                  if(!_loc2_)
                  {
                     _loc2_ = new Vector.<ReflectDamage>(0);
                  }
                  this.addReflectDamage(_loc2_,this.neutralDamage,_loc5_.reflectValue,false,_loc6_);
                  this.addReflectDamage(_loc2_,this.earthDamage,_loc5_.reflectValue,false,_loc6_);
                  this.addReflectDamage(_loc2_,this.fireDamage,_loc5_.reflectValue,false,_loc6_);
                  this.addReflectDamage(_loc2_,this.waterDamage,_loc5_.reflectValue,false,_loc6_);
                  this.addReflectDamage(_loc2_,this.airDamage,_loc5_.reflectValue,false,_loc6_);
               }
               if(_loc5_.boostedReflectValue > 0)
               {
                  if(!_loc3_)
                  {
                     _loc3_ = new Vector.<ReflectDamage>(0);
                  }
                  this.addReflectDamage(_loc3_,this.neutralDamage,_loc5_.boostedReflectValue,true,_loc6_);
                  this.addReflectDamage(_loc3_,this.earthDamage,_loc5_.boostedReflectValue,true,_loc6_);
                  this.addReflectDamage(_loc3_,this.fireDamage,_loc5_.boostedReflectValue,true,_loc6_);
                  this.addReflectDamage(_loc3_,this.waterDamage,_loc5_.boostedReflectValue,true,_loc6_);
                  this.addReflectDamage(_loc3_,this.airDamage,_loc5_.boostedReflectValue,true,_loc6_);
               }
            }
         }
         if(_loc2_)
         {
            if(!_loc1_)
            {
               _loc1_ = new Vector.<ReflectDamage>(0);
            }
            _loc1_ = _loc1_.concat(_loc2_);
         }
         if(_loc3_)
         {
            if(!_loc1_)
            {
               _loc1_ = new Vector.<ReflectDamage>(0);
            }
            _loc1_ = _loc1_.concat(_loc3_);
         }
         return _loc1_;
      }
      
      private function addReflectDamage(param1:Vector.<ReflectDamage>, param2:SpellDamage, param3:uint, param4:Boolean, param5:Number) : void
      {
         var _loc6_:EffectDamage = null;
         var _loc7_:ReflectDamage = null;
         var _loc8_:Boolean = false;
         var _loc9_:EffectDamage = null;
         for each(_loc9_ in param2.effectDamages)
         {
            _loc6_ = new EffectDamage(-1,_loc9_.element,_loc9_.random);
            _loc6_.minDamage = _loc9_.minDamage;
            _loc6_.minCriticalDamage = _loc9_.minCriticalDamage;
            _loc6_.maxDamage = _loc9_.maxDamage;
            _loc6_.maxCriticalDamage = _loc9_.maxCriticalDamage;
            _loc6_.hasCritical = _loc9_.hasCritical;
            _loc8_ = false;
            for each(_loc7_ in param1)
            {
               if(_loc7_.sourceId == param5)
               {
                  _loc7_.addEffect(_loc6_);
                  _loc8_ = true;
                  break;
               }
            }
            if(!_loc8_)
            {
               _loc7_ = new ReflectDamage(param5,param3,param4);
               _loc7_.addEffect(_loc6_);
               param1.push(_loc7_);
            }
         }
      }
      
      public function hasLifeSteal() : Boolean
      {
         var _loc2_:SpellDamage = null;
         var _loc3_:EffectDamage = null;
         var _loc1_:Vector.<SpellDamage> = new Vector.<SpellDamage>(0);
         _loc1_.push(this.neutralDamage,this.earthDamage,this.fireDamage,this.waterDamage,this.airDamage);
         for each(_loc2_ in _loc1_)
         {
            for each(_loc3_ in _loc2_.effectDamages)
            {
               if(DamageUtil.LIFE_STEAL_EFFECTS_IDS.indexOf(_loc3_.effectId) != -1)
               {
                  return true;
               }
            }
         }
         return false;
      }
   }
}
