package com.ankamagames.jerakine.logger.targets
{
   import com.ankamagames.jerakine.logger.LogEvent;
   import com.ankamagames.jerakine.logger.LogLevel;
   
   public class TraceTarget extends AbstractTarget
   {
       
      
      public function TraceTarget()
      {
         super();
      }
      
      override public function logEvent(param1:LogEvent) : void
      {
         trace("[" + LogLevel.getString(param1.level) + "] " + param1.message);
      }
   }
}
