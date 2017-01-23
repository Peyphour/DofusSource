package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.berilia.managers.HtmlManager;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.logic.game.fight.miscs.DamageUtil;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import flash.utils.getQualifiedClassName;
   
   public class SpellDamage
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellDamage));
       
      
      public var invulnerableState:Boolean;
      
      public var unhealableState:Boolean;
      
      public var hasCriticalDamage:Boolean;
      
      public var hasCriticalShieldPointsRemoved:Boolean;
      
      public var hasCriticalShieldPointsAdded:Boolean;
      
      public var hasCriticalLifePointsAdded:Boolean;
      
      public var isHealingSpell:Boolean;
      
      public var hasHeal:Boolean;
      
      public var isCriticalHit:Boolean;
      
      public var minimizedEffects:Boolean;
      
      public var maximizedEffects:Boolean;
      
      public var efficiencyMultiplier:Number;
      
      public var targetId:Number = NaN;
      
      private var _effectDamages:Vector.<EffectDamage>;
      
      private var _minDamage:int;
      
      private var _maxDamage:int;
      
      private var _minCriticalDamage:int;
      
      private var _maxCriticalDamage:int;
      
      private var _minShieldPointsRemoved:int;
      
      private var _maxShieldPointsRemoved:int;
      
      private var _minCriticalShieldPointsRemoved:int;
      
      private var _maxCriticalShieldPointsRemoved:int;
      
      private var _minShieldPointsAdded:int;
      
      private var _maxShieldPointsAdded:int;
      
      private var _minCriticalShieldPointsAdded:int;
      
      private var _maxCriticalShieldPointsAdded:int;
      
      public var effectIcons:Array;
      
      public function SpellDamage()
      {
         super();
         this._effectDamages = new Vector.<EffectDamage>();
      }
      
      public function get minDamage() : int
      {
         var _loc1_:EffectDamage = null;
         this._minDamage = 0;
         for each(_loc1_ in this._effectDamages)
         {
            if(_loc1_.random == -1)
            {
               this._minDamage = this._minDamage + _loc1_.minDamage;
            }
         }
         return this._minDamage;
      }
      
      public function set minDamage(param1:int) : void
      {
         this._minDamage = param1;
      }
      
      public function get maxDamage() : int
      {
         var _loc1_:EffectDamage = null;
         this._maxDamage = 0;
         for each(_loc1_ in this._effectDamages)
         {
            if(_loc1_.random == -1)
            {
               this._maxDamage = this._maxDamage + _loc1_.maxDamage;
            }
         }
         return this._maxDamage;
      }
      
      public function set maxDamage(param1:int) : void
      {
         this._maxDamage = param1;
      }
      
      public function get minCriticalDamage() : int
      {
         var _loc1_:EffectDamage = null;
         this._minCriticalDamage = 0;
         for each(_loc1_ in this._effectDamages)
         {
            if(_loc1_.random == -1)
            {
               this._minCriticalDamage = this._minCriticalDamage + _loc1_.minCriticalDamage;
            }
         }
         return this._minCriticalDamage;
      }
      
      public function set minCriticalDamage(param1:int) : void
      {
         this._minCriticalDamage = param1;
      }
      
      public function get maxCriticalDamage() : int
      {
         var _loc1_:EffectDamage = null;
         this._maxCriticalDamage = 0;
         for each(_loc1_ in this._effectDamages)
         {
            if(_loc1_.random == -1)
            {
               this._maxCriticalDamage = this._maxCriticalDamage + _loc1_.maxCriticalDamage;
            }
         }
         return this._maxCriticalDamage;
      }
      
      public function set maxCriticalDamage(param1:int) : void
      {
         this._maxCriticalDamage = param1;
      }
      
      public function get minErosionDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.minErosionDamage;
         }
         return _loc1_;
      }
      
      public function get maxErosionDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.maxErosionDamage;
         }
         return _loc1_;
      }
      
      public function get minCriticalErosionDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.minCriticalErosionDamage;
         }
         return _loc1_;
      }
      
      public function get maxCriticalErosionDamage() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.maxCriticalErosionDamage;
         }
         return _loc1_;
      }
      
      public function get minShieldPointsRemoved() : int
      {
         var _loc1_:EffectDamage = null;
         this._minShieldPointsRemoved = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._minShieldPointsRemoved = this._minShieldPointsRemoved + _loc1_.minShieldPointsRemoved;
         }
         return this._minShieldPointsRemoved;
      }
      
      public function set minShieldPointsRemoved(param1:int) : void
      {
         this._minShieldPointsRemoved = param1;
      }
      
      public function get maxShieldPointsRemoved() : int
      {
         var _loc1_:EffectDamage = null;
         this._maxShieldPointsRemoved = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._maxShieldPointsRemoved = this._maxShieldPointsRemoved + _loc1_.maxShieldPointsRemoved;
         }
         return this._maxShieldPointsRemoved;
      }
      
      public function set maxShieldPointsRemoved(param1:int) : void
      {
         this._maxShieldPointsRemoved = param1;
      }
      
      public function get minCriticalShieldPointsRemoved() : int
      {
         var _loc1_:EffectDamage = null;
         this._minCriticalShieldPointsRemoved = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._minCriticalShieldPointsRemoved = this._minCriticalShieldPointsRemoved + _loc1_.minCriticalShieldPointsRemoved;
         }
         return this._minCriticalShieldPointsRemoved;
      }
      
      public function set minCriticalShieldPointsRemoved(param1:int) : void
      {
         this._minCriticalShieldPointsRemoved = param1;
      }
      
      public function get maxCriticalShieldPointsRemoved() : int
      {
         var _loc1_:EffectDamage = null;
         this._maxCriticalShieldPointsRemoved = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._maxCriticalShieldPointsRemoved = this._maxCriticalShieldPointsRemoved + _loc1_.maxCriticalShieldPointsRemoved;
         }
         return this._maxCriticalShieldPointsRemoved;
      }
      
      public function set maxCriticalShieldPointsRemoved(param1:int) : void
      {
         this._maxCriticalShieldPointsRemoved = param1;
      }
      
      public function get minShieldPointsAdded() : int
      {
         var _loc1_:EffectDamage = null;
         this._minShieldPointsAdded = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._minShieldPointsAdded = this._minShieldPointsAdded + _loc1_.minShieldPointsAdded;
         }
         return this._minShieldPointsAdded;
      }
      
      public function set minShieldPointsAdded(param1:int) : void
      {
         this._minShieldPointsAdded = param1;
      }
      
      public function get maxShieldPointsAdded() : int
      {
         var _loc1_:EffectDamage = null;
         this._maxShieldPointsAdded = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._maxShieldPointsAdded = this._maxShieldPointsAdded + _loc1_.maxShieldPointsAdded;
         }
         return this._maxShieldPointsAdded;
      }
      
      public function set maxShieldPointsAdded(param1:int) : void
      {
         this._maxShieldPointsAdded = param1;
      }
      
      public function get minCriticalShieldPointsAdded() : int
      {
         var _loc1_:EffectDamage = null;
         this._minCriticalShieldPointsAdded = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._minCriticalShieldPointsAdded = this._minCriticalShieldPointsAdded + _loc1_.minCriticalShieldPointsAdded;
         }
         return this._minCriticalShieldPointsAdded;
      }
      
      public function set minCriticalShieldPointsAdded(param1:int) : void
      {
         this._minCriticalShieldPointsAdded = param1;
      }
      
      public function get maxCriticalShieldPointsAdded() : int
      {
         var _loc1_:EffectDamage = null;
         this._maxCriticalShieldPointsAdded = 0;
         for each(_loc1_ in this._effectDamages)
         {
            this._maxCriticalShieldPointsAdded = this._maxCriticalShieldPointsAdded + _loc1_.maxCriticalShieldPointsAdded;
         }
         return this._maxCriticalShieldPointsAdded;
      }
      
      public function set maxCriticalShieldPointsAdded(param1:int) : void
      {
         this._maxCriticalShieldPointsAdded = param1;
      }
      
      public function get minLifePointsAdded() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            if(_loc2_.random == -1)
            {
               _loc1_ = _loc1_ + _loc2_.minLifePointsAdded;
            }
         }
         return _loc1_;
      }
      
      public function get maxLifePointsAdded() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            if(_loc2_.random == -1)
            {
               _loc1_ = _loc1_ + _loc2_.maxLifePointsAdded;
            }
         }
         return _loc1_;
      }
      
      public function get minCriticalLifePointsAdded() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            if(_loc2_.random == -1)
            {
               _loc1_ = _loc1_ + _loc2_.minCriticalLifePointsAdded;
            }
         }
         return _loc1_;
      }
      
      public function get maxCriticalLifePointsAdded() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            if(_loc2_.random == -1)
            {
               _loc1_ = _loc1_ + _loc2_.maxCriticalLifePointsAdded;
            }
         }
         return _loc1_;
      }
      
      public function get lifePointsAddedBasedOnLifePercent() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.lifePointsAddedBasedOnLifePercent;
         }
         return _loc1_;
      }
      
      public function get criticalLifePointsAddedBasedOnLifePercent() : int
      {
         var _loc1_:int = 0;
         var _loc2_:EffectDamage = null;
         for each(_loc2_ in this._effectDamages)
         {
            _loc1_ = _loc1_ + _loc2_.criticalLifePointsAddedBasedOnLifePercent;
         }
         return _loc1_;
      }
      
      public function updateDamage() : void
      {
         this.minDamage;
         this.maxDamage;
         this.minCriticalDamage;
         this.maxCriticalDamage;
         this.minShieldPointsRemoved;
         this.maxShieldPointsRemoved;
         this.minCriticalShieldPointsRemoved;
         this.maxCriticalShieldPointsRemoved;
      }
      
      public function updateShield() : void
      {
         this.minShieldPointsAdded;
         this.maxShieldPointsAdded;
         this.minCriticalShieldPointsAdded;
         this.maxCriticalShieldPointsAdded;
      }
      
      public function addEffectDamage(param1:EffectDamage, param2:uint = 1.0) : void
      {
         this._effectDamages.splice(param2,0,param1);
      }
      
      public function get effectDamages() : Vector.<EffectDamage>
      {
         return this._effectDamages;
      }
      
      public function get hasRandomEffects() : Boolean
      {
         var _loc1_:EffectDamage = null;
         for each(_loc1_ in this._effectDamages)
         {
            if(_loc1_.random > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get random() : int
      {
         var _loc2_:EffectDamage = null;
         var _loc1_:int = -1;
         var _loc3_:Boolean = true;
         for each(_loc2_ in this._effectDamages)
         {
            if(_loc2_.random > 0)
            {
               if(_loc3_)
               {
                  _loc1_ = _loc2_.random;
                  _loc3_ = false;
               }
               else if(_loc2_.random != _loc1_)
               {
                  return -1;
               }
            }
         }
         return _loc1_;
      }
      
      public function get element() : int
      {
         var _loc2_:EffectDamage = null;
         var _loc4_:Boolean = false;
         var _loc1_:int = -1;
         var _loc3_:Boolean = true;
         for each(_loc2_ in this._effectDamages)
         {
            if(_loc2_.element != -1)
            {
               if(_loc3_)
               {
                  _loc1_ = _loc2_.element;
                  _loc3_ = false;
               }
               else if(_loc2_.element != _loc1_)
               {
                  return -1;
               }
            }
            if(_loc2_.effectId == 5)
            {
               _loc4_ = true;
            }
         }
         if(_loc1_ != -1 && _loc4_)
         {
            _loc1_ = -1;
         }
         return _loc1_;
      }
      
      public function get hasDamage() : Boolean
      {
         var _loc1_:EffectDamage = null;
         for each(_loc1_ in this.effectDamages)
         {
            if(_loc1_.hasDamage)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get empty() : Boolean
      {
         var _loc1_:EffectDamage = null;
         for each(_loc1_ in this._effectDamages)
         {
            if(!(_loc1_.effectId == -1 && _loc1_.element == -1 && _loc1_.computedEffects.length == 0 && !_loc1_.hasDamage && !_loc1_.hasHeal && !_loc1_.hasShield))
            {
               return false;
            }
         }
         return true;
      }
      
      private function getElementTextColor(param1:int) : String
      {
         var _loc2_:String = null;
         if(param1 == DamageUtil.UNKNOWN_ELEMENT)
         {
            _loc2_ = "fight.text.multi";
         }
         else
         {
            switch(param1)
            {
               case DamageUtil.NEUTRAL_ELEMENT:
                  _loc2_ = "fight.text.neutral";
                  break;
               case DamageUtil.EARTH_ELEMENT:
                  _loc2_ = "fight.text.earth";
                  break;
               case DamageUtil.FIRE_ELEMENT:
                  _loc2_ = "fight.text.fire";
                  break;
               case DamageUtil.WATER_ELEMENT:
                  _loc2_ = "fight.text.water";
                  break;
               case DamageUtil.AIR_ELEMENT:
                  _loc2_ = "fight.text.air";
            }
         }
         return XmlConfig.getInstance().getEntry("colors." + _loc2_);
      }
      
      private function getEffectString(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:int = 0) : String
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc7_:String = "";
         if(!this.isCriticalHit || this.minimizedEffects)
         {
            if(param1 == param2)
            {
               _loc8_ = String(param2);
            }
            else if(this.maximizedEffects)
            {
               _loc8_ = String(param2);
            }
            else if(this.minimizedEffects)
            {
               _loc8_ = String(param1);
            }
            else
            {
               _loc8_ = param1 + (param2 != 0?" - " + param2:"");
            }
         }
         if(param5 && !this.minimizedEffects)
         {
            if(param3 == param4)
            {
               _loc9_ = String(param4);
            }
            else if(this.maximizedEffects)
            {
               _loc9_ = String(param4);
            }
            else
            {
               _loc9_ = param3 + (param4 != 0?" - " + param4:"");
            }
         }
         if(_loc8_)
         {
            _loc7_ = _loc8_;
         }
         if(_loc9_)
         {
            if(_loc8_ != _loc9_)
            {
               _loc7_ = _loc7_ + (" (" + _loc9_ + ")");
            }
            else
            {
               _loc7_ = _loc9_;
            }
         }
         return param6 > 0?param6 + "% " + _loc7_:_loc7_;
      }
      
      public function toString() : String
      {
         var _loc6_:EffectDamage = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc1_:String = "";
         var _loc2_:String = this.getElementTextColor(this.element);
         var _loc3_:String = "0x9966CC";
         var _loc4_:int = OptionManager.getOptionManager("chat")["channelColor" + ChatActivableChannelsEnum.PSEUDO_CHANNEL_FIGHT_LOG];
         this.effectIcons = new Array();
         var _loc5_:String = SpellState.getSpellStateById(56).name;
         if(this.hasRandomEffects)
         {
            for each(_loc6_ in this._effectDamages)
            {
               _loc7_ = null;
               _loc8_ = _loc6_.damageConvertedToHeal || _loc6_.lifeSteal;
               if(!_loc8_ && this.invulnerableState)
               {
                  if(_loc1_.indexOf(_loc5_) == -1)
                  {
                     this.effectIcons.push(null);
                     _loc7_ = _loc5_;
                     _loc6_.element = this.element;
                  }
                  else
                  {
                     continue;
                  }
               }
               if(!_loc7_ && _loc6_.element != -1)
               {
                  if(_loc8_)
                  {
                     this.effectIcons.push("lifePoints");
                     _loc7_ = this.getEffectString(_loc6_.minLifePointsAdded,_loc6_.maxLifePointsAdded,_loc6_.minCriticalLifePointsAdded,_loc6_.maxCriticalLifePointsAdded,_loc6_.hasCritical,_loc6_.random);
                  }
                  else
                  {
                     this.effectIcons.push(null);
                     _loc7_ = this.getEffectString(_loc6_.minDamage,_loc6_.maxDamage,_loc6_.minCriticalDamage,_loc6_.maxCriticalDamage,_loc6_.hasCritical,_loc6_.random);
                  }
               }
               if(_loc7_)
               {
                  _loc1_ = _loc1_ + (HtmlManager.addTag(_loc7_,HtmlManager.SPAN,{"color":(!_loc8_?this.getElementTextColor(_loc6_.element):_loc4_)}) + "\n");
               }
            }
         }
         else
         {
            _loc9_ = true;
            for each(_loc6_ in this._effectDamages)
            {
               if(!(_loc6_.effectId == -1 && _loc6_.element == -1 && (!_loc6_.hasDamage || _loc6_.computedEffects.length == 0)))
               {
                  _loc10_ = true;
                  if(!_loc6_.damageConvertedToHeal)
                  {
                     _loc9_ = false;
                     break;
                  }
               }
            }
            _loc11_ = _loc10_ && !_loc9_?this.getEffectString(this._minDamage,this._maxDamage,this._minCriticalDamage,this._maxCriticalDamage,this.hasCriticalDamage):"";
            if(_loc11_ != "")
            {
               _loc11_ = !this.invulnerableState?_loc11_:_loc5_;
               this.effectIcons.push(null);
               _loc1_ = _loc1_ + (HtmlManager.addTag(_loc11_,HtmlManager.SPAN,{"color":_loc2_}) + "\n");
            }
            if(!this.isHealingSpell && !this.invulnerableState)
            {
               if(this._minShieldPointsRemoved != 0 && this._maxShieldPointsRemoved != 0)
               {
                  _loc12_ = this.getEffectString(this._minShieldPointsRemoved,this._maxShieldPointsRemoved,this._minCriticalShieldPointsRemoved,this._maxCriticalShieldPointsRemoved,this.hasCriticalShieldPointsRemoved);
               }
               if(_loc12_)
               {
                  this.effectIcons.push(null);
                  _loc1_ = _loc1_ + (HtmlManager.addTag(_loc12_,HtmlManager.SPAN,{"color":_loc3_}) + "\n");
               }
            }
            if(this._minShieldPointsAdded != 0 && this._maxShieldPointsAdded != 0)
            {
               _loc13_ = this.getEffectString(this._minShieldPointsAdded,this._maxShieldPointsAdded,this._minCriticalShieldPointsAdded,this._maxCriticalShieldPointsAdded,this.hasCriticalShieldPointsAdded);
            }
            if(_loc13_)
            {
               this.effectIcons.push(null);
               _loc1_ = _loc1_ + (HtmlManager.addTag("+" + _loc13_,HtmlManager.SPAN,{"color":_loc3_}) + "\n");
            }
            if(this.hasHeal)
            {
               _loc14_ = this.getEffectString(this.minLifePointsAdded,this.maxLifePointsAdded,this.minCriticalLifePointsAdded,this.maxCriticalLifePointsAdded,this.hasCriticalLifePointsAdded);
               if(this.unhealableState)
               {
                  this.effectIcons.push(null);
                  _loc14_ = SpellState.getSpellStateById(76).name;
               }
               else
               {
                  this.effectIcons.push("lifePoints");
               }
               _loc1_ = _loc1_ + HtmlManager.addTag(_loc14_,HtmlManager.SPAN,{"color":_loc4_});
            }
         }
         return _loc1_;
      }
   }
}
