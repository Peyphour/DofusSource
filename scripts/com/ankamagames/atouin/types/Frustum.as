package com.ankamagames.atouin.types
{
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.geom.Rectangle;
   import flash.utils.getQualifiedClassName;
   
   public class Frustum extends Rectangle
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Frustum));
      
      public static const MAX_WIDTH:Number = AtouinConstants.MAP_WIDTH * AtouinConstants.CELL_WIDTH + AtouinConstants.CELL_HALF_WIDTH;
      
      public static const MAX_HEIGHT:Number = AtouinConstants.MAP_HEIGHT * AtouinConstants.CELL_HEIGHT + AtouinConstants.CELL_HALF_HEIGHT;
      
      public static const RATIO:Number = MAX_WIDTH / MAX_HEIGHT;
       
      
      private var _marginLeft:int;
      
      private var _marginRight:int;
      
      private var _marginTop:int;
      
      private var _marginBottom:int;
      
      public var scale:Number;
      
      public function Frustum(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0)
      {
         super();
         this._marginTop = param2;
         this._marginRight = param1;
         this._marginBottom = param4;
         this._marginLeft = param3;
         this.refresh();
      }
      
      public function get marginLeft() : int
      {
         return this._marginLeft;
      }
      
      public function get marginRight() : int
      {
         return this._marginRight;
      }
      
      public function get marginTop() : int
      {
         return this._marginTop;
      }
      
      public function get marginBottom() : int
      {
         return this._marginBottom;
      }
      
      public function refresh() : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         this.scale = StageShareManager.startHeight / (MAX_HEIGHT + this._marginTop + this._marginBottom);
         width = MAX_WIDTH * this.scale;
         height = MAX_HEIGHT * this.scale;
         var _loc1_:Number = width / height;
         if(_loc1_ < RATIO)
         {
            height = width / RATIO;
         }
         else if(_loc1_ > RATIO)
         {
            width = height * RATIO;
         }
         var _loc2_:Number = StageShareManager.startWidth - MAX_WIDTH * this.scale + this._marginLeft - this._marginRight;
         var _loc3_:Number = StageShareManager.startHeight - MAX_HEIGHT * this.scale + this._marginTop - this._marginBottom;
         var _loc4_:uint = 2;
         if(this._marginLeft && this._marginRight)
         {
            _loc5_ = (this._marginLeft + this._marginRight) / this._marginLeft;
         }
         else if(this._marginLeft)
         {
            _loc5_ = _loc4_ + _loc2_ / this._marginLeft;
         }
         else if(this._marginRight)
         {
            _loc5_ = _loc4_ - _loc2_ / this._marginRight;
         }
         else
         {
            _loc5_ = _loc4_;
         }
         if(this._marginTop && this._marginBottom)
         {
            _loc6_ = (this._marginTop + this._marginBottom) / this._marginTop;
         }
         else if(this._marginTop)
         {
            _loc6_ = _loc4_ + _loc3_ / this._marginTop;
         }
         else if(this._marginBottom)
         {
            _loc6_ = _loc3_ / this._marginBottom - _loc4_;
         }
         else
         {
            _loc6_ = _loc4_;
         }
         x = _loc2_ / _loc5_;
         y = _loc3_ / _loc6_;
      }
      
      override public function toString() : String
      {
         return super.toString() + " scale=" + this.scale;
      }
   }
}
