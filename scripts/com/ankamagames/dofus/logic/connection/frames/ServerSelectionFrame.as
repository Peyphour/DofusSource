package com.ankamagames.dofus.logic.connection.frames
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.net.DisconnectionReasonEnum;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.connection.actions.AcquaintanceSearchAction;
   import com.ankamagames.dofus.logic.connection.actions.ServerSelectionAction;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.connection.managers.GuestModeManager;
   import com.ankamagames.dofus.logic.game.approach.frames.GameServerApproachFrame;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.ServerConnectionErrorEnum;
   import com.ankamagames.dofus.network.enums.ServerStatusEnum;
   import com.ankamagames.dofus.network.messages.connection.SelectedServerDataExtendedMessage;
   import com.ankamagames.dofus.network.messages.connection.SelectedServerDataMessage;
   import com.ankamagames.dofus.network.messages.connection.SelectedServerRefusedMessage;
   import com.ankamagames.dofus.network.messages.connection.ServerSelectionMessage;
   import com.ankamagames.dofus.network.messages.connection.ServerStatusUpdateMessage;
   import com.ankamagames.dofus.network.messages.connection.ServersListMessage;
   import com.ankamagames.dofus.network.messages.connection.search.AcquaintanceSearchErrorMessage;
   import com.ankamagames.dofus.network.messages.connection.search.AcquaintanceSearchMessage;
   import com.ankamagames.dofus.network.messages.connection.search.AcquaintanceServerListMessage;
   import com.ankamagames.dofus.network.types.connection.GameServerInformations;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.messages.Worker;
   import com.ankamagames.jerakine.network.messages.ExpectedSocketClosureMessage;
   import com.ankamagames.jerakine.network.messages.WrongSocketClosureReasonMessage;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class ServerSelectionFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ServerSelectionFrame));
       
      
      private var _serversList:Vector.<GameServerInformations>;
      
      private var _serversUsedList:Vector.<GameServerInformations>;
      
      private var _serversTypeAvailableSlots:Array;
      
      private var _selectedServer:SelectedServerDataMessage;
      
      private var _worker:Worker;
      
      private var _alreadyConnectedToServerId:int = 0;
      
      private var _serverSelectionAction:ServerSelectionAction;
      
      public function ServerSelectionFrame()
      {
         this._serversTypeAvailableSlots = new Array();
         super();
      }
      
      private static function serverDateSortFunction(param1:GameServerInformations, param2:GameServerInformations) : Number
      {
         if(param1.date < param2.date)
         {
            return 1;
         }
         if(param1.date == param2.date)
         {
            return 0;
         }
         return -1;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get usedServers() : Vector.<GameServerInformations>
      {
         return this._serversUsedList;
      }
      
      public function get servers() : Vector.<GameServerInformations>
      {
         return this._serversList;
      }
      
      public function get availableSlotsByServerType() : Array
      {
         return this._serversTypeAvailableSlots;
      }
      
      public function pushed() : Boolean
      {
         this._worker = Kernel.getWorker();
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:ServersListMessage = null;
         var _loc3_:ServerStatusUpdateMessage = null;
         var _loc4_:ServerSelectionAction = null;
         var _loc5_:SelectedServerDataExtendedMessage = null;
         var _loc6_:SelectedServerDataMessage = null;
         var _loc7_:ExpectedSocketClosureMessage = null;
         var _loc8_:AcquaintanceSearchAction = null;
         var _loc9_:AcquaintanceSearchMessage = null;
         var _loc10_:AcquaintanceSearchErrorMessage = null;
         var _loc11_:String = null;
         var _loc12_:AcquaintanceServerListMessage = null;
         var _loc13_:SelectedServerRefusedMessage = null;
         var _loc14_:* = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:Object = null;
         var _loc18_:* = undefined;
         var _loc19_:ServerSelectionMessage = null;
         var _loc20_:* = null;
         var _loc21_:int = 0;
         switch(true)
         {
            case param1 is ServersListMessage:
               _loc2_ = param1 as ServersListMessage;
               PlayerManager.getInstance().server = null;
               this._serversList = _loc2_.servers;
               this._serversList.sort(serverDateSortFunction);
               this._alreadyConnectedToServerId = _loc2_.alreadyConnectedToServerId;
               if(!Berilia.getInstance().uiList["CharacterHeader"])
               {
                  KernelEventsManager.getInstance().processCallback(HookList.AuthenticationTicketAccepted);
               }
               this.broadcastServersListUpdate();
               return true;
            case param1 is ServerStatusUpdateMessage:
               _loc3_ = param1 as ServerStatusUpdateMessage;
               this._serversList.forEach(this.getUpdateServerFunction(_loc3_.server));
               _log.info("Server " + _loc3_.server.id + " status changed to " + _loc3_.server.status + ".");
               this.broadcastServersListUpdate();
               return true;
            case param1 is ServerSelectionAction:
               _loc4_ = param1 as ServerSelectionAction;
               if(this._alreadyConnectedToServerId > 0 && _loc4_.serverId != this._alreadyConnectedToServerId)
               {
                  this._serverSelectionAction = _loc4_;
                  _loc15_ = Server.getServerById(this._alreadyConnectedToServerId).name;
                  _loc16_ = Server.getServerById(_loc4_.serverId).name;
                  _loc17_ = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
                  _loc17_.openPopup(I18n.getUiText("ui.popup.warning"),I18n.getUiText("ui.server.alreadyInFightOnAnotherServer",[_loc15_,_loc16_]),[I18n.getUiText("ui.common.ok"),I18n.getUiText("ui.common.cancel")],[this.onValidServerSelection,this.onCancelServerSelection],this.onValidServerSelection,this.onCancelServerSelection);
                  return true;
               }
               GuestModeManager.getInstance().forceGuestMode = false;
               for each(_loc18_ in this._serversList)
               {
                  if(_loc18_.id == _loc4_.serverId)
                  {
                     if(_loc18_.status == ServerStatusEnum.ONLINE)
                     {
                        _loc19_ = new ServerSelectionMessage();
                        _loc19_.initServerSelectionMessage(_loc4_.serverId);
                        ConnectionsHandler.getConnection().send(_loc19_);
                        KernelEventsManager.getInstance().processCallback(HookList.ServerConnectionStarted);
                     }
                     else
                     {
                        _loc20_ = "Status";
                        switch(_loc18_.status)
                        {
                           case ServerStatusEnum.OFFLINE:
                              _loc20_ = _loc20_ + "Offline";
                              break;
                           case ServerStatusEnum.STARTING:
                              _loc20_ = _loc20_ + "Starting";
                              break;
                           case ServerStatusEnum.NOJOIN:
                              _loc20_ = _loc20_ + "Nojoin";
                              break;
                           case ServerStatusEnum.SAVING:
                              _loc20_ = _loc20_ + "Saving";
                              break;
                           case ServerStatusEnum.STOPING:
                              _loc20_ = _loc20_ + "Stoping";
                              break;
                           case ServerStatusEnum.FULL:
                              _loc20_ = _loc20_ + "Full";
                              break;
                           case ServerStatusEnum.STATUS_UNKNOWN:
                           default:
                              _loc20_ = _loc20_ + "Unknown";
                        }
                        KernelEventsManager.getInstance().processCallback(HookList.SelectedServerRefused,_loc18_.id,_loc20_,this.getSelectableServers());
                     }
                  }
               }
               return true;
            case param1 is SelectedServerDataExtendedMessage:
               _loc5_ = param1 as SelectedServerDataExtendedMessage;
               PlayerManager.getInstance().serversList = new Vector.<int>();
               for each(_loc21_ in _loc5_.serverIds)
               {
                  PlayerManager.getInstance().serversList.push(_loc21_);
               }
            case param1 is SelectedServerDataMessage:
               _loc6_ = param1 as SelectedServerDataMessage;
               ConnectionsHandler.connectionGonnaBeClosed(DisconnectionReasonEnum.SWITCHING_TO_GAME_SERVER);
               this._selectedServer = _loc6_;
               AuthentificationManager.getInstance().gameServerTicket = AuthentificationManager.getInstance().decodeWithAES(_loc6_.ticket).toString();
               PlayerManager.getInstance().server = Server.getServerById(_loc6_.serverId);
               return true;
            case param1 is ExpectedSocketClosureMessage:
               _loc7_ = param1 as ExpectedSocketClosureMessage;
               if(_loc7_.reason != DisconnectionReasonEnum.SWITCHING_TO_GAME_SERVER)
               {
                  this._worker.process(new WrongSocketClosureReasonMessage(DisconnectionReasonEnum.SWITCHING_TO_GAME_SERVER,_loc7_.reason));
                  return true;
               }
               this._worker.removeFrame(this);
               this._worker.addFrame(new GameServerApproachFrame());
               ConnectionsHandler.connectToGameServer(this._selectedServer.address,this._selectedServer.port);
               return true;
            case param1 is AcquaintanceSearchAction:
               _loc8_ = param1 as AcquaintanceSearchAction;
               _loc9_ = new AcquaintanceSearchMessage();
               _loc9_.initAcquaintanceSearchMessage(_loc8_.friendName);
               ConnectionsHandler.getConnection().send(_loc9_);
               return true;
            case param1 is AcquaintanceSearchErrorMessage:
               _loc10_ = param1 as AcquaintanceSearchErrorMessage;
               switch(_loc10_.reason)
               {
                  case 1:
                     _loc11_ = "unavailable";
                     break;
                  case 2:
                     _loc11_ = "no_result";
                     break;
                  case 3:
                     _loc11_ = "flood";
                     break;
                  case 0:
                  default:
                     _loc11_ = "unknown";
               }
               KernelEventsManager.getInstance().processCallback(HookList.AcquaintanceSearchError,_loc11_);
               return true;
            case param1 is AcquaintanceServerListMessage:
               _loc12_ = param1 as AcquaintanceServerListMessage;
               KernelEventsManager.getInstance().processCallback(HookList.AcquaintanceServerList,_loc12_.servers);
               return true;
            case param1 is SelectedServerRefusedMessage:
               _loc13_ = param1 as SelectedServerRefusedMessage;
               this._serversList.forEach(this.getUpdateServerStatusFunction(_loc13_.serverId,_loc13_.serverStatus));
               this.broadcastServersListUpdate();
               switch(_loc13_.error)
               {
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_DUE_TO_STATUS:
                     _loc14_ = "Status";
                     switch(_loc13_.serverStatus)
                     {
                        case ServerStatusEnum.OFFLINE:
                           _loc14_ = _loc14_ + "Offline";
                           break;
                        case ServerStatusEnum.STARTING:
                           _loc14_ = _loc14_ + "Starting";
                           break;
                        case ServerStatusEnum.NOJOIN:
                           _loc14_ = _loc14_ + "Nojoin";
                           break;
                        case ServerStatusEnum.SAVING:
                           _loc14_ = _loc14_ + "Saving";
                           break;
                        case ServerStatusEnum.STOPING:
                           _loc14_ = _loc14_ + "Stoping";
                           break;
                        case ServerStatusEnum.FULL:
                           _loc14_ = _loc14_ + "Full";
                           break;
                        case ServerStatusEnum.STATUS_UNKNOWN:
                        default:
                           _loc14_ = _loc14_ + "Unknown";
                     }
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_ACCOUNT_RESTRICTED:
                     _loc14_ = "AccountRestricted";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_COMMUNITY_RESTRICTED:
                     _loc14_ = "CommunityRestricted";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_LOCATION_RESTRICTED:
                     _loc14_ = "LocationRestricted";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_SUBSCRIBERS_ONLY:
                     _loc14_ = "SubscribersOnly";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_REGULAR_PLAYERS_ONLY:
                     _loc14_ = "RegularPlayersOnly";
                     break;
                  case ServerConnectionErrorEnum.SERVER_CONNECTION_ERROR_NO_REASON:
                  default:
                     _loc14_ = "NoReason";
               }
               KernelEventsManager.getInstance().processCallback(HookList.SelectedServerRefused,_loc13_.serverId,_loc14_,this.getSelectableServers());
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         this._serversList = null;
         this._serversUsedList = null;
         this._selectedServer = null;
         this._worker = null;
         return true;
      }
      
      private function getSelectableServers() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._serversList)
         {
            if(_loc2_.status == ServerStatusEnum.ONLINE && _loc2_.isSelectable)
            {
               _loc1_.push(_loc2_.id);
            }
         }
         return _loc1_;
      }
      
      private function broadcastServersListUpdate() : void
      {
         var _loc1_:Object = null;
         this._serversTypeAvailableSlots = new Array();
         this._serversUsedList = new Vector.<GameServerInformations>();
         PlayerManager.getInstance().serversList = new Vector.<int>();
         for each(_loc1_ in this._serversList)
         {
            if(!this._serversTypeAvailableSlots[_loc1_.type])
            {
               this._serversTypeAvailableSlots[_loc1_.type] = 0;
            }
            if(_loc1_.charactersCount < _loc1_.charactersSlots)
            {
               this._serversTypeAvailableSlots[_loc1_.type] = 1;
            }
            if(_loc1_.charactersCount > 0)
            {
               this._serversUsedList.push(_loc1_);
               PlayerManager.getInstance().serversList.push(_loc1_.id);
            }
         }
         KernelEventsManager.getInstance().processCallback(HookList.ServersList,this._serversList);
      }
      
      private function getUpdateServerFunction(param1:GameServerInformations) : Function
      {
         var serverToUpdate:GameServerInformations = param1;
         return function(param1:*, param2:int, param3:Vector.<GameServerInformations>):void
         {
            var _loc4_:* = param1 as GameServerInformations;
            if(serverToUpdate.id == _loc4_.id)
            {
               _loc4_.charactersCount = serverToUpdate.charactersCount;
               _loc4_.completion = serverToUpdate.completion;
               _loc4_.isSelectable = serverToUpdate.isSelectable;
               _loc4_.status = serverToUpdate.status;
            }
         };
      }
      
      private function getUpdateServerStatusFunction(param1:uint, param2:uint) : Function
      {
         var serverId:uint = param1;
         var newStatus:uint = param2;
         return function(param1:*, param2:int, param3:Vector.<GameServerInformations>):void
         {
            var _loc4_:* = param1 as GameServerInformations;
            if(serverId == _loc4_.id)
            {
               _loc4_.status = newStatus;
            }
         };
      }
      
      private function onValidServerSelection() : void
      {
         this._alreadyConnectedToServerId = 0;
         this.process(this._serverSelectionAction);
         this._serverSelectionAction = null;
      }
      
      private function onCancelServerSelection() : void
      {
         KernelEventsManager.getInstance().processCallback(HookList.SelectedServerRefused,this._serverSelectionAction.serverId,"",this.getSelectableServers());
         this._serverSelectionAction = null;
      }
   }
}
