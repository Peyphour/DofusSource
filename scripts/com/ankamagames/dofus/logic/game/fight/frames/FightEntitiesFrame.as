package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.dofus.datacenter.effects.Effect;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.enum.UISoundEnum;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.dofus.logic.common.managers.PlayerManager;
   import com.ankamagames.dofus.logic.game.common.frames.AbstractEntitiesFrame;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.actions.RemoveEntityAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ShowMountsInFightAction;
   import com.ankamagames.dofus.logic.game.fight.actions.ToggleDematerializationAction;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.CarrierAnimationModifier;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightEntitiesHolder;
   import com.ankamagames.dofus.logic.game.fight.steps.FightCarryCharacterStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightChangeVisibilityStep;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.dofus.logic.game.fight.types.StatBuff;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.utils.EmbedAssets;
   import com.ankamagames.dofus.misc.utils.LookCleaner;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.network.enums.GameActionFightInvisibilityStateEnum;
   import com.ankamagames.dofus.network.enums.MapObstacleStateEnum;
   import com.ankamagames.dofus.network.enums.TeamEnum;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCarryCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightDropCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightThrowCharacterMessage;
   import com.ankamagames.dofus.network.messages.game.character.status.PlayerStatusUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRefreshEntityLookMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameEntitiesDispositionMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameEntityDispositionMessage;
   import com.ankamagames.dofus.network.messages.game.context.ShowCellMessage;
   import com.ankamagames.dofus.network.messages.game.context.ShowCellSpectatorMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightHumanReadyStateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightPlacementSwapPositionsMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightRefreshFighterMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterRandomStaticPoseMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataInHouseMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsWithCoordsMessage;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.FightEntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.IdentifiedEntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMinimalStatsPreparation;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.interactive.MapObstacle;
   import com.ankamagames.dofus.network.types.game.interactive.StatedElement;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.CustomBreedAnimationModifier;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   
   public class FightEntitiesFrame extends AbstractEntitiesFrame implements Frame
   {
      
      private static const TEAM_CIRCLE_COLOR_1:uint = 255;
      
      private static const TEAM_CIRCLE_COLOR_2:uint = 16711680;
       
      
      private var _showCellStart:Number = 0;
      
      private var arrowId:uint;
      
      private var _ie:Dictionary;
      
      private var _tempFighterList:Array;
      
      private var _illusionEntities:Dictionary;
      
      private var _entitiesNumber:Dictionary;
      
      private var _lastKnownPosition:Dictionary;
      
      private var _lastKnownMovementPoint:Dictionary;
      
      private var _lastKnownPlayerStatus:Dictionary;
      
      private var _realFightersLooks:Dictionary;
      
      private var _mountsVisible:Boolean;
      
      private var _numCreatureSwitchingEntities:int;
      
      private var _entitiesIconsToUpdate:Vector.<Number>;
      
      public function FightEntitiesFrame()
      {
         this._ie = new Dictionary(true);
         this._tempFighterList = new Array();
         this._entitiesIconsToUpdate = new Vector.<Number>(0);
         super();
      }
      
      public static function getCurrentInstance() : FightEntitiesFrame
      {
         return Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
      }
      
      override public function pushed() : Boolean
      {
         Atouin.getInstance().cellOverEnabled = true;
         Dofus.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         this._entitiesNumber = new Dictionary();
         this._illusionEntities = new Dictionary();
         this._lastKnownPosition = new Dictionary();
         this._lastKnownMovementPoint = new Dictionary();
         this._lastKnownPlayerStatus = new Dictionary();
         this._realFightersLooks = new Dictionary();
         _creaturesFightMode = OptionManager.getOptionManager("dofus")["creaturesFightMode"];
         this._mountsVisible = OptionManager.getOptionManager("dofus")["showMountsInFight"];
         return super.pushed();
      }
      
      override public function addOrUpdateActor(param1:GameContextActorInformations, param2:IAnimationModifier = null) : AnimatedCharacter
      {
         var _loc3_:AnimatedCharacter = super.addOrUpdateActor(param1,param2);
         if(param1.disposition.cellId != -1)
         {
            this.setLastKnownEntityPosition(param1.contextualId,param1.disposition.cellId);
         }
         if(param1.contextualId > 0)
         {
            _loc3_.disableMouseEventWhenAnimated = true;
         }
         if(CurrentPlayedFighterManager.getInstance().currentFighterId == param1.contextualId)
         {
            _loc3_.setCanSeeThrough(true);
         }
         if(param1 is GameFightCharacterInformations)
         {
            this._lastKnownPlayerStatus[param1.contextualId] = GameFightCharacterInformations(param1).status.statusId;
         }
         return _loc3_;
      }
      
      override public function process(param1:Message) : Boolean
      {
         var _loc2_:GameFightRefreshFighterMessage = null;
         var _loc3_:Number = NaN;
         var _loc4_:GameContextActorInformations = null;
         var _loc5_:GameFightShowFighterMessage = null;
         var _loc6_:FightContextFrame = null;
         var _loc7_:GameFightHumanReadyStateMessage = null;
         var _loc8_:AnimatedCharacter = null;
         var _loc9_:FightPreparationFrame = null;
         var _loc10_:GameEntityDispositionMessage = null;
         var _loc11_:GameFightPlacementSwapPositionsMessage = null;
         var _loc12_:IdentifiedEntityDispositionInformations = null;
         var _loc13_:GameEntitiesDispositionMessage = null;
         var _loc14_:GameContextRefreshEntityLookMessage = null;
         var _loc15_:TiphonSprite = null;
         var _loc16_:Number = NaN;
         var _loc17_:ShowCellSpectatorMessage = null;
         var _loc18_:String = null;
         var _loc19_:ShowCellMessage = null;
         var _loc20_:MapComplementaryInformationsDataMessage = null;
         var _loc21_:GameActionFightCarryCharacterMessage = null;
         var _loc22_:GameActionFightThrowCharacterMessage = null;
         var _loc23_:GameActionFightDropCharacterMessage = null;
         var _loc24_:PlayerStatusUpdateMessage = null;
         var _loc25_:ShowMountsInFightAction = null;
         var _loc26_:IAnimationModifier = null;
         var _loc27_:Sprite = null;
         var _loc28_:IdentifiedEntityDispositionInformations = null;
         var _loc29_:MapComplementaryInformationsWithCoordsMessage = null;
         var _loc30_:MapComplementaryInformationsDataInHouseMessage = null;
         var _loc31_:* = false;
         var _loc32_:MapObstacle = null;
         var _loc33_:InteractiveElement = null;
         var _loc34_:StatedElement = null;
         var _loc35_:GameFightFighterInformations = null;
         switch(true)
         {
            case param1 is GameFightRefreshFighterMessage:
               _loc2_ = param1 as GameFightRefreshFighterMessage;
               _loc3_ = _loc2_.informations.contextualId;
               _loc4_ = _entities[_loc3_];
               if(_loc4_ != null)
               {
                  _loc4_.disposition = _loc2_.informations.disposition;
                  _loc4_.look = _loc2_.informations.look;
                  this._realFightersLooks[_loc2_.informations.contextualId] = _loc2_.informations.look;
                  this.updateActor(_loc4_,true);
               }
               if(Kernel.getWorker().getFrame(FightPreparationFrame))
               {
                  KernelEventsManager.getInstance().processCallback(FightHookList.UpdatePreFightersList,_loc3_);
                  if(Dofus.getInstance().options.orderFighters)
                  {
                     this.updateAllEntitiesNumber(this.getOrdonnedPreFighters());
                  }
               }
               return true;
            case param1 is GameFightShowFighterMessage:
               _loc5_ = param1 as GameFightShowFighterMessage;
               this._realFightersLooks[_loc5_.informations.contextualId] = _loc5_.informations.look;
               if(param1 is GameFightShowFighterRandomStaticPoseMessage)
               {
                  _loc26_ = new CustomBreedAnimationModifier();
                  (_loc26_ as CustomBreedAnimationModifier).randomStatique = true;
                  this.updateFighter(_loc5_.informations,_loc26_);
                  this._illusionEntities[_loc5_.informations.contextualId] = true;
               }
               else
               {
                  this.updateFighter(_loc5_.informations);
                  this._illusionEntities[_loc5_.informations.contextualId] = false;
                  if(Kernel.getWorker().getFrame(FightPreparationFrame))
                  {
                     KernelEventsManager.getInstance().processCallback(FightHookList.UpdatePreFightersList,_loc5_.informations.contextualId);
                     if(Dofus.getInstance().options.orderFighters)
                     {
                        this.updateAllEntitiesNumber(this.getOrdonnedPreFighters());
                     }
                  }
               }
               _loc6_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
               if(_loc6_.fightersPositionsHistory[_loc5_.informations.contextualId])
               {
               }
               return true;
            case param1 is GameFightHumanReadyStateMessage:
               _loc7_ = param1 as GameFightHumanReadyStateMessage;
               _loc8_ = this.addOrUpdateActor(getEntityInfos(_loc7_.characterId) as GameFightFighterInformations);
               if(_loc7_.isReady)
               {
                  _loc27_ = EmbedAssets.getSprite("SWORDS_CLIP");
                  _loc8_.addBackground("readySwords",_loc27_);
               }
               else
               {
                  _loc8_.removeBackground("readySwords");
                  if(_loc7_.characterId == PlayedCharacterManager.getInstance().id)
                  {
                     KernelEventsManager.getInstance().processCallback(FightHookList.NotReadyToFight);
                  }
               }
               _loc9_ = Kernel.getWorker().getFrame(FightPreparationFrame) as FightPreparationFrame;
               if(_loc9_)
               {
                  _loc9_.updateSwapPositionRequestsIcons();
               }
               return true;
            case param1 is GameEntityDispositionMessage:
               _loc10_ = param1 as GameEntityDispositionMessage;
               if(_loc10_.disposition.id == CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  SoundManager.getInstance().manager.playUISound(UISoundEnum.FIGHT_POSITION);
               }
               this.updateActorDisposition(_loc10_.disposition.id,_loc10_.disposition);
               KernelEventsManager.getInstance().processCallback(FightHookList.GameEntityDisposition,_loc10_.disposition.id,_loc10_.disposition.cellId,_loc10_.disposition.direction);
               return true;
            case param1 is GameFightPlacementSwapPositionsMessage:
               _loc11_ = param1 as GameFightPlacementSwapPositionsMessage;
               for each(_loc12_ in _loc11_.dispositions)
               {
                  this.updateActorDisposition(_loc12_.id,_loc12_);
                  KernelEventsManager.getInstance().processCallback(FightHookList.GameEntityDisposition,_loc12_.id,_loc12_.cellId,_loc12_.direction);
               }
               return true;
            case param1 is GameEntitiesDispositionMessage:
               _loc13_ = param1 as GameEntitiesDispositionMessage;
               for each(_loc28_ in _loc13_.dispositions)
               {
                  if(getEntityInfos(_loc28_.id) && GameFightFighterInformations(getEntityInfos(_loc28_.id)).stats.invisibilityState != GameActionFightInvisibilityStateEnum.INVISIBLE)
                  {
                     this.updateActorDisposition(_loc28_.id,_loc28_);
                  }
                  KernelEventsManager.getInstance().processCallback(FightHookList.GameEntityDisposition,_loc28_.id,_loc28_.cellId,_loc28_.direction);
               }
               return true;
            case param1 is GameContextRefreshEntityLookMessage:
               _loc14_ = param1 as GameContextRefreshEntityLookMessage;
               _loc15_ = DofusEntities.getEntity(_loc14_.id) as TiphonSprite;
               if(_loc15_)
               {
                  _loc15_.setAnimation(AnimationEnum.ANIM_STATIQUE);
               }
               this.updateActorLook(_loc14_.id,_loc14_.look);
               return true;
            case param1 is ToggleDematerializationAction:
               this.showCreaturesInFight(!_creaturesFightMode);
               KernelEventsManager.getInstance().processCallback(FightHookList.DematerializationChanged,_creaturesFightMode);
               return true;
            case param1 is RemoveEntityAction:
               _loc16_ = RemoveEntityAction(param1).actorId;
               this._entitiesNumber[_loc16_] = null;
               removeActor(_loc16_);
               KernelEventsManager.getInstance().processCallback(FightHookList.UpdatePreFightersList,_loc16_);
               delete this._realFightersLooks[_loc16_];
               return true;
            case param1 is ShowCellSpectatorMessage:
               _loc17_ = param1 as ShowCellSpectatorMessage;
               HyperlinkShowCellManager.showCell(_loc17_.cellId);
               _loc18_ = I18n.getUiText("ui.fight.showCell",[_loc17_.playerName,"{cell," + _loc17_.cellId + "::" + _loc17_.cellId + "}"]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,_loc18_,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO,TimeManager.getInstance().getTimestamp());
               return true;
            case param1 is ShowCellMessage:
               _loc19_ = param1 as ShowCellMessage;
               HyperlinkShowCellManager.showCell(_loc19_.cellId);
               return true;
            case param1 is MapComplementaryInformationsDataMessage:
               _loc20_ = param1 as MapComplementaryInformationsDataMessage;
               _interactiveElements = _loc20_.interactiveElements;
               if(param1 is MapComplementaryInformationsWithCoordsMessage)
               {
                  _loc29_ = param1 as MapComplementaryInformationsWithCoordsMessage;
                  if(PlayedCharacterManager.getInstance().isInHouse)
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.HouseExit);
                  }
                  PlayedCharacterManager.getInstance().isInHouse = false;
                  PlayedCharacterManager.getInstance().isInHisHouse = false;
                  PlayedCharacterManager.getInstance().currentMap.setOutdoorCoords(_loc29_.worldX,_loc29_.worldY);
                  _worldPoint = new WorldPointWrapper(_loc29_.mapId,true,_loc29_.worldX,_loc29_.worldY);
               }
               else if(param1 is MapComplementaryInformationsDataInHouseMessage)
               {
                  _loc30_ = param1 as MapComplementaryInformationsDataInHouseMessage;
                  _loc31_ = PlayerManager.getInstance().nickname == _loc30_.currentHouse.ownerName;
                  PlayedCharacterManager.getInstance().isInHouse = true;
                  if(_loc31_)
                  {
                     PlayedCharacterManager.getInstance().isInHisHouse = true;
                  }
                  PlayedCharacterManager.getInstance().currentMap.setOutdoorCoords(_loc30_.currentHouse.worldX,_loc30_.currentHouse.worldY);
                  KernelEventsManager.getInstance().processCallback(HookList.HouseEntered,_loc31_,_loc30_.currentHouse.ownerId,_loc30_.currentHouse.ownerName,_loc30_.currentHouse.price,_loc30_.currentHouse.isLocked,_loc30_.currentHouse.worldX,_loc30_.currentHouse.worldY,HouseWrapper.manualCreate(_loc30_.currentHouse.modelId,-1,_loc30_.currentHouse.ownerName,_loc30_.currentHouse.price != 0));
                  _worldPoint = new WorldPointWrapper(_loc30_.mapId,true,_loc30_.currentHouse.worldX,_loc30_.currentHouse.worldY);
               }
               else
               {
                  _worldPoint = new WorldPointWrapper(_loc20_.mapId);
                  if(PlayedCharacterManager.getInstance().isInHouse)
                  {
                     KernelEventsManager.getInstance().processCallback(HookList.HouseExit);
                  }
                  PlayedCharacterManager.getInstance().isInHouse = false;
                  PlayedCharacterManager.getInstance().isInHisHouse = false;
               }
               _currentSubAreaId = _loc20_.subAreaId;
               PlayedCharacterManager.getInstance().currentMap = _worldPoint;
               PlayedCharacterManager.getInstance().currentSubArea = SubArea.getSubAreaById(_currentSubAreaId);
               TooltipManager.hide();
               for each(_loc32_ in _loc20_.obstacles)
               {
                  InteractiveCellManager.getInstance().updateCell(_loc32_.obstacleCellId,_loc32_.state == MapObstacleStateEnum.OBSTACLE_OPENED);
               }
               for each(_loc33_ in _loc20_.interactiveElements)
               {
                  if(_loc33_.enabledSkills.length)
                  {
                     this.registerInteractive(_loc33_,_loc33_.enabledSkills[0].skillId);
                  }
                  else if(_loc33_.disabledSkills.length)
                  {
                     this.registerInteractive(_loc33_,_loc33_.disabledSkills[0].skillId);
                  }
               }
               for each(_loc34_ in _loc20_.statedElements)
               {
                  this.updateStatedElement(_loc34_);
               }
               KernelEventsManager.getInstance().processCallback(HookList.MapComplementaryInformationsData,PlayedCharacterManager.getInstance().currentMap,_currentSubAreaId,Dofus.getInstance().options.mapCoordinates);
               KernelEventsManager.getInstance().processCallback(HookList.MapFightCount,0);
               return true;
            case param1 is GameActionFightCarryCharacterMessage:
               _loc21_ = param1 as GameActionFightCarryCharacterMessage;
               if(_loc21_.cellId != -1)
               {
                  for each(_loc35_ in _entities)
                  {
                     if(_loc35_.contextualId == _loc21_.targetId)
                     {
                        (_loc35_.disposition as FightEntityDispositionInformations).carryingCharacterId = _loc21_.sourceId;
                        this._tempFighterList.push(new TmpFighterInfos(_loc35_.contextualId,_loc21_.sourceId));
                        break;
                     }
                  }
               }
               return true;
            case param1 is GameActionFightThrowCharacterMessage:
               _loc22_ = param1 as GameActionFightThrowCharacterMessage;
               this.dropEntity(_loc22_.targetId);
               return true;
            case param1 is GameActionFightDropCharacterMessage:
               _loc23_ = param1 as GameActionFightDropCharacterMessage;
               this.dropEntity(_loc23_.targetId);
               return true;
            case param1 is PlayerStatusUpdateMessage:
               _loc24_ = param1 as PlayerStatusUpdateMessage;
               this._lastKnownPlayerStatus[_loc24_.playerId] = _loc24_.status.statusId;
               return false;
            case param1 is ShowMountsInFightAction:
               _loc25_ = param1 as ShowMountsInFightAction;
               OptionManager.getOptionManager("dofus")["showMountsInFight"] = _loc25_.visibility;
               return true;
            default:
               return false;
         }
      }
      
      private function dropEntity(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GameFightFighterInformations = null;
         for each(_loc3_ in _entities)
         {
            if(_loc3_.contextualId == param1)
            {
               (_loc3_.disposition as FightEntityDispositionInformations).carryingCharacterId = NaN;
               _loc2_ = this.getTmpFighterInfoIndex(_loc3_.contextualId);
               if(this._tempFighterList != null && this._tempFighterList.length != 0 && _loc2_ != -1)
               {
                  this._tempFighterList.splice(_loc2_,1);
               }
               return;
            }
         }
      }
      
      public function showCreaturesInFight(param1:Boolean = false) : void
      {
         var _loc2_:GameFightFighterInformations = null;
         var _loc3_:AnimatedCharacter = null;
         _creaturesFightMode = param1;
         _justSwitchingCreaturesFightMode = true;
         this._numCreatureSwitchingEntities = 0;
         for each(_loc2_ in _entities)
         {
            this.updateFighter(_loc2_);
            _loc3_ = DofusEntities.getEntity(_loc2_.contextualId) as AnimatedCharacter;
            if(_loc3_ && !_loc3_.rendered)
            {
               this._numCreatureSwitchingEntities++;
               _loc3_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onCreatureSwitchEnd);
            }
         }
         _justSwitchingCreaturesFightMode = false;
         if(this._numCreatureSwitchingEntities == 0)
         {
            this.onCreatureSwitchEnd(null);
         }
         FightEntitiesFrame.getCurrentInstance().updateAllIcons();
      }
      
      public function switchMountsVisibility(param1:Boolean) : void
      {
         var _loc2_:GameFightFighterInformations = null;
         var _loc3_:FightSpellCastFrame = null;
         var _loc4_:TiphonSprite = null;
         this._mountsVisible = param1;
         for each(_loc2_ in _entities)
         {
            this.updateFighter(_loc2_);
         }
         _loc3_ = Kernel.getWorker().getFrame(FightSpellCastFrame) as FightSpellCastFrame;
         if(_loc3_ && _loc3_.spellId == 74 && _loc3_.hasInvocationPreview)
         {
            _loc4_ = _loc3_.invocationPreview[0];
            _loc4_.look.updateFrom(!!this._mountsVisible?EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook):TiphonUtility.getLookWithoutMount(EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook)));
         }
      }
      
      public function stopAllAnimations() : void
      {
         var _loc1_:GameFightFighterInformations = null;
         var _loc2_:IEntity = null;
         for each(_loc1_ in _entities)
         {
            _loc2_ = DofusEntities.getEntity(_loc1_.contextualId);
            if(_loc2_ && _loc2_ is IAnimated && _loc2_ is TiphonSprite && (_loc2_ as TiphonSprite).isPlayingAnimation())
            {
               _log.debug("animation pour " + _loc1_.contextualId);
               (_loc2_ as TiphonSprite).stopAnimationAtEnd();
            }
         }
      }
      
      public function entityIsIllusion(param1:Number) : Boolean
      {
         return this._illusionEntities[param1];
      }
      
      public function getLastKnownEntityPosition(param1:Number) : int
      {
         return this._lastKnownPosition[param1] != null?int(this._lastKnownPosition[param1]):-1;
      }
      
      public function setLastKnownEntityPosition(param1:Number, param2:int) : void
      {
         this._lastKnownPosition[param1] = param2;
      }
      
      public function getLastKnownEntityMovementPoint(param1:Number) : int
      {
         return this._lastKnownMovementPoint[param1] != null?int(this._lastKnownMovementPoint[param1]):0;
      }
      
      public function setLastKnownEntityMovementPoint(param1:Number, param2:int, param3:Boolean = false) : void
      {
         if(this._lastKnownMovementPoint[param1] == null)
         {
            this._lastKnownMovementPoint[param1] = 0;
         }
         if(!param3)
         {
            this._lastKnownMovementPoint[param1] = param2;
         }
         else
         {
            this._lastKnownMovementPoint[param1] = this._lastKnownMovementPoint[param1] + param2;
         }
      }
      
      override public function pulled() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         Dofus.getInstance().options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         this._tempFighterList = null;
         for each(_loc1_ in this._ie)
         {
            this.removeInteractive(_loc1_.element as InteractiveElement);
         }
         for(_loc2_ in this._realFightersLooks)
         {
            delete this._realFightersLooks[_loc2_];
         }
         return super.pulled();
      }
      
      private function onTimeOut() : void
      {
         clearTimeout(this._showCellStart);
         removeActor(this.arrowId);
         this._showCellStart = 0;
      }
      
      private function registerInteractive(param1:InteractiveElement, param2:int) : void
      {
         var _loc5_:* = null;
         var _loc7_:InteractiveElement = null;
         var _loc3_:InteractiveObject = Atouin.getInstance().getIdentifiedElement(param1.elementId);
         if(!_loc3_)
         {
            _log.error("Unknown identified element " + param1.elementId + ", unable to register it as interactive.");
            return;
         }
         var _loc4_:Boolean = false;
         for(_loc5_ in interactiveElements)
         {
            _loc7_ = interactiveElements[int(_loc5_)];
            if(_loc7_.elementId == param1.elementId)
            {
               _loc4_ = true;
               interactiveElements[int(_loc5_)] = param1;
               break;
            }
         }
         if(!_loc4_)
         {
            interactiveElements.push(param1);
         }
         var _loc6_:MapPoint = Atouin.getInstance().getIdentifiedElementPosition(param1.elementId);
         this._ie[_loc3_] = {
            "element":param1,
            "position":_loc6_,
            "firstSkill":param2
         };
      }
      
      private function updateStatedElement(param1:StatedElement) : void
      {
         var _loc2_:InteractiveObject = Atouin.getInstance().getIdentifiedElement(param1.elementId);
         if(!_loc2_)
         {
            _log.error("Unknown identified element " + param1.elementId + "; unable to change its state to " + param1.elementState + " !");
            return;
         }
         var _loc3_:TiphonSprite = _loc2_ is DisplayObjectContainer?this.findTiphonSprite(_loc2_ as DisplayObjectContainer):null;
         if(!_loc3_)
         {
            _log.warn("Unable to find an animated element for the stated element " + param1.elementId + " on cell " + param1.elementCellId + ", this element is probably invisible or is not configured as an animated element.");
            return;
         }
         _loc3_.setAnimationAndDirection("AnimState1",0);
      }
      
      private function findTiphonSprite(param1:DisplayObjectContainer) : TiphonSprite
      {
         var _loc3_:DisplayObject = null;
         if(param1 is TiphonSprite)
         {
            return param1 as TiphonSprite;
         }
         if(!param1.numChildren)
         {
            return null;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            if(_loc3_ is TiphonSprite)
            {
               return _loc3_ as TiphonSprite;
            }
            if(_loc3_ is DisplayObjectContainer)
            {
               return this.findTiphonSprite(_loc3_ as DisplayObjectContainer);
            }
            _loc2_++;
         }
         return null;
      }
      
      private function removeInteractive(param1:InteractiveElement) : void
      {
         var _loc2_:InteractiveObject = Atouin.getInstance().getIdentifiedElement(param1.elementId);
         delete this._ie[_loc2_];
      }
      
      private function onCreatureSwitchEnd(param1:TiphonEvent) : void
      {
         var _loc2_:FightPreparationFrame = null;
         if(param1)
         {
            param1.currentTarget.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onCreatureSwitchEnd);
            this._numCreatureSwitchingEntities--;
         }
         if(this._numCreatureSwitchingEntities == 0)
         {
            _loc2_ = Kernel.getWorker().getFrame(FightPreparationFrame) as FightPreparationFrame;
            if(_loc2_)
            {
               _loc2_.updateSwapPositionRequestsIcons();
            }
         }
      }
      
      override protected function showIcons(param1:Event = null) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:UiRootContainer = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = _updateAllIcons;
         this._entitiesIconsToUpdate.length = 0;
         for(_loc2_ in _entitiesIconsNames)
         {
            if(_entitiesIcons[_loc2_] && _entitiesIcons[_loc2_].needUpdate)
            {
               this._entitiesIconsToUpdate.push(_loc2_);
            }
         }
         super.showIcons(param1);
         for(_loc2_ in _entitiesIconsNames)
         {
            _loc3_ = Berilia.getInstance().getUi("tooltip_tooltipOverEntity_" + _loc2_);
            _loc4_ = this._entitiesIconsToUpdate.indexOf(_loc2_) != -1 && !_entitiesIcons[_loc2_].needUpdate;
            if((_entitiesIcons[_loc2_] && _entitiesIcons[_loc2_].needUpdate || _loc4_ || _loc5_) && _loc3_)
            {
               this.updateEntityIconPosition(_loc2_);
            }
         }
      }
      
      public function getOrdonnedPreFighters() : Vector.<Number>
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc11_:GameFightFighterInformations = null;
         var _loc12_:GameFightMinimalStatsPreparation = null;
         var _loc13_:int = 0;
         var _loc1_:Vector.<Number> = getEntitiesIdsList();
         var _loc2_:Vector.<Number> = new Vector.<Number>();
         if(!_loc1_ || _loc1_.length <= 1)
         {
            return _loc2_;
         }
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         for each(_loc7_ in _loc1_)
         {
            _loc11_ = getEntityInfos(_loc7_) as GameFightFighterInformations;
            if(_loc11_)
            {
               _loc12_ = _loc11_.stats as GameFightMinimalStatsPreparation;
               _loc13_ = 0;
               if(_loc11_ is GameFightMonsterInformations)
               {
                  _loc13_ = (_loc11_ as GameFightMonsterInformations).creatureGenericId;
               }
               if(_loc12_)
               {
                  if(_loc11_.teamId == 0)
                  {
                     _loc4_.push({
                        "fighterId":_loc7_,
                        "init":_loc12_.initiative * _loc12_.lifePoints / _loc12_.maxLifePoints,
                        "monsterId":_loc13_
                     });
                     _loc5_ = _loc5_ + _loc12_.initiative * _loc12_.lifePoints / _loc12_.maxLifePoints;
                  }
                  else
                  {
                     _loc3_.push({
                        "fighterId":_loc7_,
                        "init":_loc12_.initiative * _loc12_.lifePoints / _loc12_.maxLifePoints,
                        "monsterId":_loc13_
                     });
                     _loc6_ = _loc6_ + _loc12_.initiative * _loc12_.lifePoints / _loc12_.maxLifePoints;
                  }
               }
            }
         }
         _loc4_.sortOn(["init","monsterId","fighterId"],Array.DESCENDING | Array.NUMERIC);
         _loc3_.sortOn(["init","monsterId","fighterId"],Array.DESCENDING | Array.NUMERIC);
         _loc8_ = true;
         if(_loc4_.length == 0 || _loc3_.length == 0 || _loc5_ / _loc4_.length < _loc6_ / _loc3_.length)
         {
            _loc8_ = false;
         }
         var _loc9_:int = Math.max(_loc4_.length,_loc3_.length);
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_)
         {
            if(_loc8_)
            {
               if(_loc4_[_loc10_])
               {
                  _loc2_.push(_loc4_[_loc10_].fighterId);
               }
               if(_loc3_[_loc10_])
               {
                  _loc2_.push(_loc3_[_loc10_].fighterId);
               }
            }
            else
            {
               if(_loc3_[_loc10_])
               {
                  _loc2_.push(_loc3_[_loc10_].fighterId);
               }
               if(_loc4_[_loc10_])
               {
                  _loc2_.push(_loc4_[_loc10_].fighterId);
               }
            }
            _loc10_++;
         }
         return _loc2_;
      }
      
      public function removeSwords() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:AnimatedCharacter = null;
         for each(_loc1_ in _entities)
         {
            if(!(_loc1_ is GameFightCharacterInformations && !GameFightCharacterInformations(_loc1_).alive))
            {
               _loc2_ = this.addOrUpdateActor(_loc1_);
               _loc2_.removeBackground("readySwords");
            }
         }
      }
      
      public function updateFighter(param1:GameFightFighterInformations, param2:IAnimationModifier = null, param3:Array = null) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:BasicBuff = null;
         var _loc8_:StatBuff = null;
         var _loc9_:String = null;
         var _loc10_:Effect = null;
         var _loc11_:int = 0;
         var _loc12_:GameFightFighterInformations = null;
         var _loc13_:AnimatedCharacter = null;
         var _loc14_:FightChangeVisibilityStep = null;
         var _loc4_:Number = param1.contextualId;
         if(param3)
         {
            _loc5_ = 0;
            while(_loc5_ < param3.length)
            {
               _loc6_ = BuffManager.getInstance().getAllBuff(_loc4_);
               for each(_loc7_ in _loc6_)
               {
                  if(_loc7_.id == param3[_loc5_].id)
                  {
                     _loc8_ = param3[_loc5_] as StatBuff;
                     _loc9_ = _loc8_.statName;
                     _loc10_ = Effect.getEffectById(_loc8_.actionId);
                     if(_loc9_ && param1.stats.hasOwnProperty(_loc9_) && _loc10_.active)
                     {
                        if(_loc9_ == "actionPoints")
                        {
                           param1.stats["maxActionPoints"] = param1.stats["maxActionPoints"] - param3[_loc5_].delta;
                        }
                        param1.stats[_loc9_] = param1.stats[_loc9_] - param3[_loc5_].delta;
                     }
                  }
               }
               _loc5_++;
            }
         }
         if(param1.alive)
         {
            _loc11_ = -1;
            _loc12_ = _entities[param1.contextualId] as GameFightFighterInformations;
            if(_loc12_)
            {
               _loc11_ = _loc12_.stats.invisibilityState;
            }
            if(_loc11_ == GameActionFightInvisibilityStateEnum.INVISIBLE && param1.stats.invisibilityState == _loc11_)
            {
               registerActor(param1);
               return;
            }
            _loc13_ = this.addOrUpdateActor(param1,param2);
            if(_loc12_ != param1)
            {
               if(param1.contextualId == CurrentPlayedFighterManager.getInstance().currentFighterId)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.CharacterStatsList);
               }
            }
            if(param1.stats.invisibilityState != GameActionFightInvisibilityStateEnum.VISIBLE && param1.stats.invisibilityState != _loc11_)
            {
               _loc14_ = new FightChangeVisibilityStep(_loc4_,param1.stats.invisibilityState);
               _loc14_.start();
            }
            this.addCircleToFighter(_loc13_,param1.teamId == TeamEnum.TEAM_DEFENDER?uint(TEAM_CIRCLE_COLOR_1):uint(TEAM_CIRCLE_COLOR_2));
         }
         else
         {
            this.updateActor(param1,false);
         }
         this.updateCarriedEntities(param1);
      }
      
      public function updateActor(param1:GameContextActorInformations, param2:Boolean = true, param3:IAnimationModifier = null) : void
      {
         if(param2)
         {
            this.addOrUpdateActor(param1,param3);
         }
         else
         {
            if(_entities[param1.contextualId])
            {
               hideActor(param1.contextualId);
            }
            registerActor(param1);
         }
      }
      
      override protected function updateActorLook(param1:Number, param2:EntityLook, param3:Boolean = false) : AnimatedCharacter
      {
         var _loc4_:AnimatedCharacter = super.updateActorLook(param1,param2,param3);
         if(_loc4_ && param1 != PlayedCharacterManager.getInstance().id)
         {
            KernelEventsManager.getInstance().processCallback(HookList.FighterLookChange,param1,LookCleaner.clean(_loc4_.look));
         }
         return _loc4_;
      }
      
      public function addCircleToFighter(param1:TiphonSprite, param2:uint) : void
      {
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Sprite = EmbedAssets.getSprite("TEAM_CIRCLE_CLIP");
         _loc3_.addChild(_loc4_);
         var _loc5_:ColorTransform = new ColorTransform();
         _loc5_.color = param2;
         _loc3_.filters = [new GlowFilter(16777215,0.5,2,2,3,3)];
         _loc4_.transform.colorTransform = _loc5_;
         param1.addBackground("teamCircle",_loc3_);
      }
      
      private function updateCarriedEntities(param1:GameContextActorInformations) : void
      {
         var _loc5_:TmpFighterInfos = null;
         var _loc6_:Number = NaN;
         var _loc7_:FightEntityDispositionInformations = null;
         var _loc8_:IEntity = null;
         var _loc9_:IEntity = null;
         var _loc10_:Boolean = false;
         var _loc11_:TiphonSprite = null;
         var _loc12_:IAnimationModifier = null;
         var _loc2_:Number = param1.contextualId;
         var _loc3_:int = this._tempFighterList.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._tempFighterList[_loc4_];
            _loc6_ = _loc5_.carryingCharacterId;
            if(_loc2_ == _loc6_)
            {
               this._tempFighterList.splice(_loc4_,1);
               this.startCarryStep(_loc6_,_loc5_.contextualId);
               break;
            }
            _loc4_++;
         }
         if(param1.disposition is FightEntityDispositionInformations)
         {
            _loc7_ = param1.disposition as FightEntityDispositionInformations;
            if(_loc7_.carryingCharacterId)
            {
               _loc8_ = DofusEntities.getEntity(_loc7_.carryingCharacterId);
               if(!_loc8_)
               {
                  this._tempFighterList.push(new TmpFighterInfos(param1.contextualId,_loc7_.carryingCharacterId));
               }
               else
               {
                  _loc9_ = DofusEntities.getEntity(param1.contextualId);
                  if(_loc9_)
                  {
                     _loc10_ = false;
                     if((_loc8_ as AnimatedCharacter).isMounted())
                     {
                        _loc11_ = (_loc8_ as TiphonSprite).getSubEntitySlot(2,0) as TiphonSprite;
                     }
                     else
                     {
                        _loc11_ = _loc8_ as TiphonSprite;
                     }
                     if(_loc11_)
                     {
                        _loc11_.removeAnimationModifierByClass(CustomBreedAnimationModifier);
                        for each(_loc12_ in _loc11_.animationModifiers)
                        {
                           if(_loc12_ is CarrierAnimationModifier)
                           {
                              _loc10_ = true;
                              break;
                           }
                        }
                        if(!_loc10_)
                        {
                           _loc11_.addAnimationModifier(CarrierAnimationModifier.getInstance());
                        }
                     }
                     if(!_loc10_ || !(_loc8_ is TiphonSprite && _loc9_ is TiphonSprite && TiphonSprite(_loc9_).parentSprite == _loc8_))
                     {
                        this.startCarryStep(_loc7_.carryingCharacterId,param1.contextualId);
                     }
                  }
               }
            }
         }
      }
      
      private function startCarryStep(param1:Number, param2:Number) : void
      {
         var _loc3_:FightCarryCharacterStep = new FightCarryCharacterStep(param1,param2,-1,true);
         _loc3_.start();
         FightEventsHelper.sendAllFightEvent();
      }
      
      public function updateAllEntitiesNumber(param1:Vector.<Number>) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:uint = 1;
         for each(_loc3_ in param1)
         {
            if(_entities[_loc3_] && _entities[_loc3_].alive)
            {
               this.updateEntityNumber(_loc3_,_loc2_);
               _loc2_++;
            }
         }
      }
      
      public function updateEntityNumber(param1:Number, param2:uint) : void
      {
         var _loc3_:Sprite = null;
         var _loc4_:Label = null;
         var _loc5_:AnimatedCharacter = null;
         if(_entities[param1] && (!(_entities[param1] is GameFightCharacterInformations) || GameFightCharacterInformations(_entities[param1]).alive))
         {
            if(!this._entitiesNumber[param1] || this._entitiesNumber[param1] == null)
            {
               _loc3_ = new Sprite();
               _loc4_ = new Label();
               _loc4_.width = 30;
               _loc4_.height = 20;
               _loc4_.x = -45;
               _loc4_.y = -15;
               _loc4_.css = new Uri(XmlConfig.getInstance().getEntry("config.ui.skin") + "css/normal.css");
               _loc4_.text = param2.toString();
               _loc3_.addChild(_loc4_);
               _loc3_.filters = [new GlowFilter(XmlConfig.getInstance().getEntry("colors.text.glow"),1,4,4,6,3)];
               this._entitiesNumber[param1] = _loc4_;
               _loc5_ = DofusEntities.getEntity(param1) as AnimatedCharacter;
               if(_loc5_)
               {
                  _loc5_.addBackground("fighterNumber",_loc3_);
               }
            }
            else
            {
               this._entitiesNumber[param1].text = param2.toString();
            }
         }
      }
      
      public function updateRemovedEntity(param1:Number) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:FightBattleFrame = null;
         var _loc4_:Number = NaN;
         this._entitiesNumber[param1] = null;
         if(Dofus.getInstance().options.orderFighters)
         {
            _loc2_ = 1;
            _loc3_ = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame;
            for each(_loc4_ in _loc3_.fightersList)
            {
               if(_loc4_ != param1 && (getEntityInfos(_loc4_) as GameFightFighterInformations).alive)
               {
                  this.updateEntityNumber(_loc4_,_loc2_);
                  _loc2_++;
               }
            }
         }
      }
      
      public function updateEntityIconPosition(param1:Number) : void
      {
         var _loc3_:UiRootContainer = null;
         var _loc4_:IRectangle = null;
         var _loc2_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         if(_loc2_ && _loc2_.parent && _loc2_.displayed && hasIcon(param1))
         {
            _loc3_ = Berilia.getInstance().getUi("tooltip_tooltipOverEntity_" + param1);
            _loc4_ = !_loc3_?getIconEntityBounds(DofusEntities.getEntity(param1) as AnimatedCharacter):new Rectangle2(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
            getIcon(param1).place(_loc4_);
         }
      }
      
      override protected function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:* = null;
         var _loc3_:AnimatedCharacter = null;
         var _loc4_:uint = 0;
         var _loc5_:FightBattleFrame = null;
         var _loc6_:Number = NaN;
         if(!_worldPoint)
         {
            _worldPoint = PlayedCharacterManager.getInstance().currentMap;
         }
         if(!_currentSubAreaId)
         {
            _currentSubAreaId = PlayedCharacterManager.getInstance().currentSubArea.id;
         }
         super.onPropertyChanged(param1);
         if(param1.propertyName == "cellSelectionOnly")
         {
            untargetableEntities = param1.propertyValue || Kernel.getWorker().getFrame(FightPreparationFrame);
         }
         else if(param1.propertyName == "orderFighters")
         {
            if(!param1.propertyValue)
            {
               for(_loc2_ in this._entitiesNumber)
               {
                  if(this._entitiesNumber[Number(_loc2_)])
                  {
                     this._entitiesNumber[Number(_loc2_)] = null;
                     _loc3_ = DofusEntities.getEntity(Number(_loc2_)) as AnimatedCharacter;
                     if(_loc3_)
                     {
                        _loc3_.removeBackground("fighterNumber");
                     }
                  }
               }
            }
            else
            {
               _loc4_ = 1;
               _loc5_ = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame;
               if(_loc5_)
               {
                  for each(_loc6_ in _loc5_.fightersList)
                  {
                     if((getEntityInfos(_loc6_) as GameFightFighterInformations).alive)
                     {
                        this.updateEntityNumber(_loc6_,_loc4_);
                        _loc4_++;
                     }
                  }
               }
            }
         }
         else if(param1.propertyName == "showMountsInFight")
         {
            this.switchMountsVisibility(param1.propertyValue);
         }
      }
      
      public function set cellSelectionOnly(param1:Boolean) : void
      {
         var _loc2_:GameContextActorInformations = null;
         var _loc3_:AnimatedCharacter = null;
         for each(_loc2_ in _entities)
         {
            _loc3_ = DofusEntities.getEntity(_loc2_.contextualId) as AnimatedCharacter;
            if(_loc3_)
            {
               _loc3_.mouseEnabled = !param1;
            }
         }
      }
      
      public function get dematerialization() : Boolean
      {
         return _creaturesFightMode;
      }
      
      public function get lastKnownPlayerStatus() : Dictionary
      {
         return this._lastKnownPlayerStatus;
      }
      
      public function getRealFighterLook(param1:Number) : EntityLook
      {
         return this._realFightersLooks[param1];
      }
      
      public function setRealFighterLook(param1:Number, param2:EntityLook) : void
      {
         this._realFightersLooks[param1] = param2;
      }
      
      public function get charactersMountsVisible() : Boolean
      {
         return this._mountsVisible;
      }
      
      override protected function updateActorDisposition(param1:Number, param2:EntityDispositionInformations) : void
      {
         var _loc3_:IEntity = null;
         super.updateActorDisposition(param1,param2);
         if(param2.cellId == -1)
         {
            _loc3_ = DofusEntities.getEntity(param1);
            if(_loc3_)
            {
               FightEntitiesHolder.getInstance().holdEntity(_loc3_);
            }
         }
         else
         {
            FightEntitiesHolder.getInstance().unholdEntity(param1);
         }
      }
      
      private function getTmpFighterInfoIndex(param1:Number) : Number
      {
         var _loc2_:TmpFighterInfos = null;
         for each(_loc2_ in this._tempFighterList)
         {
            if(_loc2_.contextualId == param1)
            {
               return this._tempFighterList.indexOf(_loc2_);
            }
         }
         return -1;
      }
   }
}

class TmpFighterInfos
{
    
   
   public var contextualId:Number;
   
   public var carryingCharacterId:Number;
   
   function TmpFighterInfos(param1:Number, param2:Number)
   {
      super();
      this.contextualId = param1;
      this.carryingCharacterId = param2;
   }
}
