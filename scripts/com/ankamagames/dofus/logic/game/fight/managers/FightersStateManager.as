package com.ankamagames.dofus.logic.game.fight.managers
{
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.logic.game.fight.types.FighterStatus;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class FightersStateManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(FightersStateManager));
      
      private static var _self:FightersStateManager;
       
      
      private var _entityStates:Dictionary;
      
      public function FightersStateManager()
      {
         this._entityStates = new Dictionary();
         super();
      }
      
      public static function getInstance() : FightersStateManager
      {
         if(!_self)
         {
            _self = new FightersStateManager();
         }
         return _self;
      }
      
      public function addStateOnTarget(param1:Number, param2:int, param3:int = 1) : void
      {
         if(!this._entityStates[param1])
         {
            this._entityStates[param1] = new Dictionary();
         }
         if(!this._entityStates[param1][param2])
         {
            this._entityStates[param1][param2] = param3;
         }
         else
         {
            this._entityStates[param1][param2] = this._entityStates[param1][param2] + param3;
         }
      }
      
      public function removeStateOnTarget(param1:Number, param2:int, param3:int = 1) : void
      {
         if(!this._entityStates[param1])
         {
            _log.error("Can\'t find state list for " + param1 + " to remove state");
            return;
         }
         if(this._entityStates[param1][param2])
         {
            this._entityStates[param1][param2] = this._entityStates[param1][param2] - param3;
            if(this._entityStates[param1][param2] == 0)
            {
               delete this._entityStates[param1][param2];
            }
         }
      }
      
      public function hasState(param1:Number, param2:int) : Boolean
      {
         if(!this._entityStates[param1] || !this._entityStates[param1][param2])
         {
            return false;
         }
         return this._entityStates[param1][param2] > 0;
      }
      
      public function getStates(param1:Number) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = new Array();
         if(!this._entityStates[param1])
         {
            return _loc2_;
         }
         for(_loc3_ in this._entityStates[param1])
         {
            if(this._entityStates[param1][_loc3_] > 0)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function getStatus(param1:Number) : FighterStatus
      {
         var _loc3_:* = undefined;
         var _loc4_:SpellState = null;
         var _loc2_:FighterStatus = new FighterStatus();
         for(_loc3_ in this._entityStates[param1])
         {
            _loc4_ = SpellState.getSpellStateById(_loc3_);
            if(_loc4_ && this._entityStates[param1][_loc3_] > 0)
            {
               if(_loc4_.preventsSpellCast)
               {
                  _loc2_.cantUseSpells = true;
               }
               if(_loc4_.preventsFight)
               {
                  _loc2_.cantUseCloseQuarterAttack = true;
               }
               if(_loc4_.cantDealDamage)
               {
                  _loc2_.cantDealDamage = true;
               }
               if(_loc4_.invulnerable)
               {
                  _loc2_.invulnerable = true;
               }
               if(_loc4_.incurable)
               {
                  _loc2_.incurable = true;
               }
               if(_loc4_.cantBeMoved)
               {
                  _loc2_.cantBeMoved = true;
               }
               if(_loc4_.cantBePushed)
               {
                  _loc2_.cantBePushed = true;
               }
               if(_loc4_.cantSwitchPosition)
               {
                  _loc2_.cantSwitchPosition = true;
               }
               if(_loc4_.invulnerableMelee)
               {
                  _loc2_.invulnerableMelee = true;
               }
               if(_loc4_.invulnerableRange)
               {
                  _loc2_.invulnerableRange = true;
               }
            }
         }
         return _loc2_;
      }
      
      public function endFight() : void
      {
         this._entityStates = new Dictionary();
      }
   }
}
