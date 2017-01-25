package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.fight.fightEvents.FightEventsHelper;
   import com.ankamagames.dofus.logic.game.fight.frames.FightBattleFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightContextFrame;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.sequencer.CallbackStep;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.jerakine.types.events.SequencerEvent;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class FightDeathStep extends AbstractSequencable implements IFightStep
   {
       
      
      private var _entityId:Number;
      
      private var _deathSubSequence:ISequencer;
      
      private var _naturalDeath:Boolean;
      
      private var _targetName:String;
      
      private var _needToWarn:Boolean = true;
      
      private var _timeOut:Boolean = false;
      
      public function FightDeathStep(param1:Number, param2:Boolean = true)
      {
         super();
         this._entityId = param1;
         this._naturalDeath = param2;
         var _loc3_:FightContextFrame = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
         if(_loc3_)
         {
            this._targetName = _loc3_.getFighterName(param1);
         }
         else
         {
            this._targetName = "???";
         }
      }
      
      public function get stepType() : String
      {
         return "death";
      }
      
      public function get entityId() : Number
      {
         return this._entityId;
      }
      
      override public function start() : void
      {
         var _loc1_:IEntity = DofusEntities.getEntity(this._entityId);
         if(!_loc1_)
         {
            _log.warn("Unable to play death of an unexisting fighter " + this._entityId + ".");
            this._needToWarn = true;
            this.deathFinished();
            return;
         }
         var _loc2_:GameFightFighterInformations = FightEntitiesFrame.getCurrentInstance().getEntityInfos(this._entityId) as GameFightFighterInformations;
         var _loc3_:FightBattleFrame = Kernel.getWorker().getFrame(FightBattleFrame) as FightBattleFrame;
         if(_loc3_)
         {
            _loc3_.deadFightersList.push(this._entityId);
         }
         this._needToWarn = true;
         BuffManager.getInstance().dispell(_loc1_.id,false,false,true);
         var _loc4_:Array = BuffManager.getInstance().removeLinkedBuff(_loc1_.id,false,true);
         BuffManager.getInstance().reaffectBuffs(_loc1_.id);
         _loc2_.stats.lifePoints = 0;
         if(PlayedCharacterManager.getInstance().id == this._entityId)
         {
            PlayedCharacterManager.getInstance().characteristics.lifePoints = 0;
         }
         this._deathSubSequence = new SerialSequencer(FightBattleFrame.FIGHT_SEQUENCER_NAME);
         if(_loc1_ is TiphonSprite)
         {
            if(_loc3_ && _loc3_.deathPlayingNumber > 1)
            {
               this._deathSubSequence.addStep(new AddGfxEntityStep(3182,_loc2_.disposition.cellId));
            }
            else
            {
               this._deathSubSequence.addStep(new PlayAnimationStep(_loc1_ as TiphonSprite,AnimationEnum.ANIM_MORT,true,false));
            }
            this._deathSubSequence.addStep(new CallbackStep(new Callback(this.onAnimEnd,_loc1_)));
         }
         this._deathSubSequence.addStep(new CallbackStep(new Callback(this.manualRollOut,this._entityId)));
         var _loc5_:TiphonSprite = _loc1_ as TiphonSprite;
         if(!_loc5_ || !_loc5_.parentSprite || _loc5_.parentSprite.carriedEntity != _loc5_)
         {
            this._deathSubSequence.addStep(new FightDestroyEntityStep(_loc1_,true));
         }
         this._deathSubSequence.addEventListener(SequencerEvent.SEQUENCE_TIMEOUT,this.deathTimeOut);
         this._deathSubSequence.addEventListener(SequencerEvent.SEQUENCE_END,this.deathFinished);
         this._deathSubSequence.start();
      }
      
      override public function clear() : void
      {
         if(this._deathSubSequence)
         {
            this._deathSubSequence.clear();
         }
         super.clear();
      }
      
      private function manualRollOut(param1:Number) : void
      {
         var _loc2_:FightContextFrame = null;
         if(FightContextFrame.fighterEntityTooltipId == param1)
         {
            _loc2_ = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
            if(_loc2_)
            {
               _loc2_.outEntity(param1);
            }
         }
      }
      
      private function onAnimEnd(param1:TiphonSprite) : void
      {
         var _loc2_:TiphonSprite = param1.getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER,0) as TiphonSprite;
         if(_loc2_)
         {
            param1 = _loc2_;
         }
         var _loc3_:DisplayObjectContainer = param1.getSubEntitySlot(FightCarryCharacterStep.CARRIED_SUBENTITY_CATEGORY,FightCarryCharacterStep.CARRIED_SUBENTITY_INDEX);
         if(_loc3_)
         {
            param1.removeSubEntity(_loc3_);
         }
      }
      
      private function deathTimeOut(param1:Event = null) : void
      {
         if(this._deathSubSequence)
         {
            this._deathSubSequence.removeEventListener(SequencerEvent.SEQUENCE_TIMEOUT,this.deathTimeOut);
         }
         this._timeOut = true;
      }
      
      private function deathFinished(param1:Event = null) : void
      {
         if(this._deathSubSequence)
         {
            this._deathSubSequence.removeEventListener(SequencerEvent.SEQUENCE_END,this.deathFinished);
            this._deathSubSequence = null;
         }
         if(this._needToWarn)
         {
            if(this._naturalDeath)
            {
               FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_DEATH,[this._entityId,this._targetName],this._entityId,castingSpellId,this._timeOut);
            }
            else
            {
               FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_LEAVE,[this._entityId,this._targetName],this._entityId,castingSpellId,this._timeOut);
            }
         }
         executeCallbacks();
      }
   }
}
