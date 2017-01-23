package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.DefaultMap;
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.messages.MapLoadedMessage;
   import com.ankamagames.atouin.messages.MapLoadingFailedMessage;
   import com.ankamagames.atouin.messages.MapsLoadingCompleteMessage;
   import com.ankamagames.atouin.renderers.MapRenderer;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.documents.Comic;
   import com.ankamagames.dofus.datacenter.houses.HavenbagTheme;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.externalnotification.ExternalNotificationManager;
   import com.ankamagames.dofus.externalnotification.enums.ExternalNotificationTypeEnum;
   import com.ankamagames.dofus.internalDatacenter.communication.CraftSmileyItem;
   import com.ankamagames.dofus.internalDatacenter.guild.PaddockWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.net.DisconnectionReasonEnum;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.logic.common.actions.AuthorizedCommandAction;
   import com.ankamagames.dofus.logic.common.actions.ChangeWorldInteractionAction;
   import com.ankamagames.dofus.logic.common.actions.ResetGameAction;
   import com.ankamagames.dofus.logic.common.managers.NotificationManager;
   import com.ankamagames.dofus.logic.game.approach.managers.PartManager;
   import com.ankamagames.dofus.logic.game.common.actions.InteractiveElementActivationAction;
   import com.ankamagames.dofus.logic.game.common.actions.PivotCharacterAction;
   import com.ankamagames.dofus.logic.game.common.actions.bid.LeaveBidHouseAction;
   import com.ankamagames.dofus.logic.game.common.actions.craft.ExchangePlayerMultiCraftRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangePlayerRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.exchange.ExchangeRequestOnTaxCollectorAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeBuyAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeOnHumanVendorRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeRequestOnShopStockAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeSellAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShopStockMouvmentAddAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShopStockMouvmentRemoveAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeShowVendorTaxAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.ExchangeStartAsVendorRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.humanVendor.LeaveShopStockAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.LeaveExchangeMountAction;
   import com.ankamagames.dofus.logic.game.common.actions.quest.treasureHunt.PortalUseRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.roleplay.GameRolePlayFreeSoulRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.taxCollector.GameRolePlayTaxCollectorFightRequestAction;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.common.frames.BidHouseManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.logic.game.common.frames.CommonExchangeManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.CraftFrame;
   import com.ankamagames.dofus.logic.game.common.frames.EmoticonFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ExchangeManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.HumanVendorManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SpectatorManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.StackManagementFrame;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.managers.TacticModeManager;
   import com.ankamagames.dofus.logic.game.roleplay.actions.DisplayContextualMenuAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.NpcGenericActionRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.PlayerFightFriendlyAnswerAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.PlayerFightRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.havenbag.HavenbagEnterAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.havenbag.HavenbagInvitePlayerAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.havenbag.HavenbagInvitePlayerAnswerAction;
   import com.ankamagames.dofus.logic.game.roleplay.managers.RoleplayManager;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementActivationMessage;
   import com.ankamagames.dofus.logic.game.roleplay.types.RoleplaySpellCastProvider;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.CraftHookList;
   import com.ankamagames.dofus.misc.lists.ExchangeHookList;
   import com.ankamagames.dofus.misc.lists.ExternalGameHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.MountHookList;
   import com.ankamagames.dofus.misc.lists.RoleplayHookList;
   import com.ankamagames.dofus.misc.lists.SocialHookList;
   import com.ankamagames.dofus.misc.utils.SurveyManager;
   import com.ankamagames.dofus.network.enums.BuildTypeEnum;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.CraftResultEnum;
   import com.ankamagames.dofus.network.enums.DelayedActionTypeEnum;
   import com.ankamagames.dofus.network.enums.ExchangeErrorEnum;
   import com.ankamagames.dofus.network.enums.ExchangeTypeEnum;
   import com.ankamagames.dofus.network.enums.FighterRefusedReasonEnum;
   import com.ankamagames.dofus.network.enums.GameContextEnum;
   import com.ankamagames.dofus.network.enums.UpdatableMountBoostEnum;
   import com.ankamagames.dofus.network.messages.game.context.GameContextDestroyMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapChangeOrientationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.display.DisplayNumericalValuePaddockMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.CurrentMapMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.ErrorMapNotFoundMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.death.GameRolePlayFreeSoulRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.delay.GameRolePlayDelayedActionMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.document.ComicReadingBeginMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.document.DocumentReadingBeginMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayAggressionMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayFightRequestCanceledMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightFriendlyAnswerMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightFriendlyAnsweredMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightFriendlyRequestedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayPlayerFightRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.EnterHavenBagRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.KickHavenBagRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.meeting.InviteInHavenBagClosedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.meeting.InviteInHavenBagMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.meeting.InviteInHavenBagOfferMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.meeting.TeleportHavenBagAnswerMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.meeting.TeleportHavenBagRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobAllowMultiCraftRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.job.JobMultiCraftAvailableSkillsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcDialogCreationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcGenericActionFailureMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.NpcGenericActionRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.paddock.PaddockPropertiesMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.paddock.PaddockSellBuyDialogMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt.PortalUseRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.visual.GameRolePlaySpellAnimMessage;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogRequestMessage;
   import com.ankamagames.dofus.network.messages.game.guild.ChallengeFightJoinRefusedMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GameRolePlayTaxCollectorFightRequestMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.TeleportDestinationsListMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.ZaapListMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBuyMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeBuyOkMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftInformationObjectMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeCraftResultMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeErrorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectMoveMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeObjectMovePricedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeOkMultiCraftMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeOnHumanVendorRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangePlayerMultiCraftRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangePlayerRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeReplyTaxVendorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestOnShopStockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestOnTaxCollectorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeRequestedTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeSellMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeSellOkMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShopStockStartedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeShowVendorTaxMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartAsVendorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkCraftWithInformationMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkHumanVendorMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcShopMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkNpcTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkRecycleTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartOkRunesTradeMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedBidBuyerMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedBidSellerMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedMountStockMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeStartedTaxCollectorShopMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectFoundWhileRecoltingMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObtainedItemMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObtainedItemWithBonusMessage;
   import com.ankamagames.dofus.network.messages.server.basic.SystemMessageDisplayMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNamedActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPortalInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.network.types.game.prism.AlliancePrismInformation;
   import com.ankamagames.dofus.scripts.SpellScriptManager;
   import com.ankamagames.dofus.types.characteristicContextual.CharacteristicContextualManager;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.types.enums.NotificationTypeEnum;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.messages.ExpectedSocketClosureMessage;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.jerakine.utils.display.AngleToOrientation;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.hurlant.util.Hex;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextFormat;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class RoleplayContextFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayContextFrame));
      
      private static const ASTRUB_SUBAREA_IDS:Array = [143,92,95,96,97,98,99,100,101,173,318,306];
      
      private static const MOUNT_BOOSTS_ICONS_PATH:String = XmlConfig.getInstance().getEntry("config.content.path") + "gfx/characteristics/mount.swf|";
      
      private static var currentStatus:int = -1;
       
      
      private var _priority:int = 0;
      
      private var _entitiesFrame:RoleplayEntitiesFrame;
      
      private var _worldFrame:RoleplayWorldFrame;
      
      private var _interactivesFrame:RoleplayInteractivesFrame;
      
      private var _npcDialogFrame:NpcDialogFrame;
      
      private var _documentFrame:DocumentFrame;
      
      private var _zaapFrame:ZaapFrame;
      
      private var _paddockFrame:PaddockFrame;
      
      private var _emoticonFrame:EmoticonFrame;
      
      private var _exchangeManagementFrame:ExchangeManagementFrame;
      
      private var _humanVendorManagementFrame:HumanVendorManagementFrame;
      
      private var _spectatorManagementFrame:SpectatorManagementFrame;
      
      private var _bidHouseManagementFrame:BidHouseManagementFrame;
      
      private var _estateFrame:EstateFrame;
      
      private var _allianceFrame:AllianceFrame;
      
      private var _craftFrame:CraftFrame;
      
      private var _commonExchangeFrame:CommonExchangeManagementFrame;
      
      private var _movementFrame:RoleplayMovementFrame;
      
      private var _delayedActionFrame:DelayedActionFrame;
      
      private var _currentWaitingFightId:uint;
      
      private var _crafterId:Number;
      
      private var _customerID:Number;
      
      private var _playersMultiCraftSkill:Array;
      
      private var _currentPaddock:PaddockWrapper;
      
      private var _playerEntity:AnimatedCharacter;
      
      private var _interactionIsLimited:Boolean = false;
      
      private var _previousMapId:uint = 0;
      
      private var _obtainedItemMsg:ObtainedItemMessage;
      
      private var _itemIcon:Texture;
      
      private var _itemBonusIcon:Texture;
      
      private var _obtainedItemTextFormat:TextFormat;
      
      private var _obtainedItemBonusTextFormat:TextFormat;
      
      private var _mountBoosTextFormat:TextFormat;
      
      public function RoleplayContextFrame()
      {
         super();
      }
      
      public function get crafterId() : Number
      {
         return this._crafterId;
      }
      
      public function get customerID() : Number
      {
         return this._customerID;
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function set priority(param1:int) : void
      {
         this._priority = param1;
      }
      
      public function get entitiesFrame() : RoleplayEntitiesFrame
      {
         return this._entitiesFrame;
      }
      
      private function get socialFrame() : SocialFrame
      {
         return Kernel.getWorker().getFrame(SocialFrame) as SocialFrame;
      }
      
      public function get hasWorldInteraction() : Boolean
      {
         return !this._interactionIsLimited;
      }
      
      public function get commonExchangeFrame() : CommonExchangeManagementFrame
      {
         return this._commonExchangeFrame;
      }
      
      public function get hasGuildedPaddock() : Boolean
      {
         return this._currentPaddock && this._currentPaddock.guildIdentity;
      }
      
      public function get currentPaddock() : PaddockWrapper
      {
         return this._currentPaddock;
      }
      
      public function get previousMapId() : uint
      {
         return this._previousMapId;
      }
      
      public function pushed() : Boolean
      {
         this._entitiesFrame = new RoleplayEntitiesFrame();
         this._delayedActionFrame = new DelayedActionFrame();
         this._movementFrame = new RoleplayMovementFrame();
         this._worldFrame = new RoleplayWorldFrame();
         this._interactivesFrame = new RoleplayInteractivesFrame();
         Kernel.getWorker().addFrame(this._delayedActionFrame);
         this._npcDialogFrame = new NpcDialogFrame();
         this._documentFrame = new DocumentFrame();
         this._zaapFrame = new ZaapFrame();
         this._paddockFrame = new PaddockFrame();
         this._exchangeManagementFrame = new ExchangeManagementFrame();
         this._spectatorManagementFrame = new SpectatorManagementFrame();
         this._bidHouseManagementFrame = new BidHouseManagementFrame();
         this._estateFrame = new EstateFrame();
         this._craftFrame = new CraftFrame();
         this._humanVendorManagementFrame = new HumanVendorManagementFrame();
         Kernel.getWorker().addFrame(this._spectatorManagementFrame);
         if(!Kernel.getWorker().contains(EstateFrame))
         {
            Kernel.getWorker().addFrame(this._estateFrame);
         }
         this._allianceFrame = Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
         this._allianceFrame.pushRoleplay();
         if(!Kernel.getWorker().contains(EmoticonFrame))
         {
            this._emoticonFrame = new EmoticonFrame();
            Kernel.getWorker().addFrame(this._emoticonFrame);
         }
         else
         {
            this._emoticonFrame = Kernel.getWorker().getFrame(EmoticonFrame) as EmoticonFrame;
         }
         this._playersMultiCraftSkill = new Array();
         this._obtainedItemTextFormat = new TextFormat("Verdana",24,7615756,true);
         this._obtainedItemBonusTextFormat = new TextFormat("Verdana",24,16733440,true);
         this._itemIcon = new Texture();
         this._itemBonusIcon = new Texture();
         var _loc1_:GlowFilter = new GlowFilter(0,1,2,2,2,1);
         this._itemIcon.filters = [_loc1_];
         this._itemBonusIcon.filters = [_loc1_];
         this._mountBoosTextFormat = new TextFormat("Verdana",24,7615756,true);
         var _loc2_:StackManagementFrame = Kernel.getWorker().getFrame(StackManagementFrame) as StackManagementFrame;
         _loc2_.paused = false;
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:CurrentMapMessage = null;
         var _loc3_:SubArea = null;
         var _loc4_:WorldPointWrapper = null;
         var _loc5_:String = null;
         var _loc6_:ByteArray = null;
         var _loc7_:Object = null;
         var _loc8_:MapPosition = null;
         var _loc9_:MapsLoadingCompleteMessage = null;
         var _loc10_:ChangeWorldInteractionAction = null;
         var _loc11_:Boolean = false;
         var _loc12_:StackManagementFrame = null;
         var _loc13_:NpcGenericActionRequestAction = null;
         var _loc14_:IEntity = null;
         var _loc15_:NpcGenericActionRequestMessage = null;
         var _loc16_:ExchangeRequestOnTaxCollectorAction = null;
         var _loc17_:ExchangeRequestOnTaxCollectorMessage = null;
         var _loc18_:IEntity = null;
         var _loc19_:GameRolePlayTaxCollectorFightRequestAction = null;
         var _loc20_:GameRolePlayTaxCollectorFightRequestMessage = null;
         var _loc21_:InteractiveElementActivationAction = null;
         var _loc22_:InteractiveElementActivationMessage = null;
         var _loc23_:DisplayContextualMenuAction = null;
         var _loc24_:GameContextActorInformations = null;
         var _loc25_:RoleplayInteractivesFrame = null;
         var _loc26_:NpcDialogCreationMessage = null;
         var _loc27_:Object = null;
         var _loc28_:PortalUseRequestAction = null;
         var _loc29_:PortalUseRequestMessage = null;
         var _loc30_:ExchangeShowVendorTaxMessage = null;
         var _loc31_:ExchangeReplyTaxVendorMessage = null;
         var _loc32_:ExchangeOnHumanVendorRequestAction = null;
         var _loc33_:ExchangeRequestOnShopStockMessage = null;
         var _loc34_:ExchangeOnHumanVendorRequestAction = null;
         var _loc35_:IEntity = null;
         var _loc36_:ExchangeOnHumanVendorRequestMessage = null;
         var _loc37_:ExchangeStartOkHumanVendorMessage = null;
         var _loc38_:ExchangeShopStockStartedMessage = null;
         var _loc39_:IEntity = null;
         var _loc40_:ExchangeStartAsVendorMessage = null;
         var _loc41_:ExpectedSocketClosureMessage = null;
         var _loc42_:ExchangeStartedMountStockMessage = null;
         var _loc43_:ExchangeStartedTaxCollectorShopMessage = null;
         var _loc44_:ExchangeStartOkNpcShopMessage = null;
         var _loc45_:ExchangeStartedMessage = null;
         var _loc46_:CommonExchangeManagementFrame = null;
         var _loc47_:ObjectFoundWhileRecoltingMessage = null;
         var _loc48_:Item = null;
         var _loc49_:Number = NaN;
         var _loc50_:CraftSmileyItem = null;
         var _loc51_:uint = 0;
         var _loc52_:String = null;
         var _loc53_:String = null;
         var _loc54_:String = null;
         var _loc55_:ObtainedItemMessage = null;
         var _loc56_:RoleplayInteractivesFrame = null;
         var _loc57_:AnimatedCharacter = null;
         var _loc58_:Timer = null;
         var _loc59_:PlayerFightRequestAction = null;
         var _loc60_:GameRolePlayPlayerFightRequestMessage = null;
         var _loc61_:IEntity = null;
         var _loc62_:PlayerFightFriendlyAnswerAction = null;
         var _loc63_:GameRolePlayPlayerFightFriendlyAnsweredMessage = null;
         var _loc64_:GameRolePlayFightRequestCanceledMessage = null;
         var _loc65_:GameRolePlayPlayerFightFriendlyRequestedMessage = null;
         var _loc66_:GameRolePlayFreeSoulRequestMessage = null;
         var _loc67_:LeaveDialogRequestMessage = null;
         var _loc68_:ExchangeErrorMessage = null;
         var _loc69_:String = null;
         var _loc70_:uint = 0;
         var _loc71_:GameRolePlayAggressionMessage = null;
         var _loc72_:LeaveDialogRequestMessage = null;
         var _loc73_:ExchangeShopStockMouvmentAddAction = null;
         var _loc74_:ExchangeObjectMovePricedMessage = null;
         var _loc75_:ExchangeShopStockMouvmentRemoveAction = null;
         var _loc76_:ExchangeObjectMoveMessage = null;
         var _loc77_:ExchangeBuyAction = null;
         var _loc78_:ExchangeBuyMessage = null;
         var _loc79_:ExchangeSellAction = null;
         var _loc80_:ExchangeSellMessage = null;
         var _loc81_:ExchangeBuyOkMessage = null;
         var _loc82_:ExchangeSellOkMessage = null;
         var _loc83_:ExchangePlayerRequestAction = null;
         var _loc84_:ExchangePlayerRequestMessage = null;
         var _loc85_:ExchangePlayerMultiCraftRequestAction = null;
         var _loc86_:ExchangePlayerMultiCraftRequestMessage = null;
         var _loc87_:JobAllowMultiCraftRequestMessage = null;
         var _loc88_:uint = 0;
         var _loc89_:ChallengeFightJoinRefusedMessage = null;
         var _loc90_:ExchangeCraftResultMessage = null;
         var _loc91_:uint = 0;
         var _loc92_:ExchangeCraftInformationObjectMessage = null;
         var _loc93_:CraftSmileyItem = null;
         var _loc94_:GameRolePlayDelayedActionMessage = null;
         var _loc95_:DocumentReadingBeginMessage = null;
         var _loc96_:ComicReadingBeginMessage = null;
         var _loc97_:Comic = null;
         var _loc98_:PaddockSellBuyDialogMessage = null;
         var _loc99_:LeaveDialogRequestMessage = null;
         var _loc100_:DisplayNumericalValuePaddockMessage = null;
         var _loc101_:IEntity = null;
         var _loc102_:GameRolePlaySpellAnimMessage = null;
         var _loc103_:RoleplaySpellCastProvider = null;
         var _loc104_:int = 0;
         var _loc105_:EnterHavenBagRequestMessage = null;
         var _loc106_:HavenbagInvitePlayerAction = null;
         var _loc107_:HavenbagInvitePlayerAnswerAction = null;
         var _loc108_:TeleportHavenBagAnswerMessage = null;
         var _loc109_:InviteInHavenBagOfferMessage = null;
         var _loc110_:Boolean = false;
         var _loc111_:uint = 0;
         var _loc112_:InviteInHavenBagMessage = null;
         var _loc113_:InviteInHavenBagClosedMessage = null;
         var _loc114_:Number = NaN;
         var _loc115_:String = null;
         var _loc116_:Object = null;
         var _loc117_:ErrorMapNotFoundMessage = null;
         var _loc118_:int = 0;
         var _loc119_:int = 0;
         var _loc120_:int = 0;
         var _loc121_:Map = null;
         var _loc122_:Boolean = false;
         var _loc123_:GameRolePlayNpcInformations = null;
         var _loc124_:TiphonEntityLook = null;
         var _loc125_:GameRolePlayTaxCollectorInformations = null;
         var _loc126_:GameRolePlayPrismInformations = null;
         var _loc127_:String = null;
         var _loc128_:GameRolePlayPortalInformations = null;
         var _loc129_:Area = null;
         var _loc130_:String = null;
         var _loc131_:LeaveDialogRequestMessage = null;
         var _loc132_:IRectangle = null;
         var _loc133_:uint = 0;
         var _loc134_:GameRolePlayCharacterInformations = null;
         var _loc135_:int = 0;
         var _loc136_:int = 0;
         var _loc137_:RoleplayContextFrame = null;
         var _loc138_:GameRolePlayActorInformations = null;
         var _loc139_:String = null;
         var _loc140_:GameContextActorInformations = null;
         var _loc141_:JobMultiCraftAvailableSkillsMessage = null;
         var _loc142_:MultiCraftEnableForPlayer = null;
         var _loc143_:Boolean = false;
         var _loc144_:MultiCraftEnableForPlayer = null;
         var _loc145_:uint = 0;
         var _loc146_:int = 0;
         var _loc147_:Item = null;
         var _loc148_:uint = 0;
         var _loc149_:IRectangle = null;
         var _loc150_:CraftSmileyItem = null;
         var _loc151_:uint = 0;
         var _loc152_:IRectangle = null;
         var _loc153_:Texture = null;
         var _loc154_:Uri = null;
         var _loc155_:TeleportHavenBagRequestMessage = null;
         var _loc156_:KickHavenBagRequestMessage = null;
         switch(true)
         {
            case param1 is CurrentMapMessage:
               _loc2_ = param1 as CurrentMapMessage;
               _loc3_ = SubArea.getSubAreaByMapId(_loc2_.mapId);
               PlayedCharacterManager.getInstance().currentSubArea = _loc3_;
               Kernel.getWorker().pause(null,[SystemMessageDisplayMessage]);
               ConnectionsHandler.pause();
               if(TacticModeManager.getInstance().tacticModeActivated)
               {
                  TacticModeManager.getInstance().hide();
               }
               KernelEventsManager.getInstance().processCallback(HookList.StartZoom,false);
               Atouin.getInstance().initPreDisplay(_loc4_);
               if(this._entitiesFrame && Kernel.getWorker().contains(RoleplayEntitiesFrame))
               {
                  Kernel.getWorker().removeFrame(this._entitiesFrame);
               }
               if(this._worldFrame && Kernel.getWorker().contains(RoleplayWorldFrame))
               {
                  Kernel.getWorker().removeFrame(this._worldFrame);
               }
               if(this._interactivesFrame && Kernel.getWorker().contains(RoleplayInteractivesFrame))
               {
                  Kernel.getWorker().removeFrame(this._interactivesFrame);
               }
               if(this._movementFrame && Kernel.getWorker().contains(RoleplayMovementFrame))
               {
                  Kernel.getWorker().removeFrame(this._movementFrame);
               }
               if(PlayedCharacterManager.getInstance().isInHouse)
               {
                  _loc4_ = new WorldPointWrapper(_loc2_.mapId,true,PlayedCharacterManager.getInstance().currentMap.outdoorX,PlayedCharacterManager.getInstance().currentMap.outdoorY);
               }
               else
               {
                  _loc4_ = new WorldPointWrapper(_loc2_.mapId);
               }
               if(PlayedCharacterManager.getInstance().currentMap)
               {
                  this._previousMapId = PlayedCharacterManager.getInstance().currentMap.mapId;
               }
               PlayedCharacterManager.getInstance().currentMap = _loc4_;
               Atouin.getInstance().clearEntities();
               KernelEventsManager.getInstance().processCallback(HookList.MapFightCount,0);
               _loc5_ = LangManager.getInstance().getEntry("config.atouin.widescreen.renderer");
               if(_loc5_ == "true" && !MapRenderer.PROTO_169_BACKGROUND)
               {
                  Kernel.getWorker().process(AuthorizedCommandAction.create("/debugwidescreen"));
                  _loc114_ = 0.92;
                  Kernel.getWorker().process(AuthorizedCommandAction.create("/setclientwindowsize " + (AtouinConstants.WIDESCREEN_BITMAP_WIDTH * _loc114_).toString() + " " + StageShareManager.startHeight * _loc114_));
               }
               if(_loc2_.mapKey && _loc2_.mapKey.length)
               {
                  _loc115_ = XmlConfig.getInstance().getEntry("config.maps.encryptionKey");
                  if(!_loc115_)
                  {
                     _loc115_ = _loc2_.mapKey;
                  }
                  _loc6_ = Hex.toArray(Hex.fromString(_loc115_));
               }
               Atouin.getInstance().display(_loc4_,_loc6_,!HavenbagTheme.isMapIdInHavenbag(_loc4_.mapId));
               TooltipManager.hideAll();
               _loc7_ = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
               _loc7_.closeAllMenu();
               this._currentPaddock = null;
               _loc8_ = MapPosition.getMapPositionById(_loc2_.mapId);
               if(_loc8_ && ASTRUB_SUBAREA_IDS.indexOf(_loc8_.subAreaId) != -1)
               {
                  PartManager.getInstance().checkAndDownload("all");
               }
               KernelEventsManager.getInstance().processCallback(HookList.CurrentMap,_loc2_.mapId);
               return false;
            case param1 is MapsLoadingCompleteMessage:
               _loc9_ = param1 as MapsLoadingCompleteMessage;
               if(!Kernel.getWorker().contains(RoleplayEntitiesFrame))
               {
                  Kernel.getWorker().addFrame(this._entitiesFrame);
               }
               TooltipManager.hideAll();
               KernelEventsManager.getInstance().processCallback(HookList.MapsLoadingComplete,_loc9_.mapPoint);
               if(!Kernel.getWorker().contains(RoleplayWorldFrame))
               {
                  Kernel.getWorker().addFrame(this._worldFrame);
               }
               if(!Kernel.getWorker().contains(RoleplayInteractivesFrame))
               {
                  Kernel.getWorker().addFrame(this._interactivesFrame);
               }
               if(!Kernel.getWorker().contains(RoleplayMovementFrame))
               {
                  Kernel.getWorker().addFrame(this._movementFrame);
               }
               SoundManager.getInstance().manager.setSubArea(_loc9_.mapData);
               Atouin.getInstance().updateCursor();
               Kernel.getWorker().resume();
               Kernel.getWorker().clearUnstoppableMsgClassList();
               ConnectionsHandler.resume();
               SurveyManager.getInstance().checkSurveys();
               return true;
            case param1 is MapLoadingFailedMessage:
               switch(MapLoadingFailedMessage(param1).errorReason)
               {
                  case MapLoadingFailedMessage.NO_FILE:
                     _loc116_ = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
                     _loc116_.openPopup(I18n.getUiText("ui.popup.information"),I18n.getUiText("ui.popup.noMapdataFile"),[I18n.getUiText("ui.common.ok")]);
                     _loc117_ = new ErrorMapNotFoundMessage();
                     _loc117_.initErrorMapNotFoundMessage(MapLoadingFailedMessage(param1).id);
                     ConnectionsHandler.getConnection().send(_loc117_);
                     MapDisplayManager.getInstance().fromMap(new DefaultMap(MapLoadingFailedMessage(param1).id));
                     return true;
                  default:
                     return false;
               }
            case param1 is MapLoadedMessage:
               if(MapDisplayManager.getInstance().isDefaultMap)
               {
                  _loc118_ = PlayedCharacterManager.getInstance().currentMap.x;
                  _loc119_ = PlayedCharacterManager.getInstance().currentMap.y;
                  _loc120_ = PlayedCharacterManager.getInstance().currentMap.worldId;
                  _loc121_ = MapDisplayManager.getInstance().getDataMapContainer().dataMap;
                  _loc121_.rightNeighbourId = WorldPoint.fromCoords(_loc120_,_loc118_ + 1,_loc119_).mapId;
                  _loc121_.leftNeighbourId = WorldPoint.fromCoords(_loc120_,_loc118_ - 1,_loc119_).mapId;
                  _loc121_.bottomNeighbourId = WorldPoint.fromCoords(_loc120_,_loc118_,_loc119_ + 1).mapId;
                  _loc121_.topNeighbourId = WorldPoint.fromCoords(_loc120_,_loc118_,_loc119_ - 1).mapId;
               }
               return true;
            case param1 is ChangeWorldInteractionAction:
               _loc10_ = param1 as ChangeWorldInteractionAction;
               _loc11_ = false;
               if(Kernel.getWorker().contains(BidHouseManagementFrame) && this._bidHouseManagementFrame.switching)
               {
                  _loc11_ = true;
               }
               this._interactionIsLimited = !_loc10_.enabled;
               switch(_loc10_.total)
               {
                  case true:
                     if(_loc10_.enabled)
                     {
                        if(!Kernel.getWorker().contains(RoleplayWorldFrame) && !_loc11_ && SystemApi.wordInteractionEnable)
                        {
                           _log.info("Enabling interaction with the roleplay world.");
                           Kernel.getWorker().addFrame(this._worldFrame);
                        }
                        this._worldFrame.cellClickEnabled = true;
                        this._worldFrame.allowOnlyCharacterInteraction = false;
                        this._worldFrame.pivotingCharacter = false;
                     }
                     else if(Kernel.getWorker().contains(RoleplayWorldFrame))
                     {
                        _log.info("Disabling interaction with the roleplay world.");
                        Kernel.getWorker().removeFrame(this._worldFrame);
                     }
                     break;
                  case false:
                     if(_loc10_.enabled)
                     {
                        if(!Kernel.getWorker().contains(RoleplayWorldFrame) && !_loc11_)
                        {
                           _log.info("Enabling total interaction with the roleplay world.");
                           Kernel.getWorker().addFrame(this._worldFrame);
                           this._worldFrame.cellClickEnabled = true;
                           this._worldFrame.allowOnlyCharacterInteraction = false;
                           this._worldFrame.pivotingCharacter = false;
                        }
                        if(!Kernel.getWorker().contains(RoleplayInteractivesFrame))
                        {
                           Kernel.getWorker().addFrame(this._interactivesFrame);
                        }
                     }
                     else if(Kernel.getWorker().contains(RoleplayWorldFrame))
                     {
                        _log.info("Disabling partial interactions with the roleplay world.");
                        this._worldFrame.allowOnlyCharacterInteraction = true;
                     }
               }
               _loc12_ = Kernel.getWorker().getFrame(StackManagementFrame) as StackManagementFrame;
               if(!(!this._interactionIsLimited && !SystemApi.wordInteractionEnable))
               {
                  _loc12_.paused = this._interactionIsLimited;
               }
               if(!_loc12_.paused && _loc12_.waitingMessage)
               {
                  this._worldFrame.process(_loc12_.waitingMessage);
                  _loc12_.waitingMessage = null;
               }
               return true;
            case param1 is NpcGenericActionRequestAction:
               _loc13_ = param1 as NpcGenericActionRequestAction;
               _loc14_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
               _loc15_ = new NpcGenericActionRequestMessage();
               _loc15_.initNpcGenericActionRequestMessage(_loc13_.npcId,_loc13_.actionId,PlayedCharacterManager.getInstance().currentMap.mapId);
               if((_loc14_ as IMovable).isMoving)
               {
                  (_loc14_ as IMovable).stop();
                  this._movementFrame.setFollowingMessage(_loc15_);
               }
               else
               {
                  ConnectionsHandler.getConnection().send(_loc15_);
               }
               return true;
            case param1 is ExchangeRequestOnTaxCollectorAction:
               _loc16_ = param1 as ExchangeRequestOnTaxCollectorAction;
               _loc17_ = new ExchangeRequestOnTaxCollectorMessage();
               _loc17_.initExchangeRequestOnTaxCollectorMessage(_loc16_.taxCollectorId);
               _loc18_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
               if((_loc18_ as IMovable).isMoving)
               {
                  this._movementFrame.setFollowingMessage(_loc17_);
                  (_loc18_ as IMovable).stop();
               }
               else
               {
                  ConnectionsHandler.getConnection().send(_loc17_);
               }
               return true;
            case param1 is GameRolePlayTaxCollectorFightRequestAction:
               _loc19_ = param1 as GameRolePlayTaxCollectorFightRequestAction;
               _loc20_ = new GameRolePlayTaxCollectorFightRequestMessage();
               _loc20_.initGameRolePlayTaxCollectorFightRequestMessage(_loc19_.taxCollectorId);
               ConnectionsHandler.getConnection().send(_loc20_);
               return true;
            case param1 is InteractiveElementActivationAction:
               _loc21_ = param1 as InteractiveElementActivationAction;
               _loc22_ = new InteractiveElementActivationMessage(_loc21_.interactiveElement,_loc21_.position,_loc21_.skillInstanceId);
               Kernel.getWorker().process(_loc22_);
               return true;
            case param1 is DisplayContextualMenuAction:
               _loc23_ = param1 as DisplayContextualMenuAction;
               _loc24_ = this.entitiesFrame.getEntityInfos(_loc23_.playerId);
               if(_loc24_)
               {
                  _loc122_ = RoleplayManager.getInstance().displayCharacterContextualMenu(_loc24_);
               }
               return false;
            case param1 is PivotCharacterAction:
               _loc25_ = Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame;
               if(_loc25_ && !_loc25_.usingInteractive)
               {
                  Kernel.getWorker().process(ChangeWorldInteractionAction.create(false));
                  this._worldFrame.pivotingCharacter = true;
                  this._playerEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as AnimatedCharacter;
                  StageShareManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onListenOrientation);
                  StageShareManager.stage.addEventListener(MouseEvent.CLICK,this.onClickOrientation);
               }
               return true;
            case param1 is NpcGenericActionFailureMessage:
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.NpcDialogCreationFailure);
               return true;
            case param1 is NpcDialogCreationMessage:
               _loc26_ = param1 as NpcDialogCreationMessage;
               _loc27_ = this._entitiesFrame.getEntityInfos(_loc26_.npcId);
               if(!Kernel.getWorker().contains(NpcDialogFrame))
               {
                  Kernel.getWorker().addFrame(this._npcDialogFrame);
               }
               Kernel.getWorker().process(ChangeWorldInteractionAction.create(false));
               TooltipManager.hideAll();
               if(_loc27_ is GameRolePlayNpcInformations)
               {
                  _loc123_ = _loc27_ as GameRolePlayNpcInformations;
                  _loc124_ = EntityLookAdapter.fromNetwork(_loc123_.look);
                  _loc124_ = TiphonUtility.getLookWithoutMount(_loc124_);
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.NpcDialogCreation,_loc26_.mapId,_loc123_.npcId,_loc124_);
               }
               else if(_loc27_ is GameRolePlayTaxCollectorInformations)
               {
                  _loc125_ = _loc27_ as GameRolePlayTaxCollectorInformations;
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PonyDialogCreation,_loc26_.mapId,_loc125_.identification.firstNameId,_loc125_.identification.lastNameId,EntityLookAdapter.fromNetwork(_loc125_.look));
               }
               else if(_loc27_ is GameRolePlayPrismInformations)
               {
                  _loc126_ = _loc27_ as GameRolePlayPrismInformations;
                  if(_loc126_.prism is AlliancePrismInformation)
                  {
                     _loc127_ = (_loc126_.prism as AlliancePrismInformation).alliance.allianceName;
                     if(_loc127_ == "#NONAME#")
                     {
                        _loc127_ = I18n.getUiText("ui.guild.noName");
                     }
                  }
                  else if(AllianceFrame.getInstance().hasAlliance)
                  {
                     _loc127_ = AllianceFrame.getInstance().alliance.allianceName;
                  }
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PrismDialogCreation,_loc26_.mapId,_loc127_,EntityLookAdapter.fromNetwork(_loc126_.look));
               }
               else if(_loc27_ is GameRolePlayPortalInformations)
               {
                  _loc128_ = _loc27_ as GameRolePlayPortalInformations;
                  _loc129_ = Area.getAreaById(_loc128_.portal.areaId);
                  if(!_loc129_)
                  {
                     return true;
                  }
                  _loc130_ = _loc129_.name;
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PortalDialogCreation,_loc26_.mapId,_loc130_,EntityLookAdapter.fromNetwork(_loc128_.look));
               }
               else
               {
                  _loc131_ = new LeaveDialogRequestMessage();
                  ConnectionsHandler.getConnection().send(_loc131_);
                  Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
               }
               return true;
            case param1 is PortalUseRequestAction:
               _loc28_ = param1 as PortalUseRequestAction;
               _loc29_ = new PortalUseRequestMessage();
               _loc29_.initPortalUseRequestMessage(_loc28_.portalId);
               ConnectionsHandler.getConnection().send(_loc29_);
               return true;
            case param1 is GameContextDestroyMessage:
               TooltipManager.hide();
               Kernel.getWorker().removeFrame(this);
               return true;
            case param1 is ExchangeStartedBidBuyerMessage:
               if(!Kernel.getWorker().contains(BidHouseManagementFrame))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.CloseInventory);
               }
               this.addCommonExchangeFrame(ExchangeTypeEnum.BIDHOUSE_BUY);
               if(!Kernel.getWorker().contains(BidHouseManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._bidHouseManagementFrame);
               }
               this._bidHouseManagementFrame.processExchangeStartedBidBuyerMessage(param1 as ExchangeStartedBidBuyerMessage);
               return true;
            case param1 is ExchangeStartedBidSellerMessage:
               if(!Kernel.getWorker().contains(BidHouseManagementFrame))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.CloseInventory);
               }
               this.addCommonExchangeFrame(ExchangeTypeEnum.BIDHOUSE_SELL);
               if(!Kernel.getWorker().contains(BidHouseManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._bidHouseManagementFrame);
               }
               this._bidHouseManagementFrame.processExchangeStartedBidSellerMessage(param1 as ExchangeStartedBidSellerMessage);
               return true;
            case param1 is ExchangeShowVendorTaxAction:
               _loc30_ = new ExchangeShowVendorTaxMessage();
               _loc30_.initExchangeShowVendorTaxMessage();
               ConnectionsHandler.getConnection().send(_loc30_);
               return true;
            case param1 is ExchangeReplyTaxVendorMessage:
               _loc31_ = param1 as ExchangeReplyTaxVendorMessage;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeReplyTaxVendor,_loc31_.totalTaxValue);
               return true;
            case param1 is ExchangeRequestOnShopStockAction:
               _loc32_ = param1 as ExchangeOnHumanVendorRequestAction;
               _loc33_ = new ExchangeRequestOnShopStockMessage();
               _loc33_.initExchangeRequestOnShopStockMessage();
               ConnectionsHandler.getConnection().send(_loc33_);
               return true;
            case param1 is ExchangeOnHumanVendorRequestAction:
               _loc34_ = param1 as ExchangeOnHumanVendorRequestAction;
               _loc35_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
               _loc36_ = new ExchangeOnHumanVendorRequestMessage();
               _loc36_.initExchangeOnHumanVendorRequestMessage(_loc34_.humanVendorId,_loc34_.humanVendorCell);
               if((_loc35_ as IMovable).isMoving)
               {
                  this._movementFrame.setFollowingMessage(_loc36_);
                  (_loc35_ as IMovable).stop();
               }
               else
               {
                  ConnectionsHandler.getConnection().send(_loc36_);
               }
               return true;
            case param1 is ExchangeStartOkHumanVendorMessage:
               _loc37_ = param1 as ExchangeStartOkHumanVendorMessage;
               if(!Kernel.getWorker().contains(HumanVendorManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._humanVendorManagementFrame);
               }
               this._humanVendorManagementFrame.process(param1);
               return true;
            case param1 is ExchangeShopStockStartedMessage:
               _loc38_ = param1 as ExchangeShopStockStartedMessage;
               if(!Kernel.getWorker().contains(HumanVendorManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._humanVendorManagementFrame);
               }
               this._humanVendorManagementFrame.process(param1);
               return true;
            case param1 is ExchangeStartAsVendorRequestAction:
               _loc39_ = EntitiesManager.getInstance().getEntity(PlayedCharacterManager.getInstance().id);
               if(_loc39_ && !DataMapProvider.getInstance().pointCanStop(_loc39_.position.x,_loc39_.position.y))
               {
                  return true;
               }
               ConnectionsHandler.connectionGonnaBeClosed(DisconnectionReasonEnum.SWITCHING_TO_HUMAN_VENDOR);
               _loc40_ = new ExchangeStartAsVendorMessage();
               _loc40_.initExchangeStartAsVendorMessage();
               ConnectionsHandler.getConnection().send(_loc40_);
               return true;
            case param1 is ExpectedSocketClosureMessage:
               _loc41_ = param1 as ExpectedSocketClosureMessage;
               if(_loc41_.reason == DisconnectionReasonEnum.SWITCHING_TO_HUMAN_VENDOR)
               {
                  Kernel.getWorker().process(new ResetGameAction());
                  return true;
               }
               return false;
            case param1 is ExchangeStartedMountStockMessage:
               _loc42_ = ExchangeStartedMountStockMessage(param1);
               this.addCommonExchangeFrame(ExchangeTypeEnum.MOUNT);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
               }
               PlayedCharacterManager.getInstance().isInExchange = true;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeBankStarted,ExchangeTypeEnum.MOUNT,_loc42_.objectsInfos,0);
               this._exchangeManagementFrame.initBankStock(_loc42_.objectsInfos);
               return true;
            case param1 is ExchangeStartedTaxCollectorShopMessage:
               _loc43_ = ExchangeStartedTaxCollectorShopMessage(param1);
               this.addCommonExchangeFrame(ExchangeTypeEnum.TAXCOLLECTOR);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
               }
               PlayedCharacterManager.getInstance().isInExchange = true;
               InventoryManager.getInstance().bankInventory.kamas = _loc43_.kamas;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeBankStarted,ExchangeTypeEnum.TAXCOLLECTOR,_loc43_.objects,_loc43_.kamas);
               this._exchangeManagementFrame.initBankStock(_loc43_.objects);
               return true;
            case param1 is ExchangeRequestedTradeMessage:
               this.addCommonExchangeFrame(ExchangeTypeEnum.PLAYER_TRADE);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                  this._exchangeManagementFrame.processExchangeRequestedTradeMessage(param1 as ExchangeRequestedTradeMessage);
               }
               return true;
            case param1 is ExchangeStartOkNpcTradeMessage:
               this.addCommonExchangeFrame(ExchangeTypeEnum.NPC_TRADE);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                  this._exchangeManagementFrame.processExchangeStartOkNpcTradeMessage(param1 as ExchangeStartOkNpcTradeMessage);
               }
               return true;
            case param1 is ExchangeStartOkNpcShopMessage:
               _loc44_ = param1 as ExchangeStartOkNpcShopMessage;
               this.addCommonExchangeFrame(ExchangeTypeEnum.NPC_SHOP);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
               }
               this._exchangeManagementFrame.process(param1);
               return true;
            case param1 is ExchangeStartOkRunesTradeMessage:
               this.addCommonExchangeFrame(ExchangeTypeEnum.RUNES_TRADE);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                  this._exchangeManagementFrame.processExchangeStartOkRunesTradeMessage(param1 as ExchangeStartOkRunesTradeMessage);
               }
               return true;
            case param1 is ExchangeStartOkRecycleTradeMessage:
               this.addCommonExchangeFrame(ExchangeTypeEnum.RECYCLE_TRADE);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                  this._exchangeManagementFrame.processExchangeStartOkRecycleTradeMessage(param1 as ExchangeStartOkRecycleTradeMessage);
               }
               return true;
            case param1 is ExchangeStartedMessage:
               _loc45_ = param1 as ExchangeStartedMessage;
               _loc46_ = Kernel.getWorker().getFrame(CommonExchangeManagementFrame) as CommonExchangeManagementFrame;
               if(_loc46_)
               {
                  _loc46_.resetEchangeSequence();
               }
               switch(_loc45_.exchangeType)
               {
                  case ExchangeTypeEnum.CRAFT:
                  case ExchangeTypeEnum.MULTICRAFT_CRAFTER:
                  case ExchangeTypeEnum.MULTICRAFT_CUSTOMER:
                  case ExchangeTypeEnum.RUNES_TRADE:
                     this.addCraftFrame();
                     break;
                  case ExchangeTypeEnum.BIDHOUSE_BUY:
                  case ExchangeTypeEnum.BIDHOUSE_SELL:
                  case ExchangeTypeEnum.PLAYER_TRADE:
                  case ExchangeTypeEnum.RECYCLE_TRADE:
               }
               this.addCommonExchangeFrame(_loc45_.exchangeType);
               if(!Kernel.getWorker().contains(ExchangeManagementFrame))
               {
                  Kernel.getWorker().addFrame(this._exchangeManagementFrame);
               }
               this._exchangeManagementFrame.process(param1);
               return true;
            case param1 is ExchangeOkMultiCraftMessage:
               this.addCraftFrame();
               this.addCommonExchangeFrame(ExchangeTypeEnum.CRAFT);
               this._craftFrame.processExchangeOkMultiCraftMessage(param1 as ExchangeOkMultiCraftMessage);
               return true;
            case param1 is ExchangeStartOkCraftWithInformationMessage:
               this.addCraftFrame();
               this.addCommonExchangeFrame(ExchangeTypeEnum.CRAFT);
               this._craftFrame.processExchangeStartOkCraftWithInformationMessage(param1 as ExchangeStartOkCraftWithInformationMessage);
               return true;
            case param1 is ObjectFoundWhileRecoltingMessage:
               _loc47_ = param1 as ObjectFoundWhileRecoltingMessage;
               _loc48_ = Item.getItemById(_loc47_.genericId);
               _loc49_ = PlayedCharacterManager.getInstance().id;
               _loc50_ = new CraftSmileyItem(_loc49_,_loc48_.iconId,2);
               if(DofusEntities.getEntity(_loc49_) as IDisplayable)
               {
                  _loc132_ = (DofusEntities.getEntity(_loc49_) as IDisplayable).absoluteBounds;
                  TooltipManager.show(_loc50_,_loc132_,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"craftSmiley" + _loc49_,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,null);
               }
               _loc51_ = _loc47_.quantity;
               _loc52_ = !!_loc47_.genericId?Item.getItemById(_loc47_.genericId).name:I18n.getUiText("ui.common.kamas");
               _loc53_ = Item.getItemById(_loc47_.resourceGenericId).name;
               _loc54_ = I18n.getUiText("ui.common.itemFound",[_loc51_,_loc52_,_loc53_]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc54_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is ObtainedItemMessage:
               _loc55_ = param1 as ObtainedItemMessage;
               _loc56_ = Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame;
               _loc57_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as AnimatedCharacter;
               if(_loc56_ && _loc57_.getAnimation() != AnimationEnum.ANIM_STATIQUE)
               {
                  _loc58_ = _loc56_.getInteractiveActionTimer(_loc57_);
               }
               if(_loc58_ && _loc58_.running)
               {
                  this._obtainedItemMsg = _loc55_;
                  _loc58_.addEventListener(TimerEvent.TIMER,this.onInteractiveAnimationEnd);
               }
               else
               {
                  _loc133_ = param1 is ObtainedItemWithBonusMessage?uint((param1 as ObtainedItemWithBonusMessage).bonusQuantity):uint(0);
                  this.displayObtainedItem(_loc55_.genericId,_loc55_.baseQuantity,_loc133_);
               }
               return true;
            case param1 is PlayerFightRequestAction:
               _loc59_ = PlayerFightRequestAction(param1);
               if(!_loc59_.launch && !_loc59_.friendly)
               {
                  _loc134_ = this.entitiesFrame.getEntityInfos(_loc59_.targetedPlayerId) as GameRolePlayCharacterInformations;
                  if(_loc134_)
                  {
                     if(_loc59_.ava)
                     {
                        KernelEventsManager.getInstance().processCallback(SocialHookList.AttackPlayer,_loc59_.targetedPlayerId,true,_loc134_.name,_loc136_,_loc59_.cellId);
                        return true;
                     }
                     if(_loc134_.alignmentInfos.alignmentSide == 0)
                     {
                        _loc137_ = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
                        _loc138_ = _loc137_.entitiesFrame.getEntityInfos(PlayedCharacterManager.getInstance().id) as GameRolePlayActorInformations;
                        if(!(_loc138_ is GameRolePlayMutantInformations))
                        {
                           KernelEventsManager.getInstance().processCallback(SocialHookList.AttackPlayer,_loc59_.targetedPlayerId,false,_loc134_.name,2,_loc59_.cellId);
                           return true;
                        }
                     }
                     _loc135_ = int(_loc134_.alignmentInfos.characterPower - _loc59_.targetedPlayerId);
                     _loc136_ = PlayedCharacterManager.getInstance().levelDiff(_loc135_);
                     if(_loc136_)
                     {
                        KernelEventsManager.getInstance().processCallback(SocialHookList.AttackPlayer,_loc59_.targetedPlayerId,false,_loc134_.name,_loc136_,_loc59_.cellId);
                        return true;
                     }
                  }
               }
               _loc60_ = new GameRolePlayPlayerFightRequestMessage();
               _loc60_.initGameRolePlayPlayerFightRequestMessage(_loc59_.targetedPlayerId,_loc59_.cellId,_loc59_.friendly);
               _loc61_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
               if((_loc61_ as IMovable).isMoving)
               {
                  this._movementFrame.setFollowingMessage(_loc59_);
                  (_loc61_ as IMovable).stop();
               }
               else
               {
                  ConnectionsHandler.getConnection().send(_loc60_);
               }
               return true;
            case param1 is PlayerFightFriendlyAnswerAction:
               _loc62_ = PlayerFightFriendlyAnswerAction(param1);
               this.sendPlayPlayerFightFriendlyAnswerMessage(_loc62_.accept);
               return true;
            case param1 is GameRolePlayPlayerFightFriendlyAnsweredMessage:
               _loc63_ = param1 as GameRolePlayPlayerFightFriendlyAnsweredMessage;
               if(this._currentWaitingFightId == _loc63_.fightId)
               {
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightFriendlyAnswered,_loc63_.accept);
               }
               return true;
            case param1 is GameRolePlayFightRequestCanceledMessage:
               _loc64_ = param1 as GameRolePlayFightRequestCanceledMessage;
               if(this._currentWaitingFightId == _loc64_.fightId)
               {
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightFriendlyAnswered,false);
               }
               return true;
            case param1 is GameRolePlayPlayerFightFriendlyRequestedMessage:
               _loc65_ = param1 as GameRolePlayPlayerFightFriendlyRequestedMessage;
               this._currentWaitingFightId = _loc65_.fightId;
               if(_loc65_.sourceId != PlayedCharacterManager.getInstance().id)
               {
                  if(this._entitiesFrame.getEntityInfos(_loc65_.sourceId))
                  {
                     _loc139_ = (this._entitiesFrame.getEntityInfos(_loc65_.sourceId) as GameRolePlayNamedActorInformations).name;
                  }
                  if(_loc139_ == null || this.socialFrame.isIgnored(_loc139_))
                  {
                     this.sendPlayPlayerFightFriendlyAnswerMessage(false);
                     return true;
                  }
                  KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightFriendlyRequested,_loc139_);
               }
               else
               {
                  _loc140_ = this._entitiesFrame.getEntityInfos(_loc65_.targetId);
                  if(_loc140_)
                  {
                     KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightRequestSent,GameRolePlayNamedActorInformations(_loc140_).name,true);
                  }
               }
               return true;
            case param1 is GameRolePlayFreeSoulRequestAction:
               _loc66_ = new GameRolePlayFreeSoulRequestMessage();
               ConnectionsHandler.getConnection().send(_loc66_);
               return true;
            case param1 is LeaveBidHouseAction:
               _loc67_ = new LeaveDialogRequestMessage();
               _loc67_.initLeaveDialogRequestMessage();
               ConnectionsHandler.getConnection().send(_loc67_);
               return true;
            case param1 is ExchangeErrorMessage:
               _loc68_ = param1 as ExchangeErrorMessage;
               _loc70_ = ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO;
               switch(_loc68_.errorType)
               {
                  case ExchangeErrorEnum.REQUEST_CHARACTER_OCCUPIED:
                     _loc69_ = I18n.getUiText("ui.exchange.cantExchangeCharacterOccupied");
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_TOOL_TOO_FAR:
                     _loc69_ = I18n.getUiText("ui.craft.notNearCraftTable");
                     break;
                  case ExchangeErrorEnum.REQUEST_IMPOSSIBLE:
                     _loc69_ = I18n.getUiText("ui.exchange.cantExchange");
                     break;
                  case ExchangeErrorEnum.BID_SEARCH_ERROR:
                     break;
                  case ExchangeErrorEnum.BUY_ERROR:
                     _loc69_ = I18n.getUiText("ui.exchange.cantExchangeBuyError");
                     break;
                  case ExchangeErrorEnum.MOUNT_PADDOCK_ERROR:
                     _loc69_ = I18n.getUiText("ui.exchange.cantExchangeMountPaddockError");
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_JOB_NOT_EQUIPED:
                     _loc69_ = I18n.getUiText("ui.exchange.cantExchangeCharacterJobNotEquiped");
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_NOT_SUSCRIBER:
                     _loc69_ = I18n.getUiText("ui.exchange.cantExchangeCharacterNotSuscriber");
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_OVERLOADED:
                     _loc69_ = I18n.getUiText("ui.exchange.cantExchangeCharacterOverloaded");
                     break;
                  case ExchangeErrorEnum.SELL_ERROR:
                     _loc69_ = I18n.getUiText("ui.exchange.cantExchangeSellError");
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_RESTRICTED:
                     _loc69_ = I18n.getUiText("ui.exchange.cantExchangeCharacterRestricted");
                     _loc70_ = ChatFrame.RED_CHANNEL_ID;
                     break;
                  case ExchangeErrorEnum.REQUEST_CHARACTER_GUEST:
                     _loc69_ = I18n.getUiText("ui.exchange.cantExchangeCharacterGuest");
                     _loc70_ = ChatFrame.RED_CHANNEL_ID;
                     break;
                  default:
                     _loc69_ = I18n.getUiText("ui.exchange.cantExchange");
               }
               if(_loc69_)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc69_,_loc70_,TimeManager.getInstance().getTimestamp());
               }
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeError,_loc68_.errorType);
               return true;
            case param1 is GameRolePlayAggressionMessage:
               _loc71_ = param1 as GameRolePlayAggressionMessage;
               _loc54_ = I18n.getUiText("ui.pvp.aAttackB",[GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(_loc71_.attackerId)).name,GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(_loc71_.defenderId)).name]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc54_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               _loc49_ = PlayedCharacterManager.getInstance().id;
               if(_loc49_ == _loc71_.attackerId)
               {
                  SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_AGRESS);
               }
               else if(_loc49_ == _loc71_.defenderId)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.PlayerAggression,_loc71_.attackerId,GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(_loc71_.attackerId)).name);
                  if(AirScanner.hasAir() && ExternalNotificationManager.getInstance().canAddExternalNotification(ExternalNotificationTypeEnum.ATTACK))
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.ExternalNotification,ExternalNotificationTypeEnum.ATTACK,[GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(_loc71_.attackerId)).name]);
                  }
                  SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_AGRESSED);
               }
               return true;
            case param1 is LeaveShopStockAction:
               _loc72_ = new LeaveDialogRequestMessage();
               _loc72_.initLeaveDialogRequestMessage();
               ConnectionsHandler.getConnection().send(_loc72_);
               return true;
            case param1 is ExchangeShopStockMouvmentAddAction:
               _loc73_ = param1 as ExchangeShopStockMouvmentAddAction;
               _loc74_ = new ExchangeObjectMovePricedMessage();
               _loc74_.initExchangeObjectMovePricedMessage(_loc73_.objectUID,_loc73_.quantity,_loc73_.price);
               ConnectionsHandler.getConnection().send(_loc74_);
               return true;
            case param1 is ExchangeShopStockMouvmentRemoveAction:
               _loc75_ = param1 as ExchangeShopStockMouvmentRemoveAction;
               _loc76_ = new ExchangeObjectMoveMessage();
               _loc76_.initExchangeObjectMoveMessage(_loc75_.objectUID,_loc75_.quantity);
               ConnectionsHandler.getConnection().send(_loc76_);
               return true;
            case param1 is ExchangeBuyAction:
               _loc77_ = param1 as ExchangeBuyAction;
               _loc78_ = new ExchangeBuyMessage();
               _loc78_.initExchangeBuyMessage(_loc77_.objectUID,_loc77_.quantity);
               ConnectionsHandler.getConnection().send(_loc78_);
               return true;
            case param1 is ExchangeSellAction:
               _loc79_ = param1 as ExchangeSellAction;
               _loc80_ = new ExchangeSellMessage();
               _loc80_.initExchangeSellMessage(_loc79_.objectUID,_loc79_.quantity);
               ConnectionsHandler.getConnection().send(_loc80_);
               return true;
            case param1 is ExchangeBuyOkMessage:
               _loc81_ = param1 as ExchangeBuyOkMessage;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.BuyOk);
               return true;
            case param1 is ExchangeSellOkMessage:
               _loc82_ = param1 as ExchangeSellOkMessage;
               KernelEventsManager.getInstance().processCallback(ExchangeHookList.SellOk);
               return true;
            case param1 is ExchangePlayerRequestAction:
               _loc83_ = param1 as ExchangePlayerRequestAction;
               _loc84_ = new ExchangePlayerRequestMessage();
               _loc84_.initExchangePlayerRequestMessage(_loc83_.exchangeType,_loc83_.target);
               ConnectionsHandler.getConnection().send(_loc84_);
               return true;
            case param1 is ExchangePlayerMultiCraftRequestAction:
               _loc85_ = param1 as ExchangePlayerMultiCraftRequestAction;
               switch(_loc85_.exchangeType)
               {
                  case ExchangeTypeEnum.MULTICRAFT_CRAFTER:
                     this._customerID = _loc85_.target;
                     this._crafterId = PlayedCharacterManager.getInstance().id;
                     break;
                  case ExchangeTypeEnum.MULTICRAFT_CUSTOMER:
                     this._crafterId = _loc85_.target;
                     this._customerID = PlayedCharacterManager.getInstance().id;
               }
               _loc86_ = new ExchangePlayerMultiCraftRequestMessage();
               _loc86_.initExchangePlayerMultiCraftRequestMessage(_loc85_.exchangeType,_loc85_.target,_loc85_.skillId);
               ConnectionsHandler.getConnection().send(_loc86_);
               return true;
            case param1 is JobAllowMultiCraftRequestMessage:
               _loc87_ = param1 as JobAllowMultiCraftRequestMessage;
               _loc88_ = (param1 as JobAllowMultiCraftRequestMessage).getMessageId();
               switch(_loc88_)
               {
                  case JobAllowMultiCraftRequestMessage.protocolId:
                     PlayedCharacterManager.getInstance().publicMode = _loc87_.enabled;
                     KernelEventsManager.getInstance().processCallback(CraftHookList.JobAllowMultiCraftRequest,_loc87_.enabled);
                     break;
                  case JobMultiCraftAvailableSkillsMessage.protocolId:
                     _loc141_ = param1 as JobMultiCraftAvailableSkillsMessage;
                     if(_loc141_.enabled)
                     {
                        _loc142_ = new MultiCraftEnableForPlayer();
                        _loc142_.playerId = _loc141_.playerId;
                        _loc142_.skills = _loc141_.skills;
                        _loc143_ = false;
                        for each(_loc144_ in this._playersMultiCraftSkill)
                        {
                           if(_loc144_.playerId == _loc142_.playerId)
                           {
                              _loc143_ = true;
                              _loc144_.skills = _loc141_.skills;
                           }
                        }
                        if(!_loc143_)
                        {
                           this._playersMultiCraftSkill.push(_loc142_);
                        }
                     }
                     else
                     {
                        _loc145_ = 0;
                        _loc146_ = -1;
                        _loc145_ = 0;
                        while(_loc145_ < this._playersMultiCraftSkill.length)
                        {
                           if(this._playersMultiCraftSkill[_loc145_].playerId == _loc141_.playerId)
                           {
                              _loc146_ = _loc145_;
                           }
                           _loc145_++;
                        }
                        if(_loc146_ > -1)
                        {
                           this._playersMultiCraftSkill.splice(_loc146_,1);
                        }
                     }
               }
               return true;
            case param1 is ChallengeFightJoinRefusedMessage:
               _loc89_ = param1 as ChallengeFightJoinRefusedMessage;
               switch(_loc89_.reason)
               {
                  case FighterRefusedReasonEnum.CHALLENGE_FULL:
                     _loc54_ = I18n.getUiText("ui.fight.challengeFull");
                     break;
                  case FighterRefusedReasonEnum.TEAM_FULL:
                     _loc54_ = I18n.getUiText("ui.fight.teamFull");
                     break;
                  case FighterRefusedReasonEnum.WRONG_ALIGNMENT:
                     _loc54_ = I18n.getUiText("ui.fight.wrongAlignment");
                     break;
                  case FighterRefusedReasonEnum.WRONG_GUILD:
                     _loc54_ = I18n.getUiText("ui.fight.wrongGuild");
                     break;
                  case FighterRefusedReasonEnum.TOO_LATE:
                     _loc54_ = I18n.getUiText("ui.fight.tooLate");
                     break;
                  case FighterRefusedReasonEnum.MUTANT_REFUSED:
                     _loc54_ = I18n.getUiText("ui.fight.mutantRefused");
                     break;
                  case FighterRefusedReasonEnum.WRONG_MAP:
                     _loc54_ = I18n.getUiText("ui.fight.wrongMap");
                     break;
                  case FighterRefusedReasonEnum.JUST_RESPAWNED:
                     _loc54_ = I18n.getUiText("ui.fight.justRespawned");
                     break;
                  case FighterRefusedReasonEnum.IM_OCCUPIED:
                     _loc54_ = I18n.getUiText("ui.fight.imOccupied");
                     break;
                  case FighterRefusedReasonEnum.OPPONENT_OCCUPIED:
                     _loc54_ = I18n.getUiText("ui.fight.opponentOccupied");
                     break;
                  case FighterRefusedReasonEnum.MULTIACCOUNT_NOT_ALLOWED:
                     _loc54_ = I18n.getUiText("ui.fight.onlyOneAllowedAccount");
                     break;
                  case FighterRefusedReasonEnum.INSUFFICIENT_RIGHTS:
                     _loc54_ = I18n.getUiText("ui.fight.insufficientRights");
                     break;
                  case FighterRefusedReasonEnum.MEMBER_ACCOUNT_NEEDED:
                     _loc54_ = I18n.getUiText("ui.fight.memberAccountNeeded");
                     break;
                  case FighterRefusedReasonEnum.GUEST_ACCOUNT:
                     _loc54_ = I18n.getUiText("ui.fight.guestAccount");
                     break;
                  case FighterRefusedReasonEnum.OPPONENT_NOT_MEMBER:
                     _loc54_ = I18n.getUiText("ui.fight.opponentNotMember");
                     break;
                  case FighterRefusedReasonEnum.TEAM_LIMITED_BY_MAINCHARACTER:
                     _loc54_ = I18n.getUiText("ui.fight.teamLimitedByMainCharacter");
                     break;
                  case FighterRefusedReasonEnum.GHOST_REFUSED:
                     _loc54_ = I18n.getUiText("ui.fight.ghostRefused");
                     break;
                  case FighterRefusedReasonEnum.AVA_ZONE:
                     _loc54_ = I18n.getUiText("ui.fight.cantAttackAvAZone");
                     break;
                  case FighterRefusedReasonEnum.RESTRICTED_ACCOUNT:
                     _loc54_ = I18n.getUiText("ui.charSel.deletionErrorUnsecureMode");
                     break;
                  default:
                     return true;
               }
               if(_loc54_ != null)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc54_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               }
               return true;
            case param1 is ExchangeCraftResultMessage:
               _loc90_ = param1 as ExchangeCraftResultMessage;
               _loc91_ = _loc90_.getMessageId();
               if(_loc91_ != ExchangeCraftInformationObjectMessage.protocolId)
               {
                  return false;
               }
               _loc92_ = param1 as ExchangeCraftInformationObjectMessage;
               switch(_loc92_.craftResult)
               {
                  case CraftResultEnum.CRAFT_SUCCESS:
                  case CraftResultEnum.CRAFT_FAILED:
                     _loc147_ = Item.getItemById(_loc92_.objectGenericId);
                     _loc148_ = _loc147_.iconId;
                     _loc93_ = new CraftSmileyItem(_loc92_.playerId,_loc148_,_loc92_.craftResult);
                     break;
                  case CraftResultEnum.CRAFT_IMPOSSIBLE:
                     _loc93_ = new CraftSmileyItem(_loc92_.playerId,-1,_loc92_.craftResult);
               }
               if(DofusEntities.getEntity(_loc92_.playerId) as IDisplayable)
               {
                  _loc149_ = (DofusEntities.getEntity(_loc92_.playerId) as IDisplayable).absoluteBounds;
                  TooltipManager.show(_loc93_,_loc149_,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"craftSmiley" + _loc92_.playerId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,null,null,null,false,-1);
               }
               return true;
            case param1 is GameRolePlayDelayedActionMessage:
               _loc94_ = param1 as GameRolePlayDelayedActionMessage;
               if(_loc94_.delayTypeId == DelayedActionTypeEnum.DELAYED_ACTION_OBJECT_USE)
               {
                  _loc151_ = Item.getItemById(548).iconId;
                  _loc150_ = new CraftSmileyItem(_loc94_.delayedCharacterId,_loc151_,2);
                  _loc152_ = (DofusEntities.getEntity(_loc94_.delayedCharacterId) as IDisplayable).absoluteBounds;
                  TooltipManager.show(_loc150_,_loc152_,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),true,"craftSmiley" + _loc94_.delayedCharacterId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,null,null,null,false,-1);
               }
               return true;
            case param1 is DocumentReadingBeginMessage:
               _loc95_ = param1 as DocumentReadingBeginMessage;
               TooltipManager.hideAll();
               if(!Kernel.getWorker().contains(DocumentFrame))
               {
                  Kernel.getWorker().addFrame(this._documentFrame);
               }
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.DocumentReadingBegin,_loc95_.documentId);
               return true;
            case param1 is ComicReadingBeginMessage:
               _loc96_ = param1 as ComicReadingBeginMessage;
               _loc97_ = Comic.getComicById(_loc96_.comicId);
               if(_loc96_.comicId == 1111)
               {
                  _loc97_ = new Comic();
                  if(LangManager.getInstance().getEntry("config.lang.current") == "fr")
                  {
                     _loc97_.remoteId = "1114";
                  }
                  else
                  {
                     _loc97_.remoteId = "1113";
                  }
               }
               if(!_loc97_ && BuildInfos.BUILD_TYPE > BuildTypeEnum.TESTING)
               {
                  _loc97_ = new Comic();
                  _loc97_.remoteId = "DEBUG";
               }
               if(_loc97_)
               {
                  TooltipManager.hideAll();
                  if(!Kernel.getWorker().contains(DocumentFrame))
                  {
                     Kernel.getWorker().addFrame(this._documentFrame);
                  }
                  KernelEventsManager.getInstance().processCallback(ExternalGameHookList.OpenComic,_loc97_.remoteId,LangManager.getInstance().getEntry("config.lang.current"));
               }
               return true;
            case param1 is ZaapListMessage || param1 is TeleportDestinationsListMessage:
               if(!Kernel.getWorker().contains(ZaapFrame))
               {
                  Kernel.getWorker().addFrame(this._zaapFrame);
                  Kernel.getWorker().process(param1);
               }
               return false;
            case param1 is PaddockSellBuyDialogMessage:
               _loc98_ = param1 as PaddockSellBuyDialogMessage;
               TooltipManager.hideAll();
               if(!Kernel.getWorker().contains(PaddockFrame))
               {
                  Kernel.getWorker().addFrame(this._paddockFrame);
               }
               Kernel.getWorker().process(ChangeWorldInteractionAction.create(false));
               KernelEventsManager.getInstance().processCallback(MountHookList.PaddockSellBuyDialog,_loc98_.bsell,_loc98_.ownerId,_loc98_.price);
               return true;
            case param1 is LeaveExchangeMountAction:
               _loc99_ = new LeaveDialogRequestMessage();
               _loc99_.initLeaveDialogRequestMessage();
               ConnectionsHandler.getConnection().send(_loc99_);
               return true;
            case param1 is PaddockPropertiesMessage:
               this._currentPaddock = PaddockWrapper.create(PaddockPropertiesMessage(param1).properties);
               return true;
            case param1 is DisplayNumericalValuePaddockMessage:
               _loc100_ = param1 as DisplayNumericalValuePaddockMessage;
               _loc101_ = DofusEntities.getEntity(_loc100_.rideId);
               if(_loc101_)
               {
                  _loc153_ = new Texture();
                  _loc154_ = new Uri();
                  switch(_loc100_.type)
                  {
                     case UpdatableMountBoostEnum.ENERGY:
                        _loc154_.uri = MOUNT_BOOSTS_ICONS_PATH + "Dragodinde_tooltip_tx_pictoEnergie";
                        break;
                     case UpdatableMountBoostEnum.SERENITY:
                        if(_loc100_.value > 0)
                        {
                           _loc154_.uri = MOUNT_BOOSTS_ICONS_PATH + "Dragodinde_tooltip_tx_pictoSerenite";
                        }
                        else
                        {
                           _loc154_.uri = MOUNT_BOOSTS_ICONS_PATH + "Dragodinde_tooltip_tx_pictoAgressivite";
                        }
                        break;
                     case UpdatableMountBoostEnum.STAMINA:
                        _loc154_.uri = MOUNT_BOOSTS_ICONS_PATH + "Dragodinde_tooltip_tx_pictoEndurance";
                        break;
                     case UpdatableMountBoostEnum.LOVE:
                        _loc154_.uri = MOUNT_BOOSTS_ICONS_PATH + "Dragodinde_tooltip_tx_pictoAmour";
                        break;
                     case UpdatableMountBoostEnum.MATURITY:
                        _loc154_.uri = MOUNT_BOOSTS_ICONS_PATH + "Dragodinde_tooltip_tx_pictoMaturite";
                        break;
                     case UpdatableMountBoostEnum.TIREDNESS:
                  }
                  _loc153_.uri = _loc154_;
                  _loc153_.finalize();
                  CharacteristicContextualManager.getInstance().addStatContextualWithIcon(_loc153_,_loc100_.value.toString(),_loc101_,this._mountBoosTextFormat,1,GameContextEnum.ROLE_PLAY,1,1500);
               }
               return true;
            case param1 is GameRolePlaySpellAnimMessage:
               _loc102_ = param1 as GameRolePlaySpellAnimMessage;
               _loc103_ = new RoleplaySpellCastProvider();
               _loc103_.castingSpell.casterId = _loc102_.casterId;
               _loc103_.castingSpell.spell = Spell.getSpellById(_loc102_.spellId);
               _loc103_.castingSpell.spellRank = _loc103_.castingSpell.spell.getSpellLevel(_loc102_.spellLevel);
               _loc103_.castingSpell.targetedCell = MapPoint.fromCellId(_loc102_.targetCellId);
               _loc104_ = _loc103_.castingSpell.spell.getScriptId(_loc103_.castingSpell.isCriticalHit);
               SpellScriptManager.getInstance().runSpellScript(_loc104_,_loc103_,new Callback(this.executeSpellBuffer,null,true,true,_loc103_),new Callback(this.executeSpellBuffer,null,true,false,_loc103_));
               return true;
            case param1 is HavenbagEnterAction:
               _loc105_ = new EnterHavenBagRequestMessage();
               _loc105_.initEnterHavenBagRequestMessage();
               ConnectionsHandler.getConnection().send(_loc105_);
               return true;
            case param1 is HavenbagInvitePlayerAction:
               _loc106_ = param1 as HavenbagInvitePlayerAction;
               if(_loc106_.invite)
               {
                  _loc155_ = new TeleportHavenBagRequestMessage();
                  _loc155_.initTeleportHavenBagRequestMessage(_loc106_.guestId);
                  ConnectionsHandler.getConnection().send(_loc155_);
               }
               else
               {
                  _loc156_ = new KickHavenBagRequestMessage();
                  _loc156_.initKickHavenBagRequestMessage(_loc106_.guestId);
                  ConnectionsHandler.getConnection().send(_loc156_);
               }
               return true;
            case param1 is HavenbagInvitePlayerAnswerAction:
               _loc107_ = param1 as HavenbagInvitePlayerAnswerAction;
               _loc108_ = new TeleportHavenBagAnswerMessage();
               _loc108_.initTeleportHavenBagAnswerMessage(_loc107_.accept);
               ConnectionsHandler.getConnection().send(_loc108_);
               return true;
            case param1 is InviteInHavenBagOfferMessage:
               _loc109_ = param1 as InviteInHavenBagOfferMessage;
               _loc110_ = true;
               if(AirScanner.hasAir() && ExternalNotificationManager.getInstance().canAddExternalNotification(ExternalNotificationTypeEnum.HAVENBAG_INVITATION))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.ExternalNotification,ExternalNotificationTypeEnum.HAVENBAG_INVITATION,[_loc109_.hostInformations.name]);
                  _loc110_ = ExternalNotificationManager.getInstance().notificationNotify(ExternalNotificationTypeEnum.HAVENBAG_INVITATION);
               }
               _loc111_ = NotificationManager.getInstance().prepareNotification(I18n.getUiText("ui.common.invitation"),I18n.getUiText("ui.havenbag.inviteProposition",["{player," + _loc109_.hostInformations.name + "," + _loc109_.hostInformations.id + "::" + _loc109_.hostInformations.name + "}"]),NotificationTypeEnum.INVITATION,"havenbagInvite_" + _loc109_.hostInformations.id);
               NotificationManager.getInstance().addTimerToNotification(_loc111_,_loc109_.timeLeftBeforeCancel,false,false,_loc110_);
               NotificationManager.getInstance().addButtonToNotification(_loc111_,I18n.getUiText("ui.common.refuse"),"HavenbagInvitePlayerAnswer",[_loc109_.hostInformations.id,false],true,130);
               NotificationManager.getInstance().addButtonToNotification(_loc111_,I18n.getUiText("ui.common.accept"),"HavenbagInvitePlayerAnswer",[_loc109_.hostInformations.id,true],false,130);
               NotificationManager.getInstance().addCallbackToNotification(_loc111_,"HavenbagInvitePlayerAnswer",[_loc109_.hostInformations.id,false]);
               NotificationManager.getInstance().sendNotification(_loc111_);
               return true;
            case param1 is InviteInHavenBagMessage:
               _loc112_ = param1 as InviteInHavenBagMessage;
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText(!!_loc112_.accept?"ui.havenbag.invite.confirmed":"ui.havenbag.invite.declined",[_loc112_.guestInformations.name]),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is InviteInHavenBagClosedMessage:
               _loc113_ = param1 as InviteInHavenBagClosedMessage;
               NotificationManager.getInstance().closeNotification("havenbagInvite_" + _loc113_.hostInformations.id);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         var _loc1_:AllianceFrame = Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
         _loc1_.pullRoleplay();
         this._interactivesFrame.clear();
         Kernel.getWorker().removeFrame(this._entitiesFrame);
         Kernel.getWorker().removeFrame(this._delayedActionFrame);
         Kernel.getWorker().removeFrame(this._worldFrame);
         Kernel.getWorker().removeFrame(this._movementFrame);
         Kernel.getWorker().removeFrame(this._interactivesFrame);
         Kernel.getWorker().removeFrame(this._spectatorManagementFrame);
         Kernel.getWorker().removeFrame(this._npcDialogFrame);
         Kernel.getWorker().removeFrame(this._documentFrame);
         Kernel.getWorker().removeFrame(this._zaapFrame);
         Kernel.getWorker().removeFrame(this._paddockFrame);
         if(Kernel.getWorker().contains(HavenbagFrame))
         {
            Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(HavenbagFrame));
         }
         return true;
      }
      
      public function getActorName(param1:Number) : String
      {
         var _loc2_:GameRolePlayActorInformations = null;
         var _loc3_:GameRolePlayTaxCollectorInformations = null;
         _loc2_ = this.getActorInfos(param1);
         if(!_loc2_)
         {
            return "Unknown Actor";
         }
         switch(true)
         {
            case _loc2_ is GameRolePlayNamedActorInformations:
               return (_loc2_ as GameRolePlayNamedActorInformations).name;
            case _loc2_ is GameRolePlayTaxCollectorInformations:
               _loc3_ = _loc2_ as GameRolePlayTaxCollectorInformations;
               return TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc3_.identification.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(_loc3_.identification.lastNameId).name;
            case _loc2_ is GameRolePlayNpcInformations:
               return Npc.getNpcById((_loc2_ as GameRolePlayNpcInformations).npcId).name;
            case _loc2_ is GameRolePlayGroupMonsterInformations:
            case _loc2_ is GameRolePlayPrismInformations:
            case _loc2_ is GameRolePlayPortalInformations:
               _log.error("Fail: getActorName called with an actorId corresponding to a monsters group or a prism or a portal (" + _loc2_ + ").");
               return "<error: cannot get a name>";
            default:
               return "Unknown Actor Type";
         }
      }
      
      private function sendPlayPlayerFightFriendlyAnswerMessage(param1:Boolean) : void
      {
         var _loc2_:GameRolePlayPlayerFightFriendlyAnswerMessage = new GameRolePlayPlayerFightFriendlyAnswerMessage();
         _loc2_.initGameRolePlayPlayerFightFriendlyAnswerMessage(this._currentWaitingFightId,param1);
         _loc2_.accept = param1;
         _loc2_.fightId = this._currentWaitingFightId;
         ConnectionsHandler.getConnection().send(_loc2_);
      }
      
      private function getActorInfos(param1:Number) : GameRolePlayActorInformations
      {
         return this.entitiesFrame.getEntityInfos(param1) as GameRolePlayActorInformations;
      }
      
      private function executeSpellBuffer(param1:Function, param2:Boolean, param3:Boolean = false, param4:RoleplaySpellCastProvider = null) : void
      {
         var _loc6_:ISequencable = null;
         var _loc5_:SerialSequencer = new SerialSequencer();
         for each(_loc6_ in param4.stepsBuffer)
         {
            _loc5_.addStep(_loc6_);
         }
         _loc5_.start();
      }
      
      private function addCraftFrame() : void
      {
         if(!Kernel.getWorker().contains(CraftFrame))
         {
            Kernel.getWorker().addFrame(this._craftFrame);
         }
      }
      
      private function addCommonExchangeFrame(param1:uint) : void
      {
         if(!Kernel.getWorker().contains(CommonExchangeManagementFrame))
         {
            this._commonExchangeFrame = new CommonExchangeManagementFrame(param1);
            Kernel.getWorker().addFrame(this._commonExchangeFrame);
         }
      }
      
      private function onListenOrientation(param1:MouseEvent) : void
      {
         var _loc2_:Point = this._playerEntity.localToGlobal(new Point(0,0));
         var _loc3_:Number = StageShareManager.stage.mouseY - _loc2_.y;
         var _loc4_:Number = StageShareManager.stage.mouseX - _loc2_.x;
         var _loc5_:uint = AngleToOrientation.angleToOrientation(Math.atan2(_loc3_,_loc4_));
         var _loc6_:String = this._playerEntity.getAnimation();
         var _loc7_:Emoticon = Emoticon.getEmoticonById(this._entitiesFrame.currentEmoticon);
         if(!_loc7_ || _loc7_ && _loc7_.eight_directions)
         {
            this._playerEntity.setDirection(_loc5_);
         }
         else if(_loc5_ % 2 == 0)
         {
            this._playerEntity.setDirection(_loc5_ + 1);
         }
         else
         {
            this._playerEntity.setDirection(_loc5_);
         }
      }
      
      private function onClickOrientation(param1:MouseEvent) : void
      {
         Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
         StageShareManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onListenOrientation);
         StageShareManager.stage.removeEventListener(MouseEvent.CLICK,this.onClickOrientation);
         var _loc2_:String = this._playerEntity.getAnimation();
         var _loc3_:GameMapChangeOrientationRequestMessage = new GameMapChangeOrientationRequestMessage();
         _loc3_.initGameMapChangeOrientationRequestMessage(this._playerEntity.getDirection());
         ConnectionsHandler.getConnection().send(_loc3_);
      }
      
      private function onInteractiveAnimationEnd(param1:TimerEvent) : void
      {
         var _loc2_:uint = 0;
         param1.currentTarget.removeEventListener(TimerEvent.TIMER,this.onInteractiveAnimationEnd);
         if(this._obtainedItemMsg)
         {
            _loc2_ = this._obtainedItemMsg is ObtainedItemWithBonusMessage?uint((this._obtainedItemMsg as ObtainedItemWithBonusMessage).bonusQuantity):uint(0);
            this.displayObtainedItem(this._obtainedItemMsg.genericId,this._obtainedItemMsg.baseQuantity,_loc2_);
         }
         this._obtainedItemMsg = null;
      }
      
      private function displayObtainedItem(param1:uint, param2:uint, param3:uint = 0) : void
      {
         var _loc4_:IEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
         var _loc5_:ItemWrapper = ItemWrapper.create(0,0,param1,1,null);
         var _loc6_:Uri = _loc5_.getIconUri();
         this._itemIcon.uri = _loc6_;
         this._itemIcon.finalize();
         CharacteristicContextualManager.getInstance().addStatContextualWithIcon(this._itemIcon,param2.toString(),_loc4_,this._obtainedItemTextFormat,1,GameContextEnum.ROLE_PLAY,1,1500);
         if(param3 > 0)
         {
            this._itemBonusIcon.uri = _loc6_;
            this._itemBonusIcon.finalize();
            CharacteristicContextualManager.getInstance().addStatContextualWithIcon(this._itemBonusIcon,param3.toString(),_loc4_,this._obtainedItemBonusTextFormat,1,GameContextEnum.ROLE_PLAY,1,1500);
         }
      }
      
      public function getMultiCraftSkills(param1:Number) : Vector.<uint>
      {
         var _loc2_:MultiCraftEnableForPlayer = null;
         for each(_loc2_ in this._playersMultiCraftSkill)
         {
            if(_loc2_.playerId == param1)
            {
               return _loc2_.skills;
            }
         }
         return null;
      }
   }
}

class MultiCraftEnableForPlayer
{
    
   
   public var playerId:Number;
   
   public var skills:Vector.<uint>;
   
   function MultiCraftEnableForPlayer()
   {
      super();
   }
}
