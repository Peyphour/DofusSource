package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.components.messages.ChangeMessage;
   import com.ankamagames.berilia.components.messages.TextureReadyMessage;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDownMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseReleaseOutsideMessage;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   
   public class Slider extends GraphicContainer implements FinalizableUIComponent
   {
       
      
      protected var _cursor:Sprite;
      
      protected var _cursorTexture:Texture;
      
      protected var _cursorDragRegion:Rectangle;
      
      protected var _cursorUri:Uri;
      
      protected var _backgroundUri:Uri;
      
      protected var _value:Number = 5;
      
      protected var _minValue:Number = 0;
      
      protected var _maxValue:Number = 10;
      
      protected var _step:Number;
      
      public var background:Texture;
      
      public var backgroundPosition:Rectangle;
      
      public function Slider()
      {
         this._cursor = new Sprite();
         this._cursorTexture = new Texture();
         this._cursorDragRegion = new Rectangle();
         this._backgroundUri = new Uri();
         this.background = new Texture();
         super();
         this.background.autoGrid = true;
         addChild(this.background);
         addChild(this._cursor);
         this._cursor.addChild(this._cursorTexture);
         this.background.dispatchMessages = true;
         this._cursorTexture.dispatchMessages = true;
         this._cursor.visible = false;
      }
      
      public function get step() : Number
      {
         return !!isNaN(this._step)?Number(this.computeStep()):Number(this._step);
      }
      
      public function set step(param1:Number) : void
      {
         this._step = param1;
      }
      
      override public function set name(param1:String) : void
      {
         super.name = param1;
         this._cursor.name = "__" + param1 + "_cursor";
         this.background.name = "__" + param1 + "_background";
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         this.background.width = width;
         this.updatePositionFromValue();
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         this.background.height = height;
         this.updatePositionFromValue();
      }
      
      public function get maxValue() : Number
      {
         return this._maxValue;
      }
      
      public function set maxValue(param1:Number) : void
      {
         this._maxValue = param1;
         this.normalizeValue();
         if(_finalized)
         {
            this.updatePositionFromValue();
         }
      }
      
      public function get minValue() : Number
      {
         return this._minValue;
      }
      
      public function set minValue(param1:Number) : void
      {
         this._minValue = param1;
         this.normalizeValue();
         if(_finalized)
         {
            this.updatePositionFromValue();
         }
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set value(param1:Number) : void
      {
         this.normalizeValue(param1);
      }
      
      public function get cursorUri() : Uri
      {
         return this._cursorUri;
      }
      
      public function set cursorUri(param1:Uri) : void
      {
         this._cursorUri = param1;
         this._cursorTexture.uri = param1;
      }
      
      public function get backgroundUri() : Uri
      {
         return this._backgroundUri;
      }
      
      public function set backgroundUri(param1:Uri) : void
      {
         this._backgroundUri = param1;
         this.background.uri = param1;
         this.background.width = width;
         this.background.height = height;
      }
      
      override public function finalize() : void
      {
         this.updatePositionFromValue();
         this._cursor.mouseEnabled = true;
         this._cursor.useHandCursor = true;
         this._cursorTexture.finalize();
         this.background.mouseEnabled = true;
         this.background.finalize();
         super.finalize();
         _finalized = true;
      }
      
      override public function process(param1:Message) : Boolean
      {
         var _loc2_:Rectangle = null;
         switch(true)
         {
            case param1 is MouseDownMessage:
               EnterFrameDispatcher.addEventListener(this.updateFromDrag,"SliderDragUpdater");
               break;
            case param1 is MouseReleaseOutsideMessage:
            case param1 is MouseClickMessage:
               this._cursor.stopDrag();
               EnterFrameDispatcher.removeEventListener(this.updateFromDrag);
               this.updateValueFromPosition();
               break;
            case param1 is TextureReadyMessage:
               if(TextureReadyMessage(param1).target == this._cursorTexture)
               {
                  this._cursorTexture.x = 0;
                  this._cursorTexture.y = 0;
                  _loc2_ = this._cursorTexture.getBounds(this._cursor);
                  this._cursorTexture.x = -_loc2_.left - this._cursorTexture.width / 2;
                  this._cursorTexture.y = -_loc2_.top - this._cursorTexture.height / 2;
                  this.background.width = width;
                  this.background.height = height;
                  this.updatePositionFromValue();
                  this.normalizeValue();
                  this._cursor.visible = true;
               }
         }
         return super.process(param1);
      }
      
      private function computeStep() : Number
      {
         return (this.maxValue - this.minValue) / (width > height?width - this._cursor.width / 2:height - this._cursor.height / 2);
      }
      
      private function normalizeValue(param1:Number = NaN) : void
      {
         var _loc2_:Number = !!isNaN(param1)?Number(this._value):Number(param1);
         var _loc3_:Number = this._step;
         if(isNaN(this._step))
         {
            _loc3_ = this.computeStep();
         }
         _loc2_ = Math.round(_loc2_ / _loc3_) * _loc3_;
         if(this.minValue < this.maxValue)
         {
            if(_loc2_ > this.maxValue)
            {
               _loc2_ = this.maxValue;
            }
            if(_loc2_ < this.minValue)
            {
               _loc2_ = this.minValue;
            }
         }
         else
         {
            if(_loc2_ < this.maxValue)
            {
               _loc2_ = this.maxValue;
            }
            if(_loc2_ > this.minValue)
            {
               _loc2_ = this.minValue;
            }
         }
         if(_loc2_ != this._value)
         {
            this._value = _loc2_;
            Berilia.getInstance().handler.process(new ChangeMessage(this));
         }
         this.updatePositionFromValue();
      }
      
      private function updateValueFromPosition() : void
      {
         var _loc1_:Number = NaN;
         if(width > height)
         {
            _loc1_ = (this._cursor.x - this._cursor.width / 2) / ((width - this._cursor.width) / (this.maxValue - this.minValue)) + this.minValue;
         }
         else
         {
            _loc1_ = (this._cursor.y - this._cursor.height / 2) / ((height - this._cursor.height) / (this.maxValue - this.minValue)) + this.minValue;
         }
         this.value = _loc1_;
      }
      
      private function updatePositionFromValue() : void
      {
         if(width > height)
         {
            this._cursor.x = (width - this._cursor.width) / (this.maxValue - this.minValue) * (this.value - this.minValue) + this._cursor.width / 2;
            this._cursor.y = height / 2;
         }
         else
         {
            this._cursor.y = (height - this._cursor.height) / (this.maxValue - this.minValue) * (this.value - this.minValue) + this._cursor.height / 2;
            this._cursor.x = width / 2;
         }
      }
      
      private function updateFromDrag(param1:Event) : void
      {
         if(width > height)
         {
            this._cursor.x = mouseX;
         }
         else
         {
            this._cursor.y = mouseY;
         }
         this.updateValueFromPosition();
      }
   }
}
