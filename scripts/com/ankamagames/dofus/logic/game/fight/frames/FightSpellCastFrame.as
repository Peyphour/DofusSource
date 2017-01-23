package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.messages.AdjacentMapClickMessage;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.messages.CellOutMessage;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.renderers.ZoneClipRenderer;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.atouin.utils.IFightZoneRenderer;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.berilia.types.tooltip.TooltipPlacer;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.items.WeaponWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.BannerEmptySlotClickAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityClickAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOutAction;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOverAction;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.LinkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.managers.SpellZoneManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.ActionIdConverter;
   import com.ankamagames.dofus.logic.game.fight.miscs.DamageUtil;
   import com.ankamagames.dofus.logic.game.fight.miscs.TeleportationUtil;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.FightTeleportation;
   import com.ankamagames.dofus.logic.game.fight.types.FightTeleportationPreview;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.GameActionFightInvisibilityStateEnum;
   import com.ankamagames.dofus.network.enums.GameActionMarkTypeEnum;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCastOnTargetRequestMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCastRequestMessage;
   import com.ankamagames.dofus.network.messages.game.chat.ChatClientMultiMessage;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.Glyph;
   import com.ankamagames.dofus.types.entities.RiderBehavior;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseUpMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.map.LosDetector;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.jerakine.utils.display.Dofus2Line;
   import com.ankamagames.jerakine.utils.display.KeyPoll;
   import com.ankamagames.jerakine.utils.display.spellZone.SpellShapeEnum;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   
   public class FightSpellCastFrame implements Frame
   {
      
      private static var SWF_LIB:String = XmlConfig.getInstance().getEntry("config.ui.skin").concat("assets_tacticmod.swf");
      
      private static const FORBIDDEN_CURSOR:Class = FightSpellCastFrame_FORBIDDEN_CURSOR;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightSpellCastFrame));
      
      private static const RANGE_COLOR:Color = new Color(5533093);
      
      private static const LOS_COLOR:Color = new Color(2241433);
      
      private static const POSSIBLE_TARGET_CELL_COLOR:Color = new Color(3359897);
      
      private static const PORTAL_COLOR:Color = new Color(251623);
      
      private static const TARGET_CENTER_COLOR:Color = new Color(14487842);
      
      private static const TARGET_COLOR:Color = new Color(14487842);
      
      private static const SELECTION_RANGE:String = "SpellCastRange";
      
      private static const SELECTION_PORTALS:String = "SpellCastPortals";
      
      private static const SELECTION_LOS:String = "SpellCastLos";
      
      private static const SELECTION_TARGET:String = "SpellCastTarget";
      
      private static const SELECTION_CENTER_TARGET:String = "SELECTION_CENTER_TARGET";
      
      private static const FORBIDDEN_CURSOR_NAME:String = "SpellCastForbiddenCusror";
      
      private static var _currentTargetIsTargetable:Boolean;
       
      
      private var _spellLevel:Object;
      
      private var _spellId:uint;
      
      private var _rangeSelection:Selection;
      
      private var _losSelection:Selection;
      
      private var _portalsSelection:Selection;
      
      private var _targetSelection:Selection;
      
      private var _targetCenterSelection:Selection;
      
      private var _currentCell:int = -1;
      
      private var _virtualCast:Boolean;
      
      private var _cancelTimer:Timer;
      
      private var _cursorData:LinkedCursorData;
      
      private var _lastTargetStatus:Boolean = true;
      
      private var _isInfiniteTarget:Boolean;
      
      private var _usedWrapper;
      
      private var _targetingThroughPortal:Boolean;
      
      private var _clearTargetTimer:Timer;
      
      private var _spellmaximumRange:uint;
      
      private var _invocationPreview:Array;
      
      private var _fightTeleportationPreview:FightTeleportationPreview;
      
      private var _replacementInvocationPreview:AnimatedCharacter;
      
      private var _currentCellEntity:AnimatedCharacter;
      
      private var _fightContextFrame:FightContextFrame;
      
      public function FightSpellCastFrame(param1:uint)
      {
         var _loc3_:SpellWrapper = null;
         var _loc4_:EffectInstance = null;
         var _loc5_:TiphonEntityLook = null;
         var _loc6_:int = 0;
         var _loc7_:* = undefined;
         var _loc8_:Monster = null;
         var _loc9_:int = 0;
         var _loc10_:IEntity = null;
         var _loc11_:WeaponWrapper = null;
         this._invocationPreview = new Array();
         super();
         var _loc2_:FightEntitiesFrame = FightEntitiesFrame.getCurrentInstance();
         this._spellId = param1;
         this._cursorData = new LinkedCursorData();
         this._cursorData.sprite = new FORBIDDEN_CURSOR();
         this._cursorData.sprite.cacheAsBitmap = true;
         this._cursorData.offset = new Point(14,14);
         this._cancelTimer = new Timer(50);
         this._cancelTimer.addEventListener(TimerEvent.TIMER,this.cancelCast);
         if(param1 || !PlayedCharacterManager.getInstance().currentWeapon)
         {
            for each(_loc3_ in PlayedCharacterManager.getInstance().spellsInventory)
            {
               if(_loc3_.spellId == this._spellId)
               {
                  this._spellLevel = _loc3_;
                  if(this._spellId == 74)
                  {
                     _loc5_ = !!_loc2_.charactersMountsVisible?EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook):TiphonUtility.getLookWithoutMount(EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook));
                     _loc6_ = 1;
                  }
                  else if(this._spellId == 2763)
                  {
                     _loc5_ = EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook);
                     _loc6_ = 4;
                  }
                  else
                  {
                     for each(_loc4_ in this.currentSpell.effects)
                     {
                        if(_loc4_.effectId == 181 || _loc4_.effectId == 1008 || _loc4_.effectId == 1011)
                        {
                           _loc7_ = _loc4_.parameter0;
                           _loc8_ = Monster.getMonsterById(_loc7_);
                           _loc5_ = new TiphonEntityLook(_loc8_.look);
                           _loc6_ = 1;
                           break;
                        }
                     }
                  }
                  if(_loc5_)
                  {
                     _loc9_ = 0;
                     while(_loc9_ < _loc6_)
                     {
                        _loc10_ = new AnimatedCharacter(EntitiesManager.getInstance().getFreeEntityId(),_loc5_);
                        (_loc10_ as AnimatedCharacter).setCanSeeThrough(true);
                        (_loc10_ as AnimatedCharacter).transparencyAllowed = true;
                        (_loc10_ as AnimatedCharacter).alpha = 0.65;
                        (_loc10_ as AnimatedCharacter).mouseEnabled = false;
                        this._invocationPreview.push(_loc10_);
                        _loc9_++;
                     }
                  }
                  else
                  {
                     this.removeInvocationPreview();
                  }
                  break;
               }
            }
         }
         else
         {
            _loc11_ = PlayedCharacterManager.getInstance().currentWeapon;
            this._spellLevel = {
               "effects":_loc11_.effects,
               "castTestLos":_loc11_.castTestLos,
               "castInLine":_loc11_.castInLine,
               "castInDiagonal":_loc11_.castInDiagonal,
               "minRange":_loc11_.minRange,
               "range":_loc11_.range,
               "apCost":_loc11_.apCost,
               "needFreeCell":false,
               "needTakenCell":false,
               "needFreeTrapCell":false,
               "name":_loc11_.name
            };
         }
         this._clearTargetTimer = new Timer(50,1);
         this._clearTargetTimer.addEventListener(TimerEvent.TIMER,this.onClearTarget);
      }
      
      public static function isCurrentTargetTargetable() : Boolean
      {
         return _currentTargetIsTargetable;
      }
      
      public static function updateRangeAndTarget() : void
      {
         var _loc1_:FightSpellCastFrame = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame;
         if(_loc1_)
         {
            _loc1_.removeRange();
            _loc1_.drawRange();
            _loc1_.refreshTarget(true);
         }
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function get currentSpell() : Object
      {
         return this._spellLevel;
      }
      
      public function get hasInvocationPreview() : Boolean
      {
         return this._invocationPreview.length > 0;
      }
      
      public function get invocationPreview() : Array
      {
         return this._invocationPreview;
      }
      
      public function get spellId() : uint
      {
         return this._spellId;
      }
      
      public function isReplacementInvocation(param1:AnimatedCharacter) : Boolean
      {
         return this._replacementInvocationPreview == param1;
      }
      
      public function pushed() : Boolean
      {
         var _loc2_:FightEntitiesFrame = null;
         var _loc3_:Dictionary = null;
         var _loc4_:GameContextActorInformations = null;
         var _loc5_:GameFightFighterInformations = null;
         var _loc6_:AnimatedCharacter = null;
         Atouin.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         this._fightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         var _loc1_:FightBattleFrame = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame;
         if(_loc1_.playingSlaveEntity)
         {
            _loc2_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
            _loc3_ = _loc2_.getEntitiesDictionnary();
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = _loc4_ as GameFightFighterInformations;
               _loc6_ = DofusEntities.getEntity(_loc5_.contextualId) as AnimatedCharacter;
               if(_loc6_ && _loc5_.contextualId != CurrentPlayedFighterManager.getInstance().currentFighterId && _loc5_.stats.invisibilityState == GameActionFightInvisibilityStateEnum.DETECTED)
               {
                  _loc6_.setCanSeeThrough(true);
               }
            }
         }
         this._cancelTimer.reset();
         this._lastTargetStatus = true;
         if(this._spellId == 0)
         {
            if(PlayedCharacterManager.getInstance().currentWeapon)
            {
               this._usedWrapper = PlayedCharacterManager.getInstance().currentWeapon;
            }
            else
            {
               this._usedWrapper = SpellWrapper.create(0,1,false,PlayedCharacterManager.getInstance().id);
            }
         }
         else
         {
            this._usedWrapper = SpellWrapper.getSpellWrapperById(this._spellId,CurrentPlayedFighterManager.getInstance().currentFighterId);
         }
         KernelEventsManager.getInstance().processCallback(HookList.CastSpellMode,this._usedWrapper);
         this.drawRange();
         this.refreshTarget();
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:CellOverMessage = null;
         var _loc3_:CellOutMessage = null;
         var _loc4_:IEntity = null;
         var _loc5_:EntityMouseOverMessage = null;
         var _loc6_:TimelineEntityOverAction = null;
         var _loc7_:IEntity = null;
         var _loc8_:TimelineEntityOutAction = null;
         var _loc9_:IEntity = null;
         var _loc10_:CellClickMessage = null;
         var _loc11_:EntityClickMessage = null;
         var _loc12_:TimelineEntityClickAction = null;
         var _loc13_:IEntity = null;
         switch(true)
         {
            case param1 is CellOverMessage:
               _loc2_ = param1 as CellOverMessage;
               FightContextFrame.currentCell = _loc2_.cellId;
               this.refreshTarget();
               return false;
            case param1 is EntityMouseOutMessage:
               this.clearTarget();
               return false;
            case param1 is CellOutMessage:
               _loc3_ = param1 as CellOutMessage;
               _loc4_ = EntitiesManager.getInstance().getEntityOnCell(_loc3_.cellId,AnimatedCharacter);
               if(_loc4_ && this._fightTeleportationPreview && FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc4_.id))
               {
                  this.removeTeleportationPreview();
               }
               if(!this._fightTeleportationPreview)
               {
                  this.removeReplacementInvocationPreview();
               }
               this.clearTarget();
               return false;
            case param1 is EntityMouseOverMessage:
               _loc5_ = param1 as EntityMouseOverMessage;
               FightContextFrame.currentCell = _loc5_.entity.position.cellId;
               this.refreshTarget();
               return false;
            case param1 is TimelineEntityOverAction:
               _loc6_ = param1 as TimelineEntityOverAction;
               _loc7_ = DofusEntities.getEntity(_loc6_.targetId);
               if(_loc7_ && _loc7_.position && _loc7_.position.cellId > -1)
               {
                  FightContextFrame.currentCell = _loc7_.position.cellId;
                  this.refreshTarget();
               }
               return false;
            case param1 is TimelineEntityOutAction:
               _loc8_ = param1 as TimelineEntityOutAction;
               _loc9_ = DofusEntities.getEntity(_loc8_.targetId);
               if(_loc9_ && _loc9_.position && _loc9_.position.cellId == this._currentCell)
               {
                  this.removeTeleportationPreview();
                  this.removeReplacementInvocationPreview();
               }
               return false;
            case param1 is CellClickMessage:
               _loc10_ = param1 as CellClickMessage;
               this.castSpell(_loc10_.cellId);
               return true;
            case param1 is EntityClickMessage:
               _loc11_ = param1 as EntityClickMessage;
               if(this._invocationPreview.length > 0)
               {
                  for each(_loc13_ in this._invocationPreview)
                  {
                     if(_loc13_.id == _loc11_.entity.id)
                     {
                        this.castSpell(_loc11_.entity.position.cellId);
                        return true;
                     }
                  }
               }
               this.castSpell(_loc11_.entity.position.cellId,_loc11_.entity.id);
               return true;
            case param1 is TimelineEntityClickAction:
               _loc12_ = param1 as TimelineEntityClickAction;
               this.castSpell(0,_loc12_.fighterId);
               return true;
            case param1 is AdjacentMapClickMessage:
            case param1 is MouseRightClickMessage:
               this.cancelCast();
               return true;
            case param1 is BannerEmptySlotClickAction:
               this.cancelCast();
               return true;
            case param1 is MouseUpMessage:
               if(!KeyPoll.getInstance().isDown(Keyboard.ALTERNATE))
               {
                  this._cancelTimer.start();
               }
               return false;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         var _loc2_:FightEntitiesFrame = null;
         var _loc3_:Dictionary = null;
         var _loc4_:GameContextActorInformations = null;
         var _loc5_:AnimatedCharacter = null;
         Atouin.getInstance().options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         var _loc1_:FightBattleFrame = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame;
         if(_loc1_ && _loc1_.playingSlaveEntity)
         {
            _loc2_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
            _loc3_ = _loc2_.getEntitiesDictionnary();
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = DofusEntities.getEntity(_loc4_.contextualId) as AnimatedCharacter;
               if(_loc5_ && _loc4_.contextualId != CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  _loc5_.setCanSeeThrough(false);
               }
            }
         }
         this._clearTargetTimer.stop();
         this._clearTargetTimer.removeEventListener(TimerEvent.TIMER,this.onClearTarget);
         this._cancelTimer.stop();
         this._cancelTimer.removeEventListener(TimerEvent.TIMER,this.cancelCast);
         this.hideTargetsTooltips();
         this.removeRange();
         this.removeTarget();
         this.removeInvocationPreview();
         LinkedCursorSpriteManager.getInstance().removeItem(FORBIDDEN_CURSOR_NAME);
         this.removeTeleportationPreview();
         this.removeReplacementInvocationPreview();
         try
         {
            KernelEventsManager.getInstance().processCallback(HookList.CancelCastSpell,SpellWrapper.getSpellWrapperById(this._spellId,CurrentPlayedFighterManager.getInstance().currentFighterId));
         }
         catch(e:Error)
         {
         }
         return true;
      }
      
      public function entityMovement(param1:Number) : void
      {
         if(this._currentCellEntity && this._currentCellEntity.id == param1)
         {
            this.removeReplacementInvocationPreview();
            if(this._fightTeleportationPreview)
            {
               this.removeTeleportationPreview();
            }
         }
         else if(this._fightTeleportationPreview && (this._fightTeleportationPreview.getEntitiesIds().indexOf(param1) != -1 || this._fightTeleportationPreview.getTelefraggedEntitiesIds().indexOf(param1) != -1))
         {
            this.removeTeleportationPreview();
         }
      }
      
      public function refreshTarget(param1:Boolean = false) : void
      {
         var _loc7_:Number = NaN;
         var _loc8_:GameFightFighterInformations = null;
         var _loc9_:IFightZoneRenderer = null;
         var _loc10_:Boolean = false;
         var _loc11_:uint = 0;
         var _loc12_:IZone = null;
         var _loc13_:Boolean = false;
         var _loc14_:Vector.<uint> = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:Array = null;
         var _loc19_:int = 0;
         var _loc20_:TiphonSprite = null;
         var _loc21_:IEntity = null;
         var _loc22_:IEntity = null;
         if(this._clearTargetTimer.running)
         {
            this._clearTargetTimer.reset();
         }
         var _loc2_:int = FightContextFrame.currentCell;
         if(_loc2_ == -1)
         {
            return;
         }
         this._targetingThroughPortal = false;
         var _loc3_:int = -1;
         if(SelectionManager.getInstance().isInside(_loc2_,SELECTION_PORTALS) && SelectionManager.getInstance().isInside(_loc2_,SELECTION_LOS) && this._spellId != 0)
         {
            _loc3_ = this.getTargetThroughPortal(_loc2_,true);
            if(_loc3_ != _loc2_)
            {
               this._targetingThroughPortal = true;
               _loc2_ = _loc3_;
            }
         }
         this.removeReplacementInvocationPreview();
         if(!param1 && (this._currentCell == _loc2_ && this._currentCell != _loc3_))
         {
            if(this._targetSelection && this.isValidCell(_loc2_))
            {
               this.showTargetsTooltips(this._targetSelection);
               this.showReplacementInvocationPreview();
               this.showTeleportationPreview();
            }
            return;
         }
         this._currentCell = _loc2_;
         var _loc4_:Array = EntitiesManager.getInstance().getEntitiesOnCell(this._currentCell,AnimatedCharacter);
         this._currentCellEntity = _loc4_.length > 0?this.getParentEntity(_loc4_[0]) as AnimatedCharacter:null;
         var _loc5_:FightTurnFrame = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
         if(!_loc5_)
         {
            return;
         }
         var _loc6_:Boolean = _loc5_.myTurn;
         _currentTargetIsTargetable = this.isValidCell(_loc2_);
         if(_currentTargetIsTargetable)
         {
            if(!this._targetSelection)
            {
               this._targetSelection = new Selection();
               this._targetSelection.renderer = this.createZoneRenderer(TARGET_COLOR);
               this._targetSelection.color = TARGET_COLOR;
               this._targetCenterSelection = new Selection();
               this._targetCenterSelection.renderer = this.createZoneRenderer(TARGET_CENTER_COLOR,!!Atouin.getInstance().options.transparentOverlayMode?uint(PlacementStrataEnums.STRATA_NO_Z_ORDER):uint(PlacementStrataEnums.STRATA_AREA));
               this._targetCenterSelection.color = TARGET_CENTER_COLOR;
               _loc10_ = true;
               _loc11_ = this.getSpellShape(this._spellLevel);
               if(_loc11_ == SpellShapeEnum.l)
               {
                  _loc10_ = false;
               }
               _loc12_ = SpellZoneManager.getInstance().getSpellZone(this._spellLevel,true,_loc10_);
               this._spellmaximumRange = _loc12_.radius;
               this._targetSelection.zone = _loc12_;
               this._targetCenterSelection.zone = new Cross(0,0,DataMapProvider.getInstance());
               SelectionManager.getInstance().addSelection(this._targetCenterSelection,SELECTION_CENTER_TARGET);
               SelectionManager.getInstance().addSelection(this._targetSelection,SELECTION_TARGET);
            }
            _loc7_ = CurrentPlayedFighterManager.getInstance().currentFighterId;
            _loc8_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc7_) as GameFightFighterInformations;
            if(_loc8_)
            {
               if(this._targetingThroughPortal)
               {
                  this._targetSelection.zone.direction = MapPoint(MapPoint.fromCellId(_loc8_.disposition.cellId)).advancedOrientationTo(MapPoint.fromCellId(FightContextFrame.currentCell),false);
               }
               else
               {
                  this._targetSelection.zone.direction = MapPoint(MapPoint.fromCellId(_loc8_.disposition.cellId)).advancedOrientationTo(MapPoint.fromCellId(_loc2_),false);
               }
            }
            _loc9_ = this._targetSelection.renderer as IFightZoneRenderer;
            if(Atouin.getInstance().options.transparentOverlayMode && this._spellmaximumRange != 63)
            {
               _loc9_.currentStrata = PlacementStrataEnums.STRATA_NO_Z_ORDER;
               SelectionManager.getInstance().update(SELECTION_TARGET,_loc2_,true);
               SelectionManager.getInstance().update(SELECTION_CENTER_TARGET,_loc2_,true);
            }
            else
            {
               if(_loc9_.currentStrata == PlacementStrataEnums.STRATA_NO_Z_ORDER)
               {
                  _loc9_.currentStrata = PlacementStrataEnums.STRATA_AREA;
                  _loc13_ = true;
               }
               SelectionManager.getInstance().update(SELECTION_TARGET,_loc2_,_loc13_);
               SelectionManager.getInstance().update(SELECTION_CENTER_TARGET,_loc2_,_loc13_);
            }
            if(_loc6_)
            {
               LinkedCursorSpriteManager.getInstance().removeItem(FORBIDDEN_CURSOR_NAME);
               this._lastTargetStatus = true;
            }
            else
            {
               if(this._lastTargetStatus)
               {
                  LinkedCursorSpriteManager.getInstance().addItem(FORBIDDEN_CURSOR_NAME,this._cursorData,true);
               }
               this._lastTargetStatus = false;
            }
            if(this._invocationPreview.length > 0)
            {
               if(this._spellId == 2763)
               {
                  _loc14_ = new Vector.<uint>();
                  _loc14_.push(this._currentCell);
                  _loc14_ = _loc14_.concat(LinkedCellsManager.getInstance().getLinks(MapPoint.fromCellId(FightContextFrame.currentCell),MarkedCellsManager.getInstance().getMarksMapPoint(GameActionMarkTypeEnum.PORTAL)));
                  _loc15_ = MapPoint.fromCellId(_loc8_.disposition.cellId).x;
                  _loc16_ = MapPoint.fromCellId(_loc8_.disposition.cellId).y;
                  _loc17_ = MapPoint.fromCellId(_loc8_.disposition.cellId).distanceTo(MapPoint.fromCellId(this._currentCell));
                  _loc18_ = [MapPoint.fromCoords(_loc15_ + _loc17_,_loc16_),MapPoint.fromCoords(_loc15_ - _loc17_,_loc16_),MapPoint.fromCoords(_loc15_,_loc16_ + _loc17_),MapPoint.fromCoords(_loc15_,_loc16_ - _loc17_)];
                  _loc19_ = 0;
                  while(_loc19_ < 4)
                  {
                     _loc22_ = this._invocationPreview[_loc19_];
                     _loc20_ = _loc22_ as TiphonSprite;
                     if(_loc20_ && _loc20_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) && !_loc20_.getSubEntityBehavior(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER))
                     {
                        _loc20_.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,new RiderBehavior());
                     }
                     _loc22_.position = _loc18_[_loc19_];
                     (_loc22_ as AnimatedCharacter).setDirection(MapPoint.fromCellId(_loc8_.disposition.cellId).advancedOrientationTo(_loc22_.position,true));
                     if(!this._targetingThroughPortal && this.isValidCell(_loc22_.position.cellId) && _loc14_.indexOf(_loc22_.position.cellId) == -1)
                     {
                        (_loc22_ as AnimatedCharacter).display(PlacementStrataEnums.STRATA_PLAYER);
                        (_loc22_ as AnimatedCharacter).visible = true;
                     }
                     else
                     {
                        (_loc22_ as AnimatedCharacter).visible = false;
                     }
                     _loc19_++;
                  }
               }
               else
               {
                  _loc21_ = this._invocationPreview[0];
                  (_loc21_ as AnimatedCharacter).visible = true;
                  _loc21_.position = MapPoint.fromCellId(this._currentCell);
                  _loc20_ = _loc21_ as TiphonSprite;
                  if(_loc20_ && _loc20_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) && !_loc20_.getSubEntityBehavior(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER))
                  {
                     _loc20_.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,new RiderBehavior());
                  }
                  (_loc21_ as AnimatedCharacter).setDirection(MapPoint.fromCellId(_loc8_.disposition.cellId).advancedOrientationTo(MapPoint.fromCellId(this._currentCell),true));
                  (_loc21_ as AnimatedCharacter).display(PlacementStrataEnums.STRATA_PLAYER);
               }
            }
            this.showTargetsTooltips(this._targetSelection);
            this.showReplacementInvocationPreview();
            this.showTeleportationPreview();
         }
         else
         {
            if(this._invocationPreview.length > 0)
            {
               for each(_loc22_ in this._invocationPreview)
               {
                  (_loc22_ as AnimatedCharacter).visible = false;
               }
            }
            if(this._lastTargetStatus)
            {
               LinkedCursorSpriteManager.getInstance().addItem(FORBIDDEN_CURSOR_NAME,this._cursorData,true);
            }
            this.removeTarget();
            this._lastTargetStatus = false;
            this.hideTargetsTooltips();
            this.removeTeleportationPreview();
            this.removeReplacementInvocationPreview();
         }
      }
      
      public function isTeleportationPreviewEntity(param1:Number) : Boolean
      {
         return this._fightTeleportationPreview && this._fightTeleportationPreview.isPreview(param1);
      }
      
      private function removeInvocationPreview() : void
      {
         var _loc1_:IEntity = null;
         for each(_loc1_ in this._invocationPreview)
         {
            (_loc1_ as AnimatedCharacter).remove();
            (_loc1_ as AnimatedCharacter).destroy();
            _loc1_ = null;
         }
      }
      
      private function showReplacementInvocationPreview() : void
      {
         var _loc3_:EffectInstance = null;
         var _loc4_:AnimatedCharacter = null;
         var _loc5_:Monster = null;
         var _loc6_:AnimatedCharacter = null;
         var _loc1_:SpellWrapper = this._usedWrapper as SpellWrapper;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Vector.<EffectInstance> = _loc1_.effects.concat(_loc1_.criticalEffect);
         var _loc7_:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(CurrentPlayedFighterManager.getInstance().currentFighterId) as GameFightFighterInformations;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.effectId == 405 || _loc3_.effectId == 2796)
            {
               if(this._currentCellEntity && DamageUtil.verifySpellEffectMask(PlayedCharacterManager.getInstance().id,this._currentCellEntity.id,_loc3_,this._currentCell))
               {
                  this._currentCellEntity.visible = false;
                  TooltipManager.hide("tooltipOverEntity_" + this._currentCellEntity.id);
                  _loc5_ = Monster.getMonsterById(_loc3_.parameter0 as uint);
                  this._replacementInvocationPreview = new AnimatedCharacter(EntitiesManager.getInstance().getFreeEntityId(),new TiphonEntityLook(_loc5_.look));
                  this._replacementInvocationPreview.setCanSeeThrough(true);
                  this._replacementInvocationPreview.transparencyAllowed = true;
                  this._replacementInvocationPreview.alpha = 0.65;
                  this._replacementInvocationPreview.mouseEnabled = false;
                  this._replacementInvocationPreview.visible = true;
                  this._replacementInvocationPreview.position = MapPoint.fromCellId(this._currentCell);
                  this._replacementInvocationPreview.setDirection(MapPoint.fromCellId(_loc7_.disposition.cellId).advancedOrientationTo(MapPoint.fromCellId(this._currentCell),true));
                  this._replacementInvocationPreview.display(PlacementStrataEnums.STRATA_PLAYER);
                  break;
               }
            }
         }
      }
      
      private function removeReplacementInvocationPreview() : void
      {
         if(this._replacementInvocationPreview)
         {
            this._replacementInvocationPreview.destroy();
            this._replacementInvocationPreview = null;
         }
         if(this._currentCellEntity)
         {
            this._currentCellEntity.visible = true;
         }
      }
      
      public function drawRange() : void
      {
         var _loc8_:Cross = null;
         var _loc16_:uint = 0;
         var _loc17_:Vector.<uint> = null;
         var _loc18_:Vector.<uint> = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:uint = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:uint = 0;
         var _loc25_:MarkInstance = null;
         var _loc26_:Vector.<MapPoint> = null;
         var _loc27_:Vector.<uint> = null;
         var _loc28_:MapPoint = null;
         var _loc29_:MapPoint = null;
         var _loc30_:Vector.<Point> = null;
         var _loc31_:MapPoint = null;
         var _loc32_:Point = null;
         var _loc33_:Vector.<uint> = null;
         var _loc1_:Number = CurrentPlayedFighterManager.getInstance().currentFighterId;
         var _loc2_:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc1_) as GameFightFighterInformations;
         var _loc3_:uint = _loc2_.disposition.cellId;
         var _loc4_:CharacterBaseCharacteristic = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().range;
         var _loc5_:int = this._spellLevel.range;
         var _loc6_:uint = this.getSpellShape(this._spellLevel);
         var _loc7_:Boolean = this._spellLevel.castInLine || _loc6_ == SpellShapeEnum.l;
         if(!_loc7_ && !this._spellLevel.castInDiagonal && !this._spellLevel.castTestLos && _loc5_ == 63)
         {
            this._isInfiniteTarget = true;
            return;
         }
         this._isInfiniteTarget = false;
         if(this._spellLevel["rangeCanBeBoosted"])
         {
            _loc5_ = _loc5_ + (_loc4_.base + _loc4_.objectsAndMountBonus + _loc4_.alignGiftBonus + _loc4_.contextModif);
            if(_loc5_ < this._spellLevel.minRange)
            {
               _loc5_ = this._spellLevel.minRange;
            }
         }
         _loc5_ = Math.min(_loc5_,AtouinConstants.MAP_WIDTH * AtouinConstants.MAP_HEIGHT);
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         this._rangeSelection = new Selection();
         this._rangeSelection.renderer = this.createZoneRenderer(RANGE_COLOR,PlacementStrataEnums.STRATA_AREA);
         this._rangeSelection.color = RANGE_COLOR;
         this._rangeSelection.alpha = true;
         if(_loc7_ && this._spellLevel.castInDiagonal)
         {
            _loc8_ = new Cross(this._spellLevel.minRange,_loc5_,DataMapProvider.getInstance());
            _loc8_.allDirections = true;
            this._rangeSelection.zone = _loc8_;
         }
         else if(_loc7_)
         {
            this._rangeSelection.zone = new Cross(this._spellLevel.minRange,_loc5_,DataMapProvider.getInstance());
         }
         else if(this._spellLevel.castInDiagonal)
         {
            _loc8_ = new Cross(this._spellLevel.minRange,_loc5_,DataMapProvider.getInstance());
            _loc8_.diagonal = true;
            this._rangeSelection.zone = _loc8_;
         }
         else
         {
            this._rangeSelection.zone = new Lozenge(this._spellLevel.minRange,_loc5_,DataMapProvider.getInstance());
         }
         var _loc9_:Vector.<uint> = new Vector.<uint>();
         this._losSelection = new Selection();
         this._losSelection.renderer = this.createZoneRenderer(LOS_COLOR,PlacementStrataEnums.STRATA_AREA);
         this._losSelection.color = LOS_COLOR;
         var _loc10_:Vector.<uint> = this._rangeSelection.zone.getCells(_loc3_);
         if(!this._spellLevel.castTestLos)
         {
            this._losSelection.zone = new Custom(_loc10_);
         }
         else
         {
            this._losSelection.zone = new Custom(LosDetector.getCell(DataMapProvider.getInstance(),_loc10_,MapPoint.fromCellId(_loc3_)));
            this._rangeSelection.renderer = this.createZoneRenderer(POSSIBLE_TARGET_CELL_COLOR,PlacementStrataEnums.STRATA_AREA);
            _loc17_ = this._rangeSelection.zone.getCells(_loc3_);
            _loc18_ = this._losSelection.zone.getCells(_loc3_);
            _loc19_ = _loc17_.length;
            _loc20_ = 0;
            while(_loc20_ < _loc19_)
            {
               _loc21_ = _loc17_[_loc20_];
               if(_loc18_.indexOf(_loc21_) == -1)
               {
                  _loc9_.push(_loc21_);
               }
               _loc20_++;
            }
         }
         var _loc11_:Vector.<MapPoint> = MarkedCellsManager.getInstance().getMarksMapPoint(GameActionMarkTypeEnum.PORTAL);
         var _loc12_:Vector.<uint> = new Vector.<uint>();
         var _loc13_:Vector.<uint> = new Vector.<uint>();
         if(_loc11_ && _loc11_.length >= 2)
         {
            for each(_loc24_ in this._losSelection.zone.getCells(_loc3_))
            {
               _loc22_ = this.getTargetThroughPortal(_loc24_);
               if(_loc22_ != _loc24_)
               {
                  this._targetingThroughPortal = true;
                  if(this.isValidCell(_loc22_,true))
                  {
                     if(this._spellLevel.castTestLos)
                     {
                        _loc25_ = MarkedCellsManager.getInstance().getMarkAtCellId(_loc24_,GameActionMarkTypeEnum.PORTAL);
                        _loc26_ = MarkedCellsManager.getInstance().getMarksMapPoint(GameActionMarkTypeEnum.PORTAL,_loc25_.teamId);
                        _loc27_ = LinkedCellsManager.getInstance().getLinks(MapPoint.fromCellId(_loc24_),_loc26_);
                        _loc23_ = _loc27_.pop();
                        _loc28_ = MapPoint.fromCellId(_loc23_);
                        _loc29_ = MapPoint.fromCellId(_loc22_);
                        _loc30_ = Dofus2Line.getLine(_loc28_.cellId,_loc29_.cellId);
                        for each(_loc32_ in _loc30_)
                        {
                           _loc31_ = MapPoint.fromCoords(_loc32_.x,_loc32_.y);
                           _loc13_.push(_loc31_.cellId);
                        }
                        _loc33_ = LosDetector.getCell(DataMapProvider.getInstance(),_loc13_,_loc28_);
                        if(_loc33_.indexOf(_loc22_) > -1)
                        {
                           _loc12_.push(_loc24_);
                        }
                        else
                        {
                           _loc9_.push(_loc24_);
                        }
                     }
                     else
                     {
                        _loc12_.push(_loc24_);
                     }
                  }
                  else
                  {
                     _loc9_.push(_loc24_);
                  }
                  this._targetingThroughPortal = false;
               }
            }
         }
         var _loc14_:Vector.<uint> = new Vector.<uint>();
         var _loc15_:Vector.<uint> = this._losSelection.zone.getCells(_loc3_);
         for each(_loc16_ in _loc15_)
         {
            if(_loc12_.indexOf(_loc16_) != -1)
            {
               _loc14_.push(_loc16_);
            }
            else if(this._usedWrapper is SpellWrapper && this._usedWrapper.spellLevelInfos && (this._usedWrapper.spellLevelInfos.needFreeCell && this.cellHasEntity(_loc16_) || this._usedWrapper.spellLevelInfos.needFreeTrapCell && MarkedCellsManager.getInstance().cellHasTrap(_loc16_)))
            {
               _loc9_.push(_loc16_);
            }
            else if(_loc9_.indexOf(_loc16_) == -1)
            {
               _loc14_.push(_loc16_);
            }
         }
         this._losSelection.zone = new Custom(_loc14_);
         SelectionManager.getInstance().addSelection(this._losSelection,SELECTION_LOS,_loc3_);
         if(_loc9_.length > 0)
         {
            this._rangeSelection.zone = new Custom(_loc9_);
            SelectionManager.getInstance().addSelection(this._rangeSelection,SELECTION_RANGE,_loc3_);
         }
         else
         {
            this._rangeSelection.zone = new Custom(new Vector.<uint>());
            SelectionManager.getInstance().addSelection(this._rangeSelection,SELECTION_RANGE,_loc3_);
         }
         if(_loc12_.length > 0)
         {
            this._portalsSelection = new Selection();
            this._portalsSelection.renderer = this.createZoneRenderer(PORTAL_COLOR,PlacementStrataEnums.STRATA_AREA);
            this._portalsSelection.color = PORTAL_COLOR;
            this._portalsSelection.alpha = true;
            this._portalsSelection.zone = new Custom(_loc12_);
            SelectionManager.getInstance().addSelection(this._portalsSelection,SELECTION_PORTALS,_loc3_);
         }
      }
      
      private function showTeleportationPreview() : void
      {
         var _loc2_:Vector.<EffectInstance> = null;
         var _loc3_:EffectInstance = null;
         var _loc4_:Vector.<Number> = null;
         var _loc5_:Number = NaN;
         var _loc6_:GameFightFighterInformations = null;
         var _loc7_:AnimatedCharacter = null;
         var _loc8_:Number = NaN;
         var _loc9_:int = 0;
         var _loc10_:Vector.<FightTeleportation> = null;
         var _loc11_:FightTeleportation = null;
         var _loc12_:SpellWrapper = null;
         var _loc13_:Array = null;
         var _loc14_:BasicBuff = null;
         var _loc15_:MapPoint = null;
         var _loc16_:MarkInstance = null;
         var _loc17_:Vector.<MapPoint> = null;
         var _loc18_:Vector.<uint> = null;
         var _loc1_:SpellWrapper = this._usedWrapper as SpellWrapper;
         if(_loc1_ && (!_loc1_.spellLevelInfos.needTakenCell || this._currentCellEntity))
         {
            _loc2_ = _loc1_.effects;
            _loc4_ = this._fightContextFrame.entitiesFrame.getEntitiesIdsList();
            _loc8_ = CurrentPlayedFighterManager.getInstance().currentFighterId;
            _loc9_ = this._fightContextFrame.entitiesFrame.getEntityInfos(_loc8_).disposition.cellId;
            _loc10_ = new Vector.<FightTeleportation>(0);
            _loc11_ = TeleportationUtil.getFightTeleportation(_loc4_,_loc2_,_loc8_,_loc9_,this._currentCell);
            if(_loc11_)
            {
               _loc10_.push(_loc11_);
            }
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.effectId == 1160)
               {
                  _loc12_ = SpellWrapper.create(_loc3_.parameter0 as uint,_loc1_.spellLevel);
                  if(TeleportationUtil.hasTeleportation(_loc12_))
                  {
                     for each(_loc5_ in _loc4_)
                     {
                        _loc6_ = this._fightContextFrame.entitiesFrame.getEntityInfos(_loc5_) as GameFightFighterInformations;
                        _loc7_ = DofusEntities.getEntity(_loc5_) as AnimatedCharacter;
                        if(_loc6_ && _loc6_.alive && _loc7_ && _loc7_.displayed && DamageUtil.verifySpellEffectMask(_loc8_,_loc5_,_loc3_,this._currentCell) && DamageUtil.verifySpellEffectZone(_loc5_,_loc3_,this._currentCell,_loc9_))
                        {
                           _loc11_ = TeleportationUtil.getFightTeleportation(_loc4_,_loc12_.effects,_loc8_,_loc9_,_loc6_.disposition.cellId);
                           if(_loc11_)
                           {
                              _loc10_.push(_loc11_);
                           }
                        }
                     }
                  }
               }
            }
            for each(_loc3_ in _loc2_)
            {
               for each(_loc5_ in _loc4_)
               {
                  _loc6_ = this._fightContextFrame.entitiesFrame.getEntityInfos(_loc5_) as GameFightFighterInformations;
                  _loc7_ = DofusEntities.getEntity(_loc5_) as AnimatedCharacter;
                  if(_loc6_ && _loc6_.alive && _loc7_ && _loc7_.displayed && DamageUtil.verifySpellEffectMask(_loc8_,_loc5_,_loc3_,this._currentCell) && DamageUtil.verifySpellEffectZone(_loc5_,_loc3_,this._currentCell,_loc9_))
                  {
                     _loc13_ = BuffManager.getInstance().getAllBuff(_loc5_);
                     for each(_loc14_ in _loc13_)
                     {
                        if((_loc14_.actionId == ActionIdConverter.ACTION_TARGET_CASTS_SPELL || _loc14_.actionId == ActionIdConverter.ACTION_TARGET_CASTS_SPELL_WITH_ANIM) && DamageUtil.verifyEffectTrigger(_loc8_,_loc5_,_loc2_,_loc3_,false,_loc14_.effect.triggers,this._currentCell))
                        {
                           _loc12_ = SpellWrapper.create(_loc14_.effect.parameter0 as uint,_loc14_.effect.parameter1 as int);
                           if(TeleportationUtil.hasTeleportation(_loc12_))
                           {
                              _loc11_ = TeleportationUtil.getFightTeleportation(_loc4_,_loc12_.effects,_loc5_,_loc6_.disposition.cellId,this._currentCell,_loc8_);
                              if(_loc11_)
                              {
                                 _loc10_.push(_loc11_);
                              }
                           }
                        }
                     }
                  }
               }
            }
            this.removeTeleportationPreview();
            if(_loc10_.length > 0)
            {
               if(this._targetingThroughPortal)
               {
                  _loc16_ = MarkedCellsManager.getInstance().getMarkAtCellId(FightContextFrame.currentCell,GameActionMarkTypeEnum.PORTAL);
                  _loc17_ = MarkedCellsManager.getInstance().getMarksMapPoint(GameActionMarkTypeEnum.PORTAL,_loc16_.teamId);
                  _loc18_ = LinkedCellsManager.getInstance().getLinks(MapPoint.fromCellId(_loc16_.markImpactCellId),_loc17_);
                  _loc15_ = MapPoint.fromCellId(_loc18_.pop());
               }
               this._fightTeleportationPreview = new FightTeleportationPreview(this._usedWrapper,_loc10_,_loc15_);
               this._fightTeleportationPreview.show();
            }
         }
      }
      
      private function removeTeleportationPreview() : void
      {
         if(this._fightTeleportationPreview)
         {
            this._fightTeleportationPreview.remove();
            this._fightTeleportationPreview = null;
         }
      }
      
      private function getParentEntity(param1:TiphonSprite) : TiphonSprite
      {
         var _loc2_:TiphonSprite = null;
         var _loc3_:TiphonSprite = param1.parentSprite;
         while(_loc3_)
         {
            _loc2_ = _loc3_;
            _loc3_ = _loc3_.parentSprite;
         }
         return !_loc2_?param1:_loc2_;
      }
      
      private function showTargetsTooltips(param1:Selection) : void
      {
         var _loc3_:Number = NaN;
         var _loc6_:GameFightFighterInformations = null;
         var _loc8_:int = 0;
         var _loc2_:Vector.<Number> = this._fightContextFrame.entitiesFrame.getEntitiesIdsList();
         var _loc4_:Vector.<uint> = param1.zone.getCells(this._currentCell);
         var _loc5_:Vector.<Number> = new Vector.<Number>(0);
         for each(_loc3_ in _loc2_)
         {
            _loc6_ = this._fightContextFrame.entitiesFrame.getEntityInfos(_loc3_) as GameFightFighterInformations;
            if(_loc4_.indexOf(_loc6_.disposition.cellId) != -1 && DofusEntities.getEntity(_loc3_))
            {
               _loc5_.push(_loc3_);
               TooltipPlacer.waitBeforeOrder("tooltip_tooltipOverEntity_" + _loc3_);
            }
            else if(!this._fightContextFrame.showPermanentTooltips || this._fightContextFrame.showPermanentTooltips && this._fightContextFrame.battleFrame.targetedEntities.indexOf(_loc3_) == -1)
            {
               TooltipManager.hide("tooltipOverEntity_" + _loc3_);
            }
         }
         if(_loc5_.length > 0 && _loc5_.indexOf(CurrentPlayedFighterManager.getInstance().currentFighterId) == -1 && this._usedWrapper is SpellWrapper && (this._usedWrapper as SpellWrapper).canTargetCasterOutOfZone)
         {
            _loc5_.push(CurrentPlayedFighterManager.getInstance().currentFighterId);
         }
         this._fightContextFrame.removeSpellTargetsTooltips();
         var _loc7_:int = _loc5_.indexOf(CurrentPlayedFighterManager.getInstance().currentFighterId);
         if(_loc7_ != -1)
         {
            _loc5_.splice(_loc7_,1);
            _loc5_.push(CurrentPlayedFighterManager.getInstance().currentFighterId);
         }
         var _loc9_:uint = _loc5_.length;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc6_ = this._fightContextFrame.entitiesFrame.getEntityInfos(_loc5_[_loc8_]) as GameFightFighterInformations;
            if(_loc6_.alive)
            {
               this._fightContextFrame.displayEntityTooltip(_loc5_[_loc8_],this._spellLevel,null,false,this._currentCell);
            }
            _loc8_++;
         }
      }
      
      private function hideTargetsTooltips() : void
      {
         var _loc2_:Number = NaN;
         var _loc4_:AnimatedCharacter = null;
         var _loc1_:Vector.<Number> = this._fightContextFrame.entitiesFrame.getEntitiesIdsList();
         var _loc3_:IEntity = EntitiesManager.getInstance().getEntityOnCell(FightContextFrame.currentCell,AnimatedCharacter);
         if(_loc3_)
         {
            _loc4_ = _loc3_ as AnimatedCharacter;
            if(_loc4_ && _loc4_.parentSprite && _loc4_.parentSprite.carriedEntity == _loc4_)
            {
               _loc3_ = _loc4_.parentSprite as AnimatedCharacter;
            }
         }
         for each(_loc2_ in _loc1_)
         {
            if(!this._fightContextFrame.showPermanentTooltips || this._fightContextFrame.showPermanentTooltips && this._fightContextFrame.battleFrame.targetedEntities.indexOf(_loc2_) == -1)
            {
               TooltipManager.hide("tooltipOverEntity_" + _loc2_);
            }
         }
         if(this._fightContextFrame.showPermanentTooltips && this._fightContextFrame.battleFrame.targetedEntities.length > 0)
         {
            for each(_loc2_ in this._fightContextFrame.battleFrame.targetedEntities)
            {
               if(!_loc3_ || _loc2_ != _loc3_.id)
               {
                  this._fightContextFrame.displayEntityTooltip(_loc2_);
               }
            }
         }
         if(_loc3_)
         {
            this._fightContextFrame.displayEntityTooltip(_loc3_.id);
         }
      }
      
      private function clearTarget() : void
      {
         if(!this._clearTargetTimer.running)
         {
            this._clearTargetTimer.start();
         }
      }
      
      private function onClearTarget(param1:TimerEvent) : void
      {
         this.refreshTarget();
      }
      
      private function getTargetThroughPortal(param1:int, param2:Boolean = false) : int
      {
         var _loc3_:MapPoint = null;
         var _loc8_:MarkInstance = null;
         var _loc9_:MapPoint = null;
         var _loc15_:EffectInstance = null;
         var _loc16_:MapPoint = null;
         var _loc17_:Vector.<uint> = null;
         var _loc18_:Vector.<uint> = null;
         if(this._spellLevel && this._spellLevel.effects)
         {
            for each(_loc15_ in this._spellLevel.effects)
            {
               if(_loc15_.effectId == ActionIdConverter.ACTION_FIGHT_DISABLE_PORTAL)
               {
                  return param1;
               }
            }
         }
         var _loc4_:Number = CurrentPlayedFighterManager.getInstance().currentFighterId;
         var _loc5_:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc4_) as GameFightFighterInformations;
         if(!_loc5_)
         {
            return param1;
         }
         var _loc6_:MarkedCellsManager = MarkedCellsManager.getInstance();
         var _loc7_:Vector.<MapPoint> = _loc6_.getMarksMapPoint(GameActionMarkTypeEnum.PORTAL);
         if(!_loc7_ || _loc7_.length < 2)
         {
            return param1;
         }
         for each(_loc9_ in _loc7_)
         {
            _loc8_ = _loc6_.getMarkAtCellId(_loc9_.cellId,GameActionMarkTypeEnum.PORTAL);
            if(_loc8_ && _loc8_.active)
            {
               if(_loc9_.cellId == param1)
               {
                  _loc3_ = _loc9_;
                  break;
               }
            }
         }
         if(!_loc3_)
         {
            return param1;
         }
         _loc7_ = _loc6_.getMarksMapPoint(GameActionMarkTypeEnum.PORTAL,_loc8_.teamId);
         var _loc10_:Vector.<uint> = LinkedCellsManager.getInstance().getLinks(_loc3_,_loc7_);
         var _loc11_:MapPoint = MapPoint.fromCellId(_loc10_.pop());
         var _loc12_:MapPoint = MapPoint.fromCellId(_loc5_.disposition.cellId);
         if(!_loc12_)
         {
            return param1;
         }
         var _loc13_:int = _loc3_.x - _loc12_.x + _loc11_.x;
         var _loc14_:int = _loc3_.y - _loc12_.y + _loc11_.y;
         if(!MapPoint.isInMap(_loc13_,_loc14_))
         {
            return AtouinConstants.MAP_CELLS_COUNT + 1;
         }
         _loc16_ = MapPoint.fromCoords(_loc13_,_loc14_);
         if(param2)
         {
            _loc17_ = new Vector.<uint>();
            _loc17_.push(_loc12_.cellId);
            _loc17_.push(_loc3_.cellId);
            LinkedCellsManager.getInstance().drawLinks("spellEntryLink",_loc17_,10,TARGET_COLOR.color,1);
            if(_loc16_.cellId < AtouinConstants.MAP_CELLS_COUNT)
            {
               _loc18_ = new Vector.<uint>();
               _loc18_.push(_loc11_.cellId);
               _loc18_.push(_loc16_.cellId);
               LinkedCellsManager.getInstance().drawLinks("spellExitLink",_loc18_,6,TARGET_COLOR.color,1);
            }
         }
         return _loc16_.cellId;
      }
      
      private function castSpell(param1:uint, param2:Number = 0) : void
      {
         var _loc4_:String = null;
         var _loc5_:IEntity = null;
         var _loc6_:* = null;
         var _loc7_:GameFightFighterInformations = null;
         var _loc8_:* = null;
         var _loc9_:ChatClientMultiMessage = null;
         var _loc10_:IEntity = null;
         var _loc11_:GameActionFightCastOnTargetRequestMessage = null;
         var _loc12_:GameActionFightCastRequestMessage = null;
         var _loc3_:FightTurnFrame = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
         if(!_loc3_)
         {
            return;
         }
         if(CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent < this._spellLevel.apCost)
         {
            return;
         }
         if(KeyPoll.getInstance().isDown(Keyboard.ALTERNATE))
         {
            if(param1 == 0 && param2 != 0)
            {
               _loc5_ = DofusEntities.getEntity(param2);
               if(_loc5_ && _loc5_.position)
               {
                  param1 = _loc5_.position.cellId;
               }
            }
            if(param2 == 0 && param1 > 0)
            {
               _loc10_ = EntitiesManager.getInstance().getEntityOnCell(param1,AnimatedCharacter);
               if(_loc10_)
               {
                  param2 = _loc10_.id;
               }
            }
            if(param2 != 0 && !_loc5_)
            {
               _loc7_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(param2) as GameFightFighterInformations;
            }
            if(_loc7_ && _loc7_.disposition.cellId)
            {
               _loc6_ = "{entity," + param2 + "," + 1 + "}";
            }
            else
            {
               _loc6_ = I18n.getUiText("ui.fightAutomsg.cellTarget",["{cell," + param1 + "::" + param1 + "}"]);
            }
            if(this._spellId == 0)
            {
               _loc8_ = this._spellLevel.name;
            }
            else
            {
               _loc8_ = "{spell," + this._spellId + "," + this._spellLevel.spellLevel + "}";
            }
            if(SelectionManager.getInstance().isInside(param1,SELECTION_RANGE))
            {
               _loc4_ = I18n.getUiText("ui.fightAutomsg.targetcast.noLineOfSight",[_loc8_,_loc6_]);
            }
            else if(!SelectionManager.getInstance().isInside(param1,SELECTION_LOS))
            {
               _loc4_ = I18n.getUiText("ui.fightAutomsg.targetcast.outsideRange",[_loc8_,_loc6_]);
            }
            else
            {
               _loc4_ = I18n.getUiText("ui.fightAutomsg.targetcast.available",[_loc8_,_loc6_]);
            }
            _loc9_ = new ChatClientMultiMessage();
            _loc9_.initChatClientMultiMessage(_loc4_,ChatActivableChannelsEnum.CHANNEL_TEAM);
            ConnectionsHandler.getConnection().send(_loc9_);
            return;
         }
         if(!_loc3_.myTurn)
         {
            return;
         }
         if(param2 != 0 && !FightEntitiesFrame.getCurrentInstance().entityIsIllusion(param2))
         {
            CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent - this._spellLevel.apCost;
            _loc11_ = new GameActionFightCastOnTargetRequestMessage();
            _loc11_.initGameActionFightCastOnTargetRequestMessage(this._spellId,param2);
            ConnectionsHandler.getConnection().send(_loc11_);
         }
         else if(this.isValidCell(param1))
         {
            if(this._invocationPreview.length > 0)
            {
               this.removeInvocationPreview();
            }
            CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations().actionPointsCurrent - this._spellLevel.apCost;
            _loc12_ = new GameActionFightCastRequestMessage();
            _loc12_.initGameActionFightCastRequestMessage(this._spellId,param1);
            ConnectionsHandler.getConnection().send(_loc12_);
         }
         this.cancelCast();
      }
      
      private function cancelCast(... rest) : void
      {
         this.removeInvocationPreview();
         this._cancelTimer.reset();
         Kernel.getWorker().removeFrame(this);
      }
      
      private function removeRange() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(SELECTION_RANGE);
         if(_loc1_)
         {
            _loc1_.remove();
            this._rangeSelection = null;
         }
         var _loc2_:Selection = SelectionManager.getInstance().getSelection(SELECTION_LOS);
         if(_loc2_)
         {
            _loc2_.remove();
            this._losSelection = null;
         }
         var _loc3_:Selection = SelectionManager.getInstance().getSelection(SELECTION_PORTALS);
         if(_loc3_)
         {
            _loc3_.remove();
            this._portalsSelection = null;
         }
         this._isInfiniteTarget = false;
      }
      
      private function removeTarget() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(SELECTION_TARGET);
         if(_loc1_)
         {
            _loc1_.remove();
            this._rangeSelection = null;
         }
         _loc1_ = SelectionManager.getInstance().getSelection(SELECTION_CENTER_TARGET);
         if(_loc1_)
         {
            _loc1_.remove();
         }
      }
      
      private function cellHasEntity(param1:uint) : Boolean
      {
         var _loc4_:IEntity = null;
         var _loc5_:IEntity = null;
         var _loc6_:Boolean = false;
         var _loc2_:Array = EntitiesManager.getInstance().getEntitiesOnCell(param1,AnimatedCharacter);
         var _loc3_:int = !!_loc2_?int(_loc2_.length):0;
         if(_loc3_ && this._invocationPreview.length > 0)
         {
            while(true)
            {
               for each(_loc4_ in _loc2_)
               {
                  _loc6_ = false;
                  for each(_loc5_ in this._invocationPreview)
                  {
                     if(_loc4_.id == _loc5_.id)
                     {
                        _loc3_--;
                        _loc6_ = true;
                        break;
                     }
                  }
                  if(_loc6_)
                  {
                     continue;
                  }
                  break;
               }
            }
            return true;
         }
         return _loc3_ > 0;
      }
      
      private function isValidCell(param1:uint, param2:Boolean = false) : Boolean
      {
         var _loc4_:SpellLevel = null;
         var _loc5_:Array = null;
         var _loc6_:IEntity = null;
         var _loc7_:* = false;
         var _loc8_:Boolean = false;
         var _loc9_:IEntity = null;
         var _loc10_:Boolean = false;
         var _loc3_:CellData = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[param1];
         if(!_loc3_ || _loc3_.farmCell)
         {
            return false;
         }
         if(this._isInfiniteTarget)
         {
            return true;
         }
         if(this._spellId)
         {
            _loc4_ = this._spellLevel.spellLevelInfos;
            _loc5_ = EntitiesManager.getInstance().getEntitiesOnCell(param1);
            for each(_loc6_ in _loc5_)
            {
               if(this._invocationPreview.length > 0)
               {
                  _loc8_ = false;
                  for each(_loc9_ in this._invocationPreview)
                  {
                     if(_loc6_.id == _loc9_.id)
                     {
                        _loc8_ = true;
                        break;
                     }
                  }
                  if(_loc8_)
                  {
                     continue;
                  }
               }
               if(!CurrentPlayedFighterManager.getInstance().canCastThisSpell(this._spellLevel.spellId,this._spellLevel.spellLevel,_loc6_.id))
               {
                  return false;
               }
               _loc7_ = _loc6_ is Glyph;
               if(_loc4_.needFreeTrapCell && _loc7_ && (_loc6_ as Glyph).glyphType == GameActionMarkTypeEnum.TRAP)
               {
                  return false;
               }
               if(this._spellLevel.needFreeCell && !_loc7_)
               {
                  return false;
               }
            }
         }
         if(this._targetingThroughPortal && !param2)
         {
            _loc10_ = this.isValidCell(this.getTargetThroughPortal(param1),true);
            if(!_loc10_)
            {
               return false;
            }
         }
         if(this._targetingThroughPortal)
         {
            if(_loc3_.nonWalkableDuringFight)
            {
               return false;
            }
            if(_loc3_.mov)
            {
               return true;
            }
            return false;
         }
         return SelectionManager.getInstance().isInside(param1,SELECTION_LOS);
      }
      
      private function getSpellShape(param1:Object) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:EffectInstance = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         for each(_loc3_ in this._spellLevel.effects)
         {
            if(_loc3_.zoneShape != 0 && (_loc3_.zoneSize > _loc4_ || _loc3_.zoneSize == _loc4_ && (_loc3_.zoneShape == SpellShapeEnum.P || _loc3_.zoneMinSize < _loc5_)))
            {
               _loc2_ = _loc3_.zoneShape;
            }
         }
         return _loc2_;
      }
      
      private function createZoneRenderer(param1:Color, param2:uint = 90) : IFightZoneRenderer
      {
         var _loc3_:IFightZoneRenderer = null;
         switch(param1)
         {
            case TARGET_CENTER_COLOR:
               _loc3_ = new ZoneClipRenderer(param2,SWF_LIB,["cellActive"],-1,false,false);
               break;
            default:
               _loc3_ = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA,1,true);
         }
         _loc3_.showFarmCell = false;
         return _loc3_;
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         if(this._targetCenterSelection && this._targetCenterSelection.visible)
         {
            ZoneDARenderer(this._targetSelection.renderer).fixedStrata = false;
            ZoneDARenderer(this._targetSelection.renderer).currentStrata = param1.propertyValue == true?uint(PlacementStrataEnums.STRATA_NO_Z_ORDER):uint(PlacementStrataEnums.STRATA_AREA);
            ZoneClipRenderer(this._targetCenterSelection.renderer).currentStrata = param1.propertyValue == true?uint(PlacementStrataEnums.STRATA_NO_Z_ORDER):uint(PlacementStrataEnums.STRATA_AREA);
         }
      }
   }
}
