package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.messages.CellOutMessage;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.messages.MapLoadedMessage;
   import com.ankamagames.atouin.messages.MapsLoadingCompleteMessage;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.enums.StrataEnum;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.SecureCenter;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.types.event.UiUnloadEvent;
   import com.ankamagames.berilia.types.tooltip.TooltipPlacer;
   import com.ankamagames.berilia.types.tooltip.event.TooltipEvent;
   import com.ankamagames.dofus.datacenter.monsters.Companion;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.fight.ChallengeWrapper;
   import com.ankamagames.dofus.internalDatacenter.fight.FightResultEntryWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.enum.UISoundEnum;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.dofus.logic.game.common.frames.PartyManagementFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SpellInventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.messages.FightEndingMessage;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.ChallengeTargetsListRequestAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ShowTacticModeAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOutAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOverAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TogglePointCellAction;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.LinkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.managers.SpellDamagesManager;
   import com.ankamagames.dofus.logic.game.fight.managers.SpellZoneManager;
   import com.ankamagames.dofus.logic.game.fight.managers.TacticModeManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.logic.game.fight.miscs.DamageUtil;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightReachableCellsMaker;
   import com.ankamagames.dofus.logic.game.fight.miscs.PushUtil;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.dofus.logic.game.fight.types.EffectDamage;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.logic.game.fight.types.InterceptedDamage;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.dofus.logic.game.fight.types.PushedEntity;
   import com.ankamagames.dofus.logic.game.fight.types.SpellCastInFightManager;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamage;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamageInfo;
   import com.ankamagames.dofus.logic.game.fight.types.SpellDamageList;
   import com.ankamagames.dofus.logic.game.fight.types.SplashDamage;
   import com.ankamagames.dofus.logic.game.fight.types.StatBuff;
   import com.ankamagames.dofus.logic.game.fight.types.TriggeredSpell;
   import com.ankamagames.dofus.logic.game.roleplay.frames.EntitiesTooltipsFrame;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.network.enums.FightOutcomeEnum;
   import com.ankamagames.dofus.network.enums.GameActionFightInvisibilityStateEnum;
   import com.ankamagames.dofus.network.enums.GameActionMarkTypeEnum;
   import com.ankamagames.dofus.network.enums.MapObstacleStateEnum;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCarryCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightNoSpellCastMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextDestroyMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextReadyMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightJoinMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightResumeMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightResumeWithSlavesMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightSpectateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightSpectatorJoinMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightStartMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightStartingMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightUpdateTeamMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.arena.ArenaFighterLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeInfoMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeResultMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeTargetUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeTargetsListMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.challenge.ChallengeTargetsListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.CurrentMapMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapObstacleUpdateMessage;
   import com.ankamagames.dofus.network.types.game.action.fight.FightDispellableEffectExtendedInformations;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMark;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMarkedCell;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultFighterListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultPlayerListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultTaxCollectorListEntry;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCompanionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterNamedInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMutantInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightResumeSlaveInfo;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.NamedPartyTeam;
   import com.ankamagames.dofus.network.types.game.context.roleplay.party.NamedPartyTeamWithOutcome;
   import com.ankamagames.dofus.network.types.game.idol.Idol;
   import com.ankamagames.dofus.network.types.game.interactive.MapObstacle;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.Glyph;
   import com.ankamagames.dofus.types.sequences.AddGlyphGfxStep;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellShapeEnum;
   import com.ankamagames.jerakine.utils.memory.WeakReference;
   import com.hurlant.util.Hex;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class FightContextFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightContextFrame));
      
      public static var preFightIsActive:Boolean = true;
      
      public static var fighterEntityTooltipId:Number;
      
      public static var currentCell:int = -1;
       
      
      private const TYPE_LOG_FIGHT:uint = 30000.0;
      
      private const INVISIBLE_POSITION_SELECTION:String = "invisible_position";
      
      private var _entitiesFrame:FightEntitiesFrame;
      
      private var _preparationFrame:FightPreparationFrame;
      
      private var _battleFrame:FightBattleFrame;
      
      private var _pointCellFrame:FightPointCellFrame;
      
      private var _overEffectOk:GlowFilter;
      
      private var _overEffectKo:GlowFilter;
      
      private var _linkedEffect:ColorMatrixFilter;
      
      private var _linkedMainEffect:ColorMatrixFilter;
      
      private var _lastEffectEntity:WeakReference;
      
      private var _reachableRangeSelection:Selection;
      
      private var _unreachableRangeSelection:Selection;
      
      private var _timerFighterInfo:Timer;
      
      private var _timerMovementRange:Timer;
      
      private var _currentFighterInfo:GameFightFighterInformations;
      
      private var _currentMapRenderId:int = -1;
      
      private var _timelineOverEntity:Boolean;
      
      private var _timelineOverEntityId:Number;
      
      private var _showPermanentTooltips:Boolean;
      
      private var _hideTooltipTimer:Timer;
      
      private var _hideTooltipEntityId:Number;
      
      private var _hideTooltipsTimer:Timer;
      
      private var _hideTooltips:Boolean;
      
      public var _challengesList:Array;
      
      private var _fightType:uint;
      
      private var _fightAttackerId:Number;
      
      private var _spellTargetsTooltips:Dictionary;
      
      private var _tooltipLastUpdate:Dictionary;
      
      private var _namedPartyTeams:Vector.<NamedPartyTeam>;
      
      private var _fightersPositionsHistory:Dictionary;
      
      private var _fightIdols:Vector.<Idol>;
      
      private var _mustShowTreasureHuntMask:Boolean = false;
      
      public var isFightLeader:Boolean;
      
      public var onlyTheOtherTeamCanPlace:Boolean = false;
      
      public function FightContextFrame()
      {
         this._spellTargetsTooltips = new Dictionary();
         this._tooltipLastUpdate = new Dictionary();
         this._fightersPositionsHistory = new Dictionary();
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get entitiesFrame() : FightEntitiesFrame
      {
         return this._entitiesFrame;
      }
      
      public function get battleFrame() : FightBattleFrame
      {
         return this._battleFrame;
      }
      
      public function get challengesList() : Array
      {
         return this._challengesList;
      }
      
      public function get fightType() : uint
      {
         return this._fightType;
      }
      
      public function set fightType(param1:uint) : void
      {
         this._fightType = param1;
         var _loc2_:PartyManagementFrame = Kernel.getWorker().getFrame(PartyManagementFrame) as PartyManagementFrame;
         _loc2_.lastFightType = param1;
      }
      
      public function get timelineOverEntity() : Boolean
      {
         return this._timelineOverEntity;
      }
      
      public function get timelineOverEntityId() : Number
      {
         return this._timelineOverEntityId;
      }
      
      public function get showPermanentTooltips() : Boolean
      {
         return this._showPermanentTooltips;
      }
      
      public function get fightersPositionsHistory() : Dictionary
      {
         return this._fightersPositionsHistory;
      }
      
      public function pushed() : Boolean
      {
         if(!Kernel.beingInReconection)
         {
            Atouin.getInstance().displayGrid(true,true);
         }
         currentCell = -1;
         this._overEffectOk = new GlowFilter(16777215,1,4,4,3,1);
         this._overEffectKo = new GlowFilter(14090240,1,4,4,3,1);
         var matrix:Array = new Array();
         matrix = matrix.concat([0.5,0,0,0,100]);
         matrix = matrix.concat([0,0.5,0,0,100]);
         matrix = matrix.concat([0,0,0.5,0,100]);
         matrix = matrix.concat([0,0,0,1,0]);
         this._linkedEffect = new ColorMatrixFilter(matrix);
         var matrix2:Array = new Array();
         matrix2 = matrix2.concat([0.5,0,0,0,0]);
         matrix2 = matrix2.concat([0,0.5,0,0,0]);
         matrix2 = matrix2.concat([0,0,0.5,0,0]);
         matrix2 = matrix2.concat([0,0,0,1,0]);
         this._linkedMainEffect = new ColorMatrixFilter(matrix2);
         this._entitiesFrame = new FightEntitiesFrame();
         this._preparationFrame = new FightPreparationFrame(this);
         this._battleFrame = new FightBattleFrame();
         this._pointCellFrame = new FightPointCellFrame();
         this._challengesList = new Array();
         this._timerFighterInfo = new Timer(100,1);
         this._timerFighterInfo.addEventListener(TimerEvent.TIMER,this.showFighterInfo,false,0,true);
         this._timerMovementRange = new Timer(200,1);
         this._timerMovementRange.addEventListener(TimerEvent.TIMER,this.showMovementRange,false,0,true);
         if(MapDisplayManager.getInstance().getDataMapContainer())
         {
            MapDisplayManager.getInstance().getDataMapContainer().setTemporaryAnimatedElementState(false);
         }
         if(Kernel.getWorker().contains(EntitiesTooltipsFrame))
         {
            Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(EntitiesTooltipsFrame) as EntitiesTooltipsFrame);
         }
         this._showPermanentTooltips = OptionManager.getOptionManager("dofus")["showPermanentTargetsTooltips"];
         OptionManager.getOptionManager("dofus").addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         Berilia.getInstance().addEventListener(UiUnloadEvent.UNLOAD_UI_COMPLETE,this.onUiUnloaded);
         Berilia.getInstance().addEventListener(UiUnloadEvent.UNLOAD_UI_STARTED,this.onUiUnloadStarted);
         Berilia.getInstance().addEventListener(TooltipEvent.TOOLTIPS_ORDERED,this.onTooltipsOrdered);
         try
         {
            Berilia.getInstance().uiSavedModificationPresetName = "fight";
         }
         catch(error:Error)
         {
            _log.error("Failed to set uiSavedModificationPresetName to \'fight\'!\n" + error.message + "\n" + error.getStackTrace());
         }
         return true;
      }
      
      private function onUiUnloaded(param1:UiUnloadEvent) : void
      {
         var _loc2_:Number = NaN;
         if(this._showPermanentTooltips && this.battleFrame)
         {
            for each(_loc2_ in this.battleFrame.targetedEntities)
            {
               this.displayEntityTooltip(_loc2_);
            }
         }
      }
      
      public function getFighterName(param1:Number) : String
      {
         var _loc2_:GameFightFighterInformations = null;
         var _loc3_:GameFightCompanionInformations = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:GameFightTaxCollectorInformations = null;
         var _loc7_:String = null;
         _loc2_ = this.getFighterInfos(param1);
         if(!_loc2_)
         {
            return "Unknown Fighter";
         }
         switch(true)
         {
            case _loc2_ is GameFightFighterNamedInformations:
               return (_loc2_ as GameFightFighterNamedInformations).name;
            case _loc2_ is GameFightMonsterInformations:
               return Monster.getMonsterById((_loc2_ as GameFightMonsterInformations).creatureGenericId).name;
            case _loc2_ is GameFightCompanionInformations:
               _loc3_ = _loc2_ as GameFightCompanionInformations;
               _loc5_ = Companion.getCompanionById(_loc3_.companionGenericId).name;
               if(_loc3_.masterId != PlayedCharacterManager.getInstance().id)
               {
                  _loc7_ = this.getFighterName(_loc3_.masterId);
                  _loc4_ = I18n.getUiText("ui.common.belonging",[_loc5_,_loc7_]);
               }
               else
               {
                  _loc4_ = _loc5_;
               }
               return _loc4_;
            case _loc2_ is GameFightTaxCollectorInformations:
               _loc6_ = _loc2_ as GameFightTaxCollectorInformations;
               return TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc6_.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(_loc6_.lastNameId).name;
            default:
               return "Unknown Fighter Type";
         }
      }
      
      public function getFighterStatus(param1:Number) : uint
      {
         var _loc2_:GameFightFighterInformations = this.getFighterInfos(param1);
         if(!_loc2_)
         {
            return 1;
         }
         switch(true)
         {
            case _loc2_ is GameFightFighterNamedInformations:
               return (_loc2_ as GameFightFighterNamedInformations).status.statusId;
            default:
               return 1;
         }
      }
      
      public function getFighterLevel(param1:Number) : uint
      {
         var _loc2_:GameFightFighterInformations = null;
         var _loc3_:Monster = null;
         _loc2_ = this.getFighterInfos(param1);
         if(!_loc2_)
         {
            return 0;
         }
         switch(true)
         {
            case _loc2_ is GameFightMutantInformations:
               return (_loc2_ as GameFightMutantInformations).powerLevel;
            case _loc2_ is GameFightCharacterInformations:
               return (_loc2_ as GameFightCharacterInformations).level;
            case _loc2_ is GameFightCompanionInformations:
               return (_loc2_ as GameFightCompanionInformations).level;
            case _loc2_ is GameFightMonsterInformations:
               _loc3_ = Monster.getMonsterById((_loc2_ as GameFightMonsterInformations).creatureGenericId);
               return _loc3_.getMonsterGrade((_loc2_ as GameFightMonsterInformations).creatureGrade).level;
            case _loc2_ is GameFightTaxCollectorInformations:
               return (_loc2_ as GameFightTaxCollectorInformations).level;
            default:
               return 0;
         }
      }
      
      public function getChallengeById(param1:uint) : ChallengeWrapper
      {
         var _loc2_:ChallengeWrapper = null;
         for each(_loc2_ in this._challengesList)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:GameFightStartingMessage = null;
         var _loc4_:Sprite = null;
         var _loc5_:CurrentMapMessage = null;
         var _loc6_:WorldPointWrapper = null;
         var _loc7_:ByteArray = null;
         var _loc8_:GameContextReadyMessage = null;
         var _loc9_:MapsLoadingCompleteMessage = null;
         var _loc10_:GameFightResumeMessage = null;
         var _loc11_:Number = NaN;
         var _loc12_:Vector.<GameFightResumeSlaveInfo> = null;
         var _loc13_:GameFightResumeSlaveInfo = null;
         var _loc14_:CurrentPlayedFighterManager = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:GameFightResumeSlaveInfo = null;
         var _loc18_:SpellCastInFightManager = null;
         var _loc19_:Array = null;
         var _loc20_:Array = null;
         var _loc21_:Array = null;
         var _loc22_:CastingSpell = null;
         var _loc23_:uint = 0;
         var _loc24_:FightDispellableEffectExtendedInformations = null;
         var _loc25_:GameFightUpdateTeamMessage = null;
         var _loc26_:GameFightSpectateMessage = null;
         var _loc27_:Number = NaN;
         var _loc28_:String = null;
         var _loc29_:String = null;
         var _loc30_:Array = null;
         var _loc31_:Array = null;
         var _loc32_:Array = null;
         var _loc33_:CastingSpell = null;
         var _loc34_:GameFightSpectatorJoinMessage = null;
         var _loc35_:int = 0;
         var _loc36_:String = null;
         var _loc37_:String = null;
         var _loc38_:GameFightJoinMessage = null;
         var _loc39_:int = 0;
         var _loc40_:GameActionFightCarryCharacterMessage = null;
         var _loc41_:GameFightStartMessage = null;
         var _loc42_:CellOverMessage = null;
         var _loc43_:AnimatedCharacter = null;
         var _loc44_:MarkedCellsManager = null;
         var _loc45_:MarkInstance = null;
         var _loc46_:CellOutMessage = null;
         var _loc47_:AnimatedCharacter = null;
         var _loc48_:MarkedCellsManager = null;
         var _loc49_:MarkInstance = null;
         var _loc50_:EntityMouseOverMessage = null;
         var _loc51_:EntityMouseOutMessage = null;
         var _loc52_:GameFightLeaveMessage = null;
         var _loc53_:TimelineEntityOverAction = null;
         var _loc54_:FightSpellCastFrame = null;
         var _loc55_:TimelineEntityOutAction = null;
         var _loc56_:Number = NaN;
         var _loc57_:Vector.<Number> = null;
         var _loc58_:TogglePointCellAction = null;
         var _loc59_:GameFightEndMessage = null;
         var _loc60_:ChallengeTargetsListRequestAction = null;
         var _loc61_:ChallengeTargetsListRequestMessage = null;
         var _loc62_:ChallengeTargetsListMessage = null;
         var _loc63_:ChallengeInfoMessage = null;
         var _loc64_:ChallengeWrapper = null;
         var _loc65_:ChallengeTargetUpdateMessage = null;
         var _loc66_:ChallengeResultMessage = null;
         var _loc67_:ArenaFighterLeaveMessage = null;
         var _loc68_:MapObstacleUpdateMessage = null;
         var _loc69_:GameActionFightNoSpellCastMessage = null;
         var _loc70_:uint = 0;
         var _loc71_:String = null;
         var _loc72_:GameFightResumeWithSlavesMessage = null;
         var _loc73_:BasicBuff = null;
         var _loc74_:NamedPartyTeam = null;
         var _loc75_:FightDispellableEffectExtendedInformations = null;
         var _loc76_:BasicBuff = null;
         var _loc77_:NamedPartyTeam = null;
         var _loc78_:IEntity = null;
         var _loc79_:MarkInstance = null;
         var _loc80_:Glyph = null;
         var _loc81_:Vector.<MapPoint> = null;
         var _loc82_:Vector.<uint> = null;
         var _loc83_:IEntity = null;
         var _loc84_:MarkInstance = null;
         var _loc85_:Glyph = null;
         var _loc86_:FightEndingMessage = null;
         var _loc87_:Vector.<FightResultEntryWrapper> = null;
         var _loc88_:uint = 0;
         var _loc89_:FightResultEntryWrapper = null;
         var _loc90_:Vector.<FightResultEntryWrapper> = null;
         var _loc91_:Array = null;
         var _loc92_:FightResultListEntry = null;
         var _loc93_:String = null;
         var _loc94_:String = null;
         var _loc95_:NamedPartyTeamWithOutcome = null;
         var _loc96_:Object = null;
         var _loc97_:Vector.<uint> = null;
         var _loc98_:FightResultEntryWrapper = null;
         var _loc99_:Number = NaN;
         var _loc100_:FightResultListEntry = null;
         var _loc101_:uint = 0;
         var _loc102_:ItemWrapper = null;
         var _loc103_:int = 0;
         var _loc104_:int = 0;
         var _loc105_:FightResultEntryWrapper = null;
         var _loc106_:uint = 0;
         var _loc107_:int = 0;
         var _loc108_:Number = NaN;
         var _loc109_:MapObstacle = null;
         var _loc110_:SpellLevel = null;
         switch(true)
         {
            case param1 is MapLoadedMessage:
               MapDisplayManager.getInstance().getDataMapContainer().setTemporaryAnimatedElementState(false);
               return true;
            case param1 is GameFightStartingMessage:
               _loc3_ = param1 as GameFightStartingMessage;
               _loc4_ = Atouin.getInstance().getWorldMask("treasureHinting",false);
               if(_loc4_ && _loc4_.visible)
               {
                  Atouin.getInstance().toggleWorldMask("treasureHinting",false);
                  this._mustShowTreasureHuntMask = true;
               }
               else
               {
                  this._mustShowTreasureHuntMask = false;
               }
               TooltipManager.hideAll();
               Atouin.getInstance().cancelZoom();
               KernelEventsManager.getInstance().processCallback(HookList.StartZoom,false);
               MapDisplayManager.getInstance().activeIdentifiedElements(false);
               FightEventsHelper.reset();
               KernelEventsManager.getInstance().processCallback(HookList.GameFightStarting,_loc3_.fightType);
               this.fightType = _loc3_.fightType;
               this._fightAttackerId = _loc3_.attackerId;
               CurrentPlayedFighterManager.getInstance().currentFighterId = PlayedCharacterManager.getInstance().id;
               CurrentPlayedFighterManager.getInstance().getSpellCastManager().currentTurn = 0;
               SoundManager.getInstance().manager.playFightMusic();
               SoundManager.getInstance().manager.playUISound(UISoundEnum.INTRO_FIGHT);
               return true;
            case param1 is CurrentMapMessage:
               _loc5_ = param1 as CurrentMapMessage;
               ConnectionsHandler.pause();
               Kernel.getWorker().pause();
               if(TacticModeManager.getInstance().tacticModeActivated)
               {
                  TacticModeManager.getInstance().hide();
               }
               _loc6_ = new WorldPointWrapper(_loc5_.mapId);
               KernelEventsManager.getInstance().processCallback(HookList.StartZoom,false);
               Atouin.getInstance().initPreDisplay(_loc6_);
               Atouin.getInstance().clearEntities();
               if(_loc5_.mapKey && _loc5_.mapKey.length)
               {
                  _loc71_ = XmlConfig.getInstance().getEntry("config.maps.encryptionKey");
                  if(!_loc71_)
                  {
                     _loc71_ = _loc5_.mapKey;
                  }
                  _loc7_ = Hex.toArray(Hex.fromString(_loc71_));
               }
               this._currentMapRenderId = Atouin.getInstance().display(_loc6_,_loc7_);
               _log.info("Ask map render for fight #" + this._currentMapRenderId);
               PlayedCharacterManager.getInstance().currentMap = _loc6_;
               KernelEventsManager.getInstance().processCallback(HookList.CurrentMap,_loc5_.mapId);
               return false;
            case param1 is MapsLoadingCompleteMessage:
               _log.info("MapsLoadingCompleteMessage #" + MapsLoadingCompleteMessage(param1).renderRequestId);
               if(this._currentMapRenderId != MapsLoadingCompleteMessage(param1).renderRequestId)
               {
                  return false;
               }
               Atouin.getInstance().showWorld(true);
               Atouin.getInstance().displayGrid(true,true);
               Atouin.getInstance().cellOverEnabled = true;
               _loc8_ = new GameContextReadyMessage();
               _loc8_.initGameContextReadyMessage(MapDisplayManager.getInstance().currentMapPoint.mapId);
               ConnectionsHandler.getConnection().send(_loc8_);
               _loc9_ = param1 as MapsLoadingCompleteMessage;
               SoundManager.getInstance().manager.setSubArea(_loc9_.mapData);
               Kernel.getWorker().resume();
               ConnectionsHandler.resume();
               return true;
            case param1 is GameFightResumeMessage:
               _loc10_ = param1 as GameFightResumeMessage;
               _loc11_ = PlayedCharacterManager.getInstance().id;
               this.tacticModeHandler();
               CurrentPlayedFighterManager.getInstance().setCurrentSummonedCreature(_loc10_.summonCount,_loc11_);
               CurrentPlayedFighterManager.getInstance().setCurrentSummonedBomb(_loc10_.bombCount,_loc11_);
               this._battleFrame.turnsCount = _loc10_.gameTurn - 1;
               KernelEventsManager.getInstance().processCallback(FightHookList.TurnCountUpdated,_loc10_.gameTurn - 1);
               this._fightIdols = _loc10_.idols;
               KernelEventsManager.getInstance().processCallback(FightHookList.FightIdolList,_loc10_.idols);
               if(param1 is GameFightResumeWithSlavesMessage)
               {
                  _loc72_ = param1 as GameFightResumeWithSlavesMessage;
                  _loc12_ = _loc72_.slavesInfo;
               }
               else
               {
                  _loc12_ = new Vector.<GameFightResumeSlaveInfo>();
               }
               _loc13_ = new GameFightResumeSlaveInfo();
               _loc13_.spellCooldowns = _loc10_.spellCooldowns;
               _loc13_.slaveId = PlayedCharacterManager.getInstance().id;
               _loc12_.unshift(_loc13_);
               _loc14_ = CurrentPlayedFighterManager.getInstance();
               _loc16_ = _loc12_.length;
               _loc15_ = 0;
               while(_loc15_ < _loc16_)
               {
                  _loc17_ = _loc12_[_loc15_];
                  _loc18_ = _loc14_.getSpellCastManagerById(_loc17_.slaveId);
                  _loc18_.currentTurn = _loc10_.gameTurn - 1;
                  _loc18_.updateCooldowns(_loc12_[_loc15_].spellCooldowns);
                  if(_loc17_.slaveId != _loc11_)
                  {
                     CurrentPlayedFighterManager.getInstance().setCurrentSummonedCreature(_loc17_.summonCount,_loc17_.slaveId);
                     CurrentPlayedFighterManager.getInstance().setCurrentSummonedBomb(_loc17_.bombCount,_loc17_.slaveId);
                  }
                  _loc15_++;
               }
               _loc19_ = [];
               _loc23_ = _loc10_.effects.length;
               _loc15_ = 0;
               while(_loc15_ < _loc23_)
               {
                  _loc24_ = _loc10_.effects[_loc15_];
                  if(!_loc19_[_loc24_.effect.targetId])
                  {
                     _loc19_[_loc24_.effect.targetId] = [];
                  }
                  _loc20_ = _loc19_[_loc24_.effect.targetId];
                  if(!_loc20_[_loc24_.effect.turnDuration])
                  {
                     _loc20_[_loc24_.effect.turnDuration] = [];
                  }
                  _loc21_ = _loc20_[_loc24_.effect.turnDuration];
                  _loc22_ = _loc21_[_loc24_.effect.spellId];
                  if(!_loc22_)
                  {
                     _loc22_ = new CastingSpell();
                     _loc22_.casterId = _loc24_.sourceId;
                     _loc22_.spell = Spell.getSpellById(_loc24_.effect.spellId);
                     _loc21_[_loc24_.effect.spellId] = _loc22_;
                  }
                  _loc73_ = BuffManager.makeBuffFromEffect(_loc24_.effect,_loc22_,_loc24_.actionId);
                  BuffManager.getInstance().addBuff(_loc73_);
                  _loc15_++;
               }
               this.addMarks(_loc10_.marks);
               Kernel.beingInReconection = false;
               return true;
            case param1 is GameFightUpdateTeamMessage:
               _loc25_ = param1 as GameFightUpdateTeamMessage;
               PlayedCharacterManager.getInstance().teamId = _loc25_.team.teamId;
               return true;
            case param1 is GameFightSpectateMessage:
               _loc26_ = param1 as GameFightSpectateMessage;
               this.tacticModeHandler();
               this._battleFrame.turnsCount = _loc26_.gameTurn - 1;
               KernelEventsManager.getInstance().processCallback(FightHookList.TurnCountUpdated,_loc26_.gameTurn - 1);
               this._fightIdols = _loc26_.idols;
               KernelEventsManager.getInstance().processCallback(FightHookList.FightIdolList,_loc26_.idols);
               _loc27_ = _loc26_.fightStart;
               _loc28_ = "";
               _loc29_ = "";
               for each(_loc74_ in this._namedPartyTeams)
               {
                  if(_loc74_.partyName && _loc74_.partyName != "")
                  {
                     if(_loc74_.teamId == TeamEnum.TEAM_CHALLENGER)
                     {
                        _loc28_ = _loc74_.partyName;
                     }
                     else if(_loc74_.teamId == TeamEnum.TEAM_DEFENDER)
                     {
                        _loc29_ = _loc74_.partyName;
                     }
                  }
               }
               KernelEventsManager.getInstance().processCallback(FightHookList.SpectateUpdate,_loc27_,_loc28_,_loc29_);
               _loc30_ = [];
               for each(_loc75_ in _loc26_.effects)
               {
                  if(!_loc30_[_loc75_.effect.targetId])
                  {
                     _loc30_[_loc75_.effect.targetId] = [];
                  }
                  _loc31_ = _loc30_[_loc75_.effect.targetId];
                  if(!_loc31_[_loc75_.effect.turnDuration])
                  {
                     _loc31_[_loc75_.effect.turnDuration] = [];
                  }
                  _loc32_ = _loc31_[_loc75_.effect.turnDuration];
                  _loc33_ = _loc32_[_loc75_.effect.spellId];
                  if(!_loc33_)
                  {
                     _loc33_ = new CastingSpell();
                     _loc33_.casterId = _loc75_.sourceId;
                     _loc33_.spell = Spell.getSpellById(_loc75_.effect.spellId);
                     _loc32_[_loc75_.effect.spellId] = _loc33_;
                  }
                  _loc76_ = BuffManager.makeBuffFromEffect(_loc75_.effect,_loc33_,_loc75_.actionId);
                  BuffManager.getInstance().addBuff(_loc76_,!(_loc76_ is StatBuff));
               }
               this.addMarks(_loc26_.marks);
               FightEventsHelper.sendAllFightEvent();
               return true;
            case param1 is GameFightSpectatorJoinMessage:
               _loc34_ = param1 as GameFightSpectatorJoinMessage;
               preFightIsActive = !_loc34_.isFightStarted;
               this.fightType = _loc34_.fightType;
               Kernel.getWorker().addFrame(this._entitiesFrame);
               if(preFightIsActive)
               {
                  Kernel.getWorker().addFrame(this._preparationFrame);
               }
               else
               {
                  Kernel.getWorker().removeFrame(this._preparationFrame);
                  Kernel.getWorker().addFrame(this._battleFrame);
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightStart);
               }
               PlayedCharacterManager.getInstance().isSpectator = true;
               PlayedCharacterManager.getInstance().isFighting = true;
               _loc35_ = _loc34_.timeMaxBeforeFightStart * 100;
               if(_loc35_ == 0 && preFightIsActive)
               {
                  _loc35_ = -1;
               }
               KernelEventsManager.getInstance().processCallback(HookList.GameFightJoin,_loc34_.canBeCancelled,_loc34_.canSayReady,true,_loc35_,_loc34_.fightType,_loc34_.isTeamPhase);
               this._namedPartyTeams = _loc34_.namedPartyTeams;
               _loc36_ = "";
               _loc37_ = "";
               for each(_loc77_ in _loc34_.namedPartyTeams)
               {
                  if(_loc77_.partyName && _loc77_.partyName != "")
                  {
                     if(_loc77_.teamId == TeamEnum.TEAM_CHALLENGER)
                     {
                        _loc36_ = _loc77_.partyName;
                     }
                     else if(_loc77_.teamId == TeamEnum.TEAM_DEFENDER)
                     {
                        _loc37_ = _loc77_.partyName;
                     }
                  }
               }
               KernelEventsManager.getInstance().processCallback(FightHookList.SpectateUpdate,0,_loc36_,_loc37_);
               return true;
            case param1 is INetworkMessage && INetworkMessage(param1).getMessageId() == GameFightJoinMessage.protocolId:
               _loc38_ = param1 as GameFightJoinMessage;
               preFightIsActive = !_loc38_.isFightStarted;
               this.fightType = _loc38_.fightType;
               if(!Kernel.getWorker().contains(FightEntitiesFrame))
               {
                  Kernel.getWorker().addFrame(this._entitiesFrame);
               }
               if(preFightIsActive)
               {
                  if(!Kernel.getWorker().contains(FightPreparationFrame))
                  {
                     Kernel.getWorker().addFrame(this._preparationFrame);
                  }
                  this.onlyTheOtherTeamCanPlace = !_loc38_.isTeamPhase;
               }
               else
               {
                  Kernel.getWorker().removeFrame(this._preparationFrame);
                  Kernel.getWorker().addFrame(this._battleFrame);
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightStart);
                  this.onlyTheOtherTeamCanPlace = false;
               }
               PlayedCharacterManager.getInstance().isSpectator = false;
               PlayedCharacterManager.getInstance().isFighting = true;
               _loc39_ = _loc38_.timeMaxBeforeFightStart * 100;
               if(_loc39_ == 0 && preFightIsActive)
               {
                  _loc39_ = -1;
               }
               KernelEventsManager.getInstance().processCallback(HookList.GameFightJoin,_loc38_.canBeCancelled,_loc38_.canSayReady,false,_loc39_,_loc38_.fightType,_loc38_.isTeamPhase);
               return true;
            case param1 is GameActionFightCarryCharacterMessage:
               _loc40_ = param1 as GameActionFightCarryCharacterMessage;
               if(this._lastEffectEntity && this._lastEffectEntity.object.id == _loc40_.targetId)
               {
                  this.process(new EntityMouseOutMessage(this._lastEffectEntity.object as IInteractive));
               }
               return false;
            case param1 is GameFightStartMessage:
               _loc41_ = param1 as GameFightStartMessage;
               preFightIsActive = false;
               Kernel.getWorker().removeFrame(this._preparationFrame);
               this._entitiesFrame.removeSwords();
               CurrentPlayedFighterManager.getInstance().getSpellCastManager().resetInitialCooldown();
               Kernel.getWorker().addFrame(this._battleFrame);
               KernelEventsManager.getInstance().processCallback(HookList.GameFightStart);
               this._fightIdols = _loc41_.idols;
               KernelEventsManager.getInstance().processCallback(FightHookList.FightIdolList,_loc41_.idols);
               return true;
            case param1 is GameContextDestroyMessage:
               TooltipManager.hide();
               Kernel.getWorker().removeFrame(this);
               return true;
            case param1 is CellOverMessage:
               _loc42_ = param1 as CellOverMessage;
               for each(_loc78_ in EntitiesManager.getInstance().getEntitiesOnCell(_loc42_.cellId))
               {
                  if(_loc78_ is AnimatedCharacter && !(_loc78_ as AnimatedCharacter).isMoving)
                  {
                     _loc43_ = _loc78_ as AnimatedCharacter;
                     break;
                  }
               }
               currentCell = _loc42_.cellId;
               if(_loc43_)
               {
                  this.overEntity(_loc43_.id);
               }
               _loc44_ = MarkedCellsManager.getInstance();
               _loc45_ = _loc44_.getMarkAtCellId(_loc42_.cellId,GameActionMarkTypeEnum.PORTAL);
               if(_loc45_)
               {
                  for each(_loc79_ in _loc44_.getMarks(_loc45_.markType,_loc45_.teamId,false))
                  {
                     _loc80_ = _loc44_.getGlyph(_loc79_.markId);
                     if(_loc80_ && _loc80_.lbl_number)
                     {
                        _loc80_.lbl_number.visible = true;
                     }
                  }
                  if(_loc45_.active && _loc44_.getActivePortalsCount(_loc45_.teamId) >= 2)
                  {
                     _loc81_ = _loc44_.getMarksMapPoint(GameActionMarkTypeEnum.PORTAL,_loc45_.teamId);
                     _loc82_ = LinkedCellsManager.getInstance().getLinks(MapPoint.fromCellId(_loc42_.cellId),_loc81_);
                     if(_loc82_)
                     {
                        LinkedCellsManager.getInstance().drawPortalLinks(_loc82_);
                     }
                  }
               }
               return true;
            case param1 is CellOutMessage:
               _loc46_ = param1 as CellOutMessage;
               for each(_loc83_ in EntitiesManager.getInstance().getEntitiesOnCell(_loc46_.cellId))
               {
                  if(_loc83_ is AnimatedCharacter)
                  {
                     _loc47_ = _loc83_ as AnimatedCharacter;
                     break;
                  }
               }
               currentCell = -1;
               if(_loc47_)
               {
                  TooltipManager.hide();
                  TooltipManager.hide("fighter");
                  this.outEntity(_loc47_.id);
               }
               _loc48_ = MarkedCellsManager.getInstance();
               _loc49_ = _loc48_.getMarkAtCellId(_loc46_.cellId,GameActionMarkTypeEnum.PORTAL);
               if(_loc49_)
               {
                  for each(_loc84_ in _loc48_.getMarks(_loc49_.markType,_loc49_.teamId,false))
                  {
                     _loc85_ = _loc48_.getGlyph(_loc84_.markId);
                     if(_loc85_ && _loc85_.lbl_number)
                     {
                        _loc85_.lbl_number.visible = false;
                     }
                  }
               }
               LinkedCellsManager.getInstance().clearLinks();
               return true;
            case param1 is EntityMouseOverMessage:
               _loc50_ = param1 as EntityMouseOverMessage;
               currentCell = _loc50_.entity.position.cellId;
               this.overEntity(_loc50_.entity.id);
               return true;
            case param1 is EntityMouseOutMessage:
               _loc51_ = param1 as EntityMouseOutMessage;
               currentCell = -1;
               this.outEntity(_loc51_.entity.id);
               return true;
            case param1 is GameFightLeaveMessage:
               _loc52_ = param1 as GameFightLeaveMessage;
               if(TooltipManager.isVisible("tooltipOverEntity_" + _loc52_.charId))
               {
                  currentCell = -1;
                  this.outEntity(_loc52_.charId);
               }
               return false;
            case param1 is TimelineEntityOverAction:
               _loc53_ = param1 as TimelineEntityOverAction;
               this._timelineOverEntity = true;
               this._timelineOverEntityId = _loc53_.targetId;
               _loc54_ = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame;
               if(!_loc54_)
               {
                  this.removeSpellTargetsTooltips();
               }
               this.overEntity(_loc53_.targetId,_loc53_.showRange,_loc53_.highlightTimelineFighter);
               return true;
            case param1 is TimelineEntityOutAction:
               _loc55_ = param1 as TimelineEntityOutAction;
               _loc57_ = this._entitiesFrame.getEntitiesIdsList();
               for each(_loc56_ in _loc57_)
               {
                  if((!this._showPermanentTooltips || this._showPermanentTooltips && this._battleFrame.targetedEntities.indexOf(_loc56_) == -1) && _loc56_ != _loc55_.targetId)
                  {
                     TooltipManager.hide("tooltipOverEntity_" + _loc56_);
                  }
               }
               this._timelineOverEntity = false;
               this.outEntity(_loc55_.targetId);
               this.removeSpellTargetsTooltips();
               return true;
            case param1 is TogglePointCellAction:
               _loc58_ = param1 as TogglePointCellAction;
               if(Kernel.getWorker().contains(FightPointCellFrame))
               {
                  KernelEventsManager.getInstance().processCallback(HookList.ShowCell);
                  Kernel.getWorker().removeFrame(this._pointCellFrame);
               }
               else
               {
                  Kernel.getWorker().addFrame(this._pointCellFrame);
               }
               return true;
            case param1 is GameFightEndMessage:
               _loc59_ = param1 as GameFightEndMessage;
               if(TacticModeManager.getInstance().tacticModeActivated)
               {
                  TacticModeManager.getInstance().hide(true);
               }
               if(this._entitiesFrame.isInCreaturesFightMode())
               {
                  this._entitiesFrame.showCreaturesInFight(false);
               }
               if(this._mustShowTreasureHuntMask)
               {
                  Atouin.getInstance().toggleWorldMask("treasureHinting",true);
                  this._mustShowTreasureHuntMask = false;
               }
               TooltipManager.hide();
               TooltipManager.hide("fighter");
               this.hideMovementRange();
               CurrentPlayedFighterManager.getInstance().resetPlayerSpellList();
               MapDisplayManager.getInstance().activeIdentifiedElements(true);
               FightEventsHelper.sendAllFightEvent(true);
               if(!PlayedCharacterManager.getInstance().isSpectator)
               {
                  FightEventsHelper.sendFightEvent(FightEventEnum.FIGHT_END,[],0,-1,true);
               }
               SoundManager.getInstance().manager.stopFightMusic();
               PlayedCharacterManager.getInstance().isFighting = false;
               SpellWrapper.removeAllSpellWrapperBut(PlayedCharacterManager.getInstance().id,SecureCenter.ACCESS_KEY);
               SpellWrapper.resetAllCoolDown(PlayedCharacterManager.getInstance().id,SecureCenter.ACCESS_KEY);
               if(_loc59_.results == null)
               {
                  KernelEventsManager.getInstance().processCallback(FightHookList.SpectatorWantLeave);
               }
               else
               {
                  _loc86_ = new FightEndingMessage();
                  _loc86_.initFightEndingMessage();
                  Kernel.getWorker().process(_loc86_);
                  _loc87_ = new Vector.<FightResultEntryWrapper>();
                  _loc88_ = 0;
                  _loc90_ = new Vector.<FightResultEntryWrapper>();
                  _loc91_ = new Array();
                  for each(_loc92_ in _loc59_.results)
                  {
                     _loc91_.push(_loc92_);
                  }
                  _loc15_ = 0;
                  while(_loc15_ < _loc91_.length)
                  {
                     _loc100_ = _loc91_[_loc15_];
                     switch(true)
                     {
                        case _loc100_ is FightResultPlayerListEntry:
                           _loc99_ = (_loc100_ as FightResultPlayerListEntry).id;
                           _loc98_ = new FightResultEntryWrapper(_loc100_,this._entitiesFrame.getEntityInfos(_loc99_) as GameFightFighterInformations);
                           _loc98_.alive = FightResultPlayerListEntry(_loc100_).alive;
                           break;
                        case _loc100_ is FightResultTaxCollectorListEntry:
                           _loc99_ = (_loc100_ as FightResultTaxCollectorListEntry).id;
                           _loc98_ = new FightResultEntryWrapper(_loc100_,this._entitiesFrame.getEntityInfos(_loc99_) as GameFightFighterInformations);
                           _loc98_.alive = FightResultTaxCollectorListEntry(_loc100_).alive;
                           break;
                        case _loc100_ is FightResultFighterListEntry:
                           _loc99_ = (_loc100_ as FightResultFighterListEntry).id;
                           _loc98_ = new FightResultEntryWrapper(_loc100_,this._entitiesFrame.getEntityInfos(_loc99_) as GameFightFighterInformations);
                           _loc98_.alive = FightResultFighterListEntry(_loc100_).alive;
                           break;
                        case _loc100_ is FightResultListEntry:
                           _loc98_ = new FightResultEntryWrapper(_loc100_);
                     }
                     if(this._fightAttackerId == _loc99_)
                     {
                        _loc98_.fightInitiator = true;
                     }
                     else
                     {
                        _loc98_.fightInitiator = false;
                     }
                     _loc98_.wave = _loc100_.wave;
                     if(_loc15_ + 1 < _loc91_.length && _loc91_[_loc15_ + 1] && _loc91_[_loc15_ + 1].outcome == _loc100_.outcome && _loc91_[_loc15_ + 1].wave != _loc100_.wave)
                     {
                        _loc98_.isLastOfHisWave = true;
                     }
                     if(_loc100_.outcome == FightOutcomeEnum.RESULT_DEFENDER_GROUP)
                     {
                        _loc89_ = _loc98_;
                     }
                     else
                     {
                        if(_loc100_.outcome == FightOutcomeEnum.RESULT_VICTORY)
                        {
                           _loc90_.push(_loc98_);
                        }
                        _loc87_[_loc88_++] = _loc98_;
                     }
                     if(_loc98_.id == PlayedCharacterManager.getInstance().id)
                     {
                        switch(_loc100_.outcome)
                        {
                           case FightOutcomeEnum.RESULT_VICTORY:
                              KernelEventsManager.getInstance().processCallback(TriggerHookList.FightResultVictory);
                              SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_FIGHT_WON);
                              break;
                           case FightOutcomeEnum.RESULT_LOST:
                              SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_FIGHT_LOST);
                        }
                        if(_loc98_.rewards.objects.length >= SpeakingItemManager.GREAT_DROP_LIMIT)
                        {
                           SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_GREAT_DROP);
                        }
                     }
                     _loc15_++;
                  }
                  if(_loc89_)
                  {
                     _loc101_ = 0;
                     for each(_loc102_ in _loc89_.rewards.objects)
                     {
                        _loc90_[_loc101_].rewards.objects.push(_loc102_);
                        _loc101_++;
                        _loc101_ = _loc101_ % _loc90_.length;
                     }
                     _loc103_ = _loc89_.rewards.kamas;
                     _loc104_ = _loc103_ / _loc90_.length;
                     if(_loc103_ % _loc90_.length != 0)
                     {
                        _loc104_++;
                     }
                     for each(_loc105_ in _loc90_)
                     {
                        if(_loc103_ < _loc104_)
                        {
                           _loc105_.rewards.kamas = _loc103_;
                        }
                        else
                        {
                           _loc105_.rewards.kamas = _loc104_;
                        }
                        _loc103_ = _loc103_ - _loc105_.rewards.kamas;
                     }
                  }
                  _loc93_ = "";
                  _loc94_ = "";
                  for each(_loc95_ in _loc59_.namedPartyTeamsOutcomes)
                  {
                     if(_loc95_.team.partyName && _loc95_.team.partyName != "")
                     {
                        if(_loc95_.outcome == FightOutcomeEnum.RESULT_VICTORY)
                        {
                           _loc93_ = _loc95_.team.partyName;
                        }
                        else if(_loc95_.outcome == FightOutcomeEnum.RESULT_LOST)
                        {
                           _loc94_ = _loc95_.team.partyName;
                        }
                     }
                  }
                  _loc96_ = new Object();
                  _loc96_.results = _loc87_;
                  _loc96_.ageBonus = _loc59_.ageBonus;
                  _loc96_.sizeMalus = _loc59_.lootShareLimitMalus;
                  _loc96_.duration = _loc59_.duration;
                  _loc96_.challenges = this.challengesList;
                  _loc96_.turns = this._battleFrame.turnsCount;
                  _loc96_.fightType = this._fightType;
                  _loc96_.winnersName = _loc93_;
                  _loc96_.losersName = _loc94_;
                  _loc97_ = new Vector.<uint>();
                  if(this._fightIdols)
                  {
                     _loc106_ = this._fightIdols.length;
                     _loc107_ = 0;
                     while(_loc107_ < _loc106_)
                     {
                        _loc97_.push(this._fightIdols[_loc107_].id);
                        _loc107_++;
                     }
                  }
                  _loc96_.idols = _loc97_;
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightEnd,_loc96_);
               }
               Kernel.getWorker().removeFrame(this);
               return true;
            case param1 is ChallengeTargetsListRequestAction:
               _loc60_ = param1 as ChallengeTargetsListRequestAction;
               _loc61_ = new ChallengeTargetsListRequestMessage();
               _loc61_.initChallengeTargetsListRequestMessage(_loc60_.challengeId);
               ConnectionsHandler.getConnection().send(_loc61_);
               return true;
            case param1 is ChallengeTargetsListMessage:
               _loc62_ = param1 as ChallengeTargetsListMessage;
               for each(_loc108_ in _loc62_.targetCells)
               {
                  if(_loc108_ != -1)
                  {
                     HyperlinkShowCellManager.showCell(_loc108_);
                  }
               }
               return true;
            case param1 is ChallengeInfoMessage:
               _loc63_ = param1 as ChallengeInfoMessage;
               _loc64_ = this.getChallengeById(_loc63_.challengeId);
               if(!_loc64_)
               {
                  _loc64_ = new ChallengeWrapper();
                  this.challengesList.push(_loc64_);
               }
               _loc64_.id = _loc63_.challengeId;
               _loc64_.targetId = _loc63_.targetId;
               _loc64_.xpBonus = _loc63_.xpBonus;
               _loc64_.dropBonus = _loc63_.dropBonus;
               _loc64_.result = 0;
               KernelEventsManager.getInstance().processCallback(FightHookList.ChallengeInfoUpdate,this.challengesList);
               return true;
            case param1 is ChallengeTargetUpdateMessage:
               _loc65_ = param1 as ChallengeTargetUpdateMessage;
               _loc64_ = this.getChallengeById(_loc65_.challengeId);
               if(_loc64_ == null)
               {
                  _log.warn("Got a challenge result with no corresponding challenge (challenge id " + _loc65_.challengeId + "), skipping.");
                  return false;
               }
               _loc64_.targetId = _loc65_.targetId;
               KernelEventsManager.getInstance().processCallback(FightHookList.ChallengeInfoUpdate,this.challengesList);
               return true;
            case param1 is ChallengeResultMessage:
               _loc66_ = param1 as ChallengeResultMessage;
               _loc64_ = this.getChallengeById(_loc66_.challengeId);
               if(!_loc64_)
               {
                  _log.warn("Got a challenge result with no corresponding challenge (challenge id " + _loc66_.challengeId + "), skipping.");
                  return false;
               }
               _loc64_.result = !!_loc66_.success?uint(1):uint(2);
               KernelEventsManager.getInstance().processCallback(FightHookList.ChallengeInfoUpdate,this.challengesList);
               return true;
            case param1 is ArenaFighterLeaveMessage:
               _loc67_ = param1 as ArenaFighterLeaveMessage;
               KernelEventsManager.getInstance().processCallback(FightHookList.ArenaFighterLeave,_loc67_.leaver);
               return true;
            case param1 is MapObstacleUpdateMessage:
               _loc68_ = param1 as MapObstacleUpdateMessage;
               for each(_loc109_ in _loc68_.obstacles)
               {
                  InteractiveCellManager.getInstance().updateCell(_loc109_.obstacleCellId,_loc109_.state == MapObstacleStateEnum.OBSTACLE_OPENED);
               }
               return true;
            case param1 is GameActionFightNoSpellCastMessage:
               _loc69_ = param1 as GameActionFightNoSpellCastMessage;
               if(_loc69_.spellLevelId != 0 || !PlayedCharacterManager.getInstance().currentWeapon)
               {
                  if(_loc69_.spellLevelId == 0)
                  {
                     _loc110_ = Spell.getSpellById(0).getSpellLevel(1);
                  }
                  else
                  {
                     _loc110_ = SpellLevel.getLevelById(_loc69_.spellLevelId);
                  }
                  _loc70_ = _loc110_.apCost;
               }
               else
               {
                  _loc70_ = PlayedCharacterManager.getInstance().currentWeapon.apCost;
               }
               CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent + _loc70_;
               return true;
            case param1 is ShowTacticModeAction:
               if(PlayedCharacterApi.getInstance().isInPreFight())
               {
                  return false;
               }
               if(PlayedCharacterApi.getInstance().isInFight() || PlayedCharacterManager.getInstance().isSpectator)
               {
                  this.tacticModeHandler(true);
               }
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         if(TacticModeManager.getInstance().tacticModeActivated)
         {
            TacticModeManager.getInstance().hide(true);
         }
         if(this._entitiesFrame)
         {
            Kernel.getWorker().removeFrame(this._entitiesFrame);
         }
         if(this._preparationFrame)
         {
            Kernel.getWorker().removeFrame(this._preparationFrame);
         }
         if(this._battleFrame)
         {
            Kernel.getWorker().removeFrame(this._battleFrame);
         }
         if(this._pointCellFrame)
         {
            Kernel.getWorker().removeFrame(this._pointCellFrame);
         }
         SerialSequencer.clearByType(FightSequenceFrame.FIGHT_SEQUENCERS_CATEGORY);
         this._preparationFrame = null;
         this._battleFrame = null;
         this._pointCellFrame = null;
         this._lastEffectEntity = null;
         this.removeSpellTargetsTooltips();
         TooltipManager.hideAll();
         this._timerFighterInfo.reset();
         this._timerFighterInfo.removeEventListener(TimerEvent.TIMER,this.showFighterInfo);
         this._timerFighterInfo = null;
         this._timerMovementRange.reset();
         this._timerMovementRange.removeEventListener(TimerEvent.TIMER,this.showMovementRange);
         this._timerMovementRange = null;
         this._currentFighterInfo = null;
         if(MapDisplayManager.getInstance().getDataMapContainer())
         {
            MapDisplayManager.getInstance().getDataMapContainer().setTemporaryAnimatedElementState(true);
         }
         Atouin.getInstance().displayGrid(false);
         OptionManager.getOptionManager("dofus").removeEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         Berilia.getInstance().removeEventListener(UiUnloadEvent.UNLOAD_UI_COMPLETE,this.onUiUnloaded);
         if(this._hideTooltipsTimer)
         {
            this._hideTooltipsTimer.removeEventListener(TimerEvent.TIMER,this.onShowPermanentTooltips);
            this._hideTooltipsTimer.stop();
         }
         if(this._hideTooltipTimer)
         {
            this._hideTooltipTimer.removeEventListener(TimerEvent.TIMER,this.onShowTooltip);
            this._hideTooltipTimer.stop();
         }
         var simf:SpellInventoryManagementFrame = Kernel.getWorker().getFrame(SpellInventoryManagementFrame) as SpellInventoryManagementFrame;
         simf.deleteSpellsGlobalCoolDownsData();
         PlayedCharacterManager.getInstance().isSpectator = false;
         Berilia.getInstance().removeEventListener(UiUnloadEvent.UNLOAD_UI_STARTED,this.onUiUnloadStarted);
         Berilia.getInstance().removeEventListener(TooltipEvent.TOOLTIPS_ORDERED,this.onTooltipsOrdered);
         try
         {
            Berilia.getInstance().uiSavedModificationPresetName = null;
         }
         catch(error:Error)
         {
            _log.error("Failed to reset uiSavedModificationPresetName!\n" + error.message + "\n" + error.getStackTrace());
         }
         return true;
      }
      
      public function outEntity(param1:Number) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc9_:Array = null;
         var _loc10_:AnimatedCharacter = null;
         this._timerFighterInfo.reset();
         this._timerMovementRange.reset();
         var _loc2_:Vector.<Number> = new Vector.<Number>(0);
         _loc2_.push(param1);
         var _loc3_:Vector.<Number> = this._entitiesFrame.getEntitiesIdsList();
         fighterEntityTooltipId = param1;
         var _loc4_:IEntity = DofusEntities.getEntity(fighterEntityTooltipId);
         if(!_loc4_ || !_loc4_.position)
         {
            if(_loc3_.indexOf(fighterEntityTooltipId) == -1)
            {
               _log.warn("Mouse out an unknown entity : " + param1);
               return;
            }
         }
         else
         {
            _loc9_ = EntitiesManager.getInstance().getEntitiesOnCell(_loc4_.position.cellId,AnimatedCharacter);
            for each(_loc10_ in _loc9_)
            {
               if(_loc2_.indexOf(_loc10_.id) == -1)
               {
                  _loc2_.push(_loc10_.id);
               }
            }
         }
         if(this._lastEffectEntity && this._lastEffectEntity.object)
         {
            Sprite(this._lastEffectEntity.object).filters = [];
         }
         this._lastEffectEntity = null;
         for each(_loc5_ in _loc2_)
         {
            _loc6_ = "tooltipOverEntity_" + _loc5_;
            if((!this._showPermanentTooltips || this._showPermanentTooltips && this.battleFrame.targetedEntities.indexOf(_loc5_) == -1) && TooltipManager.isVisible(_loc6_))
            {
               TooltipManager.hide(_loc6_);
            }
         }
         if(this._showPermanentTooltips)
         {
            for each(_loc5_ in this.battleFrame.targetedEntities)
            {
               this.displayEntityTooltip(_loc5_);
            }
         }
         if(_loc4_ != null)
         {
            Sprite(_loc4_).filters = [];
         }
         this.hideMovementRange();
         var _loc7_:Selection = SelectionManager.getInstance().getSelection(this.INVISIBLE_POSITION_SELECTION);
         if(_loc7_)
         {
            _loc7_.remove();
         }
         this.removeAsLinkEntityEffect();
         if(this._currentFighterInfo && this._currentFighterInfo.contextualId == param1)
         {
            KernelEventsManager.getInstance().processCallback(FightHookList.FighterInfoUpdate,null);
            if(PlayedCharacterManager.getInstance().isSpectator && OptionManager.getOptionManager("dofus")["spectatorAutoShowCurrentFighterInfo"] == true)
            {
               KernelEventsManager.getInstance().processCallback(FightHookList.FighterInfoUpdate,FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._battleFrame.currentPlayerId) as GameFightFighterInformations);
            }
         }
         var _loc8_:FightPreparationFrame = Kernel.getWorker().getFrame(FightPreparationFrame) as FightPreparationFrame;
         if(_loc8_)
         {
            _loc8_.updateSwapPositionRequestsIcons();
         }
      }
      
      public function removeSpellTargetsTooltips() : void
      {
         var _loc1_:* = undefined;
         PushUtil.reset();
         for(_loc1_ in this._spellTargetsTooltips)
         {
            TooltipPlacer.removeTooltipPositionByName("tooltip_tooltipOverEntity_" + _loc1_);
            delete this._spellTargetsTooltips[_loc1_];
            TooltipManager.hide("tooltipOverEntity_" + _loc1_);
            SpellDamagesManager.getInstance().removeSpellDamages(_loc1_);
            if(this._showPermanentTooltips && this._battleFrame && this._battleFrame.targetedEntities.indexOf(_loc1_) != -1)
            {
               this.displayEntityTooltip(_loc1_);
            }
         }
      }
      
      public function displayEntityTooltip(param1:Number, param2:Object = null, param3:SpellDamageInfo = null, param4:Boolean = false, param5:int = -1, param6:Object = null) : void
      {
         var updateTime:uint = 0;
         var entity:IDisplayable = null;
         var infos:GameFightFighterInformations = null;
         var params:Object = null;
         var spellImpactCell:uint = 0;
         var entityDamagedOrHealedBySpell:Boolean = false;
         var showDamages:Boolean = false;
         var spellZone:IZone = null;
         var spellZoneCells:Vector.<uint> = null;
         var hideTooltip:Boolean = false;
         var emptySpellDamage:Boolean = false;
         var ac:AnimatedCharacter = null;
         var sdi:SpellDamageInfo = null;
         var currentSpellDamage:SpellDamage = null;
         var effect:EffectDamage = null;
         var targetId:Number = NaN;
         var entitySpellDamage:Object = null;
         var ed:EffectDamage = null;
         var entityId:Number = NaN;
         var directDamageSpell:SpellWrapper = null;
         var nbPushedEntities:uint = 0;
         var pushedEntity:PushedEntity = null;
         var i:int = 0;
         var entityPushed:Boolean = false;
         var pushedEntitySdi:SpellDamageInfo = null;
         var allTargets:Vector.<Number> = null;
         var ts:TriggeredSpell = null;
         var damageSharingMultiplier:Number = NaN;
         var checkTargetTriggeredSpells:Boolean = false;
         var triggeredSpells:Vector.<TriggeredSpell> = null;
         var criticalTriggeredSpells:Vector.<TriggeredSpell> = null;
         var splashdmg:SplashDamage = null;
         var splashDamages:Vector.<SplashDamage> = null;
         var damageSharingTargets:Vector.<Number> = null;
         var originalTarget:Number = NaN;
         var sharedDamage:SpellDamage = null;
         var targetDamage:SpellDamage = null;
         var targetDamageEffect:EffectDamage = null;
         var targetsIds:Vector.<Number> = null;
         var targetsDamages:Dictionary = null;
         var finalSharedDamage:EffectDamage = null;
         var targetHeal:EffectDamage = null;
         var splashDmg:SplashDamage = null;
         var triggeredSpellOnTargetSdi:SpellDamageInfo = null;
         var triggeredSpellDamageShared:Boolean = false;
         var entitySdi:SpellDamageInfo = null;
         var interceptedDmg:InterceptedDamage = null;
         var computedEffect:EffectDamage = null;
         var triggeredSpellDamage:SpellDamage = null;
         var criticalTriggeredSpellDamage:SpellDamage = null;
         var esd:Object = null;
         var critEffects:Vector.<EffectDamage> = null;
         var critEffect:EffectDamage = null;
         var casterIndex:int = 0;
         var idx:int = 0;
         var numTargets:uint = 0;
         var allTargetsTooltipsVisible:Boolean = false;
         var hasInterceptedDamage:Boolean = false;
         var casterSdi:SpellDamageInfo = null;
         var intercepted:InterceptedDamage = null;
         var interceptedMaximizedEffects:Boolean = false;
         var interceptorSpellDamages:Object = null;
         var interceptorSdi:SpellDamageInfo = null;
         var interceptedDamageIndex:int = 0;
         var interceptorIndex:int = 0;
         var spellDamage:SpellDamage = null;
         var delta:int = 0;
         var pEntityId:Number = param1;
         var pSpell:Object = param2;
         var pSpellInfo:SpellDamageInfo = param3;
         var pForceRefresh:Boolean = param4;
         var pSpellImpactCell:int = param5;
         var pMakerParams:Object = param6;
         try
         {
            updateTime = getTimer();
            this._tooltipLastUpdate[pEntityId] = updateTime;
            entity = DofusEntities.getEntity(pEntityId) as IDisplayable;
            infos = this._entitiesFrame.getEntityInfos(pEntityId) as GameFightFighterInformations;
            if(!entity || !infos || infos.disposition.cellId == -1 || this._battleFrame.targetedEntities.indexOf(pEntityId) != -1 && this._hideTooltips || !EntitiesManager.getInstance().getEntity(pEntityId))
            {
               return;
            }
            params = pMakerParams;
            if(infos.disposition.cellId != currentCell && !(this._timelineOverEntity && pEntityId == this.timelineOverEntityId))
            {
               if(!params)
               {
                  params = new Object();
               }
               params.showName = false;
            }
            spellImpactCell = pSpellImpactCell != -1?uint(pSpellImpactCell):uint(currentCell);
            if(pSpell && !pSpellInfo)
            {
               ac = entity as AnimatedCharacter;
               entityDamagedOrHealedBySpell = pSpell && DamageUtil.isDamagedOrHealedBySpell(CurrentPlayedFighterManager.getInstance().currentFighterId,pEntityId,pSpell,spellImpactCell);
               if(ac && ac.parentSprite && ac.parentSprite.carriedEntity == ac && !entityDamagedOrHealedBySpell)
               {
                  TooltipPlacer.removeTooltipPositionByName("tooltip_tooltipOverEntity_" + pEntityId);
                  return;
               }
            }
            showDamages = pSpell && OptionManager.getOptionManager("dofus")["showDamagesPreview"] == true && FightSpellCastFrame.isCurrentTargetTargetable();
            if(showDamages)
            {
               if(!pForceRefresh && this._spellTargetsTooltips[pEntityId])
               {
                  return;
               }
               spellZone = SpellZoneManager.getInstance().getSpellZone(pSpell);
               spellZoneCells = spellZone.getCells(spellImpactCell);
               if(!pSpellInfo)
               {
                  if(entityDamagedOrHealedBySpell)
                  {
                     if(DamageUtil.BOMB_SPELLS_IDS.indexOf(pSpell.id) != -1)
                     {
                        directDamageSpell = DamageUtil.getBombDirectDamageSpellWrapper(pSpell as SpellWrapper);
                        sdi = SpellDamageInfo.fromCurrentPlayer(directDamageSpell,pEntityId,spellImpactCell);
                        for each(targetId in sdi.originalTargetsIds)
                        {
                           this.displayEntityTooltip(targetId,directDamageSpell,sdi);
                        }
                        return;
                     }
                     sdi = SpellDamageInfo.fromCurrentPlayer(pSpell,pEntityId,spellImpactCell);
                     if(pSpell is SpellWrapper)
                     {
                        sdi.pushedEntities = PushUtil.getPushedEntities(pSpell as SpellWrapper,this.entitiesFrame.getEntityInfos(pSpell.playerId).disposition.cellId,spellImpactCell);
                        nbPushedEntities = !!sdi.pushedEntities?uint(sdi.pushedEntities.length):uint(0);
                        if(nbPushedEntities > 0)
                        {
                           i = 0;
                           while(i < nbPushedEntities)
                           {
                              pushedEntity = sdi.pushedEntities[i];
                              if(!entityPushed)
                              {
                                 entityPushed = pEntityId == pushedEntity.id;
                              }
                              if(pushedEntity.id == pEntityId)
                              {
                                 this.displayEntityTooltip(pushedEntity.id,pSpell,sdi,true);
                              }
                              else
                              {
                                 pushedEntitySdi = SpellDamageInfo.fromCurrentPlayer(pSpell,pushedEntity.id,spellImpactCell);
                                 pushedEntitySdi.pushedEntities = sdi.pushedEntities;
                                 this.displayEntityTooltip(pushedEntity.id,pSpell,pushedEntitySdi,true);
                              }
                              i++;
                           }
                           if(entityPushed)
                           {
                              return;
                           }
                        }
                     }
                  }
               }
               else
               {
                  sdi = pSpellInfo;
               }
               this._spellTargetsTooltips[pEntityId] = true;
               if(sdi)
               {
                  if(!params)
                  {
                     params = new Object();
                  }
                  if(sdi.targetId != pEntityId)
                  {
                     sdi.targetId = pEntityId;
                  }
                  allTargets = new Vector.<Number>(0);
                  if(!sdi.damageSharingTargets)
                  {
                     damageSharingTargets = sdi.getDamageSharingTargets();
                     sdi.damageSharingTargets = damageSharingTargets;
                     if(damageSharingTargets && damageSharingTargets.length > 1)
                     {
                        damageSharingMultiplier = 1 / damageSharingTargets.length;
                        sharedDamage = new SpellDamage();
                        targetsIds = new Vector.<Number>();
                        for each(originalTarget in sdi.originalTargetsIds)
                        {
                           if(damageSharingTargets.indexOf(originalTarget) != -1)
                           {
                              targetsIds.push(originalTarget);
                           }
                        }
                        if(targetsIds.indexOf(pEntityId) == -1 && sdi.splashDamages)
                        {
                           for each(splashdmg in sdi.splashDamages)
                           {
                              if(splashdmg.targets.indexOf(pEntityId) != -1)
                              {
                                 targetsIds.push(pEntityId);
                                 break;
                              }
                           }
                        }
                        targetsDamages = new Dictionary();
                        for each(originalTarget in targetsIds)
                        {
                           sdi.targetId = originalTarget;
                           sdi.spellHasLifeSteal = sdi.hasLifeSteal();
                           targetDamage = DamageUtil.getSpellDamage(sdi);
                           targetsDamages[originalTarget] = targetDamage;
                           for each(targetDamageEffect in targetDamage.effectDamages)
                           {
                              targetDamageEffect.applyDamageMultiplier(damageSharingMultiplier);
                              sharedDamage.addEffectDamage(targetDamageEffect);
                           }
                        }
                        sharedDamage.updateDamage();
                        finalSharedDamage = new EffectDamage(-1,sharedDamage.element);
                        finalSharedDamage.minDamage = sharedDamage.minDamage;
                        finalSharedDamage.maxDamage = sharedDamage.maxDamage;
                        finalSharedDamage.minCriticalDamage = sharedDamage.minCriticalDamage;
                        finalSharedDamage.maxCriticalDamage = sharedDamage.maxCriticalDamage;
                        for each(targetId in damageSharingTargets)
                        {
                           sdi.sharedDamage = new SpellDamage();
                           sdi.sharedDamage.isCriticalHit = targetDamage.isCriticalHit;
                           sdi.sharedDamage.hasCriticalDamage = targetDamage.hasCriticalDamage;
                           sdi.sharedDamage.addEffectDamage(finalSharedDamage);
                           sdi.sharedDamage.updateDamage();
                           if(targetsDamages[targetId])
                           {
                              targetHeal = new EffectDamage();
                              for each(targetDamageEffect in targetsDamages[targetId].effectDamages)
                              {
                                 for each(targetDamageEffect in targetDamageEffect.computedEffects)
                                 {
                                    targetHeal.minLifePointsAdded = targetHeal.minLifePointsAdded + targetDamageEffect.minLifePointsAdded;
                                    targetHeal.maxLifePointsAdded = targetHeal.maxLifePointsAdded + targetDamageEffect.maxLifePointsAdded;
                                    targetHeal.minCriticalLifePointsAdded = targetHeal.minCriticalLifePointsAdded + targetDamageEffect.minCriticalLifePointsAdded;
                                    targetHeal.maxCriticalLifePointsAdded = targetHeal.maxCriticalLifePointsAdded + targetDamageEffect.maxCriticalLifePointsAdded;
                                 }
                              }
                              sdi.sharedDamage.addEffectDamage(targetHeal);
                              sdi.sharedDamage.hasHeal = targetHeal.minLifePointsAdded > 0 || targetHeal.maxLifePointsAdded > 0 || targetHeal.minCriticalLifePointsAdded > 0 || targetHeal.maxCriticalLifePointsAdded > 0;
                              sdi.sharedDamage.hasCriticalLifePointsAdded = targetsDamages[targetId].hasCriticalLifePointsAdded;
                           }
                           allTargets.push(targetId);
                        }
                     }
                  }
                  currentSpellDamage = DamageUtil.getSpellDamage(sdi);
                  checkTargetTriggeredSpells = !sdi.spellHasTriggered && (!sdi.damageSharingTargets || sdi.damageSharingTargets.indexOf(pEntityId) != -1 && sdi.originalTargetsIds.indexOf(pEntityId) != -1);
                  if(checkTargetTriggeredSpells)
                  {
                     triggeredSpells = this.getTriggeredSpellsOnTarget(sdi.targetLifePoints,currentSpellDamage,sdi.triggeredSpells,false);
                     criticalTriggeredSpells = this.getTriggeredSpellsOnTarget(sdi.targetLifePoints,currentSpellDamage,sdi.criticalTriggeredSpells,true);
                     for each(ts in triggeredSpells)
                     {
                        triggeredSpellDamageShared = false;
                        for each(targetId in ts.targets)
                        {
                           if(DamageUtil.isDamagedOrHealedBySpell(ts.casterId,targetId,ts.spell,ts.targetCell))
                           {
                              triggeredSpellOnTargetSdi = SpellDamageInfo.fromCurrentPlayer(ts.spell,targetId,this.entitiesFrame.getEntityInfos(ts.targetId).disposition.cellId);
                              triggeredSpellOnTargetSdi.triggeredSpell = ts;
                              triggeredSpellOnTargetSdi.criticalHitRate = sdi.criticalHitRate;
                              triggeredSpellOnTargetSdi.spellHasCriticalDamage = true;
                              triggeredSpellOnTargetSdi.spellHasCriticalHeal = true;
                              triggeredSpellDamage = DamageUtil.getSpellDamage(triggeredSpellOnTargetSdi);
                              if(!isNaN(damageSharingMultiplier))
                              {
                                 for each(ed in triggeredSpellDamage.effectDamages)
                                 {
                                    ed.applyDamageMultiplier(damageSharingMultiplier);
                                 }
                              }
                              SpellDamagesManager.getInstance().addSpellDamage(triggeredSpellOnTargetSdi,triggeredSpellDamage);
                              if(sdi.originalTargetsIds.indexOf(pEntityId) != -1 && pEntityId != targetId)
                              {
                                 entitySdi = SpellDamageInfo.fromCurrentPlayer(ts.spell,pEntityId,sdi.spellCenterCell);
                                 entitySdi.criticalHitRate = sdi.criticalHitRate;
                                 entitySdi.spellHasCriticalDamage = sdi.spellHasCriticalDamage;
                                 for each(interceptedDmg in triggeredSpellOnTargetSdi.interceptedDamages)
                                 {
                                    if(interceptedDmg.interceptorEntityId == pEntityId)
                                    {
                                       SpellDamagesManager.getInstance().addSpellDamage(entitySdi,interceptedDmg.damage);
                                    }
                                 }
                              }
                              if(sdi.damageSharingTargets && sdi.damageSharingTargets.indexOf(targetId) != -1 && !triggeredSpellDamageShared)
                              {
                                 for each(entityId in sdi.damageSharingTargets)
                                 {
                                    if(entityId != targetId)
                                    {
                                       triggeredSpellOnTargetSdi.targetId = entityId;
                                       SpellDamagesManager.getInstance().addSpellDamage(triggeredSpellOnTargetSdi,triggeredSpellDamage);
                                    }
                                 }
                                 triggeredSpellDamageShared = true;
                              }
                              if(allTargets.indexOf(targetId) == -1)
                              {
                                 allTargets.push(targetId);
                              }
                           }
                        }
                     }
                     for each(ts in criticalTriggeredSpells)
                     {
                        triggeredSpellDamageShared = false;
                        for each(targetId in ts.targets)
                        {
                           if(DamageUtil.isDamagedOrHealedBySpell(ts.casterId,targetId,ts.spell,ts.targetCell))
                           {
                              triggeredSpellOnTargetSdi = SpellDamageInfo.fromCurrentPlayer(ts.spell,targetId,this.entitiesFrame.getEntityInfos(ts.targetId).disposition.cellId);
                              triggeredSpellOnTargetSdi.triggeredSpell = ts;
                              triggeredSpellOnTargetSdi.criticalHitRate = sdi.criticalHitRate;
                              triggeredSpellOnTargetSdi.spellHasCriticalDamage = true;
                              triggeredSpellOnTargetSdi.spellHasCriticalHeal = true;
                              criticalTriggeredSpellDamage = DamageUtil.getSpellDamage(triggeredSpellOnTargetSdi);
                              for each(ed in criticalTriggeredSpellDamage.effectDamages)
                              {
                                 if(!isNaN(damageSharingMultiplier))
                                 {
                                    ed.applyDamageMultiplier(damageSharingMultiplier);
                                 }
                                 ed.minCriticalDamage = ed.minDamage;
                                 ed.maxCriticalDamage = ed.maxDamage;
                                 ed.minDamage = ed.maxDamage = 0;
                                 ed.minCriticalLifePointsAdded = ed.minLifePointsAdded;
                                 ed.maxCriticalLifePointsAdded = ed.maxLifePointsAdded;
                                 ed.minLifePointsAdded = ed.maxLifePointsAdded = 0;
                                 for each(computedEffect in ed.computedEffects)
                                 {
                                    computedEffect.minCriticalDamage = computedEffect.minDamage;
                                    computedEffect.maxCriticalDamage = computedEffect.maxDamage;
                                    computedEffect.minDamage = computedEffect.maxDamage = 0;
                                    computedEffect.minCriticalLifePointsAdded = computedEffect.minLifePointsAdded;
                                    computedEffect.maxCriticalLifePointsAdded = computedEffect.maxLifePointsAdded;
                                    computedEffect.minLifePointsAdded = computedEffect.maxLifePointsAdded = 0;
                                 }
                              }
                              if(sdi.originalTargetsIds.indexOf(pEntityId) != -1 && pEntityId != targetId)
                              {
                                 entitySdi = SpellDamageInfo.fromCurrentPlayer(ts.spell,pEntityId,sdi.spellCenterCell);
                                 entitySdi.criticalHitRate = sdi.criticalHitRate;
                                 entitySdi.spellHasCriticalDamage = sdi.spellHasCriticalDamage;
                                 esd = SpellDamagesManager.getInstance().getSpellDamageBySpellId(entitySdi.targetId,ts.spell.id);
                                 if(esd)
                                 {
                                    critEffects = new Vector.<EffectDamage>(0);
                                    for each(ed in esd.spellDamage.effectDamages)
                                    {
                                       critEffect = ed.clone();
                                       critEffect.minCriticalDamage = ed.minDamage;
                                       critEffect.maxCriticalDamage = ed.maxDamage;
                                       critEffect.minDamage = critEffect.maxDamage = 0;
                                       critEffect.minCriticalLifePointsAdded = critEffect.minLifePointsAdded;
                                       critEffect.maxCriticalLifePointsAdded = critEffect.maxLifePointsAdded;
                                       critEffect.minLifePointsAdded = critEffect.maxLifePointsAdded = 0;
                                       for each(computedEffect in critEffect.computedEffects)
                                       {
                                          computedEffect.minCriticalDamage = computedEffect.minDamage;
                                          computedEffect.maxCriticalDamage = computedEffect.maxDamage;
                                          computedEffect.minDamage = computedEffect.maxDamage = 0;
                                          computedEffect.minCriticalLifePointsAdded = computedEffect.minLifePointsAdded;
                                          computedEffect.maxCriticalLifePointsAdded = computedEffect.maxLifePointsAdded;
                                          computedEffect.minLifePointsAdded = computedEffect.maxLifePointsAdded = 0;
                                       }
                                       critEffects.push(critEffect);
                                    }
                                    for each(critEffect in critEffects)
                                    {
                                       esd.spellDamage.effectDamages.push(critEffect);
                                    }
                                 }
                              }
                              entitySpellDamage = SpellDamagesManager.getInstance().getSpellDamageBySpellId(targetId,ts.spell.id);
                              if(entitySpellDamage)
                              {
                                 for each(ed in criticalTriggeredSpellDamage.effectDamages)
                                 {
                                    entitySpellDamage.spellDamage.addEffectDamage(ed);
                                 }
                              }
                              else
                              {
                                 SpellDamagesManager.getInstance().addSpellDamage(triggeredSpellOnTargetSdi,criticalTriggeredSpellDamage);
                              }
                              if(allTargets.indexOf(targetId) == -1)
                              {
                                 allTargets.push(targetId);
                              }
                           }
                        }
                     }
                  }
                  if(triggeredSpells)
                  {
                     splashDamages = DamageUtil.getSplashDamages(triggeredSpells,sdi,false);
                     if(splashDamages)
                     {
                        if(!sdi.splashDamages)
                        {
                           sdi.splashDamages = new Vector.<SplashDamage>(0);
                        }
                        for each(splashdmg in splashDamages)
                        {
                           sdi.splashDamages.push(splashdmg);
                           for each(targetId in splashdmg.targets)
                           {
                              if(allTargets.indexOf(targetId) == -1)
                              {
                                 allTargets.push(targetId);
                              }
                           }
                        }
                     }
                     sdi.addTriggeredSpellsEffects(triggeredSpells,false);
                  }
                  if(criticalTriggeredSpells)
                  {
                     splashDamages = DamageUtil.getSplashDamages(criticalTriggeredSpells,sdi,true);
                     if(splashDamages)
                     {
                        if(!sdi.criticalSplashDamages)
                        {
                           sdi.criticalSplashDamages = new Vector.<SplashDamage>(0);
                        }
                        for each(splashdmg in splashDamages)
                        {
                           sdi.criticalSplashDamages.push(splashdmg);
                           for each(targetId in splashdmg.targets)
                           {
                              if(allTargets.indexOf(targetId) == -1)
                              {
                                 allTargets.push(targetId);
                              }
                           }
                        }
                     }
                     sdi.addTriggeredSpellsEffects(criticalTriggeredSpells,true);
                  }
                  if(allTargets.length > 0)
                  {
                     sdi.spellHasTriggered = true;
                     if(allTargets.indexOf(pEntityId) == -1)
                     {
                        allTargets.push(pEntityId);
                     }
                     casterIndex = allTargets.indexOf(sdi.casterId);
                     if(casterIndex != -1)
                     {
                        allTargets.splice(casterIndex,1);
                        allTargets.push(sdi.casterId);
                     }
                     numTargets = allTargets.length;
                     idx = 0;
                     while(idx < numTargets)
                     {
                        if(allTargets[idx] == sdi.casterId)
                        {
                           sdi.reflectDamages = sdi.getReflectDamages();
                           sdi.spellHasLifeSteal = sdi.hasLifeSteal();
                        }
                        this.displayEntityTooltip(allTargets[idx],pSpell,sdi,true);
                        idx++;
                     }
                     return;
                  }
               }
               if(currentSpellDamage)
               {
                  SpellDamagesManager.getInstance().addSpellDamage(sdi,currentSpellDamage);
                  params.spellDamage = SpellDamagesManager.getInstance().getTotalSpellDamage(pEntityId);
                  allTargetsTooltipsVisible = true;
                  for each(entityId in sdi.originalTargetsIds)
                  {
                     if(!this._spellTargetsTooltips[entityId])
                     {
                        allTargetsTooltipsVisible = false;
                        break;
                     }
                  }
                  if(pEntityId != sdi.casterId && allTargetsTooltipsVisible && sdi.originalTargetsIds.indexOf(sdi.casterId) == -1 && !SpellDamagesManager.getInstance().hasSpellDamages(sdi.casterId))
                  {
                     casterSdi = SpellDamageInfo.fromCurrentPlayer(pSpell,sdi.casterId,spellImpactCell);
                     casterSdi.reflectDamages = sdi.getReflectDamages();
                     casterSdi.spellHasLifeSteal = sdi.hasLifeSteal();
                     casterSdi.splashDamages = sdi.splashDamages;
                     casterSdi.spellHasTriggered = sdi.spellHasTriggered;
                     if(casterSdi.reflectDamages || casterSdi.spellHasLifeSteal)
                     {
                        casterSdi.minimizedEffects = sdi.minimizedEffects;
                        casterSdi.maximizedEffects = sdi.maximizedEffects;
                        this.displayEntityTooltip(sdi.casterId,pSpell,casterSdi,true);
                     }
                  }
                  if(!sdi.isInterceptedDamage)
                  {
                     for each(intercepted in sdi.interceptedDamages)
                     {
                        if(intercepted.interceptedEntityId == pEntityId)
                        {
                           hasInterceptedDamage = true;
                           break;
                        }
                     }
                  }
                  if(hasInterceptedDamage)
                  {
                     interceptedMaximizedEffects = true;
                     for each(intercepted in sdi.interceptedDamages)
                     {
                        if(pEntityId != intercepted.interceptorEntityId && intercepted.interceptedEntityId == pEntityId && !intercepted.damage.isHealingSpell && intercepted.damage.hasDamage)
                        {
                           if(!intercepted.damage.maximizedEffects)
                           {
                              interceptedMaximizedEffects = false;
                           }
                           interceptorSpellDamages = SpellDamagesManager.getInstance().getSpellDamages(intercepted.interceptorEntityId);
                           if(interceptorSpellDamages && intercepted.interceptorEntityId != sdi.interceptedEntityId)
                           {
                              for each(entitySpellDamage in interceptorSpellDamages)
                              {
                                 for each(ed in entitySpellDamage.spellDamage.effectDamages)
                                 {
                                    for each(ed in ed.computedEffects)
                                    {
                                       intercepted.damage.addEffectDamage(ed);
                                    }
                                 }
                                 if(entitySpellDamage.interceptedDamage)
                                 {
                                    if(!entitySpellDamage.spellDamage.maximizedEffects)
                                    {
                                       interceptedMaximizedEffects = false;
                                    }
                                    interceptedDamageIndex = interceptorSpellDamages.indexOf(entitySpellDamage);
                                 }
                                 if(entitySpellDamage.spellDamage.hasCriticalDamage)
                                 {
                                    intercepted.damage.hasCriticalDamage = true;
                                 }
                              }
                              if(interceptedDamageIndex != -1)
                              {
                                 interceptorSpellDamages.splice(interceptedDamageIndex,1);
                              }
                           }
                           interceptorSdi = SpellDamageInfo.fromCurrentPlayer(pSpell,intercepted.interceptorEntityId,spellImpactCell);
                           if(interceptorSpellDamages)
                           {
                              interceptorIndex = interceptorSdi.originalTargetsIds.indexOf(intercepted.interceptorEntityId);
                              if(interceptorIndex != -1)
                              {
                                 interceptorSdi.originalTargetsIds.splice(interceptorIndex,1);
                              }
                           }
                           intercepted.damage.updateDamage();
                           interceptorSdi.interceptedDamage = intercepted.damage;
                           interceptorSdi.interceptedDamage.targetId = interceptorSdi.targetId;
                           interceptorSdi.interceptedEntityId = sdi.targetId;
                           interceptorSdi.distanceBetweenCasterAndTarget = sdi.distanceBetweenCasterAndTarget;
                           interceptorSdi.minimizedEffects = sdi.minimizedEffects;
                           interceptorSdi.maximizedEffects = interceptedMaximizedEffects && interceptorSdi.maximizedEffects;
                           interceptorSdi.criticalHitRate = sdi.criticalHitRate;
                           interceptorSdi.spellHasCriticalDamage = sdi.spellHasCriticalDamage;
                           interceptorSdi.isInterceptedDamage = true;
                           this.displayEntityTooltip(interceptorSdi.targetId,pSpell,interceptorSdi,true);
                           if(!currentSpellDamage.hasHeal && !currentSpellDamage.hasDamage)
                           {
                              return;
                           }
                        }
                     }
                  }
               }
            }
            if(pSpell is SpellWrapper && (pSpell as SpellWrapper).canTargetCasterOutOfZone)
            {
               if(!showDamages)
               {
                  spellZone = SpellZoneManager.getInstance().getSpellZone(pSpell);
                  spellZoneCells = spellZone.getCells(spellImpactCell);
                  hideTooltip = spellZoneCells.indexOf(infos.disposition.cellId) == -1;
               }
               else
               {
                  hideTooltip = !entityDamagedOrHealedBySpell && !pSpellInfo;
               }
            }
            emptySpellDamage = true;
            if(params && params.spellDamage is SpellDamageList)
            {
               for each(spellDamage in params.spellDamage)
               {
                  if(!spellDamage.empty)
                  {
                     emptySpellDamage = false;
                     break;
                  }
               }
            }
            else if(params && params.spellDamage && !params.spellDamage.empty)
            {
               emptySpellDamage = false;
            }
            if(hideTooltip || params && params.spellDamage && emptySpellDamage || updateTime < this._tooltipLastUpdate[pEntityId])
            {
               return;
            }
         }
         catch(e:Error)
         {
            _log.error(e.getStackTrace());
         }
         var target:IRectangle = params && params.target?params.target:entity.absoluteBounds;
         if(this._entitiesFrame.hasIcon(pEntityId))
         {
            if(!params)
            {
               params = new Object();
            }
            delta = this._entitiesFrame.getIcon(pEntityId).height * Atouin.getInstance().currentZoom + 10 * Atouin.getInstance().currentZoom;
            params.offsetRect = new Rectangle2(0,-delta,0,delta);
         }
         var tooltipCacheName:String = "EntityShortInfos" + infos.contextualId;
         if(infos is GameFightCharacterInformations)
         {
            tooltipCacheName = "PlayerShortInfos" + infos.contextualId;
            TooltipManager.show(infos,target,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"tooltipOverEntity_" + infos.contextualId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,null,params,tooltipCacheName,false,StrataEnum.STRATA_WORLD,Atouin.getInstance().currentZoom);
         }
         else if(infos is GameFightCompanionInformations)
         {
            TooltipManager.show(infos,target,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"tooltipOverEntity_" + infos.contextualId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,"companionFighter",null,params,tooltipCacheName,false,StrataEnum.STRATA_WORLD,Atouin.getInstance().currentZoom);
         }
         else
         {
            TooltipManager.show(infos,target,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"tooltipOverEntity_" + infos.contextualId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,"monsterFighter",null,params,tooltipCacheName,false,StrataEnum.STRATA_WORLD,Atouin.getInstance().currentZoom);
         }
         var fightPreparationFrame:FightPreparationFrame = Kernel.getWorker().getFrame(FightPreparationFrame) as FightPreparationFrame;
         if(fightPreparationFrame)
         {
            fightPreparationFrame.updateSwapPositionRequestsIcons();
         }
         if(tooltipCacheName && TooltipManager.hasCache(tooltipCacheName))
         {
            this._entitiesFrame.updateEntityIconPosition(pEntityId);
         }
      }
      
      public function hideEntityTooltip(param1:Number, param2:uint) : void
      {
         if(!(this._showPermanentTooltips && this._battleFrame.targetedEntities.indexOf(param1) != -1) && TooltipManager.isVisible("tooltipOverEntity_" + param1))
         {
            TooltipManager.hide("tooltipOverEntity_" + param1);
            this._hideTooltipEntityId = param1;
            if(!this._hideTooltipTimer)
            {
               this._hideTooltipTimer = new Timer(param2);
            }
            this._hideTooltipTimer.stop();
            this._hideTooltipTimer.delay = param2;
            this._hideTooltipTimer.removeEventListener(TimerEvent.TIMER,this.onShowTooltip);
            this._hideTooltipTimer.addEventListener(TimerEvent.TIMER,this.onShowTooltip);
            this._hideTooltipTimer.start();
         }
      }
      
      public function hidePermanentTooltips(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         this._hideTooltips = true;
         if(this._battleFrame.targetedEntities.length > 0)
         {
            for each(_loc2_ in this._battleFrame.targetedEntities)
            {
               TooltipManager.hide("tooltipOverEntity_" + _loc2_);
            }
            if(!this._hideTooltipsTimer)
            {
               this._hideTooltipsTimer = new Timer(param1);
            }
            this._hideTooltipsTimer.stop();
            this._hideTooltipsTimer.delay = param1;
            this._hideTooltipsTimer.removeEventListener(TimerEvent.TIMER,this.onShowPermanentTooltips);
            this._hideTooltipsTimer.addEventListener(TimerEvent.TIMER,this.onShowPermanentTooltips);
            this._hideTooltipsTimer.start();
         }
      }
      
      public function getFighterPreviousPosition(param1:Number) : int
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         if(this._fightersPositionsHistory[param1])
         {
            _loc3_ = this._fightersPositionsHistory[param1];
            _loc2_ = _loc3_.length > 0?_loc3_[_loc3_.length - 1]:null;
         }
         return !!_loc2_?int(_loc2_.cellId):-1;
      }
      
      public function deleteFighterPreviousPosition(param1:Number) : void
      {
         if(this._fightersPositionsHistory[param1])
         {
            this._fightersPositionsHistory[param1].pop();
         }
      }
      
      public function saveFighterPosition(param1:Number, param2:uint) : void
      {
         if(!this._fightersPositionsHistory[param1])
         {
            this._fightersPositionsHistory[param1] = new Array();
         }
         this._fightersPositionsHistory[param1].push({
            "cellId":param2,
            "lives":2
         });
      }
      
      public function refreshTimelineOverEntityInfos() : void
      {
         var _loc1_:IEntity = null;
         if(this._timelineOverEntity && this._timelineOverEntityId)
         {
            _loc1_ = DofusEntities.getEntity(this._timelineOverEntityId);
            if(_loc1_ && _loc1_.position)
            {
               FightContextFrame.currentCell = _loc1_.position.cellId;
               this.overEntity(this._timelineOverEntityId);
            }
         }
      }
      
      private function getTriggeredSpellsOnTarget(param1:uint, param2:SpellDamage, param3:Vector.<TriggeredSpell>, param4:Boolean) : Vector.<TriggeredSpell>
      {
         var _loc6_:EffectDamage = null;
         var _loc7_:TriggeredSpell = null;
         var _loc5_:Vector.<TriggeredSpell> = !!param3?new Vector.<TriggeredSpell>(0):null;
         for each(_loc7_ in param3)
         {
            if(_loc7_.effectId == ActionIdConverter.ACTION_TARGET_CASTS_SPELL || _loc7_.effectId == ActionIdConverter.ACTION_TARGET_CASTS_SPELL_WITH_ANIM || _loc7_.effectId == ActionIdConverter.ACTION_TARGET_EXECUTE_SPELL_ON_SOURCE)
            {
               _loc6_ = DamageUtil.getDamageBeforeIndex(DamageUtil.getAllEffectDamages(param2),_loc7_.sourceSpellEffectOrder);
               if(!param4 && _loc6_.minDamage > param1 && _loc6_.maxDamage > param1 || param4 && _loc6_.minCriticalDamage > param1 && _loc6_.maxCriticalDamage > param1)
               {
                  continue;
               }
            }
            _loc5_.push(_loc7_);
         }
         return _loc5_;
      }
      
      private function getFighterInfos(param1:Number) : GameFightFighterInformations
      {
         return this.entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations;
      }
      
      private function showFighterInfo(param1:TimerEvent) : void
      {
         this._timerFighterInfo.reset();
         KernelEventsManager.getInstance().processCallback(FightHookList.FighterInfoUpdate,this._currentFighterInfo);
      }
      
      private function showMovementRange(param1:TimerEvent) : void
      {
         this._timerMovementRange.reset();
         this._reachableRangeSelection = new Selection();
         this._reachableRangeSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
         this._reachableRangeSelection.color = new Color(52326);
         this._unreachableRangeSelection = new Selection();
         this._unreachableRangeSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
         this._unreachableRangeSelection.color = new Color(6684672);
         var _loc2_:FightReachableCellsMaker = new FightReachableCellsMaker(this._currentFighterInfo);
         this._reachableRangeSelection.zone = new Custom(_loc2_.reachableCells);
         this._unreachableRangeSelection.zone = new Custom(_loc2_.unreachableCells);
         SelectionManager.getInstance().addSelection(this._reachableRangeSelection,"movementReachableRange",this._currentFighterInfo.disposition.cellId);
         SelectionManager.getInstance().addSelection(this._unreachableRangeSelection,"movementUnreachableRange",this._currentFighterInfo.disposition.cellId);
      }
      
      private function hideMovementRange() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection("movementReachableRange");
         if(_loc1_)
         {
            _loc1_.remove();
            this._reachableRangeSelection = null;
         }
         _loc1_ = SelectionManager.getInstance().getSelection("movementUnreachableRange");
         if(_loc1_)
         {
            _loc1_.remove();
            this._unreachableRangeSelection = null;
         }
      }
      
      private function addMarks(param1:Vector.<GameActionMark>) : void
      {
         var _loc2_:GameActionMark = null;
         var _loc3_:Spell = null;
         var _loc4_:AddGlyphGfxStep = null;
         var _loc5_:GameActionMarkedCell = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = Spell.getSpellById(_loc2_.markSpellId);
            if(_loc2_.markType == GameActionMarkTypeEnum.WALL || _loc3_.getSpellLevel(_loc2_.markSpellLevel).hasZoneShape(SpellShapeEnum.semicolon))
            {
               if(_loc3_.getParamByName("glyphGfxId"))
               {
                  for each(_loc5_ in _loc2_.cells)
                  {
                     _loc4_ = new AddGlyphGfxStep(_loc3_.getParamByName("glyphGfxId"),_loc5_.cellId,_loc2_.markId,_loc2_.markType,_loc2_.markTeamId,_loc2_.active);
                     _loc4_.start();
                  }
               }
            }
            else if(_loc3_.getParamByName("glyphGfxId") && !MarkedCellsManager.getInstance().getGlyph(_loc2_.markId) && _loc2_.markimpactCell != -1)
            {
               _loc4_ = new AddGlyphGfxStep(_loc3_.getParamByName("glyphGfxId"),_loc2_.markimpactCell,_loc2_.markId,_loc2_.markType,_loc2_.markTeamId,_loc2_.active);
               _loc4_.start();
            }
            MarkedCellsManager.getInstance().addMark(_loc2_.markId,_loc2_.markType,_loc3_,_loc3_.getSpellLevel(_loc2_.markSpellLevel),_loc2_.cells,_loc2_.markTeamId,_loc2_.active,_loc2_.markimpactCell);
         }
      }
      
      private function removeAsLinkEntityEffect() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         for each(_loc1_ in this._entitiesFrame.getEntitiesIdsList())
         {
            _loc2_ = DofusEntities.getEntity(_loc1_) as DisplayObject;
            if(_loc2_ && _loc2_.filters && _loc2_.filters.length)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.filters.length)
               {
                  if(_loc2_.filters[_loc3_] is ColorMatrixFilter)
                  {
                     _loc2_.filters = _loc2_.filters.splice(_loc3_,_loc3_);
                     break;
                  }
                  _loc3_++;
               }
               continue;
            }
         }
      }
      
      private function highlightAsLinkedEntity(param1:Number, param2:Boolean) : void
      {
         var _loc5_:ColorMatrixFilter = null;
         var _loc3_:IEntity = DofusEntities.getEntity(param1);
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:Sprite = _loc3_ as Sprite;
         if(_loc4_)
         {
            _loc5_ = !!param2?this._linkedMainEffect:this._linkedEffect;
            if(_loc4_.filters.length)
            {
               if(_loc4_.filters[0] != _loc5_)
               {
                  _loc4_.filters = [_loc5_];
               }
            }
            else
            {
               _loc4_.filters = [_loc5_];
            }
         }
      }
      
      private function overEntity(param1:Number, param2:Boolean = true, param3:Boolean = true) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:* = false;
         var _loc14_:GameFightFighterInformations = null;
         var _loc15_:Selection = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:FightReachableCellsMaker = null;
         var _loc19_:GlowFilter = null;
         var _loc20_:FightTurnFrame = null;
         var _loc21_:Boolean = false;
         var _loc4_:Vector.<Number> = this._entitiesFrame.getEntitiesIdsList();
         fighterEntityTooltipId = param1;
         var _loc5_:IEntity = DofusEntities.getEntity(fighterEntityTooltipId);
         if(!_loc5_)
         {
            if(_loc4_.indexOf(fighterEntityTooltipId) == -1)
            {
               _log.warn("Mouse over an unknown entity : " + param1);
               return;
            }
            param2 = false;
         }
         var _loc6_:GameFightFighterInformations = this._entitiesFrame.getEntityInfos(param1) as GameFightFighterInformations;
         if(!_loc6_)
         {
            _log.warn("Mouse over an unknown entity : " + param1);
            return;
         }
         var _loc7_:Number = _loc6_.stats.summoner;
         if(_loc6_ is GameFightCompanionInformations)
         {
            _loc7_ = (_loc6_ as GameFightCompanionInformations).masterId;
         }
         for each(_loc8_ in _loc4_)
         {
            if(_loc8_ != param1)
            {
               _loc14_ = this._entitiesFrame.getEntityInfos(_loc8_) as GameFightFighterInformations;
               if(_loc14_.stats.summoner == param1 || _loc7_ == _loc8_ || _loc14_.stats.summoner == _loc7_ && _loc7_ || _loc14_ is GameFightCompanionInformations && (_loc14_ as GameFightCompanionInformations).masterId == param1)
               {
                  this.highlightAsLinkedEntity(_loc8_,_loc7_ == _loc8_);
               }
            }
         }
         this._currentFighterInfo = _loc6_;
         _loc9_ = true;
         if(PlayedCharacterManager.getInstance().isSpectator && OptionManager.getOptionManager("dofus")["spectatorAutoShowCurrentFighterInfo"] == true)
         {
            _loc9_ = this._battleFrame.currentPlayerId != param1;
         }
         if(_loc9_ && param3)
         {
            this._timerFighterInfo.reset();
            this._timerFighterInfo.start();
         }
         if(_loc6_.stats.invisibilityState == GameActionFightInvisibilityStateEnum.INVISIBLE)
         {
            _log.info("Mouse over an invisible entity in timeline");
            _loc15_ = SelectionManager.getInstance().getSelection(this.INVISIBLE_POSITION_SELECTION);
            if(!_loc15_)
            {
               _loc15_ = new Selection();
               _loc15_.color = new Color(52326);
               _loc15_.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
               SelectionManager.getInstance().addSelection(_loc15_,this.INVISIBLE_POSITION_SELECTION);
            }
            _loc16_ = FightEntitiesFrame.getCurrentInstance().getLastKnownEntityPosition(_loc6_.contextualId);
            if(_loc16_ > -1)
            {
               _loc17_ = FightEntitiesFrame.getCurrentInstance().getLastKnownEntityMovementPoint(_loc6_.contextualId);
               _loc18_ = new FightReachableCellsMaker(this._currentFighterInfo,_loc16_,_loc17_);
               _loc15_.zone = new Custom(_loc18_.reachableCells);
               SelectionManager.getInstance().update(this.INVISIBLE_POSITION_SELECTION,_loc16_);
            }
            return;
         }
         var _loc10_:FightSpellCastFrame = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame;
         var _loc11_:Object = null;
         if(_loc10_ && (SelectionManager.getInstance().isInside(currentCell,"SpellCastTarget") || this._spellTargetsTooltips[param1]))
         {
            _loc11_ = _loc10_.currentSpell;
         }
         this.displayEntityTooltip(param1,_loc11_);
         var _loc12_:Selection = SelectionManager.getInstance().getSelection(FightTurnFrame.SELECTION_PATH);
         if(_loc12_)
         {
            _loc12_.remove();
         }
         if(param2)
         {
            if(Kernel.getWorker().contains(FightBattleFrame) && !Kernel.getWorker().contains(FightSpellCastFrame))
            {
               this._timerMovementRange.reset();
               this._timerMovementRange.start();
            }
         }
         if(this._lastEffectEntity && this._lastEffectEntity.object is Sprite && this._lastEffectEntity.object != _loc5_)
         {
            Sprite(this._lastEffectEntity.object).filters = [];
         }
         var _loc13_:Sprite = _loc5_ as Sprite;
         if(_loc13_)
         {
            _loc20_ = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
            _loc21_ = !!_loc20_?Boolean(_loc20_.myTurn):true;
            if((!_loc10_ || FightSpellCastFrame.isCurrentTargetTargetable()) && _loc21_)
            {
               _loc19_ = this._overEffectOk;
            }
            else
            {
               _loc19_ = this._overEffectKo;
            }
            if(_loc13_.filters.length)
            {
               if(_loc13_.filters[0] != _loc19_)
               {
                  _loc13_.filters = [_loc19_];
               }
            }
            else
            {
               _loc13_.filters = [_loc19_];
            }
            this._lastEffectEntity = new WeakReference(_loc5_);
         }
      }
      
      private function tacticModeHandler(param1:Boolean = false) : void
      {
         if(param1 && !TacticModeManager.getInstance().tacticModeActivated)
         {
            TacticModeManager.getInstance().show(PlayedCharacterManager.getInstance().currentMap);
         }
         else if(TacticModeManager.getInstance().tacticModeActivated)
         {
            TacticModeManager.getInstance().hide();
         }
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Boolean = false;
         switch(param1.propertyName)
         {
            case "showPermanentTargetsTooltips":
               this._showPermanentTooltips = param1.propertyValue as Boolean;
               for each(_loc2_ in this._battleFrame.targetedEntities)
               {
                  if(!this._showPermanentTooltips)
                  {
                     TooltipManager.hide("tooltipOverEntity_" + _loc2_);
                  }
                  else
                  {
                     this.displayEntityTooltip(_loc2_);
                  }
               }
               break;
            case "spectatorAutoShowCurrentFighterInfo":
               if(PlayedCharacterManager.getInstance().isSpectator)
               {
                  _loc3_ = param1.propertyValue as Boolean;
                  if(!_loc3_)
                  {
                     KernelEventsManager.getInstance().processCallback(FightHookList.FighterInfoUpdate,null);
                  }
                  else
                  {
                     KernelEventsManager.getInstance().processCallback(FightHookList.FighterInfoUpdate,FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._battleFrame.currentPlayerId) as GameFightFighterInformations);
                  }
               }
         }
      }
      
      private function onShowPermanentTooltips(param1:TimerEvent) : void
      {
         var _loc2_:Number = NaN;
         this._hideTooltips = false;
         this._hideTooltipsTimer.removeEventListener(TimerEvent.TIMER,this.onShowPermanentTooltips);
         this._hideTooltipsTimer.stop();
         for each(_loc2_ in this._battleFrame.targetedEntities)
         {
            this.displayEntityTooltip(_loc2_);
         }
      }
      
      private function onShowTooltip(param1:TimerEvent) : void
      {
         this._hideTooltipTimer.removeEventListener(TimerEvent.TIMER,this.onShowTooltip);
         this._hideTooltipTimer.stop();
         var _loc2_:GameContextActorInformations = this._entitiesFrame.getEntityInfos(this._hideTooltipEntityId);
         if(_loc2_ && (_loc2_.disposition.cellId == currentCell || this.timelineOverEntity && this._hideTooltipEntityId == this.timelineOverEntityId))
         {
            this.displayEntityTooltip(this._hideTooltipEntityId);
         }
      }
      
      private function onUiUnloadStarted(param1:UiUnloadEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:AnimatedCharacter = null;
         if(param1.name && param1.name.indexOf("tooltipOverEntity_") != -1)
         {
            _loc2_ = param1.name.split("_");
            _loc3_ = _loc2_[_loc2_.length - 1];
            _loc4_ = DofusEntities.getEntity(_loc3_) as AnimatedCharacter;
            if(_loc4_ && _loc4_.parent && _loc4_.displayed && this._entitiesFrame.hasIcon(_loc3_))
            {
               this._entitiesFrame.getIcon(_loc3_).place(this._entitiesFrame.getIconEntityBounds(_loc4_));
            }
         }
      }
      
      private function onTooltipsOrdered(param1:TooltipEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Vector.<Number> = this.entitiesFrame.getEntitiesIdsList();
         for each(_loc3_ in _loc2_)
         {
            if(Berilia.getInstance().getUi("tooltip_tooltipOverEntity_" + _loc3_))
            {
               this._entitiesFrame.updateEntityIconPosition(_loc3_);
            }
         }
      }
   }
}
