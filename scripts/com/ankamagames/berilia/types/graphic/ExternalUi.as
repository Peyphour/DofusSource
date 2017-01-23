package com.ankamagames.berilia.types.graphic
{
   import com.ankamagames.berilia.managers.ExternalUiManager;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.jerakine.handlers.HumanInputHandler;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowInitOptions;
   import flash.display.NativeWindowSystemChrome;
   import flash.display.NativeWindowType;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.MouseEvent;
   
   public class ExternalUi extends NativeWindow
   {
       
      
      private var _mainContainer:Sprite;
      
      private var _uiRootContainer:UiRootContainer;
      
      private var _sizeControler:DisplayObject;
      
      private const margin:uint = 10;
      
      public function ExternalUi()
      {
         var _loc1_:NativeWindowInitOptions = new NativeWindowInitOptions();
         _loc1_.systemChrome = NativeWindowSystemChrome.NONE;
         _loc1_.type = NativeWindowType.NORMAL;
         _loc1_.resizable = false;
         _loc1_.transparent = true;
         alwaysInFront = true;
         super(_loc1_);
         visible = false;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         HumanInputHandler.getInstance().registerListeners(stage);
         ExternalUiManager.getInstance().registerExternalUi(this);
         this._mainContainer = new Sprite();
         stage.addChild(this._mainContainer);
      }
      
      public function set uiRootContainer(param1:UiRootContainer) : void
      {
         while(this._mainContainer.numChildren)
         {
            this._mainContainer.removeChildAt(0);
         }
         if(this._uiRootContainer)
         {
            this._uiRootContainer.windowOwner = null;
         }
         this._sizeControler = param1;
         this._uiRootContainer = param1;
         param1.windowOwner = this;
         this._uiRootContainer.addEventListener(UiRenderEvent.UIRenderComplete,this.onUiRendered);
         this._mainContainer.addChild(param1);
      }
      
      public function get uiRootContainer() : UiRootContainer
      {
         return this._uiRootContainer;
      }
      
      public function set sizeControler(param1:DisplayObject) : void
      {
         if(param1 == null)
         {
            this._sizeControler = this._uiRootContainer;
         }
         else
         {
            this._sizeControler = param1;
         }
      }
      
      public function addDragController(param1:InteractiveObject) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownForDrag,false,0,true);
         param1.mouseEnabled = true;
      }
      
      public function removeDragController(param1:InteractiveObject) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownForDrag);
      }
      
      public function addResizeControler(param1:InteractiveObject) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownForResize,false,0,true);
      }
      
      public function removeResizeControler(param1:InteractiveObject) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownForResize);
      }
      
      protected function onUiRendered(param1:UiRenderEvent) : void
      {
         visible = true;
         width = this._sizeControler.width + this.margin * 2;
         height = this._sizeControler.width + this.margin * 2;
         this.colorUi(this._uiRootContainer);
         var _loc2_:GraphicContainer = Sprite(this._uiRootContainer.getChildAt(0)).getChildAt(0) as GraphicContainer;
         x = _loc2_.x + StageShareManager.stage.nativeWindow.x + this.margin;
         y = _loc2_.y + StageShareManager.stage.nativeWindow.y + this.margin;
         _loc2_.x = 0;
         _loc2_.y = 0;
      }
      
      private function exploreUi(param1:DisplayObject, param2:String = "") : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:uint = 0;
         trace(param2 + param1.name + ", " + param1.width + "x" + param1.height + ", " + param1.x + " / " + param1.y);
         if(param1 is DisplayObjectContainer)
         {
            _loc3_ = param1 as DisplayObjectContainer;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.numChildren)
            {
               this.exploreUi(_loc3_.getChildAt(_loc4_),param2 + ".   ");
               _loc4_++;
            }
         }
      }
      
      private function colorUi(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         var _loc3_:uint = 0;
         var _loc4_:Shape = null;
         if(param1 is DisplayObjectContainer)
         {
            _loc2_ = param1 as DisplayObjectContainer;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.numChildren)
            {
               this.exploreUi(_loc2_.getChildAt(_loc3_));
               _loc3_++;
            }
         }
         if(param1 is Sprite)
         {
            _loc4_ = new Shape();
            _loc4_.graphics.beginFill(16777215 * Math.random(),0.4);
            _loc4_.graphics.drawRect(param1.x,param1.y,param1.width,param1.height);
            _loc4_.graphics.endFill();
            Sprite(param1).addChild(_loc4_);
         }
      }
      
      protected function onMouseOver(param1:MouseEvent) : void
      {
      }
      
      protected function onMouseDownForResize(param1:MouseEvent) : void
      {
         this.startResize();
      }
      
      protected function onMouseDownForDrag(param1:MouseEvent) : void
      {
         this.startMove();
      }
      
      public function destroy() : void
      {
         this._uiRootContainer.removeEventListener(UiRenderEvent.UIRenderComplete,this.onUiRendered);
         close();
      }
   }
}
