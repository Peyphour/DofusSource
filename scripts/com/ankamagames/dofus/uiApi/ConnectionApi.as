package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.internalDatacenter.servers.ServerWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.connection.frames.ServerSelectionFrame;
   import com.ankamagames.dofus.logic.connection.managers.GuestModeManager;
   import com.ankamagames.dofus.logic.game.approach.frames.GameServerApproachFrame;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.enums.ServerCompletionEnum;
   import com.ankamagames.dofus.network.enums.ServerStatusEnum;
   import com.ankamagames.dofus.network.types.connection.GameServerInformations;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   [Trusted]
   public class ConnectionApi implements IApi
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ConnectionApi));
       
      
      public function ConnectionApi()
      {
         super();
      }
      
      private function get serverSelectionFrame() : ServerSelectionFrame
      {
         return Kernel.getWorker().getFrame(ServerSelectionFrame) as ServerSelectionFrame;
      }
      
      [Untrusted]
      public function getUsedServers() : Vector.<GameServerInformations>
      {
         return this.serverSelectionFrame.usedServers;
      }
      
      [Untrusted]
      public function getServers() : Vector.<GameServerInformations>
      {
         return this.serverSelectionFrame.servers;
      }
      
      [Untrusted]
      public function getAvailableSlotsByServerType() : Array
      {
         return this.serverSelectionFrame.availableSlotsByServerType;
      }
      
      [Untrusted]
      public function hasGuestAccount() : Boolean
      {
         return GuestModeManager.getInstance().hasGuestAccount();
      }
      
      [Untrusted]
      public function isCharacterWaitingForChange(param1:Number) : Boolean
      {
         var _loc2_:GameServerApproachFrame = Kernel.getWorker().getFrame(GameServerApproachFrame) as GameServerApproachFrame;
         if(_loc2_)
         {
            return _loc2_.isCharacterWaitingForChange(param1);
         }
         return false;
      }
      
      [Untrusted]
      public function allowAutoConnectCharacter(param1:Boolean) : void
      {
         PlayerManager.getInstance().allowAutoConnectCharacter = param1;
         PlayerManager.getInstance().autoConnectOfASpecificCharacterId = -1;
      }
      
      [Untrusted]
      public function getAutoChosenServer(param1:int) : GameServerInformations
      {
         var _loc6_:Server = null;
         var _loc7_:GameServerInformations = null;
         var _loc8_:Array = null;
         var _loc2_:Vector.<ServerWrapper> = new Vector.<ServerWrapper>();
         var _loc3_:Vector.<ServerWrapper> = new Vector.<ServerWrapper>();
         var _loc4_:* = BuildInfos.BUILD_TYPE == BuildTypeEnum.RELEASE;
         var _loc5_:int = PlayerManager.getInstance().communityId;
         for each(_loc7_ in this.serverSelectionFrame.servers)
         {
            _loc6_ = Server.getServerById(_loc7_.id);
            if(!_loc6_)
            {
               _log.warn("Missing Server data for serverId " + _loc7_.id);
            }
            else if(_loc4_ && _loc6_.name.indexOf("Test") != -1)
            {
               _log.warn("Ignoring server " + _loc6_.name + " as it\'s a test server");
            }
            else if(_loc6_.gameTypeId == param1 && this.serverIsOnlineAndNotFull(_loc7_))
            {
               if(_loc6_.communityId == _loc5_ || _loc6_.communityId == 1 && _loc5_ == 2)
               {
                  _loc2_.push(ServerWrapper.create(_loc6_,_loc7_));
               }
               else if(_loc6_.communityId == 2)
               {
                  _loc3_.push(ServerWrapper.create(_loc6_,_loc7_));
               }
            }
         }
         _loc8_ = this.getLowestPopulationServers(_loc2_);
         if(_loc8_.length == 0)
         {
            _loc8_ = this.getLowestPopulationServers(_loc3_);
         }
         if(_loc8_.length > 0)
         {
            return _loc8_[Math.floor(Math.random() * _loc8_.length)];
         }
         return null;
      }
      
      private function getLowestPopulationServers(param1:Vector.<ServerWrapper>) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:ServerWrapper = null;
         var _loc2_:Array = new Array();
         if(param1.length > 0)
         {
            param1.sort(ServerWrapper.sortByPopulation);
            _loc3_ = param1[0].server.population.id;
            for each(_loc4_ in param1)
            {
               if(_loc4_.server.population.id == _loc3_)
               {
                  _loc2_.push(_loc4_.serverInfo);
                  continue;
               }
               break;
            }
         }
         return _loc2_;
      }
      
      private function serverIsOnlineAndNotFull(param1:GameServerInformations) : Boolean
      {
         return param1.isSelectable && param1.status == ServerStatusEnum.ONLINE && param1.charactersCount < param1.charactersSlots && param1.completion <= ServerCompletionEnum.COMPLETION_HIGH;
      }
   }
}
