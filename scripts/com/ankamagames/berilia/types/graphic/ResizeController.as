package com.ankamagames.berilia.types.graphic
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.types.data.Margin;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDownMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOutMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseReleaseOutsideMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseUpMessage;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.memory.WeakReference;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   
   public class ResizeController extends Sprite implements MessageHandler
   {
      
      public static var DEBUG_SHAPE:Boolean = false;
      
      private static var _currentResizeControler:ResizeController;
      
      private static var _busy:Boolean = false;
      
      private static var _previewContainer:Sprite;
       
      
      private var _lastWidth:int;
      
      private var _lastHeight:int;
      
      private var _mouseX:int;
      
      private var _mouseY:int;
      
      private var _startWidth:int;
      
      private var _startHeight:int;
      
      private var _startX:Number;
      
      private var _startY:Number;
      
      private var _resizing:Boolean;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _margin:Margin;
      
      private var _controler:WeakReference;
      
      private var _target:WeakReference;
      
      private var _targetId:String;
      
      private var _stageBounds:Rectangle;
      
      private var _canUseVerticalResize:Boolean = true;
      
      private var _canUseHorizontalResize:Boolean = true;
      
      private var _verticalResize:Boolean;
      
      private var _horizontalResize:Boolean;
      
      private var _topLeft:Border;
      
      private var _top:Border;
      
      private var _topRight:Border;
      
      private var _left:Border;
      
      private var _right:Border;
      
      private var _bottomLeft:Border;
      
      private var _bottom:Border;
      
      private var _bottomRight:Border;
      
      private var _currentBorder:Border;
      
      private var _nextCursorId:String;
      
      public function ResizeController()
      {
         this._margin = new Margin(5,5,5,5);
         super();
         var _loc1_:uint = 16711935;
         var _loc2_:Number = 0.8;
         this._topLeft = this.configShape(0,0,1,1,null,true,true,"resizeR");
         this._top = this.configShape(0,0,1,1,null,false,true,"resizeV");
         this._topRight = this.configShape(0,0,1,1,null,true,true,"resizeL");
         this._left = this.configShape(0,0,1,1,null,true,false,"resizeH");
         this._right = this.configShape(0,0,1,1,null,true,false,"resizeH");
         this._bottomLeft = this.configShape(0,0,1,1,null,true,true,"resizeL");
         this._bottom = this.configShape(0,0,1,1,null,false,true,"resizeV");
         this._bottomRight = this.configShape(0,0,1,1,null,true,true,"resizeR");
         mouseEnabled = false;
      }
      
      public static function get busy() : Boolean
      {
         return _currentResizeControler != null;
      }
      
      public function get target() : String
      {
         return this._targetId;
      }
      
      public function set target(param1:String) : void
      {
         this._targetId = param1;
      }
      
      private function get targetContainer() : GraphicContainer
      {
         if(this._target && (this._targetId == null || this._target.object.name == this._targetId))
         {
            return this._target.object;
         }
         var _loc1_:GraphicContainer = this.controler.getUi().getElement(this._targetId);
         if(!_loc1_)
         {
            return null;
         }
         if(this._target)
         {
            this._target.destroy();
         }
         this._target = new WeakReference(_loc1_);
         return _loc1_;
      }
      
      public function get controler() : GraphicContainer
      {
         return this._controler.object;
      }
      
      public function set controler(param1:GraphicContainer) : void
      {
         if(this._controler)
         {
            this._controler.destroy();
         }
         this._controler = new WeakReference(param1);
         if(!this._target)
         {
            this._target = new WeakReference(param1);
         }
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = param1;
         this.draw();
      }
      
      override public function set height(param1:Number) : void
      {
         this._height = param1;
         this.draw();
      }
      
      override public function get width() : Number
      {
         return !!isNaN(this._width)?Number(super.width):Number(this._width);
      }
      
      override public function get height() : Number
      {
         return !!isNaN(this._height)?Number(super.height):Number(this._height);
      }
      
      public function update() : void
      {
         this.draw();
      }
      
      public function process(param1:Message) : Boolean
      {
         if(_currentResizeControler && _currentResizeControler != this || !(param1 is MouseMessage) || DragControler.busy)
         {
            return false;
         }
         var _loc2_:MouseMessage = param1 as MouseMessage;
         switch(true)
         {
            case _loc2_ is MouseDownMessage:
               if(_loc2_.target is Border)
               {
                  this._currentBorder = _loc2_.target as Border;
                  this.resizeStart();
               }
               break;
            case _loc2_ is MouseReleaseOutsideMessage:
            case _loc2_ is MouseUpMessage:
               if(this._resizing)
               {
                  this.resizeEnd();
               }
               break;
            case _loc2_ is MouseOverMessage:
               if(_loc2_.target is Border)
               {
                  this._nextCursorId = Border(_loc2_.target).cursorId;
               }
               else
               {
                  this._nextCursorId = MouseCursor.AUTO;
               }
               break;
            case _loc2_ is MouseOutMessage:
               if(_loc2_.target is Border)
               {
                  this._nextCursorId = MouseCursor.AUTO;
               }
         }
         if(!this._resizing && this._nextCursorId)
         {
            Mouse.cursor = this._nextCursorId;
            this._nextCursorId = null;
         }
         return false;
      }
      
      public function destroy() : void
      {
         EnterFrameDispatcher.removeEventListener(this.onEnterFrame);
      }
      
      private function draw() : void
      {
         this.configShape(0,0,this._margin.left,this._margin.top,this._topLeft);
         this.configShape(this._margin.left,0,this.width - this._margin.left - this._margin.right,this._margin.top,this._top);
         this.configShape(this.width - this._margin.right,0,this._margin.left,this._margin.top,this._topRight);
         this.configShape(0,this._margin.top,this._margin.left,this.height - this._margin.top - this._margin.bottom,this._left);
         this.configShape(this.width - this._margin.right,this._margin.top,this._margin.right,this.height - this._margin.top - this._margin.bottom,this._right);
         this.configShape(0,this.height - this._margin.bottom,this._margin.left,this._margin.bottom,this._bottomLeft);
         this.configShape(this._margin.left,this.height - this._margin.bottom,this.width - this._margin.left - this._margin.right,this._margin.bottom,this._bottom);
         this.configShape(this.width - this._margin.right,this.height - this._margin.bottom,this._margin.right,this._margin.bottom,this._bottomRight);
      }
      
      private function resizeStart() : void
      {
         this._resizing = true;
         _currentResizeControler = this;
         this._mouseX = StageShareManager.mouseX;
         this._mouseY = StageShareManager.mouseY;
         this._stageBounds = StageShareManager.stageVisibleBounds;
         this._startWidth = this.targetContainer.width;
         this._startHeight = this.targetContainer.height;
         this._startX = this.targetContainer.x;
         this._startY = this.targetContainer.y;
         this._horizontalResize = this._currentBorder.horizontalResize && this._canUseHorizontalResize;
         this._verticalResize = this._currentBorder.verticalResize && this._canUseVerticalResize;
         if(!this._horizontalResize && !this._verticalResize)
         {
            this._horizontalResize = true;
            this._verticalResize = true;
         }
         this.togglePreviewContainer(true);
         EnterFrameDispatcher.addEventListener(this.onEnterFrame,"GraphicContainer");
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Number = Math.min(this._stageBounds.right,Math.max(this._stageBounds.left,StageShareManager.mouseX));
         var _loc3_:Number = Math.min(this._stageBounds.bottom,Math.max(this._stageBounds.top,StageShareManager.mouseY));
         var _loc4_:GraphicContainer = this.targetContainer;
         var _loc5_:Number = this._startX;
         var _loc6_:Number = this._startY;
         var _loc7_:int = this.targetContainer.width;
         var _loc8_:int = this.targetContainer.height;
         switch(this._currentBorder)
         {
            case this._topLeft:
               _loc5_ = this._startX + _loc2_ - this._mouseX;
               _loc6_ = this._startY + _loc3_ - this._mouseY;
               _loc7_ = this._startWidth + this._mouseX - _loc2_;
               _loc8_ = this._startHeight + this._mouseY - _loc3_;
               break;
            case this._top:
               _loc6_ = this._startY + _loc3_ - this._mouseY;
               _loc8_ = this._startHeight + this._mouseY - _loc3_;
               break;
            case this._topRight:
               _loc6_ = this._startY + _loc3_ - this._mouseY;
               _loc7_ = this._startWidth + _loc2_ - this._mouseX;
               _loc8_ = this._startHeight + this._mouseY - _loc3_;
               break;
            case this._left:
               _loc5_ = this._startX + _loc2_ - this._mouseX;
               _loc7_ = this._startWidth + this._mouseX - _loc2_;
               break;
            case this._right:
               _loc7_ = this._startWidth + _loc2_ - this._mouseX;
               break;
            case this._bottomLeft:
               _loc5_ = this._startX + _loc2_ - this._mouseX;
               _loc7_ = this._startWidth + this._mouseX - _loc2_;
               _loc8_ = this._startHeight + _loc3_ - this._mouseY;
               break;
            case this._bottom:
               _loc8_ = this._startHeight + _loc3_ - this._mouseY;
               break;
            case this._bottomRight:
               _loc8_ = this._startHeight + _loc3_ - this._mouseY;
               _loc7_ = this._startWidth + _loc2_ - this._mouseX;
         }
         if(_loc4_.minSize != null)
         {
            if(!isNaN(_loc4_.minSize.x) && _loc7_ < _loc4_.minSize.x)
            {
               _loc7_ = _loc4_.minSize.x;
            }
            if(!isNaN(_loc4_.minSize.y) && _loc8_ < _loc4_.minSize.y)
            {
               _loc8_ = _loc4_.minSize.y;
            }
         }
         if(_loc4_.maxSize != null)
         {
            if(!isNaN(_loc4_.maxSize.x) && _loc7_ > _loc4_.maxSize.x)
            {
               _loc7_ = _loc4_.maxSize.x;
            }
            if(!isNaN(_loc4_.maxSize.y) && _loc8_ > _loc4_.maxSize.y)
            {
               _loc8_ = _loc4_.maxSize.y;
            }
         }
         var _loc9_:Boolean = false;
         _loc4_.getUi()._lock = true;
         if(this._horizontalResize && _loc4_.width != _loc7_)
         {
            _loc4_.xNoCache = _loc5_;
            _loc4_.widthNoCache = _loc7_;
            _loc9_ = true;
         }
         if(this._verticalResize && _loc4_.height != _loc8_)
         {
            _loc4_.yNoCache = _loc6_;
            _loc4_.heightNoCache = _loc8_;
            _loc9_ = true;
         }
         _loc4_.getUi()._lock = false;
         if(_loc9_)
         {
            _loc4_.setSavedDimension(_loc4_.width,_loc4_.height);
            _loc4_.setSavedPosition(_loc4_.x,_loc4_.y);
            try
            {
               _loc4_.getUi().render();
               return;
            }
            catch(err:Error)
            {
               return;
            }
         }
      }
      
      private function resizeEnd() : void
      {
         _currentResizeControler = null;
         EnterFrameDispatcher.removeEventListener(this.onEnterFrame);
         this._resizing = false;
         if(this._nextCursorId)
         {
            Mouse.cursor = this._nextCursorId;
            this._nextCursorId = null;
         }
         this.togglePreviewContainer(false);
         if(this._mouseX != StageShareManager.mouseX || this._mouseY != StageShareManager.mouseY)
         {
            this.targetContainer.getUi().render();
         }
      }
      
      private function configShape(param1:int, param2:int, param3:int, param4:int, param5:Border = null, param6:Boolean = false, param7:Boolean = false, param8:String = null) : Border
      {
         if(param5 == null)
         {
            param5 = new Border();
            param5.graphics.beginFill(16777215 * Math.random(),!!DEBUG_SHAPE?Number(0.8):Number(0));
            param5.graphics.drawRect(0,0,1,1);
            param5.graphics.endFill();
            param5.cursorId = param8;
            param5.horizontalResize = param6;
            param5.verticalResize = param7;
            addChild(param5);
         }
         param5.x = param1;
         param5.y = param2;
         param5.width = param3;
         param5.height = param4;
         return param5;
      }
      
      private function togglePreviewContainer(param1:Boolean) : void
      {
         var _loc2_:Rectangle = null;
         if(param1)
         {
            _loc2_ = StageShareManager.stageVisibleBounds;
            if(!_previewContainer)
            {
               _previewContainer = new Sprite();
            }
            else
            {
               _previewContainer.graphics.clear();
            }
            _previewContainer.graphics.beginFill(0,0);
            _previewContainer.graphics.drawRect(_loc2_.left,_loc2_.top,_loc2_.width,_loc2_.height);
            _previewContainer.graphics.endFill();
            Berilia.getInstance().docMain.addChildAt(_previewContainer,0);
         }
         else if(_previewContainer && _previewContainer.parent)
         {
            _previewContainer.parent.removeChild(_previewContainer);
            _previewContainer = null;
         }
      }
   }
}

import flash.display.Sprite;

class Border extends Sprite
{
    
   
   public var cursorId:String;
   
   public var verticalResize:Boolean;
   
   public var horizontalResize:Boolean;
   
   function Border()
   {
      super();
   }
}
