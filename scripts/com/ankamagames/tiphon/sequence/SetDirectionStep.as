package com.ankamagames.tiphon.sequence
{
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.tiphon.display.TiphonSprite;
   
   public class SetDirectionStep extends AbstractSequencable
   {
       
      
      private var _nDirection:uint;
      
      private var _target:TiphonSprite;
      
      private var _cellToTarget:MapPoint;
      
      public function SetDirectionStep(param1:TiphonSprite, param2:uint, param3:MapPoint = null)
      {
         super();
         this._target = param1;
         this._nDirection = param2;
         this._cellToTarget = param3;
      }
      
      override public function start() : void
      {
         if(this._target as IEntity && (this._target as IEntity).position && this._cellToTarget)
         {
            this._nDirection = (this._target as IEntity).position.advancedOrientationTo(this._cellToTarget);
         }
         if(!this._target.getAnimation() || this._target.hasAnimation(this._target.getAnimation(),this._nDirection))
         {
            this._target.setDirection(this._nDirection);
         }
         else
         {
            _log.error("[SetDirectionStep] La direction " + this._nDirection + " n\'est pas disponible sur l\'animation " + this._target.getAnimation() + " du bones " + this._target.look.getBone());
         }
         executeCallbacks();
      }
      
      override public function toString() : String
      {
         return "set direction " + this._nDirection + " on " + this._target.name;
      }
   }
}
