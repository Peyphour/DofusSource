package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class TimeApi implements IApi
   {
       
      
      private var _module:UiModule;
      
      protected var _log:Logger;
      
      public function TimeApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(TimeApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function getTimestamp() : Number
      {
         return TimeManager.getInstance().getTimestamp();
      }
      
      [Untrusted]
      public function getUtcTimestamp() : Number
      {
         return TimeManager.getInstance().getUtcTimestamp();
      }
      
      [Untrusted]
      public function getClock(param1:Number = 0, param2:Boolean = false, param3:Boolean = false) : String
      {
         return TimeManager.getInstance().formatClock(param1,param2,param3);
      }
      
      [Untrusted]
      public function getClockNumbers() : Object
      {
         var _loc1_:Array = TimeManager.getInstance().getDateFromTime(0);
         return [_loc1_[0],_loc1_[1]];
      }
      
      [Untrusted]
      public function getDate(param1:Number = 0, param2:Boolean = false, param3:Boolean = false) : String
      {
         return TimeManager.getInstance().formatDateIRL(param1,param2,param3);
      }
      
      [Untrusted]
      public function getDofusDate(param1:Number = 0) : String
      {
         return TimeManager.getInstance().formatDateIG(param1);
      }
      
      [Untrusted]
      public function getDofusDay(param1:Number = 0) : int
      {
         return TimeManager.getInstance().getDateIG(param1)[0];
      }
      
      [Untrusted]
      public function getDofusMonth(param1:Number = 0) : String
      {
         return TimeManager.getInstance().getDateIG(param1)[1];
      }
      
      [Untrusted]
      public function getDofusYear(param1:Number = 0) : String
      {
         return TimeManager.getInstance().getDateIG(param1)[2];
      }
      
      [Untrusted]
      public function getDurationTimeSinceEpoch(param1:Number = 0) : Number
      {
         var _loc2_:Date = new Date();
         var _loc3_:Number = _loc2_.getTime() / 1000;
         var _loc4_:Number = TimeManager.getInstance().timezoneOffset / 1000;
         var _loc5_:Number = TimeManager.getInstance().serverTimeLag / 1000;
         return Math.floor(_loc3_ - param1 + _loc4_ - _loc5_);
      }
      
      [Untrusted]
      public function getDuration(param1:Number, param2:Boolean = false) : String
      {
         return TimeManager.getInstance().getDuration(param1,false,param2);
      }
      
      [Untrusted]
      public function getShortDuration(param1:Number, param2:Boolean = false) : String
      {
         return TimeManager.getInstance().getDuration(param1,true,param2);
      }
      
      [Untrusted]
      public function getTimezoneOffset() : Number
      {
         return TimeManager.getInstance().timezoneOffset;
      }
   }
}
