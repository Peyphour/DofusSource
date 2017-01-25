package com.ankamagames.dofus.logic.game.common.misc
{
   import avmplus.getQualifiedClassName;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionType;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.messages.common.basic.BasicStatMessage;
   import com.ankamagames.dofus.network.messages.common.basic.BasicStatWithDataMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailedListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementDetailsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.AchievementRewardRequestMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.FriendGuildSetWarnOnAchievementCompleteMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceBulletinSetRequestMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceChangeGuildRightsMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceCreationValidMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceFactsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceInsiderInfoRequestMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceInvitationAnswerMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceInvitationMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceKickRequestMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceModificationEmblemValidMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceModificationNameAndTagValidMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceModificationValidMessage;
   import com.ankamagames.dofus.network.messages.game.alliance.AllianceMotdSetRequestMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicWhoIsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.basic.NumericWhoIsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.character.status.PlayerStatusUpdateRequestMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatClientMultiMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatClientMultiWithObjectMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatClientPrivateMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatClientPrivateWithObjectMessage;
   import com.ankamagames.dofus.network.messages.game.chat.channel.ChannelEnablingMessage;
   import com.ankamagames.dofus.network.messages.game.chat.smiley.MoodSmileyRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountHarnessColorsUpdateRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountHarnessDissociateRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountInformationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.MountSetXpRatioRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationResetMessage;
   import com.ankamagames.dofus.network.messages.game.context.notification.NotificationUpdateFlagMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryDefineSettingsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryEntryRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobCrafterDirectoryListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcDialogReplyMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcGenericActionRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.DungeonPartyFinderAvailableDungeonsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.DungeonPartyFinderListenRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.DungeonPartyFinderRegisterRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyAbdicateThroneMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyAcceptInvitationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyCancelInvitationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyFollowMemberRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyFollowThisMemberRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyInvitationArenaRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyInvitationDetailsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyInvitationDungeonRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyInvitationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyKickRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyLeaveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyLocateMembersRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyNameSetRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyPledgeLoyaltyRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyRefuseInvitationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyStopFollowRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.GuidedModeQuitRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.GuidedModeReturnRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestObjectiveValidationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStartRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.quest.QuestStepInfoRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellModifyRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.stats.StatsUpgradeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.PortalUseRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntDigRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntFlagRemoveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntFlagRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntGiveUpRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntLegendaryRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.TreasureHuntRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendJoinRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendSetWarnOnConnectionMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendSetWarnOnLevelGainMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendSpouseFollowWithCompassRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendSpouseJoinRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.GuildMemberSetWarnOnConnectionMessage;
   import com.ankamagames.dofus.network.messages.game.friend.SpouseGetInformationsMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildBulletinSetRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildChangeMemberParametersMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildCharacsUpgradeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildCreationValidMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildFactsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildGetInformationsMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildHouseTeleportRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationAnswerMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationByNameMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildKickRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildModificationEmblemValidMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildModificationNameValidMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildModificationValidMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildMotdSetRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildPaddockTeleportRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildSpellUpgradeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GameRolePlayTaxCollectorFightRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightJoinRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightLeaveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightTakePlaceRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.ObjectAveragePricesGetMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.JobBookSubscribeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.look.AccessoryPreviewRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismAttackRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightJoinLeaveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightSwapRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismInfoJoinLeaveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismModuleExchangeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismSetSabotagedRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismSettingsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismUseRequestMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismsListRegisterMessage;
   import com.ankamagames.dofus.network.messages.game.social.ContactLookRequestByIdMessage;
   import com.ankamagames.dofus.network.messages.game.social.ContactLookRequestByNameMessage;
   import com.ankamagames.dofus.network.messages.game.tinsel.OrnamentSelectRequestMessage;
   import com.ankamagames.dofus.network.messages.game.tinsel.TitleSelectRequestMessage;
   import com.ankamagames.dofus.network.messages.security.ClientKeyMessage;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterNamedInformations;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.network.IMessageRouter;
   import com.ankamagames.jerakine.network.INetworkMessage;
   
   public class KoliseumMessageRouter implements IMessageRouter
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(KoliseumMessageRouter));
       
      
      private var _fightersIds:Vector.<Number>;
      
      private var _fightersNames:Vector.<String>;
      
      public function KoliseumMessageRouter()
      {
         super();
      }
      
      public function getConnectionId(param1:INetworkMessage) : String
      {
         var _loc3_:ChatClientMultiMessage = null;
         var _loc4_:ChatClientPrivateMessage = null;
         var _loc5_:BasicWhoIsRequestMessage = null;
         var _loc6_:NumericWhoIsRequestMessage = null;
         var _loc7_:ContactLookRequestByNameMessage = null;
         var _loc8_:ContactLookRequestByIdMessage = null;
         var _loc2_:String = ConnectionType.TO_KOLI_SERVER;
         switch(true)
         {
            case param1 is ChatClientMultiMessage:
            case param1 is ChatClientMultiWithObjectMessage:
               _loc3_ = param1 as ChatClientMultiMessage;
               if(_loc3_.channel != ChatActivableChannelsEnum.CHANNEL_ARENA && _loc3_.channel != ChatActivableChannelsEnum.CHANNEL_GLOBAL && _loc3_.channel != ChatActivableChannelsEnum.CHANNEL_TEAM)
               {
                  _loc2_ = ConnectionType.TO_GAME_SERVER;
               }
               break;
            case param1 is ChatClientPrivateMessage:
            case param1 is ChatClientPrivateWithObjectMessage:
               _loc4_ = param1 as ChatClientPrivateMessage;
               if(!this.isPlayerNameInFight(_loc4_.receiver))
               {
                  _loc2_ = ConnectionType.TO_GAME_SERVER;
               }
               break;
            case param1 is BasicWhoIsRequestMessage:
               _loc5_ = param1 as BasicWhoIsRequestMessage;
               if(!this.isPlayerNameInFight(_loc5_.search))
               {
                  _loc2_ = ConnectionType.TO_GAME_SERVER;
               }
               break;
            case param1 is NumericWhoIsRequestMessage:
               _loc6_ = param1 as NumericWhoIsRequestMessage;
               if(!this.isPlayerIdInFight(_loc6_.playerId))
               {
                  _loc2_ = ConnectionType.TO_GAME_SERVER;
               }
               break;
            case param1 is ContactLookRequestByNameMessage:
               _loc7_ = param1 as ContactLookRequestByNameMessage;
               if(!this.isPlayerNameInFight(_loc7_.playerName))
               {
                  _loc2_ = ConnectionType.TO_GAME_SERVER;
               }
               break;
            case param1 is ContactLookRequestByIdMessage:
               _loc8_ = param1 as ContactLookRequestByIdMessage;
               if(!this.isPlayerIdInFight(_loc8_.playerId))
               {
                  _loc2_ = ConnectionType.TO_GAME_SERVER;
               }
               break;
            case param1 is ChannelEnablingMessage:
            case param1 is PlayerStatusUpdateRequestMessage:
            case param1 is SpellModifyRequestMessage:
            case param1 is StatsUpgradeRequestMessage:
            case param1 is MountSetXpRatioRequestMessage:
               _loc2_ = ConnectionType.TO_ALL_SERVERS;
               break;
            case param1 is MoodSmileyRequestMessage:
            case param1 is ClientKeyMessage:
            case param1 is BasicStatMessage:
            case param1 is BasicStatWithDataMessage:
            case param1 is AchievementDetailsRequestMessage:
            case param1 is AchievementDetailedListRequestMessage:
            case param1 is AchievementRewardRequestMessage:
            case param1 is FriendGuildSetWarnOnAchievementCompleteMessage:
            case param1 is PartyInvitationRequestMessage:
            case param1 is PartyInvitationDungeonRequestMessage:
            case param1 is PartyInvitationArenaRequestMessage:
            case param1 is PartyInvitationDetailsRequestMessage:
            case param1 is PartyAcceptInvitationMessage:
            case param1 is PartyRefuseInvitationMessage:
            case param1 is PartyCancelInvitationMessage:
            case param1 is PartyAbdicateThroneMessage:
            case param1 is PartyFollowMemberRequestMessage:
            case param1 is PartyFollowThisMemberRequestMessage:
            case param1 is PartyStopFollowRequestMessage:
            case param1 is PartyLocateMembersRequestMessage:
            case param1 is PartyLeaveRequestMessage:
            case param1 is PartyKickRequestMessage:
            case param1 is PartyPledgeLoyaltyRequestMessage:
            case param1 is PartyNameSetRequestMessage:
            case param1 is DungeonPartyFinderAvailableDungeonsRequestMessage:
            case param1 is DungeonPartyFinderListenRequestMessage:
            case param1 is DungeonPartyFinderRegisterRequestMessage:
            case param1 is SpouseGetInformationsMessage:
            case param1 is FriendSetWarnOnConnectionMessage:
            case param1 is FriendSetWarnOnLevelGainMessage:
            case param1 is FriendJoinRequestMessage:
            case param1 is FriendSpouseJoinRequestMessage:
            case param1 is FriendSpouseFollowWithCompassRequestMessage:
            case param1 is AllianceCreationValidMessage:
            case param1 is AllianceModificationEmblemValidMessage:
            case param1 is AllianceModificationNameAndTagValidMessage:
            case param1 is AllianceModificationValidMessage:
            case param1 is AllianceInvitationMessage:
            case param1 is AllianceInvitationAnswerMessage:
            case param1 is AllianceKickRequestMessage:
            case param1 is AllianceFactsRequestMessage:
            case param1 is AllianceChangeGuildRightsMessage:
            case param1 is AllianceInsiderInfoRequestMessage:
            case param1 is AllianceMotdSetRequestMessage:
            case param1 is AllianceBulletinSetRequestMessage:
            case param1 is GuildGetInformationsMessage:
            case param1 is GuildModificationNameValidMessage:
            case param1 is GuildModificationEmblemValidMessage:
            case param1 is GuildModificationValidMessage:
            case param1 is GuildCreationValidMessage:
            case param1 is GuildInvitationMessage:
            case param1 is GuildInvitationByNameMessage:
            case param1 is GuildInvitationAnswerMessage:
            case param1 is GuildKickRequestMessage:
            case param1 is GuildChangeMemberParametersMessage:
            case param1 is GuildSpellUpgradeRequestMessage:
            case param1 is GuildCharacsUpgradeRequestMessage:
            case param1 is GuildPaddockTeleportRequestMessage:
            case param1 is GuildHouseTeleportRequestMessage:
            case param1 is GuildMemberSetWarnOnConnectionMessage:
            case param1 is GuildMotdSetRequestMessage:
            case param1 is GuildBulletinSetRequestMessage:
            case param1 is GuildFactsRequestMessage:
            case param1 is GameRolePlayTaxCollectorFightRequestMessage:
            case param1 is GuildFightJoinRequestMessage:
            case param1 is GuildFightTakePlaceRequestMessage:
            case param1 is GuildFightLeaveRequestMessage:
            case param1 is PrismFightJoinLeaveRequestMessage:
            case param1 is PrismSetSabotagedRequestMessage:
            case param1 is PrismFightSwapRequestMessage:
            case param1 is PrismInfoJoinLeaveRequestMessage:
            case param1 is PrismUseRequestMessage:
            case param1 is PrismAttackRequestMessage:
            case param1 is PrismsListRegisterMessage:
            case param1 is PrismSettingsRequestMessage:
            case param1 is PrismModuleExchangeRequestMessage:
            case param1 is QuestListRequestMessage:
            case param1 is QuestStartRequestMessage:
            case param1 is QuestStepInfoRequestMessage:
            case param1 is QuestObjectiveValidationMessage:
            case param1 is GuidedModeReturnRequestMessage:
            case param1 is GuidedModeQuitRequestMessage:
            case param1 is NotificationUpdateFlagMessage:
            case param1 is NotificationResetMessage:
            case param1 is NpcGenericActionRequestMessage:
            case param1 is NpcDialogReplyMessage:
            case param1 is JobCrafterDirectoryListRequestMessage:
            case param1 is JobCrafterDirectoryDefineSettingsMessage:
            case param1 is JobCrafterDirectoryEntryRequestMessage:
            case param1 is JobBookSubscribeRequestMessage:
            case param1 is ObjectAveragePricesGetMessage:
            case param1 is MountInformationRequestMessage:
            case param1 is MountHarnessDissociateRequestMessage:
            case param1 is MountHarnessColorsUpdateRequestMessage:
            case param1 is TitleSelectRequestMessage:
            case param1 is OrnamentSelectRequestMessage:
            case param1 is AccessoryPreviewRequestMessage:
            case param1 is TreasureHuntRequestMessage:
            case param1 is TreasureHuntLegendaryRequestMessage:
            case param1 is TreasureHuntDigRequestMessage:
            case param1 is TreasureHuntFlagRequestMessage:
            case param1 is TreasureHuntFlagRemoveRequestMessage:
            case param1 is TreasureHuntGiveUpRequestMessage:
            case param1 is PortalUseRequestMessage:
               _loc2_ = ConnectionType.TO_GAME_SERVER;
         }
         return _loc2_;
      }
      
      private function isPlayerNameInFight(param1:String) : Boolean
      {
         if(!this._fightersNames || this._fightersNames.length == 0)
         {
            this.updateFighters();
         }
         if(this._fightersNames.indexOf(param1.toLocaleUpperCase()) != -1)
         {
            return true;
         }
         return false;
      }
      
      private function isPlayerIdInFight(param1:Number) : Boolean
      {
         if(!this._fightersNames || this._fightersNames.length == 0)
         {
            this.updateFighters();
         }
         if(this._fightersIds.indexOf(param1) != -1)
         {
            return true;
         }
         return false;
      }
      
      private function updateFighters() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:GameFightFighterNamedInformations = null;
         this._fightersIds = new Vector.<Number>();
         this._fightersNames = new Vector.<String>();
         var _loc1_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         if(_loc1_)
         {
            this._fightersIds = _loc1_.getEntitiesIdsList();
            for each(_loc2_ in this._fightersIds)
            {
               _loc3_ = _loc1_.getEntityInfos(_loc2_) as GameFightFighterNamedInformations;
               if(_loc3_)
               {
                  this._fightersNames.push(_loc3_.name.toLocaleUpperCase());
               }
            }
         }
      }
   }
}
