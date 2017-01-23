package com.ankamagames.berilia.managers
{
   import com.ankamagames.berilia.BeriliaConstants;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.types.Version;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class UiPerformanceManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UiPerformanceManager));
      
      private static const DATASTORE_CATEGORY_STATS:String = "uiStats";
      
      private static const LASTSUBMISSIONVERSION_KEY_STATS:String = "lastSubmissionClientVersion";
      
      private static const REQUIRED_TOTAL_UI_BEFORE_SUBMISSION:uint = 24;
      
      private static var _singleton:UiPerformanceManager;
       
      
      private var _uiLoadStats:Object;
      
      private var _alreadyOpenedUis:Dictionary;
      
      private var _currentVersion:Version;
      
      private var _hasToCollectStats:Boolean;
      
      public function UiPerformanceManager()
      {
         super();
         this._uiLoadStats = StoreDataManager.getInstance().getSetData(BeriliaConstants.DATASTORE_UI_STATS,DATASTORE_CATEGORY_STATS,new Object());
         this._alreadyOpenedUis = new Dictionary();
         this._hasToCollectStats = false;
      }
      
      public static function getInstance() : UiPerformanceManager
      {
         if(!_singleton)
         {
            _singleton = new UiPerformanceManager();
         }
         return _singleton;
      }
      
      public function set currentVersion(param1:Version) : void
      {
         this._currentVersion = param1;
         var _loc2_:Object = this._uiLoadStats[LASTSUBMISSIONVERSION_KEY_STATS];
         if(_loc2_ && (_loc2_.major != this._currentVersion.major && _loc2_.minor != this._currentVersion.minor))
         {
            StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_UI_STATS,DATASTORE_CATEGORY_STATS,new Object());
            this._hasToCollectStats = true;
         }
         else if(!_loc2_)
         {
            this._hasToCollectStats = true;
         }
         else
         {
            this._hasToCollectStats = false;
         }
      }
      
      public function reset() : void
      {
         this._alreadyOpenedUis = new Dictionary();
      }
      
      public function saveUiLoadStats(param1:String, param2:Object) : void
      {
         var _loc4_:* = null;
         var _loc5_:* = null;
         if(!this._hasToCollectStats)
         {
            return;
         }
         if(!param1)
         {
            _log.error("Can\'t save UI stats without an UI name!");
            return;
         }
         var _loc3_:int = param1.toLowerCase().indexOf(".xml");
         if(_loc3_ != -1)
         {
            param1 = param1.substring(param1.lastIndexOf("/") + 1,_loc3_);
         }
         if(param1.indexOf("tooltip") != -1)
         {
            return;
         }
         if(!this._uiLoadStats.stats)
         {
            this._uiLoadStats.stats = new Object();
         }
         if(this._alreadyOpenedUis.hasOwnProperty(param1) == false)
         {
            _loc4_ = param1 + "_first";
         }
         else
         {
            _loc4_ = param1;
         }
         if(!this._uiLoadStats.stats[_loc4_])
         {
            this._uiLoadStats.stats[_loc4_] = new Object();
         }
         for(_loc5_ in param2)
         {
            if(!this._uiLoadStats.stats[_loc4_][_loc5_])
            {
               this._uiLoadStats.stats[_loc4_][_loc5_] = [param2[_loc5_]];
            }
            else
            {
               this._uiLoadStats.stats[_loc4_][_loc5_].push(param2[_loc5_]);
            }
         }
         this._alreadyOpenedUis[param1] = true;
         StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_UI_STATS,DATASTORE_CATEGORY_STATS,this._uiLoadStats);
      }
      
      public function get averageUiLoadStats() : Object
      {
         var _loc2_:Array = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc1_:Object = new Object();
         if(this._uiLoadStats.hasOwnProperty("stats"))
         {
            for(_loc3_ in this._uiLoadStats.stats)
            {
               for(_loc4_ in this._uiLoadStats.stats[_loc3_])
               {
                  _loc2_ = this._uiLoadStats.stats[_loc3_][_loc4_];
                  _loc5_ = 0;
                  _loc6_ = 0;
                  while(_loc6_ < _loc2_.length)
                  {
                     _loc5_ = _loc5_ + _loc2_[_loc6_];
                     _loc6_++;
                  }
                  _loc5_ = _loc5_ / _loc2_.length;
                  _loc1_["ui_" + _loc3_ + "_" + _loc4_] = _loc5_;
               }
            }
         }
         return _loc1_;
      }
      
      public function get needUiLoadStatsSubmission() : Boolean
      {
         var _loc2_:* = null;
         var _loc1_:uint = 0;
         for(_loc2_ in this._uiLoadStats.stats)
         {
            if(_loc2_.indexOf("_first") != -1)
            {
               _loc1_++;
            }
         }
         return this._hasToCollectStats && _loc1_ >= REQUIRED_TOTAL_UI_BEFORE_SUBMISSION;
      }
      
      public function markCurrentVersionAsUploaded() : void
      {
         this._uiLoadStats[LASTSUBMISSIONVERSION_KEY_STATS] = {
            "major":this._currentVersion.major,
            "minor":this._currentVersion.minor
         };
         StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_UI_STATS,DATASTORE_CATEGORY_STATS,this._uiLoadStats);
      }
   }
}
