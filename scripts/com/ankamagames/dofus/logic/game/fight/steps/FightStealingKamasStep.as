package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class FightStealingKamasStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _robberId:Number;
      
      private var _victimId:Number;
      
      private var _amount:uint;
      
      public function FightStealingKamasStep(param1:Number, param2:Number, param3:uint)
      {
         super();
         this._robberId = param1;
         this._victimId = param2;
         this._amount = param3;
      }
      
      public function get stepType() : String
      {
         return "stealingKamas";
      }
      
      override public function start() : void
      {
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_STEALING_KAMAS,[this._robberId,this._victimId,this._amount],this._victimId,castingSpellId,false,3,2);
         executeCallbacks();
      }
   }
}
