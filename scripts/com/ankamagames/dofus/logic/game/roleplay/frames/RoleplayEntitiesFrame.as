package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.messages.EntityMovementCompleteMessage;
   import com.ankamagames.atouin.messages.EntityMovementStoppedMessage;
   import com.ankamagames.atouin.messages.MapLoadedMessage;
   import com.ankamagames.atouin.messages.MapZoomMessage;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.houses.HavenbagTheme;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.datacenter.sounds.SoundAnimation;
   import com.ankamagames.dofus.datacenter.sounds.SoundBones;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.factories.RolePlayEntitiesFactory;
   import com.ankamagames.dofus.internalDatacenter.communication.EmoteWrapper;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ShortcutWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.PartyMemberWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.common.actions.StartZoomAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.PaddockMoveItemRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.mount.PaddockRemoveItemRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.roleplay.SwitchCreatureModeAction;
   import com.ankamagames.dofus.logic.game.common.frames.AbstractEntitiesFrame;
   import com.ankamagames.dofus.logic.game.common.frames.AllianceFrame;
   import com.ankamagames.dofus.logic.game.common.frames.ContextChangeFrame;
   import com.ankamagames.dofus.logic.game.common.frames.EmoticonFrame;
   import com.ankamagames.dofus.logic.game.common.frames.PartyManagementFrame;
   import com.ankamagames.dofus.logic.game.common.managers.ChatAutocompleteNameManager;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.roleplay.managers.AnimFunManager;
   import com.ankamagames.dofus.logic.game.roleplay.messages.CharacterMovementStoppedMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.DelayedActionMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.GameRolePlaySetAnimationMessage;
   import com.ankamagames.dofus.logic.game.roleplay.types.Fight;
   import com.ankamagames.dofus.logic.game.roleplay.types.FightTeam;
   import com.ankamagames.dofus.logic.game.roleplay.types.GameContextPaddockItemInformations;
   import com.ankamagames.dofus.logic.game.roleplay.types.GroundObject;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.InventoryHookList;
   import com.ankamagames.dofus.misc.lists.PrismHookList;
   import com.ankamagames.dofus.misc.lists.RoleplayHookList;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.misc.utils.EmbedAssets;
   import com.ankamagames.dofus.network.enums.AggressableStatusEnum;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.MapObstacleStateEnum;
   import com.ankamagames.dofus.network.enums.PlayerLifeStatusEnum;
   import com.ankamagames.dofus.network.enums.PrismStateEnum;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRefreshEntityLookMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRemoveElementMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapChangeOrientationMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapChangeOrientationsMessage;
   import com.ankamagames.dofus.network.messages.game.context.ShowCellMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightOptionStateUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightRemoveTeamMemberMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightUpdateTeamMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.GameDataPaddockObjectAddMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.GameDataPaddockObjectListAddMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.GameDataPaddockObjectRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.PaddockMoveItemRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.PaddockRemoveItemRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.GameRolePlayShowActorMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataInHavenBagMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataInHouseMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsWithCoordsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapFightCountMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapInformationsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayRemoveChallengeMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayShowChallengeMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HousePropertiesMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.MapNpcsQuestStatusUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundAddedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundListAddedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundRemovedMultipleMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.paddock.GameDataPlayFarmObjectAnimationMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveMapUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUsedMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.StatedMapUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.UpdateMapPlayersAgressableStatusMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.UpdateSelfAgressableStatusMessage;
   import com.ankamagames.dofus.network.types.game.context.ActorOrientation;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightCommonInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.AlternativeMonstersInGroupLightInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayHumanoidInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcWithQuestInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPortalInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GroupMonsterStaticInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GroupMonsterStaticInformationsWithAlternatives;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionAlliance;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionEmote;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionFollowers;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionObjectUse;
   import com.ankamagames.dofus.network.types.game.context.roleplay.HumanOptionSkillUse;
   import com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupLightInformations;
   import com.ankamagames.dofus.network.types.game.house.HouseInformations;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.interactive.MapObstacle;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.look.IndexedEntityLook;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockItem;
   import com.ankamagames.dofus.types.data.Follower;
   import com.ankamagames.dofus.types.entities.AnimStatiqueSubEntityBehavior;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.RoleplayObjectEntity;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.types.enums.EntityIconEnum;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.enum.OptionEnum;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.ASwf;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.display.TiphonAnimation;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.engine.Tiphon;
   import com.ankamagames.tiphon.engine.TiphonEventsManager;
   import com.ankamagames.tiphon.engine.TiphonMultiBonesManager;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   
   public class RoleplayEntitiesFrame extends AbstractEntitiesFrame implements Frame
   {
       
      
      private var _fights:Dictionary;
      
      private var _objects:Dictionary;
      
      private var _objectsByCellId:Dictionary;
      
      private var _paddockItem:Dictionary;
      
      private var _fightNumber:uint = 0;
      
      private var _timeout:Number;
      
      private var _loader:IResourceLoader;
      
      private var _currentPaddockItemCellId:uint;
      
      private var _currentEmoticon:uint = 0;
      
      private var _playersId:Array;
      
      private var _npcList:Dictionary;
      
      private var _housesList:Dictionary;
      
      private var _emoteTimesBySprite:Dictionary;
      
      private var _waitForMap:Boolean;
      
      private var _monstersIds:Vector.<Number>;
      
      private var _allianceFrame:AllianceFrame;
      
      private var _lastStaticAnimations:Dictionary;
      
      private var _waitingEmotesAnims:Dictionary;
      
      private var _auraCycleTimer:Timer;
      
      private var _auraCycleIndex:int;
      
      private var _lastEntityWithAura:AnimatedCharacter;
      
      private var _dispatchPlayerNewLook:Boolean;
      
      public function RoleplayEntitiesFrame()
      {
         this._lastStaticAnimations = new Dictionary();
         this._waitingEmotesAnims = new Dictionary();
         super();
      }
      
      public function get currentEmoticon() : uint
      {
         return this._currentEmoticon;
      }
      
      public function set currentEmoticon(param1:uint) : void
      {
         this._currentEmoticon = param1;
      }
      
      public function get dispatchPlayerNewLook() : Boolean
      {
         return this._dispatchPlayerNewLook;
      }
      
      public function set dispatchPlayerNewLook(param1:Boolean) : void
      {
         this._dispatchPlayerNewLook = param1;
      }
      
      public function get fightNumber() : uint
      {
         return this._fightNumber;
      }
      
      public function get currentSubAreaId() : uint
      {
         return _currentSubAreaId;
      }
      
      public function get playersId() : Array
      {
         return this._playersId;
      }
      
      public function get housesInformations() : Dictionary
      {
         return this._housesList;
      }
      
      public function get fights() : Dictionary
      {
         return this._fights;
      }
      
      public function get isCreatureMode() : Boolean
      {
         return _creaturesMode;
      }
      
      public function get monstersIds() : Vector.<Number>
      {
         return this._monstersIds;
      }
      
      public function get lastStaticAnimations() : Dictionary
      {
         return this._lastStaticAnimations;
      }
      
      override public function pushed() : Boolean
      {
         var _loc1_:ContextChangeFrame = null;
         var _loc2_:String = null;
         var _loc3_:MapInformationsRequestMessage = null;
         this.initNewMap();
         this._playersId = new Array();
         this._monstersIds = new Vector.<Number>();
         this._emoteTimesBySprite = new Dictionary();
         _entitiesVisibleNumber = 0;
         this._auraCycleIndex = 0;
         this._auraCycleTimer = new Timer(1800);
         if(OptionManager.getOptionManager("tiphon").auraMode == OptionEnum.AURA_CYCLE)
         {
            this._auraCycleTimer.addEventListener(TimerEvent.TIMER,this.onAuraCycleTimer);
            this._auraCycleTimer.start();
         }
         if(MapDisplayManager.getInstance().currentMapRendered)
         {
            _loc1_ = Kernel.getWorker().getFrame(ContextChangeFrame) as ContextChangeFrame;
            _loc2_ = "";
            if(_loc1_)
            {
               _loc2_ = _loc1_.mapChangeConnexion;
            }
            _loc3_ = new MapInformationsRequestMessage();
            _loc3_.initMapInformationsRequestMessage(MapDisplayManager.getInstance().currentMapPoint.mapId);
            ConnectionsHandler.getConnection().send(_loc3_,_loc2_);
         }
         else
         {
            this._waitForMap = true;
         }
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onGroundObjectLoaded);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onGroundObjectLoadFailed);
         _interactiveElements = new Vector.<InteractiveElement>();
         Dofus.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         Tiphon.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onTiphonPropertyChanged);
         this._allianceFrame = Kernel.getWorker().getFrame(AllianceFrame) as AllianceFrame;
         return super.pushed();
      }
      
      override public function process(param1:Message) : Boolean
      {
         var _loc2_:AnimatedCharacter = null;
         var _loc3_:MapComplementaryInformationsDataMessage = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:RoleplayContextFrame = null;
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Boolean = false;
         var _loc11_:FightCommonInformations = null;
         var _loc12_:Fight = null;
         var _loc13_:Array = null;
         var _loc14_:Dictionary = null;
         var _loc15_:HouseWrapper = null;
         var _loc16_:RoleplayInteractivesFrame = null;
         var _loc17_:InteractiveMapUpdateMessage = null;
         var _loc18_:StatedMapUpdateMessage = null;
         var _loc19_:HouseInformations = null;
         var _loc20_:GameRolePlayShowActorMessage = null;
         var _loc21_:GameContextRefreshEntityLookMessage = null;
         var _loc22_:GameMapChangeOrientationMessage = null;
         var _loc23_:GameMapChangeOrientationsMessage = null;
         var _loc24_:int = 0;
         var _loc25_:GameRolePlaySetAnimationMessage = null;
         var _loc26_:AnimatedCharacter = null;
         var _loc27_:EntityMovementCompleteMessage = null;
         var _loc28_:AnimatedCharacter = null;
         var _loc29_:EntityMovementStoppedMessage = null;
         var _loc30_:CharacterMovementStoppedMessage = null;
         var _loc31_:AnimatedCharacter = null;
         var _loc32_:GameRolePlayShowChallengeMessage = null;
         var _loc33_:GameFightOptionStateUpdateMessage = null;
         var _loc34_:GameFightUpdateTeamMessage = null;
         var _loc35_:GameFightRemoveTeamMemberMessage = null;
         var _loc36_:GameRolePlayRemoveChallengeMessage = null;
         var _loc37_:GameContextRemoveElementMessage = null;
         var _loc38_:uint = 0;
         var _loc39_:Number = NaN;
         var _loc40_:MapFightCountMessage = null;
         var _loc41_:UpdateMapPlayersAgressableStatusMessage = null;
         var _loc42_:int = 0;
         var _loc43_:int = 0;
         var _loc44_:GameRolePlayHumanoidInformations = null;
         var _loc45_:* = undefined;
         var _loc46_:UpdateSelfAgressableStatusMessage = null;
         var _loc47_:GameRolePlayHumanoidInformations = null;
         var _loc48_:* = undefined;
         var _loc49_:ObjectGroundAddedMessage = null;
         var _loc50_:ObjectGroundRemovedMessage = null;
         var _loc51_:ObjectGroundRemovedMultipleMessage = null;
         var _loc52_:ObjectGroundListAddedMessage = null;
         var _loc53_:uint = 0;
         var _loc54_:PaddockRemoveItemRequestAction = null;
         var _loc55_:PaddockRemoveItemRequestMessage = null;
         var _loc56_:PaddockMoveItemRequestAction = null;
         var _loc57_:Texture = null;
         var _loc58_:ItemWrapper = null;
         var _loc59_:GameDataPaddockObjectRemoveMessage = null;
         var _loc60_:GameDataPaddockObjectAddMessage = null;
         var _loc61_:GameDataPaddockObjectListAddMessage = null;
         var _loc62_:GameDataPlayFarmObjectAnimationMessage = null;
         var _loc63_:MapNpcsQuestStatusUpdateMessage = null;
         var _loc64_:ShowCellMessage = null;
         var _loc65_:RoleplayContextFrame = null;
         var _loc66_:String = null;
         var _loc67_:String = null;
         var _loc68_:StartZoomAction = null;
         var _loc69_:DisplayObject = null;
         var _loc70_:SwitchCreatureModeAction = null;
         var _loc71_:ContextChangeFrame = null;
         var _loc72_:String = null;
         var _loc73_:MapInformationsRequestMessage = null;
         var _loc74_:MapComplementaryInformationsWithCoordsMessage = null;
         var _loc75_:MapComplementaryInformationsDataInHouseMessage = null;
         var _loc76_:* = false;
         var _loc77_:SubArea = null;
         var _loc78_:GameRolePlayActorInformations = null;
         var _loc79_:GameRolePlayActorInformations = null;
         var _loc80_:AnimatedCharacter = null;
         var _loc81_:GameRolePlayCharacterInformations = null;
         var _loc82_:* = undefined;
         var _loc83_:DelayedActionMessage = null;
         var _loc84_:HumanOptionSkillUse = null;
         var _loc85_:uint = 0;
         var _loc86_:InteractiveUsedMessage = null;
         var _loc87_:Emoticon = null;
         var _loc88_:Boolean = false;
         var _loc89_:Date = null;
         var _loc90_:TiphonEntityLook = null;
         var _loc91_:GameRolePlaySetAnimationMessage = null;
         var _loc92_:int = 0;
         var _loc93_:* = undefined;
         var _loc94_:HouseInformations = null;
         var _loc95_:int = 0;
         var _loc96_:int = 0;
         var _loc97_:MapObstacle = null;
         var _loc98_:HumanInformations = null;
         var _loc99_:GameRolePlayHumanoidInformations = null;
         var _loc100_:GameRolePlayCharacterInformations = null;
         var _loc101_:int = 0;
         var _loc102_:ActorOrientation = null;
         var _loc103_:Emoticon = null;
         var _loc104_:EmoticonFrame = null;
         var _loc105_:uint = 0;
         var _loc106_:Emoticon = null;
         var _loc107_:EmotePlayRequestMessage = null;
         var _loc108_:Number = NaN;
         var _loc109_:uint = 0;
         var _loc110_:uint = 0;
         var _loc111_:PaddockItem = null;
         var _loc112_:uint = 0;
         var _loc113_:TiphonSprite = null;
         var _loc114_:Sprite = null;
         var _loc115_:int = 0;
         var _loc116_:int = 0;
         var _loc117_:Quest = null;
         var _loc118_:Rectangle = null;
         var _loc119_:* = undefined;
         var _loc120_:* = undefined;
         var _loc121_:FightTeam = null;
         switch(true)
         {
            case param1 is MapLoadedMessage:
               if(this._waitForMap)
               {
                  _loc71_ = Kernel.getWorker().getFrame(ContextChangeFrame) as ContextChangeFrame;
                  _loc72_ = "";
                  if(_loc71_)
                  {
                     _loc72_ = _loc71_.mapChangeConnexion;
                  }
                  _loc73_ = new MapInformationsRequestMessage();
                  _loc73_.initMapInformationsRequestMessage(MapDisplayManager.getInstance().currentMapPoint.mapId);
                  ConnectionsHandler.getConnection().send(_loc73_,_loc72_);
                  this._waitForMap = false;
               }
               return false;
            case param1 is MapComplementaryInformationsDataMessage:
               _loc3_ = param1 as MapComplementaryInformationsDataMessage;
               _loc4_ = false;
               _loc5_ = false;
               _interactiveElements = _loc3_.interactiveElements;
               this._fightNumber = _loc3_.fights.length;
               TooltipManager.hide();
               if(PlayedCharacterManager.getInstance().isInHouse && !(param1 is MapComplementaryInformationsDataInHouseMessage))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.HouseExit);
                  PlayedCharacterManager.getInstance().isInHouse = false;
                  PlayedCharacterManager.getInstance().isInHisHouse = false;
               }
               if(param1 is MapComplementaryInformationsWithCoordsMessage)
               {
                  _loc74_ = param1 as MapComplementaryInformationsWithCoordsMessage;
                  _worldPoint = new WorldPointWrapper(_loc74_.mapId,true,_loc74_.worldX,_loc74_.worldY);
               }
               else if(param1 is MapComplementaryInformationsDataInHouseMessage)
               {
                  _loc75_ = param1 as MapComplementaryInformationsDataInHouseMessage;
                  _loc76_ = PlayerManager.getInstance().nickname == _loc75_.currentHouse.ownerName;
                  PlayedCharacterManager.getInstance().isInHouse = true;
                  if(_loc76_)
                  {
                     PlayedCharacterManager.getInstance().isInHisHouse = true;
                  }
                  KernelEventsManager.getInstance().processCallback(HookList.HouseEntered,_loc76_,_loc75_.currentHouse.ownerId,_loc75_.currentHouse.ownerName,_loc75_.currentHouse.price,_loc75_.currentHouse.isLocked,_loc75_.currentHouse.worldX,_loc75_.currentHouse.worldY,HouseWrapper.manualCreate(_loc75_.currentHouse.modelId,-1,_loc75_.currentHouse.ownerName,_loc75_.currentHouse.price != 0));
                  _worldPoint = new WorldPointWrapper(_loc75_.mapId,true,_loc75_.currentHouse.worldX,_loc75_.currentHouse.worldY);
               }
               else
               {
                  _worldPoint = new WorldPointWrapper(_loc3_.mapId);
               }
               _loc6_ = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
               if(_loc6_.previousMapId != _worldPoint.mapId || PlayedCharacterManager.getInstance().currentMap.mapId != _worldPoint.mapId || PlayedCharacterManager.getInstance().currentMap.outdoorX != _worldPoint.outdoorX || PlayedCharacterManager.getInstance().currentMap.outdoorY != _worldPoint.outdoorY)
               {
                  _loc4_ = true;
                  PlayedCharacterManager.getInstance().currentMap = _worldPoint;
                  this.initNewMap();
               }
               if(param1 is MapComplementaryInformationsDataInHavenBagMessage)
               {
                  PlayedCharacterManager.getInstance().currentHavenbagTotalRooms = (param1 as MapComplementaryInformationsDataInHavenBagMessage).maxRoomId;
                  Kernel.getWorker().addFrame(new HavenbagFrame((param1 as MapComplementaryInformationsDataInHavenBagMessage).roomId,(param1 as MapComplementaryInformationsDataInHavenBagMessage).theme,(param1 as MapComplementaryInformationsDataInHavenBagMessage).ownerInformations));
               }
               else if(HavenbagTheme.isMapIdInHavenbag(_loc3_.mapId))
               {
                  Atouin.getInstance().showWorld(true);
               }
               if(_currentSubAreaId != _loc3_.subAreaId || !PlayedCharacterManager.getInstance().currentSubArea)
               {
                  _loc5_ = true;
                  _currentSubAreaId = _loc3_.subAreaId;
                  _loc77_ = SubArea.getSubAreaById(_currentSubAreaId);
                  PlayedCharacterManager.getInstance().currentSubArea = _loc77_;
               }
               this._playersId = new Array();
               this._monstersIds = new Vector.<Number>();
               for each(_loc78_ in _loc3_.actors)
               {
                  if(_loc78_.contextualId > 0)
                  {
                     this._playersId.push(_loc78_.contextualId);
                  }
                  else if(_loc78_ is GameRolePlayGroupMonsterInformations)
                  {
                     this._monstersIds.push(_loc78_.contextualId);
                  }
               }
               updateCreaturesLimit();
               _entitiesVisibleNumber = this._playersId.length + this._monstersIds.length;
               if(_creaturesLimit == 0 || _creaturesLimit < 50 && _entitiesVisibleNumber >= _creaturesLimit)
               {
                  _creaturesMode = true;
               }
               else
               {
                  _creaturesMode = false;
               }
               _loc7_ = true;
               _loc8_ = 0;
               _loc9_ = 0;
               for each(_loc79_ in _loc3_.actors)
               {
                  _loc80_ = this.addOrUpdateActor(_loc79_) as AnimatedCharacter;
                  if(_loc80_)
                  {
                     if(_loc80_.id == PlayedCharacterManager.getInstance().id)
                     {
                        if(_loc80_.libraryIsAvailable)
                        {
                           this.updateUsableEmotesListInit(_loc80_.look);
                        }
                        else
                        {
                           _loc80_.addEventListener(TiphonEvent.SPRITE_INIT,this.onPlayerSpriteInit);
                        }
                        if(this.dispatchPlayerNewLook)
                        {
                           KernelEventsManager.getInstance().processCallback(HookList.PlayedCharacterLookChange,_loc80_.look);
                           this.dispatchPlayerNewLook = false;
                        }
                     }
                     _loc81_ = _loc79_ as GameRolePlayCharacterInformations;
                     if(_loc81_)
                     {
                        _loc8_ = 0;
                        _loc9_ = 0;
                        for each(_loc82_ in _loc81_.humanoidInfo.options)
                        {
                           if(_loc82_ is HumanOptionEmote)
                           {
                              _loc8_ = _loc82_.emoteId;
                              _loc9_ = _loc82_.emoteStartTime;
                           }
                           else if(_loc82_ is HumanOptionObjectUse)
                           {
                              _loc83_ = new DelayedActionMessage(_loc81_.contextualId,_loc82_.objectGID,_loc82_.delayEndTime);
                              Kernel.getWorker().process(_loc83_);
                           }
                           else if(_loc82_ is HumanOptionSkillUse)
                           {
                              _loc84_ = _loc82_ as HumanOptionSkillUse;
                              _loc85_ = _loc84_.skillEndTime - TimeManager.getInstance().getUtcTimestamp();
                              _loc85_ = _loc85_ / 100;
                              if(_loc85_ > 0)
                              {
                                 _loc86_ = new InteractiveUsedMessage();
                                 _loc86_.initInteractiveUsedMessage(_loc81_.contextualId,_loc84_.elementId,_loc84_.skillId,_loc85_);
                                 Kernel.getWorker().process(_loc86_);
                              }
                           }
                        }
                        if(_loc8_ > 0)
                        {
                           _loc87_ = Emoticon.getEmoticonById(_loc8_);
                           if(_loc87_ && _loc87_.persistancy)
                           {
                              this._currentEmoticon = _loc87_.id;
                              if(!_loc87_.aura)
                              {
                                 _loc88_ = false;
                                 _loc89_ = new Date();
                                 if(_loc89_.getTime() - _loc9_ >= _loc87_.duration)
                                 {
                                    _loc88_ = true;
                                 }
                                 _loc90_ = EntityLookAdapter.fromNetwork(_loc81_.look);
                                 _loc91_ = new GameRolePlaySetAnimationMessage(_loc79_,_loc87_.getAnimName(_loc90_),_loc9_,!_loc87_.persistancy,_loc87_.eight_directions,_loc88_);
                                 if(_loc80_.rendered)
                                 {
                                    this.process(_loc91_);
                                 }
                                 else
                                 {
                                    if(_loc91_.playStaticOnly)
                                    {
                                       _loc80_.visible = false;
                                    }
                                    this._waitingEmotesAnims[_loc80_.id] = _loc91_;
                                    _loc80_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityReadyForEmote);
                                    _loc80_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityReadyForEmote);
                                 }
                              }
                           }
                        }
                     }
                  }
                  if(_loc7_)
                  {
                     if(_loc79_ is GameRolePlayGroupMonsterInformations)
                     {
                        _loc7_ = false;
                        KernelEventsManager.getInstance().processCallback(TriggerHookList.MapWithMonsters);
                     }
                  }
                  if(_loc79_ is GameRolePlayCharacterInformations)
                  {
                     ChatAutocompleteNameManager.getInstance().addEntry((_loc79_ as GameRolePlayCharacterInformations).name,0);
                  }
               }
               this.switchPokemonMode();
               _loc10_ = false;
               _loc13_ = new Array();
               for each(_loc11_ in _loc3_.fights)
               {
                  _loc10_ = false;
                  for each(_loc12_ in this._fights)
                  {
                     if(_loc11_.fightId == _loc12_.fightId)
                     {
                        _loc10_ = true;
                     }
                  }
                  if(!_loc10_)
                  {
                     this.addFight(_loc11_);
                  }
               }
               for each(_loc12_ in this._fights)
               {
                  _loc10_ = false;
                  for each(_loc11_ in _loc3_.fights)
                  {
                     if(_loc11_.fightId == _loc12_.fightId)
                     {
                        _loc10_ = true;
                     }
                  }
                  if(!_loc10_)
                  {
                     _loc13_.push(_loc12_.fightId);
                  }
               }
               for each(_loc92_ in _loc13_)
               {
                  delete this._fights[_loc92_];
               }
               _loc14_ = new Dictionary();
               for(_loc93_ in this._housesList)
               {
                  _loc14_[_loc93_] = this._housesList[_loc93_];
               }
               this._housesList = new Dictionary();
               for each(_loc94_ in _loc3_.houses)
               {
                  if(_loc14_[_loc94_.doorsOnMap[0]] && _loc14_[_loc94_.doorsOnMap[0]].houseId == _loc94_.houseId)
                  {
                     _loc15_ = _loc14_[_loc94_.doorsOnMap[0]];
                  }
                  else
                  {
                     _loc15_ = HouseWrapper.create(_loc94_);
                  }
                  _loc95_ = _loc94_.doorsOnMap.length;
                  _loc96_ = 0;
                  while(_loc96_ < _loc95_)
                  {
                     this._housesList[_loc94_.doorsOnMap[_loc96_]] = _loc15_;
                     _loc96_++;
                  }
               }
               _loc14_ = new Dictionary();
               if(_loc4_)
               {
                  for each(_loc97_ in _loc3_.obstacles)
                  {
                     InteractiveCellManager.getInstance().updateCell(_loc97_.obstacleCellId,_loc97_.state == MapObstacleStateEnum.OBSTACLE_OPENED);
                  }
               }
               _loc16_ = Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame;
               _loc17_ = new InteractiveMapUpdateMessage();
               _loc17_.initInteractiveMapUpdateMessage(_loc3_.interactiveElements);
               _loc16_.process(_loc17_);
               _loc18_ = new StatedMapUpdateMessage();
               _loc18_.initStatedMapUpdateMessage(_loc3_.statedElements);
               _loc16_.process(_loc18_);
               if(_loc4_ || _loc5_)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.MapComplementaryInformationsData,PlayedCharacterManager.getInstance().currentMap,_currentSubAreaId,Dofus.getInstance().options.mapCoordinates);
               }
               if(_loc4_ && OptionManager.getOptionManager("dofus")["allowAnimsFun"] == true)
               {
                  AnimFunManager.getInstance().initializeByMap(_loc3_.mapId);
               }
               if(Kernel.getWorker().contains(EntitiesTooltipsFrame))
               {
                  (Kernel.getWorker().getFrame(EntitiesTooltipsFrame) as EntitiesTooltipsFrame).update();
               }
               if(Kernel.getWorker().contains(InfoEntitiesFrame))
               {
                  (Kernel.getWorker().getFrame(InfoEntitiesFrame) as InfoEntitiesFrame).update();
               }
               if(_loc4_)
               {
                  SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_NEW_MAP);
               }
               return false;
            case param1 is HousePropertiesMessage:
               _loc19_ = (param1 as HousePropertiesMessage).properties;
               _loc15_ = HouseWrapper.create(_loc19_);
               _loc95_ = _loc19_.doorsOnMap.length;
               _loc96_ = 0;
               while(_loc96_ < _loc95_)
               {
                  this._housesList[_loc19_.doorsOnMap[_loc96_]] = _loc15_;
                  _loc96_++;
               }
               KernelEventsManager.getInstance().processCallback(HookList.HouseProperties,_loc19_.houseId,_loc19_.doorsOnMap,_loc19_.ownerName,_loc19_.isOnSale,_loc19_.modelId);
               return true;
            case param1 is GameRolePlayShowActorMessage:
               _loc20_ = param1 as GameRolePlayShowActorMessage;
               if(_loc20_.informations.contextualId == PlayedCharacterManager.getInstance().id)
               {
                  _loc98_ = (_loc20_.informations as GameRolePlayHumanoidInformations).humanoidInfo as HumanInformations;
                  PlayedCharacterManager.getInstance().restrictions = _loc98_.restrictions;
                  _loc99_ = getEntityInfos(PlayedCharacterManager.getInstance().id) as GameRolePlayHumanoidInformations;
                  if(_loc99_)
                  {
                     _loc99_.humanoidInfo.restrictions = PlayedCharacterManager.getInstance().restrictions;
                  }
               }
               _loc2_ = DofusEntities.getEntity(_loc20_.informations.contextualId) as AnimatedCharacter;
               if(_loc2_ && _loc2_.getAnimation().indexOf(AnimationEnum.ANIM_STATIQUE) == -1)
               {
                  _loc2_.visibleAura = false;
               }
               if(!_loc2_)
               {
                  updateCreaturesLimit();
               }
               _loc2_ = this.addOrUpdateActor(_loc20_.informations);
               if(_loc2_ && _loc20_.informations.contextualId == PlayedCharacterManager.getInstance().id)
               {
                  if(_loc2_.libraryIsAvailable)
                  {
                     this.updateUsableEmotesListInit(_loc2_.look);
                  }
                  else
                  {
                     _loc2_.addEventListener(TiphonEvent.SPRITE_INIT,this.onPlayerSpriteInit);
                  }
               }
               if(this.switchPokemonMode())
               {
                  return true;
               }
               if(_loc20_.informations is GameRolePlayCharacterInformations)
               {
                  ChatAutocompleteNameManager.getInstance().addEntry((_loc20_.informations as GameRolePlayCharacterInformations).name,0);
               }
               if(_loc20_.informations is GameRolePlayCharacterInformations && PlayedCharacterManager.getInstance().characteristics.alignmentInfos.aggressable == AggressableStatusEnum.PvP_ENABLED_AGGRESSABLE)
               {
                  _loc100_ = _loc20_.informations as GameRolePlayCharacterInformations;
                  switch(PlayedCharacterManager.getInstance().levelDiff(int(_loc100_.alignmentInfos.characterPower - _loc20_.informations.contextualId)))
                  {
                     case -1:
                        SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_NEW_ENEMY_WEAK);
                        break;
                     case 1:
                        SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_NEW_ENEMY_STRONG);
                  }
               }
               if(OptionManager.getOptionManager("dofus")["allowAnimsFun"] == true && _loc20_.informations is GameRolePlayGroupMonsterInformations)
               {
                  AnimFunManager.getInstance().restart();
               }
               return true;
            case param1 is GameContextRefreshEntityLookMessage:
               _loc21_ = param1 as GameContextRefreshEntityLookMessage;
               _loc2_ = this.updateActorLook(_loc21_.id,_loc21_.look,true);
               if(_loc2_ && _loc21_.id == PlayedCharacterManager.getInstance().id)
               {
                  if(_loc2_.libraryIsAvailable)
                  {
                     this.updateUsableEmotesListInit(_loc2_.look);
                  }
                  else
                  {
                     _loc2_.addEventListener(TiphonEvent.SPRITE_INIT,this.onPlayerSpriteInit);
                  }
               }
               return true;
            case param1 is GameMapChangeOrientationMessage:
               _loc22_ = param1 as GameMapChangeOrientationMessage;
               updateActorOrientation(_loc22_.orientation.id,_loc22_.orientation.direction);
               return true;
            case param1 is GameMapChangeOrientationsMessage:
               _loc23_ = param1 as GameMapChangeOrientationsMessage;
               _loc24_ = _loc23_.orientations.length;
               _loc101_ = 0;
               while(_loc101_ < _loc24_)
               {
                  _loc102_ = _loc23_.orientations[_loc101_];
                  updateActorOrientation(_loc102_.id,_loc102_.direction);
                  _loc101_++;
               }
               return true;
            case param1 is GameRolePlaySetAnimationMessage:
               _loc25_ = param1 as GameRolePlaySetAnimationMessage;
               _loc26_ = DofusEntities.getEntity(_loc25_.informations.contextualId) as AnimatedCharacter;
               if(!_loc26_)
               {
                  _log.error("GameRolePlaySetAnimationMessage : l\'entitée " + _loc25_.informations.contextualId + " n\'a pas ete trouvee");
                  return true;
               }
               this.playAnimationOnEntity(_loc26_,_loc25_.animation,_loc25_.directions8,_loc25_.duration,_loc25_.playStaticOnly);
               return true;
            case param1 is EntityMovementCompleteMessage:
               _loc27_ = param1 as EntityMovementCompleteMessage;
               _loc28_ = _loc27_.entity as AnimatedCharacter;
               if(_entities[_loc28_.getRootEntity().id])
               {
                  (_entities[_loc28_.getRootEntity().id] as GameContextActorInformations).disposition.cellId = _loc28_.position.cellId;
               }
               if(_entitiesIcons[_loc27_.entity.id])
               {
                  _entitiesIcons[_loc27_.entity.id].needUpdate = true;
               }
               return false;
            case param1 is EntityMovementStoppedMessage:
               _loc29_ = param1 as EntityMovementStoppedMessage;
               if(_entitiesIcons[_loc29_.entity.id])
               {
                  _entitiesIcons[_loc29_.entity.id].needUpdate = true;
               }
               return false;
            case param1 is CharacterMovementStoppedMessage:
               _loc30_ = param1 as CharacterMovementStoppedMessage;
               _loc31_ = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as AnimatedCharacter;
               if(OptionManager.getOptionManager("tiphon").auraMode > OptionEnum.AURA_NONE && OptionManager.getOptionManager("tiphon").alwaysShowAuraOnFront && _loc31_.getDirection() == DirectionsEnum.DOWN && _loc31_.getAnimation().indexOf(AnimationEnum.ANIM_STATIQUE) != -1 && PlayedCharacterManager.getInstance().state == PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING)
               {
                  _loc104_ = Kernel.getWorker().getFrame(EmoticonFrame) as EmoticonFrame;
                  for each(_loc105_ in _loc104_.emotes)
                  {
                     _loc106_ = Emoticon.getEmoticonById(_loc105_);
                     if(_loc106_ && _loc106_.aura)
                     {
                        if(!_loc103_ || _loc106_.weight > _loc103_.weight)
                        {
                           _loc103_ = _loc106_;
                        }
                     }
                  }
                  if(_loc103_)
                  {
                     _loc107_ = new EmotePlayRequestMessage();
                     _loc107_.initEmotePlayRequestMessage(_loc103_.id);
                     ConnectionsHandler.getConnection().send(_loc107_);
                  }
               }
               return true;
            case param1 is GameRolePlayShowChallengeMessage:
               _loc32_ = param1 as GameRolePlayShowChallengeMessage;
               this.addFight(_loc32_.commonsInfos);
               return true;
            case param1 is GameFightOptionStateUpdateMessage:
               _loc33_ = param1 as GameFightOptionStateUpdateMessage;
               this.updateSwordOptions(_loc33_.fightId,_loc33_.teamId,_loc33_.option,_loc33_.state);
               KernelEventsManager.getInstance().processCallback(HookList.GameFightOptionStateUpdate,_loc33_.fightId,_loc33_.teamId,_loc33_.option,_loc33_.state);
               return true;
            case param1 is GameFightUpdateTeamMessage:
               _loc34_ = param1 as GameFightUpdateTeamMessage;
               this.updateFight(_loc34_.fightId,_loc34_.team);
               return true;
            case param1 is GameFightRemoveTeamMemberMessage:
               _loc35_ = param1 as GameFightRemoveTeamMemberMessage;
               this.removeFighter(_loc35_.fightId,_loc35_.teamId,_loc35_.charId);
               return true;
            case param1 is GameRolePlayRemoveChallengeMessage:
               _loc36_ = param1 as GameRolePlayRemoveChallengeMessage;
               KernelEventsManager.getInstance().processCallback(HookList.GameRolePlayRemoveFight,_loc36_.fightId);
               this.removeFight(_loc36_.fightId);
               return true;
            case param1 is GameContextRemoveElementMessage:
               _loc37_ = param1 as GameContextRemoveElementMessage;
               delete this._lastStaticAnimations[_loc37_.id];
               _loc38_ = 0;
               for each(_loc108_ in this._playersId)
               {
                  if(_loc108_ == _loc37_.id)
                  {
                     this._playersId.splice(_loc38_,1);
                  }
                  else
                  {
                     _loc38_++;
                  }
               }
               _loc39_ = this._monstersIds.indexOf(_loc37_.id);
               if(_loc39_ != -1)
               {
                  this._monstersIds.splice(_loc39_,1);
               }
               if(_entitiesIconsNames[_loc37_.id])
               {
                  delete _entitiesIconsNames[_loc37_.id];
               }
               if(_entitiesIcons[_loc37_.id])
               {
                  removeIcon(_loc37_.id);
               }
               delete this._waitingEmotesAnims[_loc37_.id];
               this.removeEntityListeners(_loc37_.id);
               removeActor(_loc37_.id);
               if(OptionManager.getOptionManager("dofus")["allowAnimsFun"] == true && _loc39_ != -1)
               {
                  AnimFunManager.getInstance().restart();
               }
               return true;
            case param1 is MapFightCountMessage:
               _loc40_ = param1 as MapFightCountMessage;
               KernelEventsManager.getInstance().processCallback(HookList.MapFightCount,_loc40_.fightCount);
               return true;
            case param1 is UpdateMapPlayersAgressableStatusMessage:
               _loc41_ = param1 as UpdateMapPlayersAgressableStatusMessage;
               _loc43_ = _loc41_.playerIds.length;
               _loc42_ = 0;
               while(_loc42_ < _loc43_)
               {
                  _loc44_ = getEntityInfos(_loc41_.playerIds[_loc42_]) as GameRolePlayHumanoidInformations;
                  if(_loc44_)
                  {
                     for each(_loc45_ in _loc44_.humanoidInfo.options)
                     {
                        if(_loc45_ is HumanOptionAlliance)
                        {
                           (_loc45_ as HumanOptionAlliance).aggressable = _loc41_.enable[_loc42_];
                           break;
                        }
                     }
                  }
                  if(_loc41_.playerIds[_loc42_] == PlayedCharacterManager.getInstance().id)
                  {
                     PlayedCharacterManager.getInstance().characteristics.alignmentInfos.aggressable = _loc41_.enable[_loc42_];
                     KernelEventsManager.getInstance().processCallback(PrismHookList.PvpAvaStateChange,_loc41_.enable[_loc42_],0);
                  }
                  _loc42_++;
               }
               this.updateConquestIcons(_loc41_.playerIds);
               return true;
            case param1 is UpdateSelfAgressableStatusMessage:
               _loc46_ = param1 as UpdateSelfAgressableStatusMessage;
               _loc47_ = getEntityInfos(PlayedCharacterManager.getInstance().id) as GameRolePlayHumanoidInformations;
               if(_loc47_)
               {
                  for each(_loc48_ in _loc47_.humanoidInfo.options)
                  {
                     if(_loc48_ is HumanOptionAlliance)
                     {
                        (_loc48_ as HumanOptionAlliance).aggressable = _loc46_.status;
                        break;
                     }
                  }
               }
               if(PlayedCharacterManager.getInstance().characteristics)
               {
                  PlayedCharacterManager.getInstance().characteristics.alignmentInfos.aggressable = _loc46_.status;
               }
               KernelEventsManager.getInstance().processCallback(PrismHookList.PvpAvaStateChange,_loc46_.status,_loc46_.probationTime);
               this.updateConquestIcons(PlayedCharacterManager.getInstance().id);
               return true;
            case param1 is ObjectGroundAddedMessage:
               _loc49_ = param1 as ObjectGroundAddedMessage;
               this.addObject(_loc49_.objectGID,_loc49_.cellId);
               return true;
            case param1 is ObjectGroundRemovedMessage:
               _loc50_ = param1 as ObjectGroundRemovedMessage;
               this.removeObject(_loc50_.cell);
               return true;
            case param1 is ObjectGroundRemovedMultipleMessage:
               _loc51_ = param1 as ObjectGroundRemovedMultipleMessage;
               for each(_loc109_ in _loc51_.cells)
               {
                  this.removeObject(_loc109_);
               }
               return true;
            case param1 is ObjectGroundListAddedMessage:
               _loc52_ = param1 as ObjectGroundListAddedMessage;
               _loc53_ = 0;
               for each(_loc110_ in _loc52_.referenceIds)
               {
                  this.addObject(_loc110_,_loc52_.cells[_loc53_]);
                  _loc53_++;
               }
               return true;
            case param1 is PaddockRemoveItemRequestAction:
               _loc54_ = param1 as PaddockRemoveItemRequestAction;
               _loc55_ = new PaddockRemoveItemRequestMessage();
               _loc55_.initPaddockRemoveItemRequestMessage(_loc54_.cellId);
               ConnectionsHandler.getConnection().send(_loc55_);
               return true;
            case param1 is PaddockMoveItemRequestAction:
               _loc56_ = param1 as PaddockMoveItemRequestAction;
               this._currentPaddockItemCellId = _loc56_.object.disposition.cellId;
               _loc57_ = new Texture();
               _loc58_ = ItemWrapper.create(0,0,_loc56_.object.item.id,0,null,false);
               _loc57_.uri = _loc58_.iconUri;
               _loc57_.finalize();
               Kernel.getWorker().addFrame(new RoleplayPointCellFrame(this.onCellPointed,_loc57_,true,this.paddockCellValidator,true));
               return true;
            case param1 is GameDataPaddockObjectRemoveMessage:
               _loc59_ = param1 as GameDataPaddockObjectRemoveMessage;
               this.removePaddockItem(_loc59_.cellId);
               return true;
            case param1 is GameDataPaddockObjectAddMessage:
               _loc60_ = param1 as GameDataPaddockObjectAddMessage;
               this.addPaddockItem(_loc60_.paddockItemDescription);
               return true;
            case param1 is GameDataPaddockObjectListAddMessage:
               _loc61_ = param1 as GameDataPaddockObjectListAddMessage;
               for each(_loc111_ in _loc61_.paddockItemDescription)
               {
                  this.addPaddockItem(_loc111_);
               }
               return true;
            case param1 is GameDataPlayFarmObjectAnimationMessage:
               _loc62_ = param1 as GameDataPlayFarmObjectAnimationMessage;
               for each(_loc112_ in _loc62_.cellId)
               {
                  this.activatePaddockItem(_loc112_);
               }
               return true;
            case param1 is MapNpcsQuestStatusUpdateMessage:
               _loc63_ = param1 as MapNpcsQuestStatusUpdateMessage;
               if(MapDisplayManager.getInstance().currentMapPoint.mapId == _loc63_.mapId)
               {
                  for each(_loc113_ in this._npcList)
                  {
                     this.removeBackground(_loc113_);
                  }
                  _loc116_ = _loc63_.npcsIdsWithQuest.length;
                  _loc115_ = 0;
                  while(_loc115_ < _loc116_)
                  {
                     _loc113_ = this._npcList[_loc63_.npcsIdsWithQuest[_loc115_]];
                     if(_loc113_)
                     {
                        _loc117_ = Quest.getFirstValidQuest(_loc63_.questFlags[_loc115_]);
                        if(_loc117_ != null)
                        {
                           if(_loc63_.questFlags[_loc115_].questsToStartId.indexOf(_loc117_.id) != -1)
                           {
                              if(_loc117_.repeatType == 0)
                              {
                                 _loc114_ = EmbedAssets.getSprite("QUEST_CLIP");
                                 _loc113_.addBackground("questClip",_loc114_,true);
                              }
                              else
                              {
                                 _loc114_ = EmbedAssets.getSprite("QUEST_REPEATABLE_CLIP");
                                 _loc113_.addBackground("questRepeatableClip",_loc114_,true);
                              }
                           }
                           else if(_loc117_.repeatType == 0)
                           {
                              _loc114_ = EmbedAssets.getSprite("QUEST_OBJECTIVE_CLIP");
                              _loc113_.addBackground("questObjectiveClip",_loc114_,true);
                           }
                           else
                           {
                              _loc114_ = EmbedAssets.getSprite("QUEST_REPEATABLE_OBJECTIVE_CLIP");
                              _loc113_.addBackground("questRepeatableObjectiveClip",_loc114_,true);
                           }
                        }
                     }
                     _loc115_++;
                  }
               }
               return true;
            case param1 is ShowCellMessage:
               _loc64_ = param1 as ShowCellMessage;
               HyperlinkShowCellManager.showCell(_loc64_.cellId);
               _loc65_ = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
               _loc66_ = _loc65_.getActorName(_loc64_.sourceId);
               _loc67_ = I18n.getUiText("ui.fight.showCell",[_loc66_,"{cell," + _loc64_.cellId + "::" + _loc64_.cellId + "}"]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc67_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is StartZoomAction:
               _loc68_ = param1 as StartZoomAction;
               if(Atouin.getInstance().currentZoom != 1)
               {
                  Atouin.getInstance().cancelZoom();
                  KernelEventsManager.getInstance().processCallback(HookList.StartZoom,false);
                  updateAllIcons();
                  return true;
               }
               _loc69_ = DofusEntities.getEntity(_loc68_.playerId) as DisplayObject;
               if(_loc69_ && _loc69_.stage)
               {
                  _loc118_ = _loc69_.getRect(Atouin.getInstance().worldContainer);
                  Atouin.getInstance().zoom(_loc68_.value,_loc118_.x + _loc118_.width / 2,_loc118_.y + _loc118_.height / 2);
                  KernelEventsManager.getInstance().processCallback(HookList.StartZoom,true);
                  updateAllIcons();
               }
               return true;
            case param1 is SwitchCreatureModeAction:
               _loc70_ = param1 as SwitchCreatureModeAction;
               if(_creaturesMode != _loc70_.isActivated)
               {
                  _creaturesMode = _loc70_.isActivated;
                  for(_loc119_ in _entities)
                  {
                     this.updateActorLook(_loc119_,(_entities[_loc119_] as GameContextActorInformations).look);
                  }
               }
               return true;
            case param1 is MapZoomMessage:
               for each(_loc120_ in _entities)
               {
                  _loc121_ = _loc120_ as FightTeam;
                  if(_loc121_ && _loc121_.fight && _loc121_.teamInfos)
                  {
                     this.updateSwordOptions(_loc121_.fight.fightId,_loc121_.teamInfos.teamId);
                  }
               }
               return true;
            default:
               return false;
         }
      }
      
      private function playAnimationOnEntity(param1:AnimatedCharacter, param2:String, param3:Boolean, param4:uint, param5:Boolean) : void
      {
         var _loc6_:Follower = null;
         var _loc7_:TiphonSprite = null;
         if(param2 == AnimationEnum.ANIM_STATIQUE)
         {
            this._currentEmoticon = 0;
            param1.setAnimation(param2);
            this._emoteTimesBySprite[param1.name] = 0;
         }
         else
         {
            if(!param3)
            {
               if(param1.getDirection() % 2 == 0)
               {
                  param1.setDirection(param1.getDirection() + 1);
               }
            }
            if(_creaturesMode || !param1.hasAnimation(param2,param1.getDirection()))
            {
               _log.error("L\'animation " + param2 + "_" + param1.getDirection() + " est introuvable.");
               param1.visible = true;
            }
            else if(!_creaturesMode)
            {
               this._emoteTimesBySprite[param1.name] = param4;
               param1.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
               param1.addEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
               _loc7_ = param1.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite;
               if(_loc7_)
               {
                  _loc7_.removeEventListener(TiphonEvent.ANIMATION_ADDED,this.onAnimationAdded);
                  _loc7_.addEventListener(TiphonEvent.ANIMATION_ADDED,this.onAnimationAdded);
               }
               param1.setAnimation(param2);
               if(param5)
               {
                  if(param1.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET) && param1.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET).length)
                  {
                     param1.setSubEntityBehaviour(1,new AnimStatiqueSubEntityBehavior());
                  }
                  param1.stopAnimationAtLastFrame();
                  if(_loc7_)
                  {
                     _loc7_.stopAnimationAtLastFrame();
                  }
               }
            }
         }
         for each(_loc6_ in param1.followers)
         {
            if(_loc6_.type == Follower.TYPE_PET && _loc6_.entity is AnimatedCharacter)
            {
               this.playAnimationOnEntity(_loc6_.entity as AnimatedCharacter,param2,param3,param4,param5);
            }
         }
      }
      
      private function initNewMap() : void
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this._objectsByCellId)
         {
            (_loc1_ as IDisplayable).remove();
         }
         this._npcList = new Dictionary();
         this._fights = new Dictionary();
         this._objects = new Dictionary();
         this._objectsByCellId = new Dictionary();
         this._paddockItem = new Dictionary();
      }
      
      override protected function switchPokemonMode() : Boolean
      {
         if(super.switchPokemonMode())
         {
            KernelEventsManager.getInstance().processCallback(TriggerHookList.CreaturesMode);
            return true;
         }
         return false;
      }
      
      override public function pulled() : Boolean
      {
         var _loc1_:Fight = null;
         var _loc2_:* = undefined;
         var _loc3_:AnimatedCharacter = null;
         var _loc4_:FightTeam = null;
         if(Kernel.getWorker().contains(HavenbagFrame))
         {
            Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(HavenbagFrame));
         }
         for each(_loc1_ in this._fights)
         {
            for each(_loc4_ in _loc1_.teams)
            {
               (_loc4_.teamEntity as TiphonSprite).removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onFightEntityRendered);
               TooltipManager.hide("fightOptions_" + _loc1_.fightId + "_" + _loc4_.teamInfos.teamId);
            }
         }
         if(this._loader)
         {
            this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onGroundObjectLoaded);
            this._loader.removeEventListener(ResourceErrorEvent.ERROR,this.onGroundObjectLoadFailed);
            this._loader = null;
         }
         if(OptionManager.getOptionManager("dofus")["allowAnimsFun"] == true)
         {
            AnimFunManager.getInstance().stop();
         }
         this._fights = null;
         this._objects = null;
         this._npcList = null;
         this._objectsByCellId = null;
         this._paddockItem = null;
         this._housesList = null;
         Dofus.getInstance().options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         Tiphon.getInstance().options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onTiphonPropertyChanged);
         removeAllIcons();
         if(OptionManager.getOptionManager("tiphon").auraMode == OptionEnum.AURA_CYCLE)
         {
            this._auraCycleTimer.removeEventListener(TimerEvent.TIMER,this.onAuraCycleTimer);
            this._auraCycleTimer.stop();
         }
         this._auraCycleTimer = null;
         this._lastEntityWithAura = null;
         for(_loc2_ in _entities)
         {
            _loc3_ = EntitiesManager.getInstance().getEntity(_loc2_) as AnimatedCharacter;
            if(_loc3_)
            {
               _loc3_.removeEventListener(TiphonEvent.SPRITE_INIT,this.onPlayerSpriteInit);
            }
         }
         return super.pulled();
      }
      
      public function isFight(param1:Number) : Boolean
      {
         if(!_entities)
         {
            return false;
         }
         return _entities[param1] is FightTeam;
      }
      
      public function isPaddockItem(param1:Number) : Boolean
      {
         return _entities[param1] is GameContextPaddockItemInformations;
      }
      
      public function getFightTeam(param1:Number) : FightTeam
      {
         return _entities[param1] as FightTeam;
      }
      
      public function getFightId(param1:Number) : uint
      {
         return (_entities[param1] as FightTeam).fight.fightId;
      }
      
      public function getFightLeaderId(param1:Number) : Number
      {
         return (_entities[param1] as FightTeam).teamInfos.leaderId;
      }
      
      public function getFightTeamType(param1:Number) : uint
      {
         return (_entities[param1] as FightTeam).teamType;
      }
      
      public function updateMonstersGroups() : void
      {
         var _loc2_:GameContextActorInformations = null;
         var _loc1_:Dictionary = getEntitiesDictionnary();
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_ is GameRolePlayGroupMonsterInformations)
            {
               this.updateMonstersGroup(_loc2_ as GameRolePlayGroupMonsterInformations);
            }
         }
      }
      
      private function updateMonstersGroup(param1:GameRolePlayGroupMonsterInformations) : void
      {
         var _loc3_:MonsterInGroupLightInformations = null;
         var _loc5_:uint = 0;
         var _loc6_:MonsterInGroupLightInformations = null;
         var _loc7_:Monster = null;
         var _loc8_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:Vector.<MonsterInGroupLightInformations> = this.getMonsterGroup(param1.staticInfos);
         var _loc4_:Boolean = Monster.getMonsterById(param1.staticInfos.mainCreatureLightInfos.creatureGenericId).isMiniBoss;
         if(_loc2_)
         {
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.creatureGenericId == param1.staticInfos.mainCreatureLightInfos.creatureGenericId)
               {
                  _loc2_.splice(_loc2_.indexOf(_loc3_),1);
                  break;
               }
            }
         }
         var _loc9_:Vector.<EntityLook> = null;
         var _loc10_:Vector.<Number> = null;
         if(Dofus.getInstance().options.showEveryMonsters)
         {
            if(_loc2_)
            {
               _loc11_ = _loc2_.length;
            }
            else
            {
               _loc11_ = param1.staticInfos.underlings.length;
            }
            _loc9_ = new Vector.<EntityLook>(_loc11_,true);
            _loc10_ = new Vector.<Number>(_loc9_.length,true);
         }
         for each(_loc6_ in param1.staticInfos.underlings)
         {
            if(_loc9_)
            {
               _loc7_ = Monster.getMonsterById(_loc6_.creatureGenericId);
               _loc8_ = -1;
               if(!_loc2_)
               {
                  _loc8_ = 0;
               }
               else
               {
                  for each(_loc3_ in _loc2_)
                  {
                     if(_loc3_.creatureGenericId == _loc6_.creatureGenericId)
                     {
                        _loc2_.splice(_loc2_.indexOf(_loc3_),1);
                        _loc8_ = _loc3_.grade;
                        break;
                     }
                  }
               }
               if(_loc8_ >= 0)
               {
                  _loc10_[_loc5_] = _loc7_.speedAdjust;
                  _loc9_[_loc5_] = EntityLookAdapter.toNetwork(TiphonEntityLook.fromString(_loc7_.look));
                  _loc5_++;
               }
            }
            if(!_loc4_ && Monster.getMonsterById(_loc6_.creatureGenericId).isMiniBoss)
            {
               _loc4_ = true;
               if(!_loc9_)
               {
                  break;
               }
            }
         }
         if(_loc9_)
         {
            this.manageFollowers(DofusEntities.getEntity(param1.contextualId) as AnimatedCharacter,_loc9_,_loc10_,null,true);
         }
      }
      
      private function getMonsterGroup(param1:GroupMonsterStaticInformations) : Vector.<MonsterInGroupLightInformations>
      {
         var _loc2_:Vector.<MonsterInGroupLightInformations> = null;
         var _loc4_:PartyManagementFrame = null;
         var _loc5_:Vector.<PartyMemberWrapper> = null;
         var _loc6_:int = 0;
         var _loc7_:AlternativeMonstersInGroupLightInformations = null;
         var _loc8_:PartyMemberWrapper = null;
         var _loc3_:GroupMonsterStaticInformationsWithAlternatives = param1 as GroupMonsterStaticInformationsWithAlternatives;
         if(_loc3_)
         {
            _loc4_ = Kernel.getWorker().getFrame(PartyManagementFrame) as PartyManagementFrame;
            _loc5_ = _loc4_.partyMembers;
            _loc6_ = _loc5_.length;
            if(_loc6_ == 0 && PlayedCharacterManager.getInstance().hasCompanion)
            {
               _loc6_ = 2;
            }
            else
            {
               for each(_loc8_ in _loc5_)
               {
                  _loc6_ = _loc6_ + _loc8_.companions.length;
               }
            }
            for each(_loc7_ in _loc3_.alternatives)
            {
               if(!_loc2_ || _loc7_.playerCount <= _loc6_)
               {
                  _loc2_ = _loc7_.monsters;
               }
            }
         }
         return !!_loc2_?_loc2_.concat():null;
      }
      
      override public function addOrUpdateActor(param1:GameContextActorInformations, param2:IAnimationModifier = null) : AnimatedCharacter
      {
         var _loc3_:AnimatedCharacter = null;
         var _loc4_:Sprite = null;
         var _loc5_:Quest = null;
         var _loc6_:GameRolePlayGroupMonsterInformations = null;
         var _loc7_:Boolean = false;
         var _loc8_:Vector.<EntityLook> = null;
         var _loc9_:Vector.<uint> = null;
         var _loc10_:Array = null;
         var _loc11_:MonsterInGroupInformations = null;
         var _loc12_:* = undefined;
         var _loc13_:Array = null;
         var _loc14_:IndexedEntityLook = null;
         var _loc15_:IndexedEntityLook = null;
         var _loc16_:TiphonEntityLook = null;
         var _loc17_:MapPosition = null;
         _loc3_ = super.addOrUpdateActor(param1);
         switch(true)
         {
            case param1 is GameRolePlayNpcWithQuestInformations:
               this._npcList[param1.contextualId] = _loc3_;
               _loc5_ = Quest.getFirstValidQuest((param1 as GameRolePlayNpcWithQuestInformations).questFlag);
               this.removeBackground(_loc3_);
               if(_loc5_ != null)
               {
                  if((param1 as GameRolePlayNpcWithQuestInformations).questFlag.questsToStartId.indexOf(_loc5_.id) != -1)
                  {
                     if(_loc5_.repeatType == 0)
                     {
                        _loc4_ = EmbedAssets.getSprite("QUEST_CLIP");
                        _loc3_.addBackground("questClip",_loc4_,true);
                     }
                     else
                     {
                        _loc4_ = EmbedAssets.getSprite("QUEST_REPEATABLE_CLIP");
                        _loc3_.addBackground("questRepeatableClip",_loc4_,true);
                     }
                  }
                  else if(_loc5_.repeatType == 0)
                  {
                     _loc4_ = EmbedAssets.getSprite("QUEST_OBJECTIVE_CLIP");
                     _loc3_.addBackground("questObjectiveClip",_loc4_,true);
                  }
                  else
                  {
                     _loc4_ = EmbedAssets.getSprite("QUEST_REPEATABLE_OBJECTIVE_CLIP");
                     _loc3_.addBackground("questRepeatableObjectiveClip",_loc4_,true);
                  }
               }
               if(_loc3_.look.getBone() == 1)
               {
                  _loc3_.addAnimationModifier(_customBreedAnimationModifier);
               }
               if(_creaturesMode || _loc3_.getAnimation() == AnimationEnum.ANIM_STATIQUE)
               {
                  _loc3_.setAnimation(AnimationEnum.ANIM_STATIQUE);
               }
               break;
            case param1 is GameRolePlayGroupMonsterInformations:
               _loc6_ = param1 as GameRolePlayGroupMonsterInformations;
               _loc7_ = Monster.getMonsterById(_loc6_.staticInfos.mainCreatureLightInfos.creatureGenericId).isMiniBoss;
               if(!_loc7_ && _loc6_.staticInfos.underlings && _loc6_.staticInfos.underlings.length > 0)
               {
                  for each(_loc11_ in _loc6_.staticInfos.underlings)
                  {
                     _loc7_ = Monster.getMonsterById(_loc11_.creatureGenericId).isMiniBoss;
                     if(_loc7_)
                     {
                        break;
                     }
                  }
               }
               this.updateMonstersGroup(_loc6_);
               if(this._monstersIds.indexOf(param1.contextualId) == -1)
               {
                  this._monstersIds.push(param1.contextualId);
               }
               if(Kernel.getWorker().contains(EntitiesTooltipsFrame))
               {
                  (Kernel.getWorker().getFrame(EntitiesTooltipsFrame) as EntitiesTooltipsFrame).update();
               }
               if(PlayerManager.getInstance().serverGameType != 0 && _loc6_.hasHardcoreDrop)
               {
                  addEntityIcon(_loc6_.contextualId,"treasure");
               }
               if(_loc7_)
               {
                  addEntityIcon(_loc6_.contextualId,"archmonsters");
               }
               if(_loc6_.hasAVARewardToken)
               {
                  addEntityIcon(_loc6_.contextualId,"nugget");
               }
               break;
            case param1 is GameRolePlayHumanoidInformations:
               if(param1.contextualId > 0 && this._playersId && this._playersId.indexOf(param1.contextualId) == -1)
               {
                  this._playersId.push(param1.contextualId);
               }
               _loc8_ = new Vector.<EntityLook>();
               _loc9_ = new Vector.<uint>();
               for each(_loc12_ in (param1 as GameRolePlayHumanoidInformations).humanoidInfo.options)
               {
                  switch(true)
                  {
                     case _loc12_ is HumanOptionFollowers:
                        _loc13_ = new Array();
                        for each(_loc14_ in _loc12_.followingCharactersLook)
                        {
                           _loc13_.push(_loc14_);
                        }
                        _loc13_.sortOn("index");
                        for each(_loc15_ in _loc13_)
                        {
                           _loc8_.push(_loc15_.look);
                           _loc9_.push(Follower.TYPE_NETWORK);
                        }
                        continue;
                     case _loc12_ is HumanOptionAlliance:
                        this.addConquestIcon(param1.contextualId,_loc12_ as HumanOptionAlliance);
                        continue;
                     default:
                        continue;
                  }
               }
               _loc10_ = _loc3_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET_FOLLOWER);
               for each(_loc16_ in _loc10_)
               {
                  _loc8_.push(EntityLookAdapter.toNetwork(_loc16_));
                  _loc9_.push(Follower.TYPE_PET);
               }
               this.manageFollowers(_loc3_,_loc8_,null,_loc9_);
               if(_loc3_.look.getBone() == 1)
               {
                  _loc3_.addAnimationModifier(_customBreedAnimationModifier);
                  _loc17_ = MapPosition.getMapPositionById(PlayedCharacterManager.getInstance().currentMap.mapId);
                  if(_loc17_.isUnderWater)
                  {
                     _loc3_.addAnimationModifier(_underWaterAnimationModifier);
                  }
               }
               if(_creaturesMode || _loc3_.getAnimation() == AnimationEnum.ANIM_STATIQUE)
               {
                  _loc3_.setAnimation(AnimationEnum.ANIM_STATIQUE);
               }
               break;
            case param1 is GameRolePlayMerchantInformations:
               if(_loc3_.look.getBone() == 1)
               {
                  _loc3_.addAnimationModifier(_customBreedAnimationModifier);
               }
               if(_creaturesMode || _loc3_.getAnimation() == AnimationEnum.ANIM_STATIQUE)
               {
                  _loc3_.setAnimation(AnimationEnum.ANIM_STATIQUE);
               }
               break;
            case param1 is GameRolePlayTaxCollectorInformations:
            case param1 is GameRolePlayPrismInformations:
            case param1 is GameRolePlayPortalInformations:
               _loc3_.allowMovementThrough = true;
               break;
            case param1 is GameRolePlayNpcInformations:
               this._npcList[param1.contextualId] = _loc3_;
            case param1 is GameContextPaddockItemInformations:
               break;
            default:
               _log.warn("Unknown GameRolePlayActorInformations type : " + param1 + ".");
         }
         return _loc3_;
      }
      
      override protected function updateActorLook(param1:Number, param2:EntityLook, param3:Boolean = false) : AnimatedCharacter
      {
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Boolean = false;
         var _loc10_:TiphonEntityLook = null;
         var _loc11_:Follower = null;
         var _loc4_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         if(_loc4_)
         {
            _loc5_ = (TiphonUtility.getEntityWithoutMount(_loc4_) as TiphonSprite).getAnimation();
            if(!_creaturesMode)
            {
               _loc7_ = EntityLookAdapter.fromNetwork(param2).getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET_FOLLOWER);
               _loc8_ = [];
               _loc9_ = false;
               for each(_loc10_ in _loc7_)
               {
                  _loc9_ = false;
                  for each(_loc11_ in _loc4_.followers)
                  {
                     if(_loc11_.type == Follower.TYPE_PET && _loc11_.entity is TiphonSprite && (_loc11_.entity as TiphonSprite).look.equals(_loc10_))
                     {
                        _loc9_ = true;
                        break;
                     }
                  }
                  if(!_loc9_)
                  {
                     _loc8_.push(_loc10_);
                  }
               }
               for each(_loc10_ in _loc8_)
               {
                  _loc4_.addFollower(this.createFollower(_loc10_,_loc4_,Follower.TYPE_PET),true);
               }
            }
            _loc6_ = [];
            for each(_loc11_ in _loc4_.followers)
            {
               _loc9_ = false;
               if(_loc11_.type == Follower.TYPE_PET)
               {
                  for each(_loc10_ in _loc7_)
                  {
                     if(_loc11_.entity is TiphonSprite && (_loc11_.entity as TiphonSprite).look.equals(_loc10_))
                     {
                        _loc9_ = true;
                        break;
                     }
                  }
                  if(!_loc9_)
                  {
                     _loc6_.push(_loc11_);
                  }
               }
            }
            for each(_loc11_ in _loc6_)
            {
               _loc4_.removeFollower(_loc11_);
            }
            if(_loc5_.indexOf("_Statique_") != -1 && (!this._lastStaticAnimations[param1] || this._lastStaticAnimations[param1] != _loc5_))
            {
               this._lastStaticAnimations[param1] = {"anim":_loc5_};
            }
            if(_loc4_.look.getBone() != param2.bonesId && this._lastStaticAnimations[param1])
            {
               this._lastStaticAnimations[param1].targetBone = param2.bonesId;
               _loc4_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityRendered);
               _loc4_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityRendered);
               _loc4_.setAnimation(AnimationEnum.ANIM_STATIQUE);
            }
         }
         return super.updateActorLook(param1,param2,param3);
      }
      
      private function onEntityRendered(param1:TiphonEvent) : void
      {
         var _loc2_:AnimatedCharacter = param1.currentTarget as AnimatedCharacter;
         if(_loc2_ && this._lastStaticAnimations[_loc2_.id] && _loc2_.look && this._lastStaticAnimations[_loc2_.id].targetBone == _loc2_.look.getBone() && _loc2_.rendered)
         {
            _loc2_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityRendered);
            _loc2_.setAnimation(this._lastStaticAnimations[_loc2_.id].anim);
            delete this._lastStaticAnimations[_loc2_.id];
         }
      }
      
      private function removeBackground(param1:TiphonSprite) : void
      {
         if(!param1)
         {
            return;
         }
         param1.removeBackground("questClip");
         param1.removeBackground("questObjectiveClip");
         param1.removeBackground("questRepeatableClip");
         param1.removeBackground("questRepeatableObjectiveClip");
      }
      
      private function manageFollowers(param1:AnimatedCharacter, param2:Vector.<EntityLook>, param3:Vector.<Number> = null, param4:Vector.<uint> = null, param5:Boolean = false) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:EntityLook = null;
         var _loc9_:TiphonEntityLook = null;
         if(_creaturesMode && !param5)
         {
            return;
         }
         if(!param1.followersEqual(param2))
         {
            param1.removeAllFollowers();
            _loc6_ = param2.length;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = param2[_loc7_];
               _loc9_ = EntityLookAdapter.fromNetwork(_loc8_);
               param1.addFollower(this.createFollower(_loc9_,param1,!!param4?uint(param4[_loc7_]):!!param5?uint(Follower.TYPE_MONSTER):uint(Follower.TYPE_NETWORK),param3 != null?Number(param3[_loc7_]):Number(null)));
               _loc7_++;
            }
         }
      }
      
      private function createFollower(param1:TiphonEntityLook, param2:AnimatedCharacter, param3:uint, param4:Number = 0) : Follower
      {
         var _loc6_:MapPosition = null;
         var _loc5_:AnimatedCharacter = new AnimatedCharacter(EntitiesManager.getInstance().getFreeEntityId(),param1,param2);
         if(param4)
         {
            _loc5_.speedAdjust = param4;
         }
         if(param1.getBone() == 1)
         {
            _loc5_.addAnimationModifier(_customBreedAnimationModifier);
            _loc6_ = MapPosition.getMapPositionById(PlayedCharacterManager.getInstance().currentMap.mapId);
            if(_loc6_.isUnderWater)
            {
               _loc5_.addAnimationModifier(_underWaterAnimationModifier);
            }
         }
         return new Follower(_loc5_,param3);
      }
      
      private function addFight(param1:FightCommonInformations) : void
      {
         var _loc10_:FightTeamInformations = null;
         var _loc11_:IEntity = null;
         var _loc12_:FightTeam = null;
         if(this._fights[param1.fightId])
         {
            return;
         }
         var _loc2_:Vector.<FightTeam> = new Vector.<FightTeam>(0,false);
         var _loc3_:Fight = new Fight(param1.fightId,_loc2_);
         var _loc4_:String = Math.round(Math.random() * 16).toString(16);
         var _loc5_:String = Math.round(Math.random() * 16).toString(16);
         var _loc6_:String = Math.round(Math.random() * 16).toString(16);
         var _loc7_:String = "0x" + _loc4_ + _loc4_ + _loc5_ + _loc5_ + _loc6_ + _loc6_;
         var _loc8_:int = int(_loc7_);
         var _loc9_:uint = 0;
         for each(_loc10_ in param1.fightTeams)
         {
            _loc11_ = RolePlayEntitiesFactory.createFightEntity(param1,_loc10_,MapPoint.fromCellId(param1.fightTeamsPositions[_loc9_]),_loc8_);
            (_loc11_ as IDisplayable).display();
            _loc12_ = new FightTeam(_loc3_,_loc10_.teamTypeId,_loc11_,_loc10_,param1.fightTeamsOptions[_loc10_.teamId]);
            _entities[_loc11_.id] = _loc12_;
            _loc2_.push(_loc12_);
            _loc9_++;
            (_loc11_ as TiphonSprite).addEventListener(TiphonEvent.RENDER_SUCCEED,this.onFightEntityRendered,false,0,true);
         }
         this._fights[param1.fightId] = _loc3_;
      }
      
      private function addObject(param1:uint, param2:uint) : void
      {
         if(this._objectsByCellId && this._objectsByCellId[param2])
         {
            _log.error("To add an object on the ground, the destination cell must be empty.");
            return;
         }
         var _loc3_:Uri = new Uri(LangManager.getInstance().getEntry("config.gfx.path.item.vector") + Item.getItemById(param1).iconId + ".swf");
         var _loc4_:IInteractive = new RoleplayObjectEntity(param1,MapPoint.fromCellId(param2));
         (_loc4_ as IDisplayable).display();
         var _loc5_:GameContextActorInformations = new GroundObject(Item.getItemById(param1));
         _loc5_.contextualId = _loc4_.id;
         _loc5_.disposition.cellId = param2;
         _loc5_.disposition.direction = DirectionsEnum.DOWN_RIGHT;
         if(this._objects == null)
         {
            this._objects = new Dictionary();
         }
         this._objects[_loc3_] = _loc4_;
         this._objectsByCellId[param2] = this._objects[_loc3_];
         _entities[_loc4_.id] = _loc5_;
         this._loader.load(_loc3_,null,null,true);
      }
      
      private function removeObject(param1:uint) : void
      {
         if(this._objectsByCellId[param1] != null)
         {
            if(this._objects[this._objectsByCellId[param1]] != null)
            {
               delete this._objects[this._objectsByCellId[param1]];
            }
            if(_entities[this._objectsByCellId[param1].id] != null)
            {
               delete _entities[this._objectsByCellId[param1].id];
            }
            (this._objectsByCellId[param1] as IDisplayable).remove();
            delete this._objectsByCellId[param1];
         }
      }
      
      private function updateFight(param1:uint, param2:FightTeamInformations) : void
      {
         var _loc6_:FightTeamMemberInformations = null;
         var _loc7_:Boolean = false;
         var _loc8_:FightTeamMemberInformations = null;
         var _loc3_:Fight = this._fights[param1];
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:FightTeam = _loc3_.getTeamById(param2.teamId);
         var _loc5_:FightTeamInformations = (_entities[_loc4_.teamEntity.id] as FightTeam).teamInfos;
         if(_loc5_.teamMembers == param2.teamMembers)
         {
            return;
         }
         for each(_loc6_ in param2.teamMembers)
         {
            _loc7_ = false;
            for each(_loc8_ in _loc5_.teamMembers)
            {
               if(_loc8_.id == _loc6_.id)
               {
                  _loc7_ = true;
               }
            }
            if(!_loc7_)
            {
               _loc5_.teamMembers.push(_loc6_);
            }
         }
      }
      
      private function removeFighter(param1:uint, param2:uint, param3:Number) : void
      {
         var _loc5_:FightTeam = null;
         var _loc6_:FightTeamInformations = null;
         var _loc7_:Vector.<FightTeamMemberInformations> = null;
         var _loc8_:FightTeamMemberInformations = null;
         var _loc4_:Fight = this._fights[param1];
         if(_loc4_)
         {
            _loc5_ = _loc4_.teams[param2];
            _loc6_ = _loc5_.teamInfos;
            _loc7_ = new Vector.<FightTeamMemberInformations>(0,false);
            for each(_loc8_ in _loc6_.teamMembers)
            {
               if(_loc8_.id != param3)
               {
                  _loc7_.push(_loc8_);
               }
            }
            _loc6_.teamMembers = _loc7_;
         }
      }
      
      private function removeFight(param1:uint) : void
      {
         var _loc3_:FightTeam = null;
         var _loc4_:Object = null;
         var _loc2_:Fight = this._fights[param1];
         if(_loc2_ == null)
         {
            return;
         }
         for each(_loc3_ in _loc2_.teams)
         {
            _loc4_ = _entities[_loc3_.teamEntity.id];
            _log.debug("suppression de la team " + _loc3_.teamEntity.id);
            Kernel.getWorker().process(new EntityMouseOutMessage(_loc3_.teamEntity as IInteractive));
            (_loc3_.teamEntity as IDisplayable).remove();
            TooltipManager.hide("fightOptions_" + param1 + "_" + _loc3_.teamInfos.teamId);
            delete _entities[_loc3_.teamEntity.id];
         }
         delete this._fights[param1];
      }
      
      private function addPaddockItem(param1:PaddockItem) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Item = Item.getItemById(param1.objectGID);
         if(this._paddockItem[param1.cellId])
         {
            _loc3_ = (this._paddockItem[param1.cellId] as IEntity).id;
         }
         else
         {
            _loc3_ = EntitiesManager.getInstance().getFreeEntityId();
         }
         var _loc4_:GameContextPaddockItemInformations = new GameContextPaddockItemInformations(_loc3_,_loc2_.appearance,param1.cellId,param1.durability,_loc2_);
         var _loc5_:IEntity = this.addOrUpdateActor(_loc4_);
         this._paddockItem[param1.cellId] = _loc5_;
      }
      
      private function removePaddockItem(param1:uint) : void
      {
         var _loc2_:IEntity = this._paddockItem[param1];
         if(!_loc2_)
         {
            return;
         }
         (_loc2_ as IDisplayable).remove();
         delete this._paddockItem[param1];
      }
      
      private function activatePaddockItem(param1:uint) : void
      {
         var _loc3_:SerialSequencer = null;
         var _loc2_:TiphonSprite = this._paddockItem[param1];
         if(_loc2_)
         {
            _loc3_ = new SerialSequencer();
            _loc3_.addStep(new PlayAnimationStep(_loc2_,AnimationEnum.ANIM_HIT));
            _loc3_.addStep(new PlayAnimationStep(_loc2_,AnimationEnum.ANIM_STATIQUE));
            _loc3_.start();
         }
      }
      
      private function onFightEntityRendered(param1:TiphonEvent) : void
      {
         if(!_entities || !param1.target)
         {
            return;
         }
         var _loc2_:FightTeam = _entities[param1.target.id];
         if(_loc2_ && _loc2_.fight && _loc2_.teamInfos)
         {
            this.updateSwordOptions(_loc2_.fight.fightId,_loc2_.teamInfos.teamId);
         }
      }
      
      private function updateSwordOptions(param1:uint, param2:uint, param3:int = -1, param4:Boolean = false) : void
      {
         var _loc8_:* = undefined;
         var _loc5_:Fight = this._fights[param1];
         if(_loc5_ == null)
         {
            return;
         }
         var _loc6_:FightTeam = _loc5_.teams[param2];
         if(_loc6_ == null)
         {
            return;
         }
         if(param3 != -1)
         {
            _loc6_.teamOptions[param3] = param4;
         }
         var _loc7_:Vector.<String> = new Vector.<String>();
         for(_loc8_ in _loc6_.teamOptions)
         {
            if(_loc6_.teamOptions[_loc8_])
            {
               _loc7_.push("fightOption" + _loc8_);
            }
         }
         if(_loc6_.hasGroupMember())
         {
            _loc7_.push("fightOption4");
         }
         TooltipManager.show(_loc7_,(_loc6_.teamEntity as IDisplayable).absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"fightOptions_" + param1 + "_" + param2,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,"texturesList",null,null,null,false,0,Atouin.getInstance().currentZoom,false);
      }
      
      private function paddockCellValidator(param1:int) : Boolean
      {
         var _loc3_:GameContextActorInformations = null;
         var _loc2_:IEntity = EntitiesManager.getInstance().getEntityOnCell(param1);
         if(_loc2_)
         {
            _loc3_ = getEntityInfos(_loc2_.id);
            if(_loc3_ is GameContextPaddockItemInformations)
            {
               return false;
            }
         }
         return DataMapProvider.getInstance().farmCell(MapPoint.fromCellId(param1).x,MapPoint.fromCellId(param1).y) && DataMapProvider.getInstance().pointMov(MapPoint.fromCellId(param1).x,MapPoint.fromCellId(param1).y,true);
      }
      
      private function removeEntityListeners(param1:Number) : void
      {
         var _loc3_:TiphonSprite = null;
         var _loc2_:TiphonSprite = DofusEntities.getEntity(param1) as TiphonSprite;
         if(_loc2_)
         {
            _loc2_.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
            _loc3_ = _loc2_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite;
            if(_loc3_)
            {
               _loc3_.removeEventListener(TiphonEvent.ANIMATION_ADDED,this.onAnimationAdded);
            }
            _loc2_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityReadyForEmote);
         }
      }
      
      private function updateUsableEmotesListInit(param1:TiphonEntityLook) : void
      {
         var _loc2_:TiphonEntityLook = null;
         var _loc4_:GameContextActorInformations = null;
         var _loc5_:Array = null;
         if(_entities && _entities[PlayedCharacterManager.getInstance().id])
         {
            _loc4_ = _entities[PlayedCharacterManager.getInstance().id] as GameContextActorInformations;
            _loc2_ = EntityLookAdapter.fromNetwork(_loc4_.look);
         }
         var _loc3_:Array = _loc2_.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET_FOLLOWER);
         if((_creaturesMode || _creaturesFightMode || _loc3_ && _loc3_.length != 0) && _loc2_)
         {
            _loc5_ = TiphonMultiBonesManager.getInstance().getAllBonesFromLook(_loc2_);
            TiphonMultiBonesManager.getInstance().forceBonesLoading(_loc5_,new Callback(this.updateUsableEmotesList,_loc2_));
         }
         else
         {
            this.updateUsableEmotesList(param1);
         }
      }
      
      private function updateUsableEmotesList(param1:TiphonEntityLook) : void
      {
         var _loc6_:EmoteWrapper = null;
         var _loc7_:String = null;
         var _loc9_:Boolean = false;
         var _loc10_:* = null;
         var _loc11_:* = null;
         var _loc13_:ShortcutWrapper = null;
         var _loc16_:int = 0;
         var _loc2_:Boolean = PlayedCharacterManager.getInstance().isGhost;
         var _loc3_:Boolean = PlayedCharacterManager.getInstance().isIncarnation;
         var _loc4_:EmoticonFrame = Kernel.getWorker().getFrame(EmoticonFrame) as EmoticonFrame;
         var _loc5_:Array = _loc4_.emotesList;
         var _loc8_:Array = param1.getSubEntities();
         var _loc12_:Boolean = false;
         var _loc14_:Array = new Array();
         var _loc15_:uint = param1.getBone();
         for each(_loc6_ in _loc5_)
         {
            _loc9_ = false;
            if(_loc6_ && _loc6_.emote)
            {
               _loc7_ = _loc6_.emote.getAnimName(param1);
               if(_loc6_.emote.aura && !_loc2_ && !_loc3_ || Tiphon.skullLibrary.hasAnim(param1.getBone(),_loc7_))
               {
                  _loc9_ = true;
               }
               else if(_loc8_)
               {
                  for(_loc10_ in _loc8_)
                  {
                     for(_loc11_ in _loc8_[_loc10_])
                     {
                        if(Tiphon.skullLibrary.hasAnim(_loc8_[_loc10_][_loc11_].getBone(),_loc7_))
                        {
                           _loc9_ = true;
                           break;
                        }
                     }
                     if(_loc9_)
                     {
                        break;
                     }
                  }
               }
               _loc16_ = _loc4_.emotes.indexOf(_loc6_.id);
               for each(_loc13_ in InventoryManager.getInstance().shortcutBarItems)
               {
                  if(_loc13_ && _loc13_.type == 4 && _loc13_.id == _loc6_.id && _loc13_.active != _loc9_)
                  {
                     _loc13_.active = _loc9_;
                     _loc12_ = true;
                     break;
                  }
               }
               if(_loc9_)
               {
                  _loc14_.push(_loc6_.id);
                  if(_loc16_ == -1)
                  {
                     _loc4_.emotes.push(_loc6_.id);
                  }
               }
               else if(_loc16_ != -1)
               {
                  _loc4_.emotes.splice(_loc16_,1);
               }
            }
         }
         KernelEventsManager.getInstance().processCallback(RoleplayHookList.EmoteEnabledListUpdated,_loc14_);
         if(_loc12_)
         {
            KernelEventsManager.getInstance().processCallback(InventoryHookList.ShortcutBarViewContent,0);
         }
      }
      
      private function onEntityReadyForEmote(param1:TiphonEvent) : void
      {
         var _loc2_:AnimatedCharacter = param1.currentTarget as AnimatedCharacter;
         _loc2_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onEntityReadyForEmote);
         if(this._playersId.indexOf(_loc2_.id) != -1)
         {
            this.process(this._waitingEmotesAnims[_loc2_.id]);
         }
         delete this._waitingEmotesAnims[_loc2_.id];
      }
      
      private function onAnimationAdded(param1:TiphonEvent) : void
      {
         var _loc5_:String = null;
         var _loc6_:Vector.<SoundAnimation> = null;
         var _loc7_:SoundAnimation = null;
         var _loc8_:String = null;
         var _loc2_:TiphonSprite = param1.currentTarget as TiphonSprite;
         _loc2_.removeEventListener(TiphonEvent.ANIMATION_ADDED,this.onAnimationAdded);
         var _loc3_:TiphonAnimation = _loc2_.rawAnimation;
         var _loc4_:SoundBones = SoundBones.getSoundBonesById(_loc2_.look.getBone());
         if(_loc4_)
         {
            _loc5_ = getQualifiedClassName(_loc3_);
            _loc6_ = _loc4_.getSoundAnimations(_loc5_);
            _loc3_.spriteHandler.tiphonEventManager.removeEvents(TiphonEventsManager.BALISE_SOUND,_loc5_);
            for each(_loc7_ in _loc6_)
            {
               _loc8_ = TiphonEventsManager.BALISE_DATASOUND + TiphonEventsManager.BALISE_PARAM_BEGIN + (_loc7_.label != null && _loc7_.label != "null"?_loc7_.label:"") + TiphonEventsManager.BALISE_PARAM_END;
               _loc3_.spriteHandler.tiphonEventManager.addEvent(_loc8_,_loc7_.startFrame,_loc5_);
            }
         }
      }
      
      private function onGroundObjectLoaded(param1:ResourceLoadedEvent) : void
      {
         var _loc2_:MovieClip = param1.resource is ASwf?param1.resource.content:param1.resource;
         _loc2_.width = 34;
         _loc2_.height = 34;
         _loc2_.x = _loc2_.x - _loc2_.width / 2;
         _loc2_.y = _loc2_.y - _loc2_.height / 2;
         if(this._objects[param1.uri])
         {
            this._objects[param1.uri].addChild(_loc2_);
         }
      }
      
      private function onGroundObjectLoadFailed(param1:ResourceErrorEvent) : void
      {
      }
      
      public function timeoutStop(param1:AnimatedCharacter) : void
      {
         clearTimeout(this._timeout);
         param1.setAnimation(AnimationEnum.ANIM_STATIQUE);
         this._currentEmoticon = 0;
      }
      
      override public function onPlayAnim(param1:TiphonEvent) : void
      {
         var _loc2_:Array = new Array();
         var _loc3_:String = param1.params.substring(6,param1.params.length - 1);
         _loc2_ = _loc3_.split(",");
         var _loc4_:int = this._emoteTimesBySprite[(param1.currentTarget as TiphonSprite).name] % _loc2_.length;
         param1.sprite.setAnimation(_loc2_[_loc4_]);
      }
      
      private function onAnimationEnd(param1:TiphonEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:TiphonSprite = param1.currentTarget as TiphonSprite;
         _loc2_.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
         var _loc5_:Object = _loc2_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0);
         if(_loc5_ != null)
         {
            _loc4_ = _loc5_.getAnimation();
            if(_loc4_.indexOf("_") == -1)
            {
               _loc4_ = _loc2_.getAnimation();
            }
         }
         else
         {
            _loc4_ = _loc2_.getAnimation();
         }
         if(_loc4_.indexOf("_Statique_") == -1)
         {
            _loc3_ = _loc4_.replace("_","_Statique_");
         }
         else
         {
            _loc3_ = _loc4_;
         }
         if(_loc2_.hasAnimation(_loc3_,_loc2_.getDirection()) || _loc5_ && _loc5_ is TiphonSprite && TiphonSprite(_loc5_).hasAnimation(_loc3_,TiphonSprite(_loc5_).getDirection()))
         {
            _loc2_.setAnimation(_loc3_);
         }
         else
         {
            _loc2_.setAnimation(AnimationEnum.ANIM_STATIQUE);
            this._currentEmoticon = 0;
         }
      }
      
      private function onPlayerSpriteInit(param1:TiphonEvent) : void
      {
         var _loc2_:TiphonEntityLook = (param1.sprite as TiphonSprite).look;
         if(param1.params == _loc2_.getBone())
         {
            param1.sprite.removeEventListener(TiphonEvent.SPRITE_INIT,this.onPlayerSpriteInit);
            this.updateUsableEmotesListInit(_loc2_);
         }
      }
      
      private function onCellPointed(param1:Boolean, param2:uint, param3:Number) : void
      {
         var _loc4_:PaddockMoveItemRequestMessage = null;
         if(param1)
         {
            _loc4_ = new PaddockMoveItemRequestMessage();
            _loc4_.initPaddockMoveItemRequestMessage(this._currentPaddockItemCellId,param2);
            ConnectionsHandler.getConnection().send(_loc4_);
         }
      }
      
      private function updateConquestIcons(param1:*) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:GameRolePlayHumanoidInformations = null;
         var _loc4_:* = undefined;
         if(param1 is Vector.<Number> && (param1 as Vector.<Number>).length > 0)
         {
            for each(_loc2_ in param1)
            {
               _loc3_ = getEntityInfos(_loc2_) as GameRolePlayHumanoidInformations;
               if(_loc3_)
               {
                  for each(_loc4_ in _loc3_.humanoidInfo.options)
                  {
                     if(_loc4_ is HumanOptionAlliance)
                     {
                        this.addConquestIcon(_loc3_.contextualId,_loc4_ as HumanOptionAlliance);
                        break;
                     }
                  }
               }
            }
         }
         else if(param1 is Number)
         {
            _loc3_ = getEntityInfos(param1) as GameRolePlayHumanoidInformations;
            if(_loc3_)
            {
               for each(_loc4_ in _loc3_.humanoidInfo.options)
               {
                  if(_loc4_ is HumanOptionAlliance)
                  {
                     this.addConquestIcon(_loc3_.contextualId,_loc4_ as HumanOptionAlliance);
                     break;
                  }
               }
            }
         }
      }
      
      private function addConquestIcon(param1:Number, param2:HumanOptionAlliance) : void
      {
         var _loc3_:PrismSubAreaWrapper = null;
         var _loc4_:String = null;
         var _loc5_:Vector.<String> = null;
         var _loc6_:String = null;
         if(PlayedCharacterManager.getInstance().characteristics.alignmentInfos.aggressable != AggressableStatusEnum.NON_AGGRESSABLE && this._allianceFrame && this._allianceFrame.hasAlliance && param2.aggressable != AggressableStatusEnum.NON_AGGRESSABLE && param2.aggressable != AggressableStatusEnum.PvP_ENABLED_AGGRESSABLE && param2.aggressable != AggressableStatusEnum.PvP_ENABLED_NON_AGGRESSABLE)
         {
            _loc3_ = this._allianceFrame.getPrismSubAreaById(PlayedCharacterManager.getInstance().currentSubArea.id);
            if(_loc3_ && _loc3_.state == PrismStateEnum.PRISM_STATE_VULNERABLE)
            {
               switch(param2.aggressable)
               {
                  case AggressableStatusEnum.AvA_DISQUALIFIED:
                     if(param1 == PlayedCharacterManager.getInstance().id)
                     {
                        _loc4_ = "neutral";
                     }
                     break;
                  case AggressableStatusEnum.AvA_PREQUALIFIED_AGGRESSABLE:
                     if(param1 == PlayedCharacterManager.getInstance().id)
                     {
                        _loc4_ = "clock";
                     }
                     else
                     {
                        _loc4_ = this.getPlayerConquestStatus(param1,param2.allianceInformations.allianceId,_loc3_.alliance.allianceId);
                     }
                     break;
                  case AggressableStatusEnum.AvA_ENABLED_AGGRESSABLE:
                     _loc4_ = this.getPlayerConquestStatus(param1,param2.allianceInformations.allianceId,_loc3_.alliance.allianceId);
               }
               if(_loc4_)
               {
                  _loc5_ = getIconNamesByCategory(param1,EntityIconEnum.AVA_CATEGORY);
                  if(_loc5_ && _loc5_[0] != _loc4_)
                  {
                     _loc6_ = _loc5_[0];
                     _loc5_.length = 0;
                     removeIcon(param1,_loc6_,true);
                  }
                  addEntityIcon(param1,_loc4_,EntityIconEnum.AVA_CATEGORY);
               }
            }
         }
         if(!_loc4_ && _entitiesIconsNames[param1] && _entitiesIconsNames[param1][EntityIconEnum.AVA_CATEGORY])
         {
            removeIconsCategory(param1,EntityIconEnum.AVA_CATEGORY);
         }
      }
      
      private function getPlayerConquestStatus(param1:Number, param2:int, param3:int) : String
      {
         var _loc4_:String = null;
         if(param1 == PlayedCharacterManager.getInstance().id || this._allianceFrame.alliance.allianceId == param2)
         {
            _loc4_ = "ownTeam";
         }
         else if(param2 == param3)
         {
            _loc4_ = "defender";
         }
         else
         {
            _loc4_ = "forward";
         }
         return _loc4_;
      }
      
      private function onTiphonPropertyChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.propertyName == "auraMode" && param1.propertyOldValue != param1.propertyValue)
         {
            if(this._auraCycleTimer.running)
            {
               this._auraCycleTimer.removeEventListener(TimerEvent.TIMER,this.onAuraCycleTimer);
               this._auraCycleTimer.stop();
            }
            switch(param1.propertyValue)
            {
               case OptionEnum.AURA_CYCLE:
                  this._auraCycleTimer.addEventListener(TimerEvent.TIMER,this.onAuraCycleTimer);
                  this._auraCycleTimer.start();
                  this.setEntitiesAura(false);
                  break;
               case OptionEnum.AURA_ON_ROLLOVER:
               case OptionEnum.AURA_NONE:
                  this.setEntitiesAura(false);
                  break;
               case OptionEnum.AURA_ALWAYS:
               default:
                  this.setEntitiesAura(true);
            }
         }
      }
      
      private function onAuraCycleTimer(param1:TimerEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:AnimatedCharacter = null;
         var _loc5_:AnimatedCharacter = null;
         var _loc6_:AnimatedCharacter = null;
         var _loc2_:Vector.<Number> = getEntitiesIdsList();
         if(this._auraCycleIndex >= _loc2_.length)
         {
            this._auraCycleIndex = 0;
         }
         var _loc7_:int = _loc2_.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc6_ = DofusEntities.getEntity(_loc2_[_loc8_]) as AnimatedCharacter;
            if(_loc6_)
            {
               if(!_loc4_ && _loc6_.hasAura && _loc6_.getDirection() == DirectionsEnum.DOWN)
               {
                  _loc4_ = _loc6_;
                  _loc3_ = _loc8_;
               }
               if(_loc8_ == this._auraCycleIndex && _loc6_.hasAura && _loc6_.getDirection() == DirectionsEnum.DOWN)
               {
                  _loc5_ = _loc6_;
                  break;
               }
               if(!_loc6_.hasAura)
               {
                  this._auraCycleIndex++;
               }
            }
            _loc8_++;
         }
         if(this._lastEntityWithAura)
         {
            this._lastEntityWithAura.visibleAura = false;
         }
         if(_loc5_)
         {
            _loc5_.visibleAura = true;
            this._lastEntityWithAura = _loc5_;
         }
         else if(!_loc5_ && _loc4_)
         {
            _loc4_.visibleAura = true;
            this._lastEntityWithAura = _loc4_;
            this._auraCycleIndex = _loc3_;
         }
         this._auraCycleIndex++;
      }
      
      private function setEntitiesAura(param1:Boolean) : void
      {
         var _loc3_:AnimatedCharacter = null;
         var _loc2_:Vector.<Number> = getEntitiesIdsList();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc3_ = DofusEntities.getEntity(_loc2_[_loc4_]) as AnimatedCharacter;
            if(_loc3_)
            {
               _loc3_.visibleAura = param1;
            }
            _loc4_++;
         }
      }
      
      override protected function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         super.onPropertyChanged(param1);
         if(param1.propertyName == "allowAnimsFun")
         {
            AnimFunManager.getInstance().stop();
            if(param1.propertyValue == true)
            {
               AnimFunManager.getInstance().initializeByMap(PlayedCharacterManager.getInstance().currentMap.mapId);
            }
         }
      }
   }
}
