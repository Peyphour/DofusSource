package managers
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.datacenter.externalnotifications.ExternalNotification;
   import com.ankamagames.dofus.datacenter.quest.Achievement;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.ExternalNotificationApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.ExchangeTypeEnum;
   import d2enums.BuildTypeEnum;
   import d2enums.ChatActivableChannelsEnum;
   import d2enums.ExchangeReplayStopReasonEnum;
   import d2enums.ExternalNotificationModeEnum;
   import d2enums.ExternalNotificationTypeEnum;
   import d2enums.FightEventEnum;
   import d2enums.FightTypeEnum;
   import d2enums.PvpArenaStepEnum;
   import d2enums.SocialContactCategoryEnum;
   import d2enums.UISoundEnum;
   import d2hooks.AchievementFinished;
   import d2hooks.ArenaRegistrationStatusUpdate;
   import d2hooks.ChatServer;
   import d2hooks.ChatServerWithObject;
   import d2hooks.DareWon;
   import d2hooks.ExchangeItemAutoCraftStoped;
   import d2hooks.ExchangeMultiCraftRequest;
   import d2hooks.ExchangeRequestCharacterToMe;
   import d2hooks.FightText;
   import d2hooks.GameFightEnd;
   import d2hooks.GameFightStart;
   import d2hooks.GameFightStarting;
   import d2hooks.GameFightTurnStartPlaying;
   import d2hooks.GuildInvited;
   import d2hooks.InactivityNotification;
   import d2hooks.MailStatus;
   import d2hooks.PlayerFightFriendlyRequested;
   import d2hooks.QuestValidated;
   import d2hooks.TextInformation;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   
   public class ExternalNotificationManager extends Sprite
   {
      
      private static var _instance:ExternalNotificationManager;
      
      private static const DEBUG:Boolean = false;
      
      private static var ENABLE_AVATARS:Boolean = true;
      
      private static var notifCount:int = 0;
      
      private static const ITEM_INDEX_CODE:String = String.fromCharCode(65532);
       
      
      private var sysApi:SystemApi;
      
      private var uiApi:UiApi;
      
      private var socialApi:SocialApi;
      
      private var extNotifApi:ExternalNotificationApi;
      
      private var fightApi:FightApi;
      
      private var playerApi:PlayedCharacterApi;
      
      private var dataApi:DataApi;
      
      private var chatApi:ChatApi;
      
      private var utilApi:UtilApi;
      
      private var iconsIds:Dictionary;
      
      private var iconsBgColorsIds:Dictionary;
      
      private var messages:Dictionary;
      
      private var _arenaRegistered:Boolean;
      
      public function ExternalNotificationManager(param1:PrivateClass)
      {
         super();
         this.iconsIds = new Dictionary();
         this.iconsBgColorsIds = new Dictionary();
         this.messages = new Dictionary();
         this.sysApi = Api.system as SystemApi;
         this.uiApi = Api.ui as UiApi;
         this.socialApi = Api.social as SocialApi;
         this.extNotifApi = Api.extNotif as ExternalNotificationApi;
         this.fightApi = Api.fight as FightApi;
         this.playerApi = Api.player as PlayedCharacterApi;
         this.dataApi = Api.data as DataApi;
         this.chatApi = Api.chat as ChatApi;
         this.utilApi = Api.util as UtilApi;
         ENABLE_AVATARS = this.sysApi.getOs().toLowerCase() != "linux";
         this.initData();
         this.sysApi.addHook(d2hooks.ExternalNotification,this.onExternalNotification);
         this.sysApi.addHook(InactivityNotification,this.onInactivityNotification);
         this.sysApi.addHook(MailStatus,this.onMailStatus);
         this.sysApi.addHook(ExchangeMultiCraftRequest,this.onMultiCraftRequest);
         this.sysApi.addHook(ExchangeItemAutoCraftStoped,this.onCraftStopped);
         this.sysApi.addHook(ArenaRegistrationStatusUpdate,this.onArenaRegistrationUpdate);
         this.sysApi.addHook(GameFightStarting,this.onGameFightStarting);
         this.sysApi.addHook(GameFightStart,this.onGameFightStart);
         this.sysApi.addHook(GameFightEnd,this.onGameFightEnd);
         this.sysApi.addHook(FightText,this.onFightText);
         this.sysApi.addHook(GameFightTurnStartPlaying,this.onFightTurnStartPlaying);
         this.sysApi.addHook(PlayerFightFriendlyRequested,this.onPlayerFight);
         this.sysApi.addHook(ExchangeRequestCharacterToMe,this.onExchange);
         this.sysApi.addHook(ChatServer,this.onChatServer);
         this.sysApi.addHook(ChatServerWithObject,this.onChatServerWithObject);
         this.sysApi.addHook(TextInformation,this.onTextInformation);
         this.sysApi.addHook(GuildInvited,this.onGuildInvitation);
         this.sysApi.addHook(AchievementFinished,this.onAchievementFinished);
         this.sysApi.addHook(QuestValidated,this.onQuestValidated);
         this.sysApi.addHook(DareWon,this.onDareWon);
         if(this.sysApi.getBuildType() != BuildTypeEnum.RELEASE && this.sysApi.getConfigEntry("config.dev.externalNotiflood"))
         {
            this.onInactivityNotification(true);
            this.onMailStatus(true,5,10);
            this.onMultiCraftRequest(1,"Jenexistepas",15);
            this.onCraftStopped(2);
            this.onArenaRegistrationUpdate(true,1);
            this.onGameFightStarting(0);
            this.onGameFightStart();
            this.onFightTurnStartPlaying();
            this.onPlayerFight("Jenexistepas");
            this.onChatServer(0,15,"Jenexistepas","test de notif ?");
            this.onTextInformation("test de notif ?",ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
            this.onGuildInvitation("Fausse Guilde",0,"Jenexistepas");
            this.onQuestValidated(469);
            this.onAchievementFinished(596);
         }
      }
      
      private static function log(param1:*) : void
      {
         if(DEBUG)
         {
            Api.system.log(2,param1);
         }
      }
      
      public static function getInstance() : ExternalNotificationManager
      {
         if(!_instance)
         {
            _instance = new ExternalNotificationManager(new PrivateClass());
         }
         return _instance;
      }
      
      private function initData() : void
      {
         var _loc3_:com.ankamagames.dofus.datacenter.externalnotifications.ExternalNotification = null;
         var _loc4_:int = 0;
         var _loc1_:Object = this.dataApi.getExternalNotifications();
         var _loc2_:Vector.<String> = new <String>["green","blue","yellow","red"];
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = ExternalNotificationTypeEnum[_loc3_.name];
            this.messages[_loc4_] = this.uiApi.getTextFromKey(_loc3_.messageId);
            this.iconsIds[_loc4_] = _loc3_.iconId;
            this.iconsBgColorsIds[_loc4_] = _loc2_[_loc3_.colorId - 1];
         }
      }
      
      private function getIconId(param1:int) : int
      {
         return this.iconsIds[param1];
      }
      
      private function getIconBgColorId(param1:int) : String
      {
         return this.iconsBgColorsIds[param1];
      }
      
      private function getChatMessage(param1:uint, param2:String) : Object
      {
         var _loc3_:Object = new Object();
         _loc3_.text = param2;
         if(_loc3_.text.indexOf("{") != -1 && _loc3_.text.indexOf("}") != -1)
         {
            _loc3_.text = this.chatApi.getStaticHyperlink(_loc3_.text);
         }
         _loc3_.css = "chat";
         switch(param1)
         {
            case ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO:
               _loc3_.notifType = ExternalNotificationTypeEnum.CHAT_MSG_INFO;
               _loc3_.cssClass = "p10";
               break;
            case ChatActivableChannelsEnum.PSEUDO_CHANNEL_PRIVATE:
               _loc3_.notifType = ExternalNotificationTypeEnum.PRIVATE_MSG;
               _loc3_.cssClass = "p9";
               break;
            case ChatActivableChannelsEnum.CHANNEL_GUILD:
               _loc3_.notifType = ExternalNotificationTypeEnum.CHAT_MSG_GUILD;
               _loc3_.cssClass = "p2";
               break;
            case ChatActivableChannelsEnum.CHANNEL_PARTY:
               _loc3_.notifType = ExternalNotificationTypeEnum.CHAT_MSG_GROUP;
               _loc3_.cssClass = "p4";
               break;
            case ChatActivableChannelsEnum.CHANNEL_TEAM:
               _loc3_.notifType = ExternalNotificationTypeEnum.CHAT_MSG_TEAM;
               _loc3_.cssClass = "p1";
               break;
            case ChatActivableChannelsEnum.CHANNEL_GLOBAL:
               _loc3_.notifType = ExternalNotificationTypeEnum.CHAT_MSG_GENERAL;
               _loc3_.cssClass = "p0";
               break;
            case ChatActivableChannelsEnum.CHANNEL_ADMIN:
               _loc3_.notifType = ExternalNotificationTypeEnum.CHAT_MSG_ADMIN;
               _loc3_.cssClass = "p8";
               break;
            case ChatActivableChannelsEnum.CHANNEL_ALLIANCE:
               _loc3_.notifType = ExternalNotificationTypeEnum.CHAT_MSG_ALIGNMENT;
               _loc3_.cssClass = "p3";
               break;
            case ChatActivableChannelsEnum.CHANNEL_SALES:
               _loc3_.notifType = ExternalNotificationTypeEnum.CHAT_MSG_TRADE;
               _loc3_.cssClass = "p5";
               break;
            case ChatActivableChannelsEnum.CHANNEL_ADS:
               _loc3_.notifType = ExternalNotificationTypeEnum.CHAT_MSG_PROMO;
               _loc3_.cssClass = "p12";
               break;
            case ChatActivableChannelsEnum.CHANNEL_ARENA:
               _loc3_.notifType = ExternalNotificationTypeEnum.CHAT_MSG_KOLO;
               _loc3_.cssClass = "p13";
               break;
            case ChatActivableChannelsEnum.CHANNEL_SEEK:
               _loc3_.notifType = ExternalNotificationTypeEnum.CHAT_MSG_RECRUIT;
               _loc3_.cssClass = "p6";
         }
         return _loc3_;
      }
      
      private function addExternalNotification(param1:int, param2:String, param3:String = "normal2", param4:String = "left", param5:Object = null) : void
      {
         notifCount++;
         this.extNotifApi.addExternalNotification(param1,"extNotif" + notifCount,"externalnotification",this.playerApi.getPlayedCharacterInfo().name.toUpperCase(),param2,"notifications",!param5?int(this.getIconId(param1)):-1,!param5?this.getIconBgColorId(param1):null,param3,param4,param5);
      }
      
      private function addExternalNotificationFromChatMessage(param1:uint, param2:Number, param3:String, param4:String) : void
      {
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc5_:Object = this.getChatMessage(param1,this.chatApi.unEscapeChatString(param4));
         if(_loc5_.notifType > 0 && this.extNotifApi.canAddExternalNotification(_loc5_.notifType))
         {
            _loc6_ = !!param3?param3 + this.uiApi.getText("ui.common.colon"):"";
            if(ENABLE_AVATARS)
            {
               switch(param1)
               {
                  case ChatActivableChannelsEnum.PSEUDO_CHANNEL_PRIVATE:
                     _loc7_ = {
                        "id":param2,
                        "contactCategory":SocialContactCategoryEnum.SOCIAL_CONTACT_INTERLOCUTOR
                     };
                     break;
                  case ChatActivableChannelsEnum.CHANNEL_GUILD:
                     _loc7_ = {
                        "id":param2,
                        "contactCategory":SocialContactCategoryEnum.SOCIAL_CONTACT_GUILD
                     };
               }
            }
            this.addExternalNotification(_loc5_.notifType,_loc6_ + _loc5_.text,_loc5_.css,_loc5_.cssClass,_loc7_);
         }
      }
      
      private function onQuestValidated(param1:uint) : void
      {
         var _loc2_:Quest = null;
         var _loc3_:String = null;
         if(this.extNotifApi.getShowMode() != ExternalNotificationModeEnum.DISABLED && !this.extNotifApi.isExternalNotificationTypeIgnored(ExternalNotificationTypeEnum.QUEST_VALIDATED))
         {
            notifCount++;
            _loc2_ = this.dataApi.getQuest(param1);
            _loc3_ = "<b>" + this.uiApi.getText("ui.almanax.questDone") + "</b><br/>" + _loc2_.name;
            this.extNotifApi.addExternalNotification(ExternalNotificationTypeEnum.QUEST_VALIDATED,"extNotif" + notifCount,"questNotification",null,_loc3_,null,-1,null,"normal","left",null,UISoundEnum.ACHIEVEMENT_UNLOCKED,true);
         }
      }
      
      private function onAchievementFinished(param1:uint) : void
      {
         var _loc2_:Achievement = null;
         if(this.extNotifApi.getShowMode() != ExternalNotificationModeEnum.DISABLED && !this.extNotifApi.isExternalNotificationTypeIgnored(ExternalNotificationTypeEnum.ACHIEVEMENT_UNLOCKED))
         {
            notifCount++;
            _loc2_ = this.dataApi.getAchievement(param1);
            if(!_loc2_)
            {
               this.sysApi.log(16,"Error : Achievemnt " + param1 + " doesn\'t exist.");
               return;
            }
            this.extNotifApi.addExternalNotification(ExternalNotificationTypeEnum.ACHIEVEMENT_UNLOCKED,"extNotif" + notifCount,"achievementNotification",null,"<b>" + this.uiApi.getText("ui.achievement.achievementUnlock") + "</b><br/>" + _loc2_.name,"achievements",_loc2_.iconId,null,"normal","darkleft",null,UISoundEnum.ACHIEVEMENT_UNLOCKED,true,"OpenBook",["achievementTab",{
               "forceOpen":true,
               "achievementId":param1
            }]);
         }
      }
      
      private function onDareWon(param1:Number) : void
      {
         if(this.extNotifApi.getShowMode() != ExternalNotificationModeEnum.DISABLED && !this.extNotifApi.isExternalNotificationTypeIgnored(ExternalNotificationTypeEnum.DARE_WON))
         {
            this.onExternalNotification(ExternalNotificationTypeEnum.DARE_WON,[param1]);
         }
      }
      
      private function onExternalNotification(... rest) : void
      {
         var _loc4_:Object = null;
         var _loc2_:int = rest[0];
         var _loc3_:* = rest[1];
         if(ENABLE_AVATARS)
         {
            switch(_loc2_)
            {
               case ExternalNotificationTypeEnum.FRIEND_CONNECTION:
                  _loc4_ = {
                     "id":_loc3_[_loc3_.length - 1],
                     "contactCategory":SocialContactCategoryEnum.SOCIAL_CONTACT_FRIEND
                  };
                  break;
               case ExternalNotificationTypeEnum.MEMBER_CONNECTION:
                  _loc4_ = {
                     "id":_loc3_[_loc3_.length - 1],
                     "contactCategory":SocialContactCategoryEnum.SOCIAL_CONTACT_GUILD
                  };
            }
         }
         var _loc5_:String = !_loc3_?this.messages[_loc2_]:this.utilApi.applyTextParams(this.messages[_loc2_],_loc3_);
         if(_loc5_.indexOf("{") != -1 && _loc5_.indexOf("}") != -1)
         {
            _loc5_ = this.chatApi.getStaticHyperlink(_loc5_);
         }
         this.addExternalNotification(_loc2_,_loc5_,"normal2","left",_loc4_);
      }
      
      private function onFightText(param1:String, param2:Object, param3:Object, param4:String = "") : void
      {
         var _loc8_:String = null;
         var _loc5_:Number = param2[0] as Number;
         var _loc6_:String = this.playerApi.getPlayedCharacterInfo().name;
         var _loc7_:Boolean = param1 == FightEventEnum.FIGHTER_DEATH || param1 == FightEventEnum.FIGHTER_LIFE_LOSS_AND_DEATH;
         if(_loc7_ && _loc5_ == this.playerApi.id() && this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.FIGHT_DEATH))
         {
            _loc8_ = this.playerApi.getPlayedCharacterInfo().sex == 0?"m":"f";
            this.addExternalNotification(ExternalNotificationTypeEnum.FIGHT_DEATH,this.uiApi.processText(this.uiApi.replaceParams(this.messages[ExternalNotificationTypeEnum.FIGHT_DEATH],[_loc6_]),_loc8_));
         }
      }
      
      private function onInactivityNotification(param1:Boolean) : void
      {
         if(param1 && this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.INACTIVITY_WARNING))
         {
            this.addExternalNotification(ExternalNotificationTypeEnum.INACTIVITY_WARNING,this.messages[ExternalNotificationTypeEnum.INACTIVITY_WARNING]);
         }
      }
      
      private function onMailStatus(param1:Boolean, param2:uint, param3:uint) : void
      {
         if(param1 && this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.ANKABOX_MSG))
         {
            this.addExternalNotification(ExternalNotificationTypeEnum.ANKABOX_MSG,this.messages[ExternalNotificationTypeEnum.ANKABOX_MSG]);
         }
      }
      
      private function onMultiCraftRequest(param1:int, param2:String, param3:Number) : void
      {
         if(param1 == ExchangeTypeEnum.MULTICRAFT_CUSTOMER && this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.CRAFT_INVITATION))
         {
            this.addExternalNotification(ExternalNotificationTypeEnum.CRAFT_INVITATION,this.uiApi.replaceParams(this.messages[ExternalNotificationTypeEnum.CRAFT_INVITATION],[param2]));
         }
         else if(param3 != this.playerApi.id() && this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.CRAFT_REQUEST))
         {
            this.addExternalNotification(ExternalNotificationTypeEnum.CRAFT_REQUEST,this.uiApi.replaceParams(this.messages[ExternalNotificationTypeEnum.CRAFT_REQUEST],[param2]));
         }
      }
      
      private function onCraftStopped(param1:int) : void
      {
         if(param1 == ExchangeReplayStopReasonEnum.STOPPED_REASON_OK && this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.MULTI_CRAFT_END))
         {
            this.addExternalNotification(ExternalNotificationTypeEnum.MULTI_CRAFT_END,this.messages[ExternalNotificationTypeEnum.MULTI_CRAFT_END]);
         }
      }
      
      private function onArenaRegistrationUpdate(param1:Boolean, param2:int) : void
      {
         if(param1 != this._arenaRegistered)
         {
            if(param1 && param2 == PvpArenaStepEnum.ARENA_STEP_REGISTRED && this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.KOLO_SEARCH))
            {
               this.addExternalNotification(ExternalNotificationTypeEnum.KOLO_SEARCH,this.messages[ExternalNotificationTypeEnum.KOLO_SEARCH]);
            }
            else if(!param1 && param2 != PvpArenaStepEnum.ARENA_STEP_STARTING_FIGHT && this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.KOLO_SEARCH_END))
            {
               this.addExternalNotification(ExternalNotificationTypeEnum.KOLO_SEARCH_END,this.messages[ExternalNotificationTypeEnum.KOLO_SEARCH_END]);
            }
            this._arenaRegistered = param1;
         }
      }
      
      private function onGameFightStarting(param1:uint) : void
      {
         if(param1 == FightTypeEnum.FIGHT_TYPE_PvM && this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.FIGHT_JOIN))
         {
            this.addExternalNotification(ExternalNotificationTypeEnum.FIGHT_JOIN,this.messages[ExternalNotificationTypeEnum.FIGHT_JOIN]);
         }
      }
      
      private function onGameFightStart() : void
      {
         if(this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.FIGHT_START))
         {
            this.addExternalNotification(ExternalNotificationTypeEnum.FIGHT_START,this.messages[ExternalNotificationTypeEnum.FIGHT_START]);
         }
      }
      
      private function onGameFightEnd(param1:Object) : void
      {
         if(this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.FIGHT_END))
         {
            this.addExternalNotification(ExternalNotificationTypeEnum.FIGHT_END,this.messages[ExternalNotificationTypeEnum.FIGHT_END]);
         }
      }
      
      private function onFightTurnStartPlaying() : void
      {
         if(this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.FIGHT_TURN_START))
         {
            this.addExternalNotification(ExternalNotificationTypeEnum.FIGHT_TURN_START,this.messages[ExternalNotificationTypeEnum.FIGHT_TURN_START]);
         }
      }
      
      private function onPlayerFight(param1:String) : void
      {
         if(this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.CHALLENGE_INVITATION))
         {
            this.addExternalNotification(ExternalNotificationTypeEnum.CHALLENGE_INVITATION,this.uiApi.replaceParams(this.messages[ExternalNotificationTypeEnum.CHALLENGE_INVITATION],[param1]));
         }
      }
      
      private function onExchange(param1:String, param2:String) : void
      {
         if(this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.EXCHANGE_INVITATION))
         {
            this.addExternalNotification(ExternalNotificationTypeEnum.EXCHANGE_INVITATION,this.uiApi.replaceParams(this.messages[ExternalNotificationTypeEnum.EXCHANGE_INVITATION],[param2]));
         }
      }
      
      private function onChatServer(param1:uint = 0, param2:Number = 0, param3:String = "", param4:String = "", param5:Number = 0, param6:String = "", param7:Boolean = false) : void
      {
         this.addExternalNotificationFromChatMessage(param1,param2,param3,param4);
      }
      
      private function onChatServerWithObject(param1:uint = 0, param2:Number = 0, param3:String = "", param4:String = "", param5:Number = 0, param6:String = "", param7:Object = null) : void
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:ItemWrapper = null;
         var _loc12_:int = 0;
         var _loc8_:String = param4;
         if(param7)
         {
            _loc9_ = param7.length;
            _loc10_ = 0;
            while(_loc10_ < _loc9_)
            {
               _loc11_ = param7[_loc10_];
               _loc12_ = _loc8_.indexOf(ITEM_INDEX_CODE);
               if(_loc12_ == -1)
               {
                  break;
               }
               _loc8_ = _loc8_.substr(0,_loc12_) + this.chatApi.newChatItem(_loc11_) + _loc8_.substr(_loc12_ + 1);
               _loc10_++;
            }
         }
         this.addExternalNotificationFromChatMessage(param1,param2,param3,_loc8_);
      }
      
      private function onTextInformation(param1:String = "", param2:uint = 0, param3:Number = 0, param4:Boolean = true, param5:Boolean = false) : void
      {
         if(param2 == ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO)
         {
            this.addExternalNotificationFromChatMessage(param2,-1,null,param1);
         }
      }
      
      private function onGuildInvitation(param1:String, param2:Number, param3:String) : void
      {
         if(this.extNotifApi.canAddExternalNotification(ExternalNotificationTypeEnum.GUILD_INVITATION))
         {
            this.addExternalNotification(ExternalNotificationTypeEnum.GUILD_INVITATION,this.uiApi.replaceParams(this.messages[ExternalNotificationTypeEnum.GUILD_INVITATION],[param3,param1]));
         }
      }
   }
}

class PrivateClass
{
    
   
   function PrivateClass()
   {
      super();
   }
}
