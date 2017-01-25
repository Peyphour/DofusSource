package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class FightReducedDamagesStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _fighterId:Number;
      
      private var _amount:int;
      
      public function FightReducedDamagesStep(param1:Number, param2:int)
      {
         super();
         this._fighterId = param1;
         this._amount = param2;
      }
      
      public function get stepType() : String
      {
         return "reducedDamages";
      }
      
      override public function start() : void
      {
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_REDUCED_DAMAGES,[this._fighterId,this._amount],this._fighterId,castingSpellId);
         executeCallbacks();
      }
   }
}
