package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.datacenter.items.Incarnation;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.logic.game.common.actions.roleplay.SwitchCreatureModeAction;
   import com.ankamagames.dofus.logic.game.common.managers.EntitiesLooksManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.types.EntityIcon;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.misc.utils.LookCleaner;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightMonsterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayHumanoidInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.look.SubEntity;
   import com.ankamagames.dofus.types.entities.AnimStatiqueSubEntityBehavior;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.BreedSkinModifier;
   import com.ankamagames.dofus.types.entities.CustomBreedAnimationModifier;
   import com.ankamagames.dofus.types.entities.RiderBehavior;
   import com.ankamagames.dofus.types.entities.UnderWaterAnimationModifier;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.types.enums.EntityIconEnum;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.enum.OptionEnum;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.errors.AbstractMethodCallError;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.ISkinModifier;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   public class AbstractEntitiesFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AbstractEntitiesFrame));
      
      protected static const ICONS_FILEPATH_CONQUEST:String = XmlConfig.getInstance().getEntry("config.content.path") + "gfx/icons/conquestIcon.swf|";
      
      protected static const ICONS_FILEPATH_STATE:String = XmlConfig.getInstance().getEntry("config.content.path") + "gfx/icons/stateBuffs.swf|";
       
      
      protected var _entities:Dictionary;
      
      protected var _creaturesMode:Boolean = false;
      
      protected var _creaturesLimit:int = -1;
      
      protected var _entitiesVisibleNumber:uint = 0;
      
      protected var _playerIsOnRide:Boolean = false;
      
      protected var _customBreedAnimationModifier:IAnimationModifier;
      
      protected var _underWaterAnimationModifier:IAnimationModifier;
      
      protected var _skinModifier:ISkinModifier;
      
      protected var _untargetableEntities:Boolean = false;
      
      protected var _interactiveElements:Vector.<InteractiveElement>;
      
      protected var _currentSubAreaId:uint;
      
      protected var _worldPoint:WorldPointWrapper;
      
      protected var _creaturesFightMode:Boolean = false;
      
      protected var _justSwitchingCreaturesFightMode:Boolean = false;
      
      protected var _entitiesIconsCounts:Dictionary;
      
      protected var _entitiesIconsNames:Dictionary;
      
      protected var _entitiesIcons:Dictionary;
      
      protected var _updateAllIcons:Boolean;
      
      public function AbstractEntitiesFrame()
      {
         this._customBreedAnimationModifier = new CustomBreedAnimationModifier();
         this._underWaterAnimationModifier = new UnderWaterAnimationModifier();
         this._skinModifier = new BreedSkinModifier();
         this._entitiesIconsCounts = new Dictionary();
         this._entitiesIconsNames = new Dictionary();
         this._entitiesIcons = new Dictionary();
         super();
      }
      
      public function get playerIsOnRide() : Boolean
      {
         return this._playerIsOnRide;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function set untargetableEntities(param1:Boolean) : void
      {
         var _loc2_:GameContextActorInformations = null;
         var _loc3_:AnimatedCharacter = null;
         this._untargetableEntities = param1;
         for each(_loc2_ in this._entities)
         {
            _loc3_ = DofusEntities.getEntity(_loc2_.contextualId) as AnimatedCharacter;
            if(_loc3_)
            {
               _loc3_.mouseEnabled = !param1;
            }
         }
      }
      
      public function get untargetableEntities() : Boolean
      {
         return this._untargetableEntities;
      }
      
      public function get interactiveElements() : Vector.<InteractiveElement>
      {
         return this._interactiveElements;
      }
      
      public function get justSwitchingCreaturesFightMode() : Boolean
      {
         return this._justSwitchingCreaturesFightMode;
      }
      
      public function get creaturesLimit() : int
      {
         return this._creaturesLimit;
      }
      
      public function get entitiesNumber() : int
      {
         return this._entitiesVisibleNumber;
      }
      
      public function get creaturesMode() : Boolean
      {
         return this._creaturesMode;
      }
      
      public function pushed() : Boolean
      {
         this._entities = new Dictionary();
         OptionManager.getOptionManager("atouin").addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onAtouinOptionChange);
         EntitiesLooksManager.getInstance().entitiesFrame = this;
         return true;
      }
      
      public function process(param1:Message) : Boolean
      {
         throw new AbstractMethodCallError();
      }
      
      public function pulled() : Boolean
      {
         EnterFrameDispatcher.removeEventListener(this.showIcons);
         this.removeAllIcons();
         this._entities = null;
         Atouin.getInstance().clearEntities();
         OptionManager.getOptionManager("atouin").removeEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onAtouinOptionChange);
         return true;
      }
      
      public function getEntityInfos(param1:Number) : GameContextActorInformations
      {
         if(param1 == 0)
         {
            _log.error("No entity 0, 0 is not a valid id.");
            return null;
         }
         if(!this._entities)
         {
            _log.error("Entity " + param1 + " is unknown. No entity has been registered so far.");
            return null;
         }
         if(!this._entities[param1])
         {
            _log.error("Entity " + param1 + " is unknown.");
            return null;
         }
         return this._entities[param1];
      }
      
      public function getEntitiesIdsList() : Vector.<Number>
      {
         var _loc2_:GameContextActorInformations = null;
         var _loc1_:Vector.<Number> = new Vector.<Number>(0,false);
         for each(_loc2_ in this._entities)
         {
            _loc1_.push(_loc2_.contextualId);
         }
         return _loc1_;
      }
      
      public function getEntitiesDictionnary() : Dictionary
      {
         return this._entities;
      }
      
      public function registerActor(param1:GameContextActorInformations) : void
      {
         if(this._entities == null)
         {
            this._entities = new Dictionary();
         }
         this._entities[param1.contextualId] = param1;
      }
      
      public function addOrUpdateActor(param1:GameContextActorInformations, param2:IAnimationModifier = null) : AnimatedCharacter
      {
         var _loc5_:TiphonEntityLook = null;
         var _loc6_:TiphonEntityLook = null;
         var _loc10_:Boolean = false;
         var _loc11_:EntityLook = null;
         var _loc12_:EntityLook = null;
         var _loc13_:GameRolePlayHumanoidInformations = null;
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1.contextualId) as AnimatedCharacter;
         var _loc4_:Boolean = true;
         var _loc7_:Boolean = this._creaturesMode && param1 is GameRolePlayMerchantInformations;
         var _loc8_:Boolean = param1.contextualId == PlayedCharacterManager.getInstance().id && (this._creaturesMode || this._creaturesFightMode);
         var _loc9_:MapPosition = MapPosition.getMapPositionById(PlayedCharacterManager.getInstance().currentMap.mapId);
         if(_loc9_ && _loc9_.isUnderWater)
         {
            this.addUnderwaterBubblesToEntityLook(param1.look);
         }
         if(!_loc3_ || _loc7_ || _loc8_)
         {
            _loc5_ = EntitiesLooksManager.getInstance().getLookFromContextInfos(param1);
         }
         if(_loc8_)
         {
            _loc11_ = EntityLookAdapter.toNetwork(_loc5_);
            if(PlayedCharacterManager.getInstance().infos.entityLook.bonesId != _loc11_.bonesId)
            {
               PlayedCharacterManager.getInstance().realEntityLook = PlayedCharacterManager.getInstance().infos.entityLook;
            }
         }
         if(_loc3_ == null)
         {
            _loc3_ = new AnimatedCharacter(param1.contextualId,_loc5_);
            _loc3_.addEventListener(TiphonEvent.PLAYANIM_EVENT,this.onPlayAnim);
            if(OptionManager.getOptionManager("atouin").useLowDefSkin)
            {
               _loc3_.setAlternativeSkinIndex(0,true);
            }
            if(_loc5_.getBone() == 1)
            {
               if(param2)
               {
                  _loc3_.addAnimationModifier(param2);
               }
               else
               {
                  _loc3_.addAnimationModifier(this._customBreedAnimationModifier);
               }
               if(_loc9_ && _loc9_.isUnderWater)
               {
                  _loc3_.addAnimationModifier(this._underWaterAnimationModifier);
               }
            }
            _loc3_.skinModifier = this._skinModifier;
            if(param1 is GameFightMonsterInformations)
            {
               _loc3_.speedAdjust = Monster.getMonsterById(GameFightMonsterInformations(param1).creatureGenericId).speedAdjust;
            }
            if(param1.contextualId == PlayedCharacterManager.getInstance().id)
            {
               _loc12_ = EntityLookAdapter.toNetwork(_loc5_);
               if(!EntityLookAdapter.fromNetwork(PlayedCharacterManager.getInstance().infos.entityLook).equals(_loc5_))
               {
                  PlayedCharacterManager.getInstance().infos.entityLook = _loc12_;
                  KernelEventsManager.getInstance().processCallback(HookList.PlayedCharacterLookChange,_loc5_);
               }
            }
         }
         else
         {
            _loc4_ = false;
            if(_loc7_)
            {
               _loc3_.look.updateFrom(_loc5_);
            }
            else
            {
               this.updateActorLook(param1.contextualId,param1.look,true);
            }
         }
         if(param1 is GameRolePlayHumanoidInformations)
         {
            _loc13_ = param1 as GameRolePlayHumanoidInformations;
            if(param1.contextualId == PlayedCharacterManager.getInstance().id)
            {
               PlayedCharacterManager.getInstance().restrictions = _loc13_.humanoidInfo.restrictions;
            }
         }
         if(!this._creaturesFightMode && !this._creaturesMode && _loc3_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER) && _loc3_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER).length)
         {
            _loc3_.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,new RiderBehavior());
         }
         if(_loc3_.id == PlayedCharacterManager.getInstance().id)
         {
            if(_loc3_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER) && _loc3_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER).length)
            {
               this._playerIsOnRide = true;
            }
            else
            {
               this._playerIsOnRide = false;
            }
         }
         if(!this._creaturesFightMode && !this._creaturesMode && _loc3_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET) && _loc3_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET).length)
         {
            _loc3_.setSubEntityBehaviour(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET,new AnimStatiqueSubEntityBehavior());
         }
         if(!_loc3_.slideOnNextMove && param1.disposition.cellId != -1 && !(_loc3_.parentSprite && _loc3_.parentSprite.carriedEntity == _loc3_))
         {
            if(!_loc3_.position || _loc3_.position.cellId != param1.disposition.cellId)
            {
               _loc10_ = true;
            }
            _loc3_.position = MapPoint.fromCellId(param1.disposition.cellId);
         }
         if((_loc4_ || !_loc3_.root || _loc10_) && !_loc3_.isMoving)
         {
            _loc3_.setDirection(param1.disposition.direction);
            _loc3_.display(PlacementStrataEnums.STRATA_PLAYER);
         }
         this.registerActor(param1);
         if(PlayedCharacterManager.getInstance().id == _loc3_.id)
         {
            SoundManager.getInstance().manager.setSoundSourcePosition(_loc3_.id,new Point(_loc3_.x,_loc3_.y));
         }
         _loc3_.visibleAura = !_loc3_.isMoving && OptionManager.getOptionManager("tiphon").auraMode >= OptionEnum.AURA_ALWAYS;
         _loc3_.mouseEnabled = !this.untargetableEntities;
         return _loc3_;
      }
      
      protected function updateActorLook(param1:Number, param2:EntityLook, param3:Boolean = false) : AnimatedCharacter
      {
         var _loc5_:TiphonEntityLook = null;
         var _loc6_:GameContextActorInformations = null;
         var _loc7_:int = 0;
         var _loc8_:SerialSequencer = null;
         var _loc9_:AddGfxEntityStep = null;
         var _loc10_:MapPosition = null;
         if(this._entities[param1])
         {
            _loc6_ = this._entities[param1] as GameContextActorInformations;
            _loc7_ = _loc6_.look.bonesId;
            _loc6_.look = param2;
            if(param3 && param2.bonesId != _loc7_)
            {
               _loc8_ = new SerialSequencer();
               _loc9_ = new AddGfxEntityStep(1165,DofusEntities.getEntity(param1).position.cellId);
               _loc8_.addStep(_loc9_);
               _loc8_.start();
            }
         }
         else
         {
            _log.warn("Cannot update unknown actor look (" + param1 + ") in informations.");
         }
         var _loc4_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         if(_loc4_)
         {
            _loc4_.addEventListener(TiphonEvent.RENDER_FAILED,this.onUpdateEntityFail,false,0,false);
            _loc4_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onUpdateEntitySuccess,false,0,false);
            _loc5_ = EntitiesLooksManager.getInstance().getLookFromContextInfos(this._entities[param1]);
            if(_loc5_.getBone() != 1)
            {
               _loc4_.removeAnimationModifier(this._customBreedAnimationModifier);
            }
            else
            {
               _loc4_.addAnimationModifier(this._customBreedAnimationModifier);
               _loc10_ = MapPosition.getMapPositionById(PlayedCharacterManager.getInstance().currentMap.mapId);
               if(_loc10_.isUnderWater)
               {
                  _loc4_.addAnimationModifier(this._underWaterAnimationModifier);
               }
            }
            _loc4_.enableSubCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,!this._creaturesFightMode);
            _loc4_.look.updateFrom(_loc5_);
            if(this._creaturesMode || this._creaturesFightMode)
            {
               if(_loc4_.isPlayingAnimation())
               {
                  _loc4_.dispatchEvent(new Event(TiphonEvent.ANIMATION_END));
               }
               _loc4_.setAnimation(AnimationEnum.ANIM_STATIQUE);
            }
            else
            {
               _loc4_.setAnimation(_loc4_.getAnimation());
            }
            if(_loc4_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET) && _loc4_.look.getSubEntitiesFromCategory(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_PET).length)
            {
               _loc4_.setSubEntityBehaviour(1,new AnimStatiqueSubEntityBehavior());
            }
         }
         else
         {
            _log.warn("Cannot update unknown actor look (" + param1 + ") in the game world.");
         }
         if(param1 == PlayedCharacterManager.getInstance().id && _loc5_)
         {
            if(this._creaturesMode || this._creaturesFightMode)
            {
               if(PlayedCharacterManager.getInstance().infos.entityLook.bonesId != param2.bonesId)
               {
                  PlayedCharacterManager.getInstance().realEntityLook = PlayedCharacterManager.getInstance().infos.entityLook;
               }
            }
            PlayedCharacterManager.getInstance().infos.entityLook = param2;
            KernelEventsManager.getInstance().processCallback(HookList.PlayedCharacterLookChange,LookCleaner.clean(_loc5_));
         }
         return _loc4_;
      }
      
      protected function updateActorDisposition(param1:Number, param2:EntityDispositionInformations) : void
      {
         if(this._entities[param1])
         {
            (this._entities[param1] as GameContextActorInformations).disposition = param2;
         }
         else
         {
            _log.warn("Cannot update unknown actor disposition (" + param1 + ") in informations.");
         }
         var _loc3_:IEntity = DofusEntities.getEntity(param1);
         if(_loc3_)
         {
            if(_loc3_ is IMovable && param2.cellId >= 0)
            {
               if(_loc3_ is TiphonSprite && (_loc3_ as TiphonSprite).rootEntity && (_loc3_ as TiphonSprite).rootEntity != _loc3_)
               {
                  _log.debug("PAS DE SYNCHRO pour " + (_loc3_ as TiphonSprite).name + " car entité portée");
               }
               else
               {
                  IMovable(_loc3_).jump(MapPoint.fromCellId(param2.cellId));
               }
            }
            if(_loc3_ is IAnimated)
            {
               IAnimated(_loc3_).setDirection(param2.direction);
            }
         }
         else
         {
            _log.warn("Cannot update unknown actor disposition (" + param1 + ") in the game world.");
         }
      }
      
      protected function updateActorOrientation(param1:Number, param2:uint) : void
      {
         var _loc4_:Boolean = false;
         if(this._entities[param1])
         {
            (this._entities[param1] as GameContextActorInformations).disposition.direction = param2;
         }
         else
         {
            _log.warn("Cannot update unknown actor orientation (" + param1 + ") in informations.");
         }
         var _loc3_:AnimatedCharacter = DofusEntities.getEntity(param1) as AnimatedCharacter;
         if(_loc3_)
         {
            _loc4_ = false;
            if(OptionManager.getOptionManager("tiphon").auraMode >= OptionEnum.AURA_ALWAYS && OptionManager.getOptionManager("tiphon").alwaysShowAuraOnFront && param2 == DirectionsEnum.DOWN)
            {
               _loc4_ = true;
            }
            _loc3_.visibleAura = _loc4_;
            _loc3_.setDirection(param2);
         }
         else
         {
            _log.warn("Cannot update unknown actor orientation (" + param1 + ") in the game world.");
         }
      }
      
      protected function hideActor(param1:Number) : void
      {
         var _loc2_:IDisplayable = DofusEntities.getEntity(param1) as IDisplayable;
         if(_loc2_)
         {
            _loc2_.remove();
         }
         else
         {
            _log.warn("Cannot remove an unknown actor (" + param1 + ").");
         }
      }
      
      protected function removeActor(param1:Number) : void
      {
         this.hideActor(param1);
         var _loc2_:TiphonSprite = DofusEntities.getEntity(param1) as TiphonSprite;
         if(_loc2_)
         {
            _loc2_.destroy();
         }
         this.updateCreaturesLimit();
         delete this._entities[param1];
         if(this.switchPokemonMode())
         {
            _log.debug("switch pokemon/normal mode");
         }
      }
      
      protected function switchPokemonMode() : Boolean
      {
         var _loc1_:SwitchCreatureModeAction = null;
         this._entitiesVisibleNumber = EntitiesManager.getInstance().entitiesCount;
         if(this._creaturesLimit > -1 && this._creaturesMode != (!Kernel.getWorker().getFrame(FightEntitiesFrame) && this._creaturesLimit < 50 && this._entitiesVisibleNumber >= this._creaturesLimit))
         {
            _loc1_ = SwitchCreatureModeAction.create(!this._creaturesMode);
            Kernel.getWorker().process(_loc1_);
            return true;
         }
         return false;
      }
      
      protected function updateCreaturesLimit() : void
      {
         var _loc1_:Number = NaN;
         this._creaturesLimit = OptionManager.getOptionManager("tiphon").creaturesMode;
         if(this._creaturesMode && this._creaturesLimit > 0)
         {
            _loc1_ = this._creaturesLimit * 20 / 100;
            this._creaturesLimit = Math.ceil(this._creaturesLimit - _loc1_);
         }
      }
      
      public function addEntityIcon(param1:Number, param2:String, param3:int = 0) : void
      {
         if(!this._entitiesIconsNames[param1])
         {
            this._entitiesIconsNames[param1] = new Dictionary();
            this._entitiesIconsCounts[param1] = new Dictionary();
         }
         if(!this._entitiesIconsNames[param1][param3])
         {
            this._entitiesIconsNames[param1][param3] = new Vector.<String>(0);
         }
         if(this._entitiesIconsNames[param1][param3].indexOf(param2) == -1)
         {
            this._entitiesIconsNames[param1][param3].push(param2);
         }
         if(!this._entitiesIconsCounts[param1][param2])
         {
            this._entitiesIconsCounts[param1][param2] = 1;
         }
         else
         {
            this._entitiesIconsCounts[param1][param2]++;
         }
         if(this._entitiesIcons[param1])
         {
            this._entitiesIcons[param1].needUpdate = true;
         }
         EnterFrameDispatcher.addEventListener(this.showIcons,"showIcons",250);
      }
      
      public function updateAllIcons() : void
      {
         this._updateAllIcons = true;
         this.showIcons();
      }
      
      public function forceIconUpdate(param1:Number) : void
      {
         if(this._entitiesIcons[param1])
         {
            this._entitiesIcons[param1].needUpdate = true;
         }
      }
      
      protected function removeAllIcons() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Array = new Array();
         for(_loc1_ in this._entitiesIconsNames)
         {
            _loc2_.push(_loc1_);
         }
         for each(_loc1_ in _loc2_)
         {
            this.removeIcon(_loc1_,null,true);
         }
         EnterFrameDispatcher.removeEventListener(this.showIcons);
      }
      
      public function removeIcon(param1:Number, param2:String = null, param3:Boolean = false) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:AnimatedCharacter = null;
         if(param2 && this._entitiesIconsCounts[param1] && this._entitiesIconsCounts[param1][param2] && this._entitiesIconsCounts[param1][param2] > 1)
         {
            this._entitiesIconsCounts[param1][param2]--;
            if(!param3)
            {
               return;
            }
         }
         if(!this._entitiesIconsCounts[param1] || param2 && !this._entitiesIconsCounts[param1][param2])
         {
            return;
         }
         if(this._entitiesIconsCounts[param1])
         {
            if(!param2)
            {
               delete this._entitiesIconsCounts[param1];
               delete this._entitiesIconsNames[param1];
               if(this._entitiesIcons[param1])
               {
                  this._entitiesIcons[param1].remove();
               }
               delete this._entitiesIcons[param1];
            }
            else
            {
               this._entitiesIconsCounts[param1][param2] = 0;
               for(_loc8_ in this._entitiesIconsNames[param1])
               {
                  if(this._entitiesIconsNames[param1][_loc8_] && this._entitiesIconsNames[param1][_loc8_].length > 0)
                  {
                     _loc10_ = 0;
                     while(_loc10_ < this._entitiesIconsNames[param1][_loc8_].length)
                     {
                        if(this._entitiesIconsNames[param1][_loc8_][_loc10_] == param2)
                        {
                           _loc9_ = _loc10_;
                        }
                        _loc10_++;
                     }
                     this._entitiesIconsNames[param1][_loc8_].splice(_loc9_,1);
                  }
               }
               if(this._entitiesIcons[param1])
               {
                  this._entitiesIcons[param1].removeIcon(param2);
               }
            }
         }
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         for(_loc6_ in this._entitiesIconsCounts)
         {
            _loc4_++;
            if(_loc6_ == param1)
            {
               for(_loc7_ in this._entitiesIconsCounts[_loc6_])
               {
                  _loc5_++;
               }
            }
         }
         if(_loc5_ == 0)
         {
            _loc11_ = DofusEntities.getEntity(param1) as AnimatedCharacter;
            if(_loc11_)
            {
               _loc11_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.updateIconAfterRender);
            }
            delete this._entitiesIconsCounts[param1];
            delete this._entitiesIconsNames[param1];
            delete this._entitiesIcons[param1];
         }
         if(_loc4_ == 0)
         {
            EnterFrameDispatcher.removeEventListener(this.showIcons);
         }
      }
      
      public function getIconNamesByCategory(param1:Number, param2:int) : Vector.<String>
      {
         var _loc3_:Vector.<String> = null;
         if(this._entitiesIconsNames[param1] && this._entitiesIconsNames[param1][param2])
         {
            _loc3_ = this._entitiesIconsNames[param1][param2];
         }
         return _loc3_;
      }
      
      public function removeIconsCategory(param1:Number, param2:int) : void
      {
         var _loc3_:String = null;
         var _loc4_:AnimatedCharacter = null;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         if(this._entitiesIconsNames[param1] && this._entitiesIconsNames[param1][param2])
         {
            if(this._entitiesIcons[param1])
            {
               for each(_loc3_ in this._entitiesIconsNames[param1][param2])
               {
                  this._entitiesIcons[param1].removeIcon(_loc3_);
                  this._entitiesIconsCounts[param1][_loc3_]--;
               }
            }
            delete this._entitiesIconsNames[param1][param2];
            if(this._entitiesIcons[param1] && this._entitiesIcons[param1].length == 0)
            {
               delete this._entitiesIconsNames[param1];
               delete this._entitiesIconsCounts[param1];
               this.removeIcon(param1,null,true);
               _loc4_ = DofusEntities.getEntity(param1) as AnimatedCharacter;
               if(_loc4_)
               {
                  _loc4_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.updateIconAfterRender);
               }
               _loc5_ = 0;
               for(_loc6_ in this._entitiesIcons)
               {
                  _loc5_++;
               }
               if(_loc5_ == 0)
               {
                  EnterFrameDispatcher.removeEventListener(this.showIcons);
               }
            }
         }
      }
      
      public function hasIcon(param1:Number, param2:String = null) : Boolean
      {
         var _loc3_:Boolean = false;
         if(this._entitiesIcons[param1])
         {
            if(param2)
            {
               _loc3_ = this._entitiesIcons[param1].hasIcon(param2);
            }
            else
            {
               _loc3_ = true;
            }
         }
         return _loc3_;
      }
      
      public function getIcon(param1:Number) : EntityIcon
      {
         return this._entitiesIcons[param1];
      }
      
      public function getIconEntityBounds(param1:AnimatedCharacter) : IRectangle
      {
         var _loc2_:IRectangle = null;
         var _loc3_:TiphonSprite = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:Rectangle = null;
         var _loc6_:Rectangle2 = null;
         var _loc8_:TiphonSprite = null;
         var _loc10_:DisplayObject = null;
         var _loc7_:TiphonSprite = param1;
         var _loc9_:TiphonSprite = param1.carriedEntity;
         while(_loc9_)
         {
            _loc8_ = _loc9_;
            _loc9_ = _loc9_.carriedEntity;
         }
         _loc7_ = !_loc8_?_loc7_:_loc8_;
         _loc3_ = _loc7_ as TiphonSprite;
         if(_loc7_.getSubEntitySlot(2,0) && !this._creaturesMode)
         {
            _loc3_ = _loc7_.getSubEntitySlot(2,0) as TiphonSprite;
         }
         _loc4_ = _loc3_.getSlot("Tete");
         if(_loc4_)
         {
            _loc5_ = _loc4_.getBounds(StageShareManager.stage);
            _loc6_ = new Rectangle2(_loc5_.x,_loc5_.y,_loc5_.width,_loc5_.height);
            _loc2_ = _loc6_;
            if(_loc2_.y - 30 - 10 < 0)
            {
               _loc10_ = _loc3_.getSlot("Pied");
               if(_loc10_)
               {
                  _loc5_ = _loc10_.getBounds(StageShareManager.stage);
                  _loc6_ = new Rectangle2(_loc5_.x,_loc5_.y + _loc2_.height + 30,_loc5_.width,_loc5_.height);
                  _loc2_ = _loc6_;
               }
            }
         }
         else
         {
            if(_loc3_ is IDisplayable)
            {
               _loc2_ = (_loc3_ as IDisplayable).absoluteBounds;
            }
            else
            {
               _loc5_ = _loc3_.getBounds(StageShareManager.stage);
               _loc6_ = new Rectangle2(_loc5_.x,_loc5_.y,_loc5_.width,_loc5_.height);
               _loc2_ = _loc6_;
            }
            if(_loc2_.y - 30 - 10 < 0)
            {
               _loc2_.y = _loc2_.y + (_loc2_.height + 30);
            }
         }
         return _loc2_;
      }
      
      protected function showIcons(param1:Event = null) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:AnimatedCharacter = null;
         var _loc4_:IRectangle = null;
         var _loc5_:EntityIcon = null;
         var _loc6_:Texture = null;
         var _loc8_:* = undefined;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc7_:Array = new Array();
         for(_loc2_ in this._entitiesIconsNames)
         {
            _loc3_ = DofusEntities.getEntity(_loc2_) as AnimatedCharacter;
            if(!_loc3_)
            {
               _loc7_.push(_loc2_);
            }
            else
            {
               _loc4_ = null;
               if(this._updateAllIcons || _loc3_.getAnimation() && _loc3_.getAnimation().indexOf(AnimationEnum.ANIM_STATIQUE) == -1 || !this._entitiesIcons[_loc2_] || this._entitiesIcons[_loc2_].needUpdate)
               {
                  if(this._entitiesIcons[_loc2_] && this._entitiesIcons[_loc2_].rendering)
                  {
                     continue;
                  }
                  _loc4_ = this.getIconEntityBounds(_loc3_);
               }
               if(_loc4_)
               {
                  _loc5_ = this._entitiesIcons[_loc2_];
                  if(!_loc5_)
                  {
                     this._entitiesIcons[_loc2_] = new EntityIcon(_loc3_);
                     _loc5_ = this._entitiesIcons[_loc2_];
                  }
                  _loc10_ = false;
                  for(_loc8_ in this._entitiesIconsNames[_loc2_])
                  {
                     for each(_loc9_ in this._entitiesIconsNames[_loc2_][_loc8_])
                     {
                        if(!_loc5_.hasIcon(_loc9_))
                        {
                           _loc10_ = true;
                           if(_loc8_ == EntityIconEnum.FIGHT_STATE_CATEGORY)
                           {
                              _loc5_.addIcon(ICONS_FILEPATH_STATE + "" + _loc9_,_loc9_);
                           }
                           else
                           {
                              _loc5_.addIcon(ICONS_FILEPATH_CONQUEST + "" + _loc9_,_loc9_);
                           }
                        }
                     }
                  }
                  if(!_loc10_)
                  {
                     if(this._entitiesIcons[_loc2_].needUpdate && !_loc3_.isMoving && _loc3_.getAnimation().indexOf(AnimationEnum.ANIM_STATIQUE) == 0)
                     {
                        this._entitiesIcons[_loc2_].needUpdate = false;
                     }
                     _loc11_ = _loc3_.parentSprite && _loc3_.parentSprite.carriedEntity == _loc3_;
                     if(!_loc3_ || !_loc3_.parent || !_loc3_.displayed || _loc11_)
                     {
                        if(_loc5_.parent)
                        {
                           _loc5_.parent.removeChild(_loc5_);
                        }
                     }
                     else
                     {
                        _loc3_.parent.addChildAt(_loc5_,_loc3_.parent.getChildIndex(_loc3_));
                        if(_loc3_.rendered)
                        {
                           _loc5_.place(_loc4_);
                        }
                        else
                        {
                           _loc5_.rendering = true;
                           _loc3_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.updateIconAfterRender);
                           _loc3_.addEventListener(TiphonEvent.RENDER_SUCCEED,this.updateIconAfterRender);
                        }
                     }
                  }
               }
            }
         }
         for each(_loc2_ in _loc7_)
         {
            if(this._entitiesIcons[_loc2_])
            {
               this.removeIcon(_loc2_,null,true);
            }
         }
         this._updateAllIcons = false;
      }
      
      protected function updateIconAfterRender(param1:TiphonEvent) : void
      {
         var _loc2_:AnimatedCharacter = param1.currentTarget as AnimatedCharacter;
         _loc2_.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.updateIconAfterRender);
         if(this._entitiesIcons[_loc2_.id])
         {
            this._entitiesIcons[_loc2_.id].rendering = false;
            this._entitiesIcons[_loc2_.id].needUpdate = true;
         }
      }
      
      public function onPlayAnim(param1:TiphonEvent) : void
      {
         var _loc2_:Array = new Array();
         var _loc3_:String = param1.params.substring(6,param1.params.length - 1);
         _loc2_ = _loc3_.split(",");
         param1.sprite.setAnimation(_loc2_[int(_loc2_.length * Math.random())]);
      }
      
      private function onAtouinOptionChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:Array = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1.propertyName == "useLowDefSkin")
         {
            _loc2_ = EntitiesManager.getInstance().entities;
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_ is TiphonSprite)
               {
                  TiphonSprite(_loc3_).setAlternativeSkinIndex(!!param1.propertyValue?0:-1,true);
               }
            }
         }
         if(param1.propertyName == "transparentOverlayMode")
         {
            for(_loc4_ in this._entitiesIconsNames)
            {
               this.forceIconUpdate(_loc4_);
            }
         }
      }
      
      public function isInCreaturesFightMode() : Boolean
      {
         return this._creaturesFightMode;
      }
      
      private function onUpdateEntitySuccess(param1:TiphonEvent) : void
      {
         param1.sprite.removeEventListener(TiphonEvent.RENDER_FAILED,this.onUpdateEntityFail);
         param1.sprite.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onUpdateEntitySuccess);
      }
      
      private function onUpdateEntityFail(param1:TiphonEvent) : void
      {
         param1.sprite.removeEventListener(TiphonEvent.RENDER_FAILED,this.onUpdateEntityFail);
         param1.sprite.removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onUpdateEntitySuccess);
         TiphonSprite(param1.sprite).setAnimation("AnimStatique");
      }
      
      private function isIncarnation(param1:String) : Boolean
      {
         var _loc3_:Incarnation = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:Array = Incarnation.getAllIncarnation();
         var _loc4_:String = param1.slice(1,param1.indexOf("|"));
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = _loc3_.lookMale.slice(1,_loc3_.lookMale.indexOf("|"));
            _loc6_ = _loc3_.lookFemale.slice(1,_loc3_.lookFemale.indexOf("|"));
            if(_loc4_ == _loc5_ || _loc4_ == _loc6_)
            {
               return true;
            }
         }
         return false;
      }
      
      private function addUnderwaterBubblesToEntityLook(param1:EntityLook) : void
      {
         var _loc2_:SubEntity = new SubEntity();
         _loc2_.bindingPointCategory = 8;
         _loc2_.bindingPointIndex = 0;
         _loc2_.subEntityLook.bonesId = 3580;
         param1.subentities.push(_loc2_);
      }
      
      protected function onPropertyChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.propertyName == "mapCoordinates")
         {
            KernelEventsManager.getInstance().processCallback(HookList.MapComplementaryInformationsData,this._worldPoint,this._currentSubAreaId,param1.propertyValue);
         }
      }
   }
}
