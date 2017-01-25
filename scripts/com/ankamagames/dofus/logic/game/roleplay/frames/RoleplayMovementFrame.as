package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.entities.behaviours.movements.WalkingMovementBehavior;
   import com.ankamagames.atouin.messages.EntityMovementCompleteMessage;
   import com.ankamagames.atouin.messages.EntityMovementStoppedMessage;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.berilia.frames.ShortcutsFrame;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.common.actions.EmptyStackAction;
   import com.ankamagames.dofus.logic.game.common.frames.StackManagementFrame;
   import com.ankamagames.dofus.logic.game.common.managers.MapMovementAdapter;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.misc.stackedMessages.MoveBehavior;
   import com.ankamagames.dofus.logic.game.roleplay.actions.PlayerFightRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.managers.AnimFunManager;
   import com.ankamagames.dofus.logic.game.roleplay.messages.CharacterMovementStoppedMessage;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.messages.game.context.GameCautiousMapMovementMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameCautiousMapMovementRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementCancelMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementConfirmMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapNoMovementMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.ChangeMapMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.TeleportOnSameMapMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.delay.GameRolePlayDelayedActionFinishedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayAttackMonsterRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayFightRequestCanceledMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag.EditHavenBagFinishedMessage;
   import com.ankamagames.dofus.network.messages.game.dialog.LeaveDialogMessage;
   import com.ankamagames.dofus.network.messages.game.guild.tax.GuildFightPlayersHelpersLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUseEndedMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUseErrorMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUseRequestMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUsedMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeLeaveMessage;
   import com.ankamagames.dofus.network.messages.game.prism.PrismFightDefenderLeaveMessage;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.RiderBehavior;
   import com.ankamagames.jerakine.entities.behaviours.IMovementBehavior;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.enum.OperatingSystem;
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.pathfinding.Pathfinding;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import com.ankamagames.jerakine.utils.system.SystemManager;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class RoleplayMovementFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayMovementFrame));
      
      private static const CONSECUTIVE_MOVEMENT_DELAY:uint = 250;
       
      
      private var _wantToChangeMap:int = -1;
      
      private var _followingMove:MapPoint;
      
      private var _followingIe:Object;
      
      private var _followingMonsterGroup:Object;
      
      private var _followingMessage;
      
      private var _isRequestingMovement:Boolean;
      
      private var _latestMovementRequest:uint;
      
      private var _destinationPoint:uint;
      
      private var _nextMovementBehavior:uint;
      
      private var _lastPlayerValidatedPosition:MapPoint;
      
      private var _canMove:Boolean = true;
      
      private var _mapHasAggressiveMonsters:Boolean = false;
      
      public function RoleplayMovementFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get isRequestingMovement() : Boolean
      {
         return this._isRequestingMovement;
      }
      
      public function pushed() : Boolean
      {
         this._wantToChangeMap = -1;
         this._followingIe = null;
         this._followingMonsterGroup = null;
         this._followingMove = null;
         this._isRequestingMovement = false;
         this._latestMovementRequest = 0;
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         var _loc2_:GameMapMovementMessage = null;
         var _loc3_:EntityMovementCompleteMessage = null;
         var _loc4_:EntityMovementStoppedMessage = null;
         var _loc5_:TeleportOnSameMapMessage = null;
         var _loc6_:IEntity = null;
         var _loc7_:GameMapNoMovementMessage = null;
         var _loc8_:MapPoint = null;
         var _loc9_:AnimatedCharacter = null;
         var _loc10_:GameMapMovementConfirmMessage = null;
         var _loc11_:GameMapMovementCancelMessage = null;
         var _loc12_:StackManagementFrame = null;
         var _loc13_:MoveBehavior = null;
         switch(true)
         {
            case param1 is GameMapNoMovementMessage:
               this._isRequestingMovement = false;
               if(this._followingIe)
               {
                  this.activateSkill(this._followingIe.skillInstanceId,this._followingIe.ie);
                  this._followingIe = null;
               }
               if(this._followingMonsterGroup)
               {
                  this.requestMonsterFight(this._followingMonsterGroup.id);
                  this._followingMonsterGroup = null;
               }
               else if(!this._mapHasAggressiveMonsters)
               {
                  _loc7_ = param1 as GameMapNoMovementMessage;
                  _loc8_ = MapPoint.fromCoords(_loc7_.cellX,_loc7_.cellY);
                  _loc9_ = AnimatedCharacter(DofusEntities.getEntity(PlayedCharacterManager.getInstance().id));
                  if(!_loc9_)
                  {
                     return true;
                  }
                  if(_loc9_.isMoving)
                  {
                     _loc9_.stop(true);
                     _loc9_.setAnimation("AnimStatique");
                  }
                  _loc9_.position = _loc8_;
                  _loc9_.jump(_loc8_);
               }
               return true;
            case param1 is GameMapMovementMessage:
               _loc2_ = param1 as GameMapMovementMessage;
               if(this._mapHasAggressiveMonsters || _loc2_.actorId != PlayedCharacterManager.getInstance().id)
               {
                  this.applyGameMapMovement(_loc2_.actorId,MapMovementAdapter.getClientMovement(_loc2_.keyMovements),param1 is GameCautiousMapMovementMessage);
               }
               else
               {
                  this._lastPlayerValidatedPosition = MapMovementAdapter.getClientMovement(_loc2_.keyMovements).end;
               }
               return true;
            case param1 is EntityMovementCompleteMessage:
               _loc3_ = param1 as EntityMovementCompleteMessage;
               if(_loc3_.entity.id == PlayedCharacterManager.getInstance().id)
               {
                  _loc10_ = new GameMapMovementConfirmMessage();
                  ConnectionsHandler.getConnection().send(_loc10_);
                  if(this._wantToChangeMap >= 0 && _loc3_.entity.position.cellId == this._destinationPoint)
                  {
                     this.askMapChange();
                     this._isRequestingMovement = false;
                  }
                  if(this._followingIe)
                  {
                     this.activateSkill(this._followingIe.skillInstanceId,this._followingIe.ie);
                     this._followingIe = null;
                  }
                  if(this._followingMonsterGroup)
                  {
                     this.requestMonsterFight(this._followingMonsterGroup.id);
                     this._followingMonsterGroup = null;
                  }
                  Kernel.getWorker().process(new CharacterMovementStoppedMessage());
               }
               return true;
            case param1 is EntityMovementStoppedMessage:
               _loc4_ = param1 as EntityMovementStoppedMessage;
               if(_loc4_.entity.id == PlayedCharacterManager.getInstance().id)
               {
                  _loc11_ = new GameMapMovementCancelMessage();
                  _loc11_.initGameMapMovementCancelMessage(_loc4_.entity.position.cellId);
                  ConnectionsHandler.getConnection().send(_loc11_);
                  this._isRequestingMovement = false;
                  if(this._followingMove && this._canMove)
                  {
                     this.askMoveTo(this._followingMove);
                     _loc12_ = Kernel.getWorker().getFrame(StackManagementFrame) as StackManagementFrame;
                     if(_loc12_.stackOutputMessage.length > 0)
                     {
                        _loc13_ = _loc12_.stackOutputMessage[0] as MoveBehavior;
                        if(_loc13_ && _loc13_.position.cellId != this._followingMove.cellId)
                        {
                           Kernel.getWorker().process(EmptyStackAction.create());
                        }
                     }
                     this._followingMove = null;
                  }
                  if(this._followingMessage)
                  {
                     switch(true)
                     {
                        case this._followingMessage is PlayerFightRequestAction:
                           Kernel.getWorker().process(this._followingMessage);
                           break;
                        default:
                           ConnectionsHandler.getConnection().send(this._followingMessage);
                     }
                     this._followingMessage = null;
                  }
               }
               return true;
            case param1 is TeleportOnSameMapMessage:
               _loc5_ = param1 as TeleportOnSameMapMessage;
               _loc6_ = DofusEntities.getEntity(_loc5_.targetId);
               if(_loc6_)
               {
                  if(_loc6_ is IMovable)
                  {
                     if(IMovable(_loc6_).isMoving)
                     {
                        IMovable(_loc6_).stop(true);
                     }
                     (_loc6_ as IMovable).jump(MapPoint.fromCellId(_loc5_.cellId));
                  }
                  else
                  {
                     _log.warn("Cannot teleport a non IMovable entity. WTF ?");
                  }
               }
               else
               {
                  _log.warn("Received a teleportation request for a non-existing entity. Aborting.");
               }
               return true;
            case param1 is InteractiveUsedMessage:
               if(InteractiveUsedMessage(param1).entityId == PlayedCharacterManager.getInstance().id)
               {
                  this._canMove = InteractiveUsedMessage(param1).canMove;
               }
               return true;
            case param1 is InteractiveUseEndedMessage:
               this._canMove = true;
               return true;
            case param1 is InteractiveUseErrorMessage:
               this._canMove = true;
               return true;
            case param1 is LeaveDialogMessage:
               this._canMove = true;
               return false;
            case param1 is ExchangeLeaveMessage:
               this._canMove = true;
               return false;
            case param1 is EditHavenBagFinishedMessage:
               this._canMove = true;
               return false;
            case param1 is GameRolePlayDelayedActionFinishedMessage:
               if(GameRolePlayDelayedActionFinishedMessage(param1).delayedCharacterId == PlayedCharacterManager.getInstance().id)
               {
                  this._canMove = true;
               }
               return false;
            case param1 is GuildFightPlayersHelpersLeaveMessage:
               if(GuildFightPlayersHelpersLeaveMessage(param1).playerId == PlayedCharacterManager.getInstance().id)
               {
                  this._canMove = true;
               }
               return false;
            case param1 is PrismFightDefenderLeaveMessage:
               if(PrismFightDefenderLeaveMessage(param1).fighterToRemoveId == PlayedCharacterManager.getInstance().id)
               {
                  this._canMove = true;
               }
               return false;
            case param1 is GameRolePlayFightRequestCanceledMessage:
               if(GameRolePlayFightRequestCanceledMessage(param1).targetId == PlayedCharacterManager.getInstance().id || GameRolePlayFightRequestCanceledMessage(param1).sourceId == PlayedCharacterManager.getInstance().id)
               {
                  this._canMove = true;
               }
               return false;
            case param1 is MapComplementaryInformationsDataMessage:
               this._mapHasAggressiveMonsters = MapComplementaryInformationsDataMessage(param1).hasAggressiveMonsters;
               return false;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      function setNextMoveMapChange(param1:int) : void
      {
         this._wantToChangeMap = param1;
      }
      
      function resetNextMoveMapChange() : void
      {
         this._wantToChangeMap = -1;
      }
      
      function setFollowingInteraction(param1:Object) : void
      {
         this._followingIe = param1;
      }
      
      function setFollowingMonsterFight(param1:Object) : void
      {
         this._followingMonsterGroup = param1;
      }
      
      public function setFollowingMessage(param1:*) : void
      {
         if(!(param1 is INetworkMessage || param1 is Action))
         {
            throw new Error("The message is neither INetworkMessage or Action");
         }
         this._followingMessage = param1;
      }
      
      public function forceNextMovementBehavior(param1:uint) : void
      {
         this._nextMovementBehavior = param1;
      }
      
      function askMoveTo(param1:MapPoint) : Boolean
      {
         if(!this._mapHasAggressiveMonsters && !this._canMove)
         {
            return false;
         }
         if(this._isRequestingMovement)
         {
            return false;
         }
         var _loc2_:StackManagementFrame = Kernel.getWorker().getFrame(StackManagementFrame) as StackManagementFrame;
         var _loc3_:MoveBehavior = _loc2_.stackOutputMessage.length > 0?_loc2_.stackOutputMessage[0] as MoveBehavior:null;
         var _loc4_:uint = getTimer();
         if(this._latestMovementRequest + CONSECUTIVE_MOVEMENT_DELAY > _loc4_ && (!_loc3_ || !_loc3_.getMapPoint().equals(param1)))
         {
            return false;
         }
         this._isRequestingMovement = true;
         var _loc5_:IEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
         if(!_loc5_)
         {
            _log.warn("The player tried to move before its character was added to the scene. Aborting.");
            this._isRequestingMovement = false;
            return false;
         }
         this._destinationPoint = param1.cellId;
         if(IMovable(_loc5_).isMoving)
         {
            IMovable(_loc5_).stop();
            if(_loc5_ is AnimatedCharacter)
            {
               (_loc5_ as AnimatedCharacter).getRootEntity();
            }
            this._followingMove = param1;
            return false;
         }
         (_loc5_ as AnimatedCharacter).visibleAura = false;
         var _loc6_:MovementPath = Pathfinding.findPath(DataMapProvider.getInstance(),_loc5_.position,param1,!PlayedCharacterManager.getInstance().restrictions.cantWalk8Directions,true,this.sendPath);
         return true;
      }
      
      private function sendPath(param1:MovementPath) : void
      {
         var _loc4_:GameCautiousMapMovementRequestMessage = null;
         var _loc5_:GameMapMovementRequestMessage = null;
         var _loc2_:MovementPath = param1.clone();
         if(param1.start.cellId == param1.end.cellId)
         {
            _log.warn("Discarding a movement path that begins and ends on the same cell (" + param1.start.cellId + ").");
            this._isRequestingMovement = false;
            if(this._followingIe)
            {
               this.activateSkill(this._followingIe.skillInstanceId,this._followingIe.ie);
               this._followingIe = null;
            }
            if(this._followingMonsterGroup)
            {
               this.requestMonsterFight(this._followingMonsterGroup.id);
               this._followingMonsterGroup = null;
            }
            return;
         }
         var _loc3_:Boolean = false;
         if(!AirScanner.isStreamingVersion() && OptionManager.getOptionManager("dofus")["enableForceWalk"] == true && (this._nextMovementBehavior == AtouinConstants.MOVEMENT_WALK || this._nextMovementBehavior == 0 && (ShortcutsFrame.ctrlKeyDown || SystemManager.getSingleton().os == OperatingSystem.MAC_OS && ShortcutsFrame.altKeyDown)))
         {
            _loc4_ = new GameCautiousMapMovementRequestMessage();
            _loc4_.initGameCautiousMapMovementRequestMessage(MapMovementAdapter.getServerMovement(param1),PlayedCharacterManager.getInstance().currentMap.mapId);
            ConnectionsHandler.getConnection().send(_loc4_);
            _loc3_ = true;
         }
         else
         {
            _loc5_ = new GameMapMovementRequestMessage();
            _loc5_.initGameMapMovementRequestMessage(MapMovementAdapter.getServerMovement(param1),PlayedCharacterManager.getInstance().currentMap.mapId);
            ConnectionsHandler.getConnection().send(_loc5_);
         }
         if(!this._mapHasAggressiveMonsters)
         {
            this.applyGameMapMovement(PlayedCharacterManager.getInstance().id,_loc2_,_loc3_);
         }
         this._nextMovementBehavior = 0;
         this._latestMovementRequest = getTimer();
      }
      
      private function applyGameMapMovement(param1:Number, param2:MovementPath, param3:Boolean = false) : void
      {
         SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_MOVE);
         var _loc4_:IEntity = DofusEntities.getEntity(param1);
         if(!_loc4_)
         {
            _log.warn("The entity " + param1 + " moved before it was added to the scene. Aborting movement.");
            return;
         }
         var _loc5_:RoleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         var _loc6_:TiphonSprite = _loc4_ as TiphonSprite;
         if(_loc6_ && !_loc5_.isCreatureMode && _loc6_.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) && !_loc6_.getSubEntityBehavior(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER))
         {
            _loc6_.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,new RiderBehavior());
         }
         delete _loc5_.lastStaticAnimations[param1];
         TooltipManager.hide("smiley" + param1);
         TooltipManager.hide("msg" + param1);
         if(_loc4_.id == PlayedCharacterManager.getInstance().id)
         {
            this._isRequestingMovement = false;
            KernelEventsManager.getInstance().processCallback(TriggerHookList.PlayerMove);
         }
         if(OptionManager.getOptionManager("dofus")["allowAnimsFun"] == true)
         {
            AnimFunManager.getInstance().cancelAnim(param1);
         }
         (_loc4_ as IMovable).move(param2,null,!!param3?WalkingMovementBehavior.getInstance():null);
      }
      
      function askMapChange() : void
      {
         var _loc1_:ChangeMapMessage = new ChangeMapMessage();
         _loc1_.initChangeMapMessage(this._wantToChangeMap);
         ConnectionsHandler.getConnection().send(_loc1_);
         this._wantToChangeMap = -1;
      }
      
      function activateSkill(param1:uint, param2:InteractiveElement) : void
      {
         var _loc4_:InteractiveUseRequestMessage = null;
         var _loc3_:RoleplayInteractivesFrame = Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame;
         if(_loc3_ && _loc3_.currentRequestedElementId != param2.elementId && !_loc3_.usingInteractive && !_loc3_.isElementChangingState(param2.elementId))
         {
            _loc3_.currentRequestedElementId = param2.elementId;
            _loc4_ = new InteractiveUseRequestMessage();
            _loc4_.initInteractiveUseRequestMessage(param2.elementId,param1);
            ConnectionsHandler.getConnection().send(_loc4_);
            this._canMove = false;
         }
      }
      
      function requestMonsterFight(param1:int) : void
      {
         var _loc2_:GameRolePlayAttackMonsterRequestMessage = new GameRolePlayAttackMonsterRequestMessage();
         _loc2_.initGameRolePlayAttackMonsterRequestMessage(param1);
         ConnectionsHandler.getConnection().send(_loc2_);
      }
   }
}
