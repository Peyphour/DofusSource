package com.ankamagames.jerakine.sequencer
{
   public class StartSequenceStep extends AbstractSequencable
   {
       
      
      private var _sequence:ISequencer;
      
      public function StartSequenceStep(param1:ISequencer)
      {
         super();
         this._sequence = param1;
      }
      
      override public function start() : void
      {
         if(this._sequence)
         {
            this._sequence.start();
         }
         executeCallbacks();
      }
   }
}
