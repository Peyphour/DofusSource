package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.types.sequences.AddWorldEntityStep;
   import com.ankamagames.atouin.types.sequences.ParableGfxMovementStep;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightSpellCastFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightTurnFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.CurrentPlayedFighterManager;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.miscs.CarrierAnimationModifier;
   import com.ankamagames.dofus.logic.game.fight.miscs.FightEntitiesHolder;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.Glyph;
   import com.ankamagames.dofus.types.entities.Projectile;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.types.enums.PortalAnimationEnum;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.events.SequencerEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.SetAnimationStep;
   import com.ankamagames.tiphon.sequence.SetDirectionStep;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class FightThrowCharacterStep extends AbstractSequencable implements IFightStep
   {
      
      private static const THROWING_PROJECTILE_FX:uint = 21209;
       
      
      private var _fighterId:Number;
      
      private var _carriedId:Number;
      
      private var _cellId:int;
      
      private var _throwSubSequence:ISequencer;
      
      private var _isCreature:Boolean;
      
      public var portals:Vector.<MapPoint>;
      
      public var portalIds:Vector.<int>;
      
      public function FightThrowCharacterStep(param1:Number, param2:Number, param3:int)
      {
         super();
         this._fighterId = param1;
         this._carriedId = param2;
         this._cellId = param3;
         this._isCreature = (Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame).isInCreaturesFightMode();
      }
      
      public function get stepType() : String
      {
         return "throwCharacter";
      }
      
      override public function start() : void
      {
         var _loc11_:GameFightFighterInformations = null;
         var _loc12_:FightTurnFrame = null;
         var _loc13_:MapPoint = null;
         var _loc14_:MapPoint = null;
         var _loc15_:Projectile = null;
         var _loc1_:DisplayObject = DofusEntities.getEntity(this._fighterId) as DisplayObject;
         var _loc2_:IEntity = _loc1_ as IEntity;
         _loc1_ = TiphonUtility.getEntityWithoutMount(_loc1_ as TiphonSprite);
         var _loc3_:IEntity = DofusEntities.getEntity(this._carriedId);
         var _loc4_:FightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         var _loc5_:GameFightFighterInformations = _loc4_.getEntityInfos(this._carriedId) as GameFightFighterInformations;
         if(!_loc3_ || !_loc5_.alive)
         {
            _log.error("Attention, l\'entité [" + this._fighterId + "] ne porte pas [" + this._carriedId + "]");
            this._throwSubSequence = new SerialSequencer(FightBattleFrame.FIGHT_SEQUENCER_NAME);
            if(_loc3_)
            {
               this._throwSubSequence.addStep(new FightDestroyEntityStep(_loc3_,true,true));
            }
            if(_loc1_ && _loc1_ is TiphonSprite)
            {
               (_loc1_ as TiphonSprite).removeAnimationModifierByClass(CarrierAnimationModifier);
            }
            if(_loc1_ && _loc1_ is TiphonSprite)
            {
               this._throwSubSequence.addStep(new SetAnimationStep(_loc1_ as TiphonSprite,AnimationEnum.ANIM_STATIQUE));
            }
            this.startSubSequence();
            this.throwFinished();
            return;
         }
         if(!_loc1_)
         {
            _log.error("Attention, l\'entité [" + this._fighterId + "] ne porte pas [" + this._carriedId + "]");
            (_loc3_ as IDisplayable).display(PlacementStrataEnums.STRATA_PLAYER);
            if(_loc3_ is TiphonSprite)
            {
               (_loc3_ as TiphonSprite).setAnimation(AnimationEnum.ANIM_STATIQUE);
            }
            this.throwFinished();
            return;
         }
         if(this._cellId != -1)
         {
            _loc11_ = FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._carriedId) as GameFightFighterInformations;
            _loc11_.disposition.cellId = this._cellId;
         }
         if(this._carriedId == CurrentPlayedFighterManager.getInstance().currentFighterId)
         {
            _loc12_ = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
            if(_loc12_)
            {
               _loc12_.freePlayer();
            }
         }
         var _loc6_:Boolean = false;
         if(TiphonSprite(_loc3_).look.getBone() == 761)
         {
            _loc6_ = true;
         }
         _log.debug(this._fighterId + " is throwing " + this._carriedId + " (invisibility : " + _loc6_ + ")");
         if(!_loc6_)
         {
            FightEntitiesHolder.getInstance().unholdEntity(this._carriedId);
         }
         if(_loc1_ && _loc1_ is TiphonSprite)
         {
            (_loc1_ as TiphonSprite).removeAnimationModifierByClass(CarrierAnimationModifier);
         }
         this._throwSubSequence = new SerialSequencer(FightBattleFrame.FIGHT_SEQUENCER_NAME);
         if(this._cellId == -1 || _loc6_)
         {
            this._throwSubSequence.addStep(new FightRemoveCarriedEntityStep(this._fighterId,this._carriedId,FightCarryCharacterStep.CARRIED_SUBENTITY_CATEGORY,FightCarryCharacterStep.CARRIED_SUBENTITY_INDEX));
            if(this._cellId == -1)
            {
               if(_loc1_ is TiphonSprite)
               {
                  this._throwSubSequence.addStep(new SetAnimationStep(_loc1_ as TiphonSprite,AnimationEnum.ANIM_STATIQUE));
               }
               this.startSubSequence();
               return;
            }
         }
         if(this.portals && this.portals.length > 1)
         {
            _loc13_ = this.portals[0];
            _loc14_ = this.portals[this.portals.length - 1];
         }
         var _loc7_:MapPoint = MapPoint.fromCellId(this._cellId);
         var _loc8_:MapPoint = _loc13_ != null?_loc13_:_loc7_;
         var _loc9_:int = _loc2_.position.distanceToCell(_loc8_);
         var _loc10_:int = _loc2_.position.advancedOrientationTo(_loc8_);
         if(!_loc6_)
         {
            _loc3_.position = _loc7_;
         }
         if(_loc1_ is TiphonSprite)
         {
            this._throwSubSequence.addStep(new SetDirectionStep((_loc1_ as TiphonSprite).rootEntity,_loc10_));
         }
         if(_loc9_ == 1)
         {
            _log.debug("Dropping nearby.");
            if(_loc1_ is TiphonSprite)
            {
               if(!this._isCreature)
               {
                  this._throwSubSequence.addStep(new PlayAnimationStep(_loc1_ as TiphonSprite,AnimationEnum.ANIM_DROP,_loc6_,true,TiphonEvent.ANIMATION_END,1,!!_loc6_?AnimationEnum.ANIM_STATIQUE:""));
                  if(_loc13_)
                  {
                     this.addCleanEntitiesSteps(_loc3_,_loc1_,false);
                     this.addPortalAnimationSteps();
                     _loc15_ = new Projectile(EntitiesManager.getInstance().getFreeEntityId(),TiphonEntityLook.fromString("{" + THROWING_PROJECTILE_FX + "}"));
                     _loc15_.position = _loc14_;
                     this._throwSubSequence.addStep(new AddWorldEntityStep(_loc15_));
                     this._throwSubSequence.addStep(new ParableGfxMovementStep(_loc15_,_loc7_,200,0.3,-70,true,1));
                     this._throwSubSequence.addStep(new FightDestroyEntityStep(_loc15_));
                  }
               }
               else
               {
                  this._throwSubSequence.addStep(new SetAnimationStep(_loc1_ as TiphonSprite,AnimationEnum.ANIM_STATIQUE));
               }
            }
         }
         else
         {
            _log.debug("Throwing away.");
            if(_loc1_ is TiphonSprite)
            {
               if(!this._isCreature)
               {
                  this._throwSubSequence.addStep(new PlayAnimationStep(_loc1_ as TiphonSprite,AnimationEnum.ANIM_THROW,_loc6_,true,TiphonEvent.ANIMATION_SHOT,1,!!_loc6_?AnimationEnum.ANIM_STATIQUE:""));
               }
               else
               {
                  (_loc3_ as TiphonSprite).visible = false;
               }
            }
            if(!_loc6_)
            {
               _loc15_ = new Projectile(EntitiesManager.getInstance().getFreeEntityId(),TiphonEntityLook.fromString("{" + THROWING_PROJECTILE_FX + "}"));
               _loc15_.position = _loc2_.position.getNearestCellInDirection(_loc10_);
               this._throwSubSequence.addStep(new AddWorldEntityStep(_loc15_));
               this._throwSubSequence.addStep(new ParableGfxMovementStep(_loc15_,_loc8_,200,0.3,-70,true,1));
               this._throwSubSequence.addStep(new FightDestroyEntityStep(_loc15_));
               if(_loc14_)
               {
                  this.addCleanEntitiesSteps(_loc3_,_loc1_,false);
                  this.addPortalAnimationSteps();
                  _loc15_ = new Projectile(EntitiesManager.getInstance().getFreeEntityId(),TiphonEntityLook.fromString("{" + THROWING_PROJECTILE_FX + "}"));
                  _loc15_.position = _loc14_;
                  this._throwSubSequence.addStep(new AddWorldEntityStep(_loc15_));
                  this._throwSubSequence.addStep(new ParableGfxMovementStep(_loc15_,_loc7_,200,0.3,-70,true,1));
                  this._throwSubSequence.addStep(new FightDestroyEntityStep(_loc15_));
               }
            }
         }
         if(_loc6_)
         {
            this.startSubSequence();
            return;
         }
         if(_loc13_)
         {
            this._throwSubSequence.addStep(new AddWorldEntityStep(_loc3_));
         }
         else
         {
            this.addCleanEntitiesSteps(_loc3_,_loc1_,true);
         }
         this.startSubSequence();
      }
      
      private function startSubSequence() : void
      {
         this._throwSubSequence.addEventListener(SequencerEvent.SEQUENCE_END,this.throwFinished);
         this._throwSubSequence.start();
      }
      
      private function throwFinished(param1:Event = null) : void
      {
         var _loc4_:TiphonSprite = null;
         var _loc7_:DisplayObject = null;
         if(this._throwSubSequence)
         {
            this._throwSubSequence.removeEventListener(SequencerEvent.SEQUENCE_END,this.throwFinished);
            this._throwSubSequence = null;
         }
         var _loc2_:DisplayObject = DofusEntities.getEntity(this._fighterId) as DisplayObject;
         if(_loc2_ is TiphonSprite)
         {
            _loc7_ = (_loc2_ as TiphonSprite).getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0);
            if(_loc7_)
            {
               (_loc2_ as TiphonSprite).removeAnimationModifierByClass(CarrierAnimationModifier);
               _loc2_ = _loc7_;
            }
         }
         var _loc3_:IEntity = DofusEntities.getEntity(this._carriedId);
         if(_loc2_ && _loc2_ is TiphonSprite)
         {
            (_loc2_ as TiphonSprite).removeAnimationModifierByClass(CarrierAnimationModifier);
            (_loc2_ as TiphonSprite).removeSubEntity(_loc3_ as DisplayObject);
         }
         if(_loc3_)
         {
            (_loc3_ as TiphonSprite).visible = true;
            if(_loc3_ is IMovable)
            {
               IMovable(_loc3_).movementBehavior.synchroniseSubEntitiesPosition(IMovable(_loc3_));
            }
         }
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_THROW,[this._fighterId,this._carriedId,this._cellId],0,castingSpellId);
         FightSpellCastFrame.updateRangeAndTarget();
         if(FightEntitiesFrame.getCurrentInstance().hasIcon(this._fighterId))
         {
            FightEntitiesFrame.getCurrentInstance().forceIconUpdate(this._fighterId);
         }
         var _loc5_:TiphonSprite = !!_loc3_?(_loc3_ as TiphonSprite).parentSprite:null;
         while(_loc5_)
         {
            _loc4_ = _loc5_;
            _loc5_ = _loc5_.parentSprite;
         }
         var _loc6_:Number = !!_loc4_?Number((_loc4_ as AnimatedCharacter).id):!!_loc3_?Number((_loc3_ as AnimatedCharacter).id):Number(NaN);
         if(!isNaN(_loc6_))
         {
            if(FightEntitiesFrame.getCurrentInstance().hasIcon(_loc6_))
            {
               FightEntitiesFrame.getCurrentInstance().forceIconUpdate(_loc6_);
            }
         }
         executeCallbacks();
      }
      
      private function addCleanEntitiesSteps(param1:IEntity, param2:DisplayObject, param3:Boolean) : void
      {
         this._throwSubSequence.addStep(new FightRemoveCarriedEntityStep(this._fighterId,this._carriedId,FightCarryCharacterStep.CARRIED_SUBENTITY_CATEGORY,FightCarryCharacterStep.CARRIED_SUBENTITY_INDEX));
         this._throwSubSequence.addStep(new SetDirectionStep(param1 as TiphonSprite,(param2 as TiphonSprite).rootEntity.getDirection()));
         if(param3)
         {
            this._throwSubSequence.addStep(new AddWorldEntityStep(param1));
         }
         this._throwSubSequence.addStep(new SetAnimationStep(param1 as TiphonSprite,AnimationEnum.ANIM_STATIQUE));
         if(param2 is TiphonSprite)
         {
            this._throwSubSequence.addStep(new SetAnimationStep(param2 as TiphonSprite,AnimationEnum.ANIM_STATIQUE));
         }
      }
      
      private function addPortalAnimationSteps() : void
      {
         var _loc1_:String = "";
         var _loc2_:Glyph = MarkedCellsManager.getInstance().getGlyph(this.portalIds[0]);
         if(_loc2_)
         {
            if(_loc2_.getAnimation() != PortalAnimationEnum.STATE_NORMAL)
            {
               _loc1_ = _loc2_.getAnimation();
               this._throwSubSequence.addStep(new PlayAnimationStep(_loc2_,PortalAnimationEnum.STATE_NORMAL,false,false));
            }
            else
            {
               _loc1_ = "";
            }
            this._throwSubSequence.addStep(new PlayAnimationStep(_loc2_,PortalAnimationEnum.STATE_ENTRY_SPELL,false,true,TiphonEvent.ANIMATION_SHOT));
            if(_loc1_ != "")
            {
               this._throwSubSequence.addStep(new PlayAnimationStep(_loc2_,_loc1_,false,false));
            }
         }
         var _loc3_:int = 1;
         while(_loc3_ < this.portalIds.length - 1)
         {
            _loc2_ = MarkedCellsManager.getInstance().getGlyph(this.portalIds[_loc3_]);
            if(_loc2_)
            {
               if(_loc2_.getAnimation() != PortalAnimationEnum.STATE_NORMAL)
               {
                  _loc1_ = _loc2_.getAnimation();
                  this._throwSubSequence.addStep(new PlayAnimationStep(_loc2_,PortalAnimationEnum.STATE_NORMAL,false,false));
               }
               else
               {
                  _loc1_ = "";
               }
               this._throwSubSequence.addStep(new PlayAnimationStep(_loc2_,PortalAnimationEnum.STATE_ENTRY_SPELL,false,true,TiphonEvent.ANIMATION_SHOT));
               if(_loc1_ != "")
               {
                  this._throwSubSequence.addStep(new PlayAnimationStep(_loc2_,_loc1_,false,false));
               }
            }
            _loc3_++;
         }
         _loc2_ = MarkedCellsManager.getInstance().getGlyph(this.portalIds[this.portalIds.length - 1]);
         if(_loc2_)
         {
            if(_loc2_.getAnimation() != PortalAnimationEnum.STATE_NORMAL)
            {
               _loc1_ = _loc2_.getAnimation();
               this._throwSubSequence.addStep(new PlayAnimationStep(_loc2_,PortalAnimationEnum.STATE_NORMAL,false,false));
            }
            else
            {
               _loc1_ = "";
            }
            this._throwSubSequence.addStep(new PlayAnimationStep(_loc2_,PortalAnimationEnum.STATE_EXIT_SPELL,false,false));
            if(_loc1_ != "")
            {
               this._throwSubSequence.addStep(new PlayAnimationStep(_loc2_,_loc1_,false,false));
            }
         }
      }
      
      override public function toString() : String
      {
         return "[FightThrowCharacterStep(carrier=" + this._fighterId + ", carried=" + this._carriedId + ", cell=" + this._cellId + ")]";
      }
   }
}
