package com.ankamagames.dofus.misc.interClient
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.events.AsyncErrorEvent;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.events.TimerEvent;
   import flash.net.LocalConnection;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class InterClientSlave
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(InterClientSlave));
       
      
      private var _receiving_lc:LocalConnection;
      
      private var _sending_lc:LocalConnection;
      
      private var _statusTimer:Timer;
      
      private var _waitingFocusMessage:Array;
      
      public var connId:String;
      
      public function InterClientSlave()
      {
         this._waitingFocusMessage = new Array();
         super();
         this._sending_lc = new LocalConnection();
         this._sending_lc.allowDomain("*");
         this._sending_lc.allowInsecureDomain("*");
         this._sending_lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onError);
         this._sending_lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
         this._sending_lc.addEventListener(StatusEvent.STATUS,this.onSendingStatusChange);
         this._receiving_lc = new LocalConnection();
         this._receiving_lc.allowDomain("*");
         this._receiving_lc.allowInsecureDomain("*");
         this._receiving_lc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onError);
         this._receiving_lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onError);
         this._receiving_lc.addEventListener(StatusEvent.STATUS,this.onReceivingStatusChange);
         this._receiving_lc.client = new Object();
         this._receiving_lc.client.pong = this.pong;
         this._receiving_lc.client.updateFocusMessage = this.updateFocusMessage;
         var _loc1_:Boolean = false;
         while(!_loc1_)
         {
            this.connId = "_dofus" + Math.floor(Math.random() * 100000000);
            try
            {
               this._receiving_lc.connect(this.connId);
               _loc1_ = true;
            }
            catch(e:Error)
            {
               continue;
            }
         }
         this._statusTimer = new Timer(10000);
         this._statusTimer.addEventListener(TimerEvent.TIMER,this.onTick);
         this._statusTimer.start();
      }
      
      public function destroy() : void
      {
         this._receiving_lc.close();
         this._statusTimer.stop();
         this._statusTimer.removeEventListener(TimerEvent.TIMER,this.onTick);
      }
      
      public function gainFocus(param1:Number) : void
      {
         var message:String = null;
         var time:Number = param1;
         message = this.connId + "," + time;
         try
         {
            this._sending_lc.send("_dofus","clientGainFocus",message);
            return;
         }
         catch(e:Error)
         {
            _waitingFocusMessage.push(message);
            return;
         }
      }
      
      public function updateFocusMessage(param1:String) : void
      {
         _log.info("Client : " + param1);
         InterClientManager.getInstance().clientListInfo = param1.split(",");
         InterClientManager.getInstance().updateFocusList();
      }
      
      private function pong() : void
      {
      }
      
      private function onError(param1:ErrorEvent) : void
      {
         _log.error(param1.toString());
      }
      
      private function onTick(param1:Event) : void
      {
         this._sending_lc.send("_dofus","ping",this.connId);
      }
      
      private function onSendingStatusChange(param1:StatusEvent) : void
      {
         if(param1.level == "error")
         {
            InterClientManager.getInstance().update();
            while(this._waitingFocusMessage.length)
            {
               this._sending_lc.send("_dofus","clientGainFocus",this._waitingFocusMessage.shift());
            }
         }
      }
      
      private function onReceivingStatusChange(param1:StatusEvent) : void
      {
      }
   }
}
