package com.ankamagames.jerakine.utils.display
{
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.display.DisplayObjectContainer;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowDisplayState;
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.NativeWindowDisplayStateEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class StageShareManager
   {
      
      private static const NOT_INITIALIZED:int = -77777;
      
      private static var _stage:Stage;
      
      private static var _startWidth:uint;
      
      private static var _startHeight:uint;
      
      private static var _rootContainer:DisplayObjectContainer;
      
      private static var _customMouseX:int = NOT_INITIALIZED;
      
      private static var _customMouseY:int = NOT_INITIALIZED;
      
      private static var _setQualityIsEnable:Boolean;
      
      private static var _chrome:Point = new Point();
      
      private static var _mouseOnStage:Boolean;
      
      private static var _isActive:Boolean;
      
      public static var justExitFullScreen:Boolean = false;
      
      public static var shortcutUsedToExitFullScreen:Boolean = false;
      
      public static var stageLogicalBounds:Rectangle;
      
      private static const _stageVisibleBoundCache:Rectangle = new Rectangle();
      
      public static var isGoingFullScreen:Boolean = false;
       
      
      public function StageShareManager()
      {
         super();
      }
      
      public static function set rootContainer(param1:DisplayObjectContainer) : void
      {
         _rootContainer = param1;
      }
      
      public static function get rootContainer() : DisplayObjectContainer
      {
         return _rootContainer;
      }
      
      public static function get stage() : Stage
      {
         return _stage;
      }
      
      public static function get windowScale() : Number
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(AirScanner.hasAir())
         {
            _loc1_ = isFullscreen;
            _loc2_ = !!_loc1_?Number(0):Number(chrome.x);
            _loc3_ = !!_loc1_?Number(0):Number(chrome.y);
            _loc4_ = (stage.nativeWindow.width - _loc2_) / startWidth;
            _loc5_ = (stage.nativeWindow.height - _loc3_) / startHeight;
            _loc6_ = Math.min(_loc4_,_loc5_);
            return _loc6_;
         }
         return Math.min(stage.stageWidth / startWidth,stage.stageHeight / startHeight);
      }
      
      public static function get stageVisibleBounds() : Rectangle
      {
         var _loc1_:Boolean = false;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(AirScanner.hasAir())
         {
            _loc1_ = isFullscreen;
            _loc2_ = stage.nativeWindow.width - (!!_loc1_?0:chrome.x);
            _loc3_ = stage.nativeWindow.height - (!!_loc1_?0:chrome.y);
            _loc4_ = _loc2_ / startWidth;
            _loc5_ = _loc3_ / startHeight;
            if(_loc4_ > _loc5_)
            {
               _stageVisibleBoundCache.width = Math.max(_loc2_ / _loc5_,startWidth);
               _stageVisibleBoundCache.height = startHeight;
               _stageVisibleBoundCache.x = (startWidth - _stageVisibleBoundCache.width) / 2;
               _stageVisibleBoundCache.y = 0;
            }
            else
            {
               _stageVisibleBoundCache.width = startWidth;
               _stageVisibleBoundCache.height = Math.max(_loc3_ * _loc4_,startHeight);
               _stageVisibleBoundCache.x = 0;
               _stageVisibleBoundCache.y = (startHeight - _stageVisibleBoundCache.height) / 2;
            }
            if(_stageVisibleBoundCache.width > stageLogicalBounds.width)
            {
               _stageVisibleBoundCache.width = stageLogicalBounds.width;
            }
            _loc6_ = -(stageLogicalBounds.width - _startWidth) / 2;
            if(_stageVisibleBoundCache.x < _loc6_)
            {
               _stageVisibleBoundCache.x = _loc6_;
            }
         }
         else
         {
            _stageVisibleBoundCache.width = startWidth;
            _stageVisibleBoundCache.height = startHeight;
         }
         return _stageVisibleBoundCache;
      }
      
      public static function set stage(param1:Stage) : void
      {
         _stage = param1;
         _startWidth = 1280;
         _startHeight = 1024;
         stageLogicalBounds = new Rectangle(0,0,_startWidth,_startHeight);
         if(AirScanner.hasAir())
         {
            _stage["nativeWindow"].addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,displayStateChangeHandler);
         }
         _stage.addEventListener(Event.MOUSE_LEAVE,onStageMouseLeave);
         _stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
         _stage.addEventListener(Event.ACTIVATE,onActivate);
         _stage.addEventListener(Event.DEACTIVATE,onDeactivate);
      }
      
      public static function testQuality() : void
      {
         var _loc1_:String = _stage.quality;
         _stage.quality = StageQuality.MEDIUM;
         _setQualityIsEnable = _stage.quality.toLowerCase() == StageQuality.MEDIUM;
         _stage.quality = _loc1_;
      }
      
      public static function setFullScreen(param1:Boolean, param2:Boolean = false) : void
      {
         isGoingFullScreen = param1 && !param2;
         if(AirScanner.hasAir())
         {
            if(param1)
            {
               if(!param2)
               {
                  StageShareManager.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
               }
               else
               {
                  StageShareManager.stage["nativeWindow"].maximize();
               }
            }
            else if(isFullscreen)
            {
               if(!param2)
               {
                  StageShareManager.stage.displayState = StageDisplayState.NORMAL;
               }
               else
               {
                  StageShareManager.stage["nativeWindow"].minimize();
               }
            }
         }
         else if(AirScanner.isStreamingVersion())
         {
            try
            {
               StageShareManager.stage.displayState = !!param1?StageDisplayState.FULL_SCREEN_INTERACTIVE:StageDisplayState.NORMAL;
               return;
            }
            catch(error:Error)
            {
               return;
            }
         }
      }
      
      public static function get startWidth() : uint
      {
         return _startWidth;
      }
      
      public static function get startHeight() : uint
      {
         return _startHeight;
      }
      
      public static function get setQualityIsEnable() : Boolean
      {
         return _setQualityIsEnable;
      }
      
      public static function get mouseX() : int
      {
         if(_customMouseX == NOT_INITIALIZED)
         {
            return _rootContainer.mouseX;
         }
         return _customMouseX;
      }
      
      public static function set mouseX(param1:int) : void
      {
         _customMouseX = param1;
      }
      
      public static function get mouseY() : int
      {
         if(_customMouseY == NOT_INITIALIZED)
         {
            return _rootContainer.mouseY;
         }
         return _customMouseY;
      }
      
      public static function set mouseY(param1:int) : void
      {
         _customMouseY = param1;
      }
      
      public static function get stageOffsetX() : int
      {
         return _rootContainer.x;
      }
      
      public static function get stageOffsetY() : int
      {
         return _rootContainer.y;
      }
      
      public static function get stageScaleX() : Number
      {
         return _rootContainer.scaleX;
      }
      
      public static function get stageScaleY() : Number
      {
         return _rootContainer.scaleY;
      }
      
      public static function get mouseOnStage() : Boolean
      {
         return _mouseOnStage;
      }
      
      public static function get chrome() : Point
      {
         return _chrome;
      }
      
      public static function set chrome(param1:Point) : void
      {
         _chrome = param1;
      }
      
      public static function get isActive() : Boolean
      {
         return _isActive;
      }
      
      public static function get isFullscreen() : Boolean
      {
         return _stage.displayState.toLowerCase().indexOf("fullscreen") == 0;
      }
      
      private static function displayStateChangeHandler(param1:NativeWindowDisplayStateEvent) : void
      {
         var _loc2_:NativeWindow = null;
         if(param1.beforeDisplayState == NativeWindowDisplayState.MINIMIZED)
         {
            if(AirScanner.hasAir())
            {
               _loc2_ = _stage["nativeWindow"];
               if(param1.afterDisplayState == NativeWindowDisplayState.NORMAL)
               {
                  _loc2_.width = _loc2_.width - 1;
                  _loc2_.width = _loc2_.width + 1;
               }
            }
         }
      }
      
      private static function onStageMouseLeave(param1:Event) : void
      {
         _mouseOnStage = false;
      }
      
      private static function onStageMouseMove(param1:MouseEvent) : void
      {
         _mouseOnStage = true;
      }
      
      private static function onActivate(param1:Event) : void
      {
         _isActive = true;
      }
      
      private static function onDeactivate(param1:Event) : void
      {
         _isActive = false;
      }
   }
}
