package com.ankamagames.jerakine.logger.targets
{
   import com.ankamagames.jerakine.logger.LogEvent;
   
   public class TemporaryBufferTarget extends AbstractTarget
   {
       
      
      private var _buffer:Array;
      
      public function TemporaryBufferTarget()
      {
         super();
         this._buffer = new Array();
      }
      
      override public function logEvent(param1:LogEvent) : void
      {
         this._buffer.push(param1);
      }
      
      public function getBuffer() : Array
      {
         return this._buffer;
      }
      
      public function clearBuffer() : void
      {
         this._buffer = new Array();
      }
   }
}
