package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.actions.craft.JobBookSubscribeRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterContactLookRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterDirectoryDefineSettingsAction;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterDirectoryEntryRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.jobs.JobCrafterDirectoryListRequestAction;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.SocialContactCategoryEnum;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobBookSubscriptionMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryDefineSettingsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryEntryRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectorySettingsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobDescriptionMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobExperienceMultiUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobExperienceOtherPlayerUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobExperienceUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobLevelUpMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkJobIndexMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.JobBookSubscribeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.social.ContactLookRequestByIdMessage;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobBookSubscription;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectorySettings;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobDescription;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobExperience;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.getQualifiedClassName;
   
   public class JobsFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(JobsFrame));
       
      
      private var _jobCrafterDirectoryListDialogFrame:JobCrafterDirectoryListDialogFrame;
      
      private var _settings:Array;
      
      public function JobsFrame()
      {
         this._settings = new Array();
         super();
      }
      
      private static function updateJobExperience(param1:JobExperience) : void
      {
         var _loc2_:KnownJobWrapper = PlayedCharacterManager.getInstance().jobs[param1.jobId];
         if(!_loc2_)
         {
            _loc2_ = KnownJobWrapper.create(param1.jobId);
            PlayedCharacterManager.getInstance().jobs[param1.jobId] = _loc2_;
         }
         _loc2_.jobLevel = param1.jobLevel;
         _loc2_.jobXP = param1.jobXP;
         _loc2_.jobXpLevelFloor = param1.jobXpLevelFloor;
         _loc2_.jobXpNextLevelFloor = param1.jobXpNextLevelFloor;
      }
      
      private static function createCrafterDirectorySettings(param1:JobCrafterDirectorySettings) : Object
      {
         var _loc2_:Object = new Object();
         _loc2_.jobId = param1.jobId;
         _loc2_.minLevel = param1.minLevel;
         _loc2_.free = param1.free;
         return _loc2_;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get settings() : Array
      {
         return this._settings;
      }
      
      public function pushed() : Boolean
      {
         this._jobCrafterDirectoryListDialogFrame = new JobCrafterDirectoryListDialogFrame();
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:JobDescriptionMessage = null;
         var _loc3_:JobCrafterDirectorySettingsMessage = null;
         var _loc4_:JobCrafterDirectoryDefineSettingsAction = null;
         var _loc5_:JobCrafterDirectoryDefineSettingsMessage = null;
         var _loc6_:JobExperienceOtherPlayerUpdateMessage = null;
         var _loc7_:JobExperienceUpdateMessage = null;
         var _loc8_:JobExperienceMultiUpdateMessage = null;
         var _loc9_:JobLevelUpMessage = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:KnownJobWrapper = null;
         var _loc13_:JobBookSubscribeRequestAction = null;
         var _loc14_:JobBookSubscribeRequestMessage = null;
         var _loc15_:JobBookSubscriptionMessage = null;
         var _loc16_:JobBookSubscription = null;
         var _loc17_:Boolean = false;
         var _loc18_:Boolean = false;
         var _loc19_:String = null;
         var _loc20_:JobCrafterDirectoryListRequestAction = null;
         var _loc21_:JobCrafterDirectoryListRequestMessage = null;
         var _loc22_:JobCrafterDirectoryEntryRequestAction = null;
         var _loc23_:JobCrafterDirectoryEntryRequestMessage = null;
         var _loc24_:JobCrafterContactLookRequestAction = null;
         var _loc25_:ExchangeStartOkJobIndexMessage = null;
         var _loc26_:Array = null;
         var _loc27_:JobDescription = null;
         var _loc28_:KnownJobWrapper = null;
         var _loc29_:JobCrafterDirectorySettings = null;
         var _loc30_:JobExperience = null;
         var _loc31_:KnownJobWrapper = null;
         var _loc32_:Job = null;
         var _loc33_:ContactLookRequestByIdMessage = null;
         var _loc34_:uint = 0;
         switch(true)
         {
            case param1 is JobDescriptionMessage:
               _loc2_ = param1 as JobDescriptionMessage;
               PlayedCharacterManager.getInstance().jobs = new Array();
               for each(_loc27_ in _loc2_.jobsDescription)
               {
                  if(_loc27_)
                  {
                     _loc28_ = KnownJobWrapper.create(_loc27_.jobId);
                     _loc28_.jobDescription = _loc27_;
                     PlayedCharacterManager.getInstance().jobs[_loc27_.jobId] = _loc28_;
                  }
               }
               KernelEventsManager.getInstance().processCallback(HookList.JobsListUpdated);
               return true;
            case param1 is JobCrafterDirectorySettingsMessage:
               _loc3_ = param1 as JobCrafterDirectorySettingsMessage;
               for each(_loc29_ in _loc3_.craftersSettings)
               {
                  this._settings[_loc29_.jobId] = createCrafterDirectorySettings(_loc29_);
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.CrafterDirectorySettings,this._settings);
               return true;
            case param1 is JobCrafterDirectoryDefineSettingsAction:
               _loc4_ = param1 as JobCrafterDirectoryDefineSettingsAction;
               _loc5_ = new JobCrafterDirectoryDefineSettingsMessage();
               _loc5_.initJobCrafterDirectoryDefineSettingsMessage(_loc4_.settings);
               ConnectionsHandler.getConnection().send(_loc5_);
               return true;
            case param1 is JobExperienceOtherPlayerUpdateMessage:
               _loc6_ = param1 as JobExperienceOtherPlayerUpdateMessage;
               KernelEventsManager.getInstance().processCallback(CraftHookList.JobsExpOtherPlayerUpdated,_loc6_.playerId,_loc6_.experiencesUpdate);
               return true;
            case param1 is JobExperienceUpdateMessage:
               _loc7_ = param1 as JobExperienceUpdateMessage;
               updateJobExperience(_loc7_.experiencesUpdate);
               KernelEventsManager.getInstance().processCallback(CraftHookList.JobsExpUpdated,_loc7_.experiencesUpdate.jobId);
               return true;
            case param1 is JobExperienceMultiUpdateMessage:
               _loc8_ = param1 as JobExperienceMultiUpdateMessage;
               for each(_loc30_ in _loc8_.experiencesUpdate)
               {
                  updateJobExperience(_loc30_);
               }
               KernelEventsManager.getInstance().processCallback(CraftHookList.JobsExpUpdated,0);
               return true;
            case param1 is JobLevelUpMessage:
               _loc9_ = param1 as JobLevelUpMessage;
               _loc10_ = Job.getJobById(_loc9_.jobsDescription.jobId).name;
               _loc11_ = I18n.getUiText("ui.craft.newJobLevel",[_loc10_,_loc9_.newLevel]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc11_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               _loc12_ = PlayedCharacterManager.getInstance().jobs[_loc9_.jobsDescription.jobId];
               _loc12_.jobDescription = _loc9_.jobsDescription;
               _loc12_.jobLevel = _loc9_.newLevel;
               KernelEventsManager.getInstance().processCallback(CraftHookList.JobLevelUp,_loc9_.jobsDescription.jobId,_loc10_,_loc9_.newLevel);
               return true;
            case param1 is JobBookSubscribeRequestAction:
               _loc13_ = param1 as JobBookSubscribeRequestAction;
               _loc14_ = new JobBookSubscribeRequestMessage();
               _loc14_.initJobBookSubscribeRequestMessage(_loc13_.jobIds);
               ConnectionsHandler.getConnection().send(_loc14_);
               return true;
            case param1 is JobBookSubscriptionMessage:
               _loc15_ = param1 as JobBookSubscriptionMessage;
               for each(_loc16_ in _loc15_.subscriptions)
               {
                  PlayedCharacterManager.getInstance().jobs[_loc16_.jobId].jobBookSubscriber = _loc16_.subscribed;
                  KernelEventsManager.getInstance().processCallback(CraftHookList.JobBookSubscription,_loc16_.jobId,_loc16_.subscribed);
               }
               _loc17_ = true;
               _loc18_ = _loc15_.subscriptions[0].subscribed;
               for each(_loc31_ in PlayedCharacterManager.getInstance().jobs)
               {
                  if(_loc31_.jobBookSubscriber != _loc18_)
                  {
                     _loc17_ = false;
                     break;
                  }
               }
               if(!_loc17_)
               {
                  for each(_loc16_ in _loc15_.subscriptions)
                  {
                     _loc32_ = Job.getJobById(_loc16_.jobId);
                     if(_loc16_.subscribed)
                     {
                        _loc19_ = I18n.getUiText("ui.craft.referenceAdd",[_loc32_.name]);
                     }
                     else
                     {
                        _loc19_ = I18n.getUiText("ui.craft.referenceRemove",[_loc32_.name]);
                     }
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc19_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
               }
               else
               {
                  if(_loc18_)
                  {
                     _loc19_ = I18n.getUiText("ui.craft.referenceAddAll");
                  }
                  else
                  {
                     _loc19_ = I18n.getUiText("ui.craft.referenceRemoveAll");
                  }
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc19_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is JobCrafterDirectoryListRequestAction:
               _loc20_ = param1 as JobCrafterDirectoryListRequestAction;
               _loc21_ = new JobCrafterDirectoryListRequestMessage();
               _loc21_.initJobCrafterDirectoryListRequestMessage(_loc20_.jobId);
               ConnectionsHandler.getConnection().send(_loc21_);
               return true;
            case param1 is JobCrafterDirectoryEntryRequestAction:
               _loc22_ = param1 as JobCrafterDirectoryEntryRequestAction;
               _loc23_ = new JobCrafterDirectoryEntryRequestMessage();
               _loc23_.initJobCrafterDirectoryEntryRequestMessage(_loc22_.playerId);
               ConnectionsHandler.getConnection().send(_loc5_);
               return true;
            case param1 is JobCrafterContactLookRequestAction:
               _loc24_ = param1 as JobCrafterContactLookRequestAction;
               if(_loc24_.crafterId == PlayedCharacterManager.getInstance().id)
               {
                  KernelEventsManager.getInstance().processCallback(CraftHookList.JobCrafterContactLook,_loc24_.crafterId,PlayedCharacterManager.getInstance().infos.name,EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook));
               }
               else
               {
                  _loc33_ = new ContactLookRequestByIdMessage();
                  _loc33_.initContactLookRequestByIdMessage(0,SocialContactCategoryEnum.SOCIAL_CONTACT_CRAFTER,_loc24_.crafterId);
                  ConnectionsHandler.getConnection().send(_loc33_);
               }
               return true;
            case param1 is ExchangeStartOkJobIndexMessage:
               _loc25_ = param1 as ExchangeStartOkJobIndexMessage;
               _loc26_ = new Array();
               for each(_loc34_ in _loc25_.jobs)
               {
                  _loc26_.push(_loc34_);
               }
               Kernel.getWorker().addFrame(this._jobCrafterDirectoryListDialogFrame);
               KernelEventsManager.getInstance().processCallback(CraftHookList.ExchangeStartOkJobIndex,_loc26_);
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
