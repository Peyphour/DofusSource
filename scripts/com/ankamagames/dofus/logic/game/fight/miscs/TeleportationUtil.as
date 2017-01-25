package com.ankamagames.dofus.logic.game.fight.miscs
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.FightersStateManager;
   import com.ankamagames.dofus.logic.game.fight.types.FightTeleportation;
   import com.ankamagames.dofus.logic.game.fight.types.FighterStatus;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.utils.getQualifiedClassName;
   
   public class TeleportationUtil
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(TeleportationUtil));
      
      private static const TELEPORTATION_EFFECTS:Array = [1100,1104,1105,1106,8];
       
      
      public function TeleportationUtil()
      {
         super();
      }
      
      public static function getFightTeleportation(param1:Vector.<Number>, param2:Vector.<EffectInstance>, param3:Number, param4:int, param5:uint, param6:Number = 0) : FightTeleportation
      {
         var _loc7_:FightTeleportation = null;
         var _loc8_:EffectInstance = null;
         var _loc10_:Number = NaN;
         var _loc11_:GameFightFighterInformations = null;
         var _loc12_:AnimatedCharacter = null;
         var _loc13_:Boolean = false;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc18_:MapPoint = null;
         var _loc19_:uint = 0;
         var _loc9_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc16_:uint = param2.length;
         var _loc17_:int = param4;
         _loc14_ = 0;
         while(_loc14_ < _loc16_)
         {
            _loc8_ = param2[_loc14_];
            if(_loc8_.effectId == ActionIdConverter.ACTION_CHARACTER_GET_PULLED)
            {
               _loc18_ = MapPoint.fromCellId(_loc17_);
               _loc19_ = _loc18_.advancedOrientationTo(MapPoint.fromCellId(param5));
               _loc15_ = 0;
               while(_loc15_ < _loc8_.parameter0)
               {
                  _loc18_ = _loc18_.getNearestCellInDirection(_loc19_);
                  if(_loc18_ && !PushUtil.isBlockingCell(_loc18_.cellId,-1,false))
                  {
                     _loc17_ = _loc18_.cellId;
                     _loc15_++;
                     continue;
                  }
                  break;
               }
            }
            if(TELEPORTATION_EFFECTS.indexOf(_loc8_.effectId) != -1)
            {
               if(!_loc7_)
               {
                  _loc7_ = new FightTeleportation(_loc8_.effectId,param3,_loc17_,param5);
               }
               else
               {
                  _loc7_.multipleEffects = true;
               }
               for each(_loc10_ in param1)
               {
                  _loc11_ = _loc9_.entitiesFrame.getEntityInfos(_loc10_) as GameFightFighterInformations;
                  _loc12_ = DofusEntities.getEntity(_loc10_) as AnimatedCharacter;
                  _loc13_ = _loc10_ == param3 || _loc10_ == param6;
                  if(_loc11_ && _loc11_.alive && _loc12_ && _loc12_.displayed && (_loc8_.targetMask.indexOf("C") != -1 && _loc13_ || _loc8_.targetMask.indexOf("O") != -1 && _loc10_ == param6 || DamageUtil.verifySpellEffectZone(_loc10_,_loc8_,param5,_loc17_)) && DofusEntities.getEntity(_loc10_) && canTeleport(_loc11_.contextualId) && _loc7_.targets.indexOf(_loc10_) == -1 && DamageUtil.verifySpellEffectMask(param3,_loc10_,_loc8_,param5,param6) && DamageUtil.verifyEffectTrigger(param3,_loc10_,param2,_loc8_,false,_loc8_.triggers,param5) && !(param5 == _loc11_.disposition.cellId && (_loc8_.effectId == 1104 || _loc8_.effectId == 1106)))
                  {
                     _loc7_.targets.push(_loc10_);
                  }
               }
            }
            _loc14_++;
         }
         if(_loc7_)
         {
            if(_loc7_.targets.length == 0 && _loc7_.effectId == 1104 && canTeleport(param3))
            {
               _loc7_.targets.push(param3);
            }
            _loc7_.allTargets = _loc7_.targets.length == param1.length;
         }
         return _loc7_;
      }
      
      public static function canTeleport(param1:Number) : Boolean
      {
         var _loc5_:Monster = null;
         var _loc2_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc3_:GameFightFighterInformations = _loc2_.entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations;
         if(_loc3_ is GameFightMonsterInformations)
         {
            _loc5_ = Monster.getMonsterById((_loc3_ as GameFightMonsterInformations).creatureGenericId);
            if(!_loc5_.canSwitchPos)
            {
               return false;
            }
         }
         var _loc4_:FighterStatus = FightersStateManager.getInstance().getStatus(param1);
         return !_loc4_.cantBeMoved;
      }
      
      public static function hasTeleportation(param1:SpellWrapper) : Boolean
      {
         var _loc2_:EffectInstance = null;
         for each(_loc2_ in param1.effects)
         {
            if(TELEPORTATION_EFFECTS.indexOf(_loc2_.effectId) != -1)
            {
               return true;
            }
         }
         return false;
      }
   }
}
