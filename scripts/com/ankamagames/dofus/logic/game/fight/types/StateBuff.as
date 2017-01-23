package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.FightersStateManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostStateEffect;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.enums.EntityIconEnum;
   import com.ankamagames.dofus.types.enums.SpellStateIconVisibilityMaskEnum;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   public class StateBuff extends BasicBuff
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(StateBuff));
       
      
      private var _statName:String;
      
      public var stateId:int;
      
      public var delta:int;
      
      public function StateBuff(param1:FightTemporaryBoostStateEffect = null, param2:CastingSpell = null, param3:uint = 0)
      {
         if(param1)
         {
            super(param1,param2,param3,param1.stateId,null,null);
            this._statName = ActionIdConverter.getActionStatName(param3);
            this.stateId = param1.stateId;
            this.delta = param1.delta;
         }
      }
      
      override public function get type() : String
      {
         return "StateBuff";
      }
      
      public function get statName() : String
      {
         return this._statName;
      }
      
      public function get isSilent() : Boolean
      {
         return SpellState.getSpellStateById(this.stateId).isSilent;
      }
      
      override public function onApplyed() : void
      {
         this.addBuffState();
         SpellWrapper.refreshAllPlayerSpellHolder(targetId);
         super.onApplyed();
      }
      
      override public function onRemoved() : void
      {
         if(this.delta > 0)
         {
            this.removeBuffState();
            SpellWrapper.refreshAllPlayerSpellHolder(targetId);
         }
         super.onRemoved();
      }
      
      override public function clone(param1:int = 0) : BasicBuff
      {
         var _loc2_:StateBuff = new StateBuff();
         _loc2_._statName = this._statName;
         _loc2_.stateId = this.stateId;
         _loc2_.id = uid;
         _loc2_.uid = uid;
         _loc2_.actionId = actionId;
         _loc2_.targetId = targetId;
         _loc2_.castingSpell = castingSpell;
         _loc2_.duration = duration;
         _loc2_.dispelable = dispelable;
         _loc2_.source = source;
         _loc2_.aliveSource = aliveSource;
         _loc2_.parentBoostUid = parentBoostUid;
         _loc2_.initParam(param1,param2,param3);
         return _loc2_;
      }
      
      private function addBuffState() : void
      {
         var _loc1_:Boolean = FightersStateManager.getInstance().hasState(targetId,this.stateId);
         FightersStateManager.getInstance().addStateOnTarget(targetId,this.stateId,this.delta);
         var _loc2_:Boolean = FightersStateManager.getInstance().hasState(targetId,this.stateId);
         if(!_loc1_ && _loc2_)
         {
            this.addStateIcon();
         }
         else if(_loc1_ && !_loc2_)
         {
            this.removeStateIcon();
         }
      }
      
      private function removeBuffState() : void
      {
         var _loc1_:Boolean = FightersStateManager.getInstance().hasState(targetId,this.stateId);
         FightersStateManager.getInstance().removeStateOnTarget(targetId,this.stateId,this.delta);
         var _loc2_:Boolean = FightersStateManager.getInstance().hasState(targetId,this.stateId);
         var _loc3_:Boolean = false;
         var _loc4_:FightBattleFrame = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame;
         if(_loc4_ && !_loc4_.executingSequence && _loc4_.deadFightersList.indexOf(targetId) == -1 && !this.isSilent)
         {
            _loc3_ = true;
         }
         if(_loc1_ && !_loc2_)
         {
            this.removeStateIcon();
            if(_loc3_)
            {
               FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_LEAVING_STATE,[targetId,this.stateId],targetId,-1,false,2);
            }
         }
         else if(!_loc1_ && _loc2_)
         {
            this.addStateIcon();
            if(_loc3_)
            {
               FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_ENTERING_STATE,[targetId,this.stateId],targetId,-1,false,2);
            }
         }
      }
      
      private function addStateIcon() : void
      {
         var _loc1_:SpellState = SpellState.getSpellStateById(this.stateId);
         var _loc2_:String = _loc1_.icon;
         if(!_loc2_ || _loc2_ == "")
         {
            return;
         }
         var _loc3_:Boolean = this.displayIconForThisPlayer(_loc1_.iconVisibilityMask);
         if(_loc3_)
         {
            FightEntitiesFrame.getCurrentInstance().addEntityIcon(targetId,_loc2_,EntityIconEnum.FIGHT_STATE_CATEGORY);
            FightEntitiesFrame.getCurrentInstance().forceIconUpdate(targetId);
         }
      }
      
      private function removeStateIcon() : void
      {
         var _loc1_:SpellState = SpellState.getSpellStateById(this.stateId);
         var _loc2_:String = _loc1_.icon;
         if(!_loc2_ || _loc2_ == "")
         {
            return;
         }
         var _loc3_:Boolean = this.displayIconForThisPlayer(_loc1_.iconVisibilityMask);
         if(_loc3_)
         {
            FightEntitiesFrame.getCurrentInstance().removeIcon(targetId,_loc2_);
         }
      }
      
      private function displayIconForThisPlayer(param1:int) : Boolean
      {
         var _loc3_:GameFightFighterInformations = null;
         var _loc5_:GameFightFighterInformations = null;
         var _loc6_:int = 0;
         var _loc7_:GameFightFighterInformations = null;
         var _loc8_:GameFightFighterInformations = null;
         var _loc2_:Boolean = false;
         var _loc4_:Number = PlayedCharacterManager.getInstance().id;
         switch(param1)
         {
            case SpellStateIconVisibilityMaskEnum.ALL_VISIBILITY:
               _loc2_ = true;
               break;
            case SpellStateIconVisibilityMaskEnum.TARGET_VISIBILITY:
               if(targetId == _loc4_)
               {
                  _loc2_ = true;
               }
               break;
            case SpellStateIconVisibilityMaskEnum.CASTER_VISIBILITY:
               if(!castingSpell)
               {
                  break;
               }
               if(castingSpell.casterId == _loc4_)
               {
                  _loc2_ = true;
               }
               else
               {
                  _loc5_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(castingSpell.casterId) as GameFightFighterInformations;
                  if(!_loc5_)
                  {
                     break;
                  }
                  if(_loc5_.stats.summoner == _loc4_)
                  {
                     _loc2_ = true;
                     break;
                  }
                  _loc6_ = PlayedCharacterManager.getInstance().infos.breed;
                  _loc3_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc4_) as GameFightFighterInformations;
                  if(!_loc3_)
                  {
                     break;
                  }
                  if(_loc5_ is GameFightCharacterInformations)
                  {
                     if(_loc5_.teamId == _loc3_.teamId && (_loc5_ as GameFightCharacterInformations).breed == _loc6_)
                     {
                        _loc2_ = true;
                        break;
                     }
                  }
                  else
                  {
                     _loc7_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc5_.stats.summoner) as GameFightFighterInformations;
                     if(_loc7_ is GameFightCharacterInformations)
                     {
                        if(_loc7_.teamId == _loc3_.teamId && (_loc7_ as GameFightCharacterInformations).breed == _loc6_)
                        {
                           _loc2_ = true;
                           break;
                        }
                     }
                  }
               }
               break;
            case SpellStateIconVisibilityMaskEnum.CASTER_ALLIES_VISIBILITY:
               if(!castingSpell)
               {
                  break;
               }
               if(castingSpell.casterId == _loc4_)
               {
                  _loc2_ = true;
               }
               else
               {
                  _loc8_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(castingSpell.casterId) as GameFightFighterInformations;
                  if(_loc8_ && _loc8_.stats.summoner == _loc4_)
                  {
                     _loc2_ = true;
                     break;
                  }
                  _loc3_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc4_) as GameFightFighterInformations;
                  if(!_loc3_)
                  {
                     break;
                  }
                  if(_loc8_.teamId == _loc3_.teamId)
                  {
                     _loc2_ = true;
                  }
               }
               break;
         }
         return _loc2_;
      }
   }
}
