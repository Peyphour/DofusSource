package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.externalnotification.ExternalNotificationManager;
   import com.ankamagames.dofus.externalnotification.enums.ExternalNotificationTypeEnum;
   import com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildFactSheetWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildHouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.SocialEntityInFightWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.SocialFightersWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.EnemyWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.FriendWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.IgnoredWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.SpouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.AccountManager;
   import com.ankamagames.dofus.logic.common.managers.NotificationManager;
   import com.ankamagames.dofus.logic.game.common.actions.ContactLookRequestByIdAction;
   import com.ankamagames.dofus.logic.game.common.actions.OpenSocialAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildBulletinSetRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildChangeMemberParametersAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildCharacsUpgradeRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildFactsRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildFarmTeleportRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildFightJoinRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildFightLeaveRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildFightTakePlaceRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildGetInformationsAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildHouseTeleportRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildInvitationAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildInvitationByNameAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildKickRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildMotdSetRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.guild.GuildSpellUpgradeRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.AddEnemyAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.AddFriendAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.AddIgnoredAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.CharacterReportAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.ChatReportAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.EnemiesListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.FriendGuildSetWarnOnAchievementCompleteAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.FriendOrGuildMemberLevelUpWarningSetAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.FriendSpouseFollowAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.FriendWarningSetAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.FriendsListRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.JoinFriendAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.JoinSpouseAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.MemberWarningSetAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.PlayerStatusUpdateRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.RemoveEnemyAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.RemoveFriendAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.RemoveIgnoredAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.SpouseRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.social.WarnOnHardcoreDeathAction;
   import com.ankamagames.dofus.logic.game.common.managers.ChatAutocompleteNameManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TaxCollectorsManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.dofus.network.ProtocolConstantsEnum;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.CompassTypeEnum;
   import com.ankamagames.dofus.network.enums.GuildInformationsTypeEnum;
   import com.ankamagames.dofus.network.enums.ListAddFailureEnum;
   import com.ankamagames.dofus.network.enums.PlayerStateEnum;
   import com.ankamagames.dofus.network.enums.SocialGroupCreationResultEnum;
   import com.ankamagames.dofus.network.enums.SocialGroupInvitationStateEnum;
   import com.ankamagames.dofus.network.enums.SocialNoticeErrorEnum;
   import com.ankamagames.dofus.network.enums.TaxCollectorErrorReasonEnum;
   import com.ankamagames.dofus.network.enums.TaxCollectorMovementTypeEnum;
   import com.ankamagames.dofus.network.enums.TaxCollectorStateEnum;
   import com.ankamagames.dofus.network.messages.game.achievement.FriendGuildSetWarnOnAchievementCompleteMessage;
   import com.ankamagames.dofus.network.messages.game.achievement.FriendGuildWarnOnAchievementCompleteStateMessage;
   import com.ankamagames.dofus.network.messages.game.character.status.PlayerStatusUpdateErrorMessage;
   import com.ankamagames.dofus.network.messages.game.character.status.PlayerStatusUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.character.status.PlayerStatusUpdateRequestMessage;
   import com.ankamagames.dofus.network.messages.game.chat.report.ChatMessageReportMessage;
   import com.ankamagames.dofus.network.messages.game.chat.smiley.MoodSmileyUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.death.WarnOnPermaDeathMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.AllianceTaxCollectorDialogQuestionExtendedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.TaxCollectorDialogQuestionBasicMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.TaxCollectorDialogQuestionExtendedMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendAddFailureMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendAddRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendAddedMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendDeleteRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendDeleteResultMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendJoinRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendSetWarnOnConnectionMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendSetWarnOnLevelGainMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendSpouseFollowWithCompassRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendSpouseJoinRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendWarnOnConnectionStateMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendWarnOnLevelGainStateMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendsGetListMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendsListMessage;
   import com.ankamagames.dofus.network.messages.game.friend.GuildMemberSetWarnOnConnectionMessage;
   import com.ankamagames.dofus.network.messages.game.friend.GuildMemberWarnOnConnectionStateMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredAddFailureMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredAddRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredAddedMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredDeleteRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredDeleteResultMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredGetListMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredListMessage;
   import com.ankamagames.dofus.network.messages.game.friend.SpouseGetInformationsMessage;
   import com.ankamagames.dofus.network.messages.game.friend.SpouseInformationsMessage;
   import com.ankamagames.dofus.network.messages.game.friend.SpouseStatusMessage;
   import com.ankamagames.dofus.network.messages.game.friend.WarnOnPermaDeathStateMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildBulletinMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildBulletinSetErrorMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildBulletinSetRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildChangeMemberParametersMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildCharacsUpgradeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildCreationResultMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildCreationStartedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildFactsErrorMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildFactsMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildFactsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildGetInformationsMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildHouseRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildHouseTeleportRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildHouseUpdateInformationMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildHousesInformationMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInAllianceFactsMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInformationsGeneralMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInformationsMemberUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInformationsMembersMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInformationsPaddocksMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInfosUpgradeMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationByNameMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationStateRecrutedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitationStateRecruterMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildInvitedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildJoinedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildKickRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildLeftMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildMemberLeavingMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildMemberOnlineStatusMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildMembershipMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildModificationStartedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildMotdMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildMotdSetErrorMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildMotdSetRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildPaddockBoughtMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildPaddockRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildPaddockTeleportRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.GuildSpellUpgradeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightJoinRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightLeaveRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightPlayersEnemiesListMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightPlayersEnemyRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightPlayersHelpersJoinMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightPlayersHelpersLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightTakePlaceRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorAttackedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorAttackedResultMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorErrorMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorListMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorMovementAddMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorMovementMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorMovementRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorMovementsOfflineMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TaxCollectorStateUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.TopTaxCollectorListMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeGuildTaxCollectorGetMessage;
   import com.ankamagames.dofus.network.messages.game.report.CharacterReportMessage;
   import com.ankamagames.dofus.network.messages.game.social.ContactLookErrorMessage;
   import com.ankamagames.dofus.network.messages.game.social.ContactLookMessage;
   import com.ankamagames.dofus.network.messages.game.social.ContactLookRequestByIdMessage;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalPlusLookInformations;
   import com.ankamagames.dofus.network.types.game.character.status.PlayerStatus;
   import com.ankamagames.dofus.network.types.game.character.status.PlayerStatusExtended;
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemGenericQuantity;
   import com.ankamagames.dofus.network.types.game.friend.FriendInformations;
   import com.ankamagames.dofus.network.types.game.friend.FriendOnlineInformations;
   import com.ankamagames.dofus.network.types.game.friend.IgnoredOnlineInformations;
   import com.ankamagames.dofus.network.types.game.guild.GuildMember;
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorMovement;
   import com.ankamagames.dofus.network.types.game.house.HouseInformationsForGuild;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockContentInformations;
   import com.ankamagames.dofus.types.enums.NotificationTypeEnum;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class SocialFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SocialFrame));
      
      private static var _instance:SocialFrame;
       
      
      private var _guildDialogFrame:GuildDialogFrame;
      
      private var _friendsList:Array;
      
      private var _enemiesList:Array;
      
      private var _ignoredList:Array;
      
      private var _spouse:SpouseWrapper;
      
      private var _hasGuild:Boolean = false;
      
      private var _hasSpouse:Boolean = false;
      
      private var _guild:GuildWrapper;
      
      private var _guildMembers:Vector.<GuildMember>;
      
      private var _guildHouses:Vector.<GuildHouseWrapper>;
      
      private var _guildHousesList:Boolean = false;
      
      private var _guildHousesListUpdate:Boolean = false;
      
      private var _guildPaddocks:Vector.<PaddockContentInformations>;
      
      private var _guildPaddocksMax:int = 1;
      
      private var _upGuildEmblem:EmblemWrapper;
      
      private var _backGuildEmblem:EmblemWrapper;
      
      private var _warnOnFrienConnec:Boolean;
      
      private var _warnOnMemberConnec:Boolean;
      
      private var _warnWhenFriendOrGuildMemberLvlUp:Boolean;
      
      private var _warnWhenFriendOrGuildMemberAchieve:Boolean;
      
      private var _warnOnHardcoreDeath:Boolean;
      
      private var _autoLeaveHelpers:Boolean;
      
      private var _allGuilds:Dictionary;
      
      private var _socialDatFrame:SocialDataFrame;
      
      private var _dareFrame:DareFrame;
      
      private var _dungeonTopTaxCollectors:Vector.<TaxCollectorInformations>;
      
      private var _topTaxCollectors:Vector.<TaxCollectorInformations>;
      
      public function SocialFrame()
      {
         this._guildHouses = new Vector.<GuildHouseWrapper>();
         this._guildPaddocks = new Vector.<PaddockContentInformations>();
         this._allGuilds = new Dictionary(true);
         super();
      }
      
      public static function getInstance() : SocialFrame
      {
         return _instance;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get friendsList() : Array
      {
         return this._friendsList;
      }
      
      public function get enemiesList() : Array
      {
         return this._enemiesList;
      }
      
      public function get ignoredList() : Array
      {
         return this._ignoredList;
      }
      
      public function get spouse() : SpouseWrapper
      {
         return this._spouse;
      }
      
      public function get hasGuild() : Boolean
      {
         return this._hasGuild;
      }
      
      public function get hasSpouse() : Boolean
      {
         return this._hasSpouse;
      }
      
      public function get guild() : GuildWrapper
      {
         return this._guild;
      }
      
      public function get guildmembers() : Vector.<GuildMember>
      {
         return this._guildMembers;
      }
      
      public function get guildHouses() : Vector.<GuildHouseWrapper>
      {
         return this._guildHouses;
      }
      
      public function get guildPaddocks() : Vector.<PaddockContentInformations>
      {
         return this._guildPaddocks;
      }
      
      public function get maxGuildPaddocks() : int
      {
         return this._guildPaddocksMax;
      }
      
      public function get warnFriendConnec() : Boolean
      {
         return this._warnOnFrienConnec;
      }
      
      public function get warnMemberConnec() : Boolean
      {
         return this._warnOnMemberConnec;
      }
      
      public function get warnWhenFriendOrGuildMemberLvlUp() : Boolean
      {
         return this._warnWhenFriendOrGuildMemberLvlUp;
      }
      
      public function get warnWhenFriendOrGuildMemberAchieve() : Boolean
      {
         return this._warnWhenFriendOrGuildMemberAchieve;
      }
      
      public function get warnOnHardcoreDeath() : Boolean
      {
         return this._warnOnHardcoreDeath;
      }
      
      public function get guildHousesUpdateNeeded() : Boolean
      {
         return this._guildHousesListUpdate;
      }
      
      public function getGuildById(param1:int) : GuildFactSheetWrapper
      {
         return this._allGuilds[param1];
      }
      
      public function updateGuildById(param1:int, param2:GuildFactSheetWrapper) : void
      {
         this._allGuilds[param1] = param2;
      }
      
      public function pushed() : Boolean
      {
         _instance = this;
         this._enemiesList = new Array();
         this._ignoredList = new Array();
         this._socialDatFrame = new SocialDataFrame();
         this._guildDialogFrame = new GuildDialogFrame();
         this._dareFrame = new DareFrame();
         Kernel.getWorker().addFrame(this._socialDatFrame);
         Kernel.getWorker().addFrame(this._dareFrame);
         ConnectionsHandler.getConnection().send(new FriendsGetListMessage());
         ConnectionsHandler.getConnection().send(new IgnoredGetListMessage());
         ConnectionsHandler.getConnection().send(new SpouseGetInformationsMessage());
         return true;
      }
      
      public function pulled() : Boolean
      {
         _instance = null;
         TaxCollectorsManager.getInstance().destroy();
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:String = null;
         var _loc3_:GuildMembershipMessage = null;
         var _loc4_:FriendsListMessage = null;
         var _loc5_:SpouseRequestAction = null;
         var _loc6_:SpouseInformationsMessage = null;
         var _loc7_:IgnoredListMessage = null;
         var _loc8_:OpenSocialAction = null;
         var _loc9_:FriendsListRequestAction = null;
         var _loc10_:EnemiesListRequestAction = null;
         var _loc11_:AddFriendAction = null;
         var _loc12_:FriendAddedMessage = null;
         var _loc13_:FriendWrapper = null;
         var _loc14_:FriendAddFailureMessage = null;
         var _loc15_:AddEnemyAction = null;
         var _loc16_:IgnoredAddedMessage = null;
         var _loc17_:IgnoredAddFailureMessage = null;
         var _loc18_:String = null;
         var _loc19_:RemoveFriendAction = null;
         var _loc20_:FriendDeleteRequestMessage = null;
         var _loc21_:FriendDeleteResultMessage = null;
         var _loc22_:String = null;
         var _loc23_:FriendUpdateMessage = null;
         var _loc24_:FriendWrapper = null;
         var _loc25_:Boolean = false;
         var _loc26_:RemoveEnemyAction = null;
         var _loc27_:IgnoredDeleteRequestMessage = null;
         var _loc28_:IgnoredDeleteResultMessage = null;
         var _loc29_:AddIgnoredAction = null;
         var _loc30_:RemoveIgnoredAction = null;
         var _loc31_:IgnoredDeleteRequestMessage = null;
         var _loc32_:JoinFriendAction = null;
         var _loc33_:FriendJoinRequestMessage = null;
         var _loc34_:JoinSpouseAction = null;
         var _loc35_:FriendSpouseFollowAction = null;
         var _loc36_:FriendSpouseFollowWithCompassRequestMessage = null;
         var _loc37_:FriendWarningSetAction = null;
         var _loc38_:FriendSetWarnOnConnectionMessage = null;
         var _loc39_:MemberWarningSetAction = null;
         var _loc40_:GuildMemberSetWarnOnConnectionMessage = null;
         var _loc41_:FriendOrGuildMemberLevelUpWarningSetAction = null;
         var _loc42_:FriendSetWarnOnLevelGainMessage = null;
         var _loc43_:FriendGuildSetWarnOnAchievementCompleteAction = null;
         var _loc44_:FriendGuildSetWarnOnAchievementCompleteMessage = null;
         var _loc45_:WarnOnHardcoreDeathAction = null;
         var _loc46_:WarnOnPermaDeathMessage = null;
         var _loc47_:SpouseStatusMessage = null;
         var _loc48_:MoodSmileyUpdateMessage = null;
         var _loc49_:FriendWarnOnConnectionStateMessage = null;
         var _loc50_:GuildMemberWarnOnConnectionStateMessage = null;
         var _loc51_:GuildMemberOnlineStatusMessage = null;
         var _loc52_:FriendWarnOnLevelGainStateMessage = null;
         var _loc53_:FriendGuildWarnOnAchievementCompleteStateMessage = null;
         var _loc54_:WarnOnPermaDeathStateMessage = null;
         var _loc55_:GuildInformationsMembersMessage = null;
         var _loc56_:GuildHousesInformationMessage = null;
         var _loc57_:GuildModificationStartedMessage = null;
         var _loc58_:GuildCreationResultMessage = null;
         var _loc59_:String = null;
         var _loc60_:GuildInvitedMessage = null;
         var _loc61_:GuildInvitationStateRecruterMessage = null;
         var _loc62_:GuildInvitationStateRecrutedMessage = null;
         var _loc63_:GuildJoinedMessage = null;
         var _loc64_:String = null;
         var _loc65_:GuildInformationsGeneralMessage = null;
         var _loc66_:GuildInformationsMemberUpdateMessage = null;
         var _loc67_:GuildMember = null;
         var _loc68_:GuildMemberLeavingMessage = null;
         var _loc69_:uint = 0;
         var _loc70_:GuildInfosUpgradeMessage = null;
         var _loc71_:GuildFightPlayersHelpersJoinMessage = null;
         var _loc72_:GuildFightPlayersHelpersLeaveMessage = null;
         var _loc73_:GuildFightPlayersEnemiesListMessage = null;
         var _loc74_:GuildFightPlayersEnemyRemoveMessage = null;
         var _loc75_:TaxCollectorMovementMessage = null;
         var _loc76_:String = null;
         var _loc77_:String = null;
         var _loc78_:int = 0;
         var _loc79_:* = null;
         var _loc80_:* = null;
         var _loc81_:TaxCollectorAttackedMessage = null;
         var _loc82_:int = 0;
         var _loc83_:int = 0;
         var _loc84_:String = null;
         var _loc85_:String = null;
         var _loc86_:TaxCollectorAttackedResultMessage = null;
         var _loc87_:String = null;
         var _loc88_:String = null;
         var _loc89_:String = null;
         var _loc90_:WorldPointWrapper = null;
         var _loc91_:int = 0;
         var _loc92_:int = 0;
         var _loc93_:TaxCollectorErrorMessage = null;
         var _loc94_:String = null;
         var _loc95_:TaxCollectorListMessage = null;
         var _loc96_:TaxCollectorMovementAddMessage = null;
         var _loc97_:int = 0;
         var _loc98_:Boolean = false;
         var _loc99_:int = 0;
         var _loc100_:TaxCollectorMovementRemoveMessage = null;
         var _loc101_:TaxCollectorStateUpdateMessage = null;
         var _loc102_:TaxCollectorMovementsOfflineMessage = null;
         var _loc103_:TaxCollectorMovement = null;
         var _loc104_:String = null;
         var _loc105_:* = null;
         var _loc106_:WorldPointWrapper = null;
         var _loc107_:int = 0;
         var _loc108_:* = null;
         var _loc109_:String = null;
         var _loc110_:* = null;
         var _loc111_:* = null;
         var _loc112_:int = 0;
         var _loc113_:int = 0;
         var _loc114_:TopTaxCollectorListMessage = null;
         var _loc115_:ExchangeGuildTaxCollectorGetMessage = null;
         var _loc116_:uint = 0;
         var _loc117_:ObjectItemGenericQuantity = null;
         var _loc118_:Number = NaN;
         var _loc119_:Number = NaN;
         var _loc120_:Dictionary = null;
         var _loc121_:TaxCollectorWrapper = null;
         var _loc122_:* = null;
         var _loc123_:GuildInformationsPaddocksMessage = null;
         var _loc124_:GuildPaddockBoughtMessage = null;
         var _loc125_:GuildPaddockRemovedMessage = null;
         var _loc126_:AllianceTaxCollectorDialogQuestionExtendedMessage = null;
         var _loc127_:TaxCollectorDialogQuestionExtendedMessage = null;
         var _loc128_:TaxCollectorDialogQuestionBasicMessage = null;
         var _loc129_:GuildWrapper = null;
         var _loc130_:ContactLookMessage = null;
         var _loc131_:ContactLookErrorMessage = null;
         var _loc132_:GuildGetInformationsAction = null;
         var _loc133_:Boolean = false;
         var _loc134_:GuildInvitationAction = null;
         var _loc135_:GuildInvitationMessage = null;
         var _loc136_:GuildInvitationByNameAction = null;
         var _loc137_:GuildInvitationByNameMessage = null;
         var _loc138_:GuildKickRequestAction = null;
         var _loc139_:GuildKickRequestMessage = null;
         var _loc140_:GuildChangeMemberParametersAction = null;
         var _loc141_:Number = NaN;
         var _loc142_:GuildChangeMemberParametersMessage = null;
         var _loc143_:GuildSpellUpgradeRequestAction = null;
         var _loc144_:GuildSpellUpgradeRequestMessage = null;
         var _loc145_:GuildCharacsUpgradeRequestAction = null;
         var _loc146_:GuildCharacsUpgradeRequestMessage = null;
         var _loc147_:GuildFarmTeleportRequestAction = null;
         var _loc148_:GuildPaddockTeleportRequestMessage = null;
         var _loc149_:GuildHouseTeleportRequestAction = null;
         var _loc150_:GuildHouseTeleportRequestMessage = null;
         var _loc151_:GuildFightJoinRequestAction = null;
         var _loc152_:GuildFightJoinRequestMessage = null;
         var _loc153_:GuildFightTakePlaceRequestAction = null;
         var _loc154_:GuildFightTakePlaceRequestMessage = null;
         var _loc155_:GuildFightLeaveRequestAction = null;
         var _loc156_:GuildFightLeaveRequestMessage = null;
         var _loc157_:GuildFactsRequestAction = null;
         var _loc158_:GuildFactsRequestMessage = null;
         var _loc159_:GuildFactsMessage = null;
         var _loc160_:GuildFactSheetWrapper = null;
         var _loc161_:uint = 0;
         var _loc162_:String = null;
         var _loc163_:String = null;
         var _loc164_:GuildFactsErrorMessage = null;
         var _loc165_:GuildMotdSetRequestAction = null;
         var _loc166_:GuildMotdSetRequestMessage = null;
         var _loc167_:GuildMotdMessage = null;
         var _loc168_:String = null;
         var _loc169_:RegExp = null;
         var _loc170_:Array = null;
         var _loc171_:GuildMotdSetErrorMessage = null;
         var _loc172_:GuildBulletinSetRequestAction = null;
         var _loc173_:GuildBulletinSetRequestMessage = null;
         var _loc174_:GuildBulletinMessage = null;
         var _loc175_:Array = null;
         var _loc176_:GuildBulletinSetErrorMessage = null;
         var _loc177_:CharacterReportAction = null;
         var _loc178_:CharacterReportMessage = null;
         var _loc179_:ChatReportAction = null;
         var _loc180_:ChatMessageReportMessage = null;
         var _loc181_:uint = 0;
         var _loc182_:PlayerStatusUpdateMessage = null;
         var _loc183_:String = null;
         var _loc184_:PlayerStatusUpdateRequestAction = null;
         var _loc185_:PlayerStatus = null;
         var _loc186_:PlayerStatusUpdateRequestMessage = null;
         var _loc187_:ContactLookRequestByIdAction = null;
         var _loc188_:FriendInformations = null;
         var _loc189_:FriendWrapper = null;
         var _loc190_:FriendOnlineInformations = null;
         var _loc191_:* = undefined;
         var _loc192_:EnemyWrapper = null;
         var _loc193_:IgnoredOnlineInformations = null;
         var _loc194_:FriendAddRequestMessage = null;
         var _loc195_:IgnoredAddRequestMessage = null;
         var _loc196_:EnemyWrapper = null;
         var _loc197_:* = undefined;
         var _loc198_:* = undefined;
         var _loc199_:* = undefined;
         var _loc200_:* = undefined;
         var _loc201_:* = undefined;
         var _loc202_:* = undefined;
         var _loc203_:IgnoredAddRequestMessage = null;
         var _loc204_:GuildMember = null;
         var _loc205_:int = 0;
         var _loc206_:int = 0;
         var _loc207_:FriendWrapper = null;
         var _loc208_:String = null;
         var _loc209_:GuildMember = null;
         var _loc210_:Boolean = false;
         var _loc211_:FriendWrapper = null;
         var _loc212_:GuildMember = null;
         var _loc213_:HouseInformationsForGuild = null;
         var _loc214_:GuildHouseWrapper = null;
         var _loc215_:int = 0;
         var _loc216_:int = 0;
         var _loc217_:GuildMember = null;
         var _loc218_:String = null;
         var _loc219_:CharacterMinimalPlusLookInformations = null;
         var _loc220_:String = null;
         var _loc221_:String = null;
         var _loc222_:SubArea = null;
         var _loc223_:uint = 0;
         var _loc224_:TaxCollectorInformations = null;
         var _loc225_:Vector.<TaxCollectorWrapper> = null;
         var _loc226_:Vector.<TaxCollectorWrapper> = null;
         var _loc227_:GuildGetInformationsMessage = null;
         var _loc228_:TaxCollectorWrapper = null;
         var _loc229_:SocialEntityInFightWrapper = null;
         var _loc230_:SocialFightersWrapper = null;
         var _loc231_:GuildHouseUpdateInformationMessage = null;
         var _loc232_:Boolean = false;
         var _loc233_:GuildHouseWrapper = null;
         var _loc234_:GuildHouseWrapper = null;
         var _loc235_:GuildHouseRemoveMessage = null;
         var _loc236_:Boolean = false;
         var _loc237_:int = 0;
         var _loc238_:GuildInAllianceFactsMessage = null;
         var _loc239_:String = null;
         var _loc240_:GuildMember = null;
         var _loc241_:int = 0;
         var _loc242_:int = 0;
         var _loc243_:FriendWrapper = null;
         var _loc244_:ChatApi = null;
         var _loc245_:ContactLookRequestByIdMessage = null;
         switch(true)
         {
            case param1 is GuildMembershipMessage:
               _loc3_ = param1 as GuildMembershipMessage;
               if(this._guild != null)
               {
                  this._guild.update(_loc3_.guildInfo.guildId,_loc3_.guildInfo.guildName,_loc3_.guildInfo.guildEmblem,_loc3_.memberRights);
               }
               else
               {
                  this._guild = GuildWrapper.create(_loc3_.guildInfo.guildId,_loc3_.guildInfo.guildName,_loc3_.guildInfo.guildEmblem,_loc3_.memberRights);
               }
               this._hasGuild = true;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildMembershipUpdated,true);
               return true;
            case param1 is FriendsListMessage:
               _loc4_ = param1 as FriendsListMessage;
               this._friendsList = new Array();
               for each(_loc188_ in _loc4_.friendsList)
               {
                  if(_loc188_ is FriendOnlineInformations)
                  {
                     _loc190_ = _loc188_ as FriendOnlineInformations;
                     AccountManager.getInstance().setAccount(_loc190_.playerName,_loc190_.accountId,_loc190_.accountName);
                     ChatAutocompleteNameManager.getInstance().addEntry((_loc188_ as FriendOnlineInformations).playerName,2);
                  }
                  _loc189_ = new FriendWrapper(_loc188_);
                  this._friendsList.push(_loc189_);
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendsListUpdated);
               return true;
            case param1 is SpouseRequestAction:
               _loc5_ = param1 as SpouseRequestAction;
               ConnectionsHandler.getConnection().send(new SpouseGetInformationsMessage());
               return true;
            case param1 is SpouseInformationsMessage:
               _loc6_ = param1 as SpouseInformationsMessage;
               this._spouse = new SpouseWrapper(_loc6_.spouse);
               this._hasSpouse = true;
               KernelEventsManager.getInstance().processCallback(SocialHookList.SpouseUpdated);
               return true;
            case param1 is IgnoredListMessage:
               this._enemiesList = new Array();
               _loc7_ = param1 as IgnoredListMessage;
               for each(_loc191_ in _loc7_.ignoredList)
               {
                  if(_loc191_ is IgnoredOnlineInformations)
                  {
                     _loc193_ = _loc191_ as IgnoredOnlineInformations;
                     AccountManager.getInstance().setAccount(_loc193_.playerName,_loc193_.accountId,_loc193_.accountName);
                  }
                  _loc192_ = new EnemyWrapper(_loc191_);
                  this._enemiesList.push(_loc192_);
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.EnemiesListUpdated);
               return true;
            case param1 is OpenSocialAction:
               _loc8_ = param1 as OpenSocialAction;
               KernelEventsManager.getInstance().processCallback(SocialHookList.OpenSocial,_loc8_.name);
               return true;
            case param1 is FriendsListRequestAction:
               _loc9_ = param1 as FriendsListRequestAction;
               ConnectionsHandler.getConnection().send(new FriendsGetListMessage());
               return true;
            case param1 is EnemiesListRequestAction:
               _loc10_ = param1 as EnemiesListRequestAction;
               ConnectionsHandler.getConnection().send(new IgnoredGetListMessage());
               return true;
            case param1 is AddFriendAction:
               _loc11_ = param1 as AddFriendAction;
               if(_loc11_.name.length < 2 || _loc11_.name.length > 20)
               {
                  _loc2_ = I18n.getUiText("ui.social.friend.addFailureNotFound");
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc2_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               }
               else if(_loc11_.name != PlayedCharacterManager.getInstance().infos.name)
               {
                  _loc194_ = new FriendAddRequestMessage();
                  _loc194_.initFriendAddRequestMessage(_loc11_.name);
                  ConnectionsHandler.getConnection().send(_loc194_);
               }
               else
               {
                  _loc2_ = I18n.getUiText("ui.social.friend.addFailureEgocentric");
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc2_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is FriendAddedMessage:
               _loc12_ = param1 as FriendAddedMessage;
               if(_loc12_.friendAdded is FriendOnlineInformations)
               {
                  _loc190_ = _loc12_.friendAdded as FriendOnlineInformations;
                  AccountManager.getInstance().setAccount(_loc190_.playerName,_loc190_.accountId,_loc190_.accountName);
                  ChatAutocompleteNameManager.getInstance().addEntry((_loc12_.friendAdded as FriendInformations).accountName,2);
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendAdded,true);
               _loc13_ = new FriendWrapper(_loc12_.friendAdded);
               this._friendsList.push(_loc13_);
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendsListUpdated);
               return true;
            case param1 is FriendAddFailureMessage:
               _loc14_ = param1 as FriendAddFailureMessage;
               switch(_loc14_.reason)
               {
                  case ListAddFailureEnum.LIST_ADD_FAILURE_UNKNOWN:
                     _loc2_ = I18n.getUiText("ui.common.unknowReason");
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_OVER_QUOTA:
                     _loc2_ = I18n.getUiText("ui.social.friend.addFailureListFull");
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_NOT_FOUND:
                     _loc2_ = I18n.getUiText("ui.social.friend.addFailureNotFound");
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_EGOCENTRIC:
                     _loc2_ = I18n.getUiText("ui.social.friend.addFailureEgocentric");
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_IS_DOUBLE:
                     _loc2_ = I18n.getUiText("ui.social.friend.addFailureAlreadyInList");
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc2_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is AddEnemyAction:
               _loc15_ = param1 as AddEnemyAction;
               if(_loc15_.name.length < ProtocolConstantsEnum.MIN_PLAYER_NAME_LEN || _loc15_.name.length > ProtocolConstantsEnum.MAX_PLAYER_NAME_LEN)
               {
                  _loc2_ = I18n.getUiText("ui.social.friend.addFailureNotFound");
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc2_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               }
               else if(_loc15_.name != PlayedCharacterManager.getInstance().infos.name)
               {
                  _loc195_ = new IgnoredAddRequestMessage();
                  _loc195_.initIgnoredAddRequestMessage(_loc15_.name);
                  ConnectionsHandler.getConnection().send(_loc195_);
               }
               else
               {
                  _loc2_ = I18n.getUiText("ui.social.friend.addFailureEgocentric");
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc2_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is IgnoredAddedMessage:
               _loc16_ = param1 as IgnoredAddedMessage;
               if(_loc16_.ignoreAdded is IgnoredOnlineInformations)
               {
                  _loc193_ = _loc16_.ignoreAdded as IgnoredOnlineInformations;
                  AccountManager.getInstance().setAccount(_loc193_.playerName,_loc193_.accountId,_loc193_.accountName);
               }
               if(!_loc16_.session)
               {
                  KernelEventsManager.getInstance().processCallback(SocialHookList.EnemyAdded,true);
                  _loc196_ = new EnemyWrapper(_loc16_.ignoreAdded);
                  this._enemiesList.push(_loc196_);
                  KernelEventsManager.getInstance().processCallback(SocialHookList.EnemiesListUpdated);
               }
               else
               {
                  for each(_loc197_ in this._ignoredList)
                  {
                     if(_loc197_.name == _loc16_.ignoreAdded.accountName)
                     {
                        return true;
                     }
                  }
                  this._ignoredList.push(new IgnoredWrapper(_loc16_.ignoreAdded.accountName,_loc16_.ignoreAdded.accountId));
                  KernelEventsManager.getInstance().processCallback(SocialHookList.IgnoredAdded);
               }
               return true;
            case param1 is IgnoredAddFailureMessage:
               _loc17_ = param1 as IgnoredAddFailureMessage;
               switch(_loc17_.reason)
               {
                  case ListAddFailureEnum.LIST_ADD_FAILURE_UNKNOWN:
                     _loc18_ = I18n.getUiText("ui.common.unknowReason");
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_OVER_QUOTA:
                     _loc18_ = I18n.getUiText("ui.social.friend.addFailureListFull");
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_NOT_FOUND:
                     _loc18_ = I18n.getUiText("ui.social.friend.addFailureNotFound");
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_EGOCENTRIC:
                     _loc18_ = I18n.getUiText("ui.social.friend.addFailureEgocentric");
                     break;
                  case ListAddFailureEnum.LIST_ADD_FAILURE_IS_DOUBLE:
                     _loc18_ = I18n.getUiText("ui.social.friend.addFailureAlreadyInList");
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc18_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is RemoveFriendAction:
               _loc19_ = param1 as RemoveFriendAction;
               _loc20_ = new FriendDeleteRequestMessage();
               _loc20_.initFriendDeleteRequestMessage(_loc19_.accountId);
               ConnectionsHandler.getConnection().send(_loc20_);
               return true;
            case param1 is FriendDeleteResultMessage:
               _loc21_ = param1 as FriendDeleteResultMessage;
               _loc22_ = I18n.getUiText("ui.social.friend.delete",[_loc21_.name]);
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendRemoved,_loc21_.success);
               if(_loc21_.success)
               {
                  for(_loc198_ in this._friendsList)
                  {
                     if(this._friendsList[_loc198_].name == _loc21_.name)
                     {
                        this._friendsList.splice(_loc198_,1);
                     }
                  }
                  KernelEventsManager.getInstance().processCallback(SocialHookList.FriendsListUpdated);
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc22_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is FriendUpdateMessage:
               _loc23_ = param1 as FriendUpdateMessage;
               _loc24_ = new FriendWrapper(_loc23_.friendUpdated);
               for each(_loc199_ in this._friendsList)
               {
                  if(_loc199_.name == _loc24_.name)
                  {
                     _loc199_ = _loc24_;
                     break;
                  }
               }
               _loc25_ = _loc24_.state == PlayerStateEnum.GAME_TYPE_ROLEPLAY || _loc24_.state == PlayerStateEnum.GAME_TYPE_FIGHT;
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendsListUpdated);
               if(AirScanner.hasAir() && ExternalNotificationManager.getInstance().canAddExternalNotification(ExternalNotificationTypeEnum.FRIEND_CONNECTION) && this._warnOnFrienConnec && _loc24_.online && !_loc25_)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.ExternalNotification,ExternalNotificationTypeEnum.FRIEND_CONNECTION,[_loc24_.name,_loc24_.playerName,_loc24_.playerId]);
               }
               return true;
            case param1 is RemoveEnemyAction:
               _loc26_ = param1 as RemoveEnemyAction;
               _loc27_ = new IgnoredDeleteRequestMessage();
               _loc27_.initIgnoredDeleteRequestMessage(_loc26_.accountId);
               ConnectionsHandler.getConnection().send(_loc27_);
               return true;
            case param1 is IgnoredDeleteResultMessage:
               _loc28_ = param1 as IgnoredDeleteResultMessage;
               if(!_loc28_.session)
               {
                  KernelEventsManager.getInstance().processCallback(SocialHookList.EnemyRemoved,_loc28_.success);
                  if(_loc28_.success)
                  {
                     for(_loc200_ in this._enemiesList)
                     {
                        if(this._enemiesList[_loc200_].name == _loc28_.name)
                        {
                           this._enemiesList.splice(_loc200_,1);
                        }
                     }
                     KernelEventsManager.getInstance().processCallback(SocialHookList.EnemiesListUpdated);
                  }
               }
               else if(_loc28_.success)
               {
                  for(_loc201_ in this._ignoredList)
                  {
                     if(this._ignoredList[_loc201_].name == _loc28_.name)
                     {
                        this._ignoredList.splice(_loc201_,1);
                     }
                  }
                  KernelEventsManager.getInstance().processCallback(SocialHookList.IgnoredRemoved);
               }
               return true;
            case param1 is AddIgnoredAction:
               _loc29_ = param1 as AddIgnoredAction;
               if(_loc29_.name.length < ProtocolConstantsEnum.MIN_PLAYER_NAME_LEN || _loc29_.name.length > ProtocolConstantsEnum.MAX_PLAYER_NAME_LEN)
               {
                  _loc2_ = I18n.getUiText("ui.social.friend.addFailureNotFound");
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc2_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               }
               else if(_loc29_.name != PlayedCharacterManager.getInstance().infos.name)
               {
                  for each(_loc202_ in this._ignoredList)
                  {
                     if(_loc202_.playerName == _loc29_.name)
                     {
                        return true;
                     }
                  }
                  _loc203_ = new IgnoredAddRequestMessage();
                  _loc203_.initIgnoredAddRequestMessage(_loc29_.name,true);
                  ConnectionsHandler.getConnection().send(_loc203_);
               }
               else
               {
                  _loc2_ = I18n.getUiText("ui.social.friend.addFailureEgocentric");
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc2_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is RemoveIgnoredAction:
               _loc30_ = param1 as RemoveIgnoredAction;
               _loc31_ = new IgnoredDeleteRequestMessage();
               _loc31_.initIgnoredDeleteRequestMessage(_loc30_.accountId,true);
               ConnectionsHandler.getConnection().send(_loc31_);
               return true;
            case param1 is JoinFriendAction:
               _loc32_ = param1 as JoinFriendAction;
               _loc33_ = new FriendJoinRequestMessage();
               _loc33_.initFriendJoinRequestMessage(_loc32_.name);
               ConnectionsHandler.getConnection().send(_loc33_);
               return true;
            case param1 is JoinSpouseAction:
               _loc34_ = param1 as JoinSpouseAction;
               ConnectionsHandler.getConnection().send(new FriendSpouseJoinRequestMessage());
               return true;
            case param1 is FriendSpouseFollowAction:
               _loc35_ = param1 as FriendSpouseFollowAction;
               _loc36_ = new FriendSpouseFollowWithCompassRequestMessage();
               _loc36_.initFriendSpouseFollowWithCompassRequestMessage(_loc35_.enable);
               ConnectionsHandler.getConnection().send(_loc36_);
               return true;
            case param1 is FriendWarningSetAction:
               _loc37_ = param1 as FriendWarningSetAction;
               this._warnOnFrienConnec = _loc37_.enable;
               _loc38_ = new FriendSetWarnOnConnectionMessage();
               _loc38_.initFriendSetWarnOnConnectionMessage(_loc37_.enable);
               ConnectionsHandler.getConnection().send(_loc38_);
               return true;
            case param1 is MemberWarningSetAction:
               _loc39_ = param1 as MemberWarningSetAction;
               this._warnOnMemberConnec = _loc39_.enable;
               _loc40_ = new GuildMemberSetWarnOnConnectionMessage();
               _loc40_.initGuildMemberSetWarnOnConnectionMessage(_loc39_.enable);
               ConnectionsHandler.getConnection().send(_loc40_);
               return true;
            case param1 is FriendOrGuildMemberLevelUpWarningSetAction:
               _loc41_ = param1 as FriendOrGuildMemberLevelUpWarningSetAction;
               this._warnWhenFriendOrGuildMemberLvlUp = _loc41_.enable;
               _loc42_ = new FriendSetWarnOnLevelGainMessage();
               _loc42_.initFriendSetWarnOnLevelGainMessage(_loc41_.enable);
               ConnectionsHandler.getConnection().send(_loc42_);
               return true;
            case param1 is FriendGuildSetWarnOnAchievementCompleteAction:
               _loc43_ = param1 as FriendGuildSetWarnOnAchievementCompleteAction;
               this._warnWhenFriendOrGuildMemberAchieve = _loc43_.enable;
               _loc44_ = new FriendGuildSetWarnOnAchievementCompleteMessage();
               _loc44_.initFriendGuildSetWarnOnAchievementCompleteMessage(_loc43_.enable);
               ConnectionsHandler.getConnection().send(_loc44_);
               return true;
            case param1 is WarnOnHardcoreDeathAction:
               _loc45_ = param1 as WarnOnHardcoreDeathAction;
               this._warnOnHardcoreDeath = _loc45_.enable;
               _loc46_ = new WarnOnPermaDeathMessage();
               _loc46_.initWarnOnPermaDeathMessage(_loc45_.enable);
               ConnectionsHandler.getConnection().send(_loc46_);
               return true;
            case param1 is SpouseStatusMessage:
               _loc47_ = param1 as SpouseStatusMessage;
               this._hasSpouse = _loc47_.hasSpouse;
               if(!this._hasSpouse)
               {
                  this._spouse = null;
                  KernelEventsManager.getInstance().processCallback(SocialHookList.SpouseFollowStatusUpdated,false);
                  KernelEventsManager.getInstance().processCallback(HookList.RemoveMapFlag,"flag_srv" + CompassTypeEnum.COMPASS_TYPE_SPOUSE,-1);
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.SpouseUpdated);
               return true;
            case param1 is MoodSmileyUpdateMessage:
               _loc48_ = param1 as MoodSmileyUpdateMessage;
               if(this._guildMembers != null)
               {
                  _loc205_ = this._guildMembers.length;
                  _loc206_ = 0;
                  while(_loc206_ < _loc205_)
                  {
                     if(this._guildMembers[_loc206_].id == _loc48_.playerId)
                     {
                        this._guildMembers[_loc206_].moodSmileyId = _loc48_.smileyId;
                        _loc204_ = this._guildMembers[_loc206_];
                        KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsMemberUpdate,_loc204_);
                        break;
                     }
                     _loc206_++;
                  }
               }
               if(this._friendsList != null)
               {
                  for each(_loc207_ in this._friendsList)
                  {
                     if(_loc207_.accountId == _loc48_.accountId)
                     {
                        _loc207_.moodSmileyId = _loc48_.smileyId;
                        KernelEventsManager.getInstance().processCallback(SocialHookList.FriendsListUpdated);
                        break;
                     }
                  }
               }
               return true;
            case param1 is FriendWarnOnConnectionStateMessage:
               _loc49_ = param1 as FriendWarnOnConnectionStateMessage;
               this._warnOnFrienConnec = _loc49_.enable;
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendWarningState,_loc49_.enable);
               return true;
            case param1 is GuildMemberWarnOnConnectionStateMessage:
               _loc50_ = param1 as GuildMemberWarnOnConnectionStateMessage;
               this._warnOnMemberConnec = _loc50_.enable;
               KernelEventsManager.getInstance().processCallback(SocialHookList.MemberWarningState,_loc50_.enable);
               return true;
            case param1 is GuildMemberOnlineStatusMessage:
               if(!this._friendsList)
               {
                  return true;
               }
               _loc51_ = param1 as GuildMemberOnlineStatusMessage;
               if(AirScanner.hasAir() && ExternalNotificationManager.getInstance().canAddExternalNotification(ExternalNotificationTypeEnum.MEMBER_CONNECTION) && this._warnOnMemberConnec && _loc51_.online)
               {
                  for each(_loc209_ in this._guildMembers)
                  {
                     if(_loc209_.id == _loc51_.memberId)
                     {
                        _loc208_ = _loc209_.name;
                        break;
                     }
                  }
                  _loc210_ = false;
                  for each(_loc211_ in this._friendsList)
                  {
                     if(_loc211_.name == _loc208_)
                     {
                        _loc210_ = true;
                        break;
                     }
                  }
                  if(!(_loc210_ && !ExternalNotificationManager.getInstance().isExternalNotificationTypeIgnored(ExternalNotificationTypeEnum.FRIEND_CONNECTION)))
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.ExternalNotification,ExternalNotificationTypeEnum.MEMBER_CONNECTION,[_loc208_,_loc51_.memberId]);
                  }
               }
               return true;
            case param1 is FriendWarnOnLevelGainStateMessage:
               _loc52_ = param1 as FriendWarnOnLevelGainStateMessage;
               this._warnWhenFriendOrGuildMemberLvlUp = _loc52_.enable;
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendOrGuildMemberLevelUpWarningState,_loc52_.enable);
               return true;
            case param1 is FriendGuildWarnOnAchievementCompleteStateMessage:
               _loc53_ = param1 as FriendGuildWarnOnAchievementCompleteStateMessage;
               this._warnWhenFriendOrGuildMemberAchieve = _loc53_.enable;
               KernelEventsManager.getInstance().processCallback(SocialHookList.FriendGuildWarnOnAchievementCompleteState,_loc53_.enable);
               return true;
            case param1 is WarnOnPermaDeathStateMessage:
               _loc54_ = param1 as WarnOnPermaDeathStateMessage;
               this._warnOnHardcoreDeath = _loc54_.enable;
               KernelEventsManager.getInstance().processCallback(SocialHookList.WarnOnHardcoreDeathState,_loc54_.enable);
               return true;
            case param1 is GuildInformationsMembersMessage:
               _loc55_ = param1 as GuildInformationsMembersMessage;
               for each(_loc212_ in _loc55_.members)
               {
                  ChatAutocompleteNameManager.getInstance().addEntry(_loc212_.name,2);
               }
               this._guildMembers = _loc55_.members;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsMembers,this._guildMembers);
               return true;
            case param1 is GuildHousesInformationMessage:
               _loc56_ = param1 as GuildHousesInformationMessage;
               this._guildHouses = new Vector.<GuildHouseWrapper>();
               for each(_loc213_ in _loc56_.housesInformations)
               {
                  _loc214_ = GuildHouseWrapper.create(_loc213_);
                  this._guildHouses.push(_loc214_);
               }
               this._guildHousesList = true;
               this._guildHousesListUpdate = true;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildHousesUpdate);
               return true;
            case param1 is GuildCreationStartedMessage:
               Kernel.getWorker().addFrame(this._guildDialogFrame);
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildCreationStarted,false,false);
               return true;
            case param1 is GuildModificationStartedMessage:
               _loc57_ = param1 as GuildModificationStartedMessage;
               Kernel.getWorker().addFrame(this._guildDialogFrame);
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildCreationStarted,_loc57_.canChangeName,_loc57_.canChangeEmblem);
               return true;
            case param1 is GuildCreationResultMessage:
               _loc58_ = param1 as GuildCreationResultMessage;
               switch(_loc58_.result)
               {
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_ALREADY_IN_GROUP:
                     _loc59_ = I18n.getUiText("ui.guild.alreadyInGuild");
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_EMBLEM_ALREADY_EXISTS:
                     _loc59_ = I18n.getUiText("ui.guild.AlreadyUseEmblem");
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_CANCEL:
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_LEAVE:
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_NAME_ALREADY_EXISTS:
                     _loc59_ = I18n.getUiText("ui.guild.AlreadyUseName");
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_NAME_INVALID:
                     _loc59_ = I18n.getUiText("ui.guild.invalidName");
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_REQUIREMENT_UNMET:
                     _loc59_ = I18n.getUiText("ui.guild.requirementUnmet");
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_OK:
                     Kernel.getWorker().removeFrame(this._guildDialogFrame);
                     this._hasGuild = true;
                     break;
                  case SocialGroupCreationResultEnum.SOCIAL_GROUP_CREATE_ERROR_UNKNOWN:
                     _loc59_ = I18n.getUiText("ui.common.unknownFail");
               }
               if(_loc59_)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc59_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildCreationResult,_loc58_.result);
               return true;
            case param1 is GuildInvitedMessage:
               _loc60_ = param1 as GuildInvitedMessage;
               Kernel.getWorker().addFrame(this._guildDialogFrame);
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInvited,_loc60_.guildInfo.guildName,_loc60_.recruterId,_loc60_.recruterName);
               return true;
            case param1 is GuildInvitationStateRecruterMessage:
               _loc61_ = param1 as GuildInvitationStateRecruterMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInvitationStateRecruter,_loc61_.invitationState,_loc61_.recrutedName);
               if(_loc61_.invitationState == SocialGroupInvitationStateEnum.SOCIAL_GROUP_INVITATION_CANCELED || _loc61_.invitationState == SocialGroupInvitationStateEnum.SOCIAL_GROUP_INVITATION_OK)
               {
                  Kernel.getWorker().removeFrame(this._guildDialogFrame);
               }
               else
               {
                  Kernel.getWorker().addFrame(this._guildDialogFrame);
               }
               return true;
            case param1 is GuildInvitationStateRecrutedMessage:
               _loc62_ = param1 as GuildInvitationStateRecrutedMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInvitationStateRecruted,_loc62_.invitationState);
               if(_loc62_.invitationState == SocialGroupInvitationStateEnum.SOCIAL_GROUP_INVITATION_CANCELED || _loc62_.invitationState == SocialGroupInvitationStateEnum.SOCIAL_GROUP_INVITATION_OK)
               {
                  Kernel.getWorker().removeFrame(this._guildDialogFrame);
               }
               return true;
            case param1 is GuildJoinedMessage:
               _loc63_ = param1 as GuildJoinedMessage;
               this._hasGuild = true;
               this._guild = GuildWrapper.create(_loc63_.guildInfo.guildId,_loc63_.guildInfo.guildName,_loc63_.guildInfo.guildEmblem,_loc63_.memberRights);
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildMembershipUpdated,true);
               _loc64_ = I18n.getUiText("ui.guild.JoinGuildMessage",[_loc63_.guildInfo.guildName]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc64_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is GuildInformationsGeneralMessage:
               _loc65_ = param1 as GuildInformationsGeneralMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsGeneral,_loc65_.expLevelFloor,_loc65_.experience,_loc65_.expNextLevelFloor,_loc65_.level,_loc65_.creationDate,_loc65_.abandonnedPaddock,_loc65_.nbConnectedMembers,_loc65_.nbTotalMembers);
               this._guild.level = _loc65_.level;
               this._guild.experience = _loc65_.experience;
               this._guild.expLevelFloor = _loc65_.expLevelFloor;
               this._guild.expNextLevelFloor = _loc65_.expNextLevelFloor;
               this._guild.creationDate = _loc65_.creationDate;
               this._guild.nbMembers = _loc65_.nbTotalMembers;
               this._guild.nbConnectedMembers = _loc65_.nbConnectedMembers;
               return true;
            case param1 is GuildInformationsMemberUpdateMessage:
               _loc66_ = param1 as GuildInformationsMemberUpdateMessage;
               if(this._guildMembers != null)
               {
                  _loc215_ = this._guildMembers.length;
                  _loc216_ = 0;
                  while(_loc216_ < _loc215_)
                  {
                     _loc67_ = this._guildMembers[_loc216_];
                     if(_loc67_.id == _loc66_.member.id)
                     {
                        this._guildMembers[_loc216_] = _loc66_.member;
                        if(_loc67_.id == PlayedCharacterManager.getInstance().id)
                        {
                           this.guild.memberRightsNumber = _loc66_.member.rights;
                        }
                        break;
                     }
                     _loc216_++;
                  }
               }
               else
               {
                  this._guildMembers = new Vector.<GuildMember>();
                  _loc67_ = _loc66_.member;
                  this._guildMembers.push(_loc67_);
                  if(_loc67_.id == PlayedCharacterManager.getInstance().id)
                  {
                     this.guild.memberRightsNumber = _loc67_.rights;
                  }
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsMembers,this._guildMembers);
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsMemberUpdate,_loc66_.member);
               return true;
            case param1 is GuildMemberLeavingMessage:
               _loc68_ = param1 as GuildMemberLeavingMessage;
               _loc69_ = 0;
               for each(_loc217_ in this._guildMembers)
               {
                  if(_loc68_.memberId == _loc217_.id)
                  {
                     this._guildMembers.splice(_loc69_,1);
                  }
                  _loc69_++;
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsMembers,this._guildMembers);
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildMemberLeaving,_loc68_.kicked,_loc68_.memberId);
               return true;
            case param1 is GuildLeftMessage:
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildLeft);
               this._hasGuild = false;
               this._guild = null;
               this._guildHousesList = false;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildMembershipUpdated,false);
               return true;
            case param1 is GuildInfosUpgradeMessage:
               _loc70_ = param1 as GuildInfosUpgradeMessage;
               TaxCollectorsManager.getInstance().updateGuild(_loc70_.maxTaxCollectorsCount,_loc70_.taxCollectorsCount,_loc70_.taxCollectorLifePoints,_loc70_.taxCollectorDamagesBonuses,_loc70_.taxCollectorPods,_loc70_.taxCollectorProspecting,_loc70_.taxCollectorWisdom);
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInfosUpgrade,_loc70_.boostPoints,_loc70_.maxTaxCollectorsCount,_loc70_.spellId,_loc70_.spellLevel,_loc70_.taxCollectorDamagesBonuses,_loc70_.taxCollectorLifePoints,_loc70_.taxCollectorPods,_loc70_.taxCollectorProspecting,_loc70_.taxCollectorsCount,_loc70_.taxCollectorWisdom);
               return true;
            case param1 is GuildFightPlayersHelpersJoinMessage:
               _loc71_ = param1 as GuildFightPlayersHelpersJoinMessage;
               TaxCollectorsManager.getInstance().addFighter(0,_loc71_.fightId,_loc71_.playerInfo,true);
               return true;
            case param1 is GuildFightPlayersHelpersLeaveMessage:
               _loc72_ = param1 as GuildFightPlayersHelpersLeaveMessage;
               if(this._autoLeaveHelpers)
               {
                  _loc218_ = I18n.getUiText("ui.social.guild.autoFightLeave");
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc218_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               TaxCollectorsManager.getInstance().removeFighter(0,_loc72_.fightId,_loc72_.playerId,true);
               return true;
            case param1 is GuildFightPlayersEnemiesListMessage:
               _loc73_ = param1 as GuildFightPlayersEnemiesListMessage;
               for each(_loc219_ in _loc73_.playerInfo)
               {
                  TaxCollectorsManager.getInstance().addFighter(0,_loc73_.fightId,_loc219_,false,false);
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildFightEnnemiesListUpdate,0,_loc73_.fightId);
               return true;
            case param1 is GuildFightPlayersEnemyRemoveMessage:
               _loc74_ = param1 as GuildFightPlayersEnemyRemoveMessage;
               TaxCollectorsManager.getInstance().removeFighter(0,_loc74_.fightId,_loc74_.playerId,false);
               return true;
            case param1 is TaxCollectorMovementMessage:
               _loc75_ = param1 as TaxCollectorMovementMessage;
               _loc77_ = TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc75_.basicInfos.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(_loc75_.basicInfos.lastNameId).name;
               _loc78_ = SubArea.getSubAreaByMapId(_loc75_.basicInfos.mapId).worldmap.id;
               _loc79_ = "{player," + _loc75_.playerName + "," + _loc75_.playerId + "}";
               _loc80_ = "{map," + _loc75_.basicInfos.worldX + "," + _loc75_.basicInfos.worldY + "," + _loc78_ + "}";
               switch(_loc75_.movementType)
               {
                  case TaxCollectorMovementTypeEnum.TAX_COLLECTOR_HIRED:
                     _loc76_ = I18n.getUiText("ui.social.TaxCollectorAdded",[_loc77_,_loc80_,_loc79_]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc76_,ChatActivableChannelsEnum.CHANNEL_GUILD,TimeManager.getInstance().getTimestamp());
                     break;
                  case TaxCollectorMovementTypeEnum.TAX_COLLECTOR_HARVESTED:
                     _loc76_ = I18n.getUiText("ui.social.TaxCollectorRemoved",[_loc77_,_loc80_,_loc79_]);
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc76_,ChatActivableChannelsEnum.CHANNEL_GUILD,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is TaxCollectorAttackedMessage:
               _loc81_ = param1 as TaxCollectorAttackedMessage;
               _loc82_ = _loc81_.worldX;
               _loc83_ = _loc81_.worldY;
               _loc84_ = TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc81_.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(_loc81_.lastNameId).name;
               if(!_loc81_.guild || _loc81_.guild.guildId == this._guild.guildId)
               {
                  _loc85_ = I18n.getUiText("ui.social.TaxCollectorAttacked",[_loc84_,_loc82_ + "," + _loc83_]);
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,"{openSocial,1,2::" + _loc85_ + "}",ChatActivableChannelsEnum.CHANNEL_GUILD,TimeManager.getInstance().getTimestamp());
               }
               else
               {
                  _loc220_ = _loc81_.guild.guildName;
                  _loc221_ = SubArea.getSubAreaById(_loc81_.subAreaId).name;
                  _loc85_ = I18n.getUiText("ui.guild.taxCollectorAttacked",[_loc220_,_loc221_,_loc82_ + "," + _loc83_]);
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,"{openSocial,2,2,0," + _loc81_.mapId + "::" + _loc85_ + "}",ChatActivableChannelsEnum.CHANNEL_ALLIANCE,TimeManager.getInstance().getTimestamp());
               }
               if(AirScanner.hasAir() && ExternalNotificationManager.getInstance().canAddExternalNotification(ExternalNotificationTypeEnum.TAXCOLLECTOR_ATTACK))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.ExternalNotification,ExternalNotificationTypeEnum.TAXCOLLECTOR_ATTACK,[_loc84_,_loc82_,_loc83_]);
               }
               if(this._guild.alliance && OptionManager.getOptionManager("dofus")["warnOnGuildItemAgression"])
               {
                  _loc222_ = SubArea.getSubAreaById(_loc81_.subAreaId);
                  _loc223_ = NotificationManager.getInstance().prepareNotification(I18n.getUiText("ui.guild.taxCollectorAttackedTitle"),I18n.getUiText("ui.guild.taxCollectorAttacked",[_loc81_.guild.guildName,_loc222_.name,_loc82_ + "," + _loc83_]),NotificationTypeEnum.INVITATION,"TaxCollectorAttacked");
                  NotificationManager.getInstance().addButtonToNotification(_loc223_,I18n.getUiText("ui.common.join"),"OpenSocial",[2,2,[0,_loc81_.mapId]],true,200,0,"hook");
                  NotificationManager.getInstance().sendNotification(_loc223_);
               }
               return true;
            case param1 is TaxCollectorAttackedResultMessage:
               _loc86_ = param1 as TaxCollectorAttackedResultMessage;
               _loc88_ = TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc86_.basicInfos.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(_loc86_.basicInfos.lastNameId).name;
               _loc89_ = _loc86_.guild.guildName;
               if(_loc89_ == "#NONAME#")
               {
                  _loc89_ = I18n.getUiText("ui.guild.noName");
               }
               _loc90_ = new WorldPointWrapper(_loc86_.basicInfos.mapId,true,_loc86_.basicInfos.worldX,_loc86_.basicInfos.worldY);
               _loc91_ = _loc90_.outdoorX;
               _loc92_ = _loc90_.outdoorY;
               if(!_loc86_.guild || _loc86_.guild.guildId == this._guild.guildId)
               {
                  if(_loc86_.deadOrAlive)
                  {
                     _loc87_ = I18n.getUiText("ui.social.TaxCollectorDied",[_loc88_,_loc91_ + "," + _loc92_]);
                  }
                  else
                  {
                     _loc87_ = I18n.getUiText("ui.social.TaxCollectorSurvived",[_loc88_,_loc91_ + "," + _loc92_]);
                  }
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc87_,ChatActivableChannelsEnum.CHANNEL_GUILD,TimeManager.getInstance().getTimestamp());
               }
               else
               {
                  if(_loc86_.deadOrAlive)
                  {
                     _loc87_ = I18n.getUiText("ui.alliance.taxCollectorDied",[_loc89_,_loc91_ + "," + _loc92_]);
                  }
                  else
                  {
                     _loc87_ = I18n.getUiText("ui.alliance.taxCollectorSurvived",[_loc89_,_loc91_ + "," + _loc92_]);
                  }
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc87_,ChatActivableChannelsEnum.CHANNEL_ALLIANCE,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is TaxCollectorErrorMessage:
               _loc93_ = param1 as TaxCollectorErrorMessage;
               _loc94_ = "";
               switch(_loc93_.reason)
               {
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_ALREADY_ONE:
                     _loc94_ = I18n.getUiText("ui.social.alreadyTaxCollectorOnMap");
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_CANT_HIRE_HERE:
                     _loc94_ = I18n.getUiText("ui.social.cantHireTaxCollecotrHere");
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_CANT_HIRE_YET:
                     _loc94_ = I18n.getUiText("ui.social.cantHireTaxcollectorTooTired");
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_ERROR_UNKNOWN:
                     _loc94_ = I18n.getUiText("ui.social.unknownErrorTaxCollector");
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_MAX_REACHED:
                     _loc94_ = I18n.getUiText("ui.social.cantHireMaxTaxCollector");
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_NO_RIGHTS:
                     _loc94_ = I18n.getUiText("ui.social.taxCollectorNoRights");
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_NOT_ENOUGH_KAMAS:
                     _loc94_ = I18n.getUiText("ui.social.notEnougthRichToHireTaxCollector");
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_NOT_FOUND:
                     _loc94_ = I18n.getUiText("ui.social.taxCollectorNotFound");
                     break;
                  case TaxCollectorErrorReasonEnum.TAX_COLLECTOR_NOT_OWNED:
                     _loc94_ = I18n.getUiText("ui.social.notYourTaxcollector");
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc94_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is TaxCollectorListMessage:
               _loc95_ = param1 as TaxCollectorListMessage;
               TaxCollectorsManager.getInstance().maxTaxCollectorsCount = _loc95_.nbcollectorMax;
               TaxCollectorsManager.getInstance().setTaxCollectors(_loc95_.informations);
               TaxCollectorsManager.getInstance().setTaxCollectorsFighters(_loc95_.fightersInformations);
               KernelEventsManager.getInstance().processCallback(SocialHookList.TaxCollectorListUpdate);
               return true;
            case param1 is TaxCollectorMovementAddMessage:
               _loc96_ = param1 as TaxCollectorMovementAddMessage;
               _loc97_ = -1;
               if(TaxCollectorsManager.getInstance().taxCollectors[_loc96_.informations.uniqueId])
               {
                  _loc97_ = TaxCollectorsManager.getInstance().taxCollectors[_loc96_.informations.uniqueId].state;
               }
               _loc98_ = TaxCollectorsManager.getInstance().addTaxCollector(_loc96_.informations);
               _loc99_ = TaxCollectorsManager.getInstance().taxCollectors[_loc96_.informations.uniqueId].state;
               if(_loc98_ || _loc99_ != _loc97_)
               {
                  KernelEventsManager.getInstance().processCallback(SocialHookList.TaxCollectorUpdate,_loc96_.informations.uniqueId);
               }
               if(_loc98_)
               {
                  KernelEventsManager.getInstance().processCallback(SocialHookList.GuildTaxCollectorAdd,TaxCollectorsManager.getInstance().taxCollectors[_loc96_.informations.uniqueId]);
               }
               return true;
            case param1 is TaxCollectorMovementRemoveMessage:
               _loc100_ = param1 as TaxCollectorMovementRemoveMessage;
               delete TaxCollectorsManager.getInstance().taxCollectors[_loc100_.collectorId];
               delete TaxCollectorsManager.getInstance().guildTaxCollectorsFighters[_loc100_.collectorId];
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildTaxCollectorRemoved,_loc100_.collectorId);
               return true;
            case param1 is TaxCollectorStateUpdateMessage:
               _loc101_ = param1 as TaxCollectorStateUpdateMessage;
               if(TaxCollectorsManager.getInstance().taxCollectors[_loc101_.uniqueId])
               {
                  TaxCollectorsManager.getInstance().taxCollectors[_loc101_.uniqueId].state = _loc101_.state;
               }
               if(TaxCollectorsManager.getInstance().allTaxCollectorsInPreFight[_loc101_.uniqueId])
               {
                  if(_loc101_.state != TaxCollectorStateEnum.STATE_WAITING_FOR_HELP)
                  {
                     delete TaxCollectorsManager.getInstance().allTaxCollectorsInPreFight[_loc101_.uniqueId];
                     KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceTaxCollectorRemoved,_loc101_.uniqueId);
                  }
               }
               return true;
            case param1 is TaxCollectorMovementsOfflineMessage:
               _loc102_ = param1 as TaxCollectorMovementsOfflineMessage;
               _loc110_ = "";
               _loc111_ = "";
               _loc112_ = 0;
               _loc113_ = 0;
               for each(_loc103_ in _loc102_.movements)
               {
                  _loc104_ = TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc103_.basicInfos.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(_loc103_.basicInfos.lastNameId).name;
                  _loc106_ = new WorldPointWrapper(_loc103_.basicInfos.mapId,true,_loc103_.basicInfos.worldX,_loc103_.basicInfos.worldY);
                  _loc107_ = SubArea.getSubAreaByMapId(_loc103_.basicInfos.mapId).worldmap.id;
                  _loc108_ = "{map," + _loc106_.outdoorX + "," + _loc106_.outdoorY + "," + _loc107_ + "}";
                  if(_loc103_.movementType == TaxCollectorMovementTypeEnum.TAX_COLLECTOR_HARVESTED)
                  {
                     _loc105_ = "{player," + _loc103_.playerName + "," + _loc103_.playerId + "}";
                     _loc110_ = _loc110_ + I18n.getUiText("ui.guild.taxCollectorNameWithLocAndPlayer",[_loc104_,_loc108_,_loc105_]);
                     _loc110_ = _loc110_ + ", ";
                     _loc112_++;
                  }
                  else if(_loc103_.movementType == TaxCollectorMovementTypeEnum.TAX_COLLECTOR_DEFEATED)
                  {
                     _loc111_ = _loc111_ + I18n.getUiText("ui.guild.taxCollectorNameWithLoc",[_loc104_,_loc108_]);
                     _loc111_ = _loc111_ + ", ";
                     _loc113_++;
                  }
               }
               if(_loc112_ > 0)
               {
                  _loc110_ = _loc110_.slice(0,_loc110_.length - 2);
                  if(_loc112_ == 1)
                  {
                     _loc109_ = I18n.getUiText("ui.guild.taxCollectorHarvestedWhileAbsence",[_loc110_]);
                  }
                  else
                  {
                     _loc109_ = I18n.getUiText("ui.guild.taxCollectorsHarvestedWhileAbsence",[_loc110_]);
                  }
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc109_,ChatActivableChannelsEnum.CHANNEL_GUILD,TimeManager.getInstance().getTimestamp());
               }
               if(_loc113_ > 0)
               {
                  _loc111_ = _loc111_.slice(0,_loc111_.length - 2);
                  if(_loc113_ == 1)
                  {
                     _loc109_ = I18n.getUiText("ui.guild.taxCollectorDefeatedWhileAbsence",[_loc111_]);
                  }
                  else
                  {
                     _loc109_ = I18n.getUiText("ui.guild.taxCollectorsDefeatedWhileAbsence",[_loc111_]);
                  }
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc109_,ChatActivableChannelsEnum.CHANNEL_GUILD,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is TopTaxCollectorListMessage:
               _loc114_ = param1 as TopTaxCollectorListMessage;
               if(_loc114_.isDungeon)
               {
                  this._dungeonTopTaxCollectors = _loc114_.informations;
               }
               else
               {
                  this._topTaxCollectors = _loc114_.informations;
               }
               if(this._dungeonTopTaxCollectors && this._topTaxCollectors)
               {
                  _loc225_ = new Vector.<TaxCollectorWrapper>(0);
                  _loc226_ = new Vector.<TaxCollectorWrapper>(0);
                  for each(_loc224_ in this._dungeonTopTaxCollectors)
                  {
                     _loc225_.push(TaxCollectorWrapper.create(_loc224_));
                  }
                  for each(_loc224_ in this._topTaxCollectors)
                  {
                     _loc226_.push(TaxCollectorWrapper.create(_loc224_));
                  }
                  KernelEventsManager.getInstance().processCallback(SocialHookList.ShowTopTaxCollectors,_loc225_,_loc226_);
                  this._dungeonTopTaxCollectors = null;
                  this._topTaxCollectors = null;
               }
               return true;
            case param1 is ExchangeGuildTaxCollectorGetMessage:
               _loc115_ = param1 as ExchangeGuildTaxCollectorGetMessage;
               for each(_loc117_ in _loc115_.objectsInfos)
               {
                  _loc116_ = _loc116_ + _loc117_.quantity;
               }
               _loc118_ = parseInt(_loc115_.collectorName.split(",")[0],36);
               _loc119_ = parseInt(_loc115_.collectorName.split(",")[1],36);
               _loc120_ = TaxCollectorsManager.getInstance().collectedTaxCollectors;
               _loc121_ = new TaxCollectorWrapper();
               _loc121_.uniqueId = _loc115_.mapId;
               _loc121_.firstName = TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc118_).firstname;
               _loc121_.lastName = TaxCollectorName.getTaxCollectorNameById(_loc119_).name;
               _loc121_.mapWorldX = _loc115_.worldX;
               _loc121_.mapWorldY = _loc115_.worldY;
               _loc121_.experience = _loc115_.experience;
               _loc121_.subareaId = _loc115_.subAreaId;
               _loc121_.collectedItems = _loc115_.objectsInfos;
               _loc121_.pods = _loc115_.pods;
               _loc121_.callerId = _loc115_.callerId;
               _loc121_.callerName = _loc115_.callerName;
               _loc120_[_loc121_.uniqueId] = _loc121_;
               _loc122_ = "{taxcollectorCollected," + _loc121_.uniqueId + "::" + PatternDecoder.combine(I18n.getUiText("ui.social.taxCollector.collected",[_loc115_.userName,_loc116_]),"n",_loc116_ <= 1) + "}";
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc122_,ChatActivableChannelsEnum.CHANNEL_GUILD,TimeManager.getInstance().getTimestamp(),false);
               return true;
            case param1 is GuildInformationsPaddocksMessage:
               _loc123_ = param1 as GuildInformationsPaddocksMessage;
               this._guildPaddocksMax = _loc123_.nbPaddockMax;
               this._guildPaddocks = _loc123_.paddocksInformations;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsFarms);
               return true;
            case param1 is GuildPaddockBoughtMessage:
               _loc124_ = param1 as GuildPaddockBoughtMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildPaddockAdd,_loc124_.paddockInfo);
               return true;
            case param1 is GuildPaddockRemovedMessage:
               _loc125_ = param1 as GuildPaddockRemovedMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildPaddockRemoved,_loc125_.paddockId);
               return true;
            case param1 is AllianceTaxCollectorDialogQuestionExtendedMessage:
               _loc126_ = param1 as AllianceTaxCollectorDialogQuestionExtendedMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.AllianceTaxCollectorDialogQuestionExtended,_loc126_.guildInfo.guildName,_loc126_.maxPods,_loc126_.prospecting,_loc126_.wisdom,_loc126_.taxCollectorsCount,_loc126_.taxCollectorAttack,_loc126_.kamas,_loc126_.experience,_loc126_.pods,_loc126_.itemsValue,_loc126_.alliance);
               return true;
            case param1 is TaxCollectorDialogQuestionExtendedMessage:
               _loc127_ = param1 as TaxCollectorDialogQuestionExtendedMessage;
               KernelEventsManager.getInstance().processCallback(SocialHookList.TaxCollectorDialogQuestionExtended,_loc127_.guildInfo.guildName,_loc127_.maxPods,_loc127_.prospecting,_loc127_.wisdom,_loc127_.taxCollectorsCount,_loc127_.taxCollectorAttack,_loc127_.kamas,_loc127_.experience,_loc127_.pods,_loc127_.itemsValue);
               return true;
            case param1 is TaxCollectorDialogQuestionBasicMessage:
               _loc128_ = param1 as TaxCollectorDialogQuestionBasicMessage;
               _loc129_ = GuildWrapper.create(0,_loc128_.guildInfo.guildName,null,0);
               KernelEventsManager.getInstance().processCallback(SocialHookList.TaxCollectorDialogQuestionBasic,_loc129_.guildName);
               return true;
            case param1 is ContactLookMessage:
               _loc130_ = param1 as ContactLookMessage;
               if(_loc130_.requestId == 0)
               {
                  KernelEventsManager.getInstance().processCallback(CraftHookList.JobCrafterContactLook,_loc130_.playerId,_loc130_.playerName,EntityLookAdapter.fromNetwork(_loc130_.look));
               }
               else
               {
                  KernelEventsManager.getInstance().processCallback(HookList.ContactLook,_loc130_.playerId,_loc130_.playerName,EntityLookAdapter.fromNetwork(_loc130_.look));
               }
               return true;
            case param1 is ContactLookErrorMessage:
               _loc131_ = param1 as ContactLookErrorMessage;
               return true;
            case param1 is GuildGetInformationsAction:
               _loc132_ = param1 as GuildGetInformationsAction;
               _loc133_ = true;
               switch(_loc132_.infoType)
               {
                  case GuildInformationsTypeEnum.INFO_MEMBERS:
                     break;
                  case GuildInformationsTypeEnum.INFO_HOUSES:
                     if(this._guildHousesList)
                     {
                        _loc133_ = false;
                        if(this._guildHousesListUpdate)
                        {
                           this._guildHousesListUpdate = false;
                           KernelEventsManager.getInstance().processCallback(SocialHookList.GuildHousesUpdate);
                        }
                     }
               }
               if(_loc133_)
               {
                  _loc227_ = new GuildGetInformationsMessage();
                  _loc227_.initGuildGetInformationsMessage(_loc132_.infoType);
                  ConnectionsHandler.getConnection().send(_loc227_);
               }
               return true;
            case param1 is GuildInvitationAction:
               _loc134_ = param1 as GuildInvitationAction;
               _loc135_ = new GuildInvitationMessage();
               _loc135_.initGuildInvitationMessage(_loc134_.targetId);
               ConnectionsHandler.getConnection().send(_loc135_);
               return true;
            case param1 is GuildInvitationByNameAction:
               _loc136_ = param1 as GuildInvitationByNameAction;
               _loc137_ = new GuildInvitationByNameMessage();
               _loc137_.initGuildInvitationByNameMessage(_loc136_.target);
               ConnectionsHandler.getConnection().send(_loc137_);
               return true;
            case param1 is GuildKickRequestAction:
               _loc138_ = param1 as GuildKickRequestAction;
               _loc139_ = new GuildKickRequestMessage();
               _loc139_.initGuildKickRequestMessage(_loc138_.targetId);
               ConnectionsHandler.getConnection().send(_loc139_);
               return true;
            case param1 is GuildChangeMemberParametersAction:
               _loc140_ = param1 as GuildChangeMemberParametersAction;
               _loc141_ = GuildWrapper.getRightsNumber(_loc140_.rights);
               _loc142_ = new GuildChangeMemberParametersMessage();
               _loc142_.initGuildChangeMemberParametersMessage(_loc140_.memberId,_loc140_.rank,_loc140_.experienceGivenPercent,_loc141_);
               ConnectionsHandler.getConnection().send(_loc142_);
               return true;
            case param1 is GuildSpellUpgradeRequestAction:
               _loc143_ = param1 as GuildSpellUpgradeRequestAction;
               _loc144_ = new GuildSpellUpgradeRequestMessage();
               _loc144_.initGuildSpellUpgradeRequestMessage(_loc143_.spellId);
               ConnectionsHandler.getConnection().send(_loc144_);
               return true;
            case param1 is GuildCharacsUpgradeRequestAction:
               _loc145_ = param1 as GuildCharacsUpgradeRequestAction;
               _loc146_ = new GuildCharacsUpgradeRequestMessage();
               _loc146_.initGuildCharacsUpgradeRequestMessage(_loc145_.charaTypeTarget);
               ConnectionsHandler.getConnection().send(_loc146_);
               return true;
            case param1 is GuildFarmTeleportRequestAction:
               _loc147_ = param1 as GuildFarmTeleportRequestAction;
               _loc148_ = new GuildPaddockTeleportRequestMessage();
               _loc148_.initGuildPaddockTeleportRequestMessage(_loc147_.farmId);
               ConnectionsHandler.getConnection().send(_loc148_);
               return true;
            case param1 is GuildHouseTeleportRequestAction:
               _loc149_ = param1 as GuildHouseTeleportRequestAction;
               _loc150_ = new GuildHouseTeleportRequestMessage();
               _loc150_.initGuildHouseTeleportRequestMessage(_loc149_.houseId);
               ConnectionsHandler.getConnection().send(_loc150_);
               return true;
            case param1 is GuildFightJoinRequestAction:
               _loc151_ = param1 as GuildFightJoinRequestAction;
               _loc152_ = new GuildFightJoinRequestMessage();
               _loc152_.initGuildFightJoinRequestMessage(_loc151_.taxCollectorId);
               ConnectionsHandler.getConnection().send(_loc152_);
               return true;
            case param1 is GuildFightTakePlaceRequestAction:
               _loc153_ = param1 as GuildFightTakePlaceRequestAction;
               _loc154_ = new GuildFightTakePlaceRequestMessage();
               _loc154_.initGuildFightTakePlaceRequestMessage(_loc153_.taxCollectorId,_loc153_.replacedCharacterId);
               ConnectionsHandler.getConnection().send(_loc154_);
               return true;
            case param1 is GuildFightLeaveRequestAction:
               _loc155_ = param1 as GuildFightLeaveRequestAction;
               this._autoLeaveHelpers = false;
               if(_loc155_.warning)
               {
                  for each(_loc228_ in TaxCollectorsManager.getInstance().taxCollectors)
                  {
                     if(_loc228_.state == TaxCollectorStateEnum.STATE_WAITING_FOR_HELP)
                     {
                        _loc229_ = TaxCollectorsManager.getInstance().allTaxCollectorsInPreFight[_loc228_.uniqueId];
                        for each(_loc230_ in _loc229_.allyCharactersInformations)
                        {
                           if(_loc230_.playerCharactersInformations.id == _loc155_.characterId)
                           {
                              this._autoLeaveHelpers = true;
                              _loc156_ = new GuildFightLeaveRequestMessage();
                              _loc156_.initGuildFightLeaveRequestMessage(_loc228_.uniqueId,_loc155_.characterId);
                              ConnectionsHandler.getConnection().send(_loc156_);
                           }
                        }
                     }
                  }
               }
               else
               {
                  _loc156_ = new GuildFightLeaveRequestMessage();
                  _loc156_.initGuildFightLeaveRequestMessage(_loc155_.taxCollectorId,_loc155_.characterId);
                  ConnectionsHandler.getConnection().send(_loc156_);
               }
               return true;
            case param1 is GuildHouseUpdateInformationMessage:
               if(this._guildHousesList)
               {
                  _loc231_ = param1 as GuildHouseUpdateInformationMessage;
                  _loc232_ = false;
                  for each(_loc233_ in this._guildHouses)
                  {
                     if(_loc233_.houseId == _loc231_.housesInformations.houseId)
                     {
                        _loc233_.update(_loc231_.housesInformations);
                        _loc232_ = true;
                     }
                     KernelEventsManager.getInstance().processCallback(SocialHookList.GuildHousesUpdate);
                  }
                  if(!_loc232_)
                  {
                     _loc234_ = GuildHouseWrapper.create(_loc231_.housesInformations);
                     this._guildHouses.push(_loc234_);
                     KernelEventsManager.getInstance().processCallback(SocialHookList.GuildHouseAdd,_loc234_);
                  }
                  this._guildHousesListUpdate = true;
               }
               return true;
            case param1 is GuildHouseRemoveMessage:
               if(this._guildHousesList)
               {
                  _loc235_ = param1 as GuildHouseRemoveMessage;
                  _loc236_ = false;
                  _loc237_ = 0;
                  while(_loc237_ < this._guildHouses.length)
                  {
                     if(this._guildHouses[_loc237_].houseId == _loc235_.houseId)
                     {
                        this._guildHouses.splice(_loc237_,1);
                        break;
                     }
                     _loc237_++;
                  }
                  this._guildHousesListUpdate = true;
                  KernelEventsManager.getInstance().processCallback(SocialHookList.GuildHouseRemoved,_loc235_.houseId);
               }
               return true;
            case param1 is GuildFactsRequestAction:
               _loc157_ = param1 as GuildFactsRequestAction;
               _loc158_ = new GuildFactsRequestMessage();
               _loc158_.initGuildFactsRequestMessage(_loc157_.guildId);
               ConnectionsHandler.getConnection().send(_loc158_);
               return true;
            case param1 is GuildFactsMessage:
               _loc159_ = param1 as GuildFactsMessage;
               _loc160_ = this._allGuilds[_loc159_.infos.guildId];
               _loc161_ = 0;
               _loc162_ = "";
               _loc163_ = "";
               if(param1 is GuildInAllianceFactsMessage)
               {
                  _loc238_ = param1 as GuildInAllianceFactsMessage;
                  _loc161_ = _loc238_.allianceInfos.allianceId;
                  _loc162_ = _loc238_.allianceInfos.allianceName;
                  _loc163_ = _loc238_.allianceInfos.allianceTag;
               }
               if(_loc160_)
               {
                  _loc160_.update(_loc159_.infos.guildId,_loc159_.infos.guildName,_loc159_.infos.guildEmblem,_loc159_.infos.leaderId,_loc160_.leaderName,_loc159_.infos.guildLevel,_loc159_.infos.nbMembers,_loc159_.creationDate,_loc159_.members,_loc160_.nbConnectedMembers,_loc159_.nbTaxCollectors,_loc160_.lastActivity,_loc161_,_loc162_,_loc163_,_loc160_.allianceLeader);
               }
               else
               {
                  _loc160_ = GuildFactSheetWrapper.create(_loc159_.infos.guildId,_loc159_.infos.guildName,_loc159_.infos.guildEmblem,_loc159_.infos.leaderId,"",_loc159_.infos.guildLevel,_loc159_.infos.nbMembers,_loc159_.creationDate,_loc159_.members,0,_loc159_.nbTaxCollectors,0,_loc161_,_loc162_,_loc163_);
                  this._allGuilds[_loc159_.infos.guildId] = _loc160_;
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.OpenOneGuild,_loc160_);
               return true;
            case param1 is GuildFactsErrorMessage:
               _loc164_ = param1 as GuildFactsErrorMessage;
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.guild.doesntExistAnymore"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is GuildMotdSetRequestAction:
               _loc165_ = param1 as GuildMotdSetRequestAction;
               _loc166_ = new GuildMotdSetRequestMessage();
               _loc166_.initGuildMotdSetRequestMessage(_loc165_.content);
               ConnectionsHandler.getConnection().send(_loc166_);
               return true;
            case param1 is GuildMotdMessage:
               _loc167_ = param1 as GuildMotdMessage;
               _loc168_ = _loc167_.content;
               _loc169_ = /</g;
               _loc168_ = _loc168_.replace(_loc169_,"&lt;");
               _loc170_ = (Kernel.getWorker().getFrame(ChatFrame) as ChatFrame).checkCensored(_loc168_,ChatActivableChannelsEnum.CHANNEL_GUILD,_loc167_.memberId,_loc167_.memberName);
               this._guild.motd = _loc167_.content;
               this._guild.formattedMotd = _loc170_[0];
               this._guild.motdWriterId = _loc167_.memberId;
               this._guild.motdWriterName = _loc167_.memberName;
               this._guild.motdTimestamp = _loc167_.timestamp;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildMotd);
               if(_loc167_.content != "" && !OptionManager.getOptionManager("dofus")["disableGuildMotd"])
               {
                  _loc239_ = I18n.getUiText("ui.motd.guild") + I18n.getUiText("ui.common.colon") + _loc170_[0];
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc239_,ChatActivableChannelsEnum.CHANNEL_GUILD,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is GuildMotdSetErrorMessage:
               _loc171_ = param1 as GuildMotdSetErrorMessage;
               switch(_loc171_.reason)
               {
                  case SocialNoticeErrorEnum.SOCIAL_NOTICE_UNKNOWN_ERROR:
                     _loc2_ = I18n.getUiText("ui.common.unknownFail");
                     break;
                  case SocialNoticeErrorEnum.SOCIAL_NOTICE_COOLDOWN:
                     _loc2_ = I18n.getUiText("ui.motd.errorCooldown");
                     break;
                  case SocialNoticeErrorEnum.SOCIAL_NOTICE_INVALID_RIGHTS:
                     _loc2_ = I18n.getUiText("ui.social.taxCollectorNoRights");
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc2_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is GuildBulletinSetRequestAction:
               _loc172_ = param1 as GuildBulletinSetRequestAction;
               _loc173_ = new GuildBulletinSetRequestMessage();
               _loc173_.initGuildBulletinSetRequestMessage(_loc172_.content,_loc172_.notifyMembers);
               ConnectionsHandler.getConnection().send(_loc173_);
               return true;
            case param1 is GuildBulletinMessage:
               _loc174_ = param1 as GuildBulletinMessage;
               _loc168_ = _loc174_.content;
               _loc169_ = /</g;
               _loc168_ = _loc168_.replace(_loc169_,"&lt;");
               _loc175_ = (Kernel.getWorker().getFrame(ChatFrame) as ChatFrame).checkCensored(_loc168_,ChatActivableChannelsEnum.CHANNEL_GUILD,_loc174_.memberId,_loc174_.memberName);
               this._guild.bulletin = _loc174_.content;
               this._guild.formattedBulletin = _loc175_[0];
               this._guild.bulletinWriterId = _loc174_.memberId;
               this._guild.bulletinWriterName = _loc174_.memberName;
               this._guild.bulletinTimestamp = _loc174_.timestamp;
               this._guild.lastNotifiedTimestamp = _loc174_.lastNotifiedTimestamp;
               KernelEventsManager.getInstance().processCallback(SocialHookList.GuildBulletin);
               return true;
            case param1 is GuildBulletinSetErrorMessage:
               _loc176_ = param1 as GuildBulletinSetErrorMessage;
               switch(_loc176_.reason)
               {
                  case SocialNoticeErrorEnum.SOCIAL_NOTICE_UNKNOWN_ERROR:
                     _loc2_ = I18n.getUiText("ui.common.unknownFail");
                     break;
                  case SocialNoticeErrorEnum.SOCIAL_NOTICE_COOLDOWN:
                     _loc2_ = I18n.getUiText("ui.motd.errorCooldown");
                     break;
                  case SocialNoticeErrorEnum.SOCIAL_NOTICE_INVALID_RIGHTS:
                     _loc2_ = I18n.getUiText("ui.social.taxCollectorNoRights");
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc2_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is CharacterReportAction:
               _loc177_ = param1 as CharacterReportAction;
               _loc178_ = new CharacterReportMessage();
               _loc178_.initCharacterReportMessage(_loc177_.reportedId,_loc177_.reason);
               ConnectionsHandler.getConnection().send(_loc178_);
               return true;
            case param1 is ChatReportAction:
               _loc179_ = param1 as ChatReportAction;
               _loc180_ = new ChatMessageReportMessage();
               _loc181_ = (Kernel.getWorker().getFrame(ChatFrame) as ChatFrame).getTimestampServerByRealTimestamp(_loc179_.timestamp);
               _loc180_.initChatMessageReportMessage(_loc179_.name,_loc179_.message,_loc181_,_loc179_.channel,_loc179_.fingerprint,_loc179_.reason);
               ConnectionsHandler.getConnection().send(_loc180_);
               return true;
            case param1 is PlayerStatusUpdateMessage:
               _loc182_ = param1 as PlayerStatusUpdateMessage;
               _loc183_ = "";
               if(_loc182_.status is PlayerStatusExtended)
               {
                  _loc183_ = PlayerStatusExtended(_loc182_.status).message;
               }
               KernelEventsManager.getInstance().processCallback(SocialHookList.PlayerStatusUpdate,_loc182_.accountId,_loc182_.playerId,_loc182_.status.statusId,_loc183_);
               if(this._guildMembers != null)
               {
                  _loc241_ = this._guildMembers.length;
                  _loc242_ = 0;
                  while(_loc242_ < _loc241_)
                  {
                     if(this._guildMembers[_loc242_].id == _loc182_.playerId)
                     {
                        this._guildMembers[_loc242_].status = _loc182_.status;
                        _loc240_ = this._guildMembers[_loc242_];
                        KernelEventsManager.getInstance().processCallback(SocialHookList.GuildInformationsMemberUpdate,_loc240_);
                        break;
                     }
                     _loc242_++;
                  }
               }
               if(this._friendsList != null)
               {
                  for each(_loc243_ in this._friendsList)
                  {
                     if(_loc243_.accountId == _loc182_.accountId)
                     {
                        _loc243_.statusId = _loc182_.status.statusId;
                        if(_loc182_.status is PlayerStatusExtended)
                        {
                           _loc243_.awayMessage = PlayerStatusExtended(_loc182_.status).message;
                        }
                        KernelEventsManager.getInstance().processCallback(SocialHookList.FriendsListUpdated);
                        break;
                     }
                  }
               }
               return false;
            case param1 is PlayerStatusUpdateErrorMessage:
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.chat.status.awaymessageerror"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return false;
            case param1 is PlayerStatusUpdateRequestAction:
               _loc184_ = param1 as PlayerStatusUpdateRequestAction;
               if(_loc184_.message)
               {
                  _loc244_ = new ChatApi();
                  _loc184_.message = _loc244_.escapeChatString(_loc184_.message);
                  _loc185_ = new PlayerStatusExtended();
                  PlayerStatusExtended(_loc185_).initPlayerStatusExtended(_loc184_.status,_loc184_.message);
               }
               else
               {
                  _loc185_ = new PlayerStatus();
                  _loc185_.initPlayerStatus(_loc184_.status);
               }
               _loc186_ = new PlayerStatusUpdateRequestMessage();
               _loc186_.initPlayerStatusUpdateRequestMessage(_loc185_);
               ConnectionsHandler.getConnection().send(_loc186_);
               return true;
            case param1 is ContactLookRequestByIdAction:
               _loc187_ = param1 as ContactLookRequestByIdAction;
               if(_loc187_.entityId == PlayedCharacterManager.getInstance().id)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.ContactLook,PlayedCharacterManager.getInstance().id,PlayedCharacterManager.getInstance().infos.name,EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook));
               }
               else
               {
                  _loc245_ = new ContactLookRequestByIdMessage();
                  _loc245_.initContactLookRequestByIdMessage(1,_loc187_.contactType,_loc187_.entityId);
                  ConnectionsHandler.getConnection().send(_loc245_);
               }
               return true;
            default:
               return false;
         }
      }
      
      public function isIgnored(param1:String, param2:int = 0) : Boolean
      {
         var _loc4_:IgnoredWrapper = null;
         var _loc3_:String = AccountManager.getInstance().getAccountName(param1);
         for each(_loc4_ in this._ignoredList)
         {
            if(param2 != 0 && _loc4_.accountId == param2 || _loc3_ && _loc4_.name.toLowerCase() == _loc3_.toLowerCase())
            {
               return true;
            }
         }
         return false;
      }
      
      public function isFriend(param1:String) : Boolean
      {
         var _loc4_:FriendWrapper = null;
         var _loc2_:int = this._friendsList.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._friendsList[_loc3_];
            if(_loc4_.playerName == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function isEnemy(param1:String) : Boolean
      {
         var _loc4_:EnemyWrapper = null;
         var _loc2_:int = this._enemiesList.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._enemiesList[_loc3_];
            if(_loc4_.playerName == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
   }
}
