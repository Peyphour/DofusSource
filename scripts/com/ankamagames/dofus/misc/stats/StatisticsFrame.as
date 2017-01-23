package com.ankamagames.dofus.misc.stats
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.Dictionary;
   
   public class StatisticsFrame implements Frame
   {
       
      
      private var _framesStats:Dictionary;
      
      public function StatisticsFrame(param1:Dictionary)
      {
         super();
         this._framesStats = param1;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:IStatsClass = null;
         for each(_loc2_ in this._framesStats)
         {
            _loc2_.process(param1);
         }
         return false;
      }
      
      public function get priority() : int
      {
         return Priority.LOG;
      }
   }
}
