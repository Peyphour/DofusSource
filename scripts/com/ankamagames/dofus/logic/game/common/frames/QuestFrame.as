package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.managers.FrustumManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.quest.Achievement;
   import com.ankamagames.dofus.datacenter.quest.AchievementCategory;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.datacenter.quest.QuestStep;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.quest.TreasureHuntStepWrapper;
   import com.ankamagames.dofus.internalDatacenter.quest.TreasureHuntWrapper;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.NotificationResetAction;
   import com.ankamagames.dofus.logic.game.common.actions.NotificationUpdateFlagAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.AchievementDetailedListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.AchievementDetailsRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.AchievementRewardRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.GuidedModeQuitRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.GuidedModeReturnRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestInfosRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestObjectiveValidationAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.QuestStartRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt.TreasureHuntDigRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt.TreasureHuntFlagRemoveRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt.TreasureHuntFlagRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt.TreasureHuntGiveUpRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt.TreasureHuntLegendaryRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt.TreasureHuntRequestAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.QuestHookList;
   import com.ankamagames.dofus.misc.utils.ParamsDecoder;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.CompassTypeEnum;
   import com.ankamagames.dofus.network.enums.TreasureHuntDigRequestEnum;
   import com.ankamagames.dofus.network.enums.TreasureHuntFlagRequestEnum;
   import com.ankamagames.dofus.network.enums.TreasureHuntFlagStateEnum;
   import com.ankamagames.dofus.network.enums.TreasureHuntRequestEnum;
   import com.ankamagames.dofus.network.enums.TreasureHuntTypeEnum;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailedListMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailedListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailsMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementFinishedInformationMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementFinishedMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementListMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementRewardErrorMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementRewardRequestMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementRewardSuccessMessage;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationResetMessage;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationUpdateFlagMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.GuidedModeQuitRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.GuidedModeReturnRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestListMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestObjectiveValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestObjectiveValidationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStartRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStartedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepInfoMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepInfoRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepStartedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestValidatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntAvailableRetryCountUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntDigRequestAnswerFailedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntDigRequestAnswerMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntDigRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntFinishedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntFlagRemoveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntFlagRequestAnswerMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntFlagRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntGiveUpRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntLegendaryRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntRequestAnswerMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntShowLegendaryUIMessage;
   import com.ankamagames.dofus.network.types.game.achievement.AchievementRewardable;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestActiveDetailedInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestActiveInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestObjectiveInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.quest.QuestObjectiveInformationsWithCompletion;
   import com.ankamagames.dofus.network.types.game.context.roleplay.treasureHunt.TreasureHuntFlag;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class QuestFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(QuestFrame));
      
      public static var notificationList:Array;
       
      
      private var _nbAllAchievements:int;
      
      private var _activeQuests:Vector.<QuestActiveInformations>;
      
      private var _completedQuests:Vector.<uint>;
      
      private var _reinitDoneQuests:Vector.<uint>;
      
      private var _questsInformations:Dictionary;
      
      private var _finishedAchievementsIds:Vector.<uint>;
      
      private var _rewardableAchievements:Vector.<AchievementRewardable>;
      
      private var _rewardableAchievementsVisible:Boolean;
      
      private var _treasureHunts:Dictionary;
      
      private var _flagColors:Array;
      
      public function QuestFrame()
      {
         this._questsInformations = new Dictionary();
         this._treasureHunts = new Dictionary();
         this._flagColors = new Array();
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get finishedAchievementsIds() : Vector.<uint>
      {
         return this._finishedAchievementsIds;
      }
      
      public function getActiveQuests() : Vector.<QuestActiveInformations>
      {
         return this._activeQuests;
      }
      
      public function getCompletedQuests() : Vector.<uint>
      {
         return this._completedQuests;
      }
      
      public function getReinitDoneQuests() : Vector.<uint>
      {
         return this._reinitDoneQuests;
      }
      
      public function getQuestInformations(param1:uint) : Object
      {
         return this._questsInformations[param1];
      }
      
      public function get rewardableAchievements() : Vector.<AchievementRewardable>
      {
         return this._rewardableAchievements;
      }
      
      public function getTreasureHuntById(param1:uint) : Object
      {
         return this._treasureHunts[param1];
      }
      
      public function pushed() : Boolean
      {
         this._rewardableAchievements = new Vector.<AchievementRewardable>();
         this._finishedAchievementsIds = new Vector.<uint>();
         this._treasureHunts = new Dictionary();
         this._nbAllAchievements = Achievement.getAchievements().length;
         this._flagColors[TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_UNKNOWN] = XmlConfig.getInstance().getEntry("colors.flag.unknown");
         this._flagColors[TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_OK] = XmlConfig.getInstance().getEntry("colors.flag.right");
         this._flagColors[TreasureHuntFlagStateEnum.TREASURE_HUNT_FLAG_STATE_WRONG] = XmlConfig.getInstance().getEntry("colors.flag.wrong");
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:QuestListRequestMessage = null;
         var _loc3_:QuestListMessage = null;
         var _loc4_:QuestInfosRequestAction = null;
         var _loc5_:QuestStepInfoRequestMessage = null;
         var _loc6_:QuestStepInfoMessage = null;
         var _loc7_:QuestStartRequestAction = null;
         var _loc8_:QuestStartRequestMessage = null;
         var _loc9_:QuestObjectiveValidationAction = null;
         var _loc10_:QuestObjectiveValidationMessage = null;
         var _loc11_:GuidedModeReturnRequestMessage = null;
         var _loc12_:GuidedModeQuitRequestMessage = null;
         var _loc13_:QuestStartedMessage = null;
         var _loc14_:QuestValidatedMessage = null;
         var _loc15_:Quest = null;
         var _loc16_:QuestObjectiveValidatedMessage = null;
         var _loc17_:QuestStepValidatedMessage = null;
         var _loc18_:Object = null;
         var _loc19_:QuestStepStartedMessage = null;
         var _loc20_:NotificationUpdateFlagAction = null;
         var _loc21_:NotificationUpdateFlagMessage = null;
         var _loc22_:NotificationResetMessage = null;
         var _loc23_:AchievementListMessage = null;
         var _loc24_:Achievement = null;
         var _loc25_:int = 0;
         var _loc26_:AchievementCategory = null;
         var _loc27_:Dictionary = null;
         var _loc28_:AchievementDetailedListRequestAction = null;
         var _loc29_:AchievementDetailedListRequestMessage = null;
         var _loc30_:AchievementDetailedListMessage = null;
         var _loc31_:AchievementDetailsRequestAction = null;
         var _loc32_:AchievementDetailsRequestMessage = null;
         var _loc33_:AchievementDetailsMessage = null;
         var _loc34_:AchievementFinishedInformationMessage = null;
         var _loc35_:String = null;
         var _loc36_:AchievementFinishedMessage = null;
         var _loc37_:AchievementRewardable = null;
         var _loc38_:String = null;
         var _loc39_:AchievementRewardRequestAction = null;
         var _loc40_:AchievementRewardRequestMessage = null;
         var _loc41_:AchievementRewardSuccessMessage = null;
         var _loc42_:int = 0;
         var _loc43_:AchievementRewardErrorMessage = null;
         var _loc44_:TreasureHuntShowLegendaryUIMessage = null;
         var _loc45_:TreasureHuntRequestAction = null;
         var _loc46_:TreasureHuntRequestMessage = null;
         var _loc47_:TreasureHuntLegendaryRequestAction = null;
         var _loc48_:TreasureHuntLegendaryRequestMessage = null;
         var _loc49_:TreasureHuntRequestAnswerMessage = null;
         var _loc50_:String = null;
         var _loc51_:TreasureHuntFlagRequestAction = null;
         var _loc52_:TreasureHuntFlagRequestMessage = null;
         var _loc53_:TreasureHuntFlagRemoveRequestAction = null;
         var _loc54_:TreasureHuntFlagRemoveRequestMessage = null;
         var _loc55_:TreasureHuntFlagRequestAnswerMessage = null;
         var _loc56_:String = null;
         var _loc57_:TreasureHuntMessage = null;
         var _loc58_:MapPosition = null;
         var _loc59_:TreasureHuntWrapper = null;
         var _loc60_:int = 0;
         var _loc61_:TreasureHuntAvailableRetryCountUpdateMessage = null;
         var _loc62_:TreasureHuntFinishedMessage = null;
         var _loc63_:TreasureHuntGiveUpRequestAction = null;
         var _loc64_:TreasureHuntGiveUpRequestMessage = null;
         var _loc65_:TreasureHuntDigRequestAction = null;
         var _loc66_:TreasureHuntDigRequestMessage = null;
         var _loc67_:TreasureHuntDigRequestAnswerMessage = null;
         var _loc68_:int = 0;
         var _loc69_:String = null;
         var _loc70_:QuestActiveDetailedInformations = null;
         var _loc71_:QuestObjectiveInformations = null;
         var _loc72_:Array = null;
         var _loc73_:int = 0;
         var _loc74_:Object = null;
         var _loc75_:int = 0;
         var _loc76_:QuestActiveInformations = null;
         var _loc77_:QuestStep = null;
         var _loc78_:int = 0;
         var _loc79_:int = 0;
         var _loc80_:int = 0;
         var _loc81_:AchievementRewardable = null;
         var _loc82_:SubArea = null;
         var _loc83_:AchievementRewardable = null;
         var _loc84_:int = 0;
         var _loc85_:TreasureHuntStepWrapper = null;
         var _loc86_:TreasureHuntFlag = null;
         switch(true)
         {
            case param1 is QuestListRequestAction:
               _loc2_ = new QuestListRequestMessage();
               _loc2_.initQuestListRequestMessage();
               ConnectionsHandler.getConnection().send(_loc2_);
               return true;
            case param1 is QuestListMessage:
               _loc3_ = param1 as QuestListMessage;
               this._activeQuests = _loc3_.activeQuests;
               this._completedQuests = _loc3_.finishedQuestsIds;
               this._completedQuests = this._completedQuests.concat(_loc3_.reinitDoneQuestsIds);
               this._reinitDoneQuests = _loc3_.reinitDoneQuestsIds;
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestListUpdated);
               return true;
            case param1 is QuestInfosRequestAction:
               _loc4_ = param1 as QuestInfosRequestAction;
               _loc5_ = new QuestStepInfoRequestMessage();
               _loc5_.initQuestStepInfoRequestMessage(_loc4_.questId);
               ConnectionsHandler.getConnection().send(_loc5_);
               return true;
            case param1 is QuestStepInfoMessage:
               _loc6_ = param1 as QuestStepInfoMessage;
               if(_loc6_.infos is QuestActiveDetailedInformations)
               {
                  _loc70_ = _loc6_.infos as QuestActiveDetailedInformations;
                  this._questsInformations[_loc70_.questId] = {
                     "questId":_loc70_.questId,
                     "stepId":_loc70_.stepId
                  };
                  this._questsInformations[_loc70_.questId].objectives = new Array();
                  this._questsInformations[_loc70_.questId].objectivesData = new Array();
                  this._questsInformations[_loc70_.questId].objectivesDialogParams = new Array();
                  for each(_loc71_ in _loc70_.objectives)
                  {
                     this._questsInformations[_loc70_.questId].objectives[_loc71_.objectiveId] = _loc71_.objectiveStatus;
                     if(_loc71_.dialogParams && _loc71_.dialogParams.length > 0)
                     {
                        _loc72_ = new Array();
                        _loc73_ = _loc71_.dialogParams.length;
                        _loc60_ = 0;
                        while(_loc60_ < _loc73_)
                        {
                           _loc72_.push(_loc71_.dialogParams[_loc60_]);
                           _loc60_++;
                        }
                     }
                     this._questsInformations[_loc70_.questId].objectivesDialogParams[_loc71_.objectiveId] = _loc72_;
                     if(_loc71_ is QuestObjectiveInformationsWithCompletion)
                     {
                        _loc74_ = new Object();
                        _loc74_.current = (_loc71_ as QuestObjectiveInformationsWithCompletion).curCompletion;
                        _loc74_.max = (_loc71_ as QuestObjectiveInformationsWithCompletion).maxCompletion;
                        this._questsInformations[_loc70_.questId].objectivesData[_loc71_.objectiveId] = _loc74_;
                     }
                  }
                  KernelEventsManager.getInstance().processCallback(QuestHookList.QuestInfosUpdated,_loc70_.questId,true);
               }
               else if(_loc6_.infos is QuestActiveInformations)
               {
                  KernelEventsManager.getInstance().processCallback(QuestHookList.QuestInfosUpdated,(_loc6_.infos as QuestActiveInformations).questId,false);
               }
               return true;
            case param1 is QuestStartRequestAction:
               _loc7_ = param1 as QuestStartRequestAction;
               _loc8_ = new QuestStartRequestMessage();
               _loc8_.initQuestStartRequestMessage(_loc7_.questId);
               ConnectionsHandler.getConnection().send(_loc8_);
               return true;
            case param1 is QuestObjectiveValidationAction:
               _loc9_ = param1 as QuestObjectiveValidationAction;
               _loc10_ = new QuestObjectiveValidationMessage();
               _loc10_.initQuestObjectiveValidationMessage(_loc9_.questId,_loc9_.objectiveId);
               ConnectionsHandler.getConnection().send(_loc10_);
               return true;
            case param1 is GuidedModeReturnRequestAction:
               _loc11_ = new GuidedModeReturnRequestMessage();
               _loc11_.initGuidedModeReturnRequestMessage();
               ConnectionsHandler.getConnection().send(_loc11_);
               return true;
            case param1 is GuidedModeQuitRequestAction:
               _loc12_ = new GuidedModeQuitRequestMessage();
               _loc12_.initGuidedModeQuitRequestMessage();
               ConnectionsHandler.getConnection().send(_loc12_);
               return true;
            case param1 is QuestStartedMessage:
               _loc13_ = param1 as QuestStartedMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestStarted,_loc13_.questId);
               return true;
            case param1 is QuestValidatedMessage:
               _loc14_ = param1 as QuestValidatedMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestValidated,_loc14_.questId);
               if(!this._completedQuests)
               {
                  this._completedQuests = new Vector.<uint>();
               }
               else
               {
                  for each(_loc76_ in this._activeQuests)
                  {
                     if(_loc76_.questId == _loc14_.questId)
                     {
                        break;
                     }
                     _loc75_++;
                  }
                  if(this._activeQuests && _loc75_ < this._activeQuests.length)
                  {
                     this._activeQuests.splice(_loc75_,1);
                  }
               }
               this._completedQuests.push(_loc14_.questId);
               _loc15_ = Quest.getQuestById(_loc14_.questId);
               for each(_loc77_ in _loc15_.steps)
               {
                  for each(_loc78_ in _loc77_.objectiveIds)
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.RemoveMapFlag,"flag_srv" + CompassTypeEnum.COMPASS_TYPE_QUEST + "_" + _loc14_.questId + "_" + _loc78_,PlayedCharacterManager.getInstance().currentWorldMap.id);
                  }
               }
               return true;
            case param1 is QuestObjectiveValidatedMessage:
               _loc16_ = param1 as QuestObjectiveValidatedMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestObjectiveValidated,_loc16_.questId,_loc16_.objectiveId);
               KernelEventsManager.getInstance().processCallback(HookList.RemoveMapFlag,"flag_srv" + CompassTypeEnum.COMPASS_TYPE_QUEST + "_" + _loc16_.questId + "_" + _loc16_.objectiveId,PlayedCharacterManager.getInstance().currentWorldMap.id);
               return true;
            case param1 is QuestStepValidatedMessage:
               _loc17_ = param1 as QuestStepValidatedMessage;
               if(this._questsInformations[_loc17_.questId])
               {
                  this._questsInformations[_loc17_.questId].stepId = _loc17_.stepId;
               }
               _loc18_ = QuestStep.getQuestStepById(_loc17_.stepId).objectiveIds;
               for each(_loc79_ in _loc18_)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.RemoveMapFlag,"flag_srv" + CompassTypeEnum.COMPASS_TYPE_QUEST + "_" + _loc17_.questId + "_" + _loc79_,PlayedCharacterManager.getInstance().currentWorldMap.id);
               }
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestStepValidated,_loc17_.questId,_loc17_.stepId);
               return true;
            case param1 is QuestStepStartedMessage:
               _loc19_ = param1 as QuestStepStartedMessage;
               if(this._questsInformations[_loc19_.questId])
               {
                  this._questsInformations[_loc19_.questId].stepId = _loc19_.stepId;
               }
               KernelEventsManager.getInstance().processCallback(QuestHookList.QuestStepStarted,_loc19_.questId,_loc19_.stepId);
               return true;
            case param1 is NotificationUpdateFlagAction:
               _loc20_ = param1 as NotificationUpdateFlagAction;
               _loc21_ = new NotificationUpdateFlagMessage();
               _loc21_.initNotificationUpdateFlagMessage(_loc20_.index);
               ConnectionsHandler.getConnection().send(_loc21_);
               return true;
            case param1 is NotificationResetAction:
               notificationList = new Array();
               _loc22_ = new NotificationResetMessage();
               _loc22_.initNotificationResetMessage();
               ConnectionsHandler.getConnection().send(_loc22_);
               KernelEventsManager.getInstance().processCallback(HookList.NotificationReset);
               return true;
            case param1 is AchievementListMessage:
               _loc23_ = param1 as AchievementListMessage;
               this._finishedAchievementsIds = _loc23_.finishedAchievementsIds;
               this._rewardableAchievements = _loc23_.rewardableAchievements;
               _loc26_ = AchievementCategory.getAchievementCategoryById(6);
               _loc27_ = new Dictionary();
               for each(_loc80_ in this._finishedAchievementsIds)
               {
                  if(_loc24_ = Achievement.getAchievementById(_loc80_))
                  {
                     _loc25_ = _loc25_ + Achievement.getAchievementById(_loc80_).points;
                     _loc27_[_loc80_] = true;
                  }
                  else
                  {
                     _log.warn("Succés " + _loc80_ + " non exporté");
                  }
               }
               for each(_loc81_ in this._rewardableAchievements)
               {
                  if(Achievement.getAchievementById(_loc81_.id))
                  {
                     _loc25_ = _loc25_ + Achievement.getAchievementById(_loc81_.id).points;
                     this._finishedAchievementsIds.push(_loc81_.id);
                     _loc27_[_loc80_] = true;
                  }
                  else
                  {
                     _log.warn("Succés " + _loc81_.id + " non exporté");
                  }
               }
               for each(_loc82_ in SubArea.getAllSubArea())
               {
                  _loc82_.isDiscovered = _loc27_[_loc82_.exploreAchievementId];
               }
               KernelEventsManager.getInstance().processCallback(QuestHookList.AchievementList,this._finishedAchievementsIds);
               if(!this._rewardableAchievementsVisible && this._rewardableAchievements.length > 0)
               {
                  this._rewardableAchievementsVisible = true;
                  KernelEventsManager.getInstance().processCallback(QuestHookList.RewardableAchievementsVisible,this._rewardableAchievementsVisible);
               }
               PlayedCharacterManager.getInstance().achievementPercent = Math.floor(this._finishedAchievementsIds.length / this._nbAllAchievements * 100);
               PlayedCharacterManager.getInstance().achievementPoints = _loc25_;
               return true;
            case param1 is AchievementDetailedListRequestAction:
               _loc28_ = param1 as AchievementDetailedListRequestAction;
               _loc29_ = new AchievementDetailedListRequestMessage();
               _loc29_.initAchievementDetailedListRequestMessage(_loc28_.categoryId);
               ConnectionsHandler.getConnection().send(_loc29_);
               return true;
            case param1 is AchievementDetailedListMessage:
               _loc30_ = param1 as AchievementDetailedListMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.AchievementDetailedList,_loc30_.finishedAchievements,_loc30_.startedAchievements);
               return true;
            case param1 is AchievementDetailsRequestAction:
               _loc31_ = param1 as AchievementDetailsRequestAction;
               _loc32_ = new AchievementDetailsRequestMessage();
               _loc32_.initAchievementDetailsRequestMessage(_loc31_.achievementId);
               ConnectionsHandler.getConnection().send(_loc32_);
               return true;
            case param1 is AchievementDetailsMessage:
               _loc33_ = param1 as AchievementDetailsMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.AchievementDetails,_loc33_.achievement);
               return true;
            case param1 is AchievementFinishedInformationMessage:
               _loc34_ = param1 as AchievementFinishedInformationMessage;
               _loc35_ = ParamsDecoder.applyParams(I18n.getUiText("ui.achievement.characterUnlocksAchievement",["{player," + _loc34_.name + "," + _loc34_.playerId + "}"]),[_loc34_.name,_loc34_.id]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc35_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is AchievementFinishedMessage:
               _loc36_ = param1 as AchievementFinishedMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.AchievementFinished,_loc36_.id);
               this._finishedAchievementsIds.push(_loc36_.id);
               _loc37_ = new AchievementRewardable();
               this._rewardableAchievements.push(_loc37_.initAchievementRewardable(_loc36_.id,_loc36_.finishedlevel));
               if(!this._rewardableAchievementsVisible)
               {
                  this._rewardableAchievementsVisible = true;
                  KernelEventsManager.getInstance().processCallback(QuestHookList.RewardableAchievementsVisible,this._rewardableAchievementsVisible);
               }
               _loc38_ = ParamsDecoder.applyParams(I18n.getUiText("ui.achievement.achievementUnlockWithLink"),[_loc36_.id]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc38_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               PlayedCharacterManager.getInstance().achievementPercent = Math.floor(this._finishedAchievementsIds.length / this._nbAllAchievements * 100);
               PlayedCharacterManager.getInstance().achievementPoints = PlayedCharacterManager.getInstance().achievementPoints + Achievement.getAchievementById(_loc36_.id).points;
               return true;
            case param1 is AchievementRewardRequestAction:
               _loc39_ = param1 as AchievementRewardRequestAction;
               _loc40_ = new AchievementRewardRequestMessage();
               _loc40_.initAchievementRewardRequestMessage(_loc39_.achievementId);
               ConnectionsHandler.getConnection().send(_loc40_);
               return true;
            case param1 is AchievementRewardSuccessMessage:
               _loc41_ = param1 as AchievementRewardSuccessMessage;
               for each(_loc83_ in this._rewardableAchievements)
               {
                  if(_loc83_.id == _loc41_.achievementId)
                  {
                     _loc42_ = this._rewardableAchievements.indexOf(_loc83_);
                     break;
                  }
               }
               this._rewardableAchievements.splice(_loc42_,1);
               KernelEventsManager.getInstance().processCallback(QuestHookList.AchievementRewardSuccess,_loc41_.achievementId);
               if(this._rewardableAchievementsVisible && this._rewardableAchievements.length == 0)
               {
                  this._rewardableAchievementsVisible = false;
                  KernelEventsManager.getInstance().processCallback(QuestHookList.RewardableAchievementsVisible,this._rewardableAchievementsVisible);
               }
               return true;
            case param1 is AchievementRewardErrorMessage:
               _loc43_ = param1 as AchievementRewardErrorMessage;
               return true;
            case param1 is TreasureHuntShowLegendaryUIMessage:
               _loc44_ = param1 as TreasureHuntShowLegendaryUIMessage;
               KernelEventsManager.getInstance().processCallback(QuestHookList.TreasureHuntLegendaryUiUpdate,_loc44_.availableLegendaryIds);
               return true;
            case param1 is TreasureHuntRequestAction:
               _loc45_ = param1 as TreasureHuntRequestAction;
               _loc46_ = new TreasureHuntRequestMessage();
               _loc46_.initTreasureHuntRequestMessage(_loc45_.level,_loc45_.questType);
               ConnectionsHandler.getConnection().send(_loc46_);
               return true;
            case param1 is TreasureHuntLegendaryRequestAction:
               _loc47_ = param1 as TreasureHuntLegendaryRequestAction;
               _loc48_ = new TreasureHuntLegendaryRequestMessage();
               _loc48_.initTreasureHuntLegendaryRequestMessage(_loc47_.legendaryId);
               ConnectionsHandler.getConnection().send(_loc48_);
               return true;
            case param1 is TreasureHuntRequestAnswerMessage:
               _loc49_ = param1 as TreasureHuntRequestAnswerMessage;
               if(_loc49_.result == TreasureHuntRequestEnum.TREASURE_HUNT_ERROR_ALREADY_HAVE_QUEST)
               {
                  _loc50_ = I18n.getUiText("ui.treasureHunt.alreadyHaveQuest");
               }
               else if(_loc49_.result == TreasureHuntRequestEnum.TREASURE_HUNT_ERROR_NO_QUEST_FOUND)
               {
                  _loc50_ = I18n.getUiText("ui.treasureHunt.noQuestFound");
               }
               else if(_loc49_.result == TreasureHuntRequestEnum.TREASURE_HUNT_ERROR_UNDEFINED)
               {
                  _loc50_ = I18n.getUiText("ui.popup.impossible_action");
               }
               else if(_loc49_.result == TreasureHuntRequestEnum.TREASURE_HUNT_ERROR_NOT_AVAILABLE)
               {
                  _loc50_ = I18n.getUiText("ui.treasureHunt.huntNotAvailable");
               }
               if(_loc50_)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc50_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is TreasureHuntFlagRequestAction:
               _loc51_ = param1 as TreasureHuntFlagRequestAction;
               _loc52_ = new TreasureHuntFlagRequestMessage();
               _loc52_.initTreasureHuntFlagRequestMessage(_loc51_.questType,_loc51_.index);
               ConnectionsHandler.getConnection().send(_loc52_);
               return true;
            case param1 is TreasureHuntFlagRemoveRequestAction:
               _loc53_ = param1 as TreasureHuntFlagRemoveRequestAction;
               _loc54_ = new TreasureHuntFlagRemoveRequestMessage();
               _loc54_.initTreasureHuntFlagRemoveRequestMessage(_loc53_.questType,_loc53_.index);
               ConnectionsHandler.getConnection().send(_loc54_);
               return true;
            case param1 is TreasureHuntFlagRequestAnswerMessage:
               _loc55_ = param1 as TreasureHuntFlagRequestAnswerMessage;
               switch(_loc55_.result)
               {
                  case TreasureHuntFlagRequestEnum.TREASURE_HUNT_FLAG_OK:
                     break;
                  case TreasureHuntFlagRequestEnum.TREASURE_HUNT_FLAG_ERROR_UNDEFINED:
                  case TreasureHuntFlagRequestEnum.TREASURE_HUNT_FLAG_WRONG:
                  case TreasureHuntFlagRequestEnum.TREASURE_HUNT_FLAG_TOO_MANY:
                  case TreasureHuntFlagRequestEnum.TREASURE_HUNT_FLAG_ERROR_IMPOSSIBLE:
                  case TreasureHuntFlagRequestEnum.TREASURE_HUNT_FLAG_WRONG_INDEX:
                     _loc56_ = I18n.getUiText("ui.treasureHunt.flagFail");
                     break;
                  case TreasureHuntFlagRequestEnum.TREASURE_HUNT_FLAG_SAME_MAP:
                     _loc56_ = I18n.getUiText("ui.treasureHunt.flagFailSameMap");
               }
               if(_loc56_)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc56_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is TreasureHuntMessage:
               _loc57_ = param1 as TreasureHuntMessage;
               Atouin.getInstance().setWorldMaskDimensions(StageShareManager.startWidth + AtouinConstants.CELL_HALF_WIDTH / 2,FrustumManager.getInstance().frustum.marginBottom,0,0.7,"treasureHinting");
               if(this._treasureHunts.length <= 0)
               {
                  Atouin.getInstance().toggleWorldMask("treasureHinting",true);
               }
               if(this._treasureHunts[_loc57_.questType] && this._treasureHunts[_loc57_.questType].stepList.length)
               {
                  _loc84_ = 0;
                  for each(_loc85_ in this._treasureHunts[_loc57_.questType].stepList)
                  {
                     if(_loc85_.flagState > -1)
                     {
                        _loc84_++;
                        if(!_loc58_)
                        {
                           _loc58_ = MapPosition.getMapPositionById(_loc85_.mapId);
                        }
                        if(_loc58_.worldMap > -1)
                        {
                           KernelEventsManager.getInstance().processCallback(HookList.RemoveMapFlag,"flag_hunt_" + _loc57_.questType + "_" + _loc84_,_loc58_.worldMap);
                        }
                     }
                  }
               }
               _loc59_ = TreasureHuntWrapper.create(_loc57_.questType,_loc57_.startMapId,_loc57_.checkPointCurrent,_loc57_.checkPointTotal,_loc57_.totalStepCount,_loc57_.availableRetryCount,_loc57_.knownStepsList,_loc57_.flags);
               this._treasureHunts[_loc57_.questType] = _loc59_;
               _loc60_ = 0;
               for each(_loc86_ in _loc57_.flags)
               {
                  _loc60_++;
                  _loc58_ = MapPosition.getMapPositionById(_loc86_.mapId);
                  if(_loc58_.worldMap > -1)
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.AddMapFlag,"flag_hunt_" + _loc57_.questType + "_" + _loc60_,I18n.getUiText("ui.treasureHunt.huntType" + _loc57_.questType) + " - " + I18n.getUiText("ui.treasureHunt.hint",[_loc60_]) + " [" + _loc58_.posX + "," + _loc58_.posY + "]",_loc58_.worldMap,_loc58_.posX,_loc58_.posY,this._flagColors[_loc86_.state],false,false,false);
                  }
               }
               KernelEventsManager.getInstance().processCallback(QuestHookList.TreasureHuntUpdate,_loc59_.questType);
               return true;
            case param1 is TreasureHuntAvailableRetryCountUpdateMessage:
               _loc61_ = param1 as TreasureHuntAvailableRetryCountUpdateMessage;
               this._treasureHunts[_loc61_.questType].availableRetryCount = _loc61_.availableRetryCount;
               KernelEventsManager.getInstance().processCallback(QuestHookList.TreasureHuntAvailableRetryCountUpdate,_loc61_.questType,_loc61_.availableRetryCount);
               return true;
            case param1 is TreasureHuntFinishedMessage:
               _loc62_ = param1 as TreasureHuntFinishedMessage;
               if(this._treasureHunts[_loc62_.questType])
               {
                  if(this._treasureHunts[_loc62_.questType].stepList.length)
                  {
                     _loc84_ = 0;
                     for each(_loc85_ in this._treasureHunts[_loc62_.questType].stepList)
                     {
                        if(_loc85_.flagState > -1)
                        {
                           _loc84_++;
                           if(!_loc58_)
                           {
                              _loc58_ = MapPosition.getMapPositionById(_loc85_.mapId);
                           }
                           if(_loc58_.worldMap > -1)
                           {
                              KernelEventsManager.getInstance().processCallback(HookList.RemoveMapFlag,"flag_hunt_" + _loc62_.questType + "_" + _loc84_,_loc58_.worldMap);
                           }
                        }
                     }
                  }
                  this._treasureHunts[_loc62_.questType] = null;
                  delete this._treasureHunts[_loc62_.questType];
                  if(!this.hasTreasureHunt())
                  {
                     Atouin.getInstance().toggleWorldMask("treasureHinting",false);
                  }
                  KernelEventsManager.getInstance().processCallback(QuestHookList.TreasureHuntFinished,_loc62_.questType);
               }
               return true;
            case param1 is TreasureHuntGiveUpRequestAction:
               _loc63_ = param1 as TreasureHuntGiveUpRequestAction;
               _loc64_ = new TreasureHuntGiveUpRequestMessage();
               _loc64_.initTreasureHuntGiveUpRequestMessage(_loc63_.questType);
               ConnectionsHandler.getConnection().send(_loc64_);
               return true;
            case param1 is TreasureHuntDigRequestAction:
               _loc65_ = param1 as TreasureHuntDigRequestAction;
               _loc66_ = new TreasureHuntDigRequestMessage();
               _loc66_.initTreasureHuntDigRequestMessage(_loc65_.questType);
               ConnectionsHandler.getConnection().send(_loc66_);
               return true;
            case param1 is TreasureHuntDigRequestAnswerMessage:
               _loc67_ = param1 as TreasureHuntDigRequestAnswerMessage;
               if(_loc67_ is TreasureHuntDigRequestAnswerFailedMessage)
               {
                  _loc68_ = (_loc67_ as TreasureHuntDigRequestAnswerFailedMessage).wrongFlagCount;
               }
               if(_loc67_.result == TreasureHuntDigRequestEnum.TREASURE_HUNT_DIG_ERROR_IMPOSSIBLE)
               {
                  _loc69_ = I18n.getUiText("ui.fight.wrongMap");
               }
               else if(_loc67_.result == TreasureHuntDigRequestEnum.TREASURE_HUNT_DIG_ERROR_UNDEFINED)
               {
                  _loc69_ = I18n.getUiText("ui.popup.impossible_action");
               }
               else if(_loc67_.result == TreasureHuntDigRequestEnum.TREASURE_HUNT_DIG_LOST)
               {
                  _loc69_ = I18n.getUiText("ui.treasureHunt.huntFail");
               }
               else if(_loc67_.result == TreasureHuntDigRequestEnum.TREASURE_HUNT_DIG_NEW_HINT)
               {
                  _loc69_ = I18n.getUiText("ui.treasureHunt.stepSuccess");
               }
               else if(_loc67_.result == TreasureHuntDigRequestEnum.TREASURE_HUNT_DIG_WRONG)
               {
                  if(_loc68_ > 1)
                  {
                     _loc69_ = I18n.getUiText("ui.treasureHunt.digWrongFlags",[_loc68_]);
                  }
                  else if(_loc68_ > 0)
                  {
                     _loc69_ = I18n.getUiText("ui.treasureHunt.digWrongFlag");
                  }
                  else
                  {
                     _loc69_ = I18n.getUiText("ui.treasureHunt.digFail");
                  }
               }
               else if(_loc67_.result == TreasureHuntDigRequestEnum.TREASURE_HUNT_DIG_WRONG_AND_YOU_KNOW_IT)
               {
                  _loc69_ = I18n.getUiText("ui.treasureHunt.noNewFlag");
               }
               else if(_loc67_.result == TreasureHuntDigRequestEnum.TREASURE_HUNT_DIG_FINISHED)
               {
                  if(_loc67_.questType == TreasureHuntTypeEnum.TREASURE_HUNT_CLASSIC)
                  {
                     _loc69_ = I18n.getUiText("ui.treasureHunt.huntSuccess");
                  }
               }
               if(_loc69_)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc69_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function hasTreasureHunt() : Boolean
      {
         var _loc1_:* = undefined;
         for(_loc1_ in this._treasureHunts)
         {
            if(_loc1_ != null)
            {
               return true;
            }
         }
         return false;
      }
   }
}
