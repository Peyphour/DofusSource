package com.ankamagames.dofus.logic.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.messages.common.basic.BasicPongMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicLatencyStatsMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicLatencyStatsRequestMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.IServerConnection;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class LatencyFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(LatencyFrame));
       
      
      public var pingRequested:uint;
      
      public function LatencyFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:BasicPongMessage = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:BasicLatencyStatsRequestMessage = null;
         var _loc6_:IServerConnection = null;
         var _loc7_:BasicLatencyStatsMessage = null;
         switch(true)
         {
            case param1 is BasicPongMessage:
               _loc2_ = param1 as BasicPongMessage;
               if(_loc2_.quiet)
               {
                  return true;
               }
               _loc3_ = getTimer();
               _loc4_ = _loc3_ - this.pingRequested;
               this.pingRequested = 0;
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,"Pong " + _loc4_ + "ms !",ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is BasicLatencyStatsRequestMessage:
               _loc5_ = param1 as BasicLatencyStatsRequestMessage;
               _loc6_ = ConnectionsHandler.getConnection().getSubConnection(_loc5_.sourceConnection);
               _loc7_ = new BasicLatencyStatsMessage();
               _loc7_.initBasicLatencyStatsMessage(Math.min(32767,_loc6_.latencyAvg),_loc6_.latencySamplesCount,_loc6_.latencySamplesMax);
               ConnectionsHandler.getConnection().send(_loc7_,_loc5_.sourceConnection);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
   }
}
