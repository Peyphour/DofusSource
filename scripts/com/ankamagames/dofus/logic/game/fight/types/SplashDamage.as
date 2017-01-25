package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.dofus.datacenter.effects.Effect;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   
   public class SplashDamage
   {
       
      
      private var _spellId:int;
      
      private var _casterId:Number;
      
      private var _targets:Vector.<Number>;
      
      private var _damage:SpellDamage;
      
      private var _effect:EffectInstanceDice;
      
      private var _spellShape:uint;
      
      private var _spellShapeSize:Object;
      
      private var _spellShapeMinSize:Object;
      
      private var _spellShapeEfficiencyPercent:Object;
      
      private var _spellShapeMaxEfficiency:Object;
      
      private var _hasCritical:Boolean;
      
      private var _random:int;
      
      private var _casterCell:int;
      
      public function SplashDamage(param1:int, param2:Number, param3:Vector.<Number>, param4:SpellDamage, param5:EffectInstanceDice, param6:SpellDamageInfo)
      {
         var _loc8_:EffectDamage = null;
         var _loc9_:EffectDamage = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         super();
         this._spellId = param1;
         this._casterId = param2;
         this._targets = param3;
         this._damage = new SpellDamage();
         this._effect = param5;
         var _loc7_:int = Effect.getEffectById(param5.effectId).elementId;
         this._spellShape = param5.rawZone.charCodeAt(0);
         this._spellShapeSize = param5.zoneSize;
         this._spellShapeMinSize = param5.zoneMinSize;
         this._spellShapeEfficiencyPercent = param5.zoneEfficiencyPercent;
         this._spellShapeMaxEfficiency = param5.zoneMaxEfficiency;
         this._random = param5.random > 0?int(param5.random):-1;
         this._casterCell = param6.targetCell;
         for each(_loc8_ in param4.effectDamages)
         {
            for each(_loc8_ in _loc8_.computedEffects)
            {
               if(_loc8_.effectId != ActionIdConverter.ACTION_CHARACTER_SACRIFY || param6.originalTargetsIds.indexOf(param2) == -1)
               {
                  _loc9_ = new EffectDamage(param5.effectId,_loc7_ != -1 && _loc8_.element != -1?int(_loc7_):int(_loc8_.element),_loc8_.random);
                  _loc10_ = param4.minDamage == param4.minErosionDamage?int(_loc8_.minErosionDamage):int(_loc8_.minDamage);
                  _loc11_ = param4.maxDamage == param4.maxErosionDamage?int(_loc8_.maxErosionDamage):int(_loc8_.maxDamage);
                  _loc12_ = param4.minCriticalDamage == param4.minCriticalErosionDamage?int(_loc8_.minCriticalErosionDamage):int(_loc8_.minCriticalDamage);
                  _loc13_ = param4.maxCriticalDamage == param4.maxCriticalErosionDamage?int(_loc8_.maxCriticalErosionDamage):int(_loc8_.maxCriticalDamage);
                  _loc9_.minDamage = this.getSplashDamage(_loc10_,_loc8_.minDamageList,param5.diceNum);
                  _loc9_.maxDamage = this.getSplashDamage(_loc11_,_loc8_.maxDamageList,param5.diceNum);
                  _loc9_.minCriticalDamage = this.getSplashDamage(_loc12_,_loc8_.minCriticalDamageList,param5.diceNum);
                  _loc9_.maxCriticalDamage = this.getSplashDamage(_loc13_,_loc8_.maxCriticalDamageList,param5.diceNum);
                  _loc9_.hasCritical = _loc8_.hasCritical;
                  this._damage.addEffectDamage(_loc9_);
               }
            }
         }
         this._damage.hasCriticalDamage = param4.hasCriticalDamage;
         this._damage.updateDamage();
      }
      
      public function get spellId() : int
      {
         return this._spellId;
      }
      
      public function get casterId() : Number
      {
         return this._casterId;
      }
      
      public function get targets() : Vector.<Number>
      {
         return this._targets;
      }
      
      public function get damage() : SpellDamage
      {
         return this._damage;
      }
      
      public function get effect() : EffectInstanceDice
      {
         return this._effect;
      }
      
      public function get spellShape() : uint
      {
         return this._spellShape;
      }
      
      public function get spellShapeSize() : Object
      {
         return this._spellShapeSize;
      }
      
      public function get spellShapeMinSize() : Object
      {
         return this._spellShapeMinSize;
      }
      
      public function get spellShapeEfficiencyPercent() : Object
      {
         return this._spellShapeEfficiencyPercent;
      }
      
      public function get spellShapeMaxEfficiency() : Object
      {
         return this._spellShapeMaxEfficiency;
      }
      
      public function get random() : int
      {
         return this._random;
      }
      
      public function get casterCell() : int
      {
         return this._casterCell;
      }
      
      private function getSplashDamage(param1:int, param2:Vector.<int>, param3:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param2)
         {
            for each(_loc4_ in param2)
            {
               _loc5_ = _loc5_ + _loc4_ * param3 / 100;
            }
         }
         else
         {
            _loc5_ = param1 * param3 / 100;
         }
         return _loc5_;
      }
   }
}
