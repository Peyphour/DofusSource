package
{
   import d2api.AlignmentApi;
   import d2api.AveragePricesApi;
   import d2api.BindsApi;
   import d2api.CaptureApi;
   import d2api.ChatApi;
   import d2api.ColorApi;
   import d2api.ConfigApi;
   import d2api.ConnectionApi;
   import d2api.ContextMenuApi;
   import d2api.DataApi;
   import d2api.DocumentApi;
   import d2api.ExchangeApi;
   import d2api.ExternalNotificationApi;
   import d2api.FightApi;
   import d2api.FileApi;
   import d2api.HighlightApi;
   import d2api.InventoryApi;
   import d2api.JobsApi;
   import d2api.MapApi;
   import d2api.MountApi;
   import d2api.NotificationApi;
   import d2api.PartyApi;
   import d2api.PlayedCharacterApi;
   import d2api.QuestApi;
   import d2api.RoleplayApi;
   import d2api.SecurityApi;
   import d2api.SocialApi;
   import d2api.SoundApi;
   import d2api.StorageApi;
   import d2api.SystemApi;
   import d2api.TestApi;
   import d2api.TimeApi;
   import d2api.TooltipApi;
   import d2api.UiApi;
   import d2api.UpdaterApi;
   import d2api.UtilApi;
   import d2components.ButtonContainer;
   import d2components.CharacterWheel;
   import d2components.ChatComponent;
   import d2components.ColorPicker;
   import d2components.ComboBox;
   import d2components.EntityDisplayer;
   import d2components.GraphicContainer;
   import d2components.Grid;
   import d2components.Input;
   import d2components.InputComboBox;
   import d2components.Label;
   import d2components.MapViewer;
   import d2components.MockFinalizableUIComponent;
   import d2components.ProgressBar;
   import d2components.ScrollBar;
   import d2components.ScrollContainer;
   import d2components.Slider;
   import d2components.Slot;
   import d2components.SpellZoneComponent;
   import d2components.StateContainer;
   import d2components.SwfApplication;
   import d2components.TabSet;
   import d2components.TextArea;
   import d2components.TextAreaInput;
   import d2components.Texture;
   import d2components.TextureBase;
   import d2components.TextureBitmap;
   import d2components.Tree;
   import d2components.VideoPlayer;
   import d2components.WebBrowser;
   import d2data.AbuseReasons;
   import d2data.AccountRightsItemCriterion;
   import d2data.Achievement;
   import d2data.AchievementCategory;
   import d2data.AchievementItemCriterion;
   import d2data.AchievementObjective;
   import d2data.AchievementReward;
   import d2data.ActionDescription;
   import d2data.AlignmentBalance;
   import d2data.AlignmentEffect;
   import d2data.AlignmentGift;
   import d2data.AlignmentItemCriterion;
   import d2data.AlignmentLevelItemCriterion;
   import d2data.AlignmentOrder;
   import d2data.AlignmentRank;
   import d2data.AlignmentRankJntGift;
   import d2data.AlignmentSide;
   import d2data.AlignmentTitle;
   import d2data.AllianceAvAItemCriterion;
   import d2data.AllianceItemCriterion;
   import d2data.AllianceOnTheHillWrapper;
   import d2data.AllianceRightsItemCriterion;
   import d2data.AllianceWrapper;
   import d2data.AlmanaxCalendar;
   import d2data.AlmanaxEvent;
   import d2data.AlmanaxMonth;
   import d2data.AlmanaxZodiac;
   import d2data.AmbientSound;
   import d2data.Appearance;
   import d2data.Area;
   import d2data.AreaItemCriterion;
   import d2data.ArenaMaxSoloRankCriterion;
   import d2data.ArenaMaxTeamRankCriterion;
   import d2data.ArenaRankInfosWrapper;
   import d2data.ArenaSoloRankCriterion;
   import d2data.ArenaTeamRankCriterion;
   import d2data.BasicCharacterWrapper;
   import d2data.BasicChatSentence;
   import d2data.Bind;
   import d2data.BonesItemCriterion;
   import d2data.Bonus;
   import d2data.BonusCriterion;
   import d2data.BonusSetItemCriterion;
   import d2data.Breed;
   import d2data.BreedItemCriterion;
   import d2data.BreedRole;
   import d2data.BreedRoleByBreed;
   import d2data.ButtonWrapper;
   import d2data.CensoredContent;
   import d2data.CensoredWord;
   import d2data.Challenge;
   import d2data.ChallengeWrapper;
   import d2data.Characteristic;
   import d2data.CharacteristicCategory;
   import d2data.ChatBubble;
   import d2data.ChatChannel;
   import d2data.ChatInformationSentence;
   import d2data.ChatSentenceWithRecipient;
   import d2data.ChatSentenceWithSource;
   import d2data.Comic;
   import d2data.CommunityItemCriterion;
   import d2data.Companion;
   import d2data.CompanionCharacteristic;
   import d2data.CompanionSpell;
   import d2data.ContextMenuData;
   import d2data.CraftSmileyItem;
   import d2data.CraftsmanWrapper;
   import d2data.CreationCharacterWrapper;
   import d2data.CreatureBoneOverride;
   import d2data.CreatureBoneType;
   import d2data.CriterionManager;
   import d2data.CriterionUtils;
   import d2data.DareCriteria;
   import d2data.DareCriteriaWrapper;
   import d2data.DareWrapper;
   import d2data.DayItemCriterion;
   import d2data.DelayedActionItem;
   import d2data.Document;
   import d2data.DofusShopArticle;
   import d2data.DofusShopArticleReference;
   import d2data.DofusShopCategory;
   import d2data.DofusShopHighlight;
   import d2data.DofusShopObject;
   import d2data.Dungeon;
   import d2data.Effect;
   import d2data.EffectInstance;
   import d2data.EffectInstanceCreature;
   import d2data.EffectInstanceDate;
   import d2data.EffectInstanceDice;
   import d2data.EffectInstanceDuration;
   import d2data.EffectInstanceInteger;
   import d2data.EffectInstanceLadder;
   import d2data.EffectInstanceMinMax;
   import d2data.EffectInstanceMount;
   import d2data.EffectInstanceString;
   import d2data.EffectsListWrapper;
   import d2data.EffectsWrapper;
   import d2data.EmblemBackground;
   import d2data.EmblemSymbol;
   import d2data.EmblemSymbolCategory;
   import d2data.EmblemWrapper;
   import d2data.EmoteItemCriterion;
   import d2data.EmoteWrapper;
   import d2data.Emoticon;
   import d2data.EnemyWrapper;
   import d2data.ExternalNotification;
   import d2data.FightLootWrapper;
   import d2data.FightResultEntryWrapper;
   import d2data.FighterInformations;
   import d2data.FriendWrapper;
   import d2data.FriendlistItemCriterion;
   import d2data.GiftItemCriterion;
   import d2data.GridItem;
   import d2data.GroupItemCriterion;
   import d2data.GuildFactSheetWrapper;
   import d2data.GuildHouseWrapper;
   import d2data.GuildItemCriterion;
   import d2data.GuildLevelItemCriterion;
   import d2data.GuildRightsItemCriterion;
   import d2data.GuildWrapper;
   import d2data.HavenbagFurniture;
   import d2data.HavenbagFurnitureWrapper;
   import d2data.HavenbagTheme;
   import d2data.Head;
   import d2data.Hint;
   import d2data.HintCategory;
   import d2data.House;
   import d2data.HouseWrapper;
   import d2data.Idol;
   import d2data.IgnoredWrapper;
   import d2data.Incarnation;
   import d2data.IncarnationLevel;
   import d2data.InfoMessage;
   import d2data.Interactive;
   import d2data.Item;
   import d2data.ItemCriterion;
   import d2data.ItemCriterionFactory;
   import d2data.ItemCriterionOperator;
   import d2data.ItemSet;
   import d2data.ItemType;
   import d2data.ItemWrapper;
   import d2data.Job;
   import d2data.JobItemCriterion;
   import d2data.JobWrapper;
   import d2data.KamaItemCriterion;
   import d2data.KnownJobWrapper;
   import d2data.LegendaryTreasureHunt;
   import d2data.LevelItemCriterion;
   import d2data.LivingObjectSkinJntMood;
   import d2data.MapCharactersItemCriterion;
   import d2data.MapCoordinates;
   import d2data.MapPosition;
   import d2data.MapReference;
   import d2data.MapScrollAction;
   import d2data.MariedItemCriterion;
   import d2data.Monster;
   import d2data.MonsterDrop;
   import d2data.MonsterGrade;
   import d2data.MonsterMiniBoss;
   import d2data.MonsterRace;
   import d2data.MonsterSuperRace;
   import d2data.Month;
   import d2data.MonthItemCriterion;
   import d2data.Mount;
   import d2data.MountBehavior;
   import d2data.MountBone;
   import d2data.MountData;
   import d2data.MountFamily;
   import d2data.MountFamilyItemCriterion;
   import d2data.MountWrapper;
   import d2data.NameItemCriterion;
   import d2data.Notification;
   import d2data.Npc;
   import d2data.NpcAction;
   import d2data.NpcMessage;
   import d2data.ObjectItemCriterion;
   import d2data.OfflineSaleWrapper;
   import d2data.OptionalFeature;
   import d2data.Ornament;
   import d2data.OrnamentWrapper;
   import d2data.PVPRankItemCriterion;
   import d2data.Pack;
   import d2data.PaddockWrapper;
   import d2data.PartyCompanionWrapper;
   import d2data.PartyMemberWrapper;
   import d2data.Pet;
   import d2data.Phoenix;
   import d2data.Playlist;
   import d2data.PlaylistSound;
   import d2data.PointOfInterest;
   import d2data.PointOfInterestCategory;
   import d2data.PremiumAccountItemCriterion;
   import d2data.PresetIcon;
   import d2data.PresetWrapper;
   import d2data.PrismFightersWrapper;
   import d2data.PrismSubAreaWrapper;
   import d2data.QuantifiedItemWrapper;
   import d2data.Quest;
   import d2data.QuestCategory;
   import d2data.QuestItemCriterion;
   import d2data.QuestObjective;
   import d2data.QuestObjectiveBringItemToNpc;
   import d2data.QuestObjectiveBringSoulToNpc;
   import d2data.QuestObjectiveCraftItem;
   import d2data.QuestObjectiveDiscoverMap;
   import d2data.QuestObjectiveDiscoverSubArea;
   import d2data.QuestObjectiveDuelSpecificPlayer;
   import d2data.QuestObjectiveFightMonster;
   import d2data.QuestObjectiveFightMonstersOnMap;
   import d2data.QuestObjectiveFreeForm;
   import d2data.QuestObjectiveGoToNpc;
   import d2data.QuestObjectiveMultiFightMonster;
   import d2data.QuestObjectiveType;
   import d2data.QuestStep;
   import d2data.QuestStepRewards;
   import d2data.RankName;
   import d2data.Recipe;
   import d2data.RecipeWithSkill;
   import d2data.RestrictedAreaItemCriterion;
   import d2data.RideFood;
   import d2data.RideItemCriterion;
   import d2data.Server;
   import d2data.ServerCommunity;
   import d2data.ServerGameType;
   import d2data.ServerItemCriterion;
   import d2data.ServerPopulation;
   import d2data.SexItemCriterion;
   import d2data.Shortcut;
   import d2data.ShortcutWrapper;
   import d2data.SimpleTextureWrapper;
   import d2data.Skill;
   import d2data.SkillItemCriterion;
   import d2data.SkillName;
   import d2data.SkinMapping;
   import d2data.SkinPosition;
   import d2data.Smiley;
   import d2data.SmileyCategory;
   import d2data.SmileyPack;
   import d2data.SmileyPackItemCriterion;
   import d2data.SmileyWrapper;
   import d2data.SocialEntityInFightWrapper;
   import d2data.SocialFightersWrapper;
   import d2data.SoulStoneItemCriterion;
   import d2data.SoundAnimation;
   import d2data.SoundBones;
   import d2data.SoundUi;
   import d2data.SoundUiElement;
   import d2data.SoundUiHook;
   import d2data.SpeakingItemText;
   import d2data.SpeakingItemsTrigger;
   import d2data.SpecializationItemCriterion;
   import d2data.Spell;
   import d2data.SpellBomb;
   import d2data.SpellItemCriterion;
   import d2data.SpellLevel;
   import d2data.SpellPair;
   import d2data.SpellState;
   import d2data.SpellType;
   import d2data.SpellWrapper;
   import d2data.SpouseWrapper;
   import d2data.StaticCriterionItemCriterion;
   import d2data.StealthBones;
   import d2data.SubArea;
   import d2data.SubareaItemCriterion;
   import d2data.SubscribeItemCriterion;
   import d2data.SubscriberGift;
   import d2data.SubscriptionDurationItemCriterion;
   import d2data.SuperArea;
   import d2data.TaxCollectorFirstname;
   import d2data.TaxCollectorName;
   import d2data.TaxCollectorWrapper;
   import d2data.TeleportDestinationWrapper;
   import d2data.ThinkBubble;
   import d2data.Tips;
   import d2data.Title;
   import d2data.TitleCategory;
   import d2data.TitleWrapper;
   import d2data.TradeStockItemWrapper;
   import d2data.TreasureHuntStepWrapper;
   import d2data.TreasureHuntWrapper;
   import d2data.TypeAction;
   import d2data.UnusableItemCriterion;
   import d2data.Url;
   import d2data.Version;
   import d2data.VeteranReward;
   import d2data.Waypoint;
   import d2data.Weapon;
   import d2data.WeaponWrapper;
   import d2data.WeightItemCriterion;
   import d2data.WorldMap;
   import d2data.WorldPoint;
   import d2data.WorldPointWrapper;
   import d2network.AbstractCharacterInformation;
   import d2network.AbstractCharacterToRefurbishInformation;
   import d2network.AbstractContactInformations;
   import d2network.AbstractFightDispellableEffect;
   import d2network.AbstractFightTeamInformations;
   import d2network.AbstractSocialGroupInfos;
   import d2network.AccountHouseInformations;
   import d2network.AchievementRewardable;
   import d2network.AchievementStartedObjective;
   import d2network.ActorAlignmentInformations;
   import d2network.ActorExtendedAlignmentInformations;
   import d2network.ActorOrientation;
   import d2network.ActorRestrictionsInformations;
   import d2network.AdditionalTaxCollectorInformations;
   import d2network.AllianceFactSheetInformations;
   import d2network.AllianceInformations;
   import d2network.AllianceInsiderPrismInformation;
   import d2network.AlliancePrismInformation;
   import d2network.AllianceVersatileInformations;
   import d2network.AlliancedGuildFactSheetInformations;
   import d2network.AlternativeMonstersInGroupLightInformations;
   import d2network.ArenaRankInfos;
   import d2network.AtlasPointsInformations;
   import d2network.BasicAllianceInformations;
   import d2network.BasicGuildInformations;
   import d2network.BasicNamedAllianceInformations;
   import d2network.BidExchangerObjectInfo;
   import d2network.CharacterBaseCharacteristic;
   import d2network.CharacterBaseInformations;
   import d2network.CharacterBasicMinimalInformations;
   import d2network.CharacterCharacteristicsInformations;
   import d2network.CharacterHardcoreOrEpicInformations;
   import d2network.CharacterMinimalAllianceInformations;
   import d2network.CharacterMinimalGuildInformations;
   import d2network.CharacterMinimalInformations;
   import d2network.CharacterMinimalPlusLookAndGradeInformations;
   import d2network.CharacterMinimalPlusLookInformations;
   import d2network.CharacterRemodelingInformation;
   import d2network.CharacterSpellModification;
   import d2network.CharacterToRecolorInformation;
   import d2network.CharacterToRelookInformation;
   import d2network.CharacterToRemodelInformations;
   import d2network.ContentPart;
   import d2network.DareInformations;
   import d2network.DareReward;
   import d2network.DareVersatileInformations;
   import d2network.DecraftedItemStackInfo;
   import d2network.DungeonPartyFinderPlayer;
   import d2network.EntityDispositionInformations;
   import d2network.EntityLook;
   import d2network.EntityMovementInformations;
   import d2network.FightAllianceTeamInformations;
   import d2network.FightCommonInformations;
   import d2network.FightDispellableEffectExtendedInformations;
   import d2network.FightEntityDispositionInformations;
   import d2network.FightExternalInformations;
   import d2network.FightLoot;
   import d2network.FightOptionsInformations;
   import d2network.FightResultAdditionalData;
   import d2network.FightResultExperienceData;
   import d2network.FightResultFighterListEntry;
   import d2network.FightResultListEntry;
   import d2network.FightResultMutantListEntry;
   import d2network.FightResultPlayerListEntry;
   import d2network.FightResultPvpData;
   import d2network.FightResultTaxCollectorListEntry;
   import d2network.FightTeamInformations;
   import d2network.FightTeamLightInformations;
   import d2network.FightTeamMemberCharacterInformations;
   import d2network.FightTeamMemberCompanionInformations;
   import d2network.FightTeamMemberInformations;
   import d2network.FightTeamMemberMonsterInformations;
   import d2network.FightTeamMemberTaxCollectorInformations;
   import d2network.FightTeamMemberWithAllianceCharacterInformations;
   import d2network.FightTemporaryBoostEffect;
   import d2network.FightTemporaryBoostStateEffect;
   import d2network.FightTemporaryBoostWeaponDamagesEffect;
   import d2network.FightTemporarySpellBoostEffect;
   import d2network.FightTemporarySpellImmunityEffect;
   import d2network.FightTriggeredEffect;
   import d2network.FriendInformations;
   import d2network.FriendOnlineInformations;
   import d2network.FriendSpouseInformations;
   import d2network.FriendSpouseOnlineInformations;
   import d2network.GameActionMark;
   import d2network.GameActionMarkedCell;
   import d2network.GameContextActorInformations;
   import d2network.GameFightAIInformations;
   import d2network.GameFightCharacterInformations;
   import d2network.GameFightCompanionInformations;
   import d2network.GameFightFighterCompanionLightInformations;
   import d2network.GameFightFighterInformations;
   import d2network.GameFightFighterLightInformations;
   import d2network.GameFightFighterMonsterLightInformations;
   import d2network.GameFightFighterNamedInformations;
   import d2network.GameFightFighterNamedLightInformations;
   import d2network.GameFightFighterTaxCollectorLightInformations;
   import d2network.GameFightMinimalStats;
   import d2network.GameFightMinimalStatsPreparation;
   import d2network.GameFightMonsterInformations;
   import d2network.GameFightMonsterWithAlignmentInformations;
   import d2network.GameFightMutantInformations;
   import d2network.GameFightResumeSlaveInfo;
   import d2network.GameFightSpellCooldown;
   import d2network.GameFightTaxCollectorInformations;
   import d2network.GameRolePlayActorInformations;
   import d2network.GameRolePlayCharacterInformations;
   import d2network.GameRolePlayGroupMonsterInformations;
   import d2network.GameRolePlayGroupMonsterWaveInformations;
   import d2network.GameRolePlayHumanoidInformations;
   import d2network.GameRolePlayMerchantInformations;
   import d2network.GameRolePlayMountInformations;
   import d2network.GameRolePlayMutantInformations;
   import d2network.GameRolePlayNamedActorInformations;
   import d2network.GameRolePlayNpcInformations;
   import d2network.GameRolePlayNpcQuestFlag;
   import d2network.GameRolePlayNpcWithQuestInformations;
   import d2network.GameRolePlayPortalInformations;
   import d2network.GameRolePlayPrismInformations;
   import d2network.GameRolePlayTaxCollectorInformations;
   import d2network.GameRolePlayTreasureHintInformations;
   import d2network.GameServerInformations;
   import d2network.GoldItem;
   import d2network.GroupMonsterStaticInformations;
   import d2network.GroupMonsterStaticInformationsWithAlternatives;
   import d2network.GuildEmblem;
   import d2network.GuildFactSheetInformations;
   import d2network.GuildInAllianceInformations;
   import d2network.GuildInAllianceVersatileInformations;
   import d2network.GuildInformations;
   import d2network.GuildInsiderFactSheetInformations;
   import d2network.GuildMember;
   import d2network.GuildVersatileInformations;
   import d2network.HavenBagFurnitureInformation;
   import d2network.HouseInformations;
   import d2network.HouseInformationsExtended;
   import d2network.HouseInformationsForGuild;
   import d2network.HouseInformationsForSell;
   import d2network.HouseInformationsInside;
   import d2network.HumanInformations;
   import d2network.HumanOption;
   import d2network.HumanOptionAlliance;
   import d2network.HumanOptionEmote;
   import d2network.HumanOptionFollowers;
   import d2network.HumanOptionGuild;
   import d2network.HumanOptionObjectUse;
   import d2network.HumanOptionOrnament;
   import d2network.HumanOptionSkillUse;
   import d2network.HumanOptionTitle;
   import d2network.IdentifiedEntityDispositionInformations;
   import d2network.IdolsPreset;
   import d2network.IgnoredInformations;
   import d2network.IgnoredOnlineInformations;
   import d2network.IndexedEntityLook;
   import d2network.InteractiveElement;
   import d2network.InteractiveElementNamedSkill;
   import d2network.InteractiveElementSkill;
   import d2network.InteractiveElementWithAgeBonus;
   import d2network.ItemDurability;
   import d2network.JobBookSubscription;
   import d2network.JobCrafterDirectoryEntryJobInfo;
   import d2network.JobCrafterDirectoryEntryPlayerInfo;
   import d2network.JobCrafterDirectoryListEntry;
   import d2network.JobCrafterDirectorySettings;
   import d2network.JobDescription;
   import d2network.JobExperience;
   import d2network.KrosmasterFigure;
   import d2network.MapCoordinatesAndId;
   import d2network.MapCoordinatesExtended;
   import d2network.MapObstacle;
   import d2network.MonsterBoosts;
   import d2network.MonsterInGroupInformations;
   import d2network.MonsterInGroupLightInformations;
   import d2network.MountClientData;
   import d2network.MountInformationsForPaddock;
   import d2network.NamedPartyTeam;
   import d2network.NamedPartyTeamWithOutcome;
   import d2network.NpcStaticInformations;
   import d2network.ObjectEffect;
   import d2network.ObjectEffectCreature;
   import d2network.ObjectEffectDate;
   import d2network.ObjectEffectDice;
   import d2network.ObjectEffectDuration;
   import d2network.ObjectEffectInteger;
   import d2network.ObjectEffectLadder;
   import d2network.ObjectEffectMinMax;
   import d2network.ObjectEffectMount;
   import d2network.ObjectEffectString;
   import d2network.ObjectEffects;
   import d2network.ObjectItem;
   import d2network.ObjectItemGenericQuantity;
   import d2network.ObjectItemGenericQuantityPrice;
   import d2network.ObjectItemInRolePlay;
   import d2network.ObjectItemInformationWithQuantity;
   import d2network.ObjectItemMinimalInformation;
   import d2network.ObjectItemNotInContainer;
   import d2network.ObjectItemQuantity;
   import d2network.ObjectItemToSell;
   import d2network.ObjectItemToSellInBid;
   import d2network.ObjectItemToSellInHumanVendorShop;
   import d2network.ObjectItemToSellInNpcShop;
   import d2network.ObjectItemWithLookInRolePlay;
   import d2network.OrientedObjectItemWithLookInRolePlay;
   import d2network.PaddockAbandonnedInformations;
   import d2network.PaddockBuyableInformations;
   import d2network.PaddockContentInformations;
   import d2network.PaddockInformations;
   import d2network.PaddockInformationsForSell;
   import d2network.PaddockItem;
   import d2network.PaddockPrivateInformations;
   import d2network.PartyCompanionBaseInformations;
   import d2network.PartyCompanionMemberInformations;
   import d2network.PartyGuestInformations;
   import d2network.PartyIdol;
   import d2network.PartyInvitationMemberInformations;
   import d2network.PartyMemberArenaInformations;
   import d2network.PartyMemberGeoPosition;
   import d2network.PartyMemberInformations;
   import d2network.PartyUpdateCommonsInformations;
   import d2network.PlayerStatus;
   import d2network.PlayerStatusExtended;
   import d2network.PortalInformation;
   import d2network.Preset;
   import d2network.PresetItem;
   import d2network.PrismFightersInformation;
   import d2network.PrismGeolocalizedInformation;
   import d2network.PrismInformation;
   import d2network.PrismSubareaEmptyInfo;
   import d2network.ProtectedEntityWaitingForHelpInfo;
   import d2network.QuestActiveDetailedInformations;
   import d2network.QuestActiveInformations;
   import d2network.QuestObjectiveInformations;
   import d2network.QuestObjectiveInformationsWithCompletion;
   import d2network.RemodelingInformation;
   import d2network.RemodelingInformations;
   import d2network.SellerBuyerDescriptor;
   import d2network.ServerSessionConstant;
   import d2network.ServerSessionConstantInteger;
   import d2network.ServerSessionConstantLong;
   import d2network.ServerSessionConstantString;
   import d2network.ShortcutEmote;
   import d2network.ShortcutObject;
   import d2network.ShortcutObjectIdolsPreset;
   import d2network.ShortcutObjectItem;
   import d2network.ShortcutObjectPreset;
   import d2network.ShortcutSmiley;
   import d2network.ShortcutSpell;
   import d2network.SkillActionDescription;
   import d2network.SkillActionDescriptionCollect;
   import d2network.SkillActionDescriptionCraft;
   import d2network.SkillActionDescriptionTimed;
   import d2network.SpellItem;
   import d2network.StartupActionAddObject;
   import d2network.StatedElement;
   import d2network.StatisticData;
   import d2network.StatisticDataBoolean;
   import d2network.StatisticDataByte;
   import d2network.StatisticDataInt;
   import d2network.StatisticDataShort;
   import d2network.StatisticDataString;
   import d2network.SubEntity;
   import d2network.TaxCollectorBasicInformations;
   import d2network.TaxCollectorComplementaryInformations;
   import d2network.TaxCollectorFightersInformation;
   import d2network.TaxCollectorGuildInformations;
   import d2network.TaxCollectorInformations;
   import d2network.TaxCollectorLootInformations;
   import d2network.TaxCollectorMovement;
   import d2network.TaxCollectorStaticExtendedInformations;
   import d2network.TaxCollectorStaticInformations;
   import d2network.TaxCollectorWaitingForHelpInformations;
   import d2network.TreasureHuntFlag;
   import d2network.TreasureHuntStep;
   import d2network.TreasureHuntStepDig;
   import d2network.TreasureHuntStepFight;
   import d2network.TreasureHuntStepFollowDirection;
   import d2network.TreasureHuntStepFollowDirectionToHint;
   import d2network.TreasureHuntStepFollowDirectionToPOI;
   import d2network.TrustCertificate;
   import d2network.UpdateMountBoost;
   import d2network.UpdateMountIntBoost;
   import d2network.VersionExtended;
   import d2utils.ItemTooltipSettings;
   import d2utils.ModuleFilestream;
   import d2utils.PreCompiledUiModule;
   import d2utils.SpellTooltipSettings;
   import d2utils.TooltipRectangle;
   import d2utils.UiData;
   import d2utils.UiGroup;
   import d2utils.UiModule;
   
   public class ForceImport
   {
       
      
      private var _import_d2api_BindsApi:BindsApi = null;
      
      private var _import_d2api_ColorApi:ColorApi = null;
      
      private var _import_d2api_FightApi:FightApi = null;
      
      private var _import_d2api_FileApi:FileApi = null;
      
      private var _import_d2api_MapApi:MapApi = null;
      
      private var _import_d2api_ChatApi:ChatApi = null;
      
      private var _import_d2api_ExchangeApi:ExchangeApi = null;
      
      private var _import_d2api_QuestApi:QuestApi = null;
      
      private var _import_d2api_AlignmentApi:AlignmentApi = null;
      
      private var _import_d2api_DocumentApi:DocumentApi = null;
      
      private var _import_d2api_ConnectionApi:ConnectionApi = null;
      
      private var _import_d2api_PlayedCharacterApi:PlayedCharacterApi = null;
      
      private var _import_d2api_SecurityApi:SecurityApi = null;
      
      private var _import_d2api_CaptureApi:CaptureApi = null;
      
      private var _import_d2api_TooltipApi:TooltipApi = null;
      
      private var _import_d2api_HighlightApi:HighlightApi = null;
      
      private var _import_d2api_TimeApi:TimeApi = null;
      
      private var _import_d2api_UtilApi:UtilApi = null;
      
      private var _import_d2api_PartyApi:PartyApi = null;
      
      private var _import_d2api_JobsApi:JobsApi = null;
      
      private var _import_d2api_NotificationApi:NotificationApi = null;
      
      private var _import_d2api_AveragePricesApi:AveragePricesApi = null;
      
      private var _import_d2api_MountApi:MountApi = null;
      
      private var _import_d2api_TestApi:TestApi = null;
      
      private var _import_d2api_ExternalNotificationApi:ExternalNotificationApi = null;
      
      private var _import_d2api_StorageApi:StorageApi = null;
      
      private var _import_d2api_ContextMenuApi:ContextMenuApi = null;
      
      private var _import_d2api_InventoryApi:InventoryApi = null;
      
      private var _import_d2api_SocialApi:SocialApi = null;
      
      private var _import_d2api_SystemApi:SystemApi = null;
      
      private var _import_d2api_ConfigApi:ConfigApi = null;
      
      private var _import_d2api_SoundApi:SoundApi = null;
      
      private var _import_d2api_RoleplayApi:RoleplayApi = null;
      
      private var _import_d2api_DataApi:DataApi = null;
      
      private var _import_d2utils_SpellTooltipSettings:SpellTooltipSettings = null;
      
      private var _import_d2utils_ModuleFilestream:ModuleFilestream = null;
      
      private var _import_d2utils_ItemTooltipSettings:ItemTooltipSettings = null;
      
      private var _import_d2data_SmileyWrapper:SmileyWrapper = null;
      
      private var _import_d2data_ChatSentenceWithRecipient:ChatSentenceWithRecipient = null;
      
      private var _import_d2data_ChatBubble:ChatBubble = null;
      
      private var _import_d2data_CraftSmileyItem:CraftSmileyItem = null;
      
      private var _import_d2data_ChatInformationSentence:ChatInformationSentence = null;
      
      private var _import_d2data_DelayedActionItem:DelayedActionItem = null;
      
      private var _import_d2data_BasicChatSentence:BasicChatSentence = null;
      
      private var _import_d2data_ThinkBubble:ThinkBubble = null;
      
      private var _import_d2data_ChatSentenceWithSource:ChatSentenceWithSource = null;
      
      private var _import_d2data_EmoteWrapper:EmoteWrapper = null;
      
      private var _import_d2data_DareWrapper:DareWrapper = null;
      
      private var _import_d2data_DareCriteriaWrapper:DareCriteriaWrapper = null;
      
      private var _import_d2data_ButtonWrapper:ButtonWrapper = null;
      
      private var _import_d2data_ArenaRankInfosWrapper:ArenaRankInfosWrapper = null;
      
      private var _import_d2data_HouseWrapper:HouseWrapper = null;
      
      private var _import_d2data_HavenbagFurnitureWrapper:HavenbagFurnitureWrapper = null;
      
      private var _import_d2data_EffectsListWrapper:EffectsListWrapper = null;
      
      private var _import_d2data_SpellWrapper:SpellWrapper = null;
      
      private var _import_d2data_EffectsWrapper:EffectsWrapper = null;
      
      private var _import_d2data_MountData:MountData = null;
      
      private var _import_d2data_OfflineSaleWrapper:OfflineSaleWrapper = null;
      
      private var _import_d2data_GuildWrapper:GuildWrapper = null;
      
      private var _import_d2data_SocialFightersWrapper:SocialFightersWrapper = null;
      
      private var _import_d2data_PaddockWrapper:PaddockWrapper = null;
      
      private var _import_d2data_AllianceWrapper:AllianceWrapper = null;
      
      private var _import_d2data_GuildFactSheetWrapper:GuildFactSheetWrapper = null;
      
      private var _import_d2data_TaxCollectorWrapper:TaxCollectorWrapper = null;
      
      private var _import_d2data_EmblemWrapper:EmblemWrapper = null;
      
      private var _import_d2data_SocialEntityInFightWrapper:SocialEntityInFightWrapper = null;
      
      private var _import_d2data_GuildHouseWrapper:GuildHouseWrapper = null;
      
      private var _import_d2data_TreasureHuntStepWrapper:TreasureHuntStepWrapper = null;
      
      private var _import_d2data_TreasureHuntWrapper:TreasureHuntWrapper = null;
      
      private var _import_d2data_ItemWrapper:ItemWrapper = null;
      
      private var _import_d2data_PresetWrapper:PresetWrapper = null;
      
      private var _import_d2data_WeaponWrapper:WeaponWrapper = null;
      
      private var _import_d2data_ShortcutWrapper:ShortcutWrapper = null;
      
      private var _import_d2data_SimpleTextureWrapper:SimpleTextureWrapper = null;
      
      private var _import_d2data_QuantifiedItemWrapper:QuantifiedItemWrapper = null;
      
      private var _import_d2data_MountWrapper:MountWrapper = null;
      
      private var _import_d2data_TradeStockItemWrapper:TradeStockItemWrapper = null;
      
      private var _import_d2data_FighterInformations:FighterInformations = null;
      
      private var _import_d2data_ChallengeWrapper:ChallengeWrapper = null;
      
      private var _import_d2data_FightResultEntryWrapper:FightResultEntryWrapper = null;
      
      private var _import_d2data_FightLootWrapper:FightLootWrapper = null;
      
      private var _import_d2data_BasicCharacterWrapper:BasicCharacterWrapper = null;
      
      private var _import_d2data_SubscriberGift:SubscriberGift = null;
      
      private var _import_d2data_CreationCharacterWrapper:CreationCharacterWrapper = null;
      
      private var _import_d2data_TitleWrapper:TitleWrapper = null;
      
      private var _import_d2data_OrnamentWrapper:OrnamentWrapper = null;
      
      private var _import_d2data_PrismFightersWrapper:PrismFightersWrapper = null;
      
      private var _import_d2data_PrismSubAreaWrapper:PrismSubAreaWrapper = null;
      
      private var _import_d2data_AllianceOnTheHillWrapper:AllianceOnTheHillWrapper = null;
      
      private var _import_d2data_TeleportDestinationWrapper:TeleportDestinationWrapper = null;
      
      private var _import_d2data_PartyMemberWrapper:PartyMemberWrapper = null;
      
      private var _import_d2data_SpouseWrapper:SpouseWrapper = null;
      
      private var _import_d2data_IgnoredWrapper:IgnoredWrapper = null;
      
      private var _import_d2data_PartyCompanionWrapper:PartyCompanionWrapper = null;
      
      private var _import_d2data_FriendWrapper:FriendWrapper = null;
      
      private var _import_d2data_EnemyWrapper:EnemyWrapper = null;
      
      private var _import_d2data_RecipeWithSkill:RecipeWithSkill = null;
      
      private var _import_d2data_KnownJobWrapper:KnownJobWrapper = null;
      
      private var _import_d2data_JobWrapper:JobWrapper = null;
      
      private var _import_d2data_CraftsmanWrapper:CraftsmanWrapper = null;
      
      private var _import_d2data_WorldPointWrapper:WorldPointWrapper = null;
      
      private var _import_d2data_AlmanaxZodiac:AlmanaxZodiac = null;
      
      private var _import_d2data_AlmanaxEvent:AlmanaxEvent = null;
      
      private var _import_d2data_AlmanaxMonth:AlmanaxMonth = null;
      
      private var _import_d2api_UpdaterApi:UpdaterApi = null;
      
      private var _import_d2data_DofusShopHighlight:DofusShopHighlight = null;
      
      private var _import_d2data_DofusShopArticleReference:DofusShopArticleReference = null;
      
      private var _import_d2data_DofusShopCategory:DofusShopCategory = null;
      
      private var _import_d2data_DofusShopArticle:DofusShopArticle = null;
      
      private var _import_d2data_DofusShopObject:DofusShopObject = null;
      
      private var _import_d2data_ActionDescription:ActionDescription = null;
      
      private var _import_d2data_Url:Url = null;
      
      private var _import_d2data_Tips:Tips = null;
      
      private var _import_d2data_TypeAction:TypeAction = null;
      
      private var _import_d2data_Pack:Pack = null;
      
      private var _import_d2data_CensoredContent:CensoredContent = null;
      
      private var _import_d2data_Month:Month = null;
      
      private var _import_d2data_OptionalFeature:OptionalFeature = null;
      
      private var _import_d2data_Playlist:Playlist = null;
      
      private var _import_d2data_CensoredWord:CensoredWord = null;
      
      private var _import_d2data_ChatChannel:ChatChannel = null;
      
      private var _import_d2data_Emoticon:Emoticon = null;
      
      private var _import_d2data_SmileyCategory:SmileyCategory = null;
      
      private var _import_d2data_InfoMessage:InfoMessage = null;
      
      private var _import_d2data_SmileyPack:SmileyPack = null;
      
      private var _import_d2data_Smiley:Smiley = null;
      
      private var _import_d2data_DareCriteria:d2data.DareCriteria = null;
      
      private var _import_d2data_Effect:Effect = null;
      
      private var _import_d2data_EffectInstance:EffectInstance = null;
      
      private var _import_d2data_EffectInstanceLadder:EffectInstanceLadder = null;
      
      private var _import_d2data_EffectInstanceString:EffectInstanceString = null;
      
      private var _import_d2data_EffectInstanceMount:EffectInstanceMount = null;
      
      private var _import_d2data_EffectInstanceMinMax:EffectInstanceMinMax = null;
      
      private var _import_d2data_EffectInstanceDate:EffectInstanceDate = null;
      
      private var _import_d2data_EffectInstanceDice:EffectInstanceDice = null;
      
      private var _import_d2data_EffectInstanceDuration:EffectInstanceDuration = null;
      
      private var _import_d2data_EffectInstanceInteger:EffectInstanceInteger = null;
      
      private var _import_d2data_EffectInstanceCreature:EffectInstanceCreature = null;
      
      private var _import_d2data_SpellType:SpellType = null;
      
      private var _import_d2data_SpellPair:SpellPair = null;
      
      private var _import_d2data_SpellBomb:SpellBomb = null;
      
      private var _import_d2data_SpellLevel:SpellLevel = null;
      
      private var _import_d2data_Spell:Spell = null;
      
      private var _import_d2data_SpellState:SpellState = null;
      
      private var _import_d2data_EmblemSymbolCategory:EmblemSymbolCategory = null;
      
      private var _import_d2data_EmblemSymbol:EmblemSymbol = null;
      
      private var _import_d2data_RankName:RankName = null;
      
      private var _import_d2data_EmblemBackground:EmblemBackground = null;
      
      private var _import_d2data_SoundBones:SoundBones = null;
      
      private var _import_d2data_SoundAnimation:SoundAnimation = null;
      
      private var _import_d2data_SoundUiHook:SoundUiHook = null;
      
      private var _import_d2data_SoundUi:SoundUi = null;
      
      private var _import_d2data_SoundUiElement:SoundUiElement = null;
      
      private var _import_d2data_NpcAction:NpcAction = null;
      
      private var _import_d2data_Npc:Npc = null;
      
      private var _import_d2data_TaxCollectorFirstname:TaxCollectorFirstname = null;
      
      private var _import_d2data_TaxCollectorName:d2data.TaxCollectorName = null;
      
      private var _import_d2data_NpcMessage:NpcMessage = null;
      
      private var _import_d2data_Document:Document = null;
      
      private var _import_d2data_Comic:Comic = null;
      
      private var _import_d2data_AmbientSound:AmbientSound = null;
      
      private var _import_d2data_PlaylistSound:PlaylistSound = null;
      
      private var _import_d2data_ExternalNotification:ExternalNotification = null;
      
      private var _import_d2data_AchievementObjective:d2data.AchievementObjective = null;
      
      private var _import_d2data_AchievementCategory:AchievementCategory = null;
      
      private var _import_d2data_QuestStepRewards:QuestStepRewards = null;
      
      private var _import_d2data_AchievementReward:AchievementReward = null;
      
      private var _import_d2data_QuestStep:QuestStep = null;
      
      private var _import_d2data_QuestObjectiveType:QuestObjectiveType = null;
      
      private var _import_d2data_Achievement:d2data.Achievement = null;
      
      private var _import_d2data_QuestObjective:QuestObjective = null;
      
      private var _import_d2data_Quest:Quest = null;
      
      private var _import_d2data_QuestCategory:QuestCategory = null;
      
      private var _import_d2data_PointOfInterestCategory:PointOfInterestCategory = null;
      
      private var _import_d2data_LegendaryTreasureHunt:LegendaryTreasureHunt = null;
      
      private var _import_d2data_PointOfInterest:PointOfInterest = null;
      
      private var _import_d2data_QuestObjectiveBringItemToNpc:QuestObjectiveBringItemToNpc = null;
      
      private var _import_d2data_QuestObjectiveDiscoverSubArea:QuestObjectiveDiscoverSubArea = null;
      
      private var _import_d2data_QuestObjectiveGoToNpc:QuestObjectiveGoToNpc = null;
      
      private var _import_d2data_QuestObjectiveCraftItem:QuestObjectiveCraftItem = null;
      
      private var _import_d2data_QuestObjectiveFreeForm:QuestObjectiveFreeForm = null;
      
      private var _import_d2data_QuestObjectiveFightMonstersOnMap:QuestObjectiveFightMonstersOnMap = null;
      
      private var _import_d2data_QuestObjectiveBringSoulToNpc:QuestObjectiveBringSoulToNpc = null;
      
      private var _import_d2data_QuestObjectiveFightMonster:QuestObjectiveFightMonster = null;
      
      private var _import_d2data_QuestObjectiveMultiFightMonster:QuestObjectiveMultiFightMonster = null;
      
      private var _import_d2data_QuestObjectiveDuelSpecificPlayer:QuestObjectiveDuelSpecificPlayer = null;
      
      private var _import_d2data_QuestObjectiveDiscoverMap:QuestObjectiveDiscoverMap = null;
      
      private var _import_d2data_Weapon:Weapon = null;
      
      private var _import_d2data_Item:d2data.Item = null;
      
      private var _import_d2data_ItemType:ItemType = null;
      
      private var _import_d2data_IncarnationLevel:IncarnationLevel = null;
      
      private var _import_d2data_ItemSet:ItemSet = null;
      
      private var _import_d2data_PresetIcon:PresetIcon = null;
      
      private var _import_d2data_Incarnation:Incarnation = null;
      
      private var _import_d2data_VeteranReward:VeteranReward = null;
      
      private var _import_d2data_ItemCriterion:ItemCriterion = null;
      
      private var _import_d2data_ObjectItemCriterion:ObjectItemCriterion = null;
      
      private var _import_d2data_AllianceItemCriterion:AllianceItemCriterion = null;
      
      private var _import_d2data_EmoteItemCriterion:EmoteItemCriterion = null;
      
      private var _import_d2data_ItemCriterionOperator:ItemCriterionOperator = null;
      
      private var _import_d2data_GroupItemCriterion:GroupItemCriterion = null;
      
      private var _import_d2data_RideItemCriterion:RideItemCriterion = null;
      
      private var _import_d2data_NameItemCriterion:NameItemCriterion = null;
      
      private var _import_d2data_AlignmentItemCriterion:AlignmentItemCriterion = null;
      
      private var _import_d2data_LevelItemCriterion:LevelItemCriterion = null;
      
      private var _import_d2data_CommunityItemCriterion:CommunityItemCriterion = null;
      
      private var _import_d2data_SubscriptionDurationItemCriterion:SubscriptionDurationItemCriterion = null;
      
      private var _import_d2data_MountFamilyItemCriterion:MountFamilyItemCriterion = null;
      
      private var _import_d2data_StaticCriterionItemCriterion:StaticCriterionItemCriterion = null;
      
      private var _import_d2data_DayItemCriterion:DayItemCriterion = null;
      
      private var _import_d2data_SexItemCriterion:SexItemCriterion = null;
      
      private var _import_d2data_SmileyPackItemCriterion:SmileyPackItemCriterion = null;
      
      private var _import_d2data_ArenaMaxSoloRankCriterion:ArenaMaxSoloRankCriterion = null;
      
      private var _import_d2data_JobItemCriterion:JobItemCriterion = null;
      
      private var _import_d2data_ServerItemCriterion:ServerItemCriterion = null;
      
      private var _import_d2data_BonusSetItemCriterion:BonusSetItemCriterion = null;
      
      private var _import_d2data_GuildLevelItemCriterion:GuildLevelItemCriterion = null;
      
      private var _import_d2data_AllianceAvAItemCriterion:AllianceAvAItemCriterion = null;
      
      private var _import_d2data_MariedItemCriterion:MariedItemCriterion = null;
      
      private var _import_d2data_ArenaTeamRankCriterion:ArenaTeamRankCriterion = null;
      
      private var _import_d2data_AllianceRightsItemCriterion:AllianceRightsItemCriterion = null;
      
      private var _import_d2data_SubscribeItemCriterion:SubscribeItemCriterion = null;
      
      private var _import_d2data_SoulStoneItemCriterion:SoulStoneItemCriterion = null;
      
      private var _import_d2data_CriterionUtils:CriterionUtils = null;
      
      private var _import_d2data_ArenaSoloRankCriterion:ArenaSoloRankCriterion = null;
      
      private var _import_d2data_GuildItemCriterion:GuildItemCriterion = null;
      
      private var _import_d2data_AlignmentLevelItemCriterion:AlignmentLevelItemCriterion = null;
      
      private var _import_d2data_QuestItemCriterion:QuestItemCriterion = null;
      
      private var _import_d2data_FriendlistItemCriterion:FriendlistItemCriterion = null;
      
      private var _import_d2data_AreaItemCriterion:AreaItemCriterion = null;
      
      private var _import_d2data_SpecializationItemCriterion:SpecializationItemCriterion = null;
      
      private var _import_d2data_SkillItemCriterion:SkillItemCriterion = null;
      
      private var _import_d2data_KamaItemCriterion:KamaItemCriterion = null;
      
      private var _import_d2data_RestrictedAreaItemCriterion:RestrictedAreaItemCriterion = null;
      
      private var _import_d2data_SubareaItemCriterion:SubareaItemCriterion = null;
      
      private var _import_d2data_CriterionManager:CriterionManager = null;
      
      private var _import_d2data_ArenaMaxTeamRankCriterion:ArenaMaxTeamRankCriterion = null;
      
      private var _import_d2data_PVPRankItemCriterion:PVPRankItemCriterion = null;
      
      private var _import_d2data_UnusableItemCriterion:UnusableItemCriterion = null;
      
      private var _import_d2data_AchievementItemCriterion:AchievementItemCriterion = null;
      
      private var _import_d2data_BreedItemCriterion:BreedItemCriterion = null;
      
      private var _import_d2data_WeightItemCriterion:WeightItemCriterion = null;
      
      private var _import_d2data_SpellItemCriterion:SpellItemCriterion = null;
      
      private var _import_d2data_GuildRightsItemCriterion:GuildRightsItemCriterion = null;
      
      private var _import_d2data_GiftItemCriterion:GiftItemCriterion = null;
      
      private var _import_d2data_AccountRightsItemCriterion:AccountRightsItemCriterion = null;
      
      private var _import_d2data_MonthItemCriterion:MonthItemCriterion = null;
      
      private var _import_d2data_BonesItemCriterion:BonesItemCriterion = null;
      
      private var _import_d2data_ItemCriterionFactory:ItemCriterionFactory = null;
      
      private var _import_d2data_MapCharactersItemCriterion:MapCharactersItemCriterion = null;
      
      private var _import_d2data_PremiumAccountItemCriterion:PremiumAccountItemCriterion = null;
      
      private var _import_d2data_HavenbagTheme:HavenbagTheme = null;
      
      private var _import_d2data_House:House = null;
      
      private var _import_d2data_HavenbagFurniture:HavenbagFurniture = null;
      
      private var _import_d2data_Idol:d2data.Idol = null;
      
      private var _import_d2data_Server:Server = null;
      
      private var _import_d2data_ServerPopulation:ServerPopulation = null;
      
      private var _import_d2data_ServerCommunity:ServerCommunity = null;
      
      private var _import_d2data_ServerGameType:ServerGameType = null;
      
      private var _import_d2data_AbuseReasons:AbuseReasons = null;
      
      private var _import_d2data_Notification:Notification = null;
      
      private var _import_d2data_CreatureBoneType:CreatureBoneType = null;
      
      private var _import_d2data_Title:Title = null;
      
      private var _import_d2data_SkinMapping:SkinMapping = null;
      
      private var _import_d2data_Ornament:Ornament = null;
      
      private var _import_d2data_Appearance:Appearance = null;
      
      private var _import_d2data_TitleCategory:TitleCategory = null;
      
      private var _import_d2data_SkinPosition:SkinPosition = null;
      
      private var _import_d2data_CreatureBoneOverride:CreatureBoneOverride = null;
      
      private var _import_d2data_CharacteristicCategory:CharacteristicCategory = null;
      
      private var _import_d2data_Characteristic:Characteristic = null;
      
      private var _import_d2data_SkillName:SkillName = null;
      
      private var _import_d2data_Interactive:Interactive = null;
      
      private var _import_d2data_StealthBones:StealthBones = null;
      
      private var _import_d2data_Challenge:Challenge = null;
      
      private var _import_d2data_AlignmentGift:AlignmentGift = null;
      
      private var _import_d2data_AlignmentTitle:AlignmentTitle = null;
      
      private var _import_d2data_AlignmentOrder:AlignmentOrder = null;
      
      private var _import_d2data_AlignmentRankJntGift:AlignmentRankJntGift = null;
      
      private var _import_d2data_AlignmentEffect:AlignmentEffect = null;
      
      private var _import_d2data_AlignmentBalance:AlignmentBalance = null;
      
      private var _import_d2data_AlignmentRank:AlignmentRank = null;
      
      private var _import_d2data_AlignmentSide:AlignmentSide = null;
      
      private var _import_d2data_Bonus:Bonus = null;
      
      private var _import_d2data_BonusCriterion:BonusCriterion = null;
      
      private var _import_d2data_Pet:Pet = null;
      
      private var _import_d2data_LivingObjectSkinJntMood:LivingObjectSkinJntMood = null;
      
      private var _import_d2data_SpeakingItemText:SpeakingItemText = null;
      
      private var _import_d2data_SpeakingItemsTrigger:SpeakingItemsTrigger = null;
      
      private var _import_d2data_BreedRoleByBreed:BreedRoleByBreed = null;
      
      private var _import_d2data_BreedRole:BreedRole = null;
      
      private var _import_d2data_Breed:Breed = null;
      
      private var _import_d2data_Head:Head = null;
      
      private var _import_d2data_CompanionSpell:CompanionSpell = null;
      
      private var _import_d2data_MonsterGrade:MonsterGrade = null;
      
      private var _import_d2data_CompanionCharacteristic:CompanionCharacteristic = null;
      
      private var _import_d2data_MonsterRace:MonsterRace = null;
      
      private var _import_d2data_MonsterDrop:MonsterDrop = null;
      
      private var _import_d2data_MonsterMiniBoss:MonsterMiniBoss = null;
      
      private var _import_d2data_MonsterSuperRace:MonsterSuperRace = null;
      
      private var _import_d2data_Companion:Companion = null;
      
      private var _import_d2data_Monster:Monster = null;
      
      private var _import_d2data_Job:Job = null;
      
      private var _import_d2data_Recipe:Recipe = null;
      
      private var _import_d2data_Skill:Skill = null;
      
      private var _import_d2data_MapCoordinates:d2data.MapCoordinates = null;
      
      private var _import_d2data_MapReference:MapReference = null;
      
      private var _import_d2data_HintCategory:HintCategory = null;
      
      private var _import_d2data_Hint:Hint = null;
      
      private var _import_d2data_WorldMap:WorldMap = null;
      
      private var _import_d2data_Area:Area = null;
      
      private var _import_d2data_MapScrollAction:MapScrollAction = null;
      
      private var _import_d2data_SuperArea:SuperArea = null;
      
      private var _import_d2data_Waypoint:Waypoint = null;
      
      private var _import_d2data_Dungeon:Dungeon = null;
      
      private var _import_d2data_SubArea:SubArea = null;
      
      private var _import_d2data_MapPosition:MapPosition = null;
      
      private var _import_d2data_Phoenix:Phoenix = null;
      
      private var _import_d2data_AlmanaxCalendar:AlmanaxCalendar = null;
      
      private var _import_d2data_Mount:Mount = null;
      
      private var _import_d2data_MountBone:MountBone = null;
      
      private var _import_d2data_MountBehavior:MountBehavior = null;
      
      private var _import_d2data_MountFamily:MountFamily = null;
      
      private var _import_d2data_RideFood:RideFood = null;
      
      private var _import_d2components_MockFinalizableUIComponent:MockFinalizableUIComponent = null;
      
      private var _import_d2api_UiApi:UiApi = null;
      
      private var _import_d2components_ProgressBar:ProgressBar = null;
      
      private var _import_d2components_SwfApplication:SwfApplication = null;
      
      private var _import_d2components_ComboBox:ComboBox = null;
      
      private var _import_d2components_VideoPlayer:VideoPlayer = null;
      
      private var _import_d2components_WebBrowser:WebBrowser = null;
      
      private var _import_d2components_Grid:Grid = null;
      
      private var _import_d2components_Input:Input = null;
      
      private var _import_d2components_ChatComponent:ChatComponent = null;
      
      private var _import_d2components_TextArea:TextArea = null;
      
      private var _import_d2components_Label:Label = null;
      
      private var _import_d2components_InputComboBox:InputComboBox = null;
      
      private var _import_d2components_SpellZoneComponent:SpellZoneComponent = null;
      
      private var _import_d2components_Texture:Texture = null;
      
      private var _import_d2components_CharacterWheel:CharacterWheel = null;
      
      private var _import_d2components_MapViewer:MapViewer = null;
      
      private var _import_d2components_TextAreaInput:TextAreaInput = null;
      
      private var _import_d2components_Tree:Tree = null;
      
      private var _import_d2components_ColorPicker:ColorPicker = null;
      
      private var _import_d2components_TabSet:TabSet = null;
      
      private var _import_d2components_Slot:Slot = null;
      
      private var _import_d2components_ScrollBar:ScrollBar = null;
      
      private var _import_d2components_EntityDisplayer:EntityDisplayer = null;
      
      private var _import_d2components_TextureBase:TextureBase = null;
      
      private var _import_d2components_TextureBitmap:TextureBitmap = null;
      
      private var _import_d2components_Slider:Slider = null;
      
      private var _import_d2utils_UiModule:UiModule = null;
      
      private var _import_d2data_GridItem:GridItem = null;
      
      private var _import_d2utils_PreCompiledUiModule:PreCompiledUiModule = null;
      
      private var _import_d2data_ContextMenuData:ContextMenuData = null;
      
      private var _import_d2utils_UiData:UiData = null;
      
      private var _import_d2utils_UiGroup:UiGroup = null;
      
      private var _import_d2data_Bind:Bind = null;
      
      private var _import_d2data_Shortcut:d2data.Shortcut = null;
      
      private var _import_d2utils_TooltipRectangle:TooltipRectangle = null;
      
      private var _import_d2components_ScrollContainer:ScrollContainer = null;
      
      private var _import_d2components_GraphicContainer:GraphicContainer = null;
      
      private var _import_d2components_StateContainer:StateContainer = null;
      
      private var _import_d2components_ButtonContainer:ButtonContainer = null;
      
      private var _import_d2data_Version:d2data.Version = null;
      
      private var _import_d2data_WorldPoint:WorldPoint = null;
      
      private var _import_d2network_DareCriteria:d2network.DareCriteria = null;
      
      private var _import_d2network_DareReward:DareReward = null;
      
      private var _import_d2network_DareInformations:DareInformations = null;
      
      private var _import_d2network_DareVersatileInformations:DareVersatileInformations = null;
      
      private var _import_d2network_PrismSubareaEmptyInfo:PrismSubareaEmptyInfo = null;
      
      private var _import_d2network_PrismGeolocalizedInformation:PrismGeolocalizedInformation = null;
      
      private var _import_d2network_PrismInformation:PrismInformation = null;
      
      private var _import_d2network_AlliancePrismInformation:AlliancePrismInformation = null;
      
      private var _import_d2network_PrismFightersInformation:PrismFightersInformation = null;
      
      private var _import_d2network_AllianceInsiderPrismInformation:AllianceInsiderPrismInformation = null;
      
      private var _import_d2network_GuildInAllianceVersatileInformations:GuildInAllianceVersatileInformations = null;
      
      private var _import_d2network_GuildFactSheetInformations:GuildFactSheetInformations = null;
      
      private var _import_d2network_AbstractSocialGroupInfos:AbstractSocialGroupInfos = null;
      
      private var _import_d2network_GuildVersatileInformations:GuildVersatileInformations = null;
      
      private var _import_d2network_AllianceVersatileInformations:AllianceVersatileInformations = null;
      
      private var _import_d2network_AllianceFactSheetInformations:AllianceFactSheetInformations = null;
      
      private var _import_d2network_AlliancedGuildFactSheetInformations:AlliancedGuildFactSheetInformations = null;
      
      private var _import_d2network_GuildInsiderFactSheetInformations:GuildInsiderFactSheetInformations = null;
      
      private var _import_d2network_Preset:Preset = null;
      
      private var _import_d2network_IdolsPreset:IdolsPreset = null;
      
      private var _import_d2network_PresetItem:PresetItem = null;
      
      private var _import_d2network_HouseInformationsForSell:HouseInformationsForSell = null;
      
      private var _import_d2network_HouseInformationsExtended:HouseInformationsExtended = null;
      
      private var _import_d2network_AccountHouseInformations:AccountHouseInformations = null;
      
      private var _import_d2network_HouseInformationsForGuild:HouseInformationsForGuild = null;
      
      private var _import_d2network_HouseInformationsInside:HouseInformationsInside = null;
      
      private var _import_d2network_HouseInformations:HouseInformations = null;
      
      private var _import_d2network_PaddockInformations:PaddockInformations = null;
      
      private var _import_d2network_PaddockItem:PaddockItem = null;
      
      private var _import_d2network_PaddockContentInformations:PaddockContentInformations = null;
      
      private var _import_d2network_PaddockInformationsForSell:PaddockInformationsForSell = null;
      
      private var _import_d2network_PaddockAbandonnedInformations:PaddockAbandonnedInformations = null;
      
      private var _import_d2network_MountInformationsForPaddock:MountInformationsForPaddock = null;
      
      private var _import_d2network_PaddockPrivateInformations:PaddockPrivateInformations = null;
      
      private var _import_d2network_PaddockBuyableInformations:PaddockBuyableInformations = null;
      
      private var _import_d2network_Item:d2network.Item = null;
      
      private var _import_d2network_ObjectItem:ObjectItem = null;
      
      private var _import_d2network_ObjectItemGenericQuantityPrice:ObjectItemGenericQuantityPrice = null;
      
      private var _import_d2network_ObjectItemQuantity:ObjectItemQuantity = null;
      
      private var _import_d2network_ObjectItemMinimalInformation:ObjectItemMinimalInformation = null;
      
      private var _import_d2network_ObjectItemToSell:ObjectItemToSell = null;
      
      private var _import_d2network_SpellItem:SpellItem = null;
      
      private var _import_d2network_ObjectEffects:ObjectEffects = null;
      
      private var _import_d2network_ObjectItemInformationWithQuantity:ObjectItemInformationWithQuantity = null;
      
      private var _import_d2network_ObjectItemNotInContainer:ObjectItemNotInContainer = null;
      
      private var _import_d2network_SellerBuyerDescriptor:SellerBuyerDescriptor = null;
      
      private var _import_d2network_ObjectItemGenericQuantity:ObjectItemGenericQuantity = null;
      
      private var _import_d2network_ObjectItemToSellInHumanVendorShop:ObjectItemToSellInHumanVendorShop = null;
      
      private var _import_d2network_ObjectItemToSellInBid:ObjectItemToSellInBid = null;
      
      private var _import_d2network_ObjectItemToSellInNpcShop:ObjectItemToSellInNpcShop = null;
      
      private var _import_d2network_BidExchangerObjectInfo:BidExchangerObjectInfo = null;
      
      private var _import_d2network_GoldItem:GoldItem = null;
      
      private var _import_d2network_ObjectEffectLadder:ObjectEffectLadder = null;
      
      private var _import_d2network_ObjectEffectDice:ObjectEffectDice = null;
      
      private var _import_d2network_ObjectEffectString:ObjectEffectString = null;
      
      private var _import_d2network_ObjectEffectDuration:ObjectEffectDuration = null;
      
      private var _import_d2network_ObjectEffectMount:ObjectEffectMount = null;
      
      private var _import_d2network_ObjectEffectCreature:ObjectEffectCreature = null;
      
      private var _import_d2network_ObjectEffectInteger:ObjectEffectInteger = null;
      
      private var _import_d2network_ObjectEffectDate:ObjectEffectDate = null;
      
      private var _import_d2network_ObjectEffectMinMax:ObjectEffectMinMax = null;
      
      private var _import_d2network_ObjectEffect:ObjectEffect = null;
      
      private var _import_d2network_AchievementObjective:d2network.AchievementObjective = null;
      
      private var _import_d2network_AchievementRewardable:AchievementRewardable = null;
      
      private var _import_d2network_Achievement:d2network.Achievement = null;
      
      private var _import_d2network_AchievementStartedObjective:AchievementStartedObjective = null;
      
      private var _import_d2network_UpdateMountIntBoost:UpdateMountIntBoost = null;
      
      private var _import_d2network_ItemDurability:ItemDurability = null;
      
      private var _import_d2network_MountClientData:MountClientData = null;
      
      private var _import_d2network_UpdateMountBoost:UpdateMountBoost = null;
      
      private var _import_d2network_ServerSessionConstant:ServerSessionConstant = null;
      
      private var _import_d2network_ServerSessionConstantInteger:ServerSessionConstantInteger = null;
      
      private var _import_d2network_ServerSessionConstantString:ServerSessionConstantString = null;
      
      private var _import_d2network_ServerSessionConstantLong:ServerSessionConstantLong = null;
      
      private var _import_d2network_HavenBagFurnitureInformation:HavenBagFurnitureInformation = null;
      
      private var _import_d2network_GuildEmblem:GuildEmblem = null;
      
      private var _import_d2network_GuildMember:GuildMember = null;
      
      private var _import_d2network_TaxCollectorWaitingForHelpInformations:TaxCollectorWaitingForHelpInformations = null;
      
      private var _import_d2network_TaxCollectorGuildInformations:TaxCollectorGuildInformations = null;
      
      private var _import_d2network_TaxCollectorMovement:TaxCollectorMovement = null;
      
      private var _import_d2network_TaxCollectorBasicInformations:TaxCollectorBasicInformations = null;
      
      private var _import_d2network_AdditionalTaxCollectorInformations:AdditionalTaxCollectorInformations = null;
      
      private var _import_d2network_TaxCollectorName:d2network.TaxCollectorName = null;
      
      private var _import_d2network_TaxCollectorLootInformations:TaxCollectorLootInformations = null;
      
      private var _import_d2network_TaxCollectorFightersInformation:TaxCollectorFightersInformation = null;
      
      private var _import_d2network_TaxCollectorComplementaryInformations:TaxCollectorComplementaryInformations = null;
      
      private var _import_d2network_TaxCollectorInformations:TaxCollectorInformations = null;
      
      private var _import_d2network_FightDispellableEffectExtendedInformations:FightDispellableEffectExtendedInformations = null;
      
      private var _import_d2network_FightTemporaryBoostStateEffect:FightTemporaryBoostStateEffect = null;
      
      private var _import_d2network_GameActionMarkedCell:GameActionMarkedCell = null;
      
      private var _import_d2network_FightTemporarySpellImmunityEffect:FightTemporarySpellImmunityEffect = null;
      
      private var _import_d2network_AbstractFightDispellableEffect:AbstractFightDispellableEffect = null;
      
      private var _import_d2network_GameActionMark:GameActionMark = null;
      
      private var _import_d2network_FightTriggeredEffect:FightTriggeredEffect = null;
      
      private var _import_d2network_FightTemporaryBoostWeaponDamagesEffect:FightTemporaryBoostWeaponDamagesEffect = null;
      
      private var _import_d2network_FightTemporarySpellBoostEffect:FightTemporarySpellBoostEffect = null;
      
      private var _import_d2network_FightTemporaryBoostEffect:FightTemporaryBoostEffect = null;
      
      private var _import_d2network_PartyIdol:PartyIdol = null;
      
      private var _import_d2network_Idol:d2network.Idol = null;
      
      private var _import_d2network_StartupActionAddObject:StartupActionAddObject = null;
      
      private var _import_d2network_ProtectedEntityWaitingForHelpInfo:ProtectedEntityWaitingForHelpInfo = null;
      
      private var _import_d2network_ShortcutObjectPreset:ShortcutObjectPreset = null;
      
      private var _import_d2network_ShortcutSpell:ShortcutSpell = null;
      
      private var _import_d2network_ShortcutEmote:ShortcutEmote = null;
      
      private var _import_d2network_ShortcutSmiley:ShortcutSmiley = null;
      
      private var _import_d2network_ShortcutObjectItem:ShortcutObjectItem = null;
      
      private var _import_d2network_ShortcutObjectIdolsPreset:ShortcutObjectIdolsPreset = null;
      
      private var _import_d2network_ShortcutObject:ShortcutObject = null;
      
      private var _import_d2network_Shortcut:d2network.Shortcut = null;
      
      private var _import_d2network_MapCoordinates:d2network.MapCoordinates = null;
      
      private var _import_d2network_MapCoordinatesAndId:MapCoordinatesAndId = null;
      
      private var _import_d2network_EntityMovementInformations:EntityMovementInformations = null;
      
      private var _import_d2network_MapCoordinatesExtended:MapCoordinatesExtended = null;
      
      private var _import_d2network_FightEntityDispositionInformations:FightEntityDispositionInformations = null;
      
      private var _import_d2network_TaxCollectorStaticExtendedInformations:TaxCollectorStaticExtendedInformations = null;
      
      private var _import_d2network_GameRolePlayTaxCollectorInformations:GameRolePlayTaxCollectorInformations = null;
      
      private var _import_d2network_GameContextActorInformations:GameContextActorInformations = null;
      
      private var _import_d2network_TaxCollectorStaticInformations:TaxCollectorStaticInformations = null;
      
      private var _import_d2network_ActorOrientation:ActorOrientation = null;
      
      private var _import_d2network_IdentifiedEntityDispositionInformations:IdentifiedEntityDispositionInformations = null;
      
      private var _import_d2network_EntityDispositionInformations:EntityDispositionInformations = null;
      
      private var _import_d2network_GameRolePlayCharacterInformations:GameRolePlayCharacterInformations = null;
      
      private var _import_d2network_GroupMonsterStaticInformations:GroupMonsterStaticInformations = null;
      
      private var _import_d2network_AtlasPointsInformations:AtlasPointsInformations = null;
      
      private var _import_d2network_MonsterInGroupInformations:MonsterInGroupInformations = null;
      
      private var _import_d2network_GameRolePlayMerchantInformations:GameRolePlayMerchantInformations = null;
      
      private var _import_d2network_GameRolePlayTreasureHintInformations:GameRolePlayTreasureHintInformations = null;
      
      private var _import_d2network_NpcStaticInformations:NpcStaticInformations = null;
      
      private var _import_d2network_MonsterBoosts:MonsterBoosts = null;
      
      private var _import_d2network_HumanOptionAlliance:HumanOptionAlliance = null;
      
      private var _import_d2network_GameRolePlayGroupMonsterWaveInformations:GameRolePlayGroupMonsterWaveInformations = null;
      
      private var _import_d2network_GameRolePlayPortalInformations:GameRolePlayPortalInformations = null;
      
      private var _import_d2network_GameRolePlayActorInformations:GameRolePlayActorInformations = null;
      
      private var _import_d2network_GuildInAllianceInformations:GuildInAllianceInformations = null;
      
      private var _import_d2network_BasicAllianceInformations:BasicAllianceInformations = null;
      
      private var _import_d2network_HumanOption:HumanOption = null;
      
      private var _import_d2network_BasicNamedAllianceInformations:BasicNamedAllianceInformations = null;
      
      private var _import_d2network_ObjectItemInRolePlay:ObjectItemInRolePlay = null;
      
      private var _import_d2network_GameRolePlayHumanoidInformations:GameRolePlayHumanoidInformations = null;
      
      private var _import_d2network_BasicGuildInformations:BasicGuildInformations = null;
      
      private var _import_d2network_AlternativeMonstersInGroupLightInformations:AlternativeMonstersInGroupLightInformations = null;
      
      private var _import_d2network_HumanOptionSkillUse:HumanOptionSkillUse = null;
      
      private var _import_d2network_GuildInformations:GuildInformations = null;
      
      private var _import_d2network_GameRolePlayMutantInformations:GameRolePlayMutantInformations = null;
      
      private var _import_d2network_GameRolePlayNamedActorInformations:GameRolePlayNamedActorInformations = null;
      
      private var _import_d2network_GameRolePlayNpcInformations:GameRolePlayNpcInformations = null;
      
      private var _import_d2network_HumanOptionTitle:HumanOptionTitle = null;
      
      private var _import_d2network_GameRolePlayPrismInformations:GameRolePlayPrismInformations = null;
      
      private var _import_d2network_AllianceInformations:AllianceInformations = null;
      
      private var _import_d2network_HumanOptionObjectUse:HumanOptionObjectUse = null;
      
      private var _import_d2network_GameRolePlayNpcWithQuestInformations:GameRolePlayNpcWithQuestInformations = null;
      
      private var _import_d2network_GameRolePlayMountInformations:GameRolePlayMountInformations = null;
      
      private var _import_d2network_OrientedObjectItemWithLookInRolePlay:OrientedObjectItemWithLookInRolePlay = null;
      
      private var _import_d2network_HumanInformations:HumanInformations = null;
      
      private var _import_d2network_HumanOptionOrnament:HumanOptionOrnament = null;
      
      private var _import_d2network_MonsterInGroupLightInformations:MonsterInGroupLightInformations = null;
      
      private var _import_d2network_GameRolePlayGroupMonsterInformations:GameRolePlayGroupMonsterInformations = null;
      
      private var _import_d2network_HumanOptionGuild:HumanOptionGuild = null;
      
      private var _import_d2network_GroupMonsterStaticInformationsWithAlternatives:GroupMonsterStaticInformationsWithAlternatives = null;
      
      private var _import_d2network_ObjectItemWithLookInRolePlay:ObjectItemWithLookInRolePlay = null;
      
      private var _import_d2network_HumanOptionFollowers:HumanOptionFollowers = null;
      
      private var _import_d2network_HumanOptionEmote:HumanOptionEmote = null;
      
      private var _import_d2network_TreasureHuntStepDig:TreasureHuntStepDig = null;
      
      private var _import_d2network_PortalInformation:PortalInformation = null;
      
      private var _import_d2network_TreasureHuntStepFollowDirectionToPOI:TreasureHuntStepFollowDirectionToPOI = null;
      
      private var _import_d2network_TreasureHuntStepFight:TreasureHuntStepFight = null;
      
      private var _import_d2network_TreasureHuntStepFollowDirectionToHint:TreasureHuntStepFollowDirectionToHint = null;
      
      private var _import_d2network_TreasureHuntFlag:TreasureHuntFlag = null;
      
      private var _import_d2network_TreasureHuntStepFollowDirection:TreasureHuntStepFollowDirection = null;
      
      private var _import_d2network_TreasureHuntStep:TreasureHuntStep = null;
      
      private var _import_d2network_PartyGuestInformations:PartyGuestInformations = null;
      
      private var _import_d2network_NamedPartyTeam:NamedPartyTeam = null;
      
      private var _import_d2network_NamedPartyTeamWithOutcome:NamedPartyTeamWithOutcome = null;
      
      private var _import_d2network_PartyUpdateCommonsInformations:PartyUpdateCommonsInformations = null;
      
      private var _import_d2network_PartyInvitationMemberInformations:PartyInvitationMemberInformations = null;
      
      private var _import_d2network_DungeonPartyFinderPlayer:DungeonPartyFinderPlayer = null;
      
      private var _import_d2network_PartyMemberInformations:PartyMemberInformations = null;
      
      private var _import_d2network_PartyMemberArenaInformations:PartyMemberArenaInformations = null;
      
      private var _import_d2network_PartyMemberGeoPosition:PartyMemberGeoPosition = null;
      
      private var _import_d2network_PartyCompanionMemberInformations:PartyCompanionMemberInformations = null;
      
      private var _import_d2network_PartyCompanionBaseInformations:PartyCompanionBaseInformations = null;
      
      private var _import_d2network_GameRolePlayNpcQuestFlag:GameRolePlayNpcQuestFlag = null;
      
      private var _import_d2network_QuestActiveInformations:QuestActiveInformations = null;
      
      private var _import_d2network_QuestActiveDetailedInformations:QuestActiveDetailedInformations = null;
      
      private var _import_d2network_QuestObjectiveInformationsWithCompletion:QuestObjectiveInformationsWithCompletion = null;
      
      private var _import_d2network_QuestObjectiveInformations:QuestObjectiveInformations = null;
      
      private var _import_d2network_JobExperience:JobExperience = null;
      
      private var _import_d2network_JobBookSubscription:JobBookSubscription = null;
      
      private var _import_d2network_DecraftedItemStackInfo:DecraftedItemStackInfo = null;
      
      private var _import_d2network_JobCrafterDirectorySettings:JobCrafterDirectorySettings = null;
      
      private var _import_d2network_JobCrafterDirectoryEntryPlayerInfo:JobCrafterDirectoryEntryPlayerInfo = null;
      
      private var _import_d2network_JobCrafterDirectoryEntryJobInfo:JobCrafterDirectoryEntryJobInfo = null;
      
      private var _import_d2network_JobCrafterDirectoryListEntry:JobCrafterDirectoryListEntry = null;
      
      private var _import_d2network_JobDescription:JobDescription = null;
      
      private var _import_d2network_ArenaRankInfos:ArenaRankInfos = null;
      
      private var _import_d2network_GameFightTaxCollectorInformations:GameFightTaxCollectorInformations = null;
      
      private var _import_d2network_FightResultFighterListEntry:FightResultFighterListEntry = null;
      
      private var _import_d2network_AbstractFightTeamInformations:AbstractFightTeamInformations = null;
      
      private var _import_d2network_FightResultPvpData:FightResultPvpData = null;
      
      private var _import_d2network_FightTeamLightInformations:FightTeamLightInformations = null;
      
      private var _import_d2network_GameFightCompanionInformations:GameFightCompanionInformations = null;
      
      private var _import_d2network_FightResultTaxCollectorListEntry:FightResultTaxCollectorListEntry = null;
      
      private var _import_d2network_FightCommonInformations:FightCommonInformations = null;
      
      private var _import_d2network_FightLoot:FightLoot = null;
      
      private var _import_d2network_GameFightMinimalStatsPreparation:GameFightMinimalStatsPreparation = null;
      
      private var _import_d2network_GameFightFighterNamedInformations:GameFightFighterNamedInformations = null;
      
      private var _import_d2network_FightTeamInformations:FightTeamInformations = null;
      
      private var _import_d2network_GameFightFighterMonsterLightInformations:GameFightFighterMonsterLightInformations = null;
      
      private var _import_d2network_GameFightFighterInformations:GameFightFighterInformations = null;
      
      private var _import_d2network_GameFightMinimalStats:GameFightMinimalStats = null;
      
      private var _import_d2network_GameFightMutantInformations:GameFightMutantInformations = null;
      
      private var _import_d2network_FightTeamMemberTaxCollectorInformations:FightTeamMemberTaxCollectorInformations = null;
      
      private var _import_d2network_FightTeamMemberMonsterInformations:FightTeamMemberMonsterInformations = null;
      
      private var _import_d2network_GameFightFighterNamedLightInformations:GameFightFighterNamedLightInformations = null;
      
      private var _import_d2network_GameFightMonsterInformations:GameFightMonsterInformations = null;
      
      private var _import_d2network_GameFightMonsterWithAlignmentInformations:GameFightMonsterWithAlignmentInformations = null;
      
      private var _import_d2network_FightExternalInformations:FightExternalInformations = null;
      
      private var _import_d2network_GameFightResumeSlaveInfo:GameFightResumeSlaveInfo = null;
      
      private var _import_d2network_GameFightFighterLightInformations:GameFightFighterLightInformations = null;
      
      private var _import_d2network_FightResultListEntry:FightResultListEntry = null;
      
      private var _import_d2network_GameFightSpellCooldown:GameFightSpellCooldown = null;
      
      private var _import_d2network_FightTeamMemberWithAllianceCharacterInformations:FightTeamMemberWithAllianceCharacterInformations = null;
      
      private var _import_d2network_FightResultMutantListEntry:FightResultMutantListEntry = null;
      
      private var _import_d2network_GameFightFighterTaxCollectorLightInformations:GameFightFighterTaxCollectorLightInformations = null;
      
      private var _import_d2network_FightResultAdditionalData:FightResultAdditionalData = null;
      
      private var _import_d2network_FightResultExperienceData:FightResultExperienceData = null;
      
      private var _import_d2network_FightAllianceTeamInformations:FightAllianceTeamInformations = null;
      
      private var _import_d2network_FightTeamMemberCompanionInformations:FightTeamMemberCompanionInformations = null;
      
      private var _import_d2network_FightOptionsInformations:FightOptionsInformations = null;
      
      private var _import_d2network_FightTeamMemberCharacterInformations:FightTeamMemberCharacterInformations = null;
      
      private var _import_d2network_GameFightFighterCompanionLightInformations:GameFightFighterCompanionLightInformations = null;
      
      private var _import_d2network_GameFightAIInformations:GameFightAIInformations = null;
      
      private var _import_d2network_FightResultPlayerListEntry:FightResultPlayerListEntry = null;
      
      private var _import_d2network_FightTeamMemberInformations:FightTeamMemberInformations = null;
      
      private var _import_d2network_GameFightCharacterInformations:GameFightCharacterInformations = null;
      
      private var _import_d2network_FriendInformations:FriendInformations = null;
      
      private var _import_d2network_FriendOnlineInformations:FriendOnlineInformations = null;
      
      private var _import_d2network_FriendSpouseInformations:FriendSpouseInformations = null;
      
      private var _import_d2network_AbstractContactInformations:AbstractContactInformations = null;
      
      private var _import_d2network_IgnoredInformations:IgnoredInformations = null;
      
      private var _import_d2network_IgnoredOnlineInformations:IgnoredOnlineInformations = null;
      
      private var _import_d2network_FriendSpouseOnlineInformations:FriendSpouseOnlineInformations = null;
      
      private var _import_d2network_AbstractCharacterInformation:AbstractCharacterInformation = null;
      
      private var _import_d2network_CharacterMinimalPlusLookAndGradeInformations:CharacterMinimalPlusLookAndGradeInformations = null;
      
      private var _import_d2network_CharacterBasicMinimalInformations:CharacterBasicMinimalInformations = null;
      
      private var _import_d2network_CharacterMinimalAllianceInformations:CharacterMinimalAllianceInformations = null;
      
      private var _import_d2network_CharacterMinimalPlusLookInformations:CharacterMinimalPlusLookInformations = null;
      
      private var _import_d2network_CharacterMinimalGuildInformations:CharacterMinimalGuildInformations = null;
      
      private var _import_d2network_CharacterMinimalInformations:CharacterMinimalInformations = null;
      
      private var _import_d2network_ActorAlignmentInformations:ActorAlignmentInformations = null;
      
      private var _import_d2network_ActorExtendedAlignmentInformations:ActorExtendedAlignmentInformations = null;
      
      private var _import_d2network_ActorRestrictionsInformations:ActorRestrictionsInformations = null;
      
      private var _import_d2network_CharacterCharacteristicsInformations:CharacterCharacteristicsInformations = null;
      
      private var _import_d2network_CharacterSpellModification:CharacterSpellModification = null;
      
      private var _import_d2network_CharacterBaseCharacteristic:CharacterBaseCharacteristic = null;
      
      private var _import_d2network_CharacterRemodelingInformation:CharacterRemodelingInformation = null;
      
      private var _import_d2network_CharacterToRecolorInformation:CharacterToRecolorInformation = null;
      
      private var _import_d2network_CharacterHardcoreOrEpicInformations:CharacterHardcoreOrEpicInformations = null;
      
      private var _import_d2network_AbstractCharacterToRefurbishInformation:AbstractCharacterToRefurbishInformation = null;
      
      private var _import_d2network_RemodelingInformation:RemodelingInformation = null;
      
      private var _import_d2network_CharacterToRemodelInformations:CharacterToRemodelInformations = null;
      
      private var _import_d2network_RemodelingInformations:RemodelingInformations = null;
      
      private var _import_d2network_CharacterBaseInformations:CharacterBaseInformations = null;
      
      private var _import_d2network_CharacterToRelookInformation:CharacterToRelookInformation = null;
      
      private var _import_d2network_PlayerStatusExtended:PlayerStatusExtended = null;
      
      private var _import_d2network_PlayerStatus:PlayerStatus = null;
      
      private var _import_d2network_EntityLook:EntityLook = null;
      
      private var _import_d2network_SubEntity:SubEntity = null;
      
      private var _import_d2network_IndexedEntityLook:IndexedEntityLook = null;
      
      private var _import_d2network_InteractiveElementSkill:InteractiveElementSkill = null;
      
      private var _import_d2network_MapObstacle:MapObstacle = null;
      
      private var _import_d2network_InteractiveElement:InteractiveElement = null;
      
      private var _import_d2network_InteractiveElementWithAgeBonus:InteractiveElementWithAgeBonus = null;
      
      private var _import_d2network_InteractiveElementNamedSkill:InteractiveElementNamedSkill = null;
      
      private var _import_d2network_StatedElement:StatedElement = null;
      
      private var _import_d2network_SkillActionDescriptionTimed:SkillActionDescriptionTimed = null;
      
      private var _import_d2network_SkillActionDescriptionCraft:SkillActionDescriptionCraft = null;
      
      private var _import_d2network_SkillActionDescriptionCollect:SkillActionDescriptionCollect = null;
      
      private var _import_d2network_SkillActionDescription:SkillActionDescription = null;
      
      private var _import_d2network_TrustCertificate:TrustCertificate = null;
      
      private var _import_d2network_KrosmasterFigure:KrosmasterFigure = null;
      
      private var _import_d2network_StatisticDataString:StatisticDataString = null;
      
      private var _import_d2network_StatisticDataByte:StatisticDataByte = null;
      
      private var _import_d2network_StatisticDataBoolean:StatisticDataBoolean = null;
      
      private var _import_d2network_StatisticDataShort:StatisticDataShort = null;
      
      private var _import_d2network_StatisticData:StatisticData = null;
      
      private var _import_d2network_StatisticDataInt:StatisticDataInt = null;
      
      private var _import_d2network_GameServerInformations:GameServerInformations = null;
      
      private var _import_d2network_VersionExtended:VersionExtended = null;
      
      private var _import_d2network_Version:d2network.Version = null;
      
      private var _import_d2network_ContentPart:ContentPart = null;
      
      public function ForceImport()
      {
         super();
      }
   }
}
