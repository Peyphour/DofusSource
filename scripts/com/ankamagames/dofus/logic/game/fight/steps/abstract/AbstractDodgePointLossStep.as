package com.ankamagames.dofus.logic.game.fight.steps.abstract
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   
   public class AbstractDodgePointLossStep extends AbstractSequencable
   {
       
      
      protected var _fighterId:Number;
      
      protected var _amount:int;
      
      public function AbstractDodgePointLossStep(param1:Number, param2:int)
      {
         super();
         this._fighterId = param1;
         this._amount = param2;
      }
   }
}
