package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class FightEnteringStateStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _fighterId:Number;
      
      private var _stateId:int;
      
      private var _durationString:String;
      
      public function FightEnteringStateStep(param1:Number, param2:int, param3:String)
      {
         super();
         this._fighterId = param1;
         this._stateId = param2;
         this._durationString = param3;
      }
      
      public function get stepType() : String
      {
         return "enteringState";
      }
      
      override public function start() : void
      {
         if(!SpellState.getSpellStateById(this._stateId).isSilent)
         {
            FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_ENTERING_STATE,[this._fighterId,this._stateId,this._durationString],this._fighterId,-1,false,2);
         }
         executeCallbacks();
      }
   }
}
