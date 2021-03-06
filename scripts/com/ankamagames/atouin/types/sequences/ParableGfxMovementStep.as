package com.ankamagames.atouin.types.sequences
{
   import com.ankamagames.atouin.utils.CellUtil;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import gs.TweenMax;
   import gs.easing.Linear;
   
   public class ParableGfxMovementStep extends AbstractSequencable
   {
       
      
      private var _gfxEntity:IMovable;
      
      private var _targetPoint:MapPoint;
      
      private var _curvePrc:Number;
      
      private var _yOffset:int;
      
      private var _yOffsetOnHit:int;
      
      private var _waitEnd:Boolean;
      
      private var _speed:uint;
      
      public function ParableGfxMovementStep(param1:IMovable, param2:MapPoint, param3:uint, param4:Number = 0.5, param5:int = 0, param6:Boolean = true, param7:int = 0)
      {
         super();
         this._gfxEntity = param1;
         this._targetPoint = param2;
         this._curvePrc = param4;
         this._waitEnd = param6;
         this._speed = param3;
         this._yOffset = param5;
         this._yOffsetOnHit = param7;
      }
      
      override public function start() : void
      {
         var _loc3_:Number = NaN;
         if(this._targetPoint.equals(this._gfxEntity.position))
         {
            if(this._waitEnd)
            {
               executeCallbacks();
            }
            return;
         }
         var _loc1_:Point = new Point(CellUtil.getPixelXFromMapPoint((this._gfxEntity as IEntity).position),CellUtil.getPixelYFromMapPoint((this._gfxEntity as IEntity).position) + this._yOffset);
         var _loc2_:Point = new Point(CellUtil.getPixelXFromMapPoint(this._targetPoint),CellUtil.getPixelYFromMapPoint(this._targetPoint) + (this._yOffsetOnHit != 0?this._yOffsetOnHit:this._yOffset));
         _loc3_ = Point.distance(_loc1_,_loc2_);
         var _loc4_:Point = Point.interpolate(_loc1_,_loc2_,0.5);
         _loc4_.y = _loc4_.y - _loc3_ * this._curvePrc;
         DisplayObject(this._gfxEntity).y = DisplayObject(this._gfxEntity).y + this._yOffset;
         TweenMax.to(this._gfxEntity,_loc3_ / 100 * this._speed / 1000,{
            "x":_loc2_.x,
            "y":_loc2_.y,
            "orientToBezier":true,
            "bezier":[{
               "x":_loc4_.x,
               "y":_loc4_.y
            }],
            "scaleX":1,
            "scaleY":1,
            "alpha":1,
            "ease":Linear.easeNone,
            "immediateRender":true,
            "onComplete":(!!this._waitEnd?executeCallbacks:null)
         });
         if(!this._waitEnd)
         {
            executeCallbacks();
         }
      }
   }
}
