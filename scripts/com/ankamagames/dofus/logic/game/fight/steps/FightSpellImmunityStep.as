package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class FightSpellImmunityStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _fighterId:Number;
      
      public function FightSpellImmunityStep(param1:Number)
      {
         super();
         this._fighterId = param1;
      }
      
      public function get stepType() : String
      {
         return "spellImmunity";
      }
      
      override public function start() : void
      {
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_SPELL_IMMUNITY,[this._fighterId],0,castingSpellId);
         executeCallbacks();
      }
   }
}
