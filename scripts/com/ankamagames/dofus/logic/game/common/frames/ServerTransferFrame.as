package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionType;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.KoliseumMessageRouter;
   import com.ankamagames.dofus.network.messages.connection.SelectedServerDataMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AuthenticationTicketAcceptedMessage;
   import com.ankamagames.dofus.network.messages.game.approach.AuthenticationTicketMessage;
   import com.ankamagames.dofus.network.messages.game.approach.HelloGameMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedForceMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedForceReadyMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharacterSelectedSuccessMessage;
   import com.ankamagames.dofus.network.messages.game.character.choice.CharactersListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextCreateRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.arena.GameRolePlayArenaSwitchToFightServerMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.arena.GameRolePlayArenaSwitchToGameServerMessage;
   import com.ankamagames.dofus.network.messages.game.initialization.CharacterLoadingCompleteMessage;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.messages.RegisteringFrame;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class ServerTransferFrame extends RegisteringFrame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ServerTransferFrame));
       
      
      private var _newServerLoginTicket:String;
      
      private var _originePlayerId:Number;
      
      private var _lastResultMsg:GameFightEndMessage;
      
      public function ServerTransferFrame()
      {
         super();
         _priority = Priority.HIGHEST;
      }
      
      override public function pushed() : Boolean
      {
         return true;
      }
      
      override public function pulled() : Boolean
      {
         return true;
      }
      
      override protected function registerMessages() : void
      {
         register(SelectedServerDataMessage,this.onSelectedServerDataMessage);
         register(HelloGameMessage,this.onHelloGameMessage);
         register(AuthenticationTicketAcceptedMessage,this.onAuthenticationTicketAcceptedMessage);
         register(CharacterSelectedForceMessage,this.onCharacterSelectedForceMessage);
         register(CharacterSelectedSuccessMessage,this.onCharacterSelectedSuccessMessage);
         register(CharacterLoadingCompleteMessage,this.onCharacterLoadingCompleteMessage);
         register(GameRolePlayArenaSwitchToFightServerMessage,this.onGameRolePlayArenaSwitchToFightServerMessage);
         register(GameRolePlayArenaSwitchToGameServerMessage,this.onGameRolePlayArenaSwitchToGameServerMessage);
         register(GameFightEndMessage,this.onGameFightEndMessage);
      }
      
      protected function getConnectionType(param1:Message) : String
      {
         return ConnectionsHandler.getConnection().getConnectionId(param1);
      }
      
      private function onCharacterSelectedForceMessage(param1:CharacterSelectedForceMessage) : void
      {
         ConnectionsHandler.getConnection().send(new CharacterSelectedForceReadyMessage());
      }
      
      private function onCharacterSelectedSuccessMessage(param1:CharacterSelectedSuccessMessage) : void
      {
         PlayedCharacterManager.getInstance().infos = param1.infos;
      }
      
      private function onHelloGameMessage(param1:HelloGameMessage) : Boolean
      {
         var _loc2_:String = XmlConfig.getInstance().getEntry("config.lang.current");
         var _loc3_:AuthenticationTicketMessage = new AuthenticationTicketMessage();
         _loc3_.initAuthenticationTicketMessage(_loc2_,this._newServerLoginTicket);
         switch(this.getConnectionType(param1))
         {
            case ConnectionType.TO_KOLI_SERVER:
               ConnectionsHandler.getConnection().messageRouter = new KoliseumMessageRouter();
               break;
            case ConnectionType.TO_GAME_SERVER:
               ConnectionsHandler.getConnection().messageRouter = null;
         }
         ConnectionsHandler.getConnection().send(_loc3_);
         return true;
      }
      
      private function onAuthenticationTicketAcceptedMessage(param1:AuthenticationTicketAcceptedMessage) : Boolean
      {
         var _loc2_:CharactersListRequestMessage = null;
         switch(this.getConnectionType(param1))
         {
            case ConnectionType.TO_KOLI_SERVER:
               _loc2_ = new CharactersListRequestMessage();
               _loc2_.initCharactersListRequestMessage();
               ConnectionsHandler.getConnection().send(_loc2_);
               return true;
            default:
               return false;
         }
      }
      
      private function onCharacterLoadingCompleteMessage(param1:CharacterLoadingCompleteMessage) : Boolean
      {
         var _loc2_:GameContextCreateRequestMessage = null;
         switch(this.getConnectionType(param1))
         {
            case ConnectionType.TO_KOLI_SERVER:
               _loc2_ = new GameContextCreateRequestMessage();
               _loc2_.initGameContextCreateRequestMessage();
               ConnectionsHandler.getConnection().send(_loc2_);
               return true;
            default:
               return false;
         }
      }
      
      private function onSelectedServerDataMessage(param1:SelectedServerDataMessage) : Boolean
      {
         this._newServerLoginTicket = AuthentificationManager.getInstance().decodeWithAES(param1.ticket).toString();
         ConnectionsHandler.connectToKoliServer(param1.address,param1.port);
         return true;
      }
      
      private function onGameRolePlayArenaSwitchToFightServerMessage(param1:GameRolePlayArenaSwitchToFightServerMessage) : Boolean
      {
         if(!ConnectionsHandler.getConnection().getSubConnection(ConnectionType.TO_KOLI_SERVER))
         {
            this._originePlayerId = PlayedCharacterManager.getInstance().id;
         }
         this._newServerLoginTicket = AuthentificationManager.getInstance().decodeWithAES(param1.ticket).toString();
         ConnectionsHandler.connectToKoliServer(param1.address,param1.port);
         return true;
      }
      
      private function onGameRolePlayArenaSwitchToGameServerMessage(param1:GameRolePlayArenaSwitchToGameServerMessage) : Boolean
      {
         var _loc2_:SynchronisationFrame = Kernel.getWorker().getFrame(SynchronisationFrame) as SynchronisationFrame;
         _loc2_.resetSynchroStepByServer(ConnectionType.TO_KOLI_SERVER);
         ConnectionsHandler.getConnection().close(ConnectionType.TO_KOLI_SERVER);
         ConnectionsHandler.getConnection().messageRouter = null;
         return true;
      }
      
      private function onGameFightEndMessage(param1:GameFightEndMessage) : void
      {
         this._lastResultMsg = param1;
      }
   }
}
