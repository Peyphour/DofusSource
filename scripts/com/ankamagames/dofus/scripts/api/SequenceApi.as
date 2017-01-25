package com.ankamagames.dofus.scripts.api
{
   import com.ankamagames.atouin.types.sequences.AddWorldEntityStep;
   import com.ankamagames.atouin.types.sequences.DestroyEntityStep;
   import com.ankamagames.atouin.types.sequences.ParableGfxMovementStep;
   import com.ankamagames.dofus.logic.game.fight.steps.FightDestroyEntityStep;
   import com.ankamagames.dofus.scripts.FxRunner;
   import com.ankamagames.dofus.scripts.SpellFxRunner;
   import com.ankamagames.dofus.types.sequences.AddGfxEntityStep;
   import com.ankamagames.dofus.types.sequences.AddGfxInLineStep;
   import com.ankamagames.dofus.types.sequences.AddGlyphGfxStep;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.sequencer.DebugStep;
   import com.ankamagames.jerakine.sequencer.ISequencable;
   import com.ankamagames.jerakine.sequencer.ISequencer;
   import com.ankamagames.jerakine.sequencer.ParallelStartSequenceStep;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.jerakine.sequencer.StartSequenceStep;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.SetDirectionStep;
   import com.ankamagames.tiphon.types.CarriedSprite;
   import flash.display.DisplayObject;
   
   public class SequenceApi
   {
       
      
      public function SequenceApi()
      {
         super();
      }
      
      public static function CreateSerialSequencer() : ISequencer
      {
         return new SerialSequencer();
      }
      
      public static function CreateParallelStartSequenceStep(param1:Array, param2:Boolean = true, param3:Boolean = false) : ISequencable
      {
         return new ParallelStartSequenceStep(param1,param2,param3);
      }
      
      public static function CreateStartSequenceStep(param1:ISequencer) : ISequencable
      {
         return new StartSequenceStep(param1);
      }
      
      public static function CreateAddGfxEntityStep(param1:FxRunner, param2:uint, param3:MapPoint, param4:Number = 0, param5:int = 0, param6:uint = 0, param7:MapPoint = null, param8:MapPoint = null, param9:Boolean = false, param10:IEntity = null) : ISequencable
      {
         return new AddGfxEntityStep(param2,param3.cellId,param4,-DisplayObject(param1.caster).height * param5 / 10,param6,param7,param8,param9,null,param10);
      }
      
      public static function CreateAddGlyphGfxStep(param1:SpellFxRunner, param2:uint, param3:MapPoint, param4:int) : ISequencable
      {
         return new AddGlyphGfxStep(param2,param3.cellId,param4,param1.castingSpell.markType);
      }
      
      public static function CreatePlayAnimationStep(param1:TiphonSprite, param2:String, param3:Boolean, param4:Boolean, param5:String = "animation_event_end", param6:int = 1) : ISequencable
      {
         return new PlayAnimationStep(param1,param2,param3,param4,param5,param6);
      }
      
      public static function CreateSetDirectionStep(param1:TiphonSprite, param2:uint) : ISequencable
      {
         return new SetDirectionStep(param1,param2);
      }
      
      public static function CreateParableGfxMovementStep(param1:FxRunner, param2:IMovable, param3:MapPoint, param4:Number = 100, param5:Number = 0.5, param6:int = 0, param7:Boolean = true) : ParableGfxMovementStep
      {
         var _loc8_:int = 0;
         var _loc9_:DisplayObject = TiphonSprite(param1.caster).parent;
         while(_loc9_)
         {
            if(_loc9_ is CarriedSprite)
            {
               _loc8_ = _loc8_ + _loc9_.y;
            }
            _loc9_ = _loc9_.parent;
         }
         return new ParableGfxMovementStep(param2,param3,param4,param5,-DisplayObject(param1.caster).height * param6 / 10 + _loc8_,param7);
      }
      
      public static function CreateAddGfxInLineStep(param1:SpellFxRunner, param2:uint, param3:MapPoint, param4:MapPoint, param5:Number = 0, param6:uint = 0, param7:Number = 0, param8:Number = 0, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false, param12:Boolean = false, param13:Boolean = false, param14:IEntity = null) : AddGfxInLineStep
      {
         return new AddGfxInLineStep(param2,param1.castingSpell,param3,param4,-DisplayObject(param1.caster).height * param5 / 10,param6,param7,param8,param9,param10,param12,param13,param11,param14);
      }
      
      public static function CreateAddWorldEntityStep(param1:IEntity) : AddWorldEntityStep
      {
         return new AddWorldEntityStep(param1);
      }
      
      public static function CreateDestroyEntityStep(param1:IEntity) : DestroyEntityStep
      {
         return new FightDestroyEntityStep(param1);
      }
      
      public static function CreateDebugStep(param1:String) : DebugStep
      {
         return new DebugStep(param1);
      }
   }
}
