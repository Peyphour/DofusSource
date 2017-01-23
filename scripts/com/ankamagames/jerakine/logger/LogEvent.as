package com.ankamagames.jerakine.logger
{
   import flash.events.Event;
   
   public class LogEvent extends Event
   {
      
      public static const LOG_EVENT:String = "logEvent";
       
      
      public var message:String;
      
      public var level:uint;
      
      public var category:String;
      
      public var timestamp:Date;
      
      public var stackTrace:String;
      
      public function LogEvent(param1:String = null, param2:String = null, param3:uint = 0, param4:Date = null, param5:String = "")
      {
         var _loc6_:String = null;
         var _loc7_:Array = null;
         super(LOG_EVENT,false,false);
         this.category = param1;
         this.message = param2;
         this.level = param3;
         this.timestamp = !!param4?param4:new Date();
         this.stackTrace = param5;
         if(!param5 && (param3 == LogLevel.ERROR || param3 == LogLevel.FATAL || param3 == LogLevel.WARN || param3 == LogLevel.DEBUG))
         {
            _loc6_ = new Error().getStackTrace();
            if(_loc6_ && _loc6_.length > 0)
            {
               _loc7_ = _loc6_.split("\n");
               if(_loc7_ && _loc7_.length > 5)
               {
                  _loc7_.splice(0,5);
                  _loc6_ = _loc7_.join("\n");
                  this.stackTrace = _loc6_;
               }
            }
         }
      }
      
      public function get formattedTimestamp() : String
      {
         var _loc1_:String = this.timestamp.toTimeString().split(" ")[0];
         var _loc2_:String = this.timestamp.milliseconds.toString();
         while(_loc2_.length < 3)
         {
            _loc2_ = "0" + _loc2_;
         }
         _loc1_ = _loc1_ + (":" + _loc2_);
         return _loc1_;
      }
      
      override public function clone() : Event
      {
         return new LogEvent(this.category,this.message,this.level,this.timestamp);
      }
   }
}
