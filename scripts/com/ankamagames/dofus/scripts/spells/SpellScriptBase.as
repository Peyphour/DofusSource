package com.ankamagames.dofus.scripts.spells
{
   import com.ankamagames.dofus.logic.game.fight.steps.FightLifeVariationStep;
   import com.ankamagames.dofus.logic.game.fight.steps.IFightStep;
   import com.ankamagames.dofus.logic.game.fight.types.CastingSpell;
   import com.ankamagames.dofus.scripts.SpellFxRunner;
   import com.ankamagames.dofus.scripts.api.FxApi;
   import com.ankamagames.dofus.scripts.api.SequenceApi;
   import com.ankamagames.dofus.scripts.api.SpellFxApi;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.types.entities.Glyph;
   import com.ankamagames.dofus.types.enums.PortalAnimationEnum;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.enum.AddGfxModeEnum;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.SetDirectionStep;
   import flash.utils.getQualifiedClassName;
   
   public class SpellScriptBase
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellScriptBase));
      
      protected static const PREFIX_CASTER:String = "caster";
      
      protected static const PREFIX_TARGET:String = "target";
      
      protected static const DEFAULT_CASTER_ANIMATION:int = 4;
       
      
      protected var latestStep:ISequencable;
      
      protected var runner:SpellFxRunner;
      
      protected var spell:CastingSpell;
      
      protected var caster:AnimatedCharacter;
      
      public function SpellScriptBase(param1:SpellFxRunner)
      {
         super();
         this.runner = param1;
         this.spell = SpellFxApi.GetCastingSpell(this.runner);
         this.caster = FxApi.GetCurrentCaster(this.runner) as AnimatedCharacter;
      }
      
      protected function addCasterSetDirectionStep(param1:MapPoint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:SetDirectionStep = null;
         if(this.caster && this.caster.position && param1 && !FxApi.IsPositionsEquals(this.caster.position,param1))
         {
            _loc2_ = this.caster.position.advancedOrientationTo(param1);
            _loc3_ = new SetDirectionStep(this.caster,_loc2_,param1);
            if(!this.latestStep && this.runner.stepsBuffer.length > 0)
            {
               this.latestStep = this.runner.stepsBuffer[this.runner.stepsBuffer.length - 1];
            }
            if(!this.latestStep)
            {
               SpellFxApi.AddFrontStep(this.runner,_loc3_);
            }
            else
            {
               SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc3_);
            }
            this.latestStep = _loc3_;
         }
      }
      
      protected function addCasterAnimationStep() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:ISequencable = null;
         if(this.caster && SpellFxApi.HasSpellParam(this.spell,"animId"))
         {
            _loc1_ = SpellFxApi.GetSpellParam(this.spell,"animId");
            _loc2_ = OptionManager.getOptionManager("dofus")["allowSpellEffects"];
            if(!_loc2_ && this.caster.id > 0)
            {
               _loc1_ = DEFAULT_CASTER_ANIMATION;
            }
            _loc3_ = SequenceApi.CreatePlayAnimationStep(this.caster,"AnimAttaque" + _loc1_,true,true,"SHOT");
            if(!this.latestStep)
            {
               SpellFxApi.AddFrontStep(this.runner,_loc3_);
            }
            else
            {
               SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc3_);
            }
            this.latestStep = _loc3_;
         }
      }
      
      protected function addNewGfxEntityStep(param1:MapPoint, param2:MapPoint, param3:MapPoint, param4:String, param5:String = "", param6:IEntity = null) : void
      {
         var _loc10_:MapPoint = null;
         var _loc11_:MapPoint = null;
         if(!param1 || !param2 || !param3)
         {
            return;
         }
         var _loc7_:int = 0;
         if(SpellFxApi.HasSpellParam(this.spell,param4 + "GfxOriented" + param5))
         {
            if(SpellFxApi.GetSpellParam(this.spell,param4 + "GfxOriented" + param5))
            {
               _loc7_ = FxApi.GetAngleTo(param2,param3);
            }
         }
         var _loc8_:int = 0;
         if(SpellFxApi.HasSpellParam(this.spell,param4 + "GfxYOffset" + param5))
         {
            _loc8_ = SpellFxApi.GetSpellParam(this.spell,param4 + "GfxYOffset" + param5);
         }
         var _loc9_:Boolean = false;
         if(SpellFxApi.HasSpellParam(this.spell,param4 + "GfxShowUnder" + param5))
         {
            _loc9_ = SpellFxApi.GetSpellParam(this.spell,param4 + "GfxShowUnder" + param5);
         }
         var _loc12_:uint = SpellFxApi.GetSpellParam(this.spell,param4 + "GfxDisplayType" + param5);
         if(_loc12_ == AddGfxModeEnum.ORIENTED)
         {
            _loc10_ = param2;
            _loc11_ = param3;
            if(param2 && _loc11_ && param2.cellId == _loc11_.cellId)
            {
               _loc11_ = _loc11_.getNearestCellInDirection(this.caster.getDirection());
               if(_loc11_ == null)
               {
                  _loc11_ = param3;
               }
            }
            if(!_loc11_)
            {
               _log.debug("Failed to add a GfxEntityStep, expecting it to be oriented, but found no endCell!");
               return;
            }
         }
         var _loc13_:ISequencable = SequenceApi.CreateAddGfxEntityStep(this.runner,SpellFxApi.GetSpellParam(this.spell,param4 + "GfxId" + param5),param1,_loc7_,_loc8_,_loc12_,_loc10_,_loc11_,_loc9_,param6);
         if(!this.latestStep)
         {
            SpellFxApi.AddFrontStep(this.runner,_loc13_);
         }
         else if(param4 == PREFIX_TARGET && SpellFxApi.HasSpellParam(this.spell,"playTargetGfxFirst" + param5) && SpellFxApi.GetSpellParam(this.spell,"playTargetGfxFirst" + param5) > 0)
         {
            SpellFxApi.AddStepBefore(this.runner,this.latestStep,_loc13_);
         }
         else
         {
            SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc13_);
         }
         this.latestStep = _loc13_;
      }
      
      protected function addAnimHitSteps() : void
      {
         var _loc2_:FightLifeVariationStep = null;
         var _loc3_:String = null;
         var _loc1_:Vector.<IFightStep> = Vector.<IFightStep>(SpellFxApi.GetStepsFromType(this.runner,"lifeVariation"));
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.value < 0)
            {
               _loc3_ = "AnimHit";
               if(SpellFxApi.HasSpellParam(this.spell,"customHitAnim"))
               {
                  _loc3_ = SpellFxApi.GetSpellParam(this.spell,"customHitAnim");
               }
               SpellFxApi.AddStepBefore(this.runner,_loc2_,SequenceApi.CreatePlayAnimationStep(_loc2_.target as TiphonSprite,_loc3_,true,false));
            }
         }
      }
      
      protected function addPortalAnimationSteps(param1:Vector.<int>) : void
      {
         var _loc3_:ISequencable = null;
         if(this.spell.spellRank.canThrowPlayer)
         {
            return;
         }
         var _loc2_:Glyph = SpellFxApi.GetPortalEntity(this.runner,param1[0]);
         if(_loc2_)
         {
            if(_loc2_.getAnimation() != PortalAnimationEnum.STATE_NORMAL)
            {
               _loc3_ = new PlayAnimationStep(_loc2_,PortalAnimationEnum.STATE_NORMAL,false,false);
               if(!this.latestStep)
               {
                  SpellFxApi.AddFrontStep(this.runner,_loc3_);
               }
               else
               {
                  SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc3_);
               }
               this.latestStep = _loc3_;
            }
            _loc3_ = new PlayAnimationStep(_loc2_,PortalAnimationEnum.STATE_ENTRY_SPELL,false,true,TiphonEvent.ANIMATION_SHOT);
            if(!this.latestStep)
            {
               SpellFxApi.AddFrontStep(this.runner,_loc3_);
            }
            else
            {
               SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc3_);
            }
            this.latestStep = _loc3_;
         }
         var _loc4_:int = 1;
         while(_loc4_ < param1.length - 1)
         {
            _loc2_ = SpellFxApi.GetPortalEntity(this.runner,param1[_loc4_]);
            if(_loc2_)
            {
               if(_loc2_.getAnimation() != PortalAnimationEnum.STATE_NORMAL)
               {
                  _loc3_ = new PlayAnimationStep(_loc2_,PortalAnimationEnum.STATE_NORMAL,false,false);
                  if(!this.latestStep)
                  {
                     SpellFxApi.AddFrontStep(this.runner,_loc3_);
                  }
                  else
                  {
                     SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc3_);
                  }
                  this.latestStep = _loc3_;
               }
               _loc3_ = new PlayAnimationStep(_loc2_,PortalAnimationEnum.STATE_ENTRY_SPELL,false,true,TiphonEvent.ANIMATION_SHOT);
               SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc3_);
               this.latestStep = _loc3_;
            }
            _loc4_++;
         }
         _loc2_ = SpellFxApi.GetPortalEntity(this.runner,param1[param1.length - 1]);
         if(_loc2_)
         {
            if(_loc2_.getAnimation() != PortalAnimationEnum.STATE_NORMAL)
            {
               _loc3_ = new PlayAnimationStep(_loc2_,PortalAnimationEnum.STATE_NORMAL,false,false);
               if(!this.latestStep)
               {
                  SpellFxApi.AddFrontStep(this.runner,_loc3_);
               }
               else
               {
                  SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc3_);
               }
               this.latestStep = _loc3_;
            }
            _loc3_ = new PlayAnimationStep(_loc2_,PortalAnimationEnum.STATE_EXIT_SPELL,false,false);
            SpellFxApi.AddStepAfter(this.runner,this.latestStep,_loc3_);
            this.latestStep = _loc3_;
         }
      }
      
      protected function destroy() : void
      {
         this.latestStep = null;
         this.spell = null;
         this.caster = null;
      }
   }
}
