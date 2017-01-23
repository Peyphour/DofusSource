package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.data.ContextMenuData;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.enum.UISoundEnum;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.fight.actions.GameContextKickAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightPlacementPositionRequestAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightPlacementSwapPositionsAcceptAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightPlacementSwapPositionsCancelAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightPlacementSwapPositionsRequestAction;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightReadyAction;
   import com.ankamagames.dofus.logic.game.fight.actions.RemoveEntityAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ShowTacticModeAction;
   import com.ankamagames.dofus.logic.game.fight.managers.TacticModeManager;
   import com.ankamagames.dofus.logic.game.fight.types.SwapPositionRequest;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.dofus.network.messages.game.context.GameContextDestroyMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextKickMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameEntitiesDispositionMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameEntityDispositionErrorMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightEndMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementPositionRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementPossiblePositionsMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementSwapPositionsAcceptMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementSwapPositionsCancelMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementSwapPositionsCancelledMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementSwapPositionsErrorMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementSwapPositionsMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementSwapPositionsOfferMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementSwapPositionsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightReadyMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightRemoveTeamMemberMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightUpdateTeamMessage;
   import com.ankamagames.dofus.network.messages.game.idol.IdolFightPreparationUpdateMessage;
   import com.ankamagames.dofus.network.types.game.context.IdentifiedEntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCompanionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterNamedInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.Custom;
   import flash.ui.Mouse;
   import flash.utils.getQualifiedClassName;
   
   public class FightPreparationFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightPreparationFrame));
      
      private static const PLAYER_TEAM_ALPHA:Number = 1;
      
      private static const ENEMY_TEAM_ALPHA:Number = 0.3;
      
      private static const COLOR_CHALLENGER:Color = new Color(14492160);
      
      private static const COLOR_DEFENDER:Color = new Color(8925);
      
      public static const SELECTION_CHALLENGER:String = "FightPlacementChallengerTeam";
      
      public static const SELECTION_DEFENDER:String = "FightPlacementDefenderTeam";
       
      
      private var _fightContextFrame:FightContextFrame;
      
      private var _playerTeam:uint;
      
      private var _challengerPositions:Vector.<uint>;
      
      private var _defenderPositions:Vector.<uint>;
      
      private var _swapPositionRequests:Vector.<SwapPositionRequest>;
      
      public function FightPreparationFrame(param1:FightContextFrame)
      {
         super();
         this._fightContextFrame = param1;
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      public function pushed() : Boolean
      {
         Mouse.show();
         LinkedCursorSpriteManager.getInstance().removeItem("npcMonsterCursor");
         Atouin.getInstance().cellOverEnabled = true;
         this._fightContextFrame.entitiesFrame.untargetableEntities = true;
         DataMapProvider.getInstance().isInFight = true;
         this._swapPositionRequests = new Vector.<SwapPositionRequest>(0);
         return true;
      }
      
      public function updateSwapPositionRequestsIcons() : void
      {
         var _loc1_:SwapPositionRequest = null;
         for each(_loc1_ in this._swapPositionRequests)
         {
            _loc1_.updateIcon();
         }
      }
      
      public function setSwapPositionRequestsIconsVisibility(param1:Boolean) : void
      {
         var _loc2_:SwapPositionRequest = null;
         for each(_loc2_ in this._swapPositionRequests)
         {
            _loc2_.visible = param1;
         }
      }
      
      public function removeSwapPositionRequest(param1:uint) : void
      {
         var _loc2_:SwapPositionRequest = null;
         for each(_loc2_ in this._swapPositionRequests)
         {
            if(_loc2_.requestId == param1)
            {
               this._swapPositionRequests.splice(this._swapPositionRequests.indexOf(_loc2_),1);
            }
         }
      }
      
      public function isSwapPositionRequestValid(param1:uint) : Boolean
      {
         var _loc2_:SwapPositionRequest = null;
         for each(_loc2_ in this._swapPositionRequests)
         {
            if(_loc2_.requestId == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:GameFightFighterInformations = null;
         var _loc3_:FightEntitiesFrame = null;
         var _loc4_:SwapPositionRequest = null;
         var _loc5_:GameFightLeaveMessage = null;
         var _loc6_:Vector.<SwapPositionRequest> = null;
         var _loc7_:GameFightPlacementPossiblePositionsMessage = null;
         var _loc8_:CellClickMessage = null;
         var _loc9_:AnimatedCharacter = null;
         var _loc10_:GameFightPlacementPositionRequestAction = null;
         var _loc11_:IdentifiedEntityDispositionInformations = null;
         var _loc12_:Vector.<SwapPositionRequest> = null;
         var _loc13_:GameFightPlacementSwapPositionsRequestAction = null;
         var _loc14_:GameFightPlacementSwapPositionsRequestMessage = null;
         var _loc15_:GameFightPlacementSwapPositionsOfferMessage = null;
         var _loc16_:GameFightPlacementSwapPositionsErrorMessage = null;
         var _loc17_:GameFightPlacementSwapPositionsAcceptAction = null;
         var _loc18_:GameFightPlacementSwapPositionsAcceptMessage = null;
         var _loc19_:GameFightPlacementSwapPositionsCancelAction = null;
         var _loc20_:GameFightPlacementSwapPositionsCancelMessage = null;
         var _loc21_:GameFightPlacementSwapPositionsCancelledMessage = null;
         var _loc22_:GameFightReadyAction = null;
         var _loc23_:GameFightReadyMessage = null;
         var _loc24_:EntityClickMessage = null;
         var _loc25_:IInteractive = null;
         var _loc26_:GameContextKickAction = null;
         var _loc27_:GameContextKickMessage = null;
         var _loc28_:GameFightUpdateTeamMessage = null;
         var _loc29_:Number = NaN;
         var _loc30_:Boolean = false;
         var _loc31_:GameFightRemoveTeamMemberMessage = null;
         var _loc32_:GameFightEndMessage = null;
         var _loc33_:FightContextFrame = null;
         var _loc34_:IdolFightPreparationUpdateMessage = null;
         var _loc35_:GameFightEndMessage = null;
         var _loc36_:FightContextFrame = null;
         var _loc37_:IEntity = null;
         var _loc38_:Object = null;
         var _loc39_:ContextMenuData = null;
         var _loc40_:Object = null;
         var _loc41_:Object = null;
         var _loc42_:GameFightPlacementPositionRequestMessage = null;
         var _loc43_:GameFightPlacementPositionRequestMessage = null;
         var _loc44_:GameFightFighterInformations = null;
         var _loc45_:String = null;
         var _loc46_:GameFightFighterInformations = null;
         var _loc47_:String = null;
         var _loc48_:FightTeamMemberInformations = null;
         switch(true)
         {
            case param1 is GameFightLeaveMessage:
               _loc5_ = param1 as GameFightLeaveMessage;
               if(_loc5_.charId == PlayedCharacterManager.getInstance().id)
               {
                  Kernel.getWorker().removeFrame(this);
                  KernelEventsManager.getInstance().processCallback(HookList.GameFightLeave,_loc5_.charId);
                  _loc35_ = new GameFightEndMessage();
                  _loc35_.initGameFightEndMessage();
                  _loc36_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
                  if(_loc36_)
                  {
                     _loc36_.process(_loc35_);
                  }
                  else
                  {
                     Kernel.getWorker().process(_loc35_);
                  }
                  return true;
               }
               _loc6_ = this.getPlayerSwapPositionRequests(_loc5_.charId);
               for each(_loc4_ in _loc6_)
               {
                  _loc4_.destroy();
               }
               return false;
            case param1 is GameFightPlacementPossiblePositionsMessage:
               _loc7_ = param1 as GameFightPlacementPossiblePositionsMessage;
               this.displayZone(SELECTION_CHALLENGER,this._challengerPositions = _loc7_.positionsForChallengers,COLOR_CHALLENGER,_loc7_.teamNumber == TeamEnum.TEAM_CHALLENGER?Number(PLAYER_TEAM_ALPHA):Number(ENEMY_TEAM_ALPHA));
               this.displayZone(SELECTION_DEFENDER,this._defenderPositions = _loc7_.positionsForDefenders,COLOR_DEFENDER,_loc7_.teamNumber == TeamEnum.TEAM_DEFENDER?Number(PLAYER_TEAM_ALPHA):Number(ENEMY_TEAM_ALPHA));
               this._playerTeam = _loc7_.teamNumber;
               return true;
            case param1 is CellClickMessage:
               _loc8_ = param1 as CellClickMessage;
               for each(_loc37_ in EntitiesManager.getInstance().getEntitiesOnCell(_loc8_.cellId))
               {
                  if(_loc37_ is AnimatedCharacter && !(_loc37_ as AnimatedCharacter).isMoving)
                  {
                     _loc9_ = _loc37_ as AnimatedCharacter;
                     break;
                  }
               }
               if(_loc9_)
               {
                  _loc38_ = UiModuleManager.getInstance().getModule("Ankama_ContextMenu").mainClass;
                  _loc40_ = new Object();
                  _loc40_.name = this._fightContextFrame.getFighterName(_loc9_.id);
                  _loc3_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
                  _loc41_ = _loc3_.getEntityInfos(_loc9_.id);
                  _loc2_ = _loc3_.getEntityInfos(PlayedCharacterManager.getInstance().id) as GameFightFighterInformations;
                  if(_loc41_ is GameFightCharacterInformations)
                  {
                     _loc39_ = MenusFactory.create(_loc41_ as GameFightCharacterInformations,"player",[_loc9_]);
                  }
                  else if(_loc41_ is GameFightCompanionInformations)
                  {
                     _loc39_ = MenusFactory.create(_loc41_ as GameFightCompanionInformations,"companion",[_loc9_]);
                  }
                  else if(_loc41_.contextualId != _loc2_.contextualId && _loc41_.teamId == _loc2_.teamId)
                  {
                     _loc39_ = MenusFactory.create(_loc41_,"fightAlly",[_loc9_]);
                  }
                  else
                  {
                     return true;
                  }
                  if(_loc39_)
                  {
                     _loc38_.createContextMenu(_loc39_);
                  }
               }
               else if(this.isValidPlacementCell(_loc8_.cellId,this._playerTeam) && !this._fightContextFrame.onlyTheOtherTeamCanPlace)
               {
                  _loc42_ = new GameFightPlacementPositionRequestMessage();
                  _loc42_.initGameFightPlacementPositionRequestMessage(_loc8_.cellId);
                  ConnectionsHandler.getConnection().send(_loc42_);
               }
               return true;
            case param1 is GameFightPlacementPositionRequestAction:
               _loc10_ = param1 as GameFightPlacementPositionRequestAction;
               if(!this._fightContextFrame.onlyTheOtherTeamCanPlace)
               {
                  _loc43_ = new GameFightPlacementPositionRequestMessage();
                  _loc43_.initGameFightPlacementPositionRequestMessage(_loc10_.cellId);
                  ConnectionsHandler.getConnection().send(_loc43_);
               }
               return true;
            case param1 is GameEntitiesDispositionMessage:
            case param1 is GameFightPlacementSwapPositionsMessage:
               SoundManager.getInstance().manager.playUISound(UISoundEnum.FIGHT_POSITION);
               for each(_loc11_ in param1["dispositions"])
               {
                  _loc12_ = this.getPlayerSwapPositionRequests(_loc11_.id);
                  for each(_loc4_ in _loc12_)
                  {
                     _loc4_.destroy();
                  }
               }
               return false;
            case param1 is GameFightPlacementSwapPositionsRequestAction:
               _loc13_ = param1 as GameFightPlacementSwapPositionsRequestAction;
               _loc14_ = new GameFightPlacementSwapPositionsRequestMessage();
               _loc14_.initGameFightPlacementSwapPositionsRequestMessage(_loc13_.cellId,_loc13_.requestedId);
               ConnectionsHandler.getConnection().send(_loc14_);
               return true;
            case param1 is GameFightPlacementSwapPositionsOfferMessage:
               _loc15_ = param1 as GameFightPlacementSwapPositionsOfferMessage;
               _loc3_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
               _loc4_ = new SwapPositionRequest(_loc15_.requestId,_loc15_.requesterId,_loc15_.requestedId);
               if(_loc4_.requestedId == PlayedCharacterManager.getInstance().id)
               {
                  _loc44_ = _loc3_.getEntityInfos(_loc15_.requesterId) as GameFightFighterInformations;
                  _loc4_.showRequesterIcon();
                  _loc45_ = I18n.getUiText("ui.fight.swapPositionRequest",[(_loc44_ as GameFightFighterNamedInformations).name]);
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,"{swapPositionRequest," + _loc15_.requestId + ",true::" + _loc45_ + "}",ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp(),false);
                  this._swapPositionRequests.push(_loc4_);
               }
               else if(_loc4_.requesterId == PlayedCharacterManager.getInstance().id)
               {
                  _loc4_.showRequestedIcon();
                  this._swapPositionRequests.push(_loc4_);
               }
               return true;
            case param1 is GameFightPlacementSwapPositionsErrorMessage:
               _loc16_ = param1 as GameFightPlacementSwapPositionsErrorMessage;
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.fight.swapPositionRequestError"),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp(),false);
               return true;
            case param1 is GameFightPlacementSwapPositionsAcceptAction:
               _loc17_ = param1 as GameFightPlacementSwapPositionsAcceptAction;
               _loc18_ = new GameFightPlacementSwapPositionsAcceptMessage();
               _loc18_.initGameFightPlacementSwapPositionsAcceptMessage(_loc17_.requestId);
               ConnectionsHandler.getConnection().send(_loc18_);
               return true;
            case param1 is GameFightPlacementSwapPositionsCancelAction:
               _loc19_ = param1 as GameFightPlacementSwapPositionsCancelAction;
               _loc20_ = new GameFightPlacementSwapPositionsCancelMessage();
               _loc20_.initGameFightPlacementSwapPositionsCancelMessage(_loc19_.requestId);
               ConnectionsHandler.getConnection().send(_loc20_);
               return true;
            case param1 is GameFightPlacementSwapPositionsCancelledMessage:
               _loc21_ = param1 as GameFightPlacementSwapPositionsCancelledMessage;
               _loc4_ = this.getSwapPositionRequest(_loc21_.requestId);
               if(_loc4_)
               {
                  _loc4_.destroy();
                  if(_loc4_.requesterId == PlayedCharacterManager.getInstance().id && _loc21_.cancellerId != PlayedCharacterManager.getInstance().id)
                  {
                     _loc3_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
                     _loc46_ = _loc3_.getEntityInfos(_loc21_.cancellerId) as GameFightFighterInformations;
                     _loc47_ = (_loc46_ as GameFightFighterNamedInformations).name;
                     KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getUiText("ui.fight.swapPositionRequestRefused",["{player," + _loc47_ + "," + _loc46_.contextualId + "::" + _loc47_ + "}"]),ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp(),false);
                  }
               }
               return true;
            case param1 is GameEntityDispositionErrorMessage:
               _log.error("Cette position n\'est pas accessible.");
               return true;
            case param1 is GameFightReadyAction:
               _loc22_ = param1 as GameFightReadyAction;
               _loc23_ = new GameFightReadyMessage();
               _loc23_.initGameFightReadyMessage(_loc22_.isReady);
               ConnectionsHandler.getConnection().send(_loc23_);
               return true;
            case param1 is EntityClickMessage:
               _loc24_ = param1 as EntityClickMessage;
               _loc25_ = _loc24_.entity as IInteractive;
               if(_loc25_)
               {
                  _loc38_ = UiModuleManager.getInstance().getModule("Ankama_ContextMenu").mainClass;
                  _loc40_ = new Object();
                  _loc40_.name = this._fightContextFrame.getFighterName(_loc25_.id);
                  _loc3_ = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
                  _loc41_ = _loc3_.getEntityInfos(_loc25_.id);
                  _loc2_ = _loc3_.getEntityInfos(PlayedCharacterManager.getInstance().id) as GameFightFighterInformations;
                  if(_loc41_ is GameFightCharacterInformations)
                  {
                     _loc39_ = MenusFactory.create(_loc40_,"player",[_loc25_]);
                  }
                  else if(_loc41_ is GameFightCompanionInformations)
                  {
                     _loc39_ = MenusFactory.create(_loc40_,"companion",[_loc25_]);
                  }
                  else if(_loc41_.contextualId != _loc2_.contextualId && _loc41_.teamId == _loc2_.teamId)
                  {
                     _loc39_ = MenusFactory.create(_loc41_,"fightAlly",[_loc25_]);
                  }
                  else
                  {
                     return true;
                  }
                  if(_loc39_)
                  {
                     _loc38_.createContextMenu(_loc39_);
                  }
               }
               return true;
            case param1 is GameContextKickAction:
               _loc26_ = param1 as GameContextKickAction;
               _loc27_ = new GameContextKickMessage();
               _loc27_.initGameContextKickMessage(_loc26_.targetId);
               ConnectionsHandler.getConnection().send(_loc27_);
               return true;
            case param1 is GameFightUpdateTeamMessage:
               _loc28_ = param1 as GameFightUpdateTeamMessage;
               _loc29_ = PlayedCharacterManager.getInstance().id;
               _loc30_ = false;
               for each(_loc48_ in _loc28_.team.teamMembers)
               {
                  if(_loc48_.id == _loc29_)
                  {
                     _loc30_ = true;
                  }
               }
               if(_loc30_ || _loc28_.team.teamMembers.length >= 1 && _loc28_.team.teamMembers[0].id == _loc29_)
               {
                  PlayedCharacterManager.getInstance().teamId = _loc28_.team.teamId;
                  this._fightContextFrame.isFightLeader = _loc28_.team.leaderId == _loc29_;
               }
               return true;
            case param1 is GameFightRemoveTeamMemberMessage:
               _loc31_ = param1 as GameFightRemoveTeamMemberMessage;
               this._fightContextFrame.entitiesFrame.process(RemoveEntityAction.create(_loc31_.charId));
               return true;
            case param1 is GameContextDestroyMessage:
               _loc32_ = new GameFightEndMessage();
               _loc32_.initGameFightEndMessage();
               _loc33_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               if(_loc33_)
               {
                  _loc33_.process(_loc32_);
               }
               else
               {
                  Kernel.getWorker().process(_loc32_);
               }
               return true;
            case param1 is IdolFightPreparationUpdateMessage:
               _loc34_ = param1 as IdolFightPreparationUpdateMessage;
               KernelEventsManager.getInstance().processCallback(FightHookList.IdolFightPreparationUpdate,_loc34_.idolSource,_loc34_.idols);
               return true;
            case param1 is ShowTacticModeAction:
               this.removeSelections();
               if(!TacticModeManager.getInstance().tacticModeActivated)
               {
                  TacticModeManager.getInstance().show(PlayedCharacterManager.getInstance().currentMap);
               }
               else
               {
                  TacticModeManager.getInstance().hide();
               }
               this.displayZone(SELECTION_CHALLENGER,this._challengerPositions,COLOR_CHALLENGER,this._playerTeam == TeamEnum.TEAM_CHALLENGER?Number(PLAYER_TEAM_ALPHA):Number(ENEMY_TEAM_ALPHA));
               this.displayZone(SELECTION_DEFENDER,this._defenderPositions,COLOR_DEFENDER,this._playerTeam == TeamEnum.TEAM_DEFENDER?Number(PLAYER_TEAM_ALPHA):Number(ENEMY_TEAM_ALPHA));
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         var _loc1_:SwapPositionRequest = null;
         DataMapProvider.getInstance().isInFight = false;
         this.removeSelections();
         this._fightContextFrame.entitiesFrame.untargetableEntities = Dofus.getInstance().options.cellSelectionOnly;
         for each(_loc1_ in this._swapPositionRequests)
         {
            _loc1_.destroy();
         }
         return true;
      }
      
      private function removeSelections() : void
      {
         var _loc1_:Selection = SelectionManager.getInstance().getSelection(SELECTION_CHALLENGER);
         if(_loc1_)
         {
            _loc1_.remove();
         }
         var _loc2_:Selection = SelectionManager.getInstance().getSelection(SELECTION_DEFENDER);
         if(_loc2_)
         {
            _loc2_.remove();
         }
      }
      
      private function displayZone(param1:String, param2:Vector.<uint>, param3:Color, param4:Number = 1.0) : void
      {
         var _loc5_:Selection = new Selection();
         _loc5_.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA,param4);
         _loc5_.color = param3;
         _loc5_.zone = new Custom(param2);
         SelectionManager.getInstance().addSelection(_loc5_,param1);
         SelectionManager.getInstance().update(param1);
      }
      
      private function isValidPlacementCell(param1:uint, param2:uint) : Boolean
      {
         var _loc5_:uint = 0;
         var _loc3_:MapPoint = MapPoint.fromCellId(param1);
         if(!DataMapProvider.getInstance().pointMov(_loc3_.x,_loc3_.y,false))
         {
            return false;
         }
         var _loc4_:Vector.<uint> = new Vector.<uint>();
         switch(param2)
         {
            case TeamEnum.TEAM_CHALLENGER:
               _loc4_ = this._challengerPositions;
               break;
            case TeamEnum.TEAM_DEFENDER:
               _loc4_ = this._defenderPositions;
               break;
            case TeamEnum.TEAM_SPECTATOR:
               return false;
         }
         if(_loc4_)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               if(_loc4_[_loc5_] == param1)
               {
                  return true;
               }
               _loc5_++;
            }
         }
         return false;
      }
      
      private function getSwapPositionRequest(param1:uint) : SwapPositionRequest
      {
         var _loc2_:SwapPositionRequest = null;
         for each(_loc2_ in this._swapPositionRequests)
         {
            if(_loc2_.requestId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function getPlayerSwapPositionRequests(param1:Number) : Vector.<SwapPositionRequest>
      {
         var _loc3_:SwapPositionRequest = null;
         var _loc2_:Vector.<SwapPositionRequest> = new Vector.<SwapPositionRequest>(0);
         for each(_loc3_ in this._swapPositionRequests)
         {
            if(_loc3_.requesterId == param1 || _loc3_.requestedId == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
   }
}
