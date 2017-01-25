package com.adobe.air.filesystem
{
   import com.adobe.air.filesystem.events.FileMonitorEvent;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.filesystem.File;
   import flash.utils.Timer;
   
   [Event(name="CREATE",type="com.adobe.air.filesystem.events.FileMonitor")]
   [Event(name="MOVE",type="com.adobe.air.filesystem.events.FileMonitor")]
   [Event(name="CHANGE",type="com.adobe.air.filesystem.events.FileMonitor")]
   public class FileMonitor extends EventDispatcher
   {
      
      public static const DEFAULT_MONITOR_INTERVAL:Number = 1000;
       
      
      private var _interval:Number;
      
      private var timer:Timer;
      
      private var lastModifiedTime:Number;
      
      private var _file:File;
      
      private var fileExists:Boolean = false;
      
      public function FileMonitor(param1:File = null, param2:Number = -1)
      {
         super();
         this.file = param1;
         if(param2 != -1)
         {
            if(param2 < 1000)
            {
               this._interval = 1000;
            }
            else
            {
               this._interval = param2;
            }
         }
         else
         {
            this._interval = DEFAULT_MONITOR_INTERVAL;
         }
      }
      
      private function onTimerEvent(param1:TimerEvent) : void
      {
         var _loc2_:FileMonitorEvent = null;
         var _loc3_:Number = NaN;
         if(this.fileExists != this._file.exists)
         {
            if(this._file.exists)
            {
               _loc2_ = new FileMonitorEvent(FileMonitorEvent.CREATE);
               this.lastModifiedTime = this._file.modificationDate.getTime();
            }
            else
            {
               _loc2_ = new FileMonitorEvent(FileMonitorEvent.MOVE);
               this.unwatch();
            }
            this.fileExists = this._file.exists;
         }
         else
         {
            if(!this._file.exists)
            {
               return;
            }
            _loc3_ = this._file.modificationDate.getTime();
            if(_loc3_ == this.lastModifiedTime)
            {
               return;
            }
            this.lastModifiedTime = _loc3_;
            _loc2_ = new FileMonitorEvent(FileMonitorEvent.CHANGE);
         }
         if(_loc2_)
         {
            _loc2_.file = this._file;
            dispatchEvent(_loc2_);
         }
      }
      
      public function set file(param1:File) : void
      {
         if(this.timer && this.timer.running)
         {
            this.unwatch();
         }
         this._file = param1;
         if(!this._file)
         {
            this.fileExists = false;
            return;
         }
         this.fileExists = this._file.exists;
         if(this.fileExists)
         {
            this.lastModifiedTime = this._file.modificationDate.getTime();
         }
      }
      
      public function watch() : void
      {
         if(!this.file)
         {
            return;
         }
         if(this.timer && this.timer.running)
         {
            return;
         }
         if(!this.timer)
         {
            this.timer = new Timer(this._interval);
            this.timer.addEventListener(TimerEvent.TIMER,this.onTimerEvent,false,0,true);
         }
         this.timer.start();
      }
      
      public function get interval() : Number
      {
         return this._interval;
      }
      
      public function get file() : File
      {
         return this._file;
      }
      
      public function unwatch() : void
      {
         if(!this.timer)
         {
            return;
         }
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerEvent);
      }
   }
}
