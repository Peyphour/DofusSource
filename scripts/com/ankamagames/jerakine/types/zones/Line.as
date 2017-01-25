package com.ankamagames.jerakine.types.zones
{
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.utils.getQualifiedClassName;
   
   public class Line implements IZone
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Line));
       
      
      private var _radius:uint = 0;
      
      private var _minRadius:uint = 0;
      
      private var _nDirection:uint = 1;
      
      private var _dataMapProvider:IDataMapProvider;
      
      private var _fromCaster:Boolean;
      
      private var _stopAtTarget:Boolean;
      
      private var _casterCellId:uint;
      
      public function Line(param1:uint, param2:IDataMapProvider)
      {
         super();
         this.radius = param1;
         this._dataMapProvider = param2;
      }
      
      public function get radius() : uint
      {
         return this._radius;
      }
      
      public function set radius(param1:uint) : void
      {
         this._radius = param1;
      }
      
      public function get surface() : uint
      {
         return this._radius + 1;
      }
      
      public function set minRadius(param1:uint) : void
      {
         this._minRadius = param1;
      }
      
      public function get minRadius() : uint
      {
         return this._minRadius;
      }
      
      public function set direction(param1:uint) : void
      {
         this._nDirection = param1;
      }
      
      public function get direction() : uint
      {
         return this._nDirection;
      }
      
      public function set fromCaster(param1:Boolean) : void
      {
         this._fromCaster = param1;
      }
      
      public function get fromCaster() : Boolean
      {
         return this._fromCaster;
      }
      
      public function set stopAtTarget(param1:Boolean) : void
      {
         this._stopAtTarget = param1;
      }
      
      public function get stopAtTarget() : Boolean
      {
         return this._stopAtTarget;
      }
      
      public function set casterCellId(param1:uint) : void
      {
         this._casterCellId = param1;
      }
      
      public function get casterCellId() : uint
      {
         return this._casterCellId;
      }
      
      public function getCells(param1:uint = 0) : Vector.<uint>
      {
         var _loc6_:Boolean = false;
         var _loc9_:uint = 0;
         var _loc2_:Vector.<uint> = new Vector.<uint>();
         var _loc3_:MapPoint = !this._fromCaster?MapPoint.fromCellId(param1):MapPoint.fromCellId(this.casterCellId);
         var _loc4_:int = _loc3_.x;
         var _loc5_:int = _loc3_.y;
         var _loc7_:uint = !this.fromCaster?uint(this._radius):uint(this._radius + this._minRadius - 1);
         if(this.fromCaster && this.stopAtTarget)
         {
            _loc9_ = _loc3_.distanceToCell(MapPoint.fromCellId(param1));
            _loc7_ = _loc9_ < _loc7_?uint(_loc9_):uint(_loc7_);
         }
         var _loc8_:int = this._minRadius;
         while(_loc8_ <= _loc7_)
         {
            switch(this._nDirection)
            {
               case DirectionsEnum.LEFT:
                  if(MapPoint.isInMap(_loc4_ - _loc8_,_loc5_ - _loc8_))
                  {
                     _loc6_ = this.addCell(_loc4_ - _loc8_,_loc5_ - _loc8_,_loc2_);
                  }
                  break;
               case DirectionsEnum.UP:
                  if(MapPoint.isInMap(_loc4_ - _loc8_,_loc5_ + _loc8_))
                  {
                     _loc6_ = this.addCell(_loc4_ - _loc8_,_loc5_ + _loc8_,_loc2_);
                  }
                  break;
               case DirectionsEnum.RIGHT:
                  if(MapPoint.isInMap(_loc4_ + _loc8_,_loc5_ + _loc8_))
                  {
                     _loc6_ = this.addCell(_loc4_ + _loc8_,_loc5_ + _loc8_,_loc2_);
                  }
                  break;
               case DirectionsEnum.DOWN:
                  if(MapPoint.isInMap(_loc4_ + _loc8_,_loc5_ - _loc8_))
                  {
                     _loc6_ = this.addCell(_loc4_ + _loc8_,_loc5_ - _loc8_,_loc2_);
                  }
                  break;
               case DirectionsEnum.UP_LEFT:
                  if(MapPoint.isInMap(_loc4_ - _loc8_,_loc5_))
                  {
                     _loc6_ = this.addCell(_loc4_ - _loc8_,_loc5_,_loc2_);
                  }
                  break;
               case DirectionsEnum.DOWN_LEFT:
                  if(MapPoint.isInMap(_loc4_,_loc5_ - _loc8_))
                  {
                     _loc6_ = this.addCell(_loc4_,_loc5_ - _loc8_,_loc2_);
                  }
                  break;
               case DirectionsEnum.DOWN_RIGHT:
                  if(MapPoint.isInMap(_loc4_ + _loc8_,_loc5_))
                  {
                     _loc6_ = this.addCell(_loc4_ + _loc8_,_loc5_,_loc2_);
                  }
                  break;
               case DirectionsEnum.UP_RIGHT:
                  if(MapPoint.isInMap(_loc4_,_loc5_ + _loc8_))
                  {
                     _loc6_ = this.addCell(_loc4_,_loc5_ + _loc8_,_loc2_);
                  }
            }
            _loc8_++;
         }
         return _loc2_;
      }
      
      private function addCell(param1:int, param2:int, param3:Vector.<uint>) : Boolean
      {
         if(this._dataMapProvider == null || this._dataMapProvider.pointMov(param1,param2))
         {
            param3.push(MapPoint.fromCoords(param1,param2).cellId);
            return true;
         }
         return false;
      }
   }
}
