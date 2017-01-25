package com.ankamagames.dofus.logic.game.fight.managers
{
   import com.ankamagames.dofus.logic.game.fight.types.EffectDamage;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamage;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamageInfo;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamageList;
   import flash.utils.Dictionary;
   
   public class SpellDamagesManager
   {
      
      private static var _self:SpellDamagesManager;
       
      
      private var _spellDamages:Dictionary;
      
      public function SpellDamagesManager()
      {
         this._spellDamages = new Dictionary();
         super();
      }
      
      public static function getInstance() : SpellDamagesManager
      {
         if(!_self)
         {
            _self = new SpellDamagesManager();
         }
         return _self;
      }
      
      public function addSpellDamage(param1:SpellDamageInfo, param2:SpellDamage) : void
      {
         var _loc3_:int = 0;
         var _loc4_:EntitySpellDamage = null;
         if(!this._spellDamages[param1.targetId])
         {
            this._spellDamages[param1.targetId] = new Vector.<EntitySpellDamage>();
         }
         if(this._spellDamages[param1.targetId].length > 1)
         {
            for each(_loc4_ in this._spellDamages[param1.targetId])
            {
               if(_loc4_.spellId == param1.spell.id)
               {
                  _loc3_++;
                  if(!param1.damageSharingTargets)
                  {
                     break;
                  }
               }
            }
         }
         if(_loc3_ == 0 || _loc3_ + 1 <= param1.originalTargetsIds.length)
         {
            this._spellDamages[param1.targetId].push(new EntitySpellDamage(param1.spell.id,param2,!!param1.interceptedDamage?true:false));
         }
      }
      
      public function removeSpellDamages(param1:Number) : void
      {
         if(this._spellDamages[param1])
         {
            this._spellDamages[param1].length = 0;
         }
      }
      
      public function hasSpellDamages(param1:Number) : Boolean
      {
         return this._spellDamages[param1] && this._spellDamages[param1].length > 0;
      }
      
      public function getSpellDamages(param1:Number) : Vector.<EntitySpellDamage>
      {
         return this._spellDamages[param1];
      }
      
      public function getSpellDamageBySpellId(param1:Number, param2:int) : EntitySpellDamage
      {
         var _loc3_:EntitySpellDamage = null;
         if(this._spellDamages[param1])
         {
            for each(_loc3_ in this._spellDamages[param1])
            {
               if(_loc3_.spellId == param2)
               {
                  return _loc3_;
               }
            }
         }
         return null;
      }
      
      public function getTotalSpellDamage(param1:Number, param2:Boolean = true) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:SpellDamage = null;
         var _loc5_:EntitySpellDamage = null;
         var _loc6_:EffectDamage = null;
         var _loc7_:Vector.<SpellDamage> = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this._spellDamages[param1] && this._spellDamages[param1].length > 1)
         {
            if(param2)
            {
               _loc3_ = new SpellDamage();
               for each(_loc5_ in this._spellDamages[param1])
               {
                  _loc4_ = _loc5_.spellDamage;
                  for each(_loc6_ in _loc4_.effectDamages)
                  {
                     _loc3_.addEffectDamage(_loc6_);
                  }
                  if(_loc4_.invulnerableState)
                  {
                     _loc3_.invulnerableState = true;
                  }
                  if(_loc4_.unhealableState)
                  {
                     _loc3_.unhealableState = true;
                  }
                  if(_loc4_.hasCriticalDamage)
                  {
                     _loc3_.hasCriticalDamage = true;
                  }
                  if(_loc4_.hasCriticalShieldPointsRemoved)
                  {
                     _loc3_.hasCriticalShieldPointsRemoved = true;
                  }
                  if(_loc4_.hasCriticalLifePointsAdded)
                  {
                     _loc3_.hasCriticalLifePointsAdded = true;
                  }
                  if(_loc4_.isHealingSpell)
                  {
                     _loc3_.isHealingSpell = true;
                  }
                  if(_loc4_.hasHeal)
                  {
                     _loc3_.hasHeal = true;
                  }
                  if(_loc4_.minimizedEffects)
                  {
                     _loc3_.minimizedEffects = true;
                  }
                  if(_loc4_.maximizedEffects)
                  {
                     _loc3_.maximizedEffects = true;
                  }
                  if(_loc4_.isCriticalHit)
                  {
                     _loc3_.isCriticalHit = true;
                  }
               }
               _loc3_.updateDamage();
            }
            else
            {
               _loc7_ = new Vector.<SpellDamage>(0);
               _loc9_ = this._spellDamages[param1].length;
               _loc8_ = 0;
               while(_loc8_ < _loc9_)
               {
                  _loc7_.push(this._spellDamages[param1][_loc8_].spellDamage);
                  _loc8_++;
               }
               _loc3_ = new SpellDamageList(_loc7_);
            }
         }
         else
         {
            _loc3_ = this._spellDamages[param1] && this._spellDamages[param1].length > 0?this._spellDamages[param1][0].spellDamage:null;
         }
         return _loc3_;
      }
   }
}

import com.ankamagames.dofus.logic.game.fight.types.SpellDamage;

class EntitySpellDamage
{
    
   
   public var spellId:int;
   
   public var spellDamage:SpellDamage;
   
   public var interceptedDamage:Boolean;
   
   function EntitySpellDamage(param1:int, param2:SpellDamage, param3:Boolean)
   {
      super();
      this.spellId = param1;
      this.spellDamage = param2;
      this.interceptedDamage = param3;
   }
}
