package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRefreshEntityLookMessage;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class FightDispellSpellStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _fighterId:Number;
      
      private var _spellId:int;
      
      public function FightDispellSpellStep(param1:Number, param2:int)
      {
         super();
         this._fighterId = param1;
         this._spellId = param2;
      }
      
      public function get stepType() : String
      {
         return "dispellSpell";
      }
      
      override public function start() : void
      {
         var _loc2_:BasicBuff = null;
         var _loc4_:FightEntitiesFrame = null;
         var _loc5_:GameFightFighterInformations = null;
         var _loc6_:GameContextRefreshEntityLookMessage = null;
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_SPELL_DISPELLED,[this._fighterId,this._spellId],this._fighterId,castingSpellId);
         var _loc1_:Array = BuffManager.getInstance().getAllBuff(this._fighterId);
         var _loc3_:Boolean = false;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.castingSpell.spell.id == this._spellId && _loc2_.actionId == ActionIdConverter.ACTION_CHARACTER_ADD_APPEARANCE)
            {
               _loc3_ = true;
               break;
            }
         }
         BuffManager.getInstance().dispellSpell(this._fighterId,this._spellId,true);
         if(_loc3_)
         {
            _loc4_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
            _loc5_ = _loc4_.getEntityInfos(this._fighterId) as GameFightFighterInformations;
            _loc6_ = new GameContextRefreshEntityLookMessage();
            _loc6_.initGameContextRefreshEntityLookMessage(this._fighterId,_loc5_.look);
            Kernel.getWorker().getFrame(FightEntitiesFrame).process(_loc6_);
         }
         executeCallbacks();
      }
   }
}
