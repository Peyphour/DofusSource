package com.ankamagames.dofus.misc.stats
{
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.network.messages.common.basic.AggregateStatMessage;
   import com.ankamagames.dofus.network.messages.common.basic.AggregateStatWithDataMessage;
   import com.ankamagames.dofus.network.messages.common.basic.BasicStatMessage;
   import com.ankamagames.dofus.network.messages.common.basic.BasicStatWithDataMessage;
   import com.ankamagames.dofus.network.types.common.basic.StatisticData;
   import com.ankamagames.dofus.network.types.common.basic.StatisticDataBoolean;
   import com.ankamagames.dofus.network.types.common.basic.StatisticDataByte;
   import com.ankamagames.dofus.network.types.common.basic.StatisticDataInt;
   import com.ankamagames.dofus.network.types.common.basic.StatisticDataShort;
   import com.ankamagames.dofus.network.types.common.basic.StatisticDataString;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class StatsAction
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(StatsAction));
      
      private static var _actions:Dictionary = new Dictionary();
      
      private static var _pendingActions:Vector.<StatsAction> = new Vector.<StatsAction>(0);
       
      
      private var _id:uint;
      
      private var _timestamp:Number;
      
      private var _persistent:Boolean;
      
      private var _aggregate:Boolean;
      
      private var _startTime:uint;
      
      private var _started:Boolean;
      
      private var _paramsAssoc:Dictionary;
      
      private var _params:Vector.<StatisticData>;
      
      public function StatsAction(param1:uint, param2:Boolean, param3:Boolean)
      {
         super();
         this._id = param1;
         this._persistent = param2;
         this._aggregate = param3;
         this._paramsAssoc = new Dictionary();
         this._params = new Vector.<StatisticData>(0);
      }
      
      public static function get(param1:uint, param2:Boolean = false, param3:Boolean = false) : StatsAction
      {
         if(!_actions[param1])
         {
            _actions[param1] = new StatsAction(param1,param2,param3);
         }
         return _actions[param1];
      }
      
      public static function exists(param1:uint) : Boolean
      {
         return _actions[param1];
      }
      
      public static function deletePendingActions() : void
      {
         _pendingActions.length = 0;
      }
      
      public static function sendPendingActions() : void
      {
         var _loc1_:StatsAction = null;
         for each(_loc1_ in _pendingActions)
         {
            _loc1_.send();
         }
         _pendingActions.length = 0;
      }
      
      public function start() : void
      {
         var _loc1_:Number = NaN;
         if(!this._started)
         {
            if(!this._persistent)
            {
               this._timestamp = TimeManager.getInstance().getTimestamp();
               this._startTime = getTimer();
            }
            else
            {
               _loc1_ = StatisticsManager.getInstance().getActionTimestamp(this._id);
               if(isNaN(_loc1_))
               {
                  _loc1_ = TimeManager.getInstance().getTimestamp();
                  StatisticsManager.getInstance().saveActionTimestamp(this._id,_loc1_);
               }
               this._timestamp = _loc1_;
            }
         }
         this._started = true;
      }
      
      public function restart() : void
      {
         this._started = false;
         this.start();
      }
      
      public function cancel() : void
      {
         delete _actions[this._id];
      }
      
      public function updateTimestamp() : void
      {
         this._timestamp = TimeManager.getInstance().getTimestamp();
         if(this._persistent)
         {
            StatisticsManager.getInstance().saveActionTimestamp(this._id,this._timestamp);
         }
      }
      
      public function addParam(param1:String, param2:uint) : void
      {
         var _loc3_:StatisticData = null;
         switch(param2)
         {
            case StatisticDataTypeEnum.BOOLEAN:
               _loc3_ = new StatisticDataBoolean();
               break;
            case StatisticDataTypeEnum.BYTE:
               _loc3_ = new StatisticDataByte();
               break;
            case StatisticDataTypeEnum.SHORT:
               _loc3_ = new StatisticDataShort();
               break;
            case StatisticDataTypeEnum.INTEGER:
               _loc3_ = new StatisticDataInt();
               break;
            case StatisticDataTypeEnum.STRING:
               _loc3_ = new StatisticDataString();
         }
         this._paramsAssoc[param1] = _loc3_;
         this._params.push(_loc3_);
      }
      
      public function setParam(param1:String, param2:*) : void
      {
         if(this._paramsAssoc[param1])
         {
            this._paramsAssoc[param1].value = param2;
         }
      }
      
      public function send() : void
      {
         var _loc2_:INetworkMessage = null;
         var _loc1_:Number = !this._persistent?Number(getTimer() - this._startTime):Number(TimeManager.getInstance().getTimestamp() - this._timestamp);
         if(StatisticsManager.getInstance().statsEnabled && StatisticsManager.getInstance().isConnected())
         {
            if(!this._aggregate)
            {
               if(this._params.length == 0)
               {
                  _loc2_ = new BasicStatMessage();
                  (_loc2_ as BasicStatMessage).initBasicStatMessage(_loc1_,this._id);
               }
               else
               {
                  _loc2_ = new BasicStatWithDataMessage();
                  (_loc2_ as BasicStatWithDataMessage).initBasicStatWithDataMessage(_loc1_,this._id,this._params);
               }
            }
            else if(this._params.length == 0)
            {
               _loc2_ = new AggregateStatMessage();
               (_loc2_ as AggregateStatMessage).initAggregateStatMessage(this._id);
            }
            else
            {
               _loc2_ = new AggregateStatWithDataMessage();
               (_loc2_ as AggregateStatWithDataMessage).initAggregateStatWithDataMessage(this._id,this._params);
            }
            ConnectionsHandler.getConnection().send(_loc2_);
         }
         else
         {
            _pendingActions.push(this);
         }
         if(this._persistent)
         {
            StatisticsManager.getInstance().deleteTimeStamp(this._id);
         }
         delete _actions[this._id];
      }
   }
}
