package com.ankamagames.tubul.types.sounds
{
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tubul.Tubul;
   import com.ankamagames.tubul.interfaces.ILocalizedSound;
   import flash.geom.Point;
   
   public class LocalizedSound extends MP3SoundDofus implements ILocalizedSound
   {
       
      
      private var _pan:Number;
      
      private var _position:Point;
      
      private var _range:Number;
      
      private var _saturationRange:Number;
      
      private var _observerPosition:Point;
      
      private var _volumeMax:Number;
      
      public function LocalizedSound(param1:uint, param2:Uri, param3:Boolean)
      {
         super(param1,param2,param3);
         this._pan = 0;
         this.volumeMax = 1;
         this.updateObserverPosition(Tubul.getInstance().earPosition);
      }
      
      public function get pan() : Number
      {
         return this._pan;
      }
      
      public function set pan(param1:Number) : void
      {
         if(param1 < -1)
         {
            this._pan = -1;
            return;
         }
         if(param1 > 1)
         {
            this._pan = 1;
            return;
         }
         this._pan = param1;
      }
      
      public function get range() : Number
      {
         return this._range;
      }
      
      public function set range(param1:Number) : void
      {
         if(param1 < this._saturationRange)
         {
            param1 = this._saturationRange;
         }
         this._range = param1;
      }
      
      public function get saturationRange() : Number
      {
         return this._saturationRange;
      }
      
      public function set saturationRange(param1:Number) : void
      {
         if(param1 >= this._range)
         {
            param1 = this._range;
         }
         this._saturationRange = param1;
      }
      
      public function get position() : Point
      {
         return this._position;
      }
      
      public function set position(param1:Point) : void
      {
         var _loc2_:String = null;
         if(_uri)
         {
            _loc2_ = _uri.fileName;
         }
         this._position = param1;
         if(this._observerPosition && _uri.fileName != "40003440001.mp3" && _uri.fileName != "1000001197.mp3" && _uri.fileName != "1000001198.mp3" && _uri.fileName != "1000001199.mp3" && _uri.fileName != "1000001200.mp3")
         {
            this.updateSound();
         }
      }
      
      public function get volumeMax() : Number
      {
         return this._volumeMax;
      }
      
      public function set volumeMax(param1:Number) : void
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         if(param1 < 0)
         {
            param1 = 0;
         }
         this._volumeMax = param1;
      }
      
      override public function get effectiveVolume() : Number
      {
         return busVolume * volume * currentFadeVolume * this.volumeMax;
      }
      
      public function updateObserverPosition(param1:Point) : void
      {
         this._observerPosition = param1;
         if(this.position)
         {
            this.updateSound();
         }
      }
      
      override protected function applyParam() : void
      {
         if(_soundWrapper == null)
         {
            return;
         }
         _soundWrapper.volume = this.effectiveVolume;
         _soundWrapper.pan = this._pan;
      }
      
      private function updateSound() : void
      {
         var _loc1_:Number = NaN;
         var _loc10_:Number = NaN;
         _loc1_ = this._position.y + (this._position.y - this._observerPosition.y) * 2;
         var _loc2_:Number = Math.abs(this._observerPosition.x - this._position.x);
         var _loc3_:Number = Math.abs(this._observerPosition.y - _loc1_);
         var _loc4_:Number = _loc2_ * _loc2_;
         var _loc5_:Number = _loc3_ * _loc3_;
         var _loc6_:Number = Math.sqrt(_loc4_ + _loc5_);
         var _loc7_:Number = this._range * this._range;
         var _loc8_:Number = this._saturationRange * this._saturationRange;
         if(_loc6_ <= this._saturationRange)
         {
            volume = 1;
         }
         else if(_loc6_ <= this._range)
         {
            _loc10_ = (this._range - _loc6_) / (this._range - this._saturationRange);
            volume = _loc10_;
         }
         else
         {
            volume = 0;
         }
         var _loc9_:Number = 640;
         this.pan = this._position.x / _loc9_ - 1;
         if(_soundLoaded)
         {
            this.applyParam();
         }
      }
   }
}
