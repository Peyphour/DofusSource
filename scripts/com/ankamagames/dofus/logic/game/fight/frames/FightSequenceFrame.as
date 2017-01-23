package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.atouin.types.sequences.AddWorldEntityStep;
   import com.ankamagames.atouin.types.sequences.ParableGfxMovementStep;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.SpellInventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.common.managers.MapMovementAdapter;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.misc.ISpellCastProvider;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.messages.GameActionFightLeaveMessage;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.logic.game.fight.miscs.SpellScriptBuffer;
   import com.ankamagames.dofus.logic.game.fight.miscs.TackleUtil;
   import com.ankamagames.dofus.logic.game.fight.steps.FightActionPointsLossDodgeStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightActionPointsVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightCarryCharacterStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightChangeLookStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightChangeVisibilityStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightCloseCombatStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDeathStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDispellEffectStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDispellSpellStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDispellStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDisplayBuffStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightEnteringStateStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightEntityMovementStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightEntitySlideStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightExchangePositionsStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightInvisibleTemporarilyDetectedStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightKillStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightLeavingStateStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightLifeVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightLossAnimStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMarkActivateStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMarkCellsStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMarkTriggeredStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightModifyEffectsDurationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMovementPointsLossDodgeStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightMovementPointsVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightPlaySpellScriptStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightReducedDamagesStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightReflectedDamagesStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightReflectedSpellStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightRefreshFighterStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightShieldPointsVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSpellCastStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSpellCooldownVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSpellImmunityStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightStealingKamasStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightSummonStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTackledStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTeleportStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTemporaryBoostStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightThrowCharacterStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightTurnListStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightUnmarkCellsStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightVanishStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightVisibilityStep;
   import com.ankamagames.dofus.logic.game.fight.steps.IFightStep;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.dofus.logic.game.fight.types.StatBuff;
   import com.ankamagames.dofus.logic.game.fight.types.StateBuff;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.network.enums.FightSpellCastCriticalEnum;
   import com.ankamagames.dofus.network.enums.GameActionMarkTypeEnum;
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightActivateGlyphTrapMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCarryCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightChangeLookMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCloseCombatMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDeathMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellEffectMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellSpellMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDispellableEffectMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDodgePointLossMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDropCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightExchangePositionsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightInvisibilityMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightInvisibleDetectedMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightKillMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightLifeAndShieldPointsLostMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightLifePointsGainMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightLifePointsLostMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightMarkCellsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightModifyEffectsDurationMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightPointsVariationMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReduceDamagesMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReflectDamagesMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightReflectSpellMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSlideMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSpellCastMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSpellCooldownVariationMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSpellImmunityMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightStealKamaMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightSummonMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTackledMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTeleportOnSameMapMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightThrowCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTriggerEffectMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightTriggerGlyphTrapMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightUnmarkCellsMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightVanishMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceEndMessage;
   import com.ankamagames.dofus.network.messages.game.actions.sequence.SequenceStartMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnListMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightRefreshFighterMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterRandomStaticPoseMessage;
   import com.ankamagames.dofus.network.types.game.actions.fight.AbstractFightDispellableEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.FightTemporaryBoostEffect;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMarkedCell;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCompanionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightSpellCooldown;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.dofus.types.sequences.AddGfxInLineStep;
   import com.ankamagames.dofus.types.sequences.AddGlyphGfxStep;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.sequencer.CallbackStep;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import com.ankamagames.jerakine.sequencer.ParallelStartSequenceStep;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.events.SequencerEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellShapeEnum;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.WaitAnimationEventStep;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class FightSequenceFrame implements Frame, ISpellCastProvider
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightSequenceFrame));
      
      private static var _lastCastingSpell:CastingSpell;
      
      private static var _currentInstanceId:uint;
      
      public static const FIGHT_SEQUENCERS_CATEGORY:String = "FightSequencer";
       
      
      private var _scriptStarted:uint;
      
      private var _castingSpell:CastingSpell;
      
      private var _castingSpells:Vector.<CastingSpell>;
      
      private var _stepsBuffer:Vector.<ISequencable>;
      
      public var mustAck:Boolean;
      
      public var ackIdent:int;
      
      private var _sequenceEndCallback:Function;
      
      private var _subSequenceWaitingCount:uint = 0;
      
      private var _scriptInit:Boolean;
      
      private var _sequencer:SerialSequencer;
      
      private var _parent:FightSequenceFrame;
      
      private var _fightBattleFrame:FightBattleFrame;
      
      private var _fightEntitiesFrame:FightEntitiesFrame;
      
      private var _instanceId:uint;
      
      private var _teleportThroughPortal:Boolean;
      
      private var _teleportPortalId:int;
      
      private var _playSpellScriptStep:FightPlaySpellScriptStep;
      
      private var _spellScriptTemporaryBuffer:SpellScriptBuffer;
      
      public function FightSequenceFrame(param1:FightBattleFrame, param2:FightSequenceFrame = null)
      {
         super();
         this._instanceId = _currentInstanceId++;
         this._fightBattleFrame = param1;
         this._parent = param2;
         this.clearBuffer();
      }
      
      public static function get lastCastingSpell() : CastingSpell
      {
         return _lastCastingSpell;
      }
      
      public static function get currentInstanceId() : uint
      {
         return _currentInstanceId;
      }
      
      private static function deleteTooltip(param1:Number) : void
      {
         var _loc2_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         if(FightContextFrame.fighterEntityTooltipId == param1 && FightContextFrame.fighterEntityTooltipId != _loc2_.timelineOverEntityId)
         {
            if(_loc2_)
            {
               _loc2_.outEntity(param1);
            }
         }
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function get castingSpell() : CastingSpell
      {
         if(this._castingSpells && this._castingSpells.length > 1)
         {
            return this._castingSpells[this._castingSpells.length - 1];
         }
         return this._castingSpell;
      }
      
      public function get stepsBuffer() : Vector.<ISequencable>
      {
         return this._stepsBuffer;
      }
      
      public function get parent() : FightSequenceFrame
      {
         return this._parent;
      }
      
      public function get isWaiting() : Boolean
      {
         return this._subSequenceWaitingCount != 0 || !this._scriptInit;
      }
      
      public function get instanceId() : uint
      {
         return this._instanceId;
      }
      
      public function pushed() : Boolean
      {
         this._scriptInit = false;
         return true;
      }
      
      public function pulled() : Boolean
      {
         this._stepsBuffer = null;
         this._castingSpell = null;
         this._castingSpells = null;
         _lastCastingSpell = null;
         this._sequenceEndCallback = null;
         this._parent = null;
         this._fightBattleFrame = null;
         this._fightEntitiesFrame = null;
         this._sequencer.clear();
         return true;
      }
      
      public function get fightEntitiesFrame() : FightEntitiesFrame
      {
         if(!this._fightEntitiesFrame)
         {
            this._fightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         }
         return this._fightEntitiesFrame;
      }
      
      public function addSubSequence(param1:ISequencer) : void
      {
         this._subSequenceWaitingCount++;
         this._stepsBuffer.push(new ParallelStartSequenceStep([param1],false));
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:FightContextFrame = null;
         var _loc3_:GameFightRefreshFighterMessage = null;
         var _loc4_:GameActionFightSpellCastMessage = null;
         var _loc5_:Boolean = false;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:CastingSpell = null;
         var _loc10_:* = false;
         var _loc11_:Dictionary = null;
         var _loc12_:GameFightFighterInformations = null;
         var _loc13_:PlayedCharacterManager = null;
         var _loc14_:Boolean = false;
         var _loc15_:GameFightFighterInformations = null;
         var _loc16_:GameMapMovementMessage = null;
         var _loc17_:MovementPath = null;
         var _loc18_:Vector.<uint> = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:FightSpellCastFrame = null;
         var _loc22_:GameActionFightPointsVariationMessage = null;
         var _loc23_:GameActionFightLifeAndShieldPointsLostMessage = null;
         var _loc24_:GameActionFightLifePointsGainMessage = null;
         var _loc25_:GameActionFightLifePointsLostMessage = null;
         var _loc26_:GameActionFightTeleportOnSameMapMessage = null;
         var _loc27_:GameActionFightExchangePositionsMessage = null;
         var _loc28_:GameActionFightSlideMessage = null;
         var _loc29_:GameContextActorInformations = null;
         var _loc30_:GameActionFightSummonMessage = null;
         var _loc31_:GameActionFightMarkCellsMessage = null;
         var _loc32_:uint = 0;
         var _loc33_:SpellLevel = null;
         var _loc34_:GameActionFightUnmarkCellsMessage = null;
         var _loc35_:GameActionFightChangeLookMessage = null;
         var _loc36_:GameActionFightInvisibilityMessage = null;
         var _loc37_:GameContextActorInformations = null;
         var _loc38_:GameActionFightLeaveMessage = null;
         var _loc39_:Dictionary = null;
         var _loc40_:GameContextActorInformations = null;
         var _loc41_:GameActionFightDeathMessage = null;
         var _loc42_:Dictionary = null;
         var _loc43_:GameFightFighterInformations = null;
         var _loc44_:Number = NaN;
         var _loc45_:GameFightFighterInformations = null;
         var _loc46_:GameFightFighterInformations = null;
         var _loc47_:GameFightFighterInformations = null;
         var _loc48_:GameContextActorInformations = null;
         var _loc49_:FightTurnFrame = null;
         var _loc50_:Boolean = false;
         var _loc51_:GameActionFightVanishMessage = null;
         var _loc52_:GameContextActorInformations = null;
         var _loc53_:GameActionFightDispellEffectMessage = null;
         var _loc54_:GameActionFightDispellSpellMessage = null;
         var _loc55_:GameActionFightDispellMessage = null;
         var _loc56_:GameActionFightDodgePointLossMessage = null;
         var _loc57_:GameActionFightSpellCooldownVariationMessage = null;
         var _loc58_:GameActionFightSpellImmunityMessage = null;
         var _loc59_:GameActionFightKillMessage = null;
         var _loc60_:GameActionFightReduceDamagesMessage = null;
         var _loc61_:GameActionFightReflectDamagesMessage = null;
         var _loc62_:GameActionFightReflectSpellMessage = null;
         var _loc63_:GameActionFightStealKamaMessage = null;
         var _loc64_:GameActionFightTackledMessage = null;
         var _loc65_:GameActionFightTriggerGlyphTrapMessage = null;
         var _loc66_:GameFightFighterInformations = null;
         var _loc67_:int = 0;
         var _loc68_:MarkInstance = null;
         var _loc69_:GameActionFightActivateGlyphTrapMessage = null;
         var _loc70_:GameActionFightDispellableEffectMessage = null;
         var _loc71_:CastingSpell = null;
         var _loc72_:AbstractFightDispellableEffect = null;
         var _loc73_:BasicBuff = null;
         var _loc74_:GameActionFightModifyEffectsDurationMessage = null;
         var _loc75_:GameActionFightCarryCharacterMessage = null;
         var _loc76_:GameActionFightThrowCharacterMessage = null;
         var _loc77_:uint = 0;
         var _loc78_:GameActionFightDropCharacterMessage = null;
         var _loc79_:uint = 0;
         var _loc80_:GameActionFightInvisibleDetectedMessage = null;
         var _loc81_:GameFightTurnListMessage = null;
         var _loc82_:GameActionFightCloseCombatMessage = null;
         var _loc83_:SpellScriptBuffer = null;
         var _loc84_:uint = 0;
         var _loc85_:Boolean = false;
         var _loc86_:uint = 0;
         var _loc87_:uint = 0;
         var _loc88_:uint = 0;
         var _loc89_:Array = null;
         var _loc90_:Boolean = false;
         var _loc91_:SpellLevel = null;
         var _loc92_:SpellWrapper = null;
         var _loc93_:Spell = null;
         var _loc94_:SpellLevel = null;
         var _loc95_:Dictionary = null;
         var _loc96_:GameFightFighterInformations = null;
         var _loc97_:SpellInventoryManagementFrame = null;
         var _loc98_:int = 0;
         var _loc99_:GameFightSpellCooldown = null;
         var _loc100_:uint = 0;
         var _loc101_:EffectInstance = null;
         var _loc102_:TiphonSprite = null;
         var _loc103_:GraphicCell = null;
         var _loc104_:Point = null;
         var _loc105_:TiphonSprite = null;
         var _loc106_:AnimatedCharacter = null;
         var _loc107_:GameFightFighterInformations = null;
         var _loc108_:GameFightShowFighterRandomStaticPoseMessage = null;
         var _loc109_:Sprite = null;
         var _loc110_:GameFightShowFighterMessage = null;
         var _loc111_:Sprite = null;
         var _loc112_:Number = NaN;
         var _loc113_:Boolean = false;
         var _loc114_:Boolean = false;
         var _loc115_:GameContextActorInformations = null;
         var _loc116_:GameFightMonsterInformations = null;
         var _loc117_:Monster = null;
         var _loc118_:GameFightCharacterInformations = null;
         var _loc119_:Spell = null;
         var _loc120_:EffectInstanceDice = null;
         var _loc121_:GameContextActorInformations = null;
         var _loc122_:Number = NaN;
         var _loc123_:GameFightMonsterInformations = null;
         var _loc124_:Monster = null;
         var _loc125_:GameContextActorInformations = null;
         var _loc126_:GameFightMonsterInformations = null;
         var _loc127_:GameFightFighterInformations = null;
         var _loc128_:CastingSpell = null;
         var _loc129_:StateBuff = null;
         var _loc130_:Object = null;
         var _loc131_:int = 0;
         switch(true)
         {
            case param1 is GameFightRefreshFighterMessage:
               _loc3_ = param1 as GameFightRefreshFighterMessage;
               this.pushRefreshFighterStep(_loc3_.informations);
               return true;
            case param1 is GameActionFightCloseCombatMessage:
            case param1 is GameActionFightSpellCastMessage:
               if(!this._castingSpells)
               {
                  this._castingSpells = new Vector.<CastingSpell>();
               }
               if(param1 is GameActionFightSpellCastMessage)
               {
                  _loc4_ = param1 as GameActionFightSpellCastMessage;
               }
               else
               {
                  _loc82_ = param1 as GameActionFightCloseCombatMessage;
                  _loc5_ = true;
                  _loc6_ = _loc82_.weaponGenericId;
                  _loc4_ = new GameActionFightSpellCastMessage();
                  _loc4_.initGameActionFightSpellCastMessage(_loc82_.actionId,_loc82_.sourceId,_loc82_.targetId,_loc82_.destinationCellId,_loc82_.critical,_loc82_.silentCast,_loc82_.verboseCast);
                  if(_loc82_.sourceId == PlayedCharacterManager.getInstance().id)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_PLAYER_CLOSE_COMBAT);
                  }
               }
               _loc8_ = this.fightEntitiesFrame.getEntityInfos(_loc4_.sourceId).disposition.cellId;
               _loc9_ = new CastingSpell();
               _loc9_.casterId = _loc4_.sourceId;
               _loc9_.spell = Spell.getSpellById(_loc4_.spellId);
               _loc9_.spellRank = _loc9_.spell.getSpellLevel(_loc4_.spellLevel);
               _loc9_.isCriticalFail = _loc4_.critical == FightSpellCastCriticalEnum.CRITICAL_FAIL;
               _loc9_.isCriticalHit = _loc4_.critical == FightSpellCastCriticalEnum.CRITICAL_HIT;
               _loc9_.silentCast = _loc4_.silentCast;
               _loc9_.portalIds = _loc4_.portalsIds;
               _loc9_.portalMapPoints = MarkedCellsManager.getInstance().getMapPointsFromMarkIds(_loc4_.portalsIds);
               if(!this._fightBattleFrame.currentPlayerId)
               {
                  BuffManager.getInstance().spellBuffsToIgnore.push(_loc9_);
               }
               if(_loc4_.destinationCellId != -1)
               {
                  _loc9_.targetedCell = MapPoint.fromCellId(_loc4_.destinationCellId);
               }
               if(_loc4_ && _loc4_.actionId == 2029)
               {
                  _loc83_ = new SpellScriptBuffer(_loc9_);
                  _loc7_ = _loc9_.spell.getScriptId(_loc9_.isCriticalHit);
                  this.pushPlaySpellScriptStep(_loc7_,_loc4_.sourceId,_loc4_.destinationCellId,_loc4_.spellId,_loc4_.spellLevel,_loc83_);
                  _loc84_ = 0;
                  _loc85_ = true;
                  _loc86_ = 0;
                  while(_loc85_)
                  {
                     _loc85_ = false;
                     _loc87_ = 0;
                     while(_loc87_ < this._stepsBuffer.length)
                     {
                        if(this._stepsBuffer[_loc87_] == this._playSpellScriptStep)
                        {
                           _loc86_ = _loc87_;
                        }
                        if(this._spellScriptTemporaryBuffer)
                        {
                           _loc88_ = _loc84_;
                           while(_loc88_ < this._spellScriptTemporaryBuffer.stepsBuffer.length)
                           {
                              if(this._stepsBuffer[_loc87_] == this._spellScriptTemporaryBuffer.stepsBuffer[_loc88_])
                              {
                                 _loc85_ = true;
                                 _loc84_ = _loc88_;
                                 this._stepsBuffer = this._stepsBuffer.slice(0,_loc87_).concat(this._stepsBuffer.slice(_loc87_ + 1));
                                 break;
                              }
                              _loc88_++;
                           }
                        }
                        if(_loc85_)
                        {
                           break;
                        }
                        _loc87_++;
                     }
                  }
                  this._stepsBuffer = this._stepsBuffer.slice(0,_loc86_ + 1).concat(_loc83_.stepsBuffer).concat(this._stepsBuffer.slice(_loc86_ + 1));
                  return true;
               }
               if(this._castingSpell)
               {
                  if(_loc5_ && _loc6_ != 0)
                  {
                     this.pushCloseCombatStep(_loc4_.sourceId,_loc6_,_loc4_.critical,_loc4_.verboseCast);
                  }
                  else
                  {
                     this.pushSpellCastStep(_loc4_.sourceId,_loc4_.destinationCellId,_loc8_,_loc4_.spellId,_loc4_.spellLevel,_loc4_.critical,_loc4_.verboseCast);
                  }
                  _log.error("Il ne peut y avoir qu\'un seul cast de sort par séquence (" + param1 + ")");
                  this._castingSpells.push(_loc9_);
                  if(param1 is GameActionFightCloseCombatMessage)
                  {
                     this._castingSpell.weaponId = GameActionFightCloseCombatMessage(param1).weaponGenericId;
                     this.pushPlaySpellScriptStep(7,_loc4_.sourceId,_loc4_.destinationCellId,_loc4_.spellId,_loc4_.spellLevel);
                  }
                  else if(!this._castingSpell.isCriticalFail)
                  {
                     _loc7_ = this._castingSpell.spell.getScriptId(this._castingSpell.isCriticalHit);
                     this.pushPlaySpellScriptStep(_loc7_,_loc4_.sourceId,_loc4_.destinationCellId,_loc4_.spellId,_loc4_.spellLevel);
                  }
                  break;
               }
               this._castingSpell = _loc9_;
               this._spellScriptTemporaryBuffer = new SpellScriptBuffer(this._castingSpell);
               if(param1 is GameActionFightCloseCombatMessage)
               {
                  this._castingSpell.weaponId = GameActionFightCloseCombatMessage(param1).weaponGenericId;
                  this._playSpellScriptStep = this.pushPlaySpellScriptStep(7,_loc4_.sourceId,_loc4_.destinationCellId,_loc4_.spellId,_loc4_.spellLevel,this._spellScriptTemporaryBuffer);
               }
               else if(!this._castingSpell.isCriticalFail)
               {
                  _loc7_ = this._castingSpell.spell.getScriptId(this._castingSpell.isCriticalHit);
                  this._playSpellScriptStep = this.pushPlaySpellScriptStep(_loc7_,_loc4_.sourceId,_loc4_.destinationCellId,_loc4_.spellId,_loc4_.spellLevel,this._spellScriptTemporaryBuffer);
               }
               this._stepsBuffer = this._stepsBuffer.concat(this._spellScriptTemporaryBuffer.stepsBuffer);
               if(_loc4_.sourceId == CurrentPlayedFighterManager.getInstance().currentFighterId && _loc4_.critical != FightSpellCastCriticalEnum.CRITICAL_FAIL)
               {
                  _loc89_ = new Array();
                  _loc89_.push(_loc4_.targetId);
                  CurrentPlayedFighterManager.getInstance().getSpellCastManager().castSpell(_loc4_.spellId,_loc4_.spellLevel,_loc89_);
               }
               _loc10_ = _loc4_.critical == FightSpellCastCriticalEnum.CRITICAL_HIT;
               _loc11_ = FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary();
               _loc12_ = _loc11_[_loc4_.sourceId];
               if(_loc5_ && _loc6_ != 0)
               {
                  this.pushCloseCombatStep(_loc4_.sourceId,_loc6_,_loc4_.critical,_loc4_.verboseCast);
               }
               else
               {
                  this.pushSpellCastStep(_loc4_.sourceId,_loc4_.destinationCellId,_loc8_,_loc4_.spellId,_loc4_.spellLevel,_loc4_.critical,_loc4_.verboseCast);
               }
               if(_loc4_.sourceId == CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  KernelEventsManager.getInstance().processCallback(TriggerHookList.FightSpellCast);
               }
               _loc13_ = PlayedCharacterManager.getInstance();
               _loc14_ = false;
               if(_loc11_[_loc13_.id] && _loc12_ && (_loc11_[_loc13_.id] as GameFightFighterInformations).teamId == _loc12_.teamId)
               {
                  _loc14_ = true;
               }
               if(_loc4_.sourceId != _loc13_.id && _loc14_ && !this._castingSpell.isCriticalFail)
               {
                  _loc90_ = false;
                  for each(_loc92_ in _loc13_.spellsInventory)
                  {
                     if(_loc92_.id == _loc4_.spellId)
                     {
                        _loc90_ = true;
                        _loc91_ = _loc92_.spellLevelInfos;
                        break;
                     }
                  }
                  _loc93_ = Spell.getSpellById(_loc4_.spellId);
                  _loc94_ = _loc93_.getSpellLevel(_loc4_.spellLevel);
                  if(_loc94_.globalCooldown)
                  {
                     if(_loc90_)
                     {
                        if(_loc94_.globalCooldown == -1)
                        {
                           _loc98_ = _loc91_.minCastInterval;
                        }
                        else
                        {
                           _loc98_ = _loc94_.globalCooldown;
                        }
                        this.pushSpellCooldownVariationStep(_loc13_.id,0,_loc4_.spellId,_loc98_);
                     }
                     _loc95_ = this.fightEntitiesFrame.getEntitiesDictionnary();
                     _loc97_ = Kernel.getWorker().getFrame(SpellInventoryManagementFrame) as SpellInventoryManagementFrame;
                     for each(_loc96_ in _loc95_)
                     {
                        if(_loc96_ is GameFightCompanionInformations && _loc4_.sourceId != _loc96_.contextualId && (_loc96_ as GameFightCompanionInformations).masterId == _loc13_.id)
                        {
                           _loc99_ = new GameFightSpellCooldown();
                           _loc99_.initGameFightSpellCooldown(_loc4_.spellId,_loc94_.globalCooldown);
                           _loc97_.addSpellGlobalCoolDownInfo(_loc96_.contextualId,_loc99_);
                        }
                     }
                  }
               }
               _loc44_ = PlayedCharacterManager.getInstance().id;
               _loc45_ = this.fightEntitiesFrame.getEntityInfos(_loc4_.sourceId) as GameFightFighterInformations;
               _loc47_ = this.fightEntitiesFrame.getEntityInfos(_loc44_) as GameFightFighterInformations;
               if(_loc10_)
               {
                  if(_loc4_.sourceId == _loc44_)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CC_OWNER);
                  }
                  else if(_loc47_ && _loc45_.teamId == _loc47_.teamId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CC_ALLIED);
                  }
                  else
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CC_ENEMY);
                  }
               }
               else if(_loc4_.critical == FightSpellCastCriticalEnum.CRITICAL_FAIL)
               {
                  if(_loc4_.sourceId == _loc44_)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_EC_OWNER);
                  }
                  else if(_loc47_ && _loc45_.teamId == _loc47_.teamId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_EC_ALLIED);
                  }
                  else
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_EC_ENEMY);
                  }
               }
               _loc15_ = this.fightEntitiesFrame.getEntityInfos(_loc4_.targetId) as GameFightFighterInformations;
               if(_loc15_ && _loc15_.disposition.cellId == -1)
               {
                  for each(_loc101_ in this._castingSpell.spellRank.effects)
                  {
                     if(_loc101_.hasOwnProperty("zoneShape"))
                     {
                        _loc100_ = _loc101_.zoneShape;
                        break;
                     }
                  }
                  if(_loc100_ == SpellShapeEnum.P)
                  {
                     _loc102_ = DofusEntities.getEntity(_loc4_.targetId) as TiphonSprite;
                     if(_loc102_ && this._castingSpell && this._castingSpell.targetedCell)
                     {
                        _loc103_ = InteractiveCellManager.getInstance().getCell(this._castingSpell.targetedCell.cellId);
                        _loc104_ = _loc103_.parent.localToGlobal(new Point(_loc103_.x + _loc103_.width / 2,_loc103_.y + _loc103_.height / 2));
                        _loc102_.x = _loc104_.x;
                        _loc102_.y = _loc104_.y;
                     }
                  }
               }
               this._castingSpells.push(this._castingSpell);
               return true;
            case param1 is GameMapMovementMessage:
               _loc16_ = param1 as GameMapMovementMessage;
               if(_loc16_.actorId == CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  KernelEventsManager.getInstance().processCallback(TriggerHookList.PlayerFightMove);
               }
               _loc17_ = MapMovementAdapter.getClientMovement(_loc16_.keyMovements);
               _loc18_ = _loc17_.getCells();
               _loc2_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               _loc20_ = _loc18_.length;
               _loc19_ = 0;
               while(_loc19_ < _loc20_ - 1)
               {
                  _loc2_.saveFighterPosition(_loc16_.actorId,_loc18_[_loc19_]);
                  _loc105_ = DofusEntities.getEntity(_loc16_.actorId) as TiphonSprite;
                  _loc106_ = _loc105_.carriedEntity as AnimatedCharacter;
                  while(_loc106_)
                  {
                     _loc2_.saveFighterPosition(_loc106_.id,_loc18_[_loc19_]);
                     _loc106_ = _loc106_.carriedEntity as AnimatedCharacter;
                  }
                  _loc19_++;
               }
               _loc21_ = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame;
               if(_loc21_)
               {
                  _loc21_.entityMovement(_loc16_.actorId);
               }
               this.pushMovementStep(_loc16_.actorId,_loc17_);
               return true;
            case param1 is GameActionFightPointsVariationMessage:
               _loc22_ = param1 as GameActionFightPointsVariationMessage;
               this.pushPointsVariationStep(_loc22_.targetId,_loc22_.actionId,_loc22_.delta);
               return true;
            case param1 is GameActionFightLifeAndShieldPointsLostMessage:
               _loc23_ = param1 as GameActionFightLifeAndShieldPointsLostMessage;
               this.pushShieldPointsVariationStep(_loc23_.targetId,-_loc23_.shieldLoss,_loc23_.actionId);
               this.pushLifePointsVariationStep(_loc23_.targetId,-_loc23_.loss,-_loc23_.permanentDamages,_loc23_.actionId);
               return true;
            case param1 is GameActionFightLifePointsGainMessage:
               _loc24_ = param1 as GameActionFightLifePointsGainMessage;
               this.pushLifePointsVariationStep(_loc24_.targetId,_loc24_.delta,0,_loc24_.actionId);
               return true;
            case param1 is GameActionFightLifePointsLostMessage:
               _loc25_ = param1 as GameActionFightLifePointsLostMessage;
               this.pushLifePointsVariationStep(_loc25_.targetId,-_loc25_.loss,-_loc25_.permanentDamages,_loc25_.actionId);
               return true;
            case param1 is GameActionFightTeleportOnSameMapMessage:
               _loc26_ = param1 as GameActionFightTeleportOnSameMapMessage;
               _loc2_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               if(!this.isSpellTeleportingToPreviousPosition())
               {
                  if(!this._teleportThroughPortal)
                  {
                     _loc2_.saveFighterPosition(_loc26_.targetId,_loc2_.entitiesFrame.getEntityInfos(_loc26_.targetId).disposition.cellId);
                  }
                  else
                  {
                     _loc2_.saveFighterPosition(_loc26_.targetId,MarkedCellsManager.getInstance().getMarkDatas(this._teleportPortalId).cells[0]);
                  }
               }
               else if(_loc2_.getFighterPreviousPosition(_loc26_.targetId) == _loc26_.cellId)
               {
                  _loc2_.deleteFighterPreviousPosition(_loc26_.targetId);
               }
               this.pushTeleportStep(_loc26_.targetId,_loc26_.cellId);
               this._teleportThroughPortal = false;
               return true;
            case param1 is GameActionFightExchangePositionsMessage:
               _loc27_ = param1 as GameActionFightExchangePositionsMessage;
               _loc2_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               if(!this.isSpellTeleportingToPreviousPosition())
               {
                  _loc2_.saveFighterPosition(_loc27_.sourceId,_loc2_.entitiesFrame.getEntityInfos(_loc27_.sourceId).disposition.cellId);
               }
               else
               {
                  _loc2_.deleteFighterPreviousPosition(_loc27_.sourceId);
               }
               _loc2_.saveFighterPosition(_loc27_.targetId,_loc2_.entitiesFrame.getEntityInfos(_loc27_.targetId).disposition.cellId);
               this.pushExchangePositionsStep(_loc27_.sourceId,_loc27_.casterCellId,_loc27_.targetId,_loc27_.targetCellId);
               return true;
            case param1 is GameActionFightSlideMessage:
               _loc28_ = param1 as GameActionFightSlideMessage;
               _loc2_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               _loc29_ = _loc2_.entitiesFrame.getEntityInfos(_loc28_.targetId);
               if(_loc29_)
               {
                  _loc2_.saveFighterPosition(_loc28_.targetId,_loc29_.disposition.cellId);
                  this.pushSlideStep(_loc28_.targetId,_loc28_.startCellId,_loc28_.endCellId);
               }
               return true;
            case param1 is GameActionFightSummonMessage:
               _loc30_ = param1 as GameActionFightSummonMessage;
               for each(_loc107_ in _loc30_.summons)
               {
                  if(_loc30_.actionId == 1024 || _loc30_.actionId == 1097)
                  {
                     _loc108_ = new GameFightShowFighterRandomStaticPoseMessage();
                     _loc108_.initGameFightShowFighterRandomStaticPoseMessage(_loc107_);
                     Kernel.getWorker().getFrame(FightEntitiesFrame).process(_loc108_);
                     _loc109_ = DofusEntities.getEntity(_loc107_.contextualId) as Sprite;
                     if(_loc109_)
                     {
                        _loc109_.visible = false;
                     }
                     this.pushVisibilityStep(_loc107_.contextualId,true);
                  }
                  else
                  {
                     _loc110_ = new GameFightShowFighterMessage();
                     _loc110_.initGameFightShowFighterMessage(_loc107_);
                     Kernel.getWorker().getFrame(FightEntitiesFrame).process(_loc110_);
                     _loc111_ = DofusEntities.getEntity(_loc107_.contextualId) as Sprite;
                     if(_loc111_)
                     {
                        _loc111_.visible = false;
                     }
                     this.pushSummonStep(_loc30_.sourceId,_loc107_);
                     if(_loc30_.sourceId == CurrentPlayedFighterManager.getInstance().currentFighterId && _loc30_.actionId != 185)
                     {
                        _loc113_ = false;
                        _loc114_ = false;
                        if(_loc30_.actionId == 1008)
                        {
                           _loc113_ = true;
                        }
                        else
                        {
                           _loc115_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc107_.contextualId);
                           _loc113_ = false;
                           _loc116_ = _loc115_ as GameFightMonsterInformations;
                           if(_loc116_)
                           {
                              _loc117_ = Monster.getMonsterById(_loc116_.creatureGenericId);
                              if(_loc117_ && _loc117_.useBombSlot)
                              {
                                 _loc113_ = true;
                              }
                              if(_loc117_ && _loc117_.useSummonSlot)
                              {
                                 _loc114_ = true;
                              }
                           }
                           else
                           {
                              _loc118_ = _loc115_ as GameFightCharacterInformations;
                           }
                        }
                        if(_loc114_ || _loc118_)
                        {
                           CurrentPlayedFighterManager.getInstance().addSummonedCreature();
                        }
                        else if(_loc113_)
                        {
                           CurrentPlayedFighterManager.getInstance().addSummonedBomb();
                        }
                     }
                     _loc112_ = this._fightBattleFrame.getNextPlayableCharacterId();
                     if(this._fightBattleFrame.currentPlayerId != CurrentPlayedFighterManager.getInstance().currentFighterId && _loc112_ != CurrentPlayedFighterManager.getInstance().currentFighterId && _loc112_ == _loc107_.contextualId)
                     {
                        this._fightBattleFrame.prepareNextPlayableCharacter();
                     }
                  }
               }
               return true;
            case param1 is GameActionFightMarkCellsMessage:
               _loc31_ = param1 as GameActionFightMarkCellsMessage;
               _loc32_ = _loc31_.mark.markSpellId;
               if(this._castingSpell && this._castingSpell.spell && this._castingSpell.spell.id != 1750)
               {
                  this._castingSpell.markId = _loc31_.mark.markId;
                  this._castingSpell.markType = _loc31_.mark.markType;
                  _loc33_ = this._castingSpell.spellRank;
               }
               else
               {
                  _loc119_ = Spell.getSpellById(_loc32_);
                  _loc33_ = _loc119_.getSpellLevel(_loc31_.mark.markSpellLevel);
                  for each(_loc120_ in _loc33_.effects)
                  {
                     if(_loc120_.effectId == ActionIdConverter.ACTION_FIGHT_ADD_TRAP_CASTING_SPELL || _loc120_.effectId == ActionIdConverter.ACTION_FIGHT_ADD_GLYPH_CASTING_SPELL || _loc120_.effectId == ActionIdConverter.ACTION_FIGHT_ADD_GLYPH_CASTING_SPELL_ENDTURN)
                     {
                        _loc32_ = _loc120_.parameter0 as uint;
                        _loc33_ = Spell.getSpellById(_loc32_).getSpellLevel(_loc120_.parameter1 as uint);
                        break;
                     }
                  }
               }
               this.pushMarkCellsStep(_loc31_.mark.markId,_loc31_.mark.markType,_loc31_.mark.cells,_loc32_,_loc33_,_loc31_.mark.markTeamId,_loc31_.mark.markimpactCell);
               return true;
            case param1 is GameActionFightUnmarkCellsMessage:
               _loc34_ = param1 as GameActionFightUnmarkCellsMessage;
               this.pushUnmarkCellsStep(_loc34_.markId);
               return true;
            case param1 is GameActionFightChangeLookMessage:
               _loc35_ = param1 as GameActionFightChangeLookMessage;
               this.pushChangeLookStep(_loc35_.targetId,_loc35_.entityLook);
               return true;
            case param1 is GameActionFightInvisibilityMessage:
               _loc36_ = param1 as GameActionFightInvisibilityMessage;
               _loc37_ = this.fightEntitiesFrame.getEntityInfos(_loc36_.targetId);
               FightEntitiesFrame.getCurrentInstance().setLastKnownEntityPosition(_loc36_.targetId,_loc37_.disposition.cellId);
               FightEntitiesFrame.getCurrentInstance().setLastKnownEntityMovementPoint(_loc36_.targetId,0,true);
               this.pushChangeVisibilityStep(_loc36_.targetId,_loc36_.state);
               return true;
            case param1 is GameActionFightLeaveMessage:
               _loc38_ = param1 as GameActionFightLeaveMessage;
               _loc39_ = FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary();
               for each(_loc121_ in _loc39_)
               {
                  if(_loc121_ is GameFightFighterInformations)
                  {
                     _loc122_ = (_loc121_ as GameFightFighterInformations).stats.summoner;
                     if(_loc122_ == _loc38_.targetId)
                     {
                        this.pushDeathStep(_loc121_.contextualId);
                     }
                  }
               }
               this.pushDeathStep(_loc38_.targetId,false);
               _loc40_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc38_.targetId);
               if(_loc40_ is GameFightMonsterInformations)
               {
                  _loc123_ = _loc40_ as GameFightMonsterInformations;
                  if(CurrentPlayedFighterManager.getInstance().checkPlayableEntity(_loc123_.stats.summoner))
                  {
                     _loc124_ = Monster.getMonsterById(_loc123_.creatureGenericId);
                     if(_loc124_.useSummonSlot)
                     {
                        CurrentPlayedFighterManager.getInstance().removeSummonedCreature(_loc123_.stats.summoner);
                     }
                     if(_loc124_.useBombSlot)
                     {
                        CurrentPlayedFighterManager.getInstance().removeSummonedBomb(_loc123_.stats.summoner);
                     }
                  }
               }
               return true;
            case param1 is GameActionFightDeathMessage:
               _loc41_ = param1 as GameActionFightDeathMessage;
               _loc42_ = FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary();
               for each(_loc125_ in _loc42_)
               {
                  if(_loc125_ is GameFightFighterInformations)
                  {
                     _loc43_ = _loc125_ as GameFightFighterInformations;
                     if(_loc43_.alive && _loc43_.stats.summoner == _loc41_.targetId)
                     {
                        this.pushDeathStep(_loc125_.contextualId);
                     }
                  }
               }
               _loc44_ = PlayedCharacterManager.getInstance().id;
               _loc45_ = this.fightEntitiesFrame.getEntityInfos(_loc41_.sourceId) as GameFightFighterInformations;
               _loc46_ = this.fightEntitiesFrame.getEntityInfos(_loc41_.targetId) as GameFightFighterInformations;
               _loc47_ = this.fightEntitiesFrame.getEntityInfos(_loc44_) as GameFightFighterInformations;
               if(_loc41_.targetId != this._fightBattleFrame.currentPlayerId && (this._fightBattleFrame.slaveId == _loc41_.targetId || this._fightBattleFrame.masterId == _loc41_.targetId))
               {
                  this._fightBattleFrame.prepareNextPlayableCharacter(_loc41_.targetId);
               }
               if(_loc41_.targetId == _loc44_)
               {
                  if(_loc41_.sourceId == _loc41_.targetId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_HIMSELF);
                  }
                  else if(_loc45_.teamId != _loc47_.teamId)
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_BY_ENEMY);
                  }
                  else
                  {
                     SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_BY_ENEMY);
                  }
               }
               else if(_loc41_.sourceId == _loc44_)
               {
                  if(_loc46_)
                  {
                     if(_loc46_.teamId != _loc47_.teamId)
                     {
                        SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILL_ENEMY);
                     }
                     else
                     {
                        SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILL_ALLY);
                     }
                  }
               }
               this.pushDeathStep(_loc41_.targetId);
               _loc48_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc41_.targetId);
               _loc49_ = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
               _loc50_ = _loc49_ && _loc49_.myTurn && _loc41_.targetId != _loc44_ && TackleUtil.isTackling(_loc47_,_loc46_,_loc49_.lastPath);
               if(_loc48_ is GameFightMonsterInformations)
               {
                  _loc126_ = _loc48_ as GameFightMonsterInformations;
                  _loc126_.alive = false;
                  if(CurrentPlayedFighterManager.getInstance().checkPlayableEntity(_loc126_.stats.summoner))
                  {
                     _loc124_ = Monster.getMonsterById(_loc126_.creatureGenericId);
                     if(_loc124_.useSummonSlot)
                     {
                        CurrentPlayedFighterManager.getInstance().removeSummonedCreature(_loc126_.stats.summoner);
                     }
                     if(_loc124_.useBombSlot)
                     {
                        CurrentPlayedFighterManager.getInstance().removeSummonedBomb(_loc126_.stats.summoner);
                     }
                     SpellWrapper.refreshAllPlayerSpellHolder(_loc126_.stats.summoner);
                  }
               }
               else if(_loc48_ is GameFightFighterInformations)
               {
                  (_loc48_ as GameFightFighterInformations).alive = false;
                  if((_loc48_ as GameFightFighterInformations).stats.summoner != 0)
                  {
                     _loc127_ = _loc48_ as GameFightFighterInformations;
                     if(CurrentPlayedFighterManager.getInstance().checkPlayableEntity(_loc127_.stats.summoner))
                     {
                        CurrentPlayedFighterManager.getInstance().removeSummonedCreature(_loc127_.stats.summoner);
                        SpellWrapper.refreshAllPlayerSpellHolder(_loc127_.stats.summoner);
                     }
                  }
               }
               _loc2_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               if(_loc2_)
               {
                  _loc2_.outEntity(_loc41_.targetId);
               }
               FightEntitiesFrame.getCurrentInstance().updateRemovedEntity(_loc41_.targetId);
               if(_loc50_)
               {
                  _loc49_.updatePath();
               }
               return true;
            case param1 is GameActionFightVanishMessage:
               _loc51_ = param1 as GameActionFightVanishMessage;
               this.pushVanishStep(_loc51_.targetId,_loc51_.sourceId);
               _loc52_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc51_.targetId);
               if(_loc52_ is GameFightFighterInformations)
               {
                  (_loc52_ as GameFightFighterInformations).alive = false;
               }
               _loc2_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               if(_loc2_)
               {
                  _loc2_.outEntity(_loc51_.targetId);
               }
               FightEntitiesFrame.getCurrentInstance().updateRemovedEntity(_loc51_.targetId);
               return true;
            case param1 is GameActionFightTriggerEffectMessage:
               return true;
            case param1 is GameActionFightDispellEffectMessage:
               _loc53_ = param1 as GameActionFightDispellEffectMessage;
               this.pushDispellEffectStep(_loc53_.targetId,_loc53_.boostUID);
               return true;
            case param1 is GameActionFightDispellSpellMessage:
               _loc54_ = param1 as GameActionFightDispellSpellMessage;
               this.pushDispellSpellStep(_loc54_.targetId,_loc54_.spellId);
               return true;
            case param1 is GameActionFightDispellMessage:
               _loc55_ = param1 as GameActionFightDispellMessage;
               this.pushDispellStep(_loc55_.targetId);
               return true;
            case param1 is GameActionFightDodgePointLossMessage:
               _loc56_ = param1 as GameActionFightDodgePointLossMessage;
               this.pushPointsLossDodgeStep(_loc56_.targetId,_loc56_.actionId,_loc56_.amount);
               return true;
            case param1 is GameActionFightSpellCooldownVariationMessage:
               _loc57_ = param1 as GameActionFightSpellCooldownVariationMessage;
               this.pushSpellCooldownVariationStep(_loc57_.targetId,_loc57_.actionId,_loc57_.spellId,_loc57_.value);
               return true;
            case param1 is GameActionFightSpellImmunityMessage:
               _loc58_ = param1 as GameActionFightSpellImmunityMessage;
               this.pushSpellImmunityStep(_loc58_.targetId);
               return true;
            case param1 is GameActionFightKillMessage:
               _loc59_ = param1 as GameActionFightKillMessage;
               this.pushKillStep(_loc59_.targetId,_loc59_.sourceId);
               return true;
            case param1 is GameActionFightReduceDamagesMessage:
               _loc60_ = param1 as GameActionFightReduceDamagesMessage;
               this.pushReducedDamagesStep(_loc60_.targetId,_loc60_.amount);
               return true;
            case param1 is GameActionFightReflectDamagesMessage:
               _loc61_ = param1 as GameActionFightReflectDamagesMessage;
               this.pushReflectedDamagesStep(_loc61_.sourceId);
               return true;
            case param1 is GameActionFightReflectSpellMessage:
               _loc62_ = param1 as GameActionFightReflectSpellMessage;
               this.pushReflectedSpellStep(_loc62_.targetId);
               return true;
            case param1 is GameActionFightStealKamaMessage:
               _loc63_ = param1 as GameActionFightStealKamaMessage;
               this.pushStealKamasStep(_loc63_.sourceId,_loc63_.targetId,_loc63_.amount);
               return true;
            case param1 is GameActionFightTackledMessage:
               _loc64_ = param1 as GameActionFightTackledMessage;
               if(_loc64_.sourceId == PlayedCharacterManager.getInstance().id)
               {
                  SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_PLAYER_TACKLED);
               }
               this.pushTackledStep(_loc64_.sourceId);
               return true;
            case param1 is GameActionFightTriggerGlyphTrapMessage:
               if(this._castingSpell)
               {
                  this._fightBattleFrame.process(new SequenceEndMessage());
                  this._fightBattleFrame.process(new SequenceStartMessage());
                  this._fightBattleFrame.currentSequenceFrame.process(param1);
                  return true;
               }
               _loc65_ = param1 as GameActionFightTriggerGlyphTrapMessage;
               this.pushMarkTriggeredStep(_loc65_.triggeringCharacterId,_loc65_.sourceId,_loc65_.markId);
               this._castingSpell = new CastingSpell();
               this._castingSpell.casterId = _loc65_.sourceId;
               _loc66_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc65_.triggeringCharacterId) as GameFightFighterInformations;
               _loc67_ = !!_loc66_?int(_loc66_.disposition.cellId):-1;
               this._castingSpell.spell = Spell.getSpellById(1750);
               this._castingSpell.spellRank = this._castingSpell.spell.getSpellLevel(1);
               if(_loc67_ != -1)
               {
                  this._castingSpell.targetedCell = MapPoint.fromCellId(_loc67_);
                  this.pushPlaySpellScriptStep(1,_loc65_.triggeringCharacterId,_loc67_,this._castingSpell.spell.id,this._castingSpell.spellRank.grade);
               }
               _loc68_ = MarkedCellsManager.getInstance().getMarkDatas(_loc65_.markId);
               if(_loc68_ && _loc68_.markType == GameActionMarkTypeEnum.PORTAL)
               {
                  this._teleportThroughPortal = true;
                  this._teleportPortalId = _loc68_.markId;
               }
               return true;
            case param1 is GameActionFightActivateGlyphTrapMessage:
               _loc69_ = param1 as GameActionFightActivateGlyphTrapMessage;
               this.pushMarkActivateStep(_loc69_.markId,_loc69_.active);
               return true;
            case param1 is GameActionFightDispellableEffectMessage:
               _loc70_ = param1 as GameActionFightDispellableEffectMessage;
               for each(_loc128_ in this._castingSpells)
               {
                  if(_loc128_.spell.id == _loc70_.effect.spellId)
                  {
                     _loc71_ = _loc128_;
                     break;
                  }
               }
               if(!_loc71_)
               {
                  if(_loc70_.actionId == ActionIdConverter.ACTION_CHARACTER_UPDATE_BOOST)
                  {
                     _loc71_ = new CastingSpell(false);
                  }
                  else
                  {
                     _loc71_ = new CastingSpell(this._castingSpell == null);
                  }
                  if(this._castingSpell)
                  {
                     _loc71_.castingSpellId = this._castingSpell.castingSpellId;
                     if(this._castingSpell.spell && this._castingSpell.spell.id == _loc70_.effect.spellId)
                     {
                        _loc71_.spellRank = this._castingSpell.spellRank;
                     }
                  }
                  _loc71_.spell = Spell.getSpellById(_loc70_.effect.spellId);
                  _loc71_.casterId = _loc70_.sourceId;
               }
               _loc72_ = _loc70_.effect;
               _loc73_ = BuffManager.makeBuffFromEffect(_loc72_,_loc71_,_loc70_.actionId);
               if(_loc73_ is StateBuff)
               {
                  _loc129_ = _loc73_ as StateBuff;
                  if(_loc129_.actionId == ActionIdConverter.ACTION_FIGHT_DISABLE_STATE)
                  {
                     _loc130_ = new FightLeavingStateStep(_loc129_.targetId,_loc129_.stateId);
                  }
                  else
                  {
                     _loc130_ = new FightEnteringStateStep(_loc129_.targetId,_loc129_.stateId,_loc129_.effect.durationString);
                  }
                  if(_loc71_ != null)
                  {
                     _loc130_.castingSpellId = _loc71_.castingSpellId;
                  }
                  this._stepsBuffer.push(_loc130_);
               }
               if(_loc72_ is FightTemporaryBoostEffect)
               {
                  _loc131_ = _loc70_.actionId;
                  if(_loc131_ != ActionIdConverter.ACTION_CHARACTER_MAKE_INVISIBLE && _loc131_ != ActionIdConverter.ACTION_CHARACTER_UPDATE_BOOST && _loc131_ != ActionIdConverter.ACTION_CHARACTER_CHANGE_LOOK && _loc131_ != ActionIdConverter.ACTION_CHARACTER_CHANGE_COLOR && _loc131_ != ActionIdConverter.ACTION_CHARACTER_ADD_APPEARANCE && _loc131_ != ActionIdConverter.ACTION_FIGHT_SET_STATE)
                  {
                     this.pushTemporaryBoostStep(_loc70_.effect.targetId,_loc73_.effect.description,_loc73_.effect.duration,_loc73_.effect.durationString,_loc73_.effect.visibleInFightLog);
                  }
                  if(_loc131_ == ActionIdConverter.ACTION_CHARACTER_BOOST_SHIELD)
                  {
                     this.pushShieldPointsVariationStep(_loc70_.effect.targetId,(_loc73_ as StatBuff).delta,_loc131_);
                  }
               }
               this.pushDisplayBuffStep(_loc73_);
               return true;
            case param1 is GameActionFightModifyEffectsDurationMessage:
               _loc74_ = param1 as GameActionFightModifyEffectsDurationMessage;
               this.pushModifyEffectsDurationStep(_loc74_.sourceId,_loc74_.targetId,_loc74_.delta);
               return false;
            case param1 is GameActionFightCarryCharacterMessage:
               _loc75_ = param1 as GameActionFightCarryCharacterMessage;
               if(_loc75_.cellId != -1)
               {
                  _loc2_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
                  _loc2_.saveFighterPosition(_loc75_.targetId,_loc75_.cellId);
                  this.pushCarryCharacterStep(_loc75_.sourceId,_loc75_.targetId,_loc75_.cellId);
               }
               return false;
            case param1 is GameActionFightThrowCharacterMessage:
               _loc76_ = param1 as GameActionFightThrowCharacterMessage;
               _loc77_ = !!this._castingSpell?uint(this._castingSpell.targetedCell.cellId):uint(_loc76_.cellId);
               _loc2_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               _loc2_.saveFighterPosition(_loc76_.targetId,DofusEntities.getEntity(_loc76_.targetId).position.cellId);
               this.pushThrowCharacterStep(_loc76_.sourceId,_loc76_.targetId,_loc77_);
               return false;
            case param1 is GameActionFightDropCharacterMessage:
               _loc78_ = param1 as GameActionFightDropCharacterMessage;
               _loc79_ = _loc78_.cellId;
               if(_loc79_ == -1 && this._castingSpell)
               {
                  _loc79_ = this._castingSpell.targetedCell.cellId;
               }
               this.pushThrowCharacterStep(_loc78_.sourceId,_loc78_.targetId,_loc79_);
               return false;
            case param1 is GameActionFightInvisibleDetectedMessage:
               _loc80_ = param1 as GameActionFightInvisibleDetectedMessage;
               this.pushFightInvisibleTemporarilyDetectedStep(_loc80_.sourceId,_loc80_.cellId);
               FightEntitiesFrame.getCurrentInstance().setLastKnownEntityPosition(_loc80_.targetId,_loc80_.cellId);
               FightEntitiesFrame.getCurrentInstance().setLastKnownEntityMovementPoint(_loc80_.targetId,0);
               return true;
            case param1 is GameFightTurnListMessage:
               _loc81_ = param1 as GameFightTurnListMessage;
               this.pushTurnListStep(_loc81_.ids,_loc81_.deadsIds);
               return true;
            case param1 is AbstractGameActionMessage:
               _log.error("Unsupported game action " + param1 + " ! This action was discarded.");
               return true;
         }
         return false;
      }
      
      public function execute(param1:Function = null) : void
      {
         this._sequencer = new SerialSequencer(FIGHT_SEQUENCERS_CATEGORY);
         if(this._parent)
         {
            _log.info("Process sub sequence");
            this._parent.addSubSequence(this._sequencer);
         }
         else
         {
            _log.info("Execute sequence");
         }
         this.executeBuffer(param1);
      }
      
      private function executeBuffer(param1:Function) : void
      {
         var _loc6_:ISequencable = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Boolean = false;
         var _loc13_:Dictionary = null;
         var _loc14_:Dictionary = null;
         var _loc15_:Dictionary = null;
         var _loc16_:Dictionary = null;
         var _loc17_:Dictionary = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:* = undefined;
         var _loc21_:* = undefined;
         var _loc22_:WaitAnimationEventStep = null;
         var _loc23_:PlayAnimationStep = null;
         var _loc24_:FightDeathStep = null;
         var _loc25_:int = 0;
         var _loc26_:FightActionPointsVariationStep = null;
         var _loc27_:FightShieldPointsVariationStep = null;
         var _loc28_:FightLifeVariationStep = null;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:* = undefined;
         var _loc32_:uint = 0;
         var _loc2_:Array = [];
         var _loc3_:Dictionary = new Dictionary(true);
         var _loc4_:Dictionary = new Dictionary(true);
         var _loc5_:Dictionary = new Dictionary(true);
         var _loc7_:Boolean = false;
         for each(_loc6_ in this._stepsBuffer)
         {
            switch(true)
            {
               case _loc6_ is FightMarkTriggeredStep:
                  _loc7_ = true;
                  continue;
               default:
                  continue;
            }
         }
         _loc8_ = OptionManager.getOptionManager("dofus")["allowHitAnim"];
         _loc9_ = OptionManager.getOptionManager("dofus")["allowSpellEffects"];
         _loc10_ = [];
         _loc11_ = [];
         _loc13_ = new Dictionary();
         _loc14_ = new Dictionary(true);
         _loc15_ = new Dictionary(true);
         _loc16_ = new Dictionary(true);
         _loc17_ = new Dictionary(true);
         _loc18_ = 0;
         _loc19_ = this._stepsBuffer.length;
         while(--_loc19_ >= 0)
         {
            if(_loc12_ && _loc6_)
            {
               _loc6_.clear();
            }
            _loc12_ = true;
            _loc6_ = this._stepsBuffer[_loc19_];
            switch(true)
            {
               case _loc6_ is PlayAnimationStep:
                  _loc23_ = _loc6_ as PlayAnimationStep;
                  if(_loc23_.animation.indexOf(AnimationEnum.ANIM_HIT) != -1)
                  {
                     if(!_loc8_)
                     {
                        continue;
                     }
                     _loc23_.waitEvent = _loc7_;
                     if(_loc23_.target == null)
                     {
                        continue;
                     }
                     if(_loc3_[EntitiesManager.getInstance().getEntityID(_loc23_.target as IEntity)])
                     {
                        continue;
                     }
                     if(_loc4_[_loc23_.target])
                     {
                        continue;
                     }
                     if(_loc23_.animation != AnimationEnum.ANIM_HIT && _loc23_.animation != AnimationEnum.ANIM_HIT_CARRYING && !_loc23_.target.hasAnimation(_loc23_.animation,1))
                     {
                        _loc23_.animation = AnimationEnum.ANIM_HIT;
                     }
                     _loc4_[_loc23_.target] = true;
                  }
                  if(this._castingSpell && this._castingSpell.casterId < 0)
                  {
                     if(_loc13_[_loc23_.target])
                     {
                        _loc2_.unshift(_loc13_[_loc23_.target]);
                        delete _loc13_[_loc23_.target];
                     }
                     if(_loc23_.animation.indexOf(AnimationEnum.ANIM_ATTAQUE_BASE) != -1)
                     {
                        _loc13_[_loc23_.target] = new WaitAnimationEventStep(_loc23_);
                     }
                  }
                  break;
               case _loc6_ is FightDeathStep:
                  _loc24_ = _loc6_ as FightDeathStep;
                  _loc3_[_loc24_.entityId] = true;
                  _loc25_ = this._fightBattleFrame.targetedEntities.indexOf(_loc24_.entityId);
                  if(_loc25_ != -1)
                  {
                     this._fightBattleFrame.targetedEntities.splice(_loc25_,1);
                     TooltipManager.hide("tooltipOverEntity_" + _loc24_.entityId);
                  }
                  _loc18_++;
                  break;
               case _loc6_ is FightActionPointsVariationStep:
                  _loc26_ = _loc6_ as FightActionPointsVariationStep;
                  if(_loc26_.voluntarlyUsed)
                  {
                     _loc10_.push(_loc26_);
                     _loc12_ = false;
                     continue;
                  }
                  break;
               case _loc6_ is FightShieldPointsVariationStep:
                  _loc27_ = _loc6_ as FightShieldPointsVariationStep;
                  if(_loc27_.target == null)
                  {
                     break;
                  }
                  if(_loc27_.value < 0)
                  {
                     _loc27_.virtual = true;
                     if(_loc16_[_loc27_.target] == null)
                     {
                        _loc16_[_loc27_.target] = 0;
                     }
                     _loc16_[_loc27_.target] = _loc16_[_loc27_.target] + _loc27_.value;
                     _loc17_[_loc27_.target] = _loc27_;
                  }
                  this.showTargetTooltip(_loc27_.target.id);
                  break;
               case _loc6_ is FightLifeVariationStep:
                  _loc28_ = _loc6_ as FightLifeVariationStep;
                  if(_loc28_.target == null)
                  {
                     break;
                  }
                  if(_loc28_.delta < 0)
                  {
                     _loc5_[_loc28_.target] = _loc28_;
                  }
                  if(_loc14_[_loc28_.target] == null)
                  {
                     _loc14_[_loc28_.target] = 0;
                  }
                  _loc14_[_loc28_.target] = _loc14_[_loc28_.target] + _loc28_.delta;
                  _loc15_[_loc28_.target] = _loc28_;
                  this.showTargetTooltip(_loc28_.target.id);
                  break;
               case _loc6_ is AddGfxEntityStep:
               case _loc6_ is AddGfxInLineStep:
               case _loc6_ is AddGlyphGfxStep:
               case _loc6_ is ParableGfxMovementStep:
               case _loc6_ is AddWorldEntityStep:
                  if(!_loc9_)
                  {
                     continue;
                  }
                  break;
            }
            _loc12_ = false;
            _loc2_.unshift(_loc6_);
         }
         this._fightBattleFrame.deathPlayingNumber = _loc18_;
         for each(_loc20_ in _loc2_)
         {
            if(_loc20_ is FightLifeVariationStep && _loc14_[_loc20_.target] == 0 && _loc16_[_loc20_.target] != null)
            {
               _loc20_.skipTextEvent = true;
            }
         }
         for(_loc21_ in _loc14_)
         {
            if(_loc21_ != "null" && _loc14_[_loc21_] != 0)
            {
               _loc29_ = _loc2_.indexOf(_loc15_[_loc21_]);
               _loc2_.splice(_loc29_,0,new FightLossAnimStep(_loc21_,_loc14_[_loc21_],FightLifeVariationStep.COLOR));
            }
            _loc15_[_loc21_] = -1;
            _loc14_[_loc21_] = 0;
         }
         for(_loc21_ in _loc16_)
         {
            if(_loc21_ != "null" && _loc16_[_loc21_] != 0)
            {
               _loc30_ = _loc2_.indexOf(_loc17_[_loc21_]);
               _loc2_.splice(_loc30_,0,new FightLossAnimStep(_loc21_,_loc16_[_loc21_],FightShieldPointsVariationStep.COLOR));
            }
            _loc17_[_loc21_] = -1;
            _loc16_[_loc21_] = 0;
         }
         for each(_loc22_ in _loc13_)
         {
            _loc11_.push(_loc22_);
         }
         if(_loc8_)
         {
            for(_loc31_ in _loc5_)
            {
               if(!_loc4_[_loc31_])
               {
                  _loc32_ = 0;
                  while(_loc32_ < _loc2_.length)
                  {
                     if(_loc2_[_loc32_] == _loc5_[_loc31_])
                     {
                        _loc2_.splice(_loc32_,0,new PlayAnimationStep(_loc31_ as TiphonSprite,AnimationEnum.ANIM_HIT,true,false));
                        break;
                     }
                     _loc32_++;
                  }
                  continue;
               }
            }
         }
         _loc2_ = _loc10_.concat(_loc2_).concat(_loc11_);
         for each(_loc6_ in _loc2_)
         {
            this._sequencer.addStep(_loc6_);
         }
         this.clearBuffer();
         if(param1 != null && !this._parent)
         {
            this._sequenceEndCallback = param1;
            this._sequencer.addEventListener(SequencerEvent.SEQUENCE_END,this.onSequenceEnd);
         }
         _lastCastingSpell = this._castingSpell;
         this._scriptInit = true;
         if(!this._parent)
         {
            if(!this._subSequenceWaitingCount)
            {
               this._sequencer.start();
            }
            else
            {
               _log.warn("Waiting sub sequence init end (" + this._subSequenceWaitingCount + " seq)");
            }
         }
         else
         {
            if(param1 != null)
            {
               param1();
            }
            this._parent.subSequenceInitDone();
         }
      }
      
      private function onSequenceEnd(param1:SequencerEvent) : void
      {
         this._sequencer.removeEventListener(SequencerEvent.SEQUENCE_END,this.onSequenceEnd);
         this._sequenceEndCallback();
      }
      
      private function subSequenceInitDone() : void
      {
         this._subSequenceWaitingCount--;
         if(!this.isWaiting && this._sequencer && !this._sequencer.running)
         {
            _log.warn("Sub sequence init end -- Run main sequence");
            this._sequencer.start();
         }
      }
      
      private function pushRefreshFighterStep(param1:GameContextActorInformations) : void
      {
         this._stepsBuffer.push(new FightRefreshFighterStep(param1));
      }
      
      private function pushMovementStep(param1:Number, param2:MovementPath) : void
      {
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,param1)));
         var _loc3_:FightEntityMovementStep = new FightEntityMovementStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushTeleportStep(param1:Number, param2:int) : void
      {
         var _loc3_:FightTeleportStep = null;
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,param1)));
         if(param2 != -1)
         {
            _loc3_ = new FightTeleportStep(param1,MapPoint.fromCellId(param2));
            if(this.castingSpell != null)
            {
               _loc3_.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc3_);
         }
      }
      
      private function pushExchangePositionsStep(param1:Number, param2:int, param3:Number, param4:int) : void
      {
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,param1)));
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,param3)));
         var _loc5_:FightExchangePositionsStep = new FightExchangePositionsStep(param1,param2,param3,param4);
         if(this.castingSpell != null)
         {
            _loc5_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc5_);
      }
      
      private function pushSlideStep(param1:Number, param2:int, param3:int) : void
      {
         if(param2 < 0 || param3 < 0)
         {
            return;
         }
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,param1)));
         var _loc4_:FightEntitySlideStep = new FightEntitySlideStep(param1,MapPoint.fromCellId(param2),MapPoint.fromCellId(param3));
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushSummonStep(param1:Number, param2:GameFightFighterInformations) : void
      {
         var _loc3_:FightSummonStep = new FightSummonStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushVisibilityStep(param1:Number, param2:Boolean) : void
      {
         var _loc3_:FightVisibilityStep = new FightVisibilityStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushMarkCellsStep(param1:int, param2:int, param3:Vector.<GameActionMarkedCell>, param4:int, param5:SpellLevel, param6:int, param7:int) : void
      {
         var _loc8_:FightMarkCellsStep = new FightMarkCellsStep(param1,param2,param3,param4,param5,param6,param7);
         if(this.castingSpell != null)
         {
            _loc8_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc8_);
      }
      
      private function pushUnmarkCellsStep(param1:int) : void
      {
         var _loc2_:FightUnmarkCellsStep = new FightUnmarkCellsStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushChangeLookStep(param1:Number, param2:EntityLook) : void
      {
         var _loc3_:FightChangeLookStep = new FightChangeLookStep(param1,EntityLookAdapter.fromNetwork(param2));
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushChangeVisibilityStep(param1:Number, param2:int) : void
      {
         var _loc3_:FightChangeVisibilityStep = new FightChangeVisibilityStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushPointsVariationStep(param1:Number, param2:uint, param3:int) : void
      {
         var _loc4_:IFightStep = null;
         switch(param2)
         {
            case ActionIdConverter.ACTION_CHARACTER_ACTION_POINTS_USE:
               _loc4_ = new FightActionPointsVariationStep(param1,param3,true);
               break;
            case ActionIdConverter.ACTION_CHARACTER_ACTION_POINTS_LOST:
            case ActionIdConverter.ACTION_CHARACTER_ACTION_POINTS_WIN:
               _loc4_ = new FightActionPointsVariationStep(param1,param3,false);
               break;
            case ActionIdConverter.ACTION_CHARACTER_MOVEMENT_POINTS_USE:
               _loc4_ = new FightMovementPointsVariationStep(param1,param3,true);
               break;
            case ActionIdConverter.ACTION_CHARACTER_MOVEMENT_POINTS_LOST:
            case ActionIdConverter.ACTION_CHARACTER_MOVEMENT_POINTS_WIN:
               _loc4_ = new FightMovementPointsVariationStep(param1,param3,false);
               break;
            default:
               _log.warn("Points variation with unsupported action (" + param2 + "), skipping.");
               return;
         }
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushShieldPointsVariationStep(param1:Number, param2:int, param3:int) : void
      {
         var _loc4_:FightShieldPointsVariationStep = new FightShieldPointsVariationStep(param1,param2,param3);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushTemporaryBoostStep(param1:Number, param2:String, param3:int, param4:String, param5:Boolean = true) : void
      {
         var _loc6_:FightTemporaryBoostStep = new FightTemporaryBoostStep(param1,param2,param3,param4,param5);
         if(this.castingSpell != null)
         {
            _loc6_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc6_);
      }
      
      private function pushPointsLossDodgeStep(param1:Number, param2:uint, param3:int) : void
      {
         var _loc4_:IFightStep = null;
         switch(param2)
         {
            case ActionIdConverter.ACTION_FIGHT_SPELL_DODGED_PA:
               _loc4_ = new FightActionPointsLossDodgeStep(param1,param3);
               break;
            case ActionIdConverter.ACTION_FIGHT_SPELL_DODGED_PM:
               _loc4_ = new FightMovementPointsLossDodgeStep(param1,param3);
               break;
            default:
               _log.warn("Points dodge with unsupported action (" + param2 + "), skipping.");
               return;
         }
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushLifePointsVariationStep(param1:Number, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:FightLifeVariationStep = new FightLifeVariationStep(param1,param2,param3,param4);
         if(this.castingSpell != null)
         {
            _loc5_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc5_);
      }
      
      private function pushDeathStep(param1:Number, param2:Boolean = true) : void
      {
         var _loc3_:FightDeathStep = new FightDeathStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushVanishStep(param1:Number, param2:Number) : void
      {
         var _loc3_:FightVanishStep = new FightVanishStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushDispellStep(param1:Number) : void
      {
         var _loc2_:FightDispellStep = new FightDispellStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushDispellEffectStep(param1:Number, param2:int) : void
      {
         var _loc3_:FightDispellEffectStep = new FightDispellEffectStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushDispellSpellStep(param1:Number, param2:int) : void
      {
         var _loc3_:FightDispellSpellStep = new FightDispellSpellStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushSpellCooldownVariationStep(param1:Number, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:FightSpellCooldownVariationStep = new FightSpellCooldownVariationStep(param1,param2,param3,param4);
         if(this.castingSpell != null)
         {
            _loc5_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc5_);
      }
      
      private function pushSpellImmunityStep(param1:Number) : void
      {
         var _loc2_:FightSpellImmunityStep = new FightSpellImmunityStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushKillStep(param1:Number, param2:Number) : void
      {
         var _loc3_:FightKillStep = new FightKillStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushReducedDamagesStep(param1:Number, param2:int) : void
      {
         var _loc3_:FightReducedDamagesStep = new FightReducedDamagesStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushReflectedDamagesStep(param1:Number) : void
      {
         var _loc2_:FightReflectedDamagesStep = new FightReflectedDamagesStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushReflectedSpellStep(param1:Number) : void
      {
         var _loc2_:FightReflectedSpellStep = new FightReflectedSpellStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushPlaySpellScriptStep(param1:int, param2:Number, param3:int, param4:int, param5:uint, param6:SpellScriptBuffer = null) : FightPlaySpellScriptStep
      {
         var _loc7_:FightPlaySpellScriptStep = new FightPlaySpellScriptStep(param1,param2,param3,param4,param5,!!param6?param6:this);
         if(this.castingSpell != null)
         {
            _loc7_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc7_);
         return _loc7_;
      }
      
      private function pushSpellCastStep(param1:Number, param2:int, param3:int, param4:int, param5:uint, param6:uint, param7:Boolean) : void
      {
         var _loc8_:FightSpellCastStep = new FightSpellCastStep(param1,param2,param3,param4,param5,param6,param7);
         if(this.castingSpell != null)
         {
            _loc8_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc8_);
      }
      
      private function pushCloseCombatStep(param1:Number, param2:uint, param3:uint, param4:Boolean) : void
      {
         var _loc5_:FightCloseCombatStep = new FightCloseCombatStep(param1,param2,param3,param4);
         if(this.castingSpell != null)
         {
            _loc5_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc5_);
      }
      
      private function pushStealKamasStep(param1:Number, param2:Number, param3:uint) : void
      {
         var _loc4_:FightStealingKamasStep = new FightStealingKamasStep(param1,param2,param3);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushTackledStep(param1:Number) : void
      {
         var _loc2_:FightTackledStep = new FightTackledStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushMarkTriggeredStep(param1:Number, param2:Number, param3:int) : void
      {
         var _loc4_:FightMarkTriggeredStep = new FightMarkTriggeredStep(param1,param2,param3);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushMarkActivateStep(param1:int, param2:Boolean) : void
      {
         var _loc3_:FightMarkActivateStep = new FightMarkActivateStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function pushDisplayBuffStep(param1:BasicBuff) : void
      {
         var _loc2_:FightDisplayBuffStep = new FightDisplayBuffStep(param1);
         if(this.castingSpell != null)
         {
            _loc2_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc2_);
      }
      
      private function pushModifyEffectsDurationStep(param1:Number, param2:Number, param3:int) : void
      {
         var _loc4_:FightModifyEffectsDurationStep = new FightModifyEffectsDurationStep(param1,param2,param3);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushCarryCharacterStep(param1:Number, param2:Number, param3:int) : void
      {
         var _loc4_:FightCarryCharacterStep = new FightCarryCharacterStep(param1,param2,param3);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
         this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip,param2)));
      }
      
      private function pushThrowCharacterStep(param1:Number, param2:Number, param3:int) : void
      {
         var _loc4_:FightThrowCharacterStep = new FightThrowCharacterStep(param1,param2,param3);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
            _loc4_.portals = this.castingSpell.portalMapPoints;
            _loc4_.portalIds = this.castingSpell.portalIds;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushFightInvisibleTemporarilyDetectedStep(param1:Number, param2:uint) : void
      {
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         var _loc4_:FightInvisibleTemporarilyDetectedStep = new FightInvisibleTemporarilyDetectedStep(_loc3_,param2);
         if(this.castingSpell != null)
         {
            _loc4_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc4_);
      }
      
      private function pushTurnListStep(param1:Vector.<Number>, param2:Vector.<Number>) : void
      {
         var _loc3_:FightTurnListStep = new FightTurnListStep(param1,param2);
         if(this.castingSpell != null)
         {
            _loc3_.castingSpellId = this.castingSpell.castingSpellId;
         }
         this._stepsBuffer.push(_loc3_);
      }
      
      private function clearBuffer() : void
      {
         this._stepsBuffer = new Vector.<ISequencable>(0,false);
      }
      
      private function showTargetTooltip(param1:Number) : void
      {
         var _loc2_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc3_:GameFightFighterInformations = this.fightEntitiesFrame.getEntityInfos(param1) as GameFightFighterInformations;
         if(_loc3_.alive && this._castingSpell && (this._castingSpell.casterId == PlayedCharacterManager.getInstance().id || _loc2_.battleFrame.playingSlaveEntity) && param1 != this.castingSpell.casterId && this._fightBattleFrame.targetedEntities.indexOf(param1) == -1)
         {
            this._fightBattleFrame.targetedEntities.push(param1);
            if(OptionManager.getOptionManager("dofus")["showPermanentTargetsTooltips"] == true)
            {
               _loc2_.displayEntityTooltip(param1);
            }
         }
      }
      
      private function isSpellTeleportingToPreviousPosition() : Boolean
      {
         var _loc1_:EffectInstanceDice = null;
         if(this._castingSpell && this._castingSpell.spellRank)
         {
            for each(_loc1_ in this._castingSpell.spellRank.effects)
            {
               if(_loc1_.effectId == 1100)
               {
                  return true;
               }
            }
         }
         return false;
      }
   }
}
