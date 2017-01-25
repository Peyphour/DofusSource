package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.messages.Message;
   import flash.display.Shape;
   import flash.events.Event;
   
   public class ProgressBar extends GraphicContainer implements UIComponent
   {
       
      
      private var _barColor:int;
      
      private var _barAlpha:Number;
      
      private var _innerBarColor:int;
      
      private var _innerBarAlpha:Number;
      
      private var _separatorColor:int;
      
      private var _bar:Shape;
      
      private var _innerBar:Shape;
      
      private var _barPadding:int = 1;
      
      private var _barForeground:TextureBitmap;
      
      private var _barBackground:TextureBitmap;
      
      private var _numberOfSeparators:uint;
      
      private var _separators:Shape;
      
      private var _value:Number = 0;
      
      private var _innerValue:Number = 0;
      
      private var _clickable:Boolean;
      
      public var snapToSeparators:Boolean = false;
      
      public function ProgressBar()
      {
         super();
         _bgColor = XmlConfig.getInstance().getEntry("colors.progressbar.background");
         _bgAlpha = 1;
         this._barColor = 16711935;
         this._barAlpha = 1;
         this._innerBarColor = 16711935;
         this._innerBarAlpha = 1;
         this._separatorColor = XmlConfig.getInstance().getEntry("colors.progressbar.separator");
         this._innerBar = new Shape();
         this._innerBar.x = this._barPadding;
         this._innerBar.y = this._barPadding;
         addChild(this._innerBar);
         this._bar = new Shape();
         this._bar.x = this._barPadding;
         this._bar.y = this._barPadding;
         addChild(this._bar);
         this._clickable = false;
         mouseEnabled = true;
      }
      
      public function set value(param1:Number) : void
      {
         this._value = Math.max(Math.min(param1,1),0);
         if(this.snapToSeparators && this._numberOfSeparators)
         {
            this._value = Math.ceil(width * this._value / (width / (this._numberOfSeparators + 1))) * (width / (this._numberOfSeparators + 1)) / width;
            this._value = Math.round(this._value * 100) / 100;
         }
         this.draw();
      }
      
      public function get value() : Number
      {
         return this._value;
      }
      
      public function set innerValue(param1:Number) : void
      {
         this._innerValue = Math.max(Math.min(param1,1),0);
         this.draw();
      }
      
      public function get innerValue() : Number
      {
         return this._innerValue;
      }
      
      public function get barPadding() : int
      {
         return this._barPadding;
      }
      
      public function set barPadding(param1:int) : void
      {
         this._barPadding = param1;
         this._bar.x = this._barPadding;
         this._bar.y = this._barPadding;
         this._innerBar.x = this._barPadding;
         this._innerBar.y = this._barPadding;
         if(_finalized)
         {
            this.finalize();
         }
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         if(_finalized)
         {
            this.finalize();
         }
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         if(_finalized)
         {
            this.finalize();
         }
      }
      
      override public function set bgColor(param1:*) : void
      {
         setColorVar(param1);
      }
      
      public function set barColor(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc4_:uint = 0;
         var _loc3_:Number = this._barAlpha;
         if(param1 is String)
         {
            _loc4_ = String(param1).substr(0,2) == "0x"?uint(16):uint(10);
            param1 = parseInt(param1,_loc4_);
         }
         if(param1 is int || param1 is uint)
         {
            _loc2_ = param1;
            _loc2_ = _loc2_ < 0?int(_loc2_):_loc2_ & 16777215;
            if(param1 & 4278190080 && _loc2_ != -1)
            {
               _loc3_ = ((param1 & 4278190080) >> 24) / 255;
            }
         }
         else
         {
            _loc2_ = -1;
         }
         if(_loc2_ != this._barColor || _loc3_ != this._barAlpha)
         {
            this._barColor = _loc2_;
            this._barAlpha = _loc3_;
            if(finalized)
            {
               this.finalize();
            }
         }
      }
      
      public function set innerBarColor(param1:*) : void
      {
         var _loc2_:int = 0;
         var _loc4_:uint = 0;
         var _loc3_:Number = this._innerBarAlpha;
         if(param1 is String)
         {
            _loc4_ = String(param1).substr(0,2) == "0x"?uint(16):uint(10);
            param1 = parseInt(param1,_loc4_);
         }
         if(param1 is int || param1 is uint)
         {
            _loc2_ = param1;
            _loc2_ = _loc2_ < 0?int(_loc2_):_loc2_ & 16777215;
            if(param1 & 4278190080 && _loc2_ != -1)
            {
               _loc3_ = ((param1 & 4278190080) >> 24) / 255;
            }
         }
         else
         {
            _loc2_ = -1;
         }
         if(_loc2_ != this._innerBarColor || _loc3_ != this._innerBarAlpha)
         {
            this._innerBarColor = _loc2_;
            this._innerBarAlpha = _loc3_;
            if(finalized)
            {
               this.finalize();
            }
         }
      }
      
      public function set innerBarAlpha(param1:Number) : void
      {
         this._innerBarAlpha = param1;
         if(finalized)
         {
            this.finalize();
         }
      }
      
      public function set separators(param1:uint) : void
      {
         this._numberOfSeparators = param1;
         if(this._numberOfSeparators && !this._separators)
         {
            this._separators = new Shape();
            addChild(this._separators);
         }
         else if(!this._numberOfSeparators && this._separators)
         {
            removeChild(this._separators);
            this._separators = null;
         }
         if(finalized)
         {
            this.finalize();
         }
      }
      
      public function set clickable(param1:Boolean) : void
      {
         this._clickable = param1;
         buttonMode = this._clickable;
      }
      
      public function set barForegroundThemeData(param1:String) : void
      {
         if(!this._barForeground)
         {
            this._barForeground = new TextureBitmap();
            addChildAt(this._barForeground,2);
         }
         this._barForeground.addEventListener(Event.COMPLETE,this.onForegroundCompleted);
         this._barForeground.themeDataId = param1;
      }
      
      public function set barBackgroundThemeData(param1:String) : void
      {
         if(!this._barBackground)
         {
            this._barBackground = new TextureBitmap();
            addChildAt(this._barBackground,0);
            _bgColor = -1;
         }
         this._barBackground.themeDataId = param1;
      }
      
      private function onForegroundCompleted(param1:Event) : void
      {
         this._barForeground.removeEventListener(Event.COMPLETE,this.onForegroundCompleted);
         this.finalize();
      }
      
      override public function finalize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         if(this._barForeground && !this._barForeground.finalized)
         {
            return;
         }
         graphics.clear();
         if(_bgColor > -1)
         {
            graphics.beginFill(_bgColor,_bgAlpha);
            graphics.drawRect(0,0,width,height);
            graphics.endFill();
         }
         if(this._barBackground)
         {
            this._barBackground.width = width;
            this._barBackground.height = height;
         }
         if(this._barForeground)
         {
            this._barForeground.finalized = false;
            this._barForeground.height = height;
         }
         this.draw();
         if(this._barForeground)
         {
            this._barForeground.finalize();
         }
         if(this._numberOfSeparators)
         {
            _loc1_ = this._numberOfSeparators + 1;
            this._separators.graphics.clear();
            _loc2_ = width / _loc1_;
            _loc3_ = 1;
            while(_loc3_ < _loc1_)
            {
               this._separators.graphics.lineStyle(1,this._separatorColor,0.81);
               this._separators.graphics.moveTo(_loc3_ * _loc2_,1);
               this._separators.graphics.lineTo(_loc3_ * _loc2_,height - 1);
               this._separators.graphics.lineStyle(1,this._separatorColor,0.51);
               this._separators.graphics.moveTo(_loc3_ * _loc2_ - 1,1);
               this._separators.graphics.lineTo(_loc3_ * _loc2_ - 1,height - 1);
               this._separators.graphics.lineStyle(1,this._separatorColor,0.24);
               this._separators.graphics.moveTo(_loc3_ * _loc2_ + 1,1);
               this._separators.graphics.lineTo(_loc3_ * _loc2_ + 1,height - 1);
               _loc3_++;
            }
            this._separators.graphics.endFill();
         }
         super.finalize();
         if(getUi())
         {
            getUi().iAmFinalized(this);
         }
      }
      
      protected function draw() : void
      {
         var _loc1_:Number = width * this._value;
         _loc1_ = _loc1_ < 1 && this._value != 0?Number(1):Number(_loc1_);
         var _loc2_:Number = width * this._innerValue;
         _loc2_ = _loc2_ < 1 && this._innerValue != 0?Number(1):Number(_loc2_);
         this._innerBar.graphics.clear();
         if(_loc2_)
         {
            this._innerBar.graphics.beginFill(this._innerBarColor,this._innerBarAlpha);
            this._innerBar.graphics.drawRect(0,0,_loc2_ - this._barPadding * 2,height - this._barPadding * 2);
            this._innerBar.graphics.endFill();
         }
         this._bar.graphics.clear();
         if(_loc1_)
         {
            this._bar.graphics.beginFill(this._barColor,this._barAlpha);
            this._bar.graphics.drawRect(0,0,_loc1_ - this._barPadding * 2,height - this._barPadding * 2);
            this._bar.graphics.endFill();
         }
         if(this._barForeground)
         {
            if(_loc1_)
            {
               this._barForeground.width = _loc1_;
               this._barForeground.visible = true;
            }
            else
            {
               this._barForeground.visible = false;
            }
         }
      }
      
      override public function process(param1:Message) : Boolean
      {
         super.process(param1);
         var _loc2_:MouseClickMessage = param1 as MouseClickMessage;
         if(this._clickable && _loc2_ && !isNaN(_loc2_.mouseEvent.localX))
         {
            this.value = _loc2_.mouseEvent.localX / width;
         }
         return false;
      }
      
      override public function remove() : void
      {
         super.remove();
         this._bar = null;
         this._innerBar = null;
         this._barForeground = null;
         this._separators = null;
      }
   }
}
