package com.ankamagames.berilia.types.data
{
   import com.ankamagames.jerakine.types.Uri;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.PixelSnapping;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   
   public class MapArea extends Rectangle
   {
      
      private static var _freeBitmap:Array = [];
       
      
      public var parent:Map;
      
      private var _bitmap:Bitmap;
      
      private var _active:Boolean;
      
      private var _freeTimer:Timer;
      
      private var _isLoaded:Boolean;
      
      private var _srcPath:String;
      
      private var _src:Uri;
      
      public function MapArea(param1:String, param2:Number, param3:Number, param4:Number, param5:Number, param6:Map)
      {
         this.parent = param6;
         this._srcPath = param1;
         this._isLoaded = false;
         super(param2,param3,param4,param5);
      }
      
      public function get src() : Uri
      {
         if(!this._src)
         {
            this._src = new Uri(this._srcPath);
            this._srcPath = null;
         }
         return this._src;
      }
      
      public function get isUsed() : Boolean
      {
         return this._active;
      }
      
      public function get isLoaded() : Boolean
      {
         return this._isLoaded;
      }
      
      public function getBitmap() : DisplayObject
      {
         this._active = true;
         if(this._freeTimer)
         {
            this._freeTimer.removeEventListener(TimerEvent.TIMER,this.onDeathCountDown);
            this._freeTimer.stop();
            this._freeTimer = null;
         }
         if(!this._bitmap || !this._bitmap.bitmapData)
         {
            if(_freeBitmap.length)
            {
               this._bitmap = _freeBitmap.pop();
            }
            else
            {
               this._bitmap = new Bitmap(null,PixelSnapping.AUTO,true);
            }
            this._bitmap.x = x;
            this._bitmap.y = y;
         }
         return this._bitmap;
      }
      
      public function setBitmap(param1:*) : void
      {
         var _loc2_:* = false;
         var _loc3_:Number = NaN;
         if(this._active)
         {
            this._isLoaded = true;
            this._bitmap.bitmapData = param1;
            this._bitmap.smoothing = true;
            _loc2_ = this._bitmap.width != this._bitmap.height;
            this._bitmap.width = width + 1;
            this._bitmap.height = height + 1;
            if(!_loc2_)
            {
               return;
            }
            _loc3_ = this.parent.currentScale;
            if(isNaN(_loc3_))
            {
               if(this._bitmap.scaleX == this._bitmap.scaleY)
               {
                  _loc3_ = this._bitmap.scaleX;
               }
               else if(x + width > this.parent.initialWidth)
               {
                  _loc3_ = this._bitmap.scaleY;
               }
               else if(y + height > this.parent.initialHeight)
               {
                  _loc3_ = this._bitmap.scaleX;
               }
            }
            if(this._bitmap.scaleX != this._bitmap.scaleY && _loc3_)
            {
               this._bitmap.scaleX = this._bitmap.scaleY = _loc3_;
            }
         }
      }
      
      public function free(param1:Boolean = false) : void
      {
         this._active = false;
         if(param1)
         {
            this.onDeathCountDown(null);
            return;
         }
         if(!this._freeTimer)
         {
            this._freeTimer = new Timer(3000);
            this._freeTimer.addEventListener(TimerEvent.TIMER,this.onDeathCountDown,false,0,true);
         }
         this._freeTimer.start();
      }
      
      private function onDeathCountDown(param1:Event) : void
      {
         if(this._freeTimer)
         {
            this._freeTimer.removeEventListener(TimerEvent.TIMER,this.onDeathCountDown);
            this._freeTimer.stop();
            this._freeTimer = null;
         }
         if(this._active)
         {
            return;
         }
         if(this._bitmap)
         {
            if(this._bitmap.parent)
            {
               this._bitmap.parent.removeChild(this._bitmap);
            }
            this._bitmap.bitmapData = null;
            _freeBitmap.push(this._bitmap);
            this._bitmap = null;
            this._isLoaded = false;
         }
      }
   }
}
