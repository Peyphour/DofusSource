package com.ankamagames.dofus.logic.game.fight.miscs
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.datacenter.effects.Effect;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceInteger;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceMinMax;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.monsters.MonsterGrade;
   import com.ankamagames.dofus.datacenter.spells.SpellBomb;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.FightersStateManager;
   import com.ankamagames.dofus.logic.game.fight.managers.LinkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.managers.SpellDamagesManager;
   import com.ankamagames.dofus.logic.game.fight.managers.SpellZoneManager;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.EffectDamage;
   import com.ankamagames.dofus.logic.game.fight.types.EffectModification;
   import com.ankamagames.dofus.logic.game.fight.types.InterceptedDamage;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.dofus.logic.game.fight.types.PushedEntity;
   import com.ankamagames.dofus.logic.game.fight.types.ReflectDamage;
   import com.ankamagames.dofus.logic.game.fight.types.ReflectValues;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamage;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamageInfo;
   import com.ankamagames.dofus.logic.game.fight.types.SplashDamage;
   import com.ankamagames.dofus.logic.game.fight.types.StatBuff;
   import com.ankamagames.dofus.logic.game.fight.types.TriggeredSpell;
   import com.ankamagames.dofus.network.enums.CharacterSpellModificationTypeEnum;
   import com.ankamagames.dofus.network.enums.GameActionMarkTypeEnum;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterSpellModification;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCompanionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellShapeEnum;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class DamageUtil
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(DamageUtil));
      
      private static const exclusiveTargetMasks:RegExp = /\*?[bBeEfFzZKoOPpTWUvV][0-9]*/g;
      
      public static const UNKNOWN_ELEMENT:int = -1;
      
      public static const NEUTRAL_ELEMENT:int = 0;
      
      public static const EARTH_ELEMENT:int = 1;
      
      public static const FIRE_ELEMENT:int = 2;
      
      public static const WATER_ELEMENT:int = 3;
      
      public static const AIR_ELEMENT:int = 4;
      
      public static const EFFECTSHAPE_DEFAULT_AREA_SIZE:int = 1;
      
      public static const EFFECTSHAPE_DEFAULT_MIN_AREA_SIZE:int = 0;
      
      public static const EFFECTSHAPE_DEFAULT_EFFICIENCY:int = 10;
      
      public static const EFFECTSHAPE_DEFAULT_MAX_EFFICIENCY_APPLY:int = 4;
      
      private static const DAMAGE_NOT_BOOSTED:int = 1;
      
      private static const UNLIMITED_ZONE_SIZE:int = 50;
      
      private static const AT_LEAST_MASK_TYPES:Array = ["B","F","Z"];
      
      private static const ZONE_MAX_SIZE:int = 63;
      
      public static const DAMAGE_EFFECT_CATEGORY:int = 2;
      
      public static const EROSION_DAMAGE_EFFECTS_IDS:Array = [1092,1093,1094,1095,1096];
      
      public static const HEALING_EFFECTS_IDS:Array = [81,108,1109,90];
      
      public static const IMMEDIATE_BOOST_EFFECTS_IDS:Array = [266,268,269,271,414];
      
      public static const BOMB_SPELLS_IDS:Array = [2796,2797,2808];
      
      public static const SPLASH_EFFECTS_IDS:Array = [1123,1124,1125,1126,1127,1128,2020];
      
      public static const SPLASH_HEAL_EFFECT_ID:uint = 2020;
      
      public static const MP_BASED_DAMAGE_EFFECTS_IDS:Array = [1012,1013,1014,1015,1016];
      
      public static const HP_BASED_DAMAGE_EFFECTS_IDS:Array = [672,85,86,87,88,89];
      
      public static const ERODED_HP_BASED_DAMAGE_EFFETS_IDS:Array = [1118,1119,1120,1121,1122];
      
      public static const TARGET_HP_BASED_DAMAGE_EFFECTS_IDS:Array = [1067,1068,1069,1070,1071,1048];
      
      public static const TRIGGERED_EFFECTS_IDS:Array = [138,1040];
      
      public static const NO_BOOST_EFFECTS_IDS:Array = [144,82];
      
      public static const LIFE_STEAL_EFFECTS_IDS:Array = [91,92,93,94,95,82];
      
      public static const SHIELD_GAIN_EFFECTS_IDS:Array = [1039,1040];
      
      public static const REFLECT_EFFETS_IDS:Array = [107,220];
       
      
      public function DamageUtil()
      {
         super();
      }
      
      public static function isDamagedOrHealedBySpell(param1:Number, param2:Number, param3:Object, param4:int) : Boolean
      {
         var _loc11_:Boolean = false;
         var _loc12_:EffectInstance = null;
         var _loc14_:FightContextFrame = null;
         var _loc15_:IZone = null;
         var _loc16_:Vector.<uint> = null;
         var _loc17_:uint = 0;
         var _loc18_:Array = null;
         var _loc19_:AnimatedCharacter = null;
         var _loc20_:Array = null;
         var _loc21_:BasicBuff = null;
         var _loc5_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         if(!param3 || !_loc5_)
         {
            return false;
         }
         var _loc6_:GameFightFighterInformations = _loc5_.getEntityInfos(param2) as GameFightFighterInformations;
         if(!_loc6_)
         {
            return false;
         }
         var _loc7_:TiphonSprite = DofusEntities.getEntity(param2) as AnimatedCharacter;
         var _loc8_:* = param2 == param1;
         var _loc9_:Boolean = _loc7_ && _loc7_.parentSprite && _loc7_.parentSprite.carriedEntity == _loc7_;
         var _loc10_:GameFightFighterInformations = _loc5_.getEntityInfos(param1) as GameFightFighterInformations;
         if(!(param3 is SpellWrapper) || param3.id == 0)
         {
            if(!_loc8_ && !_loc9_)
            {
               return true;
            }
            if(!_loc9_)
            {
               _loc14_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               _loc15_ = SpellZoneManager.getInstance().getSpellZone(param3,false,false);
               _loc15_.direction = MapPoint.fromCellId(_loc10_.disposition.cellId).advancedOrientationTo(MapPoint.fromCellId(param4),false);
               _loc16_ = _loc15_.getCells(param4);
               for each(_loc17_ in _loc16_)
               {
                  if(_loc17_ != _loc10_.disposition.cellId)
                  {
                     _loc18_ = EntitiesManager.getInstance().getEntitiesOnCell(_loc17_,AnimatedCharacter);
                     for each(_loc19_ in _loc18_)
                     {
                        if(_loc19_.id != param1 && _loc14_.entitiesFrame.getEntityInfos(_loc19_.id) && isDamagedOrHealedBySpell(param1,_loc19_.id,param3,param4) && getReflectDamageValues(_loc19_.id))
                        {
                           return true;
                        }
                     }
                  }
               }
               return false;
            }
            return false;
         }
         var _loc13_:Boolean = PushUtil.isPushableEntity(_loc6_);
         if(BOMB_SPELLS_IDS.indexOf(param3.id) != -1)
         {
            param3 = getBombDirectDamageSpellWrapper(param3 as SpellWrapper);
         }
         for each(_loc12_ in param3.effects)
         {
            if(_loc12_.triggers == "I" && (_loc12_.category == 2 || HEALING_EFFECTS_IDS.indexOf(_loc12_.effectId) != -1 || SHIELD_GAIN_EFFECTS_IDS.indexOf(_loc12_.effectId) != -1 || _loc12_.effectId == 5 && _loc13_) && verifySpellEffectMask(param1,param2,_loc12_,param4) && (_loc12_.targetMask.indexOf("C") != -1 && _loc8_ || verifySpellEffectZone(param2,_loc12_,param4,_loc10_.disposition.cellId)))
            {
               _loc11_ = true;
               break;
            }
         }
         if(!_loc11_)
         {
            for each(_loc12_ in param3.criticalEffect)
            {
               if(_loc12_.triggers == "I" && (_loc12_.category == 2 || HEALING_EFFECTS_IDS.indexOf(_loc12_.effectId) != -1 || SHIELD_GAIN_EFFECTS_IDS.indexOf(_loc12_.effectId) != -1 || _loc12_.effectId == 5 && _loc13_) && verifySpellEffectMask(param1,param2,_loc12_,param4) && verifySpellEffectZone(param2,_loc12_,param4,_loc10_.disposition.cellId))
               {
                  _loc11_ = true;
                  break;
               }
            }
         }
         if(!_loc11_)
         {
            _loc20_ = BuffManager.getInstance().getAllBuff(param2);
            if(_loc20_)
            {
               for each(_loc21_ in _loc20_)
               {
                  if(_loc21_.effect.category == DAMAGE_EFFECT_CATEGORY)
                  {
                     for each(_loc12_ in param3.effects)
                     {
                        if(verifyEffectTrigger(param1,param2,param3.effects,_loc12_,param3 is SpellWrapper,_loc21_.effect.triggers,param4))
                        {
                           return true;
                        }
                     }
                     for each(_loc12_ in param3.criticalEffect)
                     {
                        if(verifyEffectTrigger(param1,param2,param3.criticalEffect,_loc12_,param3 is SpellWrapper,_loc21_.effect.triggers,param4))
                        {
                           return true;
                        }
                     }
                  }
               }
            }
         }
         return _loc11_;
      }
      
      public static function getBombDirectDamageSpellWrapper(param1:SpellWrapper) : SpellWrapper
      {
         return SpellWrapper.create(SpellBomb.getSpellBombById((param1.effects[0] as EffectInstanceDice).diceNum).instantSpellId,param1.spellLevel,true,param1.playerId);
      }
      
      public static function getBuffEffectElements(param1:BasicBuff) : Vector.<int>
      {
         var _loc2_:Vector.<int> = null;
         var _loc4_:EffectInstance = null;
         var _loc5_:SpellLevel = null;
         var _loc3_:Effect = Effect.getEffectById(param1.effect.effectId);
         if(_loc3_.elementId == -1)
         {
            _loc5_ = param1.castingSpell.spellRank;
            if(!_loc5_)
            {
               _loc5_ = SpellLevel.getLevelById(param1.castingSpell.spell.spellLevels[0]);
            }
            for each(_loc4_ in _loc5_.effects)
            {
               if(_loc4_.effectId == param1.effect.effectId)
               {
                  if(!_loc2_)
                  {
                     _loc2_ = new Vector.<int>(0);
                  }
                  if(_loc4_.triggers.indexOf("DA") != -1 && _loc2_.indexOf(AIR_ELEMENT) == -1)
                  {
                     _loc2_.push(AIR_ELEMENT);
                  }
                  if(_loc4_.triggers.indexOf("DE") != -1 && _loc2_.indexOf(EARTH_ELEMENT) == -1)
                  {
                     _loc2_.push(EARTH_ELEMENT);
                  }
                  if(_loc4_.triggers.indexOf("DF") != -1 && _loc2_.indexOf(FIRE_ELEMENT) == -1)
                  {
                     _loc2_.push(FIRE_ELEMENT);
                  }
                  if(_loc4_.triggers.indexOf("DN") != -1 && _loc2_.indexOf(NEUTRAL_ELEMENT) == -1)
                  {
                     _loc2_.push(NEUTRAL_ELEMENT);
                  }
                  if(_loc4_.triggers.indexOf("DW") != -1 && _loc2_.indexOf(WATER_ELEMENT) == -1)
                  {
                     _loc2_.push(WATER_ELEMENT);
                  }
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public static function verifyBuffTriggers(param1:BasicBuff, param2:Vector.<EffectInstance>, param3:Number, param4:Number, param5:Boolean, param6:int, param7:Vector.<SplashDamage>) : Boolean
      {
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:EffectInstance = null;
         var _loc12_:Array = null;
         var _loc13_:BasicBuff = null;
         var _loc14_:BasicBuff = null;
         var _loc15_:SplashDamage = null;
         var _loc8_:String = param1.effect.triggers;
         if(_loc8_)
         {
            _loc9_ = _loc8_.split("|");
            _loc12_ = BuffManager.getInstance().getAllBuff(param4);
            for each(_loc14_ in _loc12_)
            {
               if(_loc14_.actionId == ActionIdConverter.ACTION_CHARACTER_SACRIFY)
               {
                  _loc13_ = _loc14_;
                  break;
               }
            }
            for each(_loc10_ in _loc9_)
            {
               for each(_loc11_ in param2)
               {
                  if(!(_loc10_.indexOf("D") != -1 && _loc13_ && _loc13_ != param1))
                  {
                     if(verifyEffectTrigger(param3,param4,param2,_loc11_,param5,_loc10_,param6))
                     {
                        return true;
                     }
                  }
               }
               for each(_loc15_ in param7)
               {
                  if(_loc15_.targets.indexOf(param4) != -1 && verifyEffectTrigger(_loc15_.casterId,param4,null,_loc15_.effect,false,_loc10_,_loc15_.casterCell,param3))
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      public static function verifyEffectTrigger(param1:Number, param2:Number, param3:Vector.<EffectInstance>, param4:EffectInstance, param5:Boolean, param6:String, param7:int, param8:Number = 0) : Boolean
      {
         var _loc11_:String = null;
         var _loc12_:* = false;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc9_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         if(!_loc9_)
         {
            return false;
         }
         var _loc10_:Array = param6.split("|");
         var _loc13_:GameFightFighterInformations = _loc9_.getEntityInfos(param1) as GameFightFighterInformations;
         var _loc14_:GameFightFighterInformations = _loc9_.getEntityInfos(param2) as GameFightFighterInformations;
         var _loc15_:* = _loc14_.teamId == (_loc9_.getEntityInfos(param1) as GameFightFighterInformations).teamId;
         var _loc16_:int = _loc14_.disposition.cellId != -1?int(MapPoint.fromCellId(_loc13_.disposition.cellId).distanceTo(MapPoint.fromCellId(_loc14_.disposition.cellId))):-1;
         for each(_loc11_ in _loc10_)
         {
            if(!(param4.effectId == 5 && _loc11_ != "MD"))
            {
               _loc18_ = param5 || !param4.targetMask || verifySpellEffectMask(param1,param2,param4,param7,param8);
               _loc17_ = param4.category == DAMAGE_EFFECT_CATEGORY && param4.effectId != SPLASH_HEAL_EFFECT_ID && _loc18_ && (param4.targetMask && param4.targetMask.indexOf("O") != -1 && param2 == param8 || verifySpellEffectZone(param2,param4,param7,_loc13_.disposition.cellId));
               switch(_loc11_)
               {
                  case "I":
                     _loc12_ = true;
                     break;
                  case "D":
                     _loc12_ = Boolean(_loc17_);
                     break;
                  case "DA":
                     _loc12_ = Boolean(_loc17_ && Effect.getEffectById(param4.effectId).elementId == AIR_ELEMENT);
                     break;
                  case "DBA":
                     _loc12_ = Boolean(_loc17_ && _loc15_);
                     break;
                  case "DBE":
                     _loc12_ = Boolean(_loc17_ && !_loc15_);
                     break;
                  case "DC":
                     _loc12_ = Boolean(param5);
                     break;
                  case "DE":
                     _loc12_ = Boolean(_loc17_ && Effect.getEffectById(param4.effectId).elementId == EARTH_ELEMENT);
                     break;
                  case "DF":
                     _loc12_ = Boolean(_loc17_ && Effect.getEffectById(param4.effectId).elementId == FIRE_ELEMENT);
                     break;
                  case "DG":
                     break;
                  case "DI":
                     break;
                  case "DM":
                     _loc12_ = Boolean(_loc16_ == -1?false:_loc17_ && _loc16_ <= 1);
                     break;
                  case "DN":
                     _loc12_ = Boolean(_loc17_ && Effect.getEffectById(param4.effectId).elementId == NEUTRAL_ELEMENT);
                     break;
                  case "DP":
                     break;
                  case "DR":
                     _loc12_ = Boolean(_loc16_ == -1?false:_loc17_ && _loc16_ > 1);
                     break;
                  case "Dr":
                     break;
                  case "DS":
                     _loc12_ = !param5;
                     break;
                  case "DTB":
                     break;
                  case "DTE":
                     break;
                  case "DW":
                     _loc12_ = Boolean(_loc17_ && Effect.getEffectById(param4.effectId).elementId == WATER_ELEMENT);
                     break;
                  case "MD":
                     _loc12_ = Boolean(param3 && PushUtil.hasPushDamages(param1,param2,param3,param4,param7));
                     break;
                  case "MDM":
                     break;
                  case "MDP":
                     break;
                  case "A":
                     _loc12_ = param4.effectId == 101;
                     break;
                  case "m":
                     _loc12_ = param4.effectId == 127;
                     break;
                  case "H":
                     _loc12_ = HEALING_EFFECTS_IDS.indexOf(param4.effectId) != -1;
               }
               if(_loc12_)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function verifySpellEffectMask(param1:Number, param2:Number, param3:EffectInstance, param4:int, param5:Number = 0) : Boolean
      {
         var _loc16_:RegExp = null;
         var _loc18_:Array = null;
         var _loc19_:String = null;
         var _loc20_:String = null;
         var _loc21_:* = false;
         var _loc22_:* = false;
         var _loc23_:Boolean = false;
         var _loc24_:int = 0;
         var _loc25_:Dictionary = null;
         var _loc26_:Vector.<String> = null;
         var _loc27_:String = null;
         var _loc28_:Vector.<String> = null;
         var _loc29_:Boolean = false;
         var _loc30_:String = null;
         var _loc31_:int = 0;
         var _loc6_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         if(!_loc6_)
         {
            return true;
         }
         if(!param3 || param3.delay > 0 || !param3.targetMask)
         {
            return false;
         }
         var _loc7_:TiphonSprite = DofusEntities.getEntity(param2) as AnimatedCharacter;
         var _loc8_:* = param2 == param1;
         var _loc9_:Boolean = _loc7_ && _loc7_.parentSprite && _loc7_.parentSprite.carriedEntity == _loc7_;
         var _loc10_:GameFightFighterInformations = _loc6_.getEntityInfos(param1) as GameFightFighterInformations;
         var _loc11_:GameFightFighterInformations = _loc6_.getEntityInfos(param2) as GameFightFighterInformations;
         var _loc12_:GameFightMonsterInformations = _loc11_ as GameFightMonsterInformations;
         var _loc13_:Array = FightersStateManager.getInstance().getStates(param1);
         var _loc14_:Array = FightersStateManager.getInstance().getStates(param2);
         var _loc15_:* = _loc11_.teamId == (_loc6_.getEntityInfos(param1) as GameFightFighterInformations).teamId;
         var _loc17_:String = "";
         if(param1 == CurrentPlayedFighterManager.getInstance().currentFighterId && param3.category == 0 && param3.targetMask == "C")
         {
            return true;
         }
         if(_loc8_)
         {
            if(param3.effectId == 90)
            {
               return true;
            }
            if(param3.targetMask.indexOf("g") == -1)
            {
               if(verifySpellEffectZone(param1,param3,param4,_loc11_.disposition.cellId))
               {
                  _loc17_ = "caC";
               }
               else
               {
                  _loc17_ = "C";
               }
            }
            else
            {
               return false;
            }
         }
         else
         {
            if(_loc9_ && param3.zoneShape != SpellShapeEnum.A && param3.zoneShape != SpellShapeEnum.a)
            {
               return false;
            }
            if(_loc11_.stats.summoned && _loc12_ && !Monster.getMonsterById(_loc12_.creatureGenericId).canPlay)
            {
               _loc17_ = !!_loc15_?"sj":"SJ";
            }
            else if(_loc11_.stats.summoned)
            {
               _loc17_ = !!_loc15_?"ij":"IJ";
               _loc23_ = true;
            }
            else if(_loc11_ is GameFightCompanionInformations)
            {
               _loc17_ = !!_loc15_?"dl":"DL";
            }
            if(_loc12_)
            {
               _loc17_ = _loc17_ + (!!_loc15_?"ag":"A");
               if(!_loc23_)
               {
                  _loc17_ = _loc17_ + (!!_loc15_?"m":"M");
               }
            }
            else
            {
               _loc17_ = _loc17_ + (!!_loc15_?"aghl":"AHL");
            }
         }
         _loc16_ = new RegExp("[" + _loc17_ + "]","g");
         _loc22_ = param3.targetMask.match(_loc16_).length > 0;
         if(_loc22_)
         {
            _loc18_ = param3.targetMask.match(exclusiveTargetMasks);
            if(_loc18_.length > 0)
            {
               _loc22_ = false;
               _loc25_ = new Dictionary();
               _loc26_ = new Vector.<String>(0);
               for each(_loc19_ in _loc18_)
               {
                  _loc27_ = _loc19_.charAt(0);
                  if(_loc27_ == "*")
                  {
                     _loc27_ = _loc19_.substr(0,2);
                  }
                  if(AT_LEAST_MASK_TYPES.indexOf(_loc27_) != -1)
                  {
                     if(_loc26_.indexOf(_loc27_) != -1)
                     {
                        if(!_loc25_[_loc27_])
                        {
                           _loc25_[_loc27_] = 2;
                        }
                        else
                        {
                           _loc25_[_loc27_]++;
                        }
                     }
                     else
                     {
                        _loc26_.push(_loc27_);
                     }
                  }
               }
               _loc28_ = new Vector.<String>(0);
               for each(_loc19_ in _loc18_)
               {
                  _loc21_ = _loc19_.charAt(0) == "*";
                  _loc19_ = !!_loc21_?_loc19_.substr(1,_loc19_.length - 1):_loc19_;
                  _loc20_ = _loc19_.length > 1?_loc19_.substr(1,_loc19_.length - 1):null;
                  _loc19_ = _loc19_.charAt(0);
                  switch(_loc19_)
                  {
                     case "b":
                        break;
                     case "B":
                        break;
                     case "e":
                        _loc24_ = parseInt(_loc20_);
                        if(_loc21_)
                        {
                           _loc22_ = Boolean(!_loc13_ || _loc13_.indexOf(_loc24_) == -1);
                        }
                        else
                        {
                           _loc22_ = Boolean(!_loc14_ || _loc14_.indexOf(_loc24_) == -1);
                        }
                        break;
                     case "E":
                        _loc24_ = parseInt(_loc20_);
                        if(_loc21_)
                        {
                           _loc22_ = Boolean(_loc13_ && _loc13_.indexOf(_loc24_) != -1);
                        }
                        else
                        {
                           _loc22_ = Boolean(_loc14_ && _loc14_.indexOf(_loc24_) != -1);
                        }
                        break;
                     case "f":
                        _loc22_ = Boolean(!_loc12_ || _loc12_.creatureGenericId != parseInt(_loc20_));
                        break;
                     case "F":
                        _loc22_ = Boolean(_loc12_ && _loc12_.creatureGenericId == parseInt(_loc20_));
                        break;
                     case "z":
                        break;
                     case "Z":
                        break;
                     case "K":
                        break;
                     case "o":
                        _loc22_ = Boolean(param5 != 0 && param2 == param5 && verifySpellEffectZone(param5,param3,param4,_loc10_.disposition.cellId));
                        break;
                     case "O":
                        _loc22_ = Boolean(param5 != 0 && param2 == param5);
                        break;
                     case "p":
                        break;
                     case "P":
                        break;
                     case "T":
                        break;
                     case "W":
                        break;
                     case "U":
                        break;
                     case "v":
                        if(_loc21_)
                        {
                           _loc22_ = _loc10_.stats.lifePoints / _loc10_.stats.maxLifePoints * 100 > parseInt(_loc20_);
                        }
                        else
                        {
                           _loc22_ = _loc11_.stats.lifePoints / _loc11_.stats.maxLifePoints * 100 > parseInt(_loc20_);
                        }
                        break;
                     case "V":
                        if(_loc21_)
                        {
                           _loc22_ = _loc10_.stats.lifePoints / _loc10_.stats.maxLifePoints * 100 <= parseInt(_loc20_);
                        }
                        else
                        {
                           _loc22_ = _loc11_.stats.lifePoints / _loc11_.stats.maxLifePoints * 100 <= parseInt(_loc20_);
                        }
                  }
                  _loc27_ = !!_loc21_?"*" + _loc19_:_loc19_;
                  _loc29_ = _loc25_[_loc27_];
                  if(!_loc30_ || _loc27_ == _loc30_)
                  {
                     _loc31_++;
                  }
                  else
                  {
                     _loc31_ = 0;
                  }
                  _loc30_ = _loc27_;
                  if(_loc22_ && _loc29_ && _loc28_.indexOf(_loc27_) == -1)
                  {
                     _loc28_.push(_loc27_);
                  }
                  if(!_loc22_)
                  {
                     if(!_loc29_)
                     {
                        return false;
                     }
                     if(_loc28_.indexOf(_loc27_) != -1)
                     {
                        _loc22_ = true;
                     }
                     else if(_loc25_[_loc27_] == _loc31_)
                     {
                        return false;
                     }
                  }
               }
            }
         }
         return _loc22_;
      }
      
      public static function verifySpellEffectZone(param1:Number, param2:EffectInstance, param3:int, param4:int) : Boolean
      {
         var _loc6_:Boolean = false;
         var _loc8_:IZone = null;
         var _loc9_:Vector.<uint> = null;
         var _loc5_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         if(!_loc5_)
         {
            return false;
         }
         var _loc7_:GameFightFighterInformations = _loc5_.getEntityInfos(param1) as GameFightFighterInformations;
         switch(param2.zoneShape)
         {
            case SpellShapeEnum.A:
               _loc6_ = true;
               break;
            case SpellShapeEnum.a:
               _loc6_ = _loc7_.alive;
               break;
            default:
               _loc8_ = SpellZoneManager.getInstance().getZone(param2.zoneShape,uint(param2.zoneSize),uint(param2.zoneMinSize),false,uint(param2.zoneStopAtTarget));
               if(_loc8_.radius == ZONE_MAX_SIZE || param2.targetMask && param2.targetMask.indexOf("E263") != -1)
               {
                  _loc6_ = true;
               }
               else
               {
                  _loc8_.direction = MapPoint(MapPoint.fromCellId(param4)).advancedOrientationTo(MapPoint.fromCellId(FightContextFrame.currentCell),false);
                  _loc9_ = _loc8_.getCells(param3);
                  if(_loc7_.disposition.cellId != -1)
                  {
                     _loc6_ = !!_loc9_?_loc9_.indexOf(_loc7_.disposition.cellId) != -1:false;
                  }
               }
         }
         return _loc6_;
      }
      
      public static function getSpellElementDamage(param1:Object, param2:int, param3:Number, param4:Number, param5:int) : SpellDamage
      {
         var _loc7_:EffectDamage = null;
         var _loc8_:EffectInstance = null;
         var _loc9_:EffectInstanceDice = null;
         var _loc10_:int = 0;
         var _loc13_:Boolean = false;
         var _loc16_:int = 0;
         var _loc6_:SpellDamage = new SpellDamage();
         var _loc11_:int = param1.effects.length;
         var _loc12_:Boolean = !(param1 is SpellWrapper) || param1.id == 0;
         _loc10_ = 0;
         while(_loc10_ < _loc11_)
         {
            _loc8_ = param1.effects[_loc10_];
            if(_loc8_.category == DAMAGE_EFFECT_CATEGORY && (_loc12_ || _loc8_.triggers == "I") && HEALING_EFFECTS_IDS.indexOf(_loc8_.effectId) == -1 && TARGET_HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc8_.effectId) == -1 && HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc8_.effectId) == -1 && Effect.getEffectById(_loc8_.effectId).elementId == param2 && (!_loc8_.targetMask || _loc12_ || _loc8_.targetMask && DamageUtil.verifySpellEffectMask(param3,param4,_loc8_,param5)))
            {
               _loc7_ = new EffectDamage(_loc8_.effectId,param2,_loc8_.random,_loc8_.duration);
               _loc7_.spellEffectOrder = _loc10_;
               _loc6_.addEffectDamage(_loc7_);
               if(EROSION_DAMAGE_EFFECTS_IDS.indexOf(_loc8_.effectId) != -1)
               {
                  _loc9_ = _loc8_ as EffectInstanceDice;
                  _loc7_.minErosionPercent = _loc7_.maxErosionPercent = _loc9_.diceNum;
               }
               else if(!(_loc8_ is EffectInstanceDice))
               {
                  if(_loc8_ is EffectInstanceInteger)
                  {
                     _loc7_.minDamage = _loc7_.minDamage + (_loc8_ as EffectInstanceInteger).value;
                     _loc7_.maxDamage = _loc7_.maxDamage + (_loc8_ as EffectInstanceInteger).value;
                  }
                  else if(_loc8_ is EffectInstanceMinMax)
                  {
                     _loc7_.minDamage = _loc7_.minDamage + (_loc8_ as EffectInstanceMinMax).min;
                     _loc7_.maxDamage = _loc7_.maxDamage + (_loc8_ as EffectInstanceMinMax).max;
                  }
               }
               else
               {
                  _loc9_ = _loc8_ as EffectInstanceDice;
                  _loc7_.minDamage = _loc7_.minDamage + _loc9_.diceNum;
                  _loc7_.maxDamage = _loc7_.maxDamage + (_loc9_.diceSide == 0?_loc9_.diceNum:_loc9_.diceSide);
               }
            }
            _loc10_++;
         }
         var _loc14_:int = _loc6_.effectDamages.length;
         var _loc15_:int = !!param1.criticalEffect?int(param1.criticalEffect.length):0;
         _loc10_ = 0;
         while(_loc10_ < _loc15_)
         {
            _loc8_ = param1.criticalEffect[_loc10_];
            if(_loc8_.category == DAMAGE_EFFECT_CATEGORY && (_loc12_ || _loc8_.triggers == "I") && HEALING_EFFECTS_IDS.indexOf(_loc8_.effectId) == -1 && TARGET_HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc8_.effectId) == -1 && HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc8_.effectId) == -1 && Effect.getEffectById(_loc8_.effectId).elementId == param2 && (!_loc8_.targetMask || _loc12_ || _loc8_.targetMask && DamageUtil.verifySpellEffectMask(param3,param4,_loc8_,param5)))
            {
               if(_loc16_ < _loc14_)
               {
                  _loc7_ = _loc6_.effectDamages[_loc16_];
               }
               else
               {
                  _loc7_ = new EffectDamage(_loc8_.effectId,param2,_loc8_.random,_loc8_.duration);
                  _loc7_.spellEffectOrder = _loc10_;
                  _loc6_.addEffectDamage(_loc7_);
               }
               if(EROSION_DAMAGE_EFFECTS_IDS.indexOf(_loc8_.effectId) != -1)
               {
                  _loc9_ = _loc8_ as EffectInstanceDice;
                  _loc7_.minCriticalErosionPercent = _loc7_.maxCriticalErosionPercent = _loc9_.diceNum;
               }
               else if(!(_loc8_ is EffectInstanceDice))
               {
                  if(_loc8_ is EffectInstanceInteger)
                  {
                     _loc7_.minCriticalDamage = _loc7_.minCriticalDamage + (_loc8_ as EffectInstanceInteger).value;
                     _loc7_.maxCriticalDamage = _loc7_.maxCriticalDamage + (_loc8_ as EffectInstanceInteger).value;
                  }
                  else if(_loc8_ is EffectInstanceMinMax)
                  {
                     _loc7_.minCriticalDamage = _loc7_.minCriticalDamage + (_loc8_ as EffectInstanceMinMax).min;
                     _loc7_.maxCriticalDamage = _loc7_.maxCriticalDamage + (_loc8_ as EffectInstanceMinMax).max;
                  }
               }
               else
               {
                  _loc9_ = _loc8_ as EffectInstanceDice;
                  _loc7_.minCriticalDamage = _loc7_.minCriticalDamage + _loc9_.diceNum;
                  _loc7_.maxCriticalDamage = _loc7_.maxCriticalDamage + (_loc9_.diceSide == 0?_loc9_.diceNum:_loc9_.diceSide);
               }
               _loc6_.hasCriticalDamage = _loc7_.hasCritical = true;
               _loc16_++;
            }
            _loc10_++;
         }
         return _loc6_;
      }
      
      public static function getHealEffectDamage(param1:SpellDamageInfo) : EffectDamage
      {
         var _loc4_:EffectDamage = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:EffectDamage = null;
         var _loc2_:int = param1.casterIntelligence <= 0?1:int(param1.casterIntelligence + (!!param1.isWeapon?param1.casterWeaponDamagesBonus:0));
         var _loc3_:EffectDamage = new EffectDamage();
         for each(_loc7_ in param1.heal.effectDamages)
         {
            _loc4_ = new EffectDamage(_loc7_.effectId,-1,-1,_loc7_.duration);
            _loc4_.spellEffectOrder = _loc7_.spellEffectOrder;
            _loc4_.minLifePointsAdded = getHeal(_loc7_.minLifePointsAdded,_loc2_,param1.casterHealBonus);
            _loc4_.maxLifePointsAdded = getHeal(_loc7_.maxLifePointsAdded,_loc2_,param1.casterHealBonus);
            if(param1.isWeapon)
            {
               _loc5_ = _loc7_.minLifePointsAdded > 0?int(_loc7_.minLifePointsAdded + param1.spellWeaponCriticalBonus):0;
               _loc6_ = _loc7_.maxLifePointsAdded > 0?int(_loc7_.maxLifePointsAdded + param1.spellWeaponCriticalBonus):0;
               if(_loc5_ > 0 || _loc6_ > 0)
               {
                  param1.spellHasCriticalHeal = true;
               }
            }
            else
            {
               _loc5_ = param1.heal.minCriticalLifePointsAdded;
               _loc6_ = param1.heal.maxCriticalLifePointsAdded;
            }
            _loc4_.minCriticalLifePointsAdded = getHeal(_loc5_,_loc2_,param1.casterHealBonus);
            _loc4_.maxCriticalLifePointsAdded = getHeal(_loc6_,_loc2_,param1.casterHealBonus);
            _loc3_.minLifePointsAdded = _loc3_.minLifePointsAdded + _loc4_.minLifePointsAdded;
            _loc3_.maxLifePointsAdded = _loc3_.maxLifePointsAdded + _loc4_.maxLifePointsAdded;
            _loc3_.minCriticalLifePointsAdded = _loc3_.minCriticalLifePointsAdded + _loc4_.minCriticalLifePointsAdded;
            _loc3_.maxCriticalLifePointsAdded = _loc3_.maxCriticalLifePointsAdded + _loc4_.maxCriticalLifePointsAdded;
            _loc4_.lifePointsAddedBasedOnLifePercent = _loc7_.lifePointsAddedBasedOnLifePercent;
            _loc4_.criticalLifePointsAddedBasedOnLifePercent = _loc7_.criticalLifePointsAddedBasedOnLifePercent;
            _loc3_.lifePointsAddedBasedOnLifePercent = _loc3_.lifePointsAddedBasedOnLifePercent + _loc4_.lifePointsAddedBasedOnLifePercent;
            _loc3_.criticalLifePointsAddedBasedOnLifePercent = _loc3_.criticalLifePointsAddedBasedOnLifePercent + _loc4_.criticalLifePointsAddedBasedOnLifePercent;
            _loc3_.computedEffects.push(_loc4_);
         }
         return _loc3_;
      }
      
      public static function applySpellModificationsOnEffect(param1:EffectDamage, param2:SpellWrapper) : void
      {
         if(!param2)
         {
            return;
         }
         var _loc3_:CharacterSpellModification = CurrentPlayedFighterManager.getInstance().getSpellModifications(param2.id,CharacterSpellModificationTypeEnum.BASE_DAMAGE);
         if(_loc3_)
         {
            param1.minDamage = param1.minDamage + (param1.minDamage > 0?_loc3_.value.contextModif:0);
            param1.maxDamage = param1.maxDamage + (param1.maxDamage > 0?_loc3_.value.contextModif:0);
            if(param1.hasCritical)
            {
               param1.minCriticalDamage = param1.minCriticalDamage + (param1.minCriticalDamage > 0?_loc3_.value.contextModif:0);
               param1.maxCriticalDamage = param1.maxCriticalDamage + (param1.maxCriticalDamage > 0?_loc3_.value.contextModif:0);
            }
         }
      }
      
      public static function getReflectDamageValues(param1:Number) : ReflectValues
      {
         var _loc2_:ReflectValues = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc7_:BasicBuff = null;
         var _loc8_:GameFightFighterInformations = null;
         var _loc9_:Monster = null;
         var _loc10_:MonsterGrade = null;
         var _loc3_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         if(!_loc3_)
         {
            return null;
         }
         var _loc6_:Array = BuffManager.getInstance().getAllBuff(param1);
         for each(_loc7_ in _loc6_)
         {
            if(REFLECT_EFFETS_IDS.indexOf(_loc7_.actionId) != -1)
            {
               if(_loc7_.actionId == 220)
               {
                  _loc4_ = _loc4_ + (_loc7_.effect as EffectInstanceInteger).value;
               }
               else if(_loc7_.actionId == 107)
               {
                  _loc5_ = _loc5_ + (_loc7_.effect as EffectInstanceInteger).value;
               }
            }
         }
         _loc8_ = _loc3_.entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations;
         if(_loc8_ is GameFightMonsterInformations)
         {
            _loc9_ = Monster.getMonsterById((_loc8_ as GameFightMonsterInformations).creatureGenericId);
            for each(_loc10_ in _loc9_.grades)
            {
               if(_loc10_.grade == (_loc8_ as GameFightMonsterInformations).creatureGrade)
               {
                  _loc4_ = _loc4_ + _loc10_.damageReflect;
                  break;
               }
            }
         }
         else if(_loc8_ is GameFightCharacterInformations)
         {
            _loc4_ = _loc4_ + _loc8_.stats.fixedDamageReflection;
         }
         if(_loc4_ > 0 || _loc5_ > 0)
         {
            _loc2_ = new ReflectValues(_loc4_,_loc5_);
         }
         return _loc2_;
      }
      
      public static function getSpellDamage(param1:SpellDamageInfo, param2:Boolean = true, param3:Boolean = true, param4:Boolean = true) : SpellDamage
      {
         var ed:EffectDamage = null;
         var efficiencyMultiplier:Number = NaN;
         var splashEffectDamages:Vector.<EffectDamage> = null;
         var spellShape:uint = 0;
         var spellShapeSize:Object = null;
         var spellShapeMinSize:Object = null;
         var spellShapeEfficiencyPercent:Object = null;
         var spellShapeMaxEfficiency:Object = null;
         var shapeSize:int = 0;
         var finalNeutralDmg:EffectDamage = null;
         var finalEarthDmg:EffectDamage = null;
         var finalWaterDmg:EffectDamage = null;
         var finalAirDmg:EffectDamage = null;
         var finalFireDmg:EffectDamage = null;
         var finalHpBasedDmg:EffectDamage = null;
         var finalInterceptedDmg:EffectDamage = null;
         var erosion:EffectDamage = null;
         var targetHpBasedBuffDamages:Vector.<SpellDamage> = null;
         var hasInterceptedDamage:Boolean = false;
         var dmgMultiplier:Number = NaN;
         var finalTargetHpBasedDamages:Vector.<EffectDamage> = null;
         var splashHealDmg:EffectDamage = null;
         var forceIsHealingSpell:Boolean = false;
         var forceIsHealingSpellValue:Boolean = false;
         var permanentMinDamage:int = 0;
         var permanentMaxDamage:int = 0;
         var permanentMinCriticalDamage:int = 0;
         var permanentMaxCriticalDamage:int = 0;
         var computedEffect:EffectDamage = null;
         var intercepted:InterceptedDamage = null;
         var effi:EffectInstance = null;
         var pushDamages:EffectDamage = null;
         var pushedEntity:PushedEntity = null;
         var pushIndex:uint = 0;
         var hasPushedDamage:Boolean = false;
         var pushDmg:int = 0;
         var criticalPushDmg:int = 0;
         var pushOriginCell:MapPoint = null;
         var targetCell:MapPoint = null;
         var direction:int = 0;
         var finalForce:int = 0;
         var buff:BasicBuff = null;
         var buffDamage:EffectDamage = null;
         var buffEffectDamage:EffectDamage = null;
         var buffSpellDamage:SpellDamage = null;
         var effid:EffectInstanceDice = null;
         var buffEffectMinDamage:int = 0;
         var buffEffectMaxDamage:int = 0;
         var buffEffectDispelled:Boolean = false;
         var buffDamageMultiplier:Number = NaN;
         var buffHealMultiplier:Number = NaN;
         var splashEffectDmg:EffectDamage = null;
         var interceptedDmg:InterceptedDamage = null;
         var isTargetHpBasedDamage:Boolean = false;
         var buffSpellEffectDmg:EffectDamage = null;
         var reflectDmg:ReflectDamage = null;
         var reflectDmgEffect:EffectDamage = null;
         var tmpEffect:EffectDamage = null;
         var sourceDmgWithoutPercentResists:SpellDamage = null;
         var finalElementDmgWithoutPercentResists:EffectDamage = null;
         var currentTargetId:Number = NaN;
         var minimizeEffects:Boolean = false;
         var maximizeEffects:Boolean = false;
         var reflectSpellDmg:SpellDamage = null;
         var reflectOrder:int = 0;
         var reflectValue:int = 0;
         var lifeStealHasRandom:Boolean = false;
         var targetId:Number = NaN;
         var spellDamages:Object = null;
         var spellDamage:Object = null;
         var lifeStealEffect:EffectDamage = null;
         var targetLifePoints:int = 0;
         var fightContextFrame:FightContextFrame = null;
         var hasDamageDistance:Boolean = false;
         var invulnerableToRange:Boolean = false;
         var invulnerableToMelee:Boolean = false;
         var minShieldDiff:int = 0;
         var maxShieldDiff:int = 0;
         var minCriticalShieldDiff:int = 0;
         var maxCriticalShieldDiff:int = 0;
         var interceptedEffect:EffectDamage = null;
         var pSpellDamageInfo:SpellDamageInfo = param1;
         var pWithTargetBuffs:Boolean = param2;
         var pWithTargetResists:Boolean = param3;
         var pWithTargetPercentResists:Boolean = param4;
         if(pSpellDamageInfo.sharedDamage)
         {
            pSpellDamageInfo.sharedDamage.invulnerableState = pSpellDamageInfo.targetIsInvulnerable;
            pSpellDamageInfo.sharedDamage.hasCriticalDamage = pSpellDamageInfo.spellHasCriticalDamage;
            return pSpellDamageInfo.sharedDamage;
         }
         var finalDamage:SpellDamage = new SpellDamage();
         var currentCasterLifePoints:int = ((Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).getEntityInfos(pSpellDamageInfo.casterId) as GameFightFighterInformations).stats.lifePoints;
         splashEffectDamages = new Vector.<EffectDamage>();
         var splashHealEffectDamages:Vector.<EffectDamage> = new Vector.<EffectDamage>();
         pSpellDamageInfo.targetSpellMinErosionLifePoints = 0;
         pSpellDamageInfo.targetSpellMaxErosionLifePoints = 0;
         pSpellDamageInfo.targetSpellMinCriticalErosionLifePoints = 0;
         pSpellDamageInfo.targetSpellMaxCriticalErosionLifePoints = 0;
         addSplashDamages(finalDamage,pSpellDamageInfo.splashDamages,pSpellDamageInfo,currentCasterLifePoints,false,splashEffectDamages,splashHealEffectDamages);
         addSplashDamages(finalDamage,pSpellDamageInfo.criticalSplashDamages,pSpellDamageInfo,currentCasterLifePoints,true,splashEffectDamages,splashHealEffectDamages);
         if(pSpellDamageInfo.isWeapon)
         {
            spellShapeEfficiencyPercent = pSpellDamageInfo.weaponShapeEfficiencyPercent;
         }
         else
         {
            for each(effi in pSpellDamageInfo.spellEffects)
            {
               if((effi.category == DamageUtil.DAMAGE_EFFECT_CATEGORY || DamageUtil.HEALING_EFFECTS_IDS.indexOf(effi.effectId) != -1) && DamageUtil.verifySpellEffectMask(pSpellDamageInfo.casterId,pSpellDamageInfo.targetId,effi,pSpellDamageInfo.spellCenterCell))
               {
                  if(effi.rawZone)
                  {
                     spellShape = effi.rawZone.charCodeAt(0);
                     spellShapeSize = effi.zoneSize;
                     spellShapeMinSize = effi.zoneMinSize;
                     spellShapeEfficiencyPercent = effi.zoneEfficiencyPercent;
                     spellShapeMaxEfficiency = effi.zoneMaxEfficiency;
                     break;
                  }
               }
            }
         }
         shapeSize = spellShapeSize != null?int(int(spellShapeSize)):int(EFFECTSHAPE_DEFAULT_AREA_SIZE);
         var shapeMinSize:int = spellShapeMinSize != null?int(int(spellShapeMinSize)):int(EFFECTSHAPE_DEFAULT_MIN_AREA_SIZE);
         var shapeEfficiencyPercent:int = spellShapeEfficiencyPercent != null?int(int(spellShapeEfficiencyPercent)):int(EFFECTSHAPE_DEFAULT_EFFICIENCY);
         var shapeMaxEfficiency:int = spellShapeMaxEfficiency != null?int(int(spellShapeMaxEfficiency)):int(EFFECTSHAPE_DEFAULT_MAX_EFFICIENCY_APPLY);
         if(shapeEfficiencyPercent == 0 || shapeMaxEfficiency == 0)
         {
            efficiencyMultiplier = DAMAGE_NOT_BOOSTED;
         }
         else
         {
            efficiencyMultiplier = getShapeEfficiency(spellShape,pSpellDamageInfo.spellCenterCell,pSpellDamageInfo.targetCell,shapeSize,shapeMinSize,shapeEfficiencyPercent,shapeMaxEfficiency);
         }
         if(!pSpellDamageInfo.triggeredSpell)
         {
            efficiencyMultiplier = efficiencyMultiplier * pSpellDamageInfo.portalsSpellEfficiencyBonus;
         }
         finalDamage.efficiencyMultiplier = efficiencyMultiplier;
         finalNeutralDmg = computeDamage(pSpellDamageInfo.neutralDamage,pSpellDamageInfo,efficiencyMultiplier,false,!pWithTargetResists,!pWithTargetResists,!pWithTargetPercentResists);
         finalEarthDmg = computeDamage(pSpellDamageInfo.earthDamage,pSpellDamageInfo,efficiencyMultiplier,false,!pWithTargetResists,!pWithTargetResists,!pWithTargetPercentResists);
         finalWaterDmg = computeDamage(pSpellDamageInfo.waterDamage,pSpellDamageInfo,efficiencyMultiplier,false,!pWithTargetResists,!pWithTargetResists,!pWithTargetPercentResists);
         finalAirDmg = computeDamage(pSpellDamageInfo.airDamage,pSpellDamageInfo,efficiencyMultiplier,false,!pWithTargetResists,!pWithTargetResists,!pWithTargetPercentResists);
         finalFireDmg = computeDamage(pSpellDamageInfo.fireDamage,pSpellDamageInfo,efficiencyMultiplier,false,!pWithTargetResists,!pWithTargetResists,!pWithTargetPercentResists);
         finalHpBasedDmg = computeDamage(pSpellDamageInfo.hpBasedDamage,pSpellDamageInfo,1,true,true,!pWithTargetPercentResists);
         if(pSpellDamageInfo.interceptedDamage && pSpellDamageInfo.interceptedDamage.targetId == pSpellDamageInfo.targetId)
         {
            finalInterceptedDmg = computeDamage(pSpellDamageInfo.interceptedDamage,pSpellDamageInfo,1,true,true,true,true,true,true);
         }
         pSpellDamageInfo.casterLifePointsAfterNormalMinDamage = 0;
         pSpellDamageInfo.casterLifePointsAfterNormalMaxDamage = 0;
         pSpellDamageInfo.casterLifePointsAfterCriticalMinDamage = 0;
         pSpellDamageInfo.casterLifePointsAfterCriticalMaxDamage = 0;
         var totalMinErosionDamage:int = finalNeutralDmg.minErosionDamage + finalEarthDmg.minErosionDamage + finalWaterDmg.minErosionDamage + finalAirDmg.minErosionDamage + finalFireDmg.minErosionDamage;
         var totalMaxErosionDamage:int = finalNeutralDmg.maxErosionDamage + finalEarthDmg.maxErosionDamage + finalWaterDmg.maxErosionDamage + finalAirDmg.maxErosionDamage + finalFireDmg.maxErosionDamage;
         var totalMinCriticaErosionDamage:int = finalNeutralDmg.minCriticalErosionDamage + finalEarthDmg.minCriticalErosionDamage + finalWaterDmg.minCriticalErosionDamage + finalAirDmg.minCriticalErosionDamage + finalFireDmg.minCriticalErosionDamage;
         var totalMaxCriticaErosionlDamage:int = finalNeutralDmg.maxCriticalErosionDamage + finalEarthDmg.maxCriticalErosionDamage + finalWaterDmg.maxCriticalErosionDamage + finalAirDmg.maxCriticalErosionDamage + finalFireDmg.maxCriticalErosionDamage;
         var finalHeal:EffectDamage = new EffectDamage();
         if(pSpellDamageInfo.originalTargetsIds.indexOf(pSpellDamageInfo.targetId) != -1)
         {
            finalHeal = getHealEffectDamage(pSpellDamageInfo);
         }
         finalDamage.hasHeal = finalHeal.minLifePointsAdded > 0 || finalHeal.maxLifePointsAdded > 0 || finalHeal.minCriticalLifePointsAdded > 0 || finalHeal.maxCriticalLifePointsAdded > 0 || finalHeal.lifePointsAddedBasedOnLifePercent > 0 || finalHeal.criticalLifePointsAddedBasedOnLifePercent > 0 || splashHealEffectDamages.length > 0;
         erosion = new EffectDamage();
         erosion.minDamage = totalMinErosionDamage;
         erosion.maxDamage = totalMaxErosionDamage;
         erosion.minCriticalDamage = totalMinCriticaErosionDamage;
         erosion.maxCriticalDamage = totalMaxCriticaErosionlDamage;
         if(pSpellDamageInfo.pushedEntities && pSpellDamageInfo.pushedEntities.length > 0)
         {
            pushDamages = new EffectDamage(5);
            for each(pushedEntity in pSpellDamageInfo.pushedEntities)
            {
               if(pushedEntity.id == pSpellDamageInfo.targetId)
               {
                  pushedEntity.damage = pushedEntity.criticalDamage = 0;
                  for each(pushIndex in pushedEntity.pushedIndexes)
                  {
                     pushOriginCell = !hasMinSize(pushedEntity.pushEffect.zoneShape)?EntitiesManager.getInstance().getEntity(pSpellDamageInfo.casterId).position:MapPoint.fromCellId(pSpellDamageInfo.spellCenterCell);
                     targetCell = EntitiesManager.getInstance().getEntity(pushedEntity.id).position;
                     direction = pushOriginCell.advancedOrientationTo(targetCell,false);
                     finalForce = (direction & 1) == 0?int(pushedEntity.force * 2):int(pushedEntity.force);
                     pushDmg = (pSpellDamageInfo.casterLevel / 2 + (pSpellDamageInfo.casterPushDamageBonus - pSpellDamageInfo.targetPushDamageFixedResist) + 32) * finalForce / (4 * Math.pow(2,pushIndex));
                     pushedEntity.damage = pushedEntity.damage + (pushDmg > 0?pushDmg:0);
                     criticalPushDmg = (pSpellDamageInfo.casterLevel / 2 + (pSpellDamageInfo.casterCriticalPushDamageBonus - pSpellDamageInfo.targetPushDamageFixedResist) + 32) * finalForce / (4 * Math.pow(2,pushIndex));
                     pushedEntity.criticalDamage = pushedEntity.criticalDamage + (criticalPushDmg > 0?criticalPushDmg:0);
                  }
                  hasPushedDamage = true;
                  break;
               }
            }
            if(hasPushedDamage)
            {
               pushDamages.damageDistance = pushedEntity.pushedDistance;
               pushDamages.minDamage = pushDamages.maxDamage = pushedEntity.damage;
               if(pSpellDamageInfo.spellHasCriticalDamage)
               {
                  pushDamages.minCriticalDamage = pushDamages.maxCriticalDamage = pushedEntity.criticalDamage;
               }
            }
            finalDamage.addEffectDamage(pushDamages);
         }
         var applyDamageMultiplier:Function = function(param1:Number, param2:Boolean = false):void
         {
            var _loc3_:EffectDamage = null;
            erosion.applyDamageMultiplier(param1);
            finalNeutralDmg.applyDamageMultiplier(param1);
            finalEarthDmg.applyDamageMultiplier(param1);
            finalWaterDmg.applyDamageMultiplier(param1);
            finalAirDmg.applyDamageMultiplier(param1);
            finalFireDmg.applyDamageMultiplier(param1);
            finalHpBasedDmg.applyDamageMultiplier(param1);
            if(!param2 && splashEffectDamages)
            {
               for each(_loc3_ in splashEffectDamages)
               {
                  _loc3_.applyDamageMultiplier(param1);
               }
            }
         };
         if(pWithTargetBuffs)
         {
            buffDamageMultiplier = 1;
            buffHealMultiplier = 1;
            pSpellDamageInfo.interceptedDamages.length = 0;
            for each(buff in pSpellDamageInfo.targetBuffs)
            {
               buffEffectDispelled = buff.canBeDispell() && buff.effect.duration - pSpellDamageInfo.spellTargetEffectsDurationReduction <= 0;
               if((!buff.hasOwnProperty("delay") || buff["delay"] == 0) && (!(buff is StatBuff) || !(buff as StatBuff).statName) && verifyBuffTriggers(buff,pSpellDamageInfo.spellEffects,pSpellDamageInfo.casterId,pSpellDamageInfo.targetId,pSpellDamageInfo.isWeapon,pSpellDamageInfo.spellCenterCell,pSpellDamageInfo.splashDamages) && !buffEffectDispelled)
               {
                  switch(buff.actionId)
                  {
                     case ActionIdConverter.ACTION_CHARACTER_MULTIPLY_RECEIVED_HEAL:
                        buffHealMultiplier = buffHealMultiplier * (buff.param1 / 100);
                        break;
                     case ActionIdConverter.ACTION_CHARACTER_MULTIPLY_RECEIVED_DAMAGE:
                        buffDamageMultiplier = buffDamageMultiplier * (buff.param1 / 100);
                        break;
                     case ActionIdConverter.ACTION_CHARACTER_GIVE_LIFE_WITH_RATIO:
                        erosion.convertDamageToHeal();
                        finalNeutralDmg.convertDamageToHeal();
                        finalEarthDmg.convertDamageToHeal();
                        finalWaterDmg.convertDamageToHeal();
                        finalAirDmg.convertDamageToHeal();
                        finalFireDmg.convertDamageToHeal();
                        if(splashEffectDamages)
                        {
                           for each(splashEffectDmg in splashEffectDamages)
                           {
                              splashEffectDmg.convertDamageToHeal();
                           }
                        }
                        pSpellDamageInfo.spellHasCriticalHeal = pSpellDamageInfo.spellHasCriticalDamage;
                        finalDamage.hasHeal = true;
                        break;
                     case ActionIdConverter.ACTION_CHARACTER_SACRIFY:
                        hasInterceptedDamage = false;
                        for each(interceptedDmg in pSpellDamageInfo.interceptedDamages)
                        {
                           if(interceptedDmg.buffId == buff.id)
                           {
                              hasInterceptedDamage = true;
                           }
                        }
                        if(!hasInterceptedDamage)
                        {
                           pSpellDamageInfo.interceptedDamages.push(new InterceptedDamage(buff.id,buff.source,pSpellDamageInfo.targetId));
                        }
                  }
                  if(buff.effect.category == DAMAGE_EFFECT_CATEGORY && HEALING_EFFECTS_IDS.indexOf(buff.effect.effectId) == -1)
                  {
                     buffSpellDamage = new SpellDamage();
                     buffEffectDamage = new EffectDamage(buff.effect.effectId,Effect.getEffectById(buff.effect.effectId).elementId,-1,buff.effect.duration);
                     if(buff.effect is EffectInstanceDice)
                     {
                        effid = buff.effect as EffectInstanceDice;
                        buffEffectMinDamage = effid.value + effid.diceNum;
                        buffEffectMaxDamage = effid.value + effid.diceSide;
                     }
                     else if(buff.effect is EffectInstanceMinMax)
                     {
                        buffEffectMinDamage = (buff.effect as EffectInstanceMinMax).min;
                        buffEffectMaxDamage = (buff.effect as EffectInstanceMinMax).max;
                     }
                     else if(buff.effect is EffectInstanceInteger)
                     {
                        buffEffectMinDamage = buffEffectMaxDamage = (buff.effect as EffectInstanceInteger).value;
                     }
                     buffEffectDamage.minDamage = buff.effect.duration == -1000 || buff.effect.duration - pSpellDamageInfo.spellTargetEffectsDurationReduction > 0?int(buffEffectMinDamage):0;
                     buffEffectDamage.maxDamage = buff.effect.duration == -1000 || buff.effect.duration - pSpellDamageInfo.spellTargetEffectsDurationReduction > 0?int(buffEffectMaxDamage):0;
                     buffEffectDamage.minCriticalDamage = buff.effect.duration == -1000 || buff.effect.duration - pSpellDamageInfo.spellTargetEffectsDurationCriticalReduction > 0?int(buffEffectMinDamage):0;
                     buffEffectDamage.maxCriticalDamage = buff.effect.duration == -1000 || buff.effect.duration - pSpellDamageInfo.spellTargetEffectsDurationCriticalReduction > 0?int(buffEffectMaxDamage):0;
                     buffSpellDamage.addEffectDamage(buffEffectDamage);
                     isTargetHpBasedDamage = TARGET_HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(buff.actionId) != -1;
                     if(HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(buff.actionId) != -1)
                     {
                        for each(buffSpellEffectDmg in buffSpellDamage.effectDamages)
                        {
                           switch(buffSpellEffectDmg.effectId)
                           {
                              case 85:
                                 buffSpellEffectDmg.effectId = 1068;
                                 continue;
                              case 86:
                                 buffSpellEffectDmg.effectId = 1070;
                                 continue;
                              case 87:
                                 buffSpellEffectDmg.effectId = 1067;
                                 continue;
                              case 88:
                                 buffSpellEffectDmg.effectId = 1069;
                                 continue;
                              case 89:
                                 buffSpellEffectDmg.effectId = 1071;
                                 continue;
                              default:
                                 continue;
                           }
                        }
                        isTargetHpBasedDamage = true;
                     }
                     if(!isTargetHpBasedDamage)
                     {
                        buffDamage = computeDamage(buffSpellDamage,pSpellDamageInfo,1);
                        finalDamage.addEffectDamage(buffDamage);
                     }
                     else
                     {
                        if(!targetHpBasedBuffDamages)
                        {
                           targetHpBasedBuffDamages = new Vector.<SpellDamage>(0);
                        }
                        targetHpBasedBuffDamages.push(buffSpellDamage);
                     }
                  }
               }
            }
            if(buffDamageMultiplier != 1)
            {
               applyDamageMultiplier(int(buffDamageMultiplier * 100) / 100);
            }
            if(buffHealMultiplier != 1)
            {
               finalHeal.applyHealMultiplier(int(buffHealMultiplier * 100) / 100);
            }
         }
         var damageBoostPercentTotal:int = pSpellDamageInfo.casterDamageBoostPercent - pSpellDamageInfo.casterDamageDeboostPercent;
         if(damageBoostPercentTotal != 0)
         {
            dmgMultiplier = 100 + damageBoostPercentTotal;
            applyDamageMultiplier(dmgMultiplier < 0?0:dmgMultiplier / 100,true);
         }
         var finalReflectDmg:Vector.<EffectDamage> = new Vector.<EffectDamage>(0);
         if(pSpellDamageInfo.reflectDamages && pSpellDamageInfo.reflectDamages.length > 0)
         {
            currentTargetId = pSpellDamageInfo.targetId;
            minimizeEffects = true;
            maximizeEffects = true;
            for each(reflectDmg in pSpellDamageInfo.reflectDamages)
            {
               sourceDmgWithoutPercentResists = DamageUtil.getSpellDamage(SpellDamageInfo.fromCurrentPlayer(pSpellDamageInfo.spell,reflectDmg.sourceId,pSpellDamageInfo.spellCenterCell),true,true,false);
               if(!sourceDmgWithoutPercentResists.minimizedEffects)
               {
                  minimizeEffects = false;
               }
               if(!sourceDmgWithoutPercentResists.maximizedEffects)
               {
                  maximizeEffects = false;
               }
               for each(reflectDmgEffect in reflectDmg.effects)
               {
                  finalElementDmgWithoutPercentResists = null;
                  for each(ed in sourceDmgWithoutPercentResists.effectDamages)
                  {
                     if(ed.element == reflectDmgEffect.element)
                     {
                        finalElementDmgWithoutPercentResists = ed;
                        break;
                     }
                  }
                  if(!(!finalElementDmgWithoutPercentResists || !finalElementDmgWithoutPercentResists.hasDamage))
                  {
                     reflectValue = !!reflectDmg.boosted?int(reflectDmg.reflectValue * (pSpellDamageInfo.casterLevel / 20 + 1)):int(reflectDmg.reflectValue);
                     tmpEffect = new EffectDamage(-1,finalElementDmgWithoutPercentResists.element,finalElementDmgWithoutPercentResists.random);
                     tmpEffect.minDamage = reflectDmgEffect.minDamage > 0?int(Math.min(finalElementDmgWithoutPercentResists.minDamage,reflectValue)):0;
                     tmpEffect.maxDamage = reflectDmgEffect.maxDamage > 0?int(Math.min(finalElementDmgWithoutPercentResists.maxDamage,reflectValue)):0;
                     tmpEffect.minCriticalDamage = reflectDmgEffect.minCriticalDamage > 0 || pSpellDamageInfo.isWeapon?int(Math.min(finalElementDmgWithoutPercentResists.minCriticalDamage,reflectValue)):0;
                     tmpEffect.maxCriticalDamage = reflectDmgEffect.maxCriticalDamage > 0 || pSpellDamageInfo.isWeapon?int(Math.min(finalElementDmgWithoutPercentResists.maxCriticalDamage,reflectValue)):0;
                     tmpEffect.hasCritical = tmpEffect.minCriticalDamage > 0 || tmpEffect.maxCriticalDamage > 0;
                     reflectDmgEffect = computeDamageWithoutResistsBoosts(reflectDmg.sourceId,tmpEffect,pSpellDamageInfo,1,true,true);
                     reflectDmgEffect.spellEffectOrder = --reflectOrder;
                     reflectSpellDmg = new SpellDamage();
                     reflectSpellDmg.addEffectDamage(reflectDmgEffect);
                     reflectSpellDmg.hasCriticalDamage = reflectDmgEffect.hasCritical;
                     pSpellDamageInfo.targetId = currentTargetId;
                     ed = computeDamage(reflectSpellDmg,pSpellDamageInfo,1,true);
                     finalReflectDmg.push(ed);
                  }
               }
            }
            pSpellDamageInfo.minimizedEffects = minimizeEffects;
            pSpellDamageInfo.maximizedEffects = maximizeEffects;
            pSpellDamageInfo.targetId = currentTargetId;
         }
         if(pSpellDamageInfo.originalTargetsIds.indexOf(pSpellDamageInfo.targetId) == -1)
         {
            if(finalInterceptedDmg)
            {
               if(finalInterceptedDmg.random > 0)
               {
                  for each(ed in finalInterceptedDmg.computedEffects)
                  {
                     finalDamage.addEffectDamage(ed);
                  }
               }
               else
               {
                  finalDamage.addEffectDamage(finalInterceptedDmg);
               }
            }
         }
         for each(splashHealDmg in splashHealEffectDamages)
         {
            finalHeal.minLifePointsAdded = finalHeal.minLifePointsAdded + splashHealDmg.minLifePointsAdded;
            finalHeal.maxLifePointsAdded = finalHeal.maxLifePointsAdded + splashHealDmg.maxLifePointsAdded;
            finalHeal.minCriticalLifePointsAdded = finalHeal.minCriticalLifePointsAdded + splashHealDmg.minCriticalLifePointsAdded;
            finalHeal.maxCriticalLifePointsAdded = finalHeal.maxCriticalLifePointsAdded + splashHealDmg.maxCriticalLifePointsAdded;
            finalHeal.computedEffects.push(splashHealDmg);
            finalDamage.hasHeal = true;
         }
         if(pSpellDamageInfo.targetId == pSpellDamageInfo.casterId)
         {
            for each(ed in finalReflectDmg)
            {
               finalDamage.addEffectDamage(ed);
               if(ed.hasCritical)
               {
                  pSpellDamageInfo.spellHasCriticalDamage = true;
               }
            }
            if(pSpellDamageInfo.spellHasLifeSteal && !pSpellDamageInfo.interceptedDamage)
            {
               fightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               for each(targetId in pSpellDamageInfo.originalTargetsIds)
               {
                  if(targetId != pSpellDamageInfo.casterId)
                  {
                     spellDamages = SpellDamagesManager.getInstance().getSpellDamages(targetId);
                     if(fightContextFrame)
                     {
                        targetLifePoints = (fightContextFrame.entitiesFrame.getEntityInfos(targetId) as GameFightFighterInformations).stats.lifePoints;
                     }
                     for each(spellDamage in spellDamages)
                     {
                        for each(ed in spellDamage.spellDamage.effectDamages)
                        {
                           for each(ed in ed.computedEffects)
                           {
                              if(LIFE_STEAL_EFFECTS_IDS.indexOf(ed.effectId) != -1)
                              {
                                 lifeStealEffect = new EffectDamage(ed.effectId,ed.element,ed.random,ed.duration);
                                 lifeStealEffect.minLifePointsAdded = targetLifePoints > 0?int(Math.min(targetLifePoints,ed.minDamage) / 2):int(ed.minDamage / 2);
                                 lifeStealEffect.maxLifePointsAdded = targetLifePoints > 0?int(Math.min(targetLifePoints,ed.maxDamage) / 2):int(ed.maxDamage / 2);
                                 lifeStealEffect.minCriticalLifePointsAdded = targetLifePoints > 0?int(Math.min(targetLifePoints,ed.minCriticalDamage) / 2):int(ed.minCriticalDamage / 2);
                                 lifeStealEffect.maxCriticalLifePointsAdded = targetLifePoints > 0?int(Math.min(targetLifePoints,ed.maxCriticalDamage) / 2):int(ed.maxCriticalDamage / 2);
                                 lifeStealEffect.spellEffectOrder = ed.spellEffectOrder;
                                 lifeStealEffect.lifeSteal = true;
                                 finalHeal.computedEffects.push(lifeStealEffect);
                                 finalDamage.hasHeal = true;
                                 if(lifeStealEffect.minCriticalLifePointsAdded > 0 || lifeStealEffect.maxCriticalLifePointsAdded > 0)
                                 {
                                    pSpellDamageInfo.spellHasCriticalHeal = lifeStealEffect.hasCritical = true;
                                 }
                                 if(lifeStealEffect.random > 0)
                                 {
                                    lifeStealHasRandom = true;
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
            if(pSpellDamageInfo.originalTargetsIds.indexOf(pSpellDamageInfo.targetId) == -1 || pSpellDamageInfo.isWeapon)
            {
               if(targetHpBasedBuffDamages)
               {
                  finalTargetHpBasedDamages = computeTargetHpBasedBuffDamage(pSpellDamageInfo,getAllEffectDamages(finalDamage),targetHpBasedBuffDamages,pWithTargetResists,pWithTargetPercentResists);
                  for each(ed in finalTargetHpBasedDamages)
                  {
                     finalDamage.addEffectDamage(ed);
                  }
               }
               computeHeal(finalHeal,getAllEffectDamages(finalDamage),pSpellDamageInfo,1);
               if(lifeStealHasRandom)
               {
                  for each(ed in finalHeal.computedEffects)
                  {
                     finalDamage.addEffectDamage(ed);
                  }
               }
               else
               {
                  finalDamage.addEffectDamage(finalHeal);
               }
               forceIsHealingSpell = true;
            }
         }
         else if(splashHealEffectDamages && splashHealEffectDamages.length > 0 && pSpellDamageInfo.originalTargetsIds.indexOf(pSpellDamageInfo.targetId) == -1)
         {
            computeHeal(finalHeal,getAllEffectDamages(finalDamage),pSpellDamageInfo,efficiencyMultiplier);
            finalDamage.addEffectDamage(finalHeal);
            forceIsHealingSpell = true;
         }
         if(pSpellDamageInfo.originalTargetsIds.indexOf(pSpellDamageInfo.targetId) != -1 && (!pSpellDamageInfo.isWeapon || pSpellDamageInfo.casterId != pSpellDamageInfo.targetId))
         {
            finalDamage.addEffectDamage(erosion);
            finalDamage.addEffectDamage(finalNeutralDmg,0);
            finalDamage.addEffectDamage(finalEarthDmg,0);
            finalDamage.addEffectDamage(finalWaterDmg,0);
            finalDamage.addEffectDamage(finalAirDmg,0);
            finalDamage.addEffectDamage(finalFireDmg,0);
            finalDamage.addEffectDamage(finalHpBasedDmg,0);
            if(finalInterceptedDmg)
            {
               if(finalInterceptedDmg.random > 0)
               {
                  for each(ed in finalInterceptedDmg.computedEffects)
                  {
                     finalDamage.addEffectDamage(ed);
                  }
               }
               else
               {
                  finalDamage.addEffectDamage(finalInterceptedDmg);
               }
            }
            if(targetHpBasedBuffDamages)
            {
               finalTargetHpBasedDamages = computeTargetHpBasedBuffDamage(pSpellDamageInfo,getAllEffectDamages(finalDamage),targetHpBasedBuffDamages,pWithTargetResists,pWithTargetPercentResists);
               for each(ed in finalTargetHpBasedDamages)
               {
                  finalDamage.addEffectDamage(ed);
               }
            }
            computeHeal(finalHeal,getAllEffectDamages(finalDamage),pSpellDamageInfo,efficiencyMultiplier);
            finalDamage.addEffectDamage(finalHeal);
         }
         finalDamage.hasCriticalDamage = pSpellDamageInfo.spellHasCriticalDamage;
         finalDamage.isCriticalHit = pSpellDamageInfo.criticalHitRate == 100;
         finalDamage.minimizedEffects = pSpellDamageInfo.minimizedEffects;
         finalDamage.maximizedEffects = pSpellDamageInfo.maximizedEffects;
         var invulnerable:Boolean = pSpellDamageInfo.targetIsInvulnerable;
         if(!invulnerable)
         {
            invulnerableToRange = pSpellDamageInfo.targetIsInvulnerableToRange;
            if(invulnerableToRange)
            {
               for each(ed in finalDamage.effectDamages)
               {
                  if(ed.damageDistance != -1 && ed.hasDamage)
                  {
                     hasDamageDistance = true;
                     if(ed.damageDistance < 2)
                     {
                        invulnerableToRange = false;
                     }
                     else
                     {
                        ed.minDamage = ed.maxDamage = ed.minCriticalDamage = ed.maxCriticalDamage = 0;
                     }
                  }
               }
               if(!hasDamageDistance)
               {
                  invulnerableToRange = false;
               }
            }
            invulnerableToMelee = pSpellDamageInfo.targetIsInvulnerableToMelee;
            if(invulnerableToMelee)
            {
               hasDamageDistance = false;
               for each(ed in finalDamage.effectDamages)
               {
                  if(ed.damageDistance != -1 && ed.hasDamage)
                  {
                     hasDamageDistance = true;
                     if(ed.damageDistance > 1)
                     {
                        invulnerableToMelee = false;
                     }
                     else
                     {
                        ed.minDamage = ed.maxDamage = ed.minCriticalDamage = ed.maxCriticalDamage = 0;
                     }
                  }
               }
               if(!hasDamageDistance)
               {
                  invulnerableToMelee = false;
               }
            }
            invulnerable = invulnerableToRange || invulnerableToMelee;
         }
         finalDamage.updateDamage();
         if(forceIsHealingSpell)
         {
            forceIsHealingSpellValue = finalDamage.hasHeal && finalDamage.minDamage == 0 && finalDamage.maxDamage == 0 && finalDamage.minCriticalDamage == 0 && finalDamage.maxCriticalDamage == 0;
         }
         var finalShield:EffectDamage = computeShield(pSpellDamageInfo.shield);
         finalDamage.addEffectDamage(finalShield);
         finalDamage.updateShield();
         finalDamage.hasCriticalShieldPointsAdded = finalShield.minCriticalShieldPointsAdded > 0 && finalShield.maxCriticalShieldPointsAdded > 0;
         for each(ed in finalDamage.effectDamages)
         {
            for each(computedEffect in ed.computedEffects)
            {
               if(computedEffect.duration <= 0)
               {
                  permanentMinDamage = permanentMinDamage + computedEffect.minDamage;
                  permanentMaxDamage = permanentMaxDamage + computedEffect.maxDamage;
                  permanentMinCriticalDamage = permanentMinCriticalDamage + computedEffect.minCriticalDamage;
                  permanentMaxCriticalDamage = permanentMaxCriticalDamage + computedEffect.maxCriticalDamage;
               }
            }
         }
         pSpellDamageInfo.targetShieldPoints = pSpellDamageInfo.targetShieldPoints + pSpellDamageInfo.targetTriggeredShieldPoints;
         if(pSpellDamageInfo.targetShieldPoints > 0)
         {
            minShieldDiff = permanentMinDamage - pSpellDamageInfo.targetShieldPoints;
            if(minShieldDiff < 0)
            {
               finalDamage.minShieldPointsRemoved = permanentMinDamage;
               if(permanentMinDamage > 0)
               {
                  finalDamage.minDamage = 0;
               }
            }
            else
            {
               finalDamage.minDamage = finalDamage.minDamage - pSpellDamageInfo.targetShieldPoints;
               finalDamage.minShieldPointsRemoved = pSpellDamageInfo.targetShieldPoints;
            }
            maxShieldDiff = permanentMaxDamage - pSpellDamageInfo.targetShieldPoints;
            if(maxShieldDiff < 0)
            {
               finalDamage.maxShieldPointsRemoved = permanentMaxDamage;
               if(permanentMaxDamage > 0)
               {
                  finalDamage.maxDamage = 0;
               }
            }
            else
            {
               finalDamage.maxDamage = finalDamage.maxDamage - pSpellDamageInfo.targetShieldPoints;
               finalDamage.maxShieldPointsRemoved = pSpellDamageInfo.targetShieldPoints;
            }
            minCriticalShieldDiff = permanentMinCriticalDamage - pSpellDamageInfo.targetShieldPoints;
            if(minCriticalShieldDiff < 0)
            {
               finalDamage.minCriticalShieldPointsRemoved = permanentMinCriticalDamage;
               if(permanentMinCriticalDamage > 0)
               {
                  finalDamage.minCriticalDamage = 0;
               }
            }
            else
            {
               finalDamage.minCriticalDamage = finalDamage.minCriticalDamage - pSpellDamageInfo.targetShieldPoints;
               finalDamage.minCriticalShieldPointsRemoved = pSpellDamageInfo.targetShieldPoints;
            }
            maxCriticalShieldDiff = permanentMaxCriticalDamage - pSpellDamageInfo.targetShieldPoints;
            if(maxCriticalShieldDiff < 0)
            {
               finalDamage.maxCriticalShieldPointsRemoved = permanentMaxCriticalDamage;
               if(permanentMaxCriticalDamage > 0)
               {
                  finalDamage.maxCriticalDamage = 0;
               }
            }
            else
            {
               finalDamage.maxCriticalDamage = finalDamage.maxCriticalDamage - pSpellDamageInfo.targetShieldPoints;
               finalDamage.maxCriticalShieldPointsRemoved = pSpellDamageInfo.targetShieldPoints;
            }
            if(pSpellDamageInfo.spellHasCriticalDamage)
            {
               finalDamage.hasCriticalShieldPointsRemoved = true;
            }
         }
         if(pSpellDamageInfo.casterStatus.cantDealDamage)
         {
            finalDamage.minDamage = finalDamage.maxDamage = finalDamage.minCriticalDamage = finalDamage.maxCriticalDamage = 0;
            finalDamage.minShieldPointsRemoved = finalDamage.maxShieldPointsRemoved = finalDamage.minCriticalShieldPointsRemoved = finalDamage.maxCriticalShieldPointsRemoved = 0;
         }
         finalDamage.hasCriticalLifePointsAdded = pSpellDamageInfo.spellHasCriticalHeal;
         finalDamage.invulnerableState = invulnerable;
         finalDamage.unhealableState = pSpellDamageInfo.targetIsUnhealable;
         finalDamage.isHealingSpell = !forceIsHealingSpell?Boolean(pSpellDamageInfo.isHealingSpell):Boolean(forceIsHealingSpellValue);
         hasInterceptedDamage = false;
         for each(intercepted in pSpellDamageInfo.interceptedDamages)
         {
            if(intercepted.interceptedEntityId == pSpellDamageInfo.targetId)
            {
               hasInterceptedDamage = true;
               break;
            }
         }
         if(hasInterceptedDamage)
         {
            for each(intercepted in pSpellDamageInfo.interceptedDamages)
            {
               intercepted.damage.invulnerableState = finalDamage.invulnerableState;
               intercepted.damage.unhealableState = finalDamage.unhealableState;
               intercepted.damage.hasCriticalDamage = finalDamage.hasCriticalDamage;
               intercepted.damage.hasCriticalShieldPointsRemoved = finalDamage.hasCriticalShieldPointsRemoved;
               intercepted.damage.hasCriticalShieldPointsAdded = finalDamage.hasCriticalShieldPointsAdded;
               intercepted.damage.hasCriticalLifePointsAdded = finalDamage.hasCriticalLifePointsAdded;
               intercepted.damage.isHealingSpell = finalDamage.isHealingSpell;
               intercepted.damage.hasHeal = finalDamage.hasHeal;
               intercepted.damage.isCriticalHit = finalDamage.isCriticalHit;
               intercepted.damage.minimizedEffects = finalDamage.minimizedEffects;
               intercepted.damage.maximizedEffects = finalDamage.maximizedEffects;
               intercepted.damage.efficiencyMultiplier = finalDamage.efficiencyMultiplier;
            }
            for each(ed in finalDamage.effectDamages)
            {
               if(ed != finalInterceptedDmg && (!splashEffectDamages || splashEffectDamages.indexOf(ed) == -1))
               {
                  for each(intercepted in pSpellDamageInfo.interceptedDamages)
                  {
                     interceptedEffect = ed.clone();
                     interceptedEffect.effectId = ActionIdConverter.ACTION_CHARACTER_SACRIFY;
                     intercepted.damage.addEffectDamage(interceptedEffect);
                  }
                  ed.minDamage = ed.maxDamage = ed.minCriticalDamage = ed.maxCriticalDamage = 0;
                  ed.computedEffects.length = 0;
               }
            }
            finalDamage.updateDamage();
         }
         return finalDamage;
      }
      
      private static function addSplashDamages(param1:SpellDamage, param2:Vector.<SplashDamage>, param3:SpellDamageInfo, param4:int, param5:Boolean, param6:Vector.<EffectDamage>, param7:Vector.<EffectDamage>) : void
      {
         var _loc8_:EffectDamage = null;
         var _loc9_:Boolean = false;
         var _loc10_:EffectDamage = null;
         var _loc11_:SplashDamage = null;
         var _loc12_:uint = 0;
         var _loc13_:Number = NaN;
         var _loc14_:EffectDamage = null;
         if(param2)
         {
            for each(_loc11_ in param2)
            {
               if(_loc11_.targets.indexOf(param3.targetId) != -1)
               {
                  _loc12_ = EntitiesManager.getInstance().getEntity(_loc11_.casterId).position.cellId;
                  _loc13_ = getShapeEfficiency(_loc11_.spellShape,_loc12_,param3.targetCell,_loc11_.spellShapeSize != null?int(int(_loc11_.spellShapeSize)):int(EFFECTSHAPE_DEFAULT_AREA_SIZE),_loc11_.spellShapeMinSize != null?int(int(_loc11_.spellShapeMinSize)):int(EFFECTSHAPE_DEFAULT_MIN_AREA_SIZE),_loc11_.spellShapeEfficiencyPercent != null?int(int(_loc11_.spellShapeEfficiencyPercent)):int(EFFECTSHAPE_DEFAULT_EFFICIENCY),_loc11_.spellShapeMaxEfficiency != null?int(int(_loc11_.spellShapeMaxEfficiency)):int(EFFECTSHAPE_DEFAULT_MAX_EFFICIENCY_APPLY));
                  _loc9_ = false;
                  for each(_loc10_ in _loc11_.damage.effectDamages)
                  {
                     if(_loc10_.effectId == SPLASH_HEAL_EFFECT_ID)
                     {
                        _loc9_ = true;
                        break;
                     }
                  }
                  _loc8_ = computeDamage(_loc11_.damage,param3,_loc13_,true,!param5 || _loc9_,_loc9_);
                  _loc8_.damageDistance = param3.targetCell != -1?int(MapPoint.fromCellId(_loc11_.casterCell).distanceToCell(MapPoint.fromCellId(param3.targetCell))):-1;
                  if(_loc8_.effectId == SPLASH_HEAL_EFFECT_ID)
                  {
                     _loc8_.convertDamageToHeal();
                     if(_loc8_.hasCritical)
                     {
                        param3.spellHasCriticalHeal = true;
                     }
                     param7.push(_loc8_);
                  }
                  else if(_loc8_.random > 0)
                  {
                     if(_loc11_.random > 0)
                     {
                        _loc14_ = new EffectDamage(_loc8_.effectId,_loc8_.element,_loc11_.random);
                        _loc14_.hasCritical = _loc8_.hasCritical;
                        _loc14_.damageDistance = _loc8_.damageDistance;
                        param6.push(_loc14_);
                        for each(_loc10_ in _loc8_.computedEffects)
                        {
                           if(_loc10_.random > 0)
                           {
                              _loc10_.hasCritical = _loc8_.hasCritical;
                              _loc14_.minDamage = _loc14_.minDamage > 0?int(Math.min(_loc14_.minDamage,_loc10_.minDamage)):int(_loc10_.minDamage);
                              _loc14_.maxDamage = Math.max(_loc14_.maxDamage,_loc10_.maxDamage);
                              _loc14_.minCriticalDamage = _loc14_.minCriticalDamage > 0?int(Math.min(_loc14_.minCriticalDamage,_loc10_.minCriticalDamage)):int(_loc10_.minCriticalDamage);
                              _loc14_.maxCriticalDamage = Math.max(_loc14_.maxCriticalDamage,_loc10_.maxCriticalDamage);
                           }
                        }
                        param1.addEffectDamage(_loc14_);
                     }
                     else
                     {
                        param6.push(_loc8_);
                        for each(_loc10_ in _loc8_.computedEffects)
                        {
                           _loc10_.hasCritical = _loc8_.hasCritical;
                           _loc10_.damageDistance = _loc8_.damageDistance;
                           param1.addEffectDamage(_loc10_);
                        }
                     }
                  }
                  else
                  {
                     param6.push(_loc8_);
                     _loc8_.random = _loc11_.random;
                     param1.addEffectDamage(_loc8_);
                  }
                  if(param3.targetId == param3.casterId)
                  {
                     if(param3.casterLifePointsAfterNormalMinDamage == 0)
                     {
                        param3.casterLifePointsAfterNormalMinDamage = param4 - _loc8_.minDamage;
                     }
                     else
                     {
                        param3.casterLifePointsAfterNormalMinDamage = param3.casterLifePointsAfterNormalMinDamage - _loc8_.minDamage;
                     }
                     if(param3.casterLifePointsAfterNormalMaxDamage == 0)
                     {
                        param3.casterLifePointsAfterNormalMaxDamage = param4 - _loc8_.maxDamage;
                     }
                     else
                     {
                        param3.casterLifePointsAfterNormalMaxDamage = param3.casterLifePointsAfterNormalMaxDamage - _loc8_.maxDamage;
                     }
                     if(param3.casterLifePointsAfterCriticalMinDamage == 0)
                     {
                        param3.casterLifePointsAfterCriticalMinDamage = param4 - _loc8_.minCriticalDamage;
                     }
                     else
                     {
                        param3.casterLifePointsAfterCriticalMinDamage = param3.casterLifePointsAfterCriticalMinDamage - _loc8_.minCriticalDamage;
                     }
                     if(param3.casterLifePointsAfterCriticalMaxDamage == 0)
                     {
                        param3.casterLifePointsAfterCriticalMaxDamage = param4 - _loc8_.maxCriticalDamage;
                     }
                     else
                     {
                        param3.casterLifePointsAfterCriticalMaxDamage = param3.casterLifePointsAfterCriticalMaxDamage - _loc8_.maxCriticalDamage;
                     }
                  }
               }
            }
         }
      }
      
      public static function getDamageBeforeIndex(param1:Vector.<EffectDamage>, param2:uint) : EffectDamage
      {
         var _loc4_:EffectDamage = null;
         var _loc3_:EffectDamage = new EffectDamage();
         for each(_loc4_ in param1)
         {
            if(_loc4_.spellEffectOrder < param2)
            {
               _loc3_.minDamage = _loc3_.minDamage + _loc4_.minDamage;
               _loc3_.minBaseDamage = _loc3_.minBaseDamage + _loc4_.minBaseDamage;
               _loc3_.maxDamage = _loc3_.maxDamage + _loc4_.maxDamage;
               _loc3_.maxBaseDamage = _loc3_.maxBaseDamage + _loc4_.maxBaseDamage;
               _loc3_.minCriticalDamage = _loc3_.minCriticalDamage + _loc4_.minCriticalDamage;
               _loc3_.minBaseCriticalDamage = _loc3_.minBaseCriticalDamage + _loc4_.minBaseCriticalDamage;
               _loc3_.maxCriticalDamage = _loc3_.maxCriticalDamage + _loc4_.maxCriticalDamage;
               _loc3_.maxBaseCriticalDamage = _loc3_.maxBaseCriticalDamage + _loc4_.maxBaseCriticalDamage;
            }
         }
         return _loc3_;
      }
      
      public static function getAllEffectDamages(param1:SpellDamage) : Vector.<EffectDamage>
      {
         var _loc4_:int = 0;
         var _loc2_:Vector.<EffectDamage> = new Vector.<EffectDamage>(0);
         var _loc3_:uint = param1.effectDamages.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = _loc2_.concat(param1.effectDamages[_loc4_].computedEffects);
            _loc4_++;
         }
         return _loc2_;
      }
      
      private static function computeTargetHpBasedBuffDamage(param1:SpellDamageInfo, param2:Vector.<EffectDamage>, param3:Vector.<SpellDamage>, param4:Boolean, param5:Boolean) : Vector.<EffectDamage>
      {
         var _loc9_:EffectDamage = null;
         var _loc10_:SpellDamage = null;
         var _loc11_:EffectDamage = null;
         var _loc12_:int = 0;
         var _loc6_:Vector.<EffectDamage> = new Vector.<EffectDamage>();
         var _loc7_:int = ((Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).getEntityInfos(param1.targetId) as GameFightFighterInformations).stats.lifePoints;
         var _loc8_:uint = param2.length;
         _loc12_ = 0;
         while(_loc12_ < _loc8_)
         {
            _loc9_ = param2[_loc12_];
            if(_loc12_ == 0)
            {
               param1.targetLifePointsAfterNormalMinDamage = _loc7_ - _loc9_.minDamage < 0?uint(0):uint(_loc7_ - _loc9_.minDamage);
               param1.targetLifePointsAfterNormalMaxDamage = _loc7_ - _loc9_.maxDamage < 0?uint(0):uint(_loc7_ - _loc9_.maxDamage);
               param1.targetLifePointsAfterCriticalMinDamage = _loc7_ - _loc9_.minCriticalDamage < 0?uint(0):uint(_loc7_ - _loc9_.minCriticalDamage);
               param1.targetLifePointsAfterCriticalMaxDamage = _loc7_ - _loc9_.maxCriticalDamage < 0?uint(0):uint(_loc7_ - _loc9_.maxCriticalDamage);
            }
            else
            {
               param1.targetLifePointsAfterNormalMinDamage = param1.targetLifePointsAfterNormalMinDamage - _loc9_.minDamage < 0?uint(0):uint(param1.targetLifePointsAfterNormalMinDamage - _loc9_.minDamage);
               param1.targetLifePointsAfterNormalMaxDamage = param1.targetLifePointsAfterNormalMaxDamage - _loc9_.maxDamage < 0?uint(0):uint(param1.targetLifePointsAfterNormalMaxDamage - _loc9_.maxDamage);
               param1.targetLifePointsAfterCriticalMinDamage = param1.targetLifePointsAfterCriticalMinDamage - _loc9_.minCriticalDamage < 0?uint(0):uint(param1.targetLifePointsAfterCriticalMinDamage - _loc9_.minCriticalDamage);
               param1.targetLifePointsAfterCriticalMaxDamage = param1.targetLifePointsAfterCriticalMaxDamage - _loc9_.maxCriticalDamage < 0?uint(0):uint(param1.targetLifePointsAfterCriticalMaxDamage - _loc9_.maxCriticalDamage);
            }
            for each(_loc10_ in param3)
            {
               _loc11_ = computeDamage(_loc10_,param1,1,false,!param4,!param4,!param5);
               _loc6_.push(_loc11_);
               param1.targetLifePointsAfterNormalMinDamage = param1.targetLifePointsAfterNormalMinDamage - _loc11_.minDamage < 0?uint(0):uint(param1.targetLifePointsAfterNormalMinDamage - _loc11_.minDamage);
               param1.targetLifePointsAfterNormalMaxDamage = param1.targetLifePointsAfterNormalMaxDamage - _loc11_.maxDamage < 0?uint(0):uint(param1.targetLifePointsAfterNormalMaxDamage - _loc11_.maxDamage);
               param1.targetLifePointsAfterCriticalMinDamage = param1.targetLifePointsAfterCriticalMinDamage - _loc11_.minCriticalDamage < 0?uint(0):uint(param1.targetLifePointsAfterCriticalMinDamage - _loc11_.minCriticalDamage);
               param1.targetLifePointsAfterCriticalMaxDamage = param1.targetLifePointsAfterCriticalMaxDamage - _loc11_.maxCriticalDamage < 0?uint(0):uint(param1.targetLifePointsAfterCriticalMaxDamage - _loc11_.maxCriticalDamage);
            }
            _loc12_++;
         }
         return _loc6_;
      }
      
      private static function computeHeal(param1:EffectDamage, param2:Vector.<EffectDamage>, param3:SpellDamageInfo, param4:Number) : void
      {
         var _loc6_:EffectDamage = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:EffectDamage = null;
         var _loc5_:uint = param3.targetInfos.stats.maxLifePoints - param3.targetInfos.stats.lifePoints;
         var _loc12_:uint = 10 + param3.targetErosionPercentBonus;
         if(_loc12_ > 50)
         {
            _loc12_ = 50;
         }
         for each(_loc11_ in param1.computedEffects)
         {
            _loc6_ = getDamageBeforeIndex(param2,_loc11_.spellEffectOrder);
            _loc6_.minDamage = _loc6_.minDamage + (_loc5_ - Math.floor(_loc12_ * _loc6_.minBaseDamage / 100));
            _loc6_.maxDamage = _loc6_.maxDamage + (_loc5_ - Math.floor(_loc12_ * _loc6_.maxBaseDamage / 100));
            _loc6_.minCriticalDamage = _loc6_.minCriticalDamage + (_loc5_ - Math.floor(_loc12_ * _loc6_.minBaseCriticalDamage / 100));
            _loc6_.maxCriticalDamage = _loc6_.maxCriticalDamage + (_loc5_ - Math.floor(_loc12_ * _loc6_.maxBaseCriticalDamage / 100));
            if(!param3.isHealingSpell && _loc6_.minDamage > 0 && _loc11_.minLifePointsAdded > _loc6_.minDamage - _loc7_)
            {
               _loc7_ = _loc7_ + (_loc6_.minDamage - _loc7_);
            }
            else
            {
               _loc7_ = _loc7_ + _loc11_.minLifePointsAdded;
            }
            if(!param3.isHealingSpell && _loc6_.maxDamage > 0 && _loc11_.maxLifePointsAdded > _loc6_.maxDamage - _loc8_)
            {
               _loc8_ = _loc8_ + (_loc6_.maxDamage - _loc8_);
            }
            else
            {
               _loc8_ = _loc8_ + _loc11_.maxLifePointsAdded;
            }
            if(!param3.isHealingSpell && _loc6_.minCriticalDamage > 0 && _loc11_.minCriticalLifePointsAdded > _loc6_.minCriticalDamage - _loc9_)
            {
               _loc9_ = _loc9_ + (_loc6_.minCriticalDamage - _loc9_);
            }
            else
            {
               _loc9_ = _loc9_ + _loc11_.minCriticalLifePointsAdded;
            }
            if(!param3.isHealingSpell && _loc6_.maxCriticalDamage > 0 && _loc11_.maxCriticalLifePointsAdded > _loc6_.maxCriticalDamage - _loc10_)
            {
               _loc10_ = _loc10_ + (_loc6_.maxCriticalDamage - _loc10_);
            }
            else
            {
               _loc10_ = _loc10_ + _loc11_.maxCriticalLifePointsAdded;
            }
            if(!param3.isHealingSpell && _loc6_.minDamage > 0 && _loc11_.lifePointsAddedBasedOnLifePercent > _loc6_.minDamage - _loc7_ || !param3.isHealingSpell && _loc11_.lifePointsAddedBasedOnLifePercent > _loc6_.maxDamage - _loc8_)
            {
               _loc7_ = _loc7_ + (_loc6_.minDamage - _loc7_);
               _loc8_ = _loc8_ + (_loc6_.maxDamage - _loc8_);
            }
            else
            {
               _loc7_ = _loc7_ + _loc11_.lifePointsAddedBasedOnLifePercent;
               _loc8_ = _loc8_ + _loc11_.lifePointsAddedBasedOnLifePercent;
            }
            if(!param3.isHealingSpell && _loc6_.minCriticalDamage > 0 && _loc11_.criticalLifePointsAddedBasedOnLifePercent > _loc6_.minCriticalDamage - _loc9_ || !param3.isHealingSpell && _loc11_.criticalLifePointsAddedBasedOnLifePercent > _loc6_.maxCriticalDamage - _loc10_)
            {
               _loc9_ = _loc9_ + (_loc6_.minCriticalDamage - _loc9_);
               _loc10_ = _loc10_ + (_loc6_.maxCriticalDamage - _loc10_);
            }
            else
            {
               _loc9_ = _loc9_ + _loc11_.criticalLifePointsAddedBasedOnLifePercent;
               _loc10_ = _loc10_ + _loc11_.criticalLifePointsAddedBasedOnLifePercent;
            }
         }
         param1.minLifePointsAdded = _loc7_ * param4;
         param1.maxLifePointsAdded = _loc8_ * param4;
         param1.minCriticalLifePointsAdded = _loc9_ * param4;
         param1.maxCriticalLifePointsAdded = _loc10_ * param4;
         if(param3.isHealingSpell)
         {
            param1.minLifePointsAdded = param1.minLifePointsAdded > _loc5_?int(_loc5_):int(param1.minLifePointsAdded);
            param1.maxLifePointsAdded = param1.maxLifePointsAdded > _loc5_?int(_loc5_):int(param1.maxLifePointsAdded);
            param1.minCriticalLifePointsAdded = param1.minCriticalLifePointsAdded > _loc5_?int(_loc5_):int(param1.minCriticalLifePointsAdded);
            param1.maxCriticalLifePointsAdded = param1.maxCriticalLifePointsAdded > _loc5_?int(_loc5_):int(param1.maxCriticalLifePointsAdded);
         }
      }
      
      private static function computeShield(param1:SpellDamage) : EffectDamage
      {
         var _loc3_:EffectDamage = null;
         var _loc2_:EffectDamage = new EffectDamage();
         for each(_loc3_ in param1.effectDamages)
         {
            _loc2_.minShieldPointsAdded = _loc2_.minShieldPointsAdded + _loc3_.minShieldPointsAdded;
            _loc2_.maxShieldPointsAdded = _loc2_.maxShieldPointsAdded + _loc3_.maxShieldPointsAdded;
            _loc2_.minCriticalShieldPointsAdded = _loc2_.minCriticalShieldPointsAdded + _loc3_.minCriticalShieldPointsAdded;
            _loc2_.maxCriticalShieldPointsAdded = _loc2_.maxCriticalShieldPointsAdded + _loc3_.maxCriticalShieldPointsAdded;
         }
         return _loc2_;
      }
      
      private static function computeDamageWithoutResistsBoosts(param1:Number, param2:EffectDamage, param3:SpellDamageInfo, param4:Number, param5:Boolean = false, param6:Boolean = false) : EffectDamage
      {
         var _loc7_:SpellDamage = null;
         _loc7_ = new SpellDamage();
         _loc7_.addEffectDamage(param2);
         _loc7_.hasCriticalDamage = param2.hasCritical;
         param3.targetId = param1;
         return computeDamage(_loc7_,param3,param4,param5,false,false,false,true,param6);
      }
      
      public static function computeDamage(param1:SpellDamage, param2:SpellDamageInfo, param3:Number, param4:Boolean = false, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false) : EffectDamage
      {
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:Boolean = false;
         var _loc21_:EffectModification = null;
         var _loc22_:int = 0;
         var _loc23_:EffectDamage = null;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:int = 0;
         var _loc28_:int = 0;
         var _loc29_:Vector.<int> = null;
         var _loc30_:int = 0;
         var _loc31_:Vector.<int> = null;
         var _loc32_:int = 0;
         var _loc33_:Vector.<int> = null;
         var _loc34_:int = 0;
         var _loc35_:Vector.<int> = null;
         var _loc45_:int = 0;
         var _loc46_:int = 0;
         var _loc48_:EffectDamage = null;
         var _loc49_:EffectDamage = null;
         var _loc50_:int = 0;
         var _loc51_:Boolean = false;
         var _loc52_:uint = 0;
         var _loc53_:uint = 0;
         var _loc54_:uint = 0;
         var _loc55_:uint = 0;
         var _loc56_:uint = 0;
         var _loc57_:uint = 0;
         var _loc58_:uint = 0;
         var _loc59_:int = 0;
         var _loc60_:int = 0;
         var _loc61_:int = 0;
         var _loc62_:uint = 0;
         var _loc16_:int = param2.casterAllDamagesBonus;
         var _loc17_:int = !param2.triggeredSpell?int(param2.casterCriticalDamageBonus):0;
         var _loc18_:int = param2.targetCriticalDamageFixedResist;
         var _loc36_:Number = param2.casterMovementPoints / param2.casterMaxMovementPoints;
         var _loc37_:uint = param2.casterLifePointsAfterNormalMinDamage > 0?uint(param2.casterLifePointsAfterNormalMinDamage):uint(param2.casterLifePoints);
         var _loc38_:uint = param2.casterLifePointsAfterNormalMaxDamage > 0?uint(param2.casterLifePointsAfterNormalMaxDamage):uint(param2.casterLifePoints);
         var _loc39_:uint = param2.casterLifePointsAfterCriticalMinDamage > 0?uint(param2.casterLifePointsAfterCriticalMinDamage):uint(param2.casterLifePoints);
         var _loc40_:uint = param2.casterLifePointsAfterCriticalMaxDamage > 0?uint(param2.casterLifePointsAfterCriticalMaxDamage):uint(param2.casterLifePoints);
         var _loc41_:uint = param2.targetLifePointsAfterNormalMinDamage > 0?uint(param2.targetLifePointsAfterNormalMinDamage):!!param2.targetInfos?uint(param2.targetInfos.stats.lifePoints):uint(0);
         var _loc42_:uint = param2.targetLifePointsAfterNormalMaxDamage > 0?uint(param2.targetLifePointsAfterNormalMaxDamage):!!param2.targetInfos?uint(param2.targetInfos.stats.lifePoints):uint(0);
         var _loc43_:uint = param2.targetLifePointsAfterCriticalMinDamage > 0?uint(param2.targetLifePointsAfterCriticalMinDamage):!!param2.targetInfos?uint(param2.targetInfos.stats.lifePoints):uint(0);
         var _loc44_:uint = param2.targetLifePointsAfterCriticalMaxDamage > 0?uint(param2.targetLifePointsAfterCriticalMaxDamage):!!param2.targetInfos?uint(param2.targetInfos.stats.lifePoints):uint(0);
         var _loc47_:int = param1.effectDamages.length;
         _loc45_ = 0;
         while(_loc45_ < _loc47_)
         {
            _loc23_ = param1.effectDamages[_loc45_];
            if(!_loc48_)
            {
               _loc48_ = new EffectDamage(_loc23_.effectId,param1.element,param1.random);
            }
            _loc13_ = 0;
            if(NO_BOOST_EFFECTS_IDS.indexOf(_loc23_.effectId) != -1)
            {
               param4 = true;
            }
            _loc21_ = param2.getEffectModification(_loc23_.effectId,_loc45_,_loc23_.hasCritical);
            if(_loc21_)
            {
               _loc22_ = _loc21_.damagesBonus;
               if(_loc21_.shieldPoints > param2.targetTriggeredShieldPoints)
               {
                  param2.targetTriggeredShieldPoints = _loc21_.shieldPoints;
               }
            }
            switch(_loc23_.element)
            {
               case NEUTRAL_ELEMENT:
                  if(!param4)
                  {
                     _loc46_ = param2.casterStrength;
                     _loc10_ = _loc46_ + param2.casterDamagesBonus + _loc22_ + (!!param2.isWeapon?param2.casterWeaponDamagesBonus:param2.casterSpellDamagesBonus);
                     _loc11_ = param2.casterStrengthBonus;
                     _loc12_ = param2.casterCriticalStrengthBonus;
                  }
                  if(!param6)
                  {
                     _loc13_ = param2.targetNeutralElementResistPercent;
                     _loc15_ = param2.targetNeutralElementReduction;
                  }
                  _loc19_ = param2.casterNeutralDamageBonus;
                  break;
               case EARTH_ELEMENT:
                  if(!param4)
                  {
                     _loc46_ = param2.casterStrength;
                     _loc10_ = _loc46_ + param2.casterDamagesBonus + _loc22_ + (!!param2.isWeapon?param2.casterWeaponDamagesBonus:param2.casterSpellDamagesBonus);
                     _loc11_ = param2.casterStrengthBonus;
                     _loc12_ = param2.casterCriticalStrengthBonus;
                  }
                  if(!param6)
                  {
                     _loc13_ = param2.targetEarthElementResistPercent;
                     _loc15_ = param2.targetEarthElementReduction;
                  }
                  _loc19_ = param2.casterEarthDamageBonus;
                  break;
               case FIRE_ELEMENT:
                  if(!param4)
                  {
                     _loc46_ = param2.casterIntelligence;
                     _loc10_ = _loc46_ + param2.casterDamagesBonus + _loc22_ + (!!param2.isWeapon?param2.casterWeaponDamagesBonus:param2.casterSpellDamagesBonus);
                     _loc11_ = param2.casterIntelligenceBonus;
                     _loc12_ = param2.casterCriticalIntelligenceBonus;
                  }
                  if(!param6)
                  {
                     _loc13_ = param2.targetFireElementResistPercent;
                     _loc15_ = param2.targetFireElementReduction;
                  }
                  _loc19_ = param2.casterFireDamageBonus;
                  break;
               case WATER_ELEMENT:
                  if(!param4)
                  {
                     _loc46_ = param2.casterChance;
                     _loc10_ = _loc46_ + param2.casterDamagesBonus + _loc22_ + (!!param2.isWeapon?param2.casterWeaponDamagesBonus:param2.casterSpellDamagesBonus);
                     _loc11_ = param2.casterChanceBonus;
                     _loc12_ = param2.casterCriticalChanceBonus;
                  }
                  if(!param6)
                  {
                     _loc13_ = param2.targetWaterElementResistPercent;
                     _loc15_ = param2.targetWaterElementReduction;
                  }
                  _loc19_ = param2.casterWaterDamageBonus;
                  break;
               case AIR_ELEMENT:
                  if(!param4)
                  {
                     _loc46_ = param2.casterAgility;
                     _loc10_ = _loc46_ + param2.casterDamagesBonus + _loc22_ + (!!param2.isWeapon?param2.casterWeaponDamagesBonus:param2.casterSpellDamagesBonus);
                     _loc11_ = param2.casterAgilityBonus;
                     _loc12_ = param2.casterCriticalAgilityBonus;
                  }
                  if(!param6)
                  {
                     _loc13_ = param2.targetAirElementResistPercent;
                     _loc15_ = param2.targetAirElementReduction;
                  }
                  _loc19_ = param2.casterAirDamageBonus;
            }
            _loc10_ = Math.max(0,_loc10_);
            if(!param6)
            {
               _loc15_ = _loc15_ + getBuffElementReduction(param2,_loc23_,param2.targetId);
            }
            if(param9)
            {
               _loc15_ = 0;
               _loc18_ = 0;
            }
            if(!param2.targetIsMonster)
            {
               _loc13_ = Math.min(_loc13_,50);
            }
            if(param7)
            {
               _loc13_ = 0;
            }
            _loc13_ = 100 - _loc13_;
            _loc14_ = (!!isNaN(_loc23_.efficiencyMultiplier)?param3:_loc23_.efficiencyMultiplier) * 100;
            if(param8)
            {
               _loc13_ = Math.min(100,_loc13_);
            }
            _loc20_ = true;
            if(HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc23_.effectId) == -1 && TARGET_HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc23_.effectId) == -1 && ERODED_HP_BASED_DAMAGE_EFFETS_IDS.indexOf(_loc23_.effectId) == -1)
            {
               if(param4)
               {
                  _loc19_ = _loc16_ = _loc17_ = 0;
               }
               if(param5)
               {
                  _loc18_ = 0;
               }
               _loc50_ = !!param2.spellDamageModification?int(param2.spellDamageModification.value.objectsAndMountBonus):0;
               _loc28_ = getDamage(_loc23_.minDamage,param4,_loc10_,_loc11_,_loc19_,_loc16_,_loc50_,_loc15_,_loc13_,_loc14_);
               _loc30_ = getDamage(!param4 && param2.spellWeaponCriticalBonus != 0?_loc23_.minDamage > 0?int(_loc23_.minDamage + param2.spellWeaponCriticalBonus):0:param2.isWeapon && param2.spell.id != 0?int(_loc23_.minDamage):int(_loc23_.minCriticalDamage),param4,_loc10_,_loc12_,_loc19_ + _loc17_,_loc16_,_loc50_,_loc15_ + _loc18_,_loc13_,_loc14_);
               _loc32_ = getDamage(_loc23_.maxDamage,param4,_loc10_,_loc11_,_loc19_,_loc16_,_loc50_,_loc15_,_loc13_,_loc14_);
               _loc34_ = getDamage(!param4 && param2.spellWeaponCriticalBonus != 0?_loc23_.maxDamage > 0?int(_loc23_.maxDamage + param2.spellWeaponCriticalBonus):0:param2.isWeapon && param2.spell.id != 0?int(_loc23_.maxDamage):int(_loc23_.maxCriticalDamage),param4,_loc10_,_loc12_,_loc19_ + _loc17_,_loc16_,_loc50_,_loc15_ + _loc18_,_loc13_,_loc14_);
               addr1225:
               _loc28_ = _loc28_ < 0?0:int(_loc28_);
               _loc32_ = _loc32_ < 0?0:int(_loc32_);
               _loc30_ = _loc30_ < 0?0:int(_loc30_);
               _loc34_ = _loc34_ < 0?0:int(_loc34_);
               if(MP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc23_.effectId) != -1)
               {
                  _loc28_ = _loc28_ * _loc36_;
                  _loc32_ = _loc32_ * _loc36_;
                  _loc30_ = _loc30_ * _loc36_;
                  _loc34_ = _loc34_ * _loc36_;
               }
               if(DamageUtil.EROSION_DAMAGE_EFFECTS_IDS.indexOf(_loc23_.effectId) != -1)
               {
                  _loc23_.minErosionDamage = (param2.targetErosionLifePoints + param2.targetSpellMinErosionLifePoints) * _loc23_.minErosionPercent / 100;
                  _loc23_.maxErosionDamage = (param2.targetErosionLifePoints + param2.targetSpellMaxErosionLifePoints) * _loc23_.maxErosionPercent / 100;
                  if(_loc23_.hasCritical)
                  {
                     _loc23_.minCriticalErosionDamage = (param2.targetErosionLifePoints + param2.targetSpellMinCriticalErosionLifePoints) * _loc23_.minCriticalErosionPercent / 100;
                     _loc23_.maxCriticalErosionDamage = (param2.targetErosionLifePoints + param2.targetSpellMaxCriticalErosionLifePoints) * _loc23_.maxCriticalErosionPercent / 100;
                  }
               }
               else
               {
                  _loc62_ = 10 + param2.targetErosionPercentBonus;
                  if(_loc62_ > 50)
                  {
                     _loc62_ = 50;
                  }
                  param2.targetSpellMinErosionLifePoints = param2.targetSpellMinErosionLifePoints + _loc28_ * _loc62_ / 100;
                  param2.targetSpellMaxErosionLifePoints = param2.targetSpellMaxErosionLifePoints + _loc32_ * _loc62_ / 100;
                  param2.targetSpellMinCriticalErosionLifePoints = param2.targetSpellMinCriticalErosionLifePoints + _loc30_ * _loc62_ / 100;
                  param2.targetSpellMaxCriticalErosionLifePoints = param2.targetSpellMaxCriticalErosionLifePoints + _loc34_ * _loc62_ / 100;
               }
               if(!_loc29_)
               {
                  _loc29_ = new Vector.<int>(0);
               }
               _loc29_.push(_loc28_);
               if(!_loc33_)
               {
                  _loc33_ = new Vector.<int>(0);
               }
               _loc33_.push(_loc32_);
               if(!_loc31_)
               {
                  _loc31_ = new Vector.<int>(0);
               }
               _loc31_.push(_loc30_);
               if(!_loc35_)
               {
                  _loc35_ = new Vector.<int>(0);
               }
               _loc35_.push(_loc34_);
               _loc24_ = _loc24_ + _loc28_;
               _loc26_ = _loc26_ + _loc32_;
               _loc25_ = _loc25_ + _loc30_;
               _loc27_ = _loc27_ + _loc34_;
               _loc49_ = new EffectDamage(_loc23_.effectId,_loc23_.element,_loc23_.random,_loc23_.duration,_loc20_);
               _loc49_.spellEffectOrder = _loc23_.spellEffectOrder;
               _loc49_.minDamage = _loc49_.minBaseDamage = _loc28_;
               _loc49_.maxDamage = _loc49_.maxBaseDamage = _loc32_;
               _loc49_.minCriticalDamage = _loc49_.minBaseCriticalDamage = _loc30_;
               _loc49_.maxCriticalDamage = _loc49_.maxBaseCriticalDamage = _loc34_;
               _loc49_.minErosionDamage = _loc23_.minErosionDamage;
               _loc49_.maxErosionDamage = _loc23_.maxErosionDamage;
               _loc49_.minCriticalErosionDamage = _loc23_.minCriticalErosionDamage;
               _loc49_.maxCriticalErosionDamage = _loc23_.maxCriticalErosionDamage;
               _loc49_.hasCritical = _loc23_.hasCritical;
               _loc49_.damageDistance = param2.distanceBetweenCasterAndTarget;
               _loc48_.computedEffects.push(_loc49_);
            }
            else if(_loc23_.computedEffects.length == 0)
            {
               if(TARGET_HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc23_.effectId) != -1)
               {
                  _loc52_ = param2.targetBaseMaxLifePoints;
                  _loc53_ = param2.targetMaxLifePoints;
                  _loc54_ = param2.targetLifePoints;
                  _loc55_ = _loc41_;
                  _loc56_ = _loc42_;
                  _loc57_ = _loc43_;
                  _loc58_ = _loc44_;
                  _loc59_ = param2.targetErosionLifePoints;
                  _loc51_ = true;
               }
               else if(param2.triggeredSpell)
               {
                  _loc52_ = param2.triggeredSpell.casterStats.baseMaxLifePoints;
                  _loc53_ = param2.triggeredSpell.casterStats.maxLifePoints;
                  _loc54_ = param2.triggeredSpell.casterStats.lifePoints;
                  _loc55_ = _loc41_;
                  _loc56_ = _loc42_;
                  _loc57_ = _loc43_;
                  _loc58_ = _loc44_;
                  _loc59_ = param2.triggeredSpell.casterStats.baseMaxLifePoints - param2.triggeredSpell.casterStats.maxLifePoints;
                  _loc51_ = true;
               }
               else
               {
                  _loc52_ = param2.casterBaseMaxLifePoints;
                  _loc53_ = param2.casterMaxLifePoints;
                  _loc54_ = param2.casterLifePoints;
                  _loc55_ = _loc37_;
                  _loc56_ = _loc38_;
                  _loc57_ = _loc39_;
                  _loc58_ = _loc40_;
                  _loc59_ = param2.casterErosionLifePoints;
               }
               if(_loc23_.effectId == ActionIdConverter.ACTION_CHARACTER_LIFE_POINTS_LOST_BASED_ON_CASTER_LIFE_MIDLIFE)
               {
                  _loc20_ = false;
                  _loc60_ = _loc23_.maxDamage * _loc52_ * getMidLifeDamageMultiplier(Math.min(100,Math.max(0,100 * _loc54_ / _loc53_))) / 100;
                  _loc28_ = _loc32_ = (_loc60_ - _loc15_) * _loc13_ / 100;
                  _loc61_ = _loc23_.maxCriticalDamage * _loc52_ * getMidLifeDamageMultiplier(Math.min(100,Math.max(0,100 * _loc54_ / _loc53_))) / 100;
                  _loc30_ = _loc34_ = (_loc61_ - _loc15_) * _loc13_ / 100;
               }
               else
               {
                  if(ERODED_HP_BASED_DAMAGE_EFFETS_IDS.indexOf(_loc23_.effectId) != -1)
                  {
                     _loc55_ = _loc56_ = _loc57_ = _loc58_ = _loc59_;
                  }
                  _loc28_ = getHpBasedDamage(_loc23_.minDamage,_loc55_,_loc13_,_loc15_,_loc14_);
                  _loc32_ = getHpBasedDamage(_loc23_.maxDamage,_loc56_,_loc13_,_loc15_,_loc14_);
                  _loc30_ = getHpBasedDamage(_loc23_.minCriticalDamage,_loc57_,_loc13_,_loc15_,_loc14_);
                  _loc34_ = getHpBasedDamage(_loc23_.maxCriticalDamage,_loc58_,_loc13_,_loc15_,_loc14_);
                  if(!_loc51_)
                  {
                     _loc37_ = _loc37_ - _loc28_;
                     _loc38_ = _loc38_ - _loc32_;
                     _loc39_ = _loc39_ - _loc30_;
                     _loc40_ = _loc40_ - _loc34_;
                  }
                  else
                  {
                     _loc41_ = _loc41_ - _loc28_;
                     _loc42_ = _loc42_ - _loc32_;
                     _loc43_ = _loc43_ - _loc30_;
                     _loc44_ = _loc44_ - _loc34_;
                  }
               }
               §§goto(addr1225);
            }
            else
            {
               _loc24_ = _loc24_ + _loc23_.minDamage;
               _loc26_ = _loc26_ + _loc23_.maxDamage;
               _loc25_ = _loc25_ + _loc23_.minCriticalDamage;
               _loc27_ = _loc27_ + _loc23_.maxCriticalDamage;
            }
            _loc45_++;
         }
         if(!_loc48_)
         {
            _loc48_ = new EffectDamage(-1,param1.element,param1.random);
         }
         _loc48_.minDamage = _loc48_.minBaseDamage = _loc24_;
         _loc48_.minDamageList = _loc29_;
         _loc48_.maxDamage = _loc48_.maxBaseDamage = _loc26_;
         _loc48_.maxDamageList = _loc33_;
         _loc48_.minCriticalDamage = _loc48_.minBaseCriticalDamage = _loc25_;
         _loc48_.minCriticalDamageList = _loc31_;
         _loc48_.maxCriticalDamage = _loc48_.maxBaseCriticalDamage = _loc27_;
         _loc48_.maxCriticalDamageList = _loc35_;
         _loc48_.minErosionDamage = param1.minErosionDamage * _loc14_ / 100;
         _loc48_.minErosionDamage = _loc48_.minErosionDamage * _loc13_ / 100;
         _loc48_.maxErosionDamage = param1.maxErosionDamage * _loc14_ / 100;
         _loc48_.maxErosionDamage = _loc48_.maxErosionDamage * _loc13_ / 100;
         _loc48_.minCriticalErosionDamage = param1.minCriticalErosionDamage * _loc14_ / 100;
         _loc48_.minCriticalErosionDamage = _loc48_.minCriticalErosionDamage * _loc13_ / 100;
         _loc48_.maxCriticalErosionDamage = param1.maxCriticalErosionDamage * _loc14_ / 100;
         _loc48_.maxCriticalErosionDamage = _loc48_.maxCriticalErosionDamage * _loc13_ / 100;
         _loc48_.hasCritical = param1.hasCriticalDamage;
         _loc48_.damageDistance = param2.distanceBetweenCasterAndTarget;
         return _loc48_;
      }
      
      private static function getDamage(param1:int, param2:Boolean, param3:int, param4:int, param5:int, param6:int, param7:int, param8:int, param9:int, param10:int) : int
      {
         if(!param2 && param3 + param4 <= 0)
         {
            param3 = param4 = 0;
         }
         var _loc11_:int = param1 > 0?int(Math.floor(param1 * (100 + param3 + param4) / 100) + param5 + param6):0;
         var _loc12_:int = _loc11_ > 0?int((_loc11_ + param7) * param10 / 100):0;
         var _loc13_:int = _loc12_ > 0?int(_loc12_ - param8):0;
         _loc13_ = _loc13_ < 0?0:int(_loc13_);
         return _loc13_ * param9 / 100;
      }
      
      private static function getHeal(param1:int, param2:int, param3:int) : int
      {
         return Math.floor(param1 * (100 + param2) / 100) + (param1 > 0?param3:0);
      }
      
      private static function getMidLifeDamageMultiplier(param1:int) : Number
      {
         return Math.pow(Math.cos(2 * Math.PI * (param1 * 0.01 - 0.5)) + 1,2) / 4;
      }
      
      private static function getHpBasedDamage(param1:int, param2:uint, param3:int, param4:int, param5:int) : int
      {
         var _loc6_:int = param1 * param2 / 100 * param5 / 100;
         return (_loc6_ - param4) * param3 / 100;
      }
      
      private static function getDistance(param1:uint, param2:uint) : int
      {
         return MapPoint.fromCellId(param1).distanceToCell(MapPoint.fromCellId(param2));
      }
      
      private static function getSquareDistance(param1:uint, param2:uint) : int
      {
         var _loc3_:MapPoint = MapPoint.fromCellId(param1);
         var _loc4_:MapPoint = MapPoint.fromCellId(param2);
         return Math.max(Math.abs(_loc3_.x - _loc4_.x),Math.abs(_loc3_.y - _loc4_.y));
      }
      
      public static function getShapeEfficiency(param1:uint, param2:uint, param3:uint, param4:int, param5:int, param6:int, param7:int) : Number
      {
         var _loc8_:int = 0;
         switch(param1)
         {
            case SpellShapeEnum.A:
            case SpellShapeEnum.a:
            case SpellShapeEnum.Z:
            case SpellShapeEnum.I:
            case SpellShapeEnum.O:
            case SpellShapeEnum.semicolon:
            case SpellShapeEnum.empty:
            case SpellShapeEnum.P:
               return DAMAGE_NOT_BOOSTED;
            case SpellShapeEnum.B:
            case SpellShapeEnum.V:
            case SpellShapeEnum.G:
            case SpellShapeEnum.W:
               _loc8_ = getSquareDistance(param2,param3);
               break;
            case SpellShapeEnum.minus:
            case SpellShapeEnum.plus:
            case SpellShapeEnum.U:
               _loc8_ = getDistance(param2,param3) / 2;
               break;
            default:
               _loc8_ = getDistance(param2,param3);
         }
         return getSimpleEfficiency(_loc8_,param4,param5,param6,param7);
      }
      
      public static function getSimpleEfficiency(param1:int, param2:int, param3:int, param4:int, param5:int) : Number
      {
         if(param4 == 0)
         {
            return DAMAGE_NOT_BOOSTED;
         }
         if(param2 <= 0 || param2 >= UNLIMITED_ZONE_SIZE)
         {
            return DAMAGE_NOT_BOOSTED;
         }
         if(param1 > param2)
         {
            return DAMAGE_NOT_BOOSTED;
         }
         if(param4 <= 0)
         {
            return DAMAGE_NOT_BOOSTED;
         }
         if(param3 != 0)
         {
            if(param1 <= param3)
            {
               return DAMAGE_NOT_BOOSTED;
            }
            return Math.max(0,DAMAGE_NOT_BOOSTED - 0.01 * Math.min(param1 - param3,param5) * param4);
         }
         return Math.max(0,DAMAGE_NOT_BOOSTED - 0.01 * Math.min(param1,param5) * param4);
      }
      
      public static function getPortalsSpellEfficiencyBonus(param1:int) : Number
      {
         var _loc3_:Boolean = false;
         var _loc4_:MapPoint = null;
         var _loc8_:Vector.<MarkInstance> = null;
         var _loc9_:int = 0;
         var _loc10_:MarkInstance = null;
         var _loc11_:MarkInstance = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc2_:Number = 1;
         var _loc5_:Vector.<MapPoint> = MarkedCellsManager.getInstance().getMarksMapPoint(GameActionMarkTypeEnum.PORTAL);
         for each(_loc4_ in _loc5_)
         {
            if(_loc4_.cellId == param1)
            {
               _loc3_ = true;
               break;
            }
         }
         if(!_loc3_)
         {
            return _loc2_;
         }
         var _loc6_:Vector.<uint> = LinkedCellsManager.getInstance().getLinks(MapPoint.fromCellId(param1),_loc5_);
         var _loc7_:int = _loc6_.length;
         if(_loc7_ > 1)
         {
            _loc8_ = new Vector.<MarkInstance>(0);
            _loc9_ = 0;
            while(_loc9_ < _loc7_)
            {
               _loc8_.push(MarkedCellsManager.getInstance().getMarkAtCellId(_loc6_[_loc9_],GameActionMarkTypeEnum.PORTAL));
               _loc9_++;
            }
            _loc9_ = 0;
            while(_loc9_ < _loc7_)
            {
               _loc10_ = _loc8_[_loc9_];
               _loc12_ = Math.max(_loc12_,int(_loc10_.associatedSpellLevel.effects[0].parameter2));
               if(_loc11_)
               {
                  _loc13_ = _loc13_ + MapPoint.fromCellId(_loc10_.cells[0]).distanceToCell(MapPoint.fromCellId(_loc11_.cells[0]));
               }
               _loc11_ = _loc10_;
               _loc9_++;
            }
            _loc2_ = 1 + (_loc12_ + 2 * _loc13_) / 100;
         }
         return _loc2_;
      }
      
      public static function getSplashDamages(param1:Vector.<TriggeredSpell>, param2:SpellDamageInfo, param3:Boolean) : Vector.<SplashDamage>
      {
         var _loc4_:Vector.<SplashDamage> = null;
         var _loc5_:TriggeredSpell = null;
         var _loc6_:SpellWrapper = null;
         var _loc7_:EffectInstance = null;
         var _loc8_:IZone = null;
         var _loc9_:Vector.<uint> = null;
         var _loc10_:uint = 0;
         var _loc11_:Vector.<Number> = null;
         var _loc13_:Array = null;
         var _loc14_:IEntity = null;
         var _loc16_:EffectDamage = null;
         var _loc17_:SpellDamage = null;
         var _loc12_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         var _loc15_:uint = EntitiesManager.getInstance().getEntity(param2.casterId).position.cellId;
         for each(_loc5_ in param1)
         {
            _loc6_ = _loc5_.spell;
            for each(_loc7_ in _loc6_.effects)
            {
               if(SPLASH_EFFECTS_IDS.indexOf(_loc7_.effectId) != -1 && (_loc7_.effectId == SPLASH_HEAL_EFFECT_ID || !param2.isHealingSpell))
               {
                  _loc8_ = SpellZoneManager.getInstance().getSpellZone(_loc6_,false,false);
                  _loc9_ = _loc8_.getCells(_loc5_.targetCell);
                  _loc11_ = null;
                  if(_loc7_.targetMask && _loc7_.targetMask.indexOf("O") != -1 && _loc9_.indexOf(_loc15_) == -1)
                  {
                     _loc9_.push(_loc15_);
                  }
                  for each(_loc10_ in _loc9_)
                  {
                     _loc13_ = EntitiesManager.getInstance().getEntitiesOnCell(_loc10_,AnimatedCharacter);
                     for each(_loc14_ in _loc13_)
                     {
                        if(_loc12_.getEntityInfos(_loc14_.id) && verifySpellEffectMask(_loc6_.playerId,_loc14_.id,_loc7_,_loc5_.targetCell,param2.casterId))
                        {
                           if(!_loc4_)
                           {
                              _loc4_ = new Vector.<SplashDamage>(0);
                           }
                           if(!_loc11_)
                           {
                              _loc11_ = new Vector.<Number>(0);
                           }
                           _loc11_.push(_loc14_.id);
                        }
                     }
                  }
                  if(_loc11_)
                  {
                     _loc17_ = DamageUtil.getSpellDamage(param2,false,false,false);
                     if(!param3)
                     {
                        for each(_loc16_ in _loc17_.effectDamages)
                        {
                           _loc16_.minCriticalDamage = _loc16_.maxCriticalDamage = _loc16_.minCriticalErosionDamage = _loc16_.maxCriticalErosionDamage = 0;
                           for each(_loc16_ in _loc16_.computedEffects)
                           {
                              _loc16_.minCriticalDamage = _loc16_.maxCriticalDamage = _loc16_.minCriticalErosionDamage = _loc16_.maxCriticalErosionDamage = 0;
                           }
                        }
                        _loc17_.minCriticalDamage = _loc17_.maxCriticalDamage = 0;
                     }
                     else
                     {
                        for each(_loc16_ in _loc17_.effectDamages)
                        {
                           _loc16_.minDamage = _loc16_.maxDamage = _loc16_.minErosionDamage = _loc16_.maxErosionDamage = 0;
                           for each(_loc16_ in _loc16_.computedEffects)
                           {
                              _loc16_.minDamage = _loc16_.maxDamage = _loc16_.minErosionDamage = _loc16_.maxErosionDamage = 0;
                           }
                        }
                        _loc17_.minDamage = _loc17_.maxDamage = 0;
                     }
                     _loc4_.push(new SplashDamage(_loc6_.id,_loc6_.playerId,_loc11_,_loc17_,_loc7_ as EffectInstanceDice,param2));
                  }
               }
            }
         }
         return _loc4_;
      }
      
      public static function getAverageElementResistance(param1:uint, param2:Vector.<Number>) : int
      {
         var _loc3_:String = null;
         switch(param1)
         {
            case NEUTRAL_ELEMENT:
               _loc3_ = "neutralElementResistPercent";
               break;
            case EARTH_ELEMENT:
               _loc3_ = "earthElementResistPercent";
               break;
            case FIRE_ELEMENT:
               _loc3_ = "fireElementResistPercent";
               break;
            case WATER_ELEMENT:
               _loc3_ = "waterElementResistPercent";
               break;
            case AIR_ELEMENT:
               _loc3_ = "airElementResistPercent";
         }
         return getAverageStat(_loc3_,param2);
      }
      
      public static function getAverageElementReduction(param1:uint, param2:Vector.<Number>) : int
      {
         var _loc3_:String = null;
         switch(param1)
         {
            case NEUTRAL_ELEMENT:
               _loc3_ = "neutralElementReduction";
               break;
            case EARTH_ELEMENT:
               _loc3_ = "earthElementReduction";
               break;
            case FIRE_ELEMENT:
               _loc3_ = "fireElementReduction";
               break;
            case WATER_ELEMENT:
               _loc3_ = "waterElementReduction";
               break;
            case AIR_ELEMENT:
               _loc3_ = "airElementReduction";
         }
         return getAverageStat(_loc3_,param2);
      }
      
      public static function getAverageBuffElementReduction(param1:SpellDamageInfo, param2:EffectDamage, param3:Vector.<Number>) : int
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         for each(_loc5_ in param3)
         {
            _loc4_ = _loc4_ + getBuffElementReduction(param1,param2,_loc5_);
         }
         return _loc4_ / param3.length;
      }
      
      public static function getBuffElementReduction(param1:SpellDamageInfo, param2:EffectDamage, param3:Number) : int
      {
         var _loc5_:BasicBuff = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:EffectInstance = null;
         var _loc10_:int = 0;
         var _loc12_:Boolean = false;
         var _loc4_:Array = BuffManager.getInstance().getAllBuff(param3);
         var _loc11_:Dictionary = new Dictionary(true);
         _loc9_ = new EffectInstance();
         _loc9_.effectId = param2.effectId;
         for each(_loc5_ in _loc4_)
         {
            _loc7_ = _loc5_.effect.triggers;
            _loc12_ = _loc5_.canBeDispell() && _loc5_.effect.duration - param1.spellTargetEffectsDurationReduction <= 0;
            if(!_loc12_ && _loc7_)
            {
               _loc8_ = _loc7_.split("|");
               if(!_loc11_[_loc5_.castingSpell.spell.id])
               {
                  _loc11_[_loc5_.castingSpell.spell.id] = new Vector.<int>(0);
               }
               for each(_loc6_ in _loc8_)
               {
                  if(_loc5_.actionId == 265 && verifyEffectTrigger(param1.casterId,param3,null,_loc9_,param1.isWeapon,_loc6_,param1.spellCenterCell))
                  {
                     if(_loc11_[_loc5_.castingSpell.spell.id].indexOf(param2.element) == -1)
                     {
                        _loc10_ = _loc10_ + (param1.targetLevel / 20 + 1) * (_loc5_.effect as EffectInstanceInteger).value;
                        if(_loc11_[_loc5_.castingSpell.spell.id].indexOf(param2.element) == -1)
                        {
                           _loc11_[_loc5_.castingSpell.spell.id].push(param2.element);
                        }
                     }
                  }
               }
            }
         }
         return _loc10_;
      }
      
      public static function getAverageStat(param1:String, param2:Vector.<Number>) : int
      {
         var _loc4_:Number = NaN;
         var _loc5_:GameFightFighterInformations = null;
         var _loc6_:int = 0;
         var _loc3_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         if(!_loc3_ || !param2 || param2.length == 0)
         {
            return -1;
         }
         if(param1)
         {
            for each(_loc4_ in param2)
            {
               _loc5_ = _loc3_.getEntityInfos(_loc4_) as GameFightFighterInformations;
               _loc6_ = _loc6_ + _loc5_.stats[param1];
            }
         }
         return _loc6_ / param2.length;
      }
      
      public static function hasMinSize(param1:int) : Boolean
      {
         return param1 == SpellShapeEnum.C || param1 == SpellShapeEnum.X || param1 == SpellShapeEnum.Q || param1 == SpellShapeEnum.plus || param1 == SpellShapeEnum.sharp;
      }
   }
}
