package com.ankamagames.jerakine.utils.misc
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class Chrono
   {
      
      private static var times:Array = [];
      
      private static var labels:Array = [];
      
      private static var level:int = 0;
      
      private static var indent:String = "";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Chrono));
      
      public static var show_total_time:Boolean = true;
       
      
      public function Chrono()
      {
         super();
      }
      
      public static function start(param1:String = "") : void
      {
         param1 = !!param1.length?param1:"Chrono " + times.length;
         times.push(getTimer());
         labels.push(param1);
         level = level + 1;
         indent = indent + "  ";
      }
      
      public static function stop() : int
      {
         var _loc1_:int = getTimer() - times.pop();
         if(!show_total_time && times.length)
         {
            times[times.length - 1] = times[times.length - 1] - _loc1_;
         }
         level = level - 1;
         indent = indent.slice(0,2 * level + 1);
         return _loc1_;
      }
      
      public static function display(param1:String) : void
      {
         _log.trace("!!" + indent + "TRACE " + param1);
      }
   }
}
