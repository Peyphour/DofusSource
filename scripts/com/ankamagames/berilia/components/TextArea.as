package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.types.graphic.GraphicElement;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseWheelMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.NativeWindowBoundsEvent;
   import flash.utils.getQualifiedClassName;
   
   public class TextArea extends Label implements FinalizableUIComponent
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(TextArea));
       
      
      private var _sbScrollBar:ScrollBar;
      
      private var _bFinalized:Boolean;
      
      private var _nScrollPos:int = 5;
      
      private var _bHideScroll:Boolean = false;
      
      private var _scrollTopMargin:int = 0;
      
      private var _scrollBottomMargin:int = 0;
      
      private var _scrollXOffset:int = 10;
      
      private var _skipScrollUpdate:Boolean = false;
      
      private var _bResetScroll:Boolean = false;
      
      protected var ___width:uint;
      
      public function TextArea()
      {
         super();
         this._sbScrollBar = new ScrollBar();
         this._sbScrollBar.min = 1;
         this._sbScrollBar.max = 1;
         this._sbScrollBar.step = 1;
         this._sbScrollBar.scrollSpeed = 1 / 6;
         this._sbScrollBar.addEventListener(Event.CHANGE,this.onScroll);
         _tText.addEventListener(MouseEvent.MOUSE_WHEEL,this.onTextWheel);
         addChild(this._sbScrollBar);
         _tText.wordWrap = true;
         _tText.multiline = true;
         _tText.mouseEnabled = true;
         _tText.mouseWheelEnabled = false;
         if(AirScanner.hasAir())
         {
            StageShareManager.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE,this.onWindowResize);
         }
      }
      
      public function get resetScroll() : Boolean
      {
         return this._bResetScroll;
      }
      
      public function set resetScroll(param1:Boolean) : void
      {
         this._bResetScroll = param1;
      }
      
      public function get scrollBarY() : int
      {
         return this._sbScrollBar.y;
      }
      
      public function set scrollBarY(param1:int) : void
      {
         this._sbScrollBar.y = param1;
      }
      
      public function get scrollBarX() : int
      {
         return this._sbScrollBar.x;
      }
      
      public function set scrollBarX(param1:int) : void
      {
         this._sbScrollBar.x = param1;
      }
      
      public function get scrollBottomMargin() : int
      {
         return this._scrollBottomMargin;
      }
      
      public function set scrollBottomMargin(param1:int) : void
      {
         this._scrollBottomMargin = param1;
         this._sbScrollBar.height = height - this._scrollTopMargin - this._scrollBottomMargin;
      }
      
      public function get scrollTopMargin() : int
      {
         return this._scrollTopMargin;
      }
      
      public function set scrollTopMargin(param1:int) : void
      {
         this._scrollTopMargin = param1;
         this._sbScrollBar.y = this._scrollTopMargin;
         this._sbScrollBar.height = height - this._scrollTopMargin - this._scrollBottomMargin;
      }
      
      public function set scrollCss(param1:Uri) : void
      {
         this._sbScrollBar.css = param1;
      }
      
      public function get scrollCss() : Uri
      {
         return this._sbScrollBar.css;
      }
      
      override public function set width(param1:Number) : void
      {
         if(!param1)
         {
            return;
         }
         _nWidth = param1;
         __width = param1;
         this.___width = param1;
         if(this._bFinalized && _autoResize)
         {
            resizeText();
         }
         _tText.textWidth;
         if(this._bFinalized)
         {
            this.updateScrollBarPos();
         }
      }
      
      override public function get width() : Number
      {
         return this.___width;
      }
      
      override public function set height(param1:Number) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1 != super.height || param1 != this._sbScrollBar.height - this._scrollTopMargin - this._scrollBottomMargin)
         {
            super.height = param1;
            _tText.textWidth;
            this._sbScrollBar.height = param1 - this._scrollTopMargin - this._scrollBottomMargin;
            if(this._bFinalized)
            {
               this.updateScrollBar();
            }
         }
      }
      
      override public function set text(param1:String) : void
      {
         super.text = param1;
         if(this._bFinalized)
         {
            this._skipScrollUpdate = true;
            this.updateScrollBar(this._bResetScroll);
         }
      }
      
      public function set scrollPos(param1:int) : void
      {
         this._nScrollPos = param1;
      }
      
      override public function set css(param1:Uri) : void
      {
         super.css = param1;
      }
      
      override public function set scrollV(param1:int) : void
      {
         super.scrollV = param1;
         if(this._bFinalized)
         {
            this.updateScrollBar();
         }
      }
      
      override public function get scrollV() : int
      {
         return super.scrollV;
      }
      
      override public function get finalized() : Boolean
      {
         return this._bFinalized && super.finalized;
      }
      
      override public function set finalized(param1:Boolean) : void
      {
         this._bFinalized = param1;
      }
      
      public function get hideScroll() : Boolean
      {
         return this._bHideScroll;
      }
      
      public function set hideScroll(param1:Boolean) : void
      {
         this._bHideScroll = param1;
      }
      
      override public function get htmlText() : String
      {
         return super.htmlText;
      }
      
      override public function set htmlText(param1:String) : void
      {
         super.htmlText = param1;
         if(this._bFinalized)
         {
            this._skipScrollUpdate = true;
            this.updateScrollBar();
         }
      }
      
      override public function appendText(param1:String, param2:String = null) : void
      {
         super.appendText(param1,param2);
         if(this._bFinalized)
         {
            this._skipScrollUpdate = true;
            this.updateScrollBar();
         }
      }
      
      override public function finalize() : void
      {
         this._sbScrollBar.finalize();
         this.updateScrollBarPos();
         this.updateScrollBar();
         this._bFinalized = true;
         super.finalize();
      }
      
      override public function free() : void
      {
         super.free();
         this._bFinalized = false;
         this._nScrollPos = 5;
         this.___width = 0;
         this._sbScrollBar.min = 1;
         this._sbScrollBar.max = 1;
         this._sbScrollBar.step = 1;
         _tText.wordWrap = true;
         _tText.multiline = true;
      }
      
      override public function remove() : void
      {
         if(this._sbScrollBar)
         {
            this._sbScrollBar.removeEventListener(Event.CHANGE,this.onScroll);
            this._sbScrollBar.remove();
         }
         this._sbScrollBar = null;
         _tText.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onTextWheel);
         if(AirScanner.hasAir())
         {
            StageShareManager.stage.removeEventListener(Event.FRAME_CONSTRUCTED,this.onFrameConstructed);
            StageShareManager.stage.nativeWindow.removeEventListener(NativeWindowBoundsEvent.RESIZE,this.onWindowResize);
         }
         super.remove();
      }
      
      override public function process(param1:Message) : Boolean
      {
         if(param1 is MouseWheelMessage && (this._sbScrollBar && this._sbScrollBar.visible))
         {
            return true;
         }
         return super.process(param1);
      }
      
      public function hideScrollBar() : void
      {
         this._sbScrollBar.visible = false;
      }
      
      protected function updateScrollBar(param1:Boolean = false, param2:Boolean = true) : void
      {
         _tText.getCharBoundaries(0);
         var _loc3_:Boolean = this._sbScrollBar.finalized;
         if(_tText.scrollV == 1 && _tText.bottomScrollV == _tText.numLines)
         {
            this._sbScrollBar.disabled = true;
            if(this._bHideScroll)
            {
               this._sbScrollBar.visible = false;
            }
            else
            {
               this._sbScrollBar.finalized = false;
               this._sbScrollBar.total = _tText.numLines;
               this._sbScrollBar.finalized = _loc3_;
               this._sbScrollBar.max = _tText.maxScrollV;
               this._sbScrollBar.value = 0;
            }
         }
         else
         {
            this._sbScrollBar.visible = true;
            this._sbScrollBar.disabled = false;
            if(_tText.height)
            {
               this._sbScrollBar.finalized = false;
               this._sbScrollBar.total = _tText.numLines;
               this._sbScrollBar.finalized = _loc3_;
               this._sbScrollBar.max = _tText.maxScrollV;
               if(param1)
               {
                  if(param2)
                  {
                     _tText.scrollV = 0;
                     this._sbScrollBar.value = 0;
                  }
                  else
                  {
                     _tText.scrollV = _tText.maxScrollV;
                     this._sbScrollBar.value = _tText.maxScrollV;
                  }
               }
               else if(!this._skipScrollUpdate)
               {
                  _tText.scrollV = _tText.maxScrollV;
                  this._sbScrollBar.value = _tText.maxScrollV;
               }
               else
               {
                  this._sbScrollBar.value = _tText.scrollV;
               }
            }
         }
         this._skipScrollUpdate = false;
      }
      
      protected function updateScrollBarPos() : void
      {
         _tText.width = this.width - this._sbScrollBar.width - this._scrollXOffset;
         if(this._nScrollPos >= 0)
         {
            this._sbScrollBar.x = this.width - this._sbScrollBar.width;
            _tText.x = 0;
         }
         else
         {
            this._sbScrollBar.x = 0;
            _tText.x = this._sbScrollBar.width + this._scrollXOffset;
         }
      }
      
      override protected function updateAlign() : void
      {
         if(this._sbScrollBar.disabled)
         {
            super.updateAlign();
         }
      }
      
      private function onTextWheel(param1:MouseEvent) : void
      {
         param1.delta = param1.delta * 3;
         this._sbScrollBar.onWheel(param1);
      }
      
      private function onScroll(param1:Event) : void
      {
         _tText.scrollV = this._sbScrollBar.value / this._sbScrollBar.max * _tText.maxScrollV;
      }
      
      private function onWindowResize(param1:NativeWindowBoundsEvent) : void
      {
         var _loc3_:GraphicElement = null;
         var _loc2_:UiRootContainer = getUi();
         if(_loc2_)
         {
            _loc3_ = _loc2_.getElementById(name);
            if(_loc3_ && _loc3_.locations && _loc3_.locations.length > 1)
            {
               return;
            }
         }
         StageShareManager.stage.addEventListener(Event.FRAME_CONSTRUCTED,this.onFrameConstructed);
      }
      
      private function onFrameConstructed(param1:Event) : void
      {
         StageShareManager.stage.removeEventListener(Event.FRAME_CONSTRUCTED,this.onFrameConstructed);
         if(this._bFinalized && this._sbScrollBar)
         {
            this.updateScrollBar();
         }
      }
   }
}
