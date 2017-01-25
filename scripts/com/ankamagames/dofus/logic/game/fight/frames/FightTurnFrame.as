package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.messages.EntityMovementCompleteMessage;
   import com.ankamagames.atouin.messages.MapContainerRollOutMessage;
   import com.ankamagames.atouin.renderers.MovementZoneRenderer;
   import com.ankamagames.atouin.renderers.ZoneClipRenderer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.managers.EmbedFontManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.logic.game.common.managers.AFKFightManager;
   import com.ankamagames.dofus.logic.game.common.managers.MapMovementAdapter;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightSpellCastAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightTurnFinishAction;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.TackleUtil;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.messages.game.chat.ChatClientMultiMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapNoMovementMessage;
   import com.ankamagames.dofus.network.messages.game.context.ShowCellRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnFinishMessage;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.FontManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.pathfinding.Pathfinding;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.jerakine.types.positions.PathElement;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.jerakine.utils.display.KeyPoll;
   import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class FightTurnFrame implements Frame
   {
      
      private static var SWF_LIB:String = XmlConfig.getInstance().getEntry("config.ui.skin").concat("assets_tacticmod.swf");
      
      private static const TAKLED_CURSOR_NAME:String = "TackledCursor";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightTurnFrame));
      
      public static const SELECTION_PATH:String = "FightMovementPath";
      
      public static const SELECTION_END_PATH:String = "FightMovementEndPath";
      
      public static const SELECTION_PATH_UNREACHABLE:String = "FightMovementPathUnreachable";
      
      private static const PATH_COLOR:Color = new Color(26112);
      
      private static const PATH_UNREACHABLE_COLOR:Color = new Color(6684672);
      
      private static const REMIND_TURN_DELAY:uint = 15000;
       
      
      private var _movementSelection:Selection;
      
      private var _movementTargetSelection:Selection;
      
      private var _movementSelectionUnreachable:Selection;
      
      private var _isRequestingMovement:Boolean;
      
      private var _spellCastFrame:Frame;
      
      private var _finishingTurn:Boolean;
      
      private var _remindTurnTimeoutId:uint;
      
      private var _myTurn:Boolean;
      
      private var _turnDuration:uint;
      
      private var _remainingDurationSeconds:uint;
      
      private var _lastCell:MapPoint;
      
      private var _cursorData:LinkedCursorData = null;
      
      private var _tfAP:TextField;
      
      private var _tfMP:TextField;
      
      private var _cells:Vector.<uint>;
      
      private var _cellsUnreachable:Vector.<uint>;
      
      private var _lastPath:MovementPath;
      
      private var _intervalTurn:Number;
      
      public function FightTurnFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      public function get myTurn() : Boolean
      {
         return this._myTurn;
      }
      
      public function set myTurn(param1:Boolean) : void
      {
         var _loc2_:* = param1 != this._myTurn;
         var _loc3_:* = !this._myTurn;
         this._myTurn = param1;
         if(param1)
         {
            this.startRemindTurn();
         }
         else
         {
            this._isRequestingMovement = false;
            if(this._remindTurnTimeoutId != 0)
            {
               clearTimeout(this._remindTurnTimeoutId);
            }
            this.removePath();
         }
         var _loc4_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         if(_loc4_)
         {
            _loc4_.refreshTimelineOverEntityInfos();
         }
         var _loc5_:FightSpellCastFrame = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame;
         if(_loc5_)
         {
            if(_loc3_)
            {
               _loc5_.drawRange();
            }
            if(_loc2_)
            {
               if(_loc5_)
               {
                  _loc5_.refreshTarget(true);
               }
            }
         }
         if(this._myTurn && !_loc5_)
         {
            this.drawPath();
         }
      }
      
      public function set turnDuration(param1:uint) : void
      {
         this._turnDuration = param1;
         this._remainingDurationSeconds = Math.floor(param1 / 1000);
         if(this._intervalTurn)
         {
            clearInterval(this._intervalTurn);
         }
         this._intervalTurn = setInterval(this.onSecondTick,1000);
      }
      
      public function get lastPath() : MovementPath
      {
         return this._lastPath;
      }
      
      public function freePlayer() : void
      {
         this._isRequestingMovement = false;
      }
      
      public function pushed() : Boolean
      {
         Atouin.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:CellOverMessage = null;
         var _loc3_:GameFightSpellCastAction = null;
         var _loc4_:Number = NaN;
         var _loc5_:GameFightFighterInformations = null;
         var _loc6_:CellClickMessage = null;
         var _loc7_:EntityMovementCompleteMessage = null;
         var _loc8_:FightContextFrame = null;
         var _loc9_:Number = NaN;
         var _loc10_:FightEntitiesFrame = null;
         var _loc11_:GameFightFighterInformations = null;
         var _loc12_:IMovable = null;
         var _loc13_:ShowCellRequestMessage = null;
         var _loc14_:String = null;
         var _loc15_:ChatClientMultiMessage = null;
         var _loc16_:Frame = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         switch(true)
         {
            case param1 is CellOverMessage:
               _loc2_ = param1 as CellOverMessage;
               if(this.myTurn)
               {
                  this._lastCell = _loc2_.cell;
                  this.drawPath(this._lastCell);
               }
               return false;
            case param1 is GameFightSpellCastAction:
               _loc3_ = param1 as GameFightSpellCastAction;
               if(this._spellCastFrame != null)
               {
                  Kernel.getWorker().removeFrame(this._spellCastFrame);
               }
               this.removePath();
               if(this._myTurn)
               {
                  this.startRemindTurn();
               }
               _loc4_ = CurrentPlayedFighterManager.getInstance().currentFighterId;
               _loc5_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc4_) as GameFightFighterInformations;
               if(_loc5_ && _loc5_.alive)
               {
                  Kernel.getWorker().addFrame(this._spellCastFrame = new FightSpellCastFrame(_loc3_.spellId));
               }
               return true;
            case param1 is CellClickMessage:
               _loc6_ = param1 as CellClickMessage;
               if(KeyPoll.getInstance().isDown(Keyboard.ALTERNATE) && !Kernel.getWorker().contains(FightSpellCastFrame))
               {
                  if(Kernel.getWorker().contains(FightPointCellFrame))
                  {
                     FightPointCellFrame.getInstance().cancelShow();
                  }
                  if(DataMapProvider.getInstance().pointMov(MapPoint.fromCellId(_loc6_.cellId).x,MapPoint.fromCellId(_loc6_.cellId).y,true))
                  {
                     _loc13_ = new ShowCellRequestMessage();
                     _loc13_.initShowCellRequestMessage(_loc6_.cellId);
                     ConnectionsHandler.getConnection().send(_loc13_);
                     _loc14_ = I18n.getUiText("ui.fightAutomsg.cell",["{cell," + _loc6_.cellId + "::" + _loc6_.cellId + "}"]);
                     _loc15_ = new ChatClientMultiMessage();
                     _loc15_.initChatClientMultiMessage(_loc14_,ChatActivableChannelsEnum.CHANNEL_TEAM);
                     ConnectionsHandler.getConnection().send(_loc15_);
                  }
               }
               else
               {
                  if(!this.myTurn)
                  {
                     return false;
                  }
                  this.askMoveTo(_loc6_.cell);
               }
               return true;
            case param1 is GameMapNoMovementMessage:
               if(!this.myTurn)
               {
                  return false;
               }
               this._isRequestingMovement = false;
               this.removePath();
               return true;
            case param1 is EntityMovementCompleteMessage:
               _loc7_ = param1 as EntityMovementCompleteMessage;
               _loc8_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               if(_loc8_)
               {
                  _loc8_.refreshTimelineOverEntityInfos();
               }
               if(!this.myTurn)
               {
                  return true;
               }
               if(_loc7_.entity.id == CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  this._isRequestingMovement = false;
                  _loc16_ = Kernel.getWorker().getFrame(FightSpellCastFrame);
                  if(!_loc16_)
                  {
                     this.drawPath();
                  }
                  this.startRemindTurn();
                  if(this._finishingTurn)
                  {
                     this.finishTurn();
                  }
               }
               return true;
            case param1 is GameFightTurnFinishAction:
               if(!this.myTurn)
               {
                  return false;
               }
               _loc9_ = CurrentPlayedFighterManager.getInstance().currentFighterId;
               _loc10_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
               _loc11_ = _loc10_.getEntityInfos(_loc9_) as GameFightFighterInformations;
               if(this._remainingDurationSeconds > 0 && !_loc11_.stats.summoned)
               {
                  _loc17_ = CurrentPlayedFighterManager.getInstance().getBasicTurnDuration();
                  _loc18_ = Math.floor(this._remainingDurationSeconds / 2);
                  if(_loc17_ + _loc18_ > 60)
                  {
                     _loc18_ = 60 - _loc17_;
                  }
                  if(_loc18_ > 0 && !AFKFightManager.getInstance().isAfk)
                  {
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,PatternDecoder.combine(I18n.getUiText("ui.fight.secondsAdded",[_loc18_]),"n",_loc18_ <= 1),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
                  }
                  this._remainingDurationSeconds = 0;
                  clearInterval(this._intervalTurn);
               }
               _loc12_ = DofusEntities.getEntity(_loc9_) as IMovable;
               if(!_loc12_)
               {
                  return true;
               }
               if(_loc12_.isMoving)
               {
                  this._finishingTurn = true;
               }
               else
               {
                  this.finishTurn();
               }
               return true;
            case param1 is MapContainerRollOutMessage:
               this.removePath();
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         Atouin.getInstance().options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         if(this._remindTurnTimeoutId != 0)
         {
            clearTimeout(this._remindTurnTimeoutId);
         }
         if(this._intervalTurn)
         {
            clearInterval(this._intervalTurn);
         }
         Atouin.getInstance().cellOverEnabled = false;
         this.removePath();
         Kernel.getWorker().removeFrame(this._spellCastFrame);
         return true;
      }
      
      public function drawPath(param1:MapPoint = null) : void
      {
         var _loc3_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc10_:PathElement = null;
         var _loc16_:PathElement = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:uint = 0;
         var _loc21_:Selection = null;
         var _loc22_:Sprite = null;
         var _loc23_:TextFormat = null;
         var _loc24_:GlowFilter = null;
         var _loc25_:uint = 0;
         this._cells = new Vector.<uint>();
         this._cellsUnreachable = new Vector.<uint>();
         if(Kernel.getWorker().contains(FightSpellCastFrame))
         {
            return;
         }
         if(this._isRequestingMovement)
         {
            return;
         }
         if(!param1)
         {
            if(FightContextFrame.currentCell == -1)
            {
               return;
            }
            param1 = MapPoint.fromCellId(FightContextFrame.currentCell);
         }
         var _loc2_:IEntity = DofusEntities.getEntity(CurrentPlayedFighterManager.getInstance().currentFighterId);
         if(!_loc2_)
         {
            this.removePath();
            return;
         }
         var _loc4_:CharacterCharacteristicsInformations = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations();
         var _loc7_:int = _loc4_.movementPointsCurrent;
         var _loc8_:int = _loc4_.actionPointsCurrent;
         if(IMovable(_loc2_).isMoving || _loc2_.position.distanceToCell(param1) > _loc7_)
         {
            this.removePath();
            return;
         }
         var _loc9_:MovementPath = Pathfinding.findPath(DataMapProvider.getInstance(),_loc2_.position,param1,false,false,null,null,true);
         if(DataMapProvider.getInstance().obstaclesCells.length > 0 && (_loc9_.path.length == 0 || _loc9_.path.length > _loc7_))
         {
            _loc9_ = Pathfinding.findPath(DataMapProvider.getInstance(),_loc2_.position,param1,false,false,null,null,true,false);
            if(_loc9_.path.length > 0)
            {
               _loc20_ = _loc9_.path.length;
               _loc18_ = 0;
               while(_loc18_ < _loc20_)
               {
                  if(DataMapProvider.getInstance().obstaclesCells.indexOf(_loc9_.path[_loc18_].cellId) != -1)
                  {
                     _loc10_ = _loc9_.path[_loc18_];
                     _loc19_ = _loc18_ + 1;
                     while(_loc19_ < _loc20_)
                     {
                        this._cellsUnreachable.push(_loc9_.path[_loc19_].cellId);
                        _loc19_++;
                     }
                     this._cellsUnreachable.push(_loc9_.end.cellId);
                     _loc9_.end = _loc10_.step;
                     _loc9_.path = _loc9_.path.slice(0,_loc18_);
                     break;
                  }
                  _loc18_++;
               }
            }
         }
         if(_loc9_.path.length == 0 || _loc9_.path.length > _loc7_)
         {
            this.removePath();
            return;
         }
         this._lastPath = _loc9_;
         var _loc11_:Boolean = true;
         var _loc12_:int = 0;
         var _loc13_:PathElement = null;
         var _loc14_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         var _loc15_:GameFightFighterInformations = _loc14_.getEntityInfos(_loc2_.id) as GameFightFighterInformations;
         for each(_loc16_ in _loc9_.path)
         {
            if(_loc11_)
            {
               _loc11_ = false;
            }
            else
            {
               _loc3_ = TackleUtil.getTackle(_loc15_,_loc13_.step);
               _loc5_ = _loc5_ + int((_loc7_ - _loc12_) * (1 - _loc3_) + 0.5);
               if(_loc5_ < 0)
               {
                  _loc5_ = 0;
               }
               _loc6_ = _loc6_ + int(_loc8_ * (1 - _loc3_) + 0.5);
               if(_loc6_ < 0)
               {
                  _loc6_ = 0;
               }
               _loc7_ = _loc4_.movementPointsCurrent - _loc5_;
               _loc8_ = _loc4_.actionPointsCurrent - _loc6_;
               if(_loc12_ < _loc7_)
               {
                  this._cells.push(_loc16_.step.cellId);
                  _loc12_++;
               }
               else
               {
                  this._cellsUnreachable.push(_loc16_.step.cellId);
               }
            }
            _loc13_ = _loc16_;
         }
         _loc3_ = TackleUtil.getTackle(_loc15_,_loc13_.step);
         _loc5_ = _loc5_ + int((_loc7_ - _loc12_) * (1 - _loc3_) + 0.5);
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         _loc6_ = _loc6_ + int(_loc8_ * (1 - _loc3_) + 0.5);
         if(_loc6_ < 0)
         {
            _loc6_ = 0;
         }
         _loc7_ = _loc4_.movementPointsCurrent - _loc5_;
         _loc8_ = _loc4_.actionPointsCurrent - _loc6_;
         if(_loc12_ < _loc7_)
         {
            if(_loc10_)
            {
               _loc7_ = _loc9_.path.length;
            }
            this._cells.push(_loc9_.end.cellId);
         }
         else if(_loc10_)
         {
            this._cellsUnreachable.unshift(_loc9_.end.cellId);
            _loc7_ = _loc9_.path.length - 1;
         }
         else
         {
            this._cellsUnreachable.push(_loc9_.end.cellId);
         }
         if(this._movementSelection == null)
         {
            this._movementSelection = new Selection();
            this._movementSelection.renderer = new MovementZoneRenderer(Dofus.getInstance().options.showMovementDistance);
            this._movementSelection.color = PATH_COLOR;
            this._movementTargetSelection = new Selection();
            this._movementTargetSelection.renderer = new ZoneClipRenderer(!!Atouin.getInstance().options.transparentOverlayMode?uint(PlacementStrataEnums.STRATA_NO_Z_ORDER):uint(PlacementStrataEnums.STRATA_AREA),SWF_LIB,[],-1,false,false);
            SelectionManager.getInstance().addSelection(this._movementTargetSelection,SELECTION_END_PATH);
            SelectionManager.getInstance().addSelection(this._movementSelection,SELECTION_PATH);
         }
         if(this._cellsUnreachable.length > 0)
         {
            if(this._movementSelectionUnreachable == null)
            {
               this._movementSelectionUnreachable = new Selection();
               this._movementSelectionUnreachable.renderer = new MovementZoneRenderer(Dofus.getInstance().options.showMovementDistance,_loc7_ + 1);
               this._movementSelectionUnreachable.color = PATH_UNREACHABLE_COLOR;
               SelectionManager.getInstance().addSelection(this._movementSelectionUnreachable,SELECTION_PATH_UNREACHABLE);
            }
            else
            {
               (this._movementSelectionUnreachable.renderer as MovementZoneRenderer).startAt = _loc7_ + 1;
            }
            this._movementSelectionUnreachable.zone = new Custom(this._cellsUnreachable);
            SelectionManager.getInstance().update(SELECTION_PATH_UNREACHABLE);
         }
         else
         {
            _loc21_ = SelectionManager.getInstance().getSelection(SELECTION_PATH_UNREACHABLE);
            if(_loc21_)
            {
               _loc21_.remove();
               this._movementSelectionUnreachable = null;
            }
         }
         if(_loc5_ > 0 || _loc6_ > 0)
         {
            if(!this._cursorData)
            {
               _loc22_ = new Sprite();
               this._tfAP = new TextField();
               this._tfAP.selectable = false;
               _loc23_ = new TextFormat(FontManager.getInstance().getFontInfo("Verdana").className,16,255,true);
               this._tfAP.defaultTextFormat = _loc23_;
               this._tfAP.setTextFormat(_loc23_);
               this._tfAP.text = "-" + _loc6_ + " " + I18n.getUiText("ui.common.ap");
               if(EmbedFontManager.getInstance().isEmbed(_loc23_.font))
               {
                  this._tfAP.embedFonts = true;
               }
               this._tfAP.width = this._tfAP.textWidth + 5;
               this._tfAP.height = this._tfAP.textHeight;
               _loc22_.addChild(this._tfAP);
               this._tfMP = new TextField();
               this._tfMP.selectable = false;
               _loc23_ = new TextFormat(FontManager.getInstance().getFontInfo("Verdana").className,16,26112,true);
               this._tfMP.defaultTextFormat = _loc23_;
               this._tfMP.setTextFormat(_loc23_);
               this._tfMP.text = "-" + _loc5_ + " " + I18n.getUiText("ui.common.mp");
               if(EmbedFontManager.getInstance().isEmbed(_loc23_.font))
               {
                  this._tfMP.embedFonts = true;
               }
               this._tfMP.width = this._tfMP.textWidth + 5;
               this._tfMP.height = this._tfMP.textHeight;
               this._tfMP.y = this._tfAP.height;
               _loc22_.addChild(this._tfMP);
               _loc24_ = new GlowFilter(16777215,1,4,4,3,1);
               _loc22_.filters = [_loc24_];
               this._cursorData = new LinkedCursorData();
               this._cursorData.sprite = _loc22_;
               this._cursorData.sprite.cacheAsBitmap = true;
               this._cursorData.offset = new Point(14,14);
            }
            if(_loc6_ > 0)
            {
               this._tfAP.text = "-" + _loc6_ + " " + I18n.getUiText("ui.common.ap");
               this._tfAP.width = this._tfAP.textWidth + 5;
               this._tfAP.visible = true;
               this._tfMP.y = this._tfAP.height;
            }
            else
            {
               this._tfAP.visible = false;
               this._tfMP.y = 0;
            }
            if(_loc5_ > 0)
            {
               this._tfMP.text = "-" + _loc5_ + " " + I18n.getUiText("ui.common.mp");
               this._tfMP.width = this._tfMP.textWidth + 5;
               this._tfMP.visible = true;
            }
            else
            {
               this._tfMP.visible = false;
            }
            LinkedCursorSpriteManager.getInstance().addItem(TAKLED_CURSOR_NAME,this._cursorData,true);
         }
         else if(LinkedCursorSpriteManager.getInstance().getItem(TAKLED_CURSOR_NAME))
         {
            LinkedCursorSpriteManager.getInstance().removeItem(TAKLED_CURSOR_NAME);
         }
         var _loc17_:MapPoint = new MapPoint();
         _loc17_.cellId = this._cells.length > 1?uint(this._cells[this._cells.length - 2]):uint(_loc15_.disposition.cellId);
         this._movementSelection.zone = new Custom(this._cells);
         SelectionManager.getInstance().update(SELECTION_PATH,0,true);
         if(this._cells.length)
         {
            if(!Dofus.getInstance().options.showMovementDistance)
            {
               _loc25_ = _loc17_.orientationTo(MapPoint.fromCellId(this._cells[this._cells.length - 1]));
               if(_loc25_ % 2 == 0)
               {
                  _loc25_++;
               }
               this._movementTargetSelection.zone = new Cross(0,0,DataMapProvider.getInstance());
               ZoneClipRenderer(this._movementTargetSelection.renderer).clipName = ["pathEnd_" + _loc25_];
            }
            ZoneClipRenderer(this._movementTargetSelection.renderer).currentStrata = !!Atouin.getInstance().options.transparentOverlayMode?uint(PlacementStrataEnums.STRATA_NO_Z_ORDER):uint(PlacementStrataEnums.STRATA_AREA);
            SelectionManager.getInstance().update(SELECTION_END_PATH,this._cells[this._cells.length - 1],true);
         }
      }
      
      public function updatePath() : void
      {
         this.drawPath(this._lastCell);
      }
      
      private function removePath() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(SELECTION_PATH);
         if(_loc1_)
         {
            _loc1_.remove();
            this._movementSelection = null;
         }
         _loc1_ = SelectionManager.getInstance().getSelection(SELECTION_PATH_UNREACHABLE);
         if(_loc1_)
         {
            _loc1_.remove();
            this._movementSelectionUnreachable = null;
         }
         _loc1_ = SelectionManager.getInstance().getSelection(SELECTION_END_PATH);
         if(_loc1_)
         {
            _loc1_.remove();
            this._movementTargetSelection = null;
         }
         if(LinkedCursorSpriteManager.getInstance().getItem(TAKLED_CURSOR_NAME))
         {
            LinkedCursorSpriteManager.getInstance().removeItem(TAKLED_CURSOR_NAME);
         }
         this._lastPath = null;
         this._cells = null;
      }
      
      private function askMoveTo(param1:MapPoint) : Boolean
      {
         if(this._isRequestingMovement)
         {
            return false;
         }
         this._isRequestingMovement = true;
         var _loc2_:IEntity = DofusEntities.getEntity(CurrentPlayedFighterManager.getInstance().currentFighterId);
         if(!_loc2_)
         {
            _log.warn("The player tried to move before its character was added to the scene. Aborting.");
            return this._isRequestingMovement = false;
         }
         if(IMovable(_loc2_).isMoving)
         {
            return this._isRequestingMovement = false;
         }
         var _loc3_:CharacterCharacteristicsInformations = CurrentPlayedFighterManager.getInstance().getCharacteristicsInformations();
         if(!this._cells || this._cells.length == 0)
         {
            return this._isRequestingMovement = false;
         }
         var _loc4_:MovementPath = new MovementPath();
         this._cells.unshift(_loc2_.position.cellId);
         _loc4_.fillFromCellIds(this._cells.slice(0,this._cells.length - 1));
         _loc4_.start = _loc2_.position;
         _loc4_.end = MapPoint.fromCellId(this._cells[this._cells.length - 1]);
         _loc4_.path[_loc4_.path.length - 1].orientation = _loc4_.path[_loc4_.path.length - 1].step.orientationTo(_loc4_.end);
         var _loc5_:GameMapMovementRequestMessage = new GameMapMovementRequestMessage();
         _loc5_.initGameMapMovementRequestMessage(MapMovementAdapter.getServerMovement(_loc4_),PlayedCharacterManager.getInstance().currentMap.mapId);
         ConnectionsHandler.getConnection().send(_loc5_);
         this.removePath();
         return true;
      }
      
      private function finishTurn() : void
      {
         var _loc1_:GameFightTurnFinishMessage = new GameFightTurnFinishMessage();
         _loc1_.initGameFightTurnFinishMessage(AFKFightManager.getInstance().isAfk);
         ConnectionsHandler.getConnection().send(_loc1_);
         this._finishingTurn = false;
      }
      
      private function startRemindTurn() : void
      {
         if(!this._myTurn)
         {
            return;
         }
         if(this._turnDuration > 0 && Dofus.getInstance().options.remindTurn)
         {
            if(this._remindTurnTimeoutId != 0)
            {
               clearTimeout(this._remindTurnTimeoutId);
            }
            this._remindTurnTimeoutId = setTimeout(this.remindTurn,REMIND_TURN_DELAY);
         }
      }
      
      private function remindTurn() : void
      {
         var _loc1_:String = I18n.getUiText("ui.fight.inactivity");
         KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc1_,ChatFrame.RED_CHANNEL_ID,TimeManager.getInstance().getTimestamp());
         KernelEventsManager.getInstance().processCallback(FightHookList.RemindTurn);
         clearTimeout(this._remindTurnTimeoutId);
         this._remindTurnTimeoutId = 0;
      }
      
      public function onSecondTick() : void
      {
         if(this._remainingDurationSeconds > 0)
         {
            this._remainingDurationSeconds--;
         }
         else
         {
            clearInterval(this._intervalTurn);
         }
      }
      
      private function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.propertyName == "transparentOverlayMode")
         {
            if(this._cells && this._cells.length && SelectionManager.getInstance().getSelection(SELECTION_END_PATH).visible)
            {
               ZoneClipRenderer(this._movementTargetSelection.renderer).currentStrata = param1.propertyValue == true?uint(PlacementStrataEnums.STRATA_NO_Z_ORDER):uint(PlacementStrataEnums.STRATA_AREA);
               SelectionManager.getInstance().update(SELECTION_END_PATH,this._cells[this._cells.length - 1],true);
            }
         }
      }
   }
}
