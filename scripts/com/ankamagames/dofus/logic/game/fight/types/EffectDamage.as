package com.ankamagames.dofus.logic.game.fight.types
{
   import flash.net.registerClassAlias;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class EffectDamage
   {
       
      
      private var _effectId:int;
      
      private var _element:int;
      
      private var _random:int;
      
      private var _duration:int;
      
      private var _boostable:Boolean;
      
      public var computedEffects:Vector.<EffectDamage>;
      
      public var spellEffectOrder:int;
      
      public var efficiencyMultiplier:Number;
      
      public var minDamage:int;
      
      public var minDamageList:Vector.<int>;
      
      public var maxDamage:int;
      
      public var maxDamageList:Vector.<int>;
      
      public var minCriticalDamage:int;
      
      public var minCriticalDamageList:Vector.<int>;
      
      public var maxCriticalDamage:int;
      
      public var maxCriticalDamageList:Vector.<int>;
      
      public var minErosionPercent:int;
      
      public var maxErosionPercent:int;
      
      public var minCriticalErosionPercent:int;
      
      public var maxCriticalErosionPercent:int;
      
      public var minErosionDamage:int;
      
      public var maxErosionDamage:int;
      
      public var minCriticalErosionDamage:int;
      
      public var maxCriticalErosionDamage:int;
      
      public var minBaseDamage:int;
      
      public var minBaseDamageList:Vector.<int>;
      
      public var maxBaseDamage:int;
      
      public var minBaseCriticalDamage:int;
      
      public var maxBaseCriticalDamage:int;
      
      public var minShieldPointsRemoved:int;
      
      public var maxShieldPointsRemoved:int;
      
      public var minCriticalShieldPointsRemoved:int;
      
      public var maxCriticalShieldPointsRemoved:int;
      
      public var minShieldPointsAdded:int;
      
      public var maxShieldPointsAdded:int;
      
      public var minCriticalShieldPointsAdded:int;
      
      public var maxCriticalShieldPointsAdded:int;
      
      public var minLifePointsAdded:int;
      
      public var maxLifePointsAdded:int;
      
      public var minCriticalLifePointsAdded:int;
      
      public var maxCriticalLifePointsAdded:int;
      
      public var lifePointsAddedBasedOnLifePercent:int;
      
      public var criticalLifePointsAddedBasedOnLifePercent:int;
      
      public var hasCritical:Boolean;
      
      public var damageConvertedToHeal:Boolean;
      
      public var lifeSteal:Boolean;
      
      public var damageDistance:int = -1;
      
      public function EffectDamage(param1:int = -1, param2:int = -1, param3:int = -1, param4:int = -1, param5:Boolean = true)
      {
         super();
         this._effectId = param1;
         this._element = param2;
         this._random = param3 <= 0?-1:int(param3);
         this._duration = param4;
         this._boostable = param5;
         this.computedEffects = new Vector.<EffectDamage>(0);
      }
      
      public function get effectId() : int
      {
         return this._effectId;
      }
      
      public function set effectId(param1:int) : void
      {
         this._effectId = param1;
      }
      
      public function get element() : int
      {
         return this._element;
      }
      
      public function set element(param1:int) : void
      {
         this._element = param1;
      }
      
      public function get random() : int
      {
         return this._random;
      }
      
      public function set random(param1:int) : void
      {
         this._random = param1;
      }
      
      public function get duration() : int
      {
         return this._duration;
      }
      
      public function get boostable() : Boolean
      {
         return this._boostable;
      }
      
      public function applyDamageMultiplier(param1:Number) : void
      {
         var _loc2_:EffectDamage = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:Vector.<int> = new Vector.<int>(0);
         for each(_loc2_ in this.computedEffects)
         {
            if(_loc2_.boostable)
            {
               _loc2_.minDamage = _loc2_.minDamage * param1;
               _loc2_.maxDamage = _loc2_.maxDamage * param1;
               _loc2_.minCriticalDamage = _loc2_.minCriticalDamage * param1;
               _loc2_.maxCriticalDamage = _loc2_.maxCriticalDamage * param1;
            }
            else
            {
               _loc3_.push(this.computedEffects.indexOf(_loc2_));
               _loc4_ = _loc4_ + (_loc2_.minDamage * param1 - _loc2_.minDamage);
               _loc5_ = _loc5_ + (_loc2_.maxDamage * param1 - _loc2_.maxDamage);
               _loc6_ = _loc6_ + (_loc2_.minCriticalDamage * param1 - _loc2_.minCriticalDamage);
               _loc7_ = _loc7_ + (_loc2_.maxCriticalDamage * param1 - _loc2_.maxCriticalDamage);
            }
         }
         this.applyTotalDamageMultiplier("minDamage",this.minDamageList,param1,_loc3_,_loc4_);
         this.applyTotalDamageMultiplier("maxDamage",this.maxDamageList,param1,_loc3_,_loc5_);
         this.applyTotalDamageMultiplier("minCriticalDamage",this.minCriticalDamageList,param1,_loc3_,_loc6_);
         this.applyTotalDamageMultiplier("maxCriticalDamage",this.maxCriticalDamageList,param1,_loc3_,_loc7_);
      }
      
      private function applyTotalDamageMultiplier(param1:String, param2:Vector.<int>, param3:Number, param4:Vector.<int>, param5:int) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = !!param2?int(param2.length):0;
         if(_loc7_ > 0)
         {
            this[param1] = 0;
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               if(param4.indexOf(_loc6_) == -1)
               {
                  param2[_loc6_] = param2[_loc6_] * param3;
               }
               this[param1] = this[param1] + param2[_loc6_];
               _loc6_++;
            }
         }
         else
         {
            this[param1] = this[param1] * param3;
            this[param1] = this[param1] - param5;
         }
      }
      
      public function applyHealMultiplier(param1:Number) : void
      {
         var _loc2_:EffectDamage = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         for each(_loc2_ in this.computedEffects)
         {
            if(_loc2_.boostable)
            {
               _loc2_.minLifePointsAdded = _loc2_.minLifePointsAdded * param1;
               _loc2_.maxLifePointsAdded = _loc2_.maxLifePointsAdded * param1;
               _loc2_.minCriticalLifePointsAdded = _loc2_.minCriticalLifePointsAdded * param1;
               _loc2_.maxCriticalLifePointsAdded = _loc2_.maxCriticalLifePointsAdded * param1;
            }
            else
            {
               _loc3_ = _loc3_ + (_loc2_.minLifePointsAdded * param1 - _loc2_.minLifePointsAdded);
               _loc4_ = _loc4_ + (_loc2_.maxLifePointsAdded * param1 - _loc2_.maxLifePointsAdded);
               _loc5_ = _loc5_ + (_loc2_.minCriticalLifePointsAdded * param1 - _loc2_.minCriticalLifePointsAdded);
               _loc6_ = _loc6_ + (_loc2_.maxCriticalLifePointsAdded * param1 - _loc2_.maxCriticalLifePointsAdded);
            }
         }
         this.minLifePointsAdded = this.minLifePointsAdded * param1;
         this.minLifePointsAdded = this.minLifePointsAdded - _loc3_;
         this.maxLifePointsAdded = this.maxLifePointsAdded * param1;
         this.maxLifePointsAdded = this.maxLifePointsAdded - _loc4_;
         this.minCriticalLifePointsAdded = this.minCriticalLifePointsAdded * param1;
         this.minCriticalLifePointsAdded = this.minCriticalLifePointsAdded - _loc5_;
         this.maxCriticalLifePointsAdded = this.maxCriticalLifePointsAdded * param1;
         this.maxCriticalLifePointsAdded = this.maxCriticalLifePointsAdded - _loc6_;
      }
      
      public function convertDamageToHeal() : void
      {
         var _loc1_:EffectDamage = null;
         this.minLifePointsAdded = this.minLifePointsAdded + this.minDamage;
         this.minDamage = 0;
         this.maxLifePointsAdded = this.maxLifePointsAdded + this.maxDamage;
         this.maxDamage = 0;
         this.minCriticalLifePointsAdded = this.minCriticalLifePointsAdded + this.minCriticalDamage;
         this.minCriticalDamage = 0;
         this.maxCriticalLifePointsAdded = this.maxCriticalLifePointsAdded + this.maxCriticalDamage;
         this.maxCriticalDamage = 0;
         if(this.minDamageList)
         {
            this.minDamageList.length = 0;
         }
         if(this.maxDamageList)
         {
            this.maxDamageList.length = 0;
         }
         if(this.minCriticalDamageList)
         {
            this.minCriticalDamageList.length = 0;
         }
         if(this.maxCriticalDamageList)
         {
            this.maxCriticalDamageList.length = 0;
         }
         this.damageConvertedToHeal = true;
         for each(_loc1_ in this.computedEffects)
         {
            _loc1_.convertDamageToHeal();
         }
      }
      
      public function get hasDamage() : Boolean
      {
         return !(this.minDamage == 0 && this.maxDamage == 0 && this.minCriticalDamage == 0 && this.maxCriticalDamage == 0);
      }
      
      public function get hasHeal() : Boolean
      {
         return !(this.minLifePointsAdded == 0 && this.maxLifePointsAdded == 0 && this.minCriticalLifePointsAdded == 0 && this.maxCriticalLifePointsAdded == 0);
      }
      
      public function get hasShield() : Boolean
      {
         return !(this.minShieldPointsAdded == 0 && this.maxShieldPointsAdded == 0 && this.minCriticalShieldPointsAdded == 0 && this.maxCriticalShieldPointsAdded == 0);
      }
      
      public function clone() : *
      {
         var _loc1_:String = getQualifiedClassName(this);
         var _loc2_:Class = this["constructor"];
         registerClassAlias(_loc1_,_loc2_);
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeObject(this);
         _loc3_.position = 0;
         return _loc3_.readObject() as _loc2_;
      }
      
      public function addDamage(param1:EffectDamage) : void
      {
         this.minDamage = this.minDamage + param1.minDamage;
         this.maxDamage = this.maxDamage + param1.maxDamage;
         this.minCriticalDamage = this.minCriticalDamage + param1.minCriticalDamage;
         this.maxCriticalDamage = this.maxCriticalDamage + param1.maxCriticalDamage;
      }
      
      public function addHeal(param1:EffectDamage) : void
      {
         this.minLifePointsAdded = this.minLifePointsAdded + param1.minLifePointsAdded;
         this.maxLifePointsAdded = this.maxLifePointsAdded + param1.maxLifePointsAdded;
         this.minCriticalLifePointsAdded = this.minCriticalLifePointsAdded + param1.minCriticalLifePointsAdded;
         this.maxCriticalLifePointsAdded = this.maxCriticalLifePointsAdded + param1.maxCriticalLifePointsAdded;
      }
      
      public function toString() : String
      {
         return "[Effect id=" + this.effectId + " element=" + this.element + " random=" + this.random + " spellEffectOrder=" + this.spellEffectOrder + " min=" + this.minDamage + " max=" + this.maxDamage + " minCrit=" + this.minCriticalDamage + " maxCrit=" + this.maxCriticalDamage + " minLife=" + this.minLifePointsAdded + " maxLife=" + this.maxLifePointsAdded + " minCritLife=" + this.minCriticalLifePointsAdded + " maxCritLife=" + this.maxCriticalLifePointsAdded + "]";
      }
   }
}
