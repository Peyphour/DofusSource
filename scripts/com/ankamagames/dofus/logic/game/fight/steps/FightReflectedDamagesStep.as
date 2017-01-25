package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class FightReflectedDamagesStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _fighterId:Number;
      
      public function FightReflectedDamagesStep(param1:Number)
      {
         super();
         this._fighterId = param1;
      }
      
      public function get stepType() : String
      {
         return "reflectedDamages";
      }
      
      override public function start() : void
      {
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_REFLECTED_DAMAGES,[this._fighterId],this._fighterId,castingSpellId);
         executeCallbacks();
      }
   }
}
