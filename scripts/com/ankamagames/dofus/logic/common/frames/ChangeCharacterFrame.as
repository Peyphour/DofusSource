package com.ankamagames.dofus.logic.common.frames
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.logic.common.actions.ChangeCharacterAction;
   import com.ankamagames.dofus.logic.common.actions.ChangeServerAction;
   import com.ankamagames.dofus.logic.common.actions.DirectSelectionCharacterAction;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationWithSteamAction;
   import com.ankamagames.dofus.logic.connection.actions.LoginValidationWithTicketAction;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   import com.ankamagames.dofus.logic.game.common.frames.QuestFrame;
   import com.ankamagames.dofus.logic.game.common.managers.SteamManager;
   import com.ankamagames.dofus.misc.utils.errormanager.WebServiceDataHandler;
   import com.ankamagames.dofus.network.messages.game.approach.ReloginTokenRequestMessage;
   import com.ankamagames.dofus.network.messages.game.approach.ReloginTokenStatusMessage;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationListMessage;
   import com.ankamagames.dofus.network.messages.subscription.SubscriptionUpdateMessage;
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import flash.utils.getQualifiedClassName;
   
   public class ChangeCharacterFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ChangeCharacterFrame));
       
      
      private var _currentAction:Action;
      
      private var _token:String = "";
      
      public function ChangeCharacterFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return 0;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:DirectSelectionCharacterAction = null;
         var _loc3_:ChangeCharacterAction = null;
         var _loc4_:ReloginTokenStatusMessage = null;
         var _loc5_:NotificationListMessage = null;
         var _loc6_:int = 0;
         var _loc7_:SubscriptionUpdateMessage = null;
         var _loc8_:ReloginTokenRequestMessage = null;
         var _loc9_:LoginValidationWithTicketAction = null;
         var _loc10_:LoginValidationAction = null;
         var _loc11_:LoginValidationAction = null;
         var _loc12_:ReloginTokenRequestMessage = null;
         var _loc13_:LoginValidationWithTicketAction = null;
         var _loc14_:LoginValidationWithSteamAction = null;
         var _loc15_:LoginValidationAction = null;
         var _loc16_:LoginValidationAction = null;
         var _loc17_:ReloginTokenRequestMessage = null;
         var _loc18_:LoginValidationWithTicketAction = null;
         var _loc19_:LoginValidationAction = null;
         var _loc20_:LoginValidationAction = null;
         var _loc21_:int = 0;
         var _loc22_:* = 0;
         var _loc23_:int = 0;
         switch(true)
         {
            case param1 is DirectSelectionCharacterAction:
               _loc2_ = param1 as DirectSelectionCharacterAction;
               if(!this._currentAction)
               {
                  this._currentAction = _loc2_;
                  _loc8_ = new ReloginTokenRequestMessage();
                  _loc8_.initReloginTokenRequestMessage();
                  ConnectionsHandler.getConnection().send(_loc8_);
               }
               else
               {
                  this._currentAction = null;
                  WebServiceDataHandler.getInstance().changeCharacter();
                  PlayerManager.getInstance().allowAutoConnectCharacter = true;
                  PlayerManager.getInstance().autoConnectOfASpecificCharacterId = _loc2_.characterId;
                  if(this._token != "")
                  {
                     _loc9_ = LoginValidationWithTicketAction.create(this._token,true,_loc2_.serverId);
                     AuthentificationManager.getInstance().setValidationAction(_loc9_);
                  }
                  else
                  {
                     _loc10_ = AuthentificationManager.getInstance().loginValidationAction;
                     _loc11_ = LoginValidationAction.create(_loc10_.username,_loc10_.password,true,_loc2_.serverId);
                     AuthentificationManager.getInstance().setValidationAction(_loc11_);
                  }
                  SoundManager.getInstance().manager.removeAllSounds();
                  ConnectionsHandler.closeConnection();
                  Kernel.getWorker().resume();
                  Kernel.getInstance().reset(null,AuthentificationManager.getInstance().canAutoConnectWithToken || !AuthentificationManager.getInstance().tokenMode);
               }
               return true;
            case param1 is ChangeCharacterAction:
               _loc3_ = param1 as ChangeCharacterAction;
               if(!this._currentAction)
               {
                  this._currentAction = _loc3_;
                  _loc12_ = new ReloginTokenRequestMessage();
                  _loc12_.initReloginTokenRequestMessage();
                  ConnectionsHandler.getConnection().send(_loc12_);
               }
               else
               {
                  this._currentAction = null;
                  WebServiceDataHandler.getInstance().changeCharacter();
                  PlayerManager.getInstance().allowAutoConnectCharacter = false;
                  PlayerManager.getInstance().autoConnectOfASpecificCharacterId = -1;
                  if(this._token != "")
                  {
                     _loc13_ = LoginValidationWithTicketAction.create(this._token,true,_loc3_.serverId);
                     AuthentificationManager.getInstance().setValidationAction(_loc13_);
                  }
                  else if(SteamManager.hasSteamApi() && SteamManager.getInstance().isSteamEmbed())
                  {
                     _loc14_ = LoginValidationWithSteamAction.create();
                     AuthentificationManager.getInstance().setValidationAction(_loc14_);
                  }
                  else
                  {
                     _loc15_ = AuthentificationManager.getInstance().loginValidationAction;
                     _loc16_ = LoginValidationAction.create(_loc15_.username,_loc15_.password,true,_loc3_.serverId);
                     AuthentificationManager.getInstance().setValidationAction(_loc16_);
                  }
                  SoundManager.getInstance().manager.removeAllSounds();
                  ConnectionsHandler.closeConnection();
                  Kernel.getWorker().resume();
                  Kernel.getInstance().reset(null,AuthentificationManager.getInstance().canAutoConnectWithToken || !AuthentificationManager.getInstance().tokenMode);
               }
               return true;
            case param1 is ChangeServerAction:
               if(!this._currentAction)
               {
                  this._currentAction = param1 as ChangeServerAction;
                  _loc17_ = new ReloginTokenRequestMessage();
                  _loc17_.initReloginTokenRequestMessage();
                  ConnectionsHandler.getConnection().send(_loc17_);
               }
               else
               {
                  this._currentAction = null;
                  if(this._token != "")
                  {
                     _loc18_ = LoginValidationWithTicketAction.create(this._token,false);
                     AuthentificationManager.getInstance().setValidationAction(_loc18_);
                  }
                  else if(SteamManager.hasSteamApi() && SteamManager.getInstance().isSteamEmbed())
                  {
                     _loc14_ = LoginValidationWithSteamAction.create();
                     AuthentificationManager.getInstance().setValidationAction(_loc14_);
                  }
                  else
                  {
                     _loc19_ = AuthentificationManager.getInstance().loginValidationAction;
                     _loc20_ = LoginValidationAction.create(_loc19_.username,_loc19_.password,false);
                     AuthentificationManager.getInstance().setValidationAction(_loc20_);
                  }
                  ConnectionsHandler.closeConnection();
                  Kernel.getInstance().reset(null,AuthentificationManager.getInstance().canAutoConnectWithToken || !AuthentificationManager.getInstance().tokenMode);
               }
               return true;
            case param1 is ReloginTokenStatusMessage:
               _loc4_ = ReloginTokenStatusMessage(param1);
               if(_loc4_.validToken)
               {
                  this._token = AuthentificationManager.getInstance().decodeWithAES(_loc4_.ticket).toString();
                  AuthentificationManager.getInstance().tokenMode = true;
                  AuthentificationManager.getInstance().nextToken = this._token;
               }
               else
               {
                  this._token = "";
                  AuthentificationManager.getInstance().tokenMode = false;
                  AuthentificationManager.getInstance().nextToken = null;
               }
               this.process(this._currentAction);
               return true;
            case param1 is NotificationListMessage:
               _loc5_ = param1 as NotificationListMessage;
               QuestFrame.notificationList = new Array();
               _loc6_ = _loc5_.flags.length;
               _loc21_ = 0;
               while(_loc21_ < _loc6_)
               {
                  _loc22_ = int(_loc5_.flags[_loc21_]);
                  _loc23_ = 0;
                  while(_loc23_ < 32)
                  {
                     QuestFrame.notificationList[_loc23_ + _loc21_ * 32] = Boolean(_loc22_ & 1);
                     _loc22_ = _loc22_ >> 1;
                     _loc23_++;
                  }
                  _loc21_++;
               }
               return true;
            case param1 is SubscriptionUpdateMessage:
               _loc7_ = param1 as SubscriptionUpdateMessage;
               PlayerManager.getInstance().subscriptionEndDate = _loc7_.timestamp;
               PlayerManager.getInstance().refreshSubscriptionEndDateUpdateTime();
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
