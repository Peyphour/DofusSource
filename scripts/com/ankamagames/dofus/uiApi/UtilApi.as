package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.EntitiesLooksManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.DamageUtil;
   import com.ankamagames.dofus.logic.game.fight.types.EffectDamage;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamage;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamageInfo;
   import com.ankamagames.dofus.misc.utils.ParamsDecoder;
   import com.ankamagames.dofus.network.enums.BoostableCharacteristicEnum;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.pools.PoolsManager;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.globalization.Collator;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class UtilApi implements IApi
   {
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      private var _stringSorter:Collator;
      
      private var _triggeredSpells:Dictionary;
      
      public function UtilApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(UtilApi));
         this._triggeredSpells = new Dictionary(true);
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function callWithParameters(param1:Function, param2:Array) : void
      {
         CallWithParameters.call(param1,param2);
      }
      
      [Untrusted]
      public function callConstructorWithParameters(param1:Class, param2:Array) : *
      {
         return CallWithParameters.callConstructor(param1,param2);
      }
      
      [Untrusted]
      public function callRWithParameters(param1:Function, param2:Array) : *
      {
         return CallWithParameters.callR(param1,param2);
      }
      
      [Untrusted]
      public function kamasToString(param1:Number, param2:String = "-") : String
      {
         return StringUtils.kamasToString(param1,param2);
      }
      
      [Untrusted]
      public function formateIntToString(param1:Number, param2:int = 2) : String
      {
         return StringUtils.formateIntToString(param1,param2);
      }
      
      [Untrusted]
      public function stringToKamas(param1:String, param2:String = "-") : Number
      {
         return StringUtils.stringToKamas(param1,param2);
      }
      
      [Untrusted]
      public function getTextWithParams(param1:int, param2:Array, param3:String = "%") : String
      {
         var _loc4_:String = I18n.getText(param1);
         if(_loc4_)
         {
            return ParamsDecoder.applyParams(_loc4_,param2,param3);
         }
         return "";
      }
      
      [Untrusted]
      public function applyTextParams(param1:String, param2:Array, param3:String = "%") : String
      {
         return ParamsDecoder.applyParams(param1,param2,param3);
      }
      
      [Trusted]
      public function noAccent(param1:String) : String
      {
         return StringUtils.noAccent(param1);
      }
      
      [Trusted]
      public function getAllIndexOf(param1:String, param2:String) : Array
      {
         return StringUtils.getAllIndexOf(param1,param2);
      }
      
      [Untrusted]
      public function changeColor(param1:Object, param2:Number, param3:int, param4:Boolean = false) : void
      {
         var _loc5_:ColorTransform = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc9_:ColorTransform = null;
         if(param1 != null)
         {
            if(param4)
            {
               _loc5_ = new ColorTransform(1,1,1,1,0,0,0);
               if(param1 is Texture)
               {
                  Texture(param1).colorTransform = _loc5_;
               }
               else if(param1 is DisplayObject)
               {
                  DisplayObject(param1).transform.colorTransform = _loc5_;
               }
            }
            else
            {
               _loc6_ = param2 >> 16 & 255;
               _loc7_ = param2 >> 8 & 255;
               _loc8_ = param2 >> 0 & 255;
               _loc9_ = new ColorTransform(0,0,0,1,_loc6_,_loc7_,_loc8_);
               if(param1 is Texture)
               {
                  Texture(param1).colorTransform = _loc9_;
               }
               else if(param1 is DisplayObject)
               {
                  DisplayObject(param1).transform.colorTransform = _loc9_;
               }
            }
         }
      }
      
      [Untrusted]
      public function sortOnString(param1:*, param2:String = "", param3:Boolean = true) : void
      {
         var list:* = param1;
         var field:String = param2;
         var ascending:Boolean = param3;
         if(!(list is Array) && !(list is Vector.<*>))
         {
            this._log.error("Tried to sort something different than an Array or a Vector!");
            return;
         }
         if(!this._stringSorter)
         {
            this._stringSorter = new Collator(XmlConfig.getInstance().getEntry("config.lang.current"));
         }
         if(field)
         {
            list.sort(function(param1:*, param2:*):int
            {
               var _loc3_:int = _stringSorter.compare(param1[field],param2[field]);
               return !!ascending?int(_loc3_):int(_loc3_ * -1);
            });
         }
         else
         {
            list.sort(this._stringSorter.compare);
         }
      }
      
      [Untrusted]
      public function sort(param1:*, param2:String, param3:Boolean = true, param4:Boolean = false) : *
      {
         var result:* = undefined;
         var sup:int = 0;
         var inf:int = 0;
         var target:* = param1;
         var field:String = param2;
         var ascendand:Boolean = param3;
         var isNumeric:Boolean = param4;
         if(target is Array)
         {
            result = (target as Array).concat();
            result.sortOn(field,(!!ascendand?0:Array.DESCENDING) | (!!isNumeric?Array.NUMERIC:Array.CASEINSENSITIVE));
            return result;
         }
         if(target is Vector.<*>)
         {
            result = target.concat();
            sup = !!ascendand?1:-1;
            inf = !!ascendand?-1:1;
            if(isNumeric)
            {
               result.sort(function(param1:*, param2:*):int
               {
                  if(param1[field] > param2[field])
                  {
                     return sup;
                  }
                  if(param1[field] < param2[field])
                  {
                     return inf;
                  }
                  return 0;
               });
            }
            else
            {
               result.sort(function(param1:*, param2:*):int
               {
                  var _loc3_:String = param1[field].toLocaleLowerCase();
                  var _loc4_:String = param2[field].toLocaleLowerCase();
                  if(_loc3_ > _loc4_)
                  {
                     return sup;
                  }
                  if(_loc3_ < _loc4_)
                  {
                     return inf;
                  }
                  return 0;
               });
            }
            return result;
         }
         return null;
      }
      
      [Untrusted]
      public function filter(param1:*, param2:*, param3:String) : *
      {
         var _loc7_:String = null;
         if(!param1)
         {
            return null;
         }
         var _loc4_:* = new (param1.constructor as Class)();
         var _loc5_:uint = param1.length;
         var _loc6_:uint = 0;
         if(param2 is String)
         {
            _loc7_ = String(param2).toLowerCase();
            while(_loc6_ < _loc5_)
            {
               if(String(param1[_loc6_][param3]).toLowerCase().indexOf(_loc7_) != -1)
               {
                  _loc4_.push(param1[_loc6_]);
               }
               _loc6_++;
            }
         }
         else
         {
            while(_loc6_ < _loc5_)
            {
               if(param1[_loc6_][param3] == param2)
               {
                  _loc4_.push(param1[_loc6_]);
               }
               _loc6_++;
            }
         }
         return _loc4_;
      }
      
      [Untrusted]
      public function getTiphonEntityLook(param1:Number) : TiphonEntityLook
      {
         return EntitiesLooksManager.getInstance().getTiphonEntityLook(param1);
      }
      
      [Untrusted]
      public function getRealTiphonEntityLook(param1:Number, param2:Boolean = false) : TiphonEntityLook
      {
         return EntitiesLooksManager.getInstance().getRealTiphonEntityLook(param1,param2);
      }
      
      [Untrusted]
      public function getLookFromContext(param1:Number, param2:Boolean = false) : TiphonEntityLook
      {
         return EntitiesLooksManager.getInstance().getLookFromContext(param1,param2);
      }
      
      [Untrusted]
      public function getLookFromContextInfos(param1:GameContextActorInformations, param2:Boolean = false) : TiphonEntityLook
      {
         return EntitiesLooksManager.getInstance().getLookFromContextInfos(param1,param2);
      }
      
      [Untrusted]
      public function isCreature(param1:Number) : Boolean
      {
         return EntitiesLooksManager.getInstance().isCreature(param1);
      }
      
      [Untrusted]
      public function isCreatureFromLook(param1:TiphonEntityLook) : Boolean
      {
         return EntitiesLooksManager.getInstance().isCreatureFromLook(param1);
      }
      
      [Untrusted]
      public function isIncarnation(param1:Number) : Boolean
      {
         return EntitiesLooksManager.getInstance().isIncarnation(param1);
      }
      
      [Untrusted]
      public function isIncarnationFromLook(param1:TiphonEntityLook) : Boolean
      {
         return EntitiesLooksManager.getInstance().isIncarnationFromLook(param1);
      }
      
      [Untrusted]
      public function isCreatureMode() : Boolean
      {
         return EntitiesLooksManager.getInstance().isCreatureMode();
      }
      
      [Untrusted]
      public function getCreatureLook(param1:Number) : TiphonEntityLook
      {
         return EntitiesLooksManager.getInstance().getCreatureLook(param1);
      }
      
      [Untrusted]
      public function getGfxUri(param1:int) : String
      {
         return Atouin.getInstance().options.elementsPath + "/" + Atouin.getInstance().options.pngSubPath + "/" + param1 + "." + Atouin.getInstance().options.mapPictoExtension;
      }
      
      [Untrusted]
      public function encodeToJson(param1:*) : String
      {
         return by.blooddy.crypto.serialization.JSON.encode(param1);
      }
      
      [Untrusted]
      public function decodeJson(param1:String) : *
      {
         return by.blooddy.crypto.serialization.JSON.decode(param1);
      }
      
      [Untrusted]
      public function getObjectsUnderPoint() : Array
      {
         return StageShareManager.stage.getObjectsUnderPoint(PoolsManager.getInstance().getPointPool().checkOut()["renew"](StageShareManager.mouseX,StageShareManager.mouseY));
      }
      
      [Untrusted]
      public function isCharacteristicSpell(param1:SpellWrapper, param2:int, param3:Boolean = false) : Boolean
      {
         var _loc4_:EffectInstance = null;
         var _loc5_:SpellWrapper = null;
         var _loc6_:* = undefined;
         var _loc7_:Boolean = false;
         var _loc8_:* = false;
         if(!param3)
         {
            for(_loc6_ in this._triggeredSpells)
            {
               delete this._triggeredSpells[_loc6_];
            }
         }
         for each(_loc4_ in param1.effects)
         {
            if(param1.typeId != 29 && (_loc4_.effectId != 1109 && DamageUtil.TARGET_HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc4_.effectId) == -1))
            {
               if(_loc4_.effectId == 1160 || _loc4_.effectId == 792 || _loc4_.effectId == 793 || _loc4_.effectId == 400)
               {
                  _loc5_ = SpellWrapper.create(_loc4_.parameter0 as uint,_loc4_.parameter1 as int);
                  if(!this._triggeredSpells[_loc5_.spellId] && _loc5_.spellId != param1.spellId)
                  {
                     this._triggeredSpells[_loc5_.spellId] = true;
                     _loc7_ = this.isCharacteristicSpell(_loc5_,param2,true);
                     if(_loc7_)
                     {
                        return true;
                     }
                  }
                  else
                  {
                     delete this._triggeredSpells[_loc5_.spellId];
                  }
               }
               else
               {
                  if(param2 == BoostableCharacteristicEnum.BOOSTABLE_CHARAC_VITALITY && (_loc4_.effectId == 90 || DamageUtil.HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc4_.effectId) != -1))
                  {
                     return true;
                  }
                  if(DamageUtil.HEALING_EFFECTS_IDS.indexOf(_loc4_.effectId) != -1 && (_loc4_.effectId != 90 && param2 == BoostableCharacteristicEnum.BOOSTABLE_CHARAC_INTELLIGENCE))
                  {
                     return true;
                  }
                  if(DamageUtil.HP_BASED_DAMAGE_EFFECTS_IDS.indexOf(_loc4_.effectId) == -1 && DamageUtil.ERODED_HP_BASED_DAMAGE_EFFETS_IDS.indexOf(_loc4_.effectId) == -1 && DamageUtil.HEALING_EFFECTS_IDS.indexOf(_loc4_.effectId) == -1 && _loc4_.category == DamageUtil.DAMAGE_EFFECT_CATEGORY)
                  {
                     _loc8_ = false;
                     switch(param2)
                     {
                        case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_STRENGTH:
                           _loc8_ = Boolean(_loc4_.effectElement == DamageUtil.NEUTRAL_ELEMENT || _loc4_.effectElement == DamageUtil.EARTH_ELEMENT);
                           break;
                        case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_INTELLIGENCE:
                           _loc8_ = _loc4_.effectElement == DamageUtil.FIRE_ELEMENT;
                           break;
                        case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_CHANCE:
                           _loc8_ = _loc4_.effectElement == DamageUtil.WATER_ELEMENT;
                           break;
                        case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_AGILITY:
                           _loc8_ = _loc4_.effectElement == DamageUtil.AIR_ELEMENT;
                     }
                     if(_loc8_)
                     {
                        return true;
                     }
                  }
               }
            }
         }
         return false;
      }
      
      [Untrusted]
      public function getSpellBoost(param1:SpellWrapper, param2:int) : Object
      {
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         var _loc9_:SpellDamage = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:EffectDamage = null;
         var _loc13_:EffectDamage = null;
         var _loc14_:EffectDamage = null;
         var _loc15_:EffectDamage = null;
         var _loc3_:Object = new Object();
         var _loc6_:SpellDamageInfo = SpellDamageInfo.fromCurrentPlayer(param1);
         var _loc7_:Vector.<SpellDamage> = new Vector.<SpellDamage>(0);
         var _loc8_:Array = new Array();
         _loc5_ = I18n.getUiText("ui.common.damageShort");
         switch(param2)
         {
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_STRENGTH:
               _loc8_ = ["casterStrength"];
               _loc7_.push(_loc6_.neutralDamage,_loc6_.earthDamage);
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_VITALITY:
               _loc6_.casterLifePoints = _loc6_.casterBaseMaxLifePoints / 2;
               _loc8_ = ["casterLifePoints","casterBaseMaxLifePoints","casterMaxLifePoints"];
               if(!_loc6_.isHealingSpell)
               {
                  _loc7_.push(_loc6_.hpBasedDamage);
               }
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_CHANCE:
               _loc8_ = ["casterChance"];
               _loc7_.push(_loc6_.waterDamage);
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_AGILITY:
               _loc8_ = ["casterAgility"];
               _loc7_.push(_loc6_.airDamage);
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_INTELLIGENCE:
               _loc8_ = ["casterIntelligence"];
               if(!_loc6_.isHealingSpell)
               {
                  _loc7_.push(_loc6_.fireDamage);
               }
         }
         if(!_loc6_.isHealingSpell)
         {
            _loc12_ = new EffectDamage();
            _loc13_ = new EffectDamage();
            for each(_loc9_ in _loc7_)
            {
               _loc12_.addDamage(DamageUtil.computeDamage(_loc9_,_loc6_,1,false,true,true,true,true,true));
            }
            _loc10_ = _loc12_.minDamage + _loc12_.maxDamage + _loc12_.minCriticalDamage + _loc12_.maxCriticalDamage;
            this.increaseStats(_loc6_,param2,_loc8_);
            for each(_loc9_ in _loc7_)
            {
               _loc13_.addDamage(DamageUtil.computeDamage(_loc9_,_loc6_,1,false,true,true,true,true,true));
            }
            _loc11_ = _loc13_.minDamage + _loc13_.maxDamage + _loc13_.minCriticalDamage + _loc13_.maxCriticalDamage;
         }
         else
         {
            _loc5_ = I18n.getUiText("ui.stats.healBonus");
            this.computeLifePointsBasedOnLifePercent(_loc6_,_loc6_.casterBaseMaxLifePoints);
            _loc14_ = DamageUtil.getHealEffectDamage(_loc6_);
            _loc10_ = _loc14_.minLifePointsAdded + _loc14_.maxLifePointsAdded + _loc14_.minCriticalLifePointsAdded + _loc14_.maxCriticalLifePointsAdded + _loc14_.lifePointsAddedBasedOnLifePercent + _loc14_.criticalLifePointsAddedBasedOnLifePercent;
            this.increaseStats(_loc6_,param2,_loc8_);
            this.computeLifePointsBasedOnLifePercent(_loc6_,_loc6_.casterBaseMaxLifePoints);
            _loc15_ = DamageUtil.getHealEffectDamage(_loc6_);
            _loc11_ = _loc15_.minLifePointsAdded + _loc15_.maxLifePointsAdded + _loc15_.minCriticalLifePointsAdded + _loc15_.maxCriticalLifePointsAdded + _loc15_.lifePointsAddedBasedOnLifePercent + _loc15_.criticalLifePointsAddedBasedOnLifePercent;
         }
         _loc4_ = _loc11_ > 0 && _loc10_ > 0?Number((_loc11_ / _loc10_ - 1) * 100):Number(0);
         _loc3_.value = Math.round(_loc4_ * 100) / 100;
         _loc3_.type = _loc5_;
         return _loc3_;
      }
      
      private function increaseStats(param1:SpellDamageInfo, param2:int, param3:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         var _loc6_:Breed = Breed.getBreedById(PlayedCharacterManager.getInstance().infos.breed);
         switch(param2)
         {
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_VITALITY:
               _loc8_ = _loc6_.statsPointsForVitality;
               _loc7_ = PlayedCharacterManager.getInstance().characteristics.vitality.base;
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_WISDOM:
               _loc8_ = _loc6_..statsPointsForWisdom;
               _loc7_ = PlayedCharacterManager.getInstance().characteristics.vitality.base;
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_STRENGTH:
               _loc8_ = _loc6_.statsPointsForStrength;
               _loc7_ = PlayedCharacterManager.getInstance().characteristics.vitality.base;
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_INTELLIGENCE:
               _loc8_ = _loc6_.statsPointsForIntelligence;
               _loc7_ = PlayedCharacterManager.getInstance().characteristics.vitality.base;
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_CHANCE:
               _loc8_ = _loc6_.statsPointsForChance;
               _loc7_ = PlayedCharacterManager.getInstance().characteristics.vitality.base;
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_AGILITY:
               _loc8_ = _loc6_.statsPointsForAgility;
               _loc7_ = PlayedCharacterManager.getInstance().characteristics.vitality.base;
         }
         _loc9_ = 0;
         while(_loc9_ < _loc8_.length)
         {
            if(_loc7_ >= _loc8_[_loc9_][0] && (_loc9_ + 1 >= _loc8_.length || _loc7_ < _loc8_[_loc9_ + 1][0]))
            {
               _loc5_ = _loc8_[_loc9_].length == 3?uint(_loc8_[_loc9_][2]):uint(1);
               break;
            }
            _loc9_++;
         }
         for each(_loc4_ in param3)
         {
            param1[_loc4_] = param1[_loc4_] + _loc5_;
         }
      }
      
      private function computeLifePointsBasedOnLifePercent(param1:SpellDamageInfo, param2:uint) : void
      {
         var _loc3_:EffectDamage = null;
         var _loc4_:EffectInstance = null;
         for each(_loc4_ in param1.spellEffects)
         {
            if(_loc4_.effectId == 90)
            {
               for each(_loc3_ in param1.heal.effectDamages)
               {
                  if(_loc3_.effectId == 90 && _loc3_.criticalLifePointsAddedBasedOnLifePercent == 0 && _loc3_.spellEffectOrder == param1.spellEffects.indexOf(_loc4_))
                  {
                     _loc3_.lifePointsAddedBasedOnLifePercent = (_loc4_ as EffectInstanceDice).diceNum * param2 / 100;
                     break;
                  }
               }
               break;
            }
         }
         for each(_loc4_ in param1.spellCriticalEffects)
         {
            if(_loc4_.effectId == 90)
            {
               for each(_loc3_ in param1.heal.effectDamages)
               {
                  if(_loc3_.effectId == 90 && _loc3_.lifePointsAddedBasedOnLifePercent == 0 && _loc3_.spellEffectOrder == param1.spellCriticalEffects.indexOf(_loc4_))
                  {
                     _loc3_.criticalLifePointsAddedBasedOnLifePercent = (_loc4_ as EffectInstanceDice).diceNum * param2 / 100;
                     break;
                  }
               }
               break;
            }
         }
      }
   }
}
