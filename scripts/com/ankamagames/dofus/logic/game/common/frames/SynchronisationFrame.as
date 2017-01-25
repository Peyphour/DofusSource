package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.actions.ResetGameAction;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.messages.game.basic.SequenceNumberMessage;
   import com.ankamagames.dofus.network.messages.game.basic.SequenceNumberRequestMessage;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class SynchronisationFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SynchronisationFrame));
      
      private static const STEP_TIME:uint = 2000;
       
      
      private var _synchroStepByServer:Dictionary;
      
      private var _creationTimeFlash:uint;
      
      private var _creationTimeOs:uint;
      
      private var _timerSpeedHack:Timer;
      
      private var _timeToTest:Timer;
      
      public function SynchronisationFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function pushed() : Boolean
      {
         this._synchroStepByServer = new Dictionary();
         this._timeToTest = new Timer(30000,1);
         this._timeToTest.addEventListener(TimerEvent.TIMER_COMPLETE,this.checkSpeedHack);
         this._timeToTest.start();
         this._timerSpeedHack = new Timer(10000,1);
         this._timerSpeedHack.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         return true;
      }
      
      public function resetSynchroStepByServer(param1:String) : void
      {
         this._synchroStepByServer[param1] = 0;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:SequenceNumberRequestMessage = null;
         var _loc3_:SequenceNumberMessage = null;
         switch(true)
         {
            case param1 is SequenceNumberRequestMessage:
               _loc2_ = param1 as SequenceNumberRequestMessage;
               if(!this._synchroStepByServer[_loc2_.sourceConnection])
               {
                  this._synchroStepByServer[_loc2_.sourceConnection] = 0;
               }
               this._synchroStepByServer[_loc2_.sourceConnection] = this._synchroStepByServer[_loc2_.sourceConnection] + 1;
               _loc3_ = new SequenceNumberMessage();
               _loc3_.initSequenceNumberMessage(this._synchroStepByServer[_loc2_.sourceConnection]);
               ConnectionsHandler.getConnection().send(_loc3_,_loc2_.sourceConnection);
               return true;
            default:
               return false;
         }
      }
      
      private function checkSpeedHack(param1:TimerEvent) : void
      {
         this._timeToTest.stop();
         this._creationTimeFlash = getTimer();
         this._creationTimeOs = new Date().time;
         this._timerSpeedHack.start();
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         this._timerSpeedHack.stop();
         var _loc2_:uint = getTimer() - this._creationTimeFlash;
         var _loc3_:uint = new Date().time - this._creationTimeOs;
         if(_loc2_ > _loc3_ + STEP_TIME)
         {
            _log.error("This account is cheating : flash=" + _loc2_ + ", os=" + _loc3_ + ", diff= flash:" + _loc2_ + " / os:" + _loc3_);
            if(BuildInfos.BUILD_TYPE != BuildTypeEnum.DEBUG)
            {
               Kernel.getWorker().process(ResetGameAction.create(I18n.getUiText("ui.error.speedHack")));
            }
            else
            {
               _log.fatal("Reset du jeu annulé mais on sait bien que tu cheat");
            }
         }
         this._timeToTest.start();
      }
      
      public function pulled() : Boolean
      {
         this._timerSpeedHack.stop();
         this._timerSpeedHack.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this._timerSpeedHack = null;
         this._timeToTest.stop();
         this._timeToTest.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         this._timeToTest = null;
         return true;
      }
   }
}
