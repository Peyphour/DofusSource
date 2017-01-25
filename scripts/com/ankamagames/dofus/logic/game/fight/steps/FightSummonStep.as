package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.logic.game.fight.types.StateBuff;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import flash.display.Sprite;
   
   public class FightSummonStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _summonerId:Number;
      
      private var _summonInfos:GameFightFighterInformations;
      
      public function FightSummonStep(param1:Number, param2:GameFightFighterInformations)
      {
         super();
         this._summonerId = param1;
         this._summonInfos = param2;
      }
      
      public function get stepType() : String
      {
         return "summon";
      }
      
      override public function start() : void
      {
         var _loc3_:Array = null;
         var _loc4_:BasicBuff = null;
         var _loc5_:GameFightFighterInformations = null;
         var _loc1_:Sprite = DofusEntities.getEntity(this._summonInfos.contextualId) as Sprite;
         if(_loc1_)
         {
            _loc1_.visible = true;
         }
         SpellWrapper.refreshAllPlayerSpellHolder(this._summonerId);
         var _loc2_:FightBattleFrame = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame;
         if(_loc2_ && _loc2_.deadFightersList.indexOf(this._summonInfos.contextualId) != -1)
         {
            _loc2_.deadFightersList.splice(_loc2_.deadFightersList.indexOf(this._summonInfos.contextualId),1);
            _loc3_ = BuffManager.getInstance().getAllBuff(this._summonInfos.contextualId);
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_ is StateBuff)
               {
                  BuffManager.getInstance().updateBuff(_loc4_);
               }
            }
         }
         if(this._summonInfos.contextualId == PlayedCharacterManager.getInstance().id)
         {
            _loc5_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._summonInfos.contextualId) as GameFightFighterInformations;
            if(!_loc5_)
            {
               super.executeCallbacks();
               return;
            }
            CurrentPlayedFighterManager.getInstance().getSpellCastManager().resetInitialCooldown(true);
            _loc5_.stats.lifePoints = this._summonInfos.stats.lifePoints;
            if(PlayedCharacterManager.getInstance().id == this._summonInfos.contextualId)
            {
               PlayedCharacterManager.getInstance().characteristics.lifePoints = _loc5_.stats.lifePoints;
            }
         }
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_SUMMONED,[this._summonerId,this._summonInfos.contextualId],this._summonInfos.contextualId,castingSpellId);
         executeCallbacks();
      }
   }
}
