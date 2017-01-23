package com.ankamagames.berilia.types.graphic
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDoubleClickMessage;
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
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.utils.Dictionary;
   
   public class DragControler implements MessageHandler
   {
      
      private static var _previewContainer:Sprite;
      
      private static var _currentDragControler:DragControler;
       
      
      private var _dragControlCount:uint;
      
      private var _startDragPosition:Point;
      
      private var _visibleBounds:Rectangle;
      
      private var _currentBounds:Rectangle;
      
      private var _dragRestrictedArea:Rectangle;
      
      private var _indexInParentBeforeDrag:int;
      
      private var _boundsContainerId:String;
      
      private var _boundsContainer:WeakReference;
      
      private var _controler:WeakReference;
      
      private var _target:WeakReference;
      
      private var _targetId:String;
      
      private var _utilPoint:Point;
      
      private var _magneticUiRect:Vector.<MagnetGrid>;
      
      public var useDragMagnetism:Boolean;
      
      public var verticalDrag:Boolean = true;
      
      public var horizontalDrag:Boolean = true;
      
      public var savePosition:Boolean = true;
      
      private var mousePositionOnMouseDown:Point;
      
      public function DragControler()
      {
         this._utilPoint = new Point();
         this.mousePositionOnMouseDown = new Point();
         super();
      }
      
      public static function get busy() : Boolean
      {
         return _currentDragControler != null;
      }
      
      public function get boundsContainer() : String
      {
         return this._boundsContainerId;
      }
      
      public function set boundsContainer(param1:String) : void
      {
         this._boundsContainerId = param1;
      }
      
      private function get boundsContainerRef() : GraphicContainer
      {
         if(this._boundsContainerId == null)
         {
            return this.targetContainer;
         }
         if(this._boundsContainer && (this._boundsContainerId == null || this._boundsContainer.object.name == this._boundsContainerId))
         {
            return this._boundsContainer.object;
         }
         var _loc1_:GraphicContainer = this.controler.getUi().getElement(this._boundsContainerId);
         if(!_loc1_)
         {
            return null;
         }
         if(this._boundsContainer)
         {
            this._boundsContainer.destroy();
         }
         this._boundsContainer = new WeakReference(_loc1_);
         return _loc1_;
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
            if(this._controler.object)
            {
               this._controler.object.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
               this._controler.object.removeEventListener("releaseOutside",this.onMouseUp);
               this._controler.object.removeEventListener(MouseEvent.DOUBLE_CLICK,this.onMouseDlbClick);
            }
            this._controler.destroy();
         }
         if(param1)
         {
            this._controler = new WeakReference(param1);
            if(!this._target)
            {
               this._target = new WeakReference(param1);
            }
            param1.mouseEnabled = true;
         }
      }
      
      public function restrictPosition() : void
      {
         var _loc2_:Point = null;
         if(!this._startDragPosition || !_currentDragControler)
         {
            this.setupDragVars();
         }
         this._utilPoint.x = this.targetContainer.x;
         this._utilPoint.y = this.targetContainer.y;
         var _loc1_:Point = this.targetContainer.parent.localToGlobal(this._utilPoint);
         this._currentBounds.x = _loc1_.x;
         this._currentBounds.y = _loc1_.y;
         if(!this._dragRestrictedArea.containsRect(this._currentBounds))
         {
            this._utilPoint.x = this._dragRestrictedArea.x;
            this._utilPoint.y = this._dragRestrictedArea.y;
            _loc2_ = this.targetContainer.parent.globalToLocal(this._utilPoint);
            if(this._currentBounds.x < this._dragRestrictedArea.x)
            {
               this.targetContainer.xNoCache = _loc2_.x;
            }
            else if(this._currentBounds.x > this._dragRestrictedArea.right)
            {
               this.targetContainer.xNoCache = this._dragRestrictedArea.width + _loc2_.x;
            }
            if(this._currentBounds.y < this._dragRestrictedArea.y)
            {
               this.targetContainer.yNoCache = _loc2_.y;
            }
            else if(this._currentBounds.y > this._dragRestrictedArea.bottom)
            {
               this.targetContainer.yNoCache = this._dragRestrictedArea.height + _loc2_.y;
            }
            if(this._currentBounds.x > this._dragRestrictedArea.right - 128 && this._currentBounds.y < 32)
            {
               this.targetContainer.yNoCache = 32;
            }
         }
      }
      
      public function process(param1:Message) : Boolean
      {
         if(!(param1 is MouseMessage) || ResizeController.busy)
         {
            return false;
         }
         var _loc2_:MouseMessage = param1 as MouseMessage;
         switch(true)
         {
            case _loc2_ is MouseDownMessage:
               this.onMouseDown(null);
               break;
            case _loc2_ is MouseReleaseOutsideMessage:
            case _loc2_ is MouseUpMessage:
               this.onMouseUp(null);
               break;
            case _loc2_ is MouseDoubleClickMessage:
               this.onMouseDlbClick(null);
               break;
            case _loc2_ is MouseOverMessage:
               if(_loc2_.target == this.controler)
               {
                  Mouse.cursor = "drag";
               }
               break;
            case _loc2_ is MouseOutMessage:
               if(_loc2_.target == this.controler)
               {
                  Mouse.cursor = "auto";
               }
         }
         return false;
      }
      
      private function setupDragVars() : void
      {
         var _loc2_:UiRootContainer = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Array = null;
         var _loc6_:GraphicContainer = null;
         this._startDragPosition = new Point();
         this._visibleBounds = this.boundsContainerRef.getBounds(StageShareManager.stage);
         this._currentBounds = this._visibleBounds.clone();
         this._dragRestrictedArea = StageShareManager.stageVisibleBounds.clone();
         this._magneticUiRect = new Vector.<MagnetGrid>();
         var _loc1_:Dictionary = Berilia.getInstance().uiList;
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_ != this.targetContainer.getUi())
            {
               _loc5_ = _loc2_.magneticElements;
               for each(_loc6_ in _loc5_)
               {
                  this._magneticUiRect.push(new MagnetGrid(_loc6_.getBounds(StageShareManager.stage)));
               }
            }
         }
         _loc3_ = 40;
         _loc4_ = 40;
         this._magneticUiRect.push(new MagnetGrid(new Rectangle(this._dragRestrictedArea.left - 1,this._dragRestrictedArea.top - 1,1,1),new Rectangle(this._dragRestrictedArea.left,this._dragRestrictedArea.top,_loc3_,_loc4_),true,true,false));
         this._magneticUiRect.push(new MagnetGrid(new Rectangle(this._dragRestrictedArea.right + 1,this._dragRestrictedArea.bottom + 1,1,1),new Rectangle(this._dragRestrictedArea.right - _loc3_,this._dragRestrictedArea.bottom - _loc4_,_loc3_,_loc4_),true,true,false));
         this._magneticUiRect.push(new MagnetGrid(new Rectangle(this._dragRestrictedArea.left - 1,this._dragRestrictedArea.bottom + 1,1,1),new Rectangle(this._dragRestrictedArea.left,this._dragRestrictedArea.bottom - _loc4_,_loc3_,_loc4_),true,true,false));
         this._magneticUiRect.push(new MagnetGrid(new Rectangle(this._dragRestrictedArea.left - 1,this._dragRestrictedArea.top,1,this._dragRestrictedArea.height),new Rectangle(this._dragRestrictedArea.left,this._dragRestrictedArea.top,_loc3_,this._dragRestrictedArea.height),true,false,false));
         this._magneticUiRect.push(new MagnetGrid(new Rectangle(this._dragRestrictedArea.right + 1,this._dragRestrictedArea.top,1,this._dragRestrictedArea.height),new Rectangle(this._dragRestrictedArea.right - _loc3_,this._dragRestrictedArea.top,_loc3_,this._dragRestrictedArea.height),true,false,false));
         this._magneticUiRect.push(new MagnetGrid(new Rectangle(this._dragRestrictedArea.left + _loc3_,this._dragRestrictedArea.top - 1,this._dragRestrictedArea.width - _loc3_ * 2,1),new Rectangle(this._dragRestrictedArea.left + _loc3_,this._dragRestrictedArea.top,this._dragRestrictedArea.width - _loc3_ * 2,_loc4_),false,true,false));
         this._magneticUiRect.push(new MagnetGrid(new Rectangle(this._dragRestrictedArea.left + _loc3_,this._dragRestrictedArea.bottom + 1,this._dragRestrictedArea.width - _loc3_ * 2,1),new Rectangle(this._dragRestrictedArea.left + _loc3_,this._dragRestrictedArea.bottom - _loc4_,this._dragRestrictedArea.width - _loc3_ * 2,_loc4_ / 2),false,true,false));
         this._dragRestrictedArea.width = this._dragRestrictedArea.width - this._visibleBounds.width;
         this._dragRestrictedArea.height = this._dragRestrictedArea.height - this._visibleBounds.height;
      }
      
      private function getMagneticResult(param1:Boolean = true) : Rectangle
      {
         var _loc2_:Rectangle = null;
         var _loc5_:MagnetGrid = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Point = null;
         if(!this._magneticUiRect || this._magneticUiRect.length == 0)
         {
            return null;
         }
         if(this.targetContainer.getUi().magneticElements.length)
         {
            _loc2_ = this.targetContainer.getUi().magneticElements[0].getBounds(StageShareManager.stage);
         }
         else
         {
            _loc2_ = this.boundsContainerRef.getBounds(StageShareManager.stage);
         }
         var _loc3_:uint = 0;
         var _loc4_:MagnetGrid = null;
         for each(_loc5_ in this._magneticUiRect)
         {
            _loc6_ = _loc5_.collidArea.intersection(_loc2_);
            if(_loc6_.width * _loc6_.height > _loc3_ && (!_loc4_ || _loc5_.hasSortPriority))
            {
               _loc3_ = _loc6_.width * _loc6_.height;
               _loc4_ = _loc5_;
            }
         }
         if(_loc3_ != 0)
         {
            _loc7_ = this.getNewPosition(_loc2_,_loc4_);
            if(param1)
            {
               this._utilPoint.x = this.targetContainer.x;
               this._utilPoint.y = this.targetContainer.y;
               _loc8_ = this.targetContainer.localToGlobal(this._utilPoint);
               if(this.horizontalDrag)
               {
                  _loc7_.x = _loc7_.x + (_loc8_.x - _loc2_.x);
               }
               if(this.verticalDrag)
               {
                  _loc7_.y = _loc7_.y + (_loc8_.y - _loc2_.y);
               }
               if(this.targetContainer.getUi().fullscreen)
               {
                  if(this.horizontalDrag)
                  {
                     _loc7_.x = _loc7_.x - StageShareManager.stageVisibleBounds.left;
                  }
                  if(this.verticalDrag)
                  {
                     _loc7_.y = _loc7_.y - StageShareManager.stageVisibleBounds.top;
                  }
               }
            }
            return _loc7_;
         }
         return null;
      }
      
      private function getNewPosition(param1:Rectangle, param2:MagnetGrid) : Rectangle
      {
         var _loc3_:Rectangle = new Rectangle(param1.x,param1.y,param1.width,param1.height);
         var _loc4_:Point = new Point(param1.x + param1.width / 2,param1.y + param1.height / 2);
         var _loc5_:Point = new Point(param2.rect.x + param2.rect.width / 2,param2.rect.y + param2.rect.height / 2);
         var _loc6_:Rectangle = param2.collidArea.intersection(param1);
         if(_loc6_.width > _loc6_.height)
         {
            if(param2.magnetX && this.horizontalDrag)
            {
               if(_loc4_.x > _loc5_.x == param1.width < param2.rect.width)
               {
                  _loc3_.x = param2.rect.x + param2.rect.width - param1.width;
               }
               else
               {
                  _loc3_.x = param2.rect.x;
               }
            }
            if(this.verticalDrag)
            {
               if(_loc4_.y > _loc5_.y)
               {
                  _loc3_.y = param2.rect.y + param2.rect.height;
               }
               else
               {
                  _loc3_.y = param2.rect.y - param1.height;
               }
            }
         }
         else
         {
            if(param2.magnetY && this.verticalDrag)
            {
               if(_loc4_.y > _loc5_.y == param1.height < param2.rect.height)
               {
                  _loc3_.y = param2.rect.y + param2.rect.height - param1.height;
               }
               else
               {
                  _loc3_.y = param2.rect.y;
               }
            }
            if(this.horizontalDrag)
            {
               if(_loc4_.x > _loc5_.x)
               {
                  _loc3_.x = param2.rect.x + param2.rect.width;
               }
               else
               {
                  _loc3_.x = param2.rect.x - param1.width;
               }
            }
         }
         return _loc3_;
      }
      
      private function drawShape(param1:Rectangle, param2:uint, param3:Number) : Shape
      {
         var _loc4_:Shape = new Shape();
         _loc4_.graphics.beginFill(param2,param3);
         _loc4_.graphics.drawRect(param1.x,param1.y,param1.width,param1.height);
         _loc4_.graphics.endFill();
         return _loc4_;
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
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         if(ResizeController.busy)
         {
            return;
         }
         this.togglePreviewContainer(true);
         this.setupDragVars();
         _currentDragControler = this;
         this.targetContainer.cacheAsBitmap = true;
         this.mousePositionOnMouseDown.x = StageShareManager.mouseX;
         this.mousePositionOnMouseDown.y = StageShareManager.mouseY;
         this._startDragPosition.x = StageShareManager.mouseX - this.targetContainer.x;
         this._startDragPosition.y = StageShareManager.mouseY - this.targetContainer.y;
         if(this.targetContainer.parent)
         {
            this._indexInParentBeforeDrag = this.targetContainer.parent.getChildIndex(this.targetContainer);
            this.targetContainer.parent.setChildIndex(this.targetContainer,this.targetContainer.parent.numChildren - 1);
         }
         EnterFrameDispatcher.addEventListener(this.onEnterframe,"refreshDragUi");
      }
      
      private function onMouseUp(param1:Event) : void
      {
         var _loc2_:Rectangle = null;
         if(EnterFrameDispatcher.hasEventListener(this.onEnterframe))
         {
            _currentDragControler = null;
            this.targetContainer.cacheAsBitmap = false;
            if(this.horizontalDrag)
            {
               this.targetContainer.xNoCache = Math.round(StageShareManager.mouseX - this._startDragPosition.x);
            }
            if(this.verticalDrag)
            {
               this.targetContainer.yNoCache = Math.round(StageShareManager.mouseY - this._startDragPosition.y);
            }
            if(this.useDragMagnetism)
            {
               _loc2_ = this.getMagneticResult();
               if(_loc2_)
               {
                  if(this.horizontalDrag)
                  {
                     this.targetContainer.xNoCache = _loc2_.x;
                  }
                  if(this.verticalDrag)
                  {
                     this.targetContainer.yNoCache = _loc2_.y;
                  }
               }
            }
            this.restrictPosition();
            if(this.savePosition)
            {
               this.targetContainer.setSavedPosition(this.targetContainer.x,this.targetContainer.y);
            }
            this.targetContainer.parent.setChildIndex(this.targetContainer,this._indexInParentBeforeDrag);
            this.togglePreviewContainer(false);
            EnterFrameDispatcher.removeEventListener(this.onEnterframe);
         }
      }
      
      private function onMouseDlbClick(param1:Event) : void
      {
         Berilia.getInstance().resetUiSavedUserModification(this.targetContainer.getUi().name);
      }
      
      private function onEnterframe(param1:Event) : void
      {
         var _loc3_:Rectangle = null;
         if(this.mousePositionOnMouseDown.x == StageShareManager.mouseX && this.mousePositionOnMouseDown.y == StageShareManager.mouseY)
         {
            return;
         }
         if(this.horizontalDrag)
         {
            this.targetContainer.xNoCache = Math.round(StageShareManager.mouseX - this._startDragPosition.x);
         }
         if(this.verticalDrag)
         {
            this.targetContainer.yNoCache = Math.round(StageShareManager.mouseY - this._startDragPosition.y);
         }
         if(this.useDragMagnetism)
         {
            _loc3_ = this.getMagneticResult(false);
            while(_previewContainer.numChildren)
            {
               _previewContainer.removeChildAt(0);
            }
            if(_loc3_)
            {
               _previewContainer.addChild(this.drawShape(_loc3_,0,0.5));
            }
         }
         this.restrictPosition();
         var _loc2_:UiRootContainer = this.targetContainer.getUi();
         if(_loc2_ && _loc2_.uiClass && _loc2_.uiClass.hasOwnProperty("dragUpdate"))
         {
            _loc2_.uiClass.dragUpdate();
         }
      }
      
      public function destroy() : void
      {
         this.controler = null;
         _currentDragControler = null;
         if(EnterFrameDispatcher.hasEventListener(this.onEnterframe))
         {
            EnterFrameDispatcher.removeEventListener(this.onEnterframe);
         }
      }
   }
}

import flash.geom.Rectangle;

class MagnetGrid
{
    
   
   public var rect:Rectangle;
   
   public var collidArea:Rectangle;
   
   public var magnetX:Boolean = true;
   
   public var magnetY:Boolean = true;
   
   public var hasSortPriority:Boolean = true;
   
   function MagnetGrid(param1:Rectangle, param2:Rectangle = null, param3:Boolean = true, param4:Boolean = true, param5:Boolean = true)
   {
      super();
      this.rect = param1;
      this.collidArea = !!param2?param2:param1;
      this.magnetX = param3;
      this.magnetY = param4;
      this.hasSortPriority = param5;
   }
}
