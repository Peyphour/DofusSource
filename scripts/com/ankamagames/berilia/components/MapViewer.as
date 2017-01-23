package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.components.messages.MapElementRightClickMessage;
   import com.ankamagames.berilia.components.messages.MapElementRollOutMessage;
   import com.ankamagames.berilia.components.messages.MapElementRollOverMessage;
   import com.ankamagames.berilia.components.messages.MapMoveMessage;
   import com.ankamagames.berilia.components.messages.MapRollOutMessage;
   import com.ankamagames.berilia.components.messages.MapRollOverMessage;
   import com.ankamagames.berilia.components.messages.TextureReadyMessage;
   import com.ankamagames.berilia.frames.ShortcutsFrame;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.berilia.types.data.Map;
   import com.ankamagames.berilia.types.data.MapArea;
   import com.ankamagames.berilia.types.data.MapElement;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.MapAreaShape;
   import com.ankamagames.berilia.types.graphic.MapDisplayableElement;
   import com.ankamagames.berilia.types.graphic.MapGroupElement;
   import com.ankamagames.berilia.types.graphic.MapIconElement;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDownMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOutMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseReleaseOutsideMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseUpMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseWheelMessage;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.pools.PoolablePoint;
   import com.ankamagames.jerakine.pools.PoolsManager;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.system.AirScanner;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.InteractiveObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.ui.MouseCursor;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class MapViewer extends GraphicContainer implements FinalizableUIComponent
   {
      
      public static var MEMORY_LOG:Dictionary = new Dictionary(true);
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MapViewer));
      
      private static var _iconUris:Dictionary = new Dictionary();
      
      public static var FLAG_CURSOR:Class;
       
      
      private var _showGrid:Boolean = false;
      
      private var _mapBitmapContainer:Sprite;
      
      private var _mapContainer:Sprite;
      
      private var _arrowContainer:Sprite;
      
      private var _grid:Shape;
      
      private var _areaShapesContainer:Sprite;
      
      private var _groupsContainer:Sprite;
      
      private var _layersContainer:Sprite;
      
      private var _currentMapContainer:Sprite;
      
      private var _openedMapGroupElement:MapGroupElement;
      
      private var _elementsListsByCoordinates:Dictionary;
      
      private var _elementsByElementTexture:Dictionary;
      
      private var _elementTexturesByElement:Dictionary;
      
      private var _lastMx:int;
      
      private var _lastMy:int;
      
      private var _currentMapRect:Rectangle;
      
      private var _currentMapPos:Point;
      
      private var _viewRect:Rectangle;
      
      private var _layers:Array;
      
      private var _mapElements:Vector.<MapElement>;
      
      private var _dragging:Boolean;
      
      private var _currentMap:Map;
      
      private var _availableMaps:Array;
      
      private var _arrowPool:Array;
      
      private var _arrowsByElementTexture:Dictionary;
      
      private var _elementTexturesByArrow:Dictionary;
      
      private var _mapGroupElements:Dictionary;
      
      private var _lastScaleIconUpdate:Number = -1;
      
      private var _enable3DMode:Boolean = false;
      
      private var _flagCursor:Sprite;
      
      private var _flagCursorVisible:Boolean;
      
      private var _mouseOnArrow:Boolean = false;
      
      private var _zoomLevels:Array;
      
      private var _zoomLevelsPercent:Array;
      
      private var _visibleMapAreas:Vector.<MapArea>;
      
      private var _mapToClear:Map;
      
      private var _lastWheelZoom:Number;
      
      private var _currentZoomStep:Number;
      
      private var _mouseOutRelatedObject:DisplayObject;
      
      private var _currentMapIcon:Texture;
      
      private var _onMapElementsUpdated:Function;
      
      private var _lastIconScale:Number;
      
      private var _needIconResize:Boolean;
      
      public var mapWidth:Number;
      
      public var mapHeight:Number;
      
      public var origineX:int;
      
      public var origineY:int;
      
      public var maxScale:Number = 2;
      
      public var minScale:Number = 0.5;
      
      public var startScale:Number = 0.8;
      
      public var roundCornerRadius:uint = 0;
      
      public var enabledDrag:Boolean = true;
      
      public var autoSizeIcon:Boolean = false;
      
      public var gridLineThickness:Number = 0.5;
      
      public var needMask:Boolean = true;
      
      private var zz:Number = 1;
      
      private var _isMouseOver:Boolean = false;
      
      private var _lastMouseX:Number = 0;
      
      private var _lastMouseY:Number = 0;
      
      private var _openMapGroupElementIndex:int;
      
      public function MapViewer()
      {
         this._availableMaps = [];
         this._arrowPool = new Array();
         this._arrowsByElementTexture = new Dictionary();
         this._elementTexturesByArrow = new Dictionary();
         this._mapGroupElements = new Dictionary();
         this._zoomLevels = [];
         super();
         MEMORY_LOG[this] = 1;
         if(AirScanner.hasAir())
         {
            StageShareManager.stage.nativeWindow.addEventListener(Event.DEACTIVATE,this.onWindowDeactivate);
         }
      }
      
      public function set onMapElementsUpdated(param1:Function) : void
      {
         this._onMapElementsUpdated = param1;
      }
      
      public function get mapContainerBounds() : Rectangle
      {
         return new Rectangle(this._mapContainer.x,this._mapContainer.y,this._mapContainer.width,this._mapContainer.height);
      }
      
      public function get showGrid() : Boolean
      {
         return this._showGrid;
      }
      
      public function set showGrid(param1:Boolean) : void
      {
         this._showGrid = param1;
         this.drawGrid();
      }
      
      public function get isDragging() : Boolean
      {
         return this._dragging;
      }
      
      public function get visibleMaps() : Rectangle
      {
         var _loc1_:Number = -(this._mapContainer.x / this._mapContainer.scaleX + this.origineX) / this.mapWidth;
         var _loc2_:Number = -(this._mapContainer.y / this._mapContainer.scaleY + this.origineY) / this.mapHeight;
         var _loc3_:Number = width / (this.mapWidth * this._mapContainer.scaleX);
         var _loc4_:Number = height / (this.mapHeight * this._mapContainer.scaleY);
         var _loc5_:Number = Math.ceil(_loc3_);
         var _loc6_:Number = Math.ceil(_loc4_);
         return new Rectangle(_loc1_,_loc2_,_loc5_ < 1?Number(1):Number(_loc5_),_loc6_ < 1?Number(1):Number(_loc6_));
      }
      
      public function get currentMouseMapX() : int
      {
         return this._lastMx;
      }
      
      public function get currentMouseMapY() : int
      {
         return this._lastMy;
      }
      
      public function get currentMapBounds() : Rectangle
      {
         return this.getMapBounds(this._lastMx,this._lastMy);
      }
      
      public function getMapBounds(param1:int, param2:int) : Rectangle
      {
         if(!this._currentMapRect)
         {
            this._currentMapRect = new Rectangle();
         }
         if(!this._currentMapPos)
         {
            this._currentMapPos = new Point();
         }
         this._currentMapPos.x = param1 * this.mapWidth + this.origineX;
         this._currentMapPos.y = param2 * this.mapHeight + this.origineY;
         var _loc3_:Point = this._mapContainer.localToGlobal(this._currentMapPos);
         this._currentMapRect.x = _loc3_.x;
         this._currentMapRect.y = _loc3_.y;
         this._currentMapRect.width = this.mapWidth * this._mapContainer.scaleX;
         this._currentMapRect.height = this.mapHeight * this._mapContainer.scaleY;
         return this._currentMapRect;
      }
      
      public function get mapBounds() : Rectangle
      {
         var _loc1_:Rectangle = new Rectangle();
         _loc1_.x = Math.floor(-this.origineX / this.mapWidth);
         _loc1_.y = Math.floor(-this.origineY / this.mapHeight);
         if(this._currentMap)
         {
            _loc1_.width = Math.round(this._currentMap.initialWidth / this.mapWidth);
            _loc1_.height = Math.round(this._currentMap.initialHeight / this.mapHeight);
         }
         else
         {
            _loc1_.width = Math.round(this._mapBitmapContainer.width / this.mapWidth);
            _loc1_.height = Math.round(this._mapBitmapContainer.height / this.mapHeight);
         }
         return _loc1_;
      }
      
      public function set mapAlpha(param1:Number) : void
      {
         this._mapBitmapContainer.alpha = param1;
      }
      
      public function get mapPixelPosition() : Point
      {
         return new Point(this._mapContainer.x,this._mapContainer.y);
      }
      
      public function get zoomFactor() : Number
      {
         return this._mapContainer.scaleX;
      }
      
      override public function set width(param1:Number) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:* = param1 != super.width;
         super.width = param1;
         if(finalized && _loc2_)
         {
            this.initMask();
            this.zoom(this._mapContainer.scaleX);
            this.updateVisibleChunck(false);
            this.updateMapElements();
         }
      }
      
      override public function set height(param1:Number) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:* = param1 != super.height;
         super.height = param1;
         if(finalized && _loc2_)
         {
            this.initMask();
            this.zoom(this._mapContainer.scaleX);
            this.updateVisibleChunck(false);
            this.updateMapElements();
         }
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         var _loc3_:Boolean = param2 != super.height || param1 != super.width;
         super.width = param1;
         super.height = param2;
         if(finalized && _loc3_)
         {
            this.initMask();
            this.zoom(this._mapContainer.scaleX);
            this.updateVisibleChunck(false);
            this.updateMapElements();
         }
      }
      
      public function get zoomStep() : Number
      {
         return this._availableMaps.length > 0?Number(this.maxScale / (this._availableMaps.length * 2)):Number(NaN);
      }
      
      public function get zoomLevels() : Array
      {
         return this._zoomLevels;
      }
      
      public function get allLayersVisible() : Boolean
      {
         var _loc1_:Sprite = null;
         for each(_loc1_ in this._layers)
         {
            if(!_loc1_.visible)
            {
               return false;
            }
         }
         return true;
      }
      
      public function isLayerVisible(param1:String) : Boolean
      {
         return !!this._layers[param1]?Boolean(this._layers[param1].visible):false;
      }
      
      public function set mapScale(param1:Number) : void
      {
         this._mapContainer.scaleX = this._mapContainer.scaleY = param1;
      }
      
      public function get mouseOnArrow() : Boolean
      {
         return this._mouseOnArrow;
      }
      
      public function set currentMapIconVisible(param1:Boolean) : void
      {
         this._currentMapIcon.visible = param1;
      }
      
      public function get currentMapIconVisible() : Boolean
      {
         return this._currentMapIcon.visible;
      }
      
      override public function finalize() : void
      {
         var _loc2_:Texture = null;
         var _loc3_:InteractiveObject = null;
         destroy(this._mapBitmapContainer);
         destroy(this._mapContainer);
         destroy(this._areaShapesContainer);
         destroy(this._groupsContainer);
         destroy(this._layersContainer);
         destroy(this._currentMapContainer);
         if(this._arrowPool && this._arrowsByElementTexture)
         {
            for each(_loc2_ in this._arrowsByElementTexture)
            {
               this._arrowPool.push(_loc2_);
            }
            this._arrowsByElementTexture = new Dictionary();
         }
         MapElement.removeAllElements(this);
         this._mapBitmapContainer = new Sprite();
         this._mapBitmapContainer.doubleClickEnabled = true;
         this._mapBitmapContainer.mouseChildren = false;
         this._mapBitmapContainer.mouseEnabled = false;
         this._mapBitmapContainer.name = "mapBitmapContainer";
         this._viewRect = new Rectangle();
         this.initMap();
         _finalized = true;
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc3_ = getChildAt(_loc1_) as InteractiveObject;
            if(_loc3_)
            {
               _loc3_.doubleClickEnabled = true;
            }
            _loc1_++;
         }
         this.setupZoomLevels(width,height);
         super.finalize();
         getUi().iAmFinalized(this);
      }
      
      public function setupZoomLevels(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Vector.<Number> = null;
         for each(_loc3_ in this._zoomLevels)
         {
            if(this._currentMap && (this._currentMap.initialWidth * _loc3_ < param1 || this._currentMap.initialHeight * _loc3_ < param2))
            {
               if(!_loc4_)
               {
                  _loc4_ = new Vector.<Number>(0);
               }
               _loc4_.push(_loc3_);
            }
         }
         this._zoomLevelsPercent = [];
         for each(_loc3_ in this._zoomLevels)
         {
            this._zoomLevelsPercent.push(int(_loc3_ * 100));
         }
      }
      
      public function addLayer(param1:String) : void
      {
         var _loc2_:Sprite = null;
         if(!this._layers[param1])
         {
            _loc2_ = new Sprite();
            _loc2_.name = "layer_" + param1;
            _loc2_.mouseEnabled = false;
            _loc2_.doubleClickEnabled = true;
            this._layers[param1] = _loc2_;
         }
         this._layersContainer.addChild(this._layers[param1]);
      }
      
      public function addIcon(param1:String, param2:String, param3:String, param4:int, param5:int, param6:Number = 1, param7:String = null, param8:Boolean = false, param9:int = -1, param10:Boolean = true, param11:Boolean = true, param12:Rectangle = null, param13:Boolean = false, param14:Boolean = false, param15:uint = 0) : MapIconElement
      {
         var _loc16_:Uri = null;
         var _loc17_:TextureBase = null;
         var _loc18_:MapIconElement = null;
         var _loc19_:Sprite = null;
         var _loc20_:* = 0;
         var _loc21_:* = 0;
         var _loc22_:* = 0;
         var _loc23_:ColorTransform = null;
         if(this._layers[param1] && this.mapBounds.contains(param4,param5))
         {
            if(!_iconUris[param3])
            {
               _iconUris[param3] = new Uri(param3);
            }
            _loc16_ = _iconUris[param3];
            _loc17_ = _loc16_.path && _loc16_.fileType.toLowerCase() == "png"?new TextureBitmap():new Texture();
            _loc17_.mouseChildren = false;
            _loc17_.autoCenterBitmap = true;
            if(_loc17_ is TextureBitmap)
            {
               TextureBitmap(_loc17_).smooth = true;
            }
            else if(_loc17_ is Texture)
            {
               Texture(_loc17_).dispatchMessages = true;
            }
            if(_loc16_.path)
            {
               _loc17_.uri = _loc16_;
            }
            if(param12)
            {
               _loc19_ = new Sprite();
               _loc19_.graphics.beginFill(0,0);
               _loc19_.graphics.drawRect(param12.x,param12.y,param12.width,param12.height);
               _loc19_.mouseEnabled = false;
               _loc17_.addChildAt(_loc19_,0);
               _loc17_.hitArea = _loc19_;
            }
            _loc17_.scaleX = _loc17_.scaleY = this._lastIconScale * MapDisplayableElement.SCALE_FACTOR;
            if(param9 != -1)
            {
               _loc20_ = param9 >> 16 & 255;
               _loc21_ = param9 >> 8 & 255;
               _loc22_ = param9 >> 0 & 255;
               _loc23_ = new ColorTransform(0.6,0.6,0.6,1,_loc20_ - 80,_loc21_ - 80,_loc22_ - 80);
               _loc17_.transform.colorTransform = _loc23_;
            }
            _loc18_ = new MapIconElement(param2,param4,param5,param1,_loc17_,param9,param7,this,param11,param13,param14,param15);
            _loc18_.canBeGrouped = param10;
            _loc18_.follow = param8;
            this._mapElements.push(_loc18_);
            this._elementsByElementTexture[_loc17_] = _loc18_;
            this._elementTexturesByElement[_loc18_] = _loc17_;
            if(!this._elementsListsByCoordinates[_loc18_.key])
            {
               this._elementsListsByCoordinates[_loc18_.key] = [];
            }
            this._elementsListsByCoordinates[_loc18_.key].push(_loc18_);
            return _loc18_;
         }
         return null;
      }
      
      public function addAreaShape(param1:String, param2:String, param3:Vector.<int>, param4:uint = 0, param5:Number = 1, param6:uint = 0, param7:Number = 0.4, param8:int = 4) : MapAreaShape
      {
         var _loc9_:MapAreaShape = null;
         var _loc10_:Texture = null;
         var _loc11_:Graphics = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:MapAreaShape = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         if(this._layers[param1] && param3)
         {
            _loc9_ = MapAreaShape(MapElement.getElementById(param2,this));
            if(_loc9_)
            {
               if(_loc9_.lineColor == param4 && _loc9_.fillColor == param6)
               {
                  return _loc9_;
               }
               _loc9_.remove();
               this._mapElements.splice(this._mapElements.indexOf(_loc9_),1);
            }
            _loc10_ = new Texture();
            _loc10_.mouseEnabled = false;
            _loc10_.mouseChildren = false;
            _loc11_ = _loc10_.graphics;
            _loc11_.lineStyle(param8,param4,param5,true);
            _loc11_.beginFill(param6,param7);
            _loc12_ = param3.length;
            _loc13_ = 0;
            while(_loc13_ < _loc12_)
            {
               _loc15_ = param3[_loc13_];
               _loc16_ = param3[_loc13_ + 1];
               if(_loc15_ > 10000)
               {
                  _loc11_.moveTo((_loc15_ - 11000) * this.mapWidth,(_loc16_ - 11000) * this.mapHeight);
               }
               else
               {
                  _loc11_.lineTo(_loc15_ * this.mapWidth,_loc16_ * this.mapHeight);
               }
               _loc13_ = _loc13_ + 2;
            }
            _loc14_ = new MapAreaShape(param2,param1,_loc10_,this.origineX,this.origineY,param4,param6,this);
            this._mapElements.push(_loc14_);
            return _loc14_;
         }
         return null;
      }
      
      public function areaShapeColorTransform(param1:MapAreaShape, param2:int, param3:Number = 1, param4:Number = 1, param5:Number = 1, param6:Number = 1, param7:Number = 0, param8:Number = 0, param9:Number = 0, param10:Number = 0) : void
      {
         param1.colorTransform(param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      public function getMapElement(param1:String) : MapElement
      {
         var _loc3_:MapElement = null;
         var _loc2_:MapElement = MapElement.getElementById(param1,this);
         if(!_loc2_)
         {
            for each(_loc3_ in this._mapElements)
            {
               if(_loc3_.id == param1)
               {
                  _loc2_ = _loc3_;
                  break;
               }
            }
         }
         return _loc2_;
      }
      
      public function getMapElementsByLayer(param1:String) : Array
      {
         var _loc5_:MapElement = null;
         var _loc2_:int = this._mapElements.length;
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = this._mapElements[_loc4_];
            if(_loc5_.layer == param1)
            {
               _loc3_.push(_loc5_);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getMapElementsAtCoordinates(param1:int, param2:int) : Array
      {
         var _loc3_:String = param1 + "_" + param2;
         if(!this._elementsListsByCoordinates[_loc3_])
         {
            return [];
         }
         return (this._elementsListsByCoordinates[_loc3_] as Array).sortOn("priority");
      }
      
      public function removeMapElement(param1:MapElement) : void
      {
         var _loc3_:MapIconElement = null;
         var _loc4_:TextureBase = null;
         var _loc5_:int = 0;
         if(!param1)
         {
            return;
         }
         var _loc2_:int = this._mapElements.indexOf(param1);
         if(_loc2_ != -1)
         {
            _loc3_ = this._mapElements[_loc2_] as MapIconElement;
            if(_loc3_)
            {
               _loc4_ = this._elementTexturesByElement[_loc3_];
               if(this._mapGroupElements[_loc3_])
               {
                  this._mapGroupElements[_loc3_].icons.splice(this._mapGroupElements[_loc3_].icons.indexOf(_loc3_),1);
                  this._mapGroupElements[_loc3_].display();
                  delete this._mapGroupElements[_loc3_];
               }
               if(this._arrowsByElementTexture[_loc4_] && this._arrowsByElementTexture[_loc4_].parent)
               {
                  this._arrowsByElementTexture[_loc4_].parent.removeChild(this._arrowsByElementTexture[_loc4_]);
                  this._arrowPool.push(this._arrowsByElementTexture[_loc4_]);
                  delete this._elementTexturesByArrow[this._arrowsByElementTexture[_loc4_]];
                  delete this._arrowsByElementTexture[_loc4_];
               }
               if(this._elementsListsByCoordinates[_loc3_.key])
               {
                  _loc5_ = this._elementsListsByCoordinates[_loc3_.key].indexOf(_loc3_);
                  if(_loc5_ != -1)
                  {
                     this._elementsListsByCoordinates[_loc3_.key].splice(_loc5_,1);
                  }
               }
            }
            param1.remove();
            this._mapElements.splice(_loc2_,1);
         }
      }
      
      public function updateMapElements() : void
      {
         if(!hasEventListener(Event.ENTER_FRAME))
         {
            addEventListener(Event.ENTER_FRAME,this.processUpdateMapElements);
         }
      }
      
      private function processUpdateMapElements(param1:Event) : void
      {
         var _loc2_:* = null;
         var _loc3_:MapElement = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:MapIconElement = null;
         var _loc8_:MapGroupElement = null;
         var _loc9_:int = 0;
         removeEventListener(Event.ENTER_FRAME,this.processUpdateMapElements);
         this.updateIconSize();
         for(_loc2_ in this._mapGroupElements)
         {
            delete this._mapGroupElements[_loc2_];
         }
         this.clearLayer();
         this.clearElementsGroups();
         this.clearMapAreaShapes();
         _loc4_ = new Array();
         for each(_loc3_ in this._mapElements)
         {
            if(this._layers[_loc3_.layer].visible)
            {
               _loc5_ = _loc3_.x + "_" + _loc3_.y;
               if(!_loc4_[_loc5_])
               {
                  _loc4_[_loc5_] = new Array();
               }
               if(!(_loc3_ is MapIconElement) || !this.checkDuplicate(_loc3_ as MapIconElement,_loc4_[_loc5_]))
               {
                  _loc4_[_loc5_].push(_loc3_);
               }
            }
         }
         for each(_loc6_ in _loc4_)
         {
            _loc8_ = null;
            _loc9_ = 0;
            for each(_loc3_ in _loc6_)
            {
               _loc7_ = _loc3_ as MapIconElement;
               if(_loc7_ && _loc7_.canBeGrouped)
               {
                  _loc9_++;
                  if(_loc9_ > 1)
                  {
                     _loc8_ = new MapGroupElement(this);
                     _loc8_.x = _loc7_.x * this.mapWidth + this.origineX + this.mapWidth / 2;
                     _loc8_.y = _loc7_.y * this.mapHeight + this.origineY + this.mapHeight / 2;
                     this._groupsContainer.addChild(_loc8_);
                     break;
                  }
               }
            }
            for each(_loc3_ in _loc6_)
            {
               switch(true)
               {
                  case _loc3_ is MapIconElement:
                     _loc7_ = _loc3_ as MapIconElement;
                     if(_loc8_ && _loc7_.canBeGrouped)
                     {
                        this._mapGroupElements[_loc7_] = _loc8_;
                        _loc7_.setTexturePosition(0,0);
                        _loc8_.addElement(_loc7_);
                     }
                     else
                     {
                        _loc7_.group = null;
                        _loc7_.setTexturePosition(_loc7_.x * this.mapWidth + this.origineX + this.mapWidth / 2,_loc7_.y * this.mapHeight + this.origineY + this.mapHeight / 2);
                        _loc7_.setTextureParent(this._layers[_loc3_.layer]);
                     }
                     continue;
                  case _loc3_ is MapAreaShape:
                     this.updateMapAreaShape(_loc3_ as MapAreaShape);
                     continue;
                  default:
                     continue;
               }
            }
            if(_loc8_)
            {
               _loc8_.display();
            }
         }
         this.updateIcons();
         if(this._onMapElementsUpdated != null)
         {
            this._onMapElementsUpdated.call();
         }
      }
      
      public function updateMapAreaShape(param1:MapAreaShape) : void
      {
         var _loc2_:Sprite = this._layers[param1.layer];
         if(_loc2_.parent != this._areaShapesContainer)
         {
            this._areaShapesContainer.addChild(_loc2_);
         }
         param1.setTextureParent(_loc2_);
         param1.setTexturePosition(param1.x,param1.y);
      }
      
      public function showLayer(param1:String, param2:Boolean = true) : void
      {
         if(this._layers[param1])
         {
            this._layers[param1].visible = param2;
         }
      }
      
      public function showAllLayers(param1:Boolean = true) : void
      {
         var _loc2_:Sprite = null;
         for each(_loc2_ in this._layers)
         {
            _loc2_.visible = param1;
         }
         this.updateMapElements();
      }
      
      public function moveToPixel(param1:int, param2:int, param3:Number) : void
      {
         this._mapContainer.x = param1;
         this._mapContainer.y = param2;
         this._mapContainer.scaleX = param3;
         this._mapContainer.scaleY = param3;
         this.updateVisibleChunck();
      }
      
      public function moveTo(param1:Number, param2:Number, param3:uint = 1, param4:uint = 1, param5:Boolean = true, param6:Boolean = true) : void
      {
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc7_:Rectangle = this.mapBounds;
         if(_loc7_.left > param1)
         {
            param1 = _loc7_.left;
         }
         if(_loc7_.top > param2)
         {
            param2 = _loc7_.top;
         }
         if(param5)
         {
            _loc10_ = param3 * this.mapWidth * this._mapContainer.scaleX;
            if(_loc10_ > this.width && param6)
            {
               this._mapContainer.scaleX = this.width / (this.mapWidth * param3);
               this._mapContainer.scaleY = this._mapContainer.scaleX;
            }
            _loc11_ = param4 * this.mapHeight * this._mapContainer.scaleY;
            if(_loc11_ > this.height && param6)
            {
               this._mapContainer.scaleY = this.height / (this.mapHeight * param4);
               this._mapContainer.scaleX = this._mapContainer.scaleY;
            }
            _loc12_ = -(param1 * this.mapWidth + this.origineX) * this._mapContainer.scaleX - this.mapWidth / 2 * this._mapContainer.scaleX;
            _loc13_ = -(param2 * this.mapHeight + this.origineY) * this._mapContainer.scaleY - this.mapHeight / 2 * this._mapContainer.scaleY;
            _loc14_ = this.width / 2;
            _loc15_ = this.height / 2;
            _loc16_ = Math.abs(-this._mapContainer.width - _loc12_);
            if(_loc16_ < _loc14_)
            {
               _loc14_ = _loc14_ + (_loc14_ - _loc16_);
            }
            _loc17_ = Math.abs(-this._mapContainer.height - _loc13_);
            if(_loc17_ < _loc15_)
            {
               _loc15_ = _loc15_ + (_loc15_ - _loc17_);
            }
            this._mapContainer.x = _loc12_ + _loc14_;
            this._mapContainer.y = _loc13_ + _loc15_;
         }
         else
         {
            this._mapContainer.x = -(param1 * this.mapWidth + this.origineX) * this._mapContainer.scaleX;
            this._mapContainer.y = -(param2 * this.mapHeight + this.origineY) * this._mapContainer.scaleY;
         }
         var _loc8_:Number = !!this._currentMap?Number(this._currentMap.initialWidth):Number(this._mapBitmapContainer.width);
         var _loc9_:Number = !!this._currentMap?Number(this._currentMap.initialHeight):Number(this._mapBitmapContainer.height);
         if(this._mapContainer.x < param3 - _loc8_)
         {
            if(!param5)
            {
               this._mapContainer.x = param3 - _loc8_;
            }
            else
            {
               this._mapContainer.x = 0;
            }
         }
         if(this._mapContainer.y < param4 - _loc9_)
         {
            if(!param5)
            {
               this._mapContainer.y = param4 - _loc9_;
            }
            else
            {
               this._mapContainer.y = 0;
            }
         }
         if(this._mapContainer.x > 0)
         {
            this._mapContainer.x = 0;
         }
         if(this._mapContainer.y > 0)
         {
            this._mapContainer.y = 0;
         }
         this.updateVisibleChunck();
         Berilia.getInstance().handler.process(new MapMoveMessage(this));
         this._mouseOnArrow = false;
      }
      
      private function zoomWithScalePercent(param1:int, param2:Point = null) : void
      {
         this.zoom(param1 / 100,param2);
      }
      
      public function zoom(param1:Number, param2:Point = null) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Rectangle = null;
         var _loc6_:Point = null;
         if(param1 > this.maxScale)
         {
            param1 = this.maxScale;
         }
         if(param1 < this.minScale)
         {
            param1 = this.minScale;
         }
         if(this._currentMap)
         {
            if(this._currentMap.initialWidth * param1 < width)
            {
               param1 = width / this._currentMap.initialWidth;
            }
            if(this._currentMap.initialHeight * param1 < height)
            {
               param1 = height / this._currentMap.initialHeight;
            }
         }
         if(param2)
         {
            if(this._currentMap)
            {
               this._currentMap.currentScale = NaN;
            }
            this._mapContainer.x = this._mapContainer.x - (param2.x * param1 - param2.x * this._mapContainer.scaleX);
            this._mapContainer.y = this._mapContainer.y - (param2.y * param1 - param2.y * this._mapContainer.scaleY);
            this._mapContainer.scaleX = this._mapContainer.scaleY = param1;
            this._needIconResize = 62 * MapDisplayableElement.SCALE_FACTOR > this.mapWidth * param1 || 62 * MapDisplayableElement.SCALE_FACTOR > this.mapHeight * param1;
            _loc3_ = !!this._currentMap?Number(this._currentMap.initialWidth):Number(this._mapBitmapContainer.width);
            _loc4_ = !!this._currentMap?Number(this._currentMap.initialHeight):Number(this._mapBitmapContainer.height);
            if(this._mapContainer.x < width - _loc3_ * param1)
            {
               this._mapContainer.x = width - _loc3_ * param1;
            }
            if(this._mapContainer.y < height - _loc4_ * param1)
            {
               this._mapContainer.y = height - _loc4_ * param1;
            }
            if(this._mapContainer.x > 0)
            {
               this._mapContainer.x = 0;
            }
            if(this._mapContainer.y > 0)
            {
               this._mapContainer.y = 0;
            }
            this.updateIconSize();
            this.processMapInfo();
            return;
         }
         _loc5_ = this.visibleMaps;
         _loc6_ = new Point((_loc5_.x + _loc5_.width / 2) * this.mapWidth + this.origineX,(_loc5_.y + _loc5_.height / 2) * this.mapHeight + this.origineY);
         this.zoom(param1,_loc6_);
      }
      
      public function addMap(param1:Number, param2:String, param3:uint, param4:uint, param5:uint, param6:uint) : void
      {
         this._availableMaps.push(new Map(param1,param2,new Sprite(),param3,param4,param5,param6));
         if(this._zoomLevels.indexOf(param1) == -1)
         {
            this._zoomLevels.push(param1);
            this._zoomLevels.sort(Array.NUMERIC);
         }
      }
      
      public function removeAllMap() : void
      {
         var _loc1_:Map = null;
         var _loc2_:MapArea = null;
         for each(_loc1_ in this._availableMaps)
         {
            for each(_loc2_ in _loc1_.areas)
            {
               _loc2_.free(true);
            }
         }
         this._availableMaps = [];
         this._zoomLevels.length = 0;
      }
      
      public function getOrigineFromPos(param1:int, param2:int) : Point
      {
         return new Point(-this._mapContainer.x / this._mapContainer.scaleX - param1 * this.mapWidth,-this._mapContainer.y / this._mapContainer.scaleY - param2 * this.mapHeight);
      }
      
      public function set useFlagCursor(param1:Boolean) : void
      {
         var _loc2_:LinkedCursorData = null;
         if(!FLAG_CURSOR)
         {
            return;
         }
         if(param1)
         {
            if(!this._flagCursor)
            {
               this._flagCursor = new Sprite();
               this._flagCursor.addChild(new FLAG_CURSOR());
            }
            _loc2_ = new LinkedCursorData();
            _loc2_.sprite = this._flagCursor;
            _loc2_.offset = new Point();
            Mouse.hide();
            LinkedCursorSpriteManager.getInstance().addItem("mapViewerCursor",_loc2_);
         }
         else
         {
            this.removeCustomCursor();
         }
         this._flagCursorVisible = param1;
      }
      
      public function get useFlagCursor() : Boolean
      {
         return this._flagCursorVisible;
      }
      
      public function get allChunksLoaded() : Boolean
      {
         var _loc1_:MapArea = null;
         if(!this._visibleMapAreas || !this._visibleMapAreas.length)
         {
            return false;
         }
         for each(_loc1_ in this._visibleMapAreas)
         {
            if(!_loc1_.isLoaded)
            {
               return false;
            }
         }
         return true;
      }
      
      private function checkDuplicate(param1:MapIconElement, param2:Array) : Boolean
      {
         var _loc3_:MapElement = null;
         var _loc4_:MapIconElement = null;
         if(param1.allowDuplicate || !param1.legend)
         {
            return false;
         }
         for each(_loc3_ in param2)
         {
            _loc4_ = _loc3_ as MapIconElement;
            if(_loc4_ && _loc4_.legend == param1.legend)
            {
               return true;
            }
         }
         return false;
      }
      
      private function removeCustomCursor() : void
      {
         Mouse.show();
         LinkedCursorSpriteManager.getInstance().removeItem("mapViewerCursor");
      }
      
      override public function remove() : void
      {
         var _loc1_:MapElement = null;
         Mouse.cursor = MouseCursor.AUTO;
         if(!__removed)
         {
            if(this._grid)
            {
               this._grid.cacheAsBitmap = false;
               if(this._mapContainer.contains(this._grid))
               {
                  this._mapContainer.removeChild(this._grid);
               }
            }
            if(this._mapToClear)
            {
               this.clearMap(this._mapToClear);
               this._mapToClear = null;
            }
            this.removeAllMap();
            for each(_loc1_ in MapElement.getOwnerElements(this))
            {
               if(this._mapGroupElements[_loc1_])
               {
                  delete this._mapGroupElements[_loc1_];
               }
               _loc1_.remove();
            }
            this._mapElements = null;
            this._elementsByElementTexture = null;
            this._elementTexturesByElement = null;
            this._elementsListsByCoordinates = null;
            this._mapGroupElements = null;
            this._visibleMapAreas = null;
            MapElement._elementRef = new Dictionary(true);
            EnterFrameDispatcher.removeEventListener(this.onMapEnterFrame);
            this.removeCustomCursor();
            if(hasEventListener(Event.ENTER_FRAME))
            {
               removeEventListener(Event.ENTER_FRAME,this.processUpdateMapElements);
            }
            if(AirScanner.hasAir())
            {
               StageShareManager.stage.nativeWindow.removeEventListener(Event.DEACTIVATE,this.onWindowDeactivate);
            }
         }
         super.remove();
      }
      
      private function getIconTextureGlobalCoords(param1:MapIconElement) : Point
      {
         var _loc3_:Point = null;
         var _loc4_:PoolablePoint = null;
         var _loc2_:Sprite = this._layers[param1.layer] as Sprite;
         if(this._mapGroupElements[param1])
         {
            _loc4_ = PoolsManager.getInstance().getPointPool().checkOut() as PoolablePoint;
            _loc3_ = _loc2_.localToGlobal(_loc4_.renew(this._mapGroupElements[param1].x,this._mapGroupElements[param1].y));
         }
         else
         {
            _loc3_ = _loc2_.localToGlobal(param1.getTexturePosition());
         }
         return _loc3_;
      }
      
      private function updateIcons() : void
      {
         var _loc2_:TextureBase = null;
         var _loc3_:MapIconElement = null;
         var _loc7_:Point = null;
         var _loc9_:* = false;
         var _loc12_:MapElement = null;
         var _loc13_:Texture = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:* = undefined;
         var _loc18_:Texture = null;
         var _loc19_:Number = NaN;
         var _loc1_:Rectangle = new Rectangle(0,0,1,1);
         var _loc4_:Rectangle = this.visibleMaps;
         var _loc5_:Point = new Point(Math.floor(_loc4_.x + _loc4_.width / 2),Math.floor(_loc4_.y + _loc4_.height / 2));
         var _loc6_:* = this.roundCornerRadius > width / 3;
         var _loc8_:Number = width / 2;
         var _loc10_:Point = parent.localToGlobal(new Point(x,y));
         var _loc11_:Rectangle = new Rectangle(_loc10_.x,_loc10_.y,width,height);
         for each(_loc12_ in this._mapElements)
         {
            _loc3_ = _loc12_ as MapIconElement;
            if(_loc3_)
            {
               _loc1_.x = _loc3_.x;
               _loc1_.y = _loc3_.y;
               _loc2_ = this._elementTexturesByElement[_loc3_];
               if(_loc2_)
               {
                  if(_loc3_.follow && _loc6_)
                  {
                     _loc7_ = globalToLocal(this.getIconTextureGlobalCoords(_loc3_));
                     _loc9_ = Math.floor(Math.sqrt(Math.pow(_loc7_.x - _loc8_,2) + Math.pow(_loc7_.y - _loc8_,2))) < _loc8_;
                  }
                  else
                  {
                     _loc9_ = Boolean(_loc2_ is Texture && !_loc2_.finalized || (!_loc2_.uri || !_loc2_.finalized?Boolean(_loc4_.intersects(_loc1_)):Boolean(_loc11_.intersects(_loc3_.getRealBounds))));
                  }
                  _loc2_.visible = this._layers[_loc3_.layer].visible != false && _loc9_;
                  if(_loc3_.group)
                  {
                     _loc3_.group.visible = _loc2_.visible;
                  }
                  if(_loc2_ is Texture)
                  {
                     if(_loc2_.visible && !_loc2_.finalized)
                     {
                        _loc2_.finalize();
                     }
                     Texture(_loc2_).gotoAndPlay = 1;
                  }
                  if(_loc3_.follow)
                  {
                     if(_loc2_.visible && this._arrowsByElementTexture[_loc2_])
                     {
                        this._arrowContainer.removeChild(this._arrowsByElementTexture[_loc2_]);
                        this._arrowPool.push(this._arrowsByElementTexture[_loc2_]);
                        _loc3_.boundsRef = null;
                        delete this._elementTexturesByArrow[this._arrowsByElementTexture[_loc2_]];
                        delete this._arrowsByElementTexture[_loc2_];
                     }
                     else if(_loc3_.follow && !_loc2_.visible)
                     {
                        _loc18_ = this.getIconArrow(_loc2_);
                        _loc18_.visible = this._layers[_loc3_.layer].visible;
                        this._arrowContainer.addChild(_loc18_);
                        this._elementsByElementTexture[_loc18_] = _loc3_;
                        _loc3_.boundsRef = _loc18_;
                     }
                  }
               }
            }
         }
         _loc14_ = Math.atan2(0,-width / 2);
         _loc15_ = Math.atan2(width / 2,0) + _loc14_;
         for(_loc17_ in this._arrowsByElementTexture)
         {
            _loc13_ = this._arrowsByElementTexture[_loc17_];
            _loc3_ = this._elementsByElementTexture[_loc17_];
            if(_loc6_)
            {
               _loc7_ = globalToLocal(this.getIconTextureGlobalCoords(_loc3_));
               _loc19_ = Math.atan2(-_loc7_.y + height / 2,-_loc7_.x + width / 2);
            }
            else
            {
               _loc19_ = Math.atan2(-_loc3_.y + _loc5_.y,-_loc3_.x + _loc5_.x);
            }
            _loc13_.x = Math.cos(_loc14_ + _loc19_) * width / 2;
            _loc13_.y = Math.sin(_loc14_ + _loc19_) * height / 2;
            _loc13_.rotation = _loc19_ * (180 / Math.PI);
            if(_loc6_)
            {
               _loc13_.x = _loc13_.x + width / 2;
               _loc13_.y = _loc13_.y + height / 2;
            }
            else
            {
               _loc15_ = _loc13_.y / _loc13_.x;
               _loc19_ = _loc19_ + Math.PI;
               if(_loc19_ < Math.PI / 4 || _loc19_ > Math.PI * 7 / 4)
               {
                  _loc16_ = width / 2 * _loc15_ + height / 2;
                  if(_loc16_ > 0 && _loc16_ < height)
                  {
                     _loc13_.x = width;
                     _loc13_.y = _loc16_;
                     continue;
                  }
               }
               else if(_loc19_ < Math.PI * 3 / 4)
               {
                  _loc16_ = height / 2 / _loc15_ + width / 2;
                  _loc16_ = _loc16_ > width?Number(width):Number(_loc16_);
                  if(_loc16_ > 0)
                  {
                     _loc13_.x = _loc16_;
                     _loc13_.y = height;
                     continue;
                  }
               }
               else if(_loc19_ < Math.PI * 5 / 4)
               {
                  _loc16_ = -width / 2 * _loc15_ + height / 2;
                  if(_loc16_ > 0 && _loc16_ < height)
                  {
                     _loc13_.x = 0;
                     _loc13_.y = _loc16_;
                     continue;
                  }
               }
               else
               {
                  _loc16_ = -height / 2 / _loc15_ + width / 2;
                  _loc16_ = _loc16_ > width?Number(width):_loc16_ < 0?Number(0):Number(_loc16_);
                  if(_loc16_ >= 0)
                  {
                     _loc13_.x = _loc16_;
                     _loc13_.y = 0;
                     continue;
                  }
               }
               if(_loc13_.rotation == -45)
               {
                  _loc13_.x = 0;
                  _loc13_.y = _loc16_;
               }
            }
         }
      }
      
      private function getIconArrow(param1:TextureBase) : Texture
      {
         var _loc2_:Texture = null;
         if(this._arrowsByElementTexture[param1])
         {
            return this._arrowsByElementTexture[param1];
         }
         if(this._arrowPool.length)
         {
            this._arrowsByElementTexture[param1] = this._arrowPool.pop();
         }
         else
         {
            _loc2_ = new Texture();
            _loc2_.uri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path") + "icons/assets.swf|arrow0");
            _loc2_.mouseEnabled = true;
            _loc2_.buttonMode = _loc2_.useHandCursor = true;
            _loc2_.finalize();
            this._arrowsByElementTexture[param1] = _loc2_;
         }
         this._elementTexturesByArrow[this._arrowsByElementTexture[param1]] = param1;
         Texture(this._arrowsByElementTexture[param1]).transform.colorTransform = param1.transform.colorTransform;
         return this._arrowsByElementTexture[param1];
      }
      
      private function processMapInfo() : void
      {
         var _loc1_:Map = null;
         var _loc3_:Number = NaN;
         var _loc4_:Map = null;
         if(!this._availableMaps.length)
         {
            return;
         }
         this._lastScaleIconUpdate = -1;
         var _loc2_:Number = 10000;
         for each(_loc4_ in this._availableMaps)
         {
            _loc3_ = Math.abs(this._mapContainer.scaleX - _loc4_.zoom);
            if(_loc3_ < _loc2_ && this._mapContainer.scaleX <= _loc4_.zoom)
            {
               _loc1_ = _loc4_;
               _loc2_ = _loc3_;
            }
         }
         if(_loc1_ && (!this._currentMap || _loc1_ != this._currentMap))
         {
            if(this._currentMap)
            {
               if(this._mapToClear)
               {
                  this.clearMap(this._mapToClear);
               }
               this._mapToClear = this._currentMap;
            }
            this._currentMap = _loc1_;
            this._mapBitmapContainer.graphics.beginFill(0,0);
            this._mapBitmapContainer.graphics.drawRect(0,0,this._currentMap.initialWidth,this._currentMap.initialHeight);
            this._mapBitmapContainer.graphics.endFill();
            this._mapBitmapContainer.addChild(this._currentMap.container);
            this._viewRect.width = width;
            this._viewRect.height = height;
         }
         this.updateVisibleChunck();
      }
      
      private function updateVisibleChunck(param1:Boolean = true) : void
      {
         if(!this._currentMap || !this._currentMap.areas)
         {
            return;
         }
         if(param1)
         {
            this.updateIcons();
         }
         var _loc2_:uint = 100;
         this._viewRect.x = -this._mapContainer.x / this._mapContainer.scaleX - _loc2_;
         this._viewRect.y = -this._mapContainer.y / this._mapContainer.scaleY - _loc2_;
         this._viewRect.width = width / this._mapContainer.scaleX + _loc2_ * 2;
         this._viewRect.height = height / this._mapContainer.scaleY + _loc2_ * 2;
         this._visibleMapAreas = this._currentMap.loadAreas(this._viewRect);
      }
      
      private function initMask() : void
      {
         if(!this.needMask)
         {
            return;
         }
         if(this._mapContainer.mask)
         {
            this._mapContainer.mask.parent.removeChild(this._mapContainer.mask);
         }
         var _loc1_:Sprite = new Sprite();
         _loc1_.name = "maskCtr";
         _loc1_.doubleClickEnabled = true;
         _loc1_.graphics.beginFill(7798784,0.3);
         if(!this.roundCornerRadius)
         {
            _loc1_.graphics.drawRect(0,0,width,height);
         }
         else
         {
            _loc1_.graphics.drawRoundRectComplex(0,0,width,height,this.roundCornerRadius,this.roundCornerRadius,this.roundCornerRadius,this.roundCornerRadius);
         }
         addChild(_loc1_);
         this._mapContainer.mask = _loc1_;
      }
      
      private function initMap() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Map = null;
         this._mapContainer = new Sprite();
         this._mapContainer.name = "mapContainer";
         this._mapContainer.doubleClickEnabled = true;
         this.initMask();
         this._mapContainer.addChild(this._mapBitmapContainer);
         this._grid = new Shape();
         this.drawGrid();
         this._mapContainer.addChild(this._grid);
         this._areaShapesContainer = new Sprite();
         this._areaShapesContainer.name = "areaShapesContainer";
         this._areaShapesContainer.mouseEnabled = false;
         this._mapContainer.addChild(this._areaShapesContainer);
         this._layersContainer = new Sprite();
         this._layersContainer.name = "layersContainer";
         this._layersContainer.mouseEnabled = false;
         this._mapContainer.addChild(this._layersContainer);
         this._groupsContainer = new Sprite();
         this._groupsContainer.name = "groupsContainer";
         this._groupsContainer.mouseEnabled = false;
         this._mapContainer.addChild(this._groupsContainer);
         this._currentMapContainer = new Sprite();
         this._currentMapContainer.name = "currentMapContainer";
         this._currentMapContainer.mouseEnabled = false;
         this._mapContainer.addChild(this._currentMapContainer);
         this._currentMapIcon = new Texture();
         this._currentMapIcon.mouseEnabled = false;
         this._currentMapIcon.uri = new Uri(XmlConfig.getInstance().getEntry("config.gfx.path") + "icons/assets.swf|currenMapHighlight");
         this._currentMapIcon.finalize();
         this._currentMapContainer.addChild(this._currentMapIcon);
         if(this._enable3DMode)
         {
            _loc1_ = new Sprite();
            _loc1_.addChild(this._mapContainer);
            _loc1_.rotationX = -30;
            _loc1_.doubleClickEnabled = true;
            addChild(_loc1_);
         }
         else
         {
            addChild(this._mapContainer);
         }
         this._arrowContainer = new Sprite();
         this._arrowContainer.name = "arrowContainer";
         this._arrowContainer.mouseEnabled = false;
         addChild(this._arrowContainer);
         this._mapElements = new Vector.<MapElement>();
         this._layers = new Array();
         this._elementsByElementTexture = new Dictionary(true);
         this._elementTexturesByElement = new Dictionary(true);
         this._elementsListsByCoordinates = new Dictionary(true);
         if(this._availableMaps && this._availableMaps.length)
         {
            _loc2_ = Map(this._availableMaps[0]);
            this.minScale = Math.min(width / _loc2_.initialWidth,height / _loc2_.initialHeight);
            this.maxScale = this._zoomLevels[this._zoomLevels.length - 1];
            this.startScale = Math.min(width / (this.mapWidth * 3),height / (this.mapHeight * 3));
         }
         this.zoom(this.startScale);
      }
      
      private function drawGrid() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(!this._showGrid)
         {
            this._grid.graphics.clear();
         }
         else
         {
            _loc1_ = this.origineX % this.mapWidth;
            _loc2_ = this.origineY % this.mapHeight;
            this._grid.cacheAsBitmap = false;
            this._grid.graphics.lineStyle(1,7829367,this.gridLineThickness);
            _loc5_ = this._mapBitmapContainer.width / this.mapWidth;
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc4_ = _loc3_ * this.mapWidth + _loc1_;
               this._grid.graphics.moveTo(_loc4_,0);
               this._grid.graphics.lineTo(_loc4_,this._mapBitmapContainer.height);
               _loc3_++;
            }
            _loc6_ = this._mapBitmapContainer.height / this.mapHeight;
            _loc3_ = 0;
            while(_loc3_ < _loc6_)
            {
               _loc4_ = _loc3_ * this.mapHeight + _loc2_;
               this._grid.graphics.moveTo(0,_loc4_);
               this._grid.graphics.lineTo(this._mapBitmapContainer.width,_loc4_);
               _loc3_++;
            }
         }
      }
      
      private function clearLayer(param1:DisplayObjectContainer = null) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:DisplayObjectContainer = null;
         for each(_loc3_ in this._layers)
         {
            if(!param1 || param1 == _loc3_)
            {
               while(_loc3_.numChildren)
               {
                  _loc2_ = _loc3_.removeChildAt(0);
               }
               continue;
            }
         }
      }
      
      private function clearElementsGroups() : void
      {
         var _loc1_:MapGroupElement = null;
         while(this._groupsContainer.numChildren > 0)
         {
            _loc1_ = this._groupsContainer.getChildAt(0) as MapGroupElement;
            _loc1_.remove();
            this._groupsContainer.removeChildAt(0);
         }
      }
      
      private function clearMapAreaShapes() : void
      {
         var _loc1_:MapAreaShape = null;
         var _loc2_:Sprite = null;
         var _loc4_:int = 0;
         var _loc3_:int = this._areaShapesContainer.numChildren;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = this._areaShapesContainer.getChildAt(_loc4_) as Sprite;
            while(_loc2_.numChildren)
            {
               _loc1_ = _loc2_.getChildAt(0) as MapAreaShape;
               _loc1_.remove();
               _loc2_.removeChildAt(0);
            }
            _loc4_++;
         }
      }
      
      private function updateIconSize() : void
      {
         var _loc3_:MapIconElement = null;
         var _loc4_:MapElement = null;
         if(!this.autoSizeIcon || this._lastScaleIconUpdate == this._mapContainer.scaleX)
         {
            return;
         }
         this._lastScaleIconUpdate = this._mapContainer.scaleX;
         var _loc1_:DisplayObject = this._mapContainer;
         var _loc2_:Number = this._mapContainer.scaleX;
         while(_loc1_ && _loc1_.parent)
         {
            _loc1_ = _loc1_.parent;
            _loc2_ = _loc2_ * _loc1_.scaleX;
         }
         this._lastIconScale = 1 / _loc2_;
         this._lastIconScale = !!this._needIconResize?Number(this._lastIconScale * 0.6):Number(this._lastIconScale);
         for each(_loc4_ in this._mapElements)
         {
            _loc3_ = _loc4_ as MapIconElement;
            if(!(!_loc3_ || !_loc3_.canBeAutoSize))
            {
               _loc3_.textureScale = this._lastIconScale;
            }
         }
      }
      
      private function forceMapRollOver() : void
      {
         this._mouseOnArrow = false;
         Berilia.getInstance().handler.process(new MapRollOverMessage(this,Math.floor((this._mapBitmapContainer.mouseX - this.origineX) / this.mapWidth),Math.floor((this._mapBitmapContainer.mouseY - this.origineY) / this.mapHeight)));
      }
      
      private function clearMap(param1:Map) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = param1.areas.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            param1.areas[_loc2_].free();
            _loc2_++;
         }
         if(param1.container.parent == this._mapBitmapContainer)
         {
            this._mapBitmapContainer.removeChild(param1.container);
         }
         param1 = null;
      }
      
      override public function process(param1:Message) : Boolean
      {
         var _loc2_:* = false;
         var _loc3_:TextureReadyMessage = null;
         var _loc4_:MouseOverMessage = null;
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:MouseOutMessage = null;
         var _loc7_:Boolean = false;
         var _loc8_:MouseDownMessage = null;
         var _loc9_:MouseClickMessage = null;
         var _loc10_:MouseWheelMessage = null;
         var _loc11_:Point = null;
         var _loc12_:int = 0;
         var _loc13_:MouseRightClickMessage = null;
         var _loc14_:MapElement = null;
         var _loc15_:MapElement = null;
         switch(true)
         {
            case param1 is TextureReadyMessage:
               _loc3_ = param1 as TextureReadyMessage;
               _loc3_.texture.gotoAndPlay = 1;
               break;
            case param1 is MouseOverMessage:
               _loc4_ = param1 as MouseOverMessage;
               _loc2_ = Boolean(this._isMouseOver);
               this._isMouseOver = mouseX >= 0 && mouseY >= 0 && mouseX <= width && mouseY <= height;
               Mouse.cursor = MouseCursor.HAND;
               this._currentMapIcon.visible = true;
               _loc5_ = _loc4_.target as DisplayObjectContainer;
               while(_loc5_)
               {
                  if(_loc5_ == this)
                  {
                     if(!EnterFrameDispatcher.hasEventListener(this.onMapEnterFrame))
                     {
                        EnterFrameDispatcher.addEventListener(this.onMapEnterFrame,"mapMouse");
                     }
                     break;
                  }
                  _loc5_ = _loc5_.parent;
               }
               if(_loc5_ != this)
               {
                  _loc2_ = true;
                  this._isMouseOver = false;
               }
               this._mouseOnArrow = _loc4_.target.parent == this._arrowContainer?true:false;
               if(_loc4_.target is MapGroupElement)
               {
                  this._openedMapGroupElement = MapGroupElement(_loc4_.target);
               }
               else if(_loc4_.target.parent is MapGroupElement)
               {
                  this._openedMapGroupElement = MapGroupElement(_loc4_.target.parent);
               }
               else if(!this._mouseOnArrow && this._mapGroupElements[this._elementsByElementTexture[_loc4_.target]] is MapGroupElement)
               {
                  this._openedMapGroupElement = this._mapGroupElements[this._elementsByElementTexture[_loc4_.target]];
               }
               if(this._elementsByElementTexture[_loc4_.target])
               {
                  Berilia.getInstance().handler.process(new MapElementRollOverMessage(this,this._elementsByElementTexture[_loc4_.target]));
               }
               else if(this._elementTexturesByArrow[_loc4_.target] && this._elementsByElementTexture[this._elementTexturesByArrow[_loc4_.target]])
               {
                  Berilia.getInstance().handler.process(new MapElementRollOverMessage(this,this._elementsByElementTexture[this._elementTexturesByArrow[_loc4_.target]]));
               }
               return _loc2_;
            case param1 is MouseOutMessage:
               _loc6_ = param1 as MouseOutMessage;
               _loc7_ = mouseX >= 0 && mouseY >= 0 && mouseX <= width && mouseY <= height;
               _loc2_ = this._isMouseOver == _loc7_;
               this._isMouseOver = _loc7_;
               Mouse.cursor = MouseCursor.AUTO;
               if(!_loc6_.mouseEvent.relatedObject || !contains(_loc6_.mouseEvent.relatedObject))
               {
                  this._currentMapIcon.visible = false;
                  Berilia.getInstance().handler.process(new MapRollOutMessage(this));
               }
               _loc5_ = _loc6_.target as DisplayObjectContainer;
               while(_loc5_)
               {
                  if(_loc5_ == this)
                  {
                     if(!this._dragging && EnterFrameDispatcher.hasEventListener(this.onMapEnterFrame))
                     {
                        EnterFrameDispatcher.removeEventListener(this.onMapEnterFrame);
                     }
                     break;
                  }
                  _loc5_ = _loc5_.parent;
               }
               if(_loc5_ != this)
               {
                  _loc2_ = false;
                  this._isMouseOver = false;
               }
               this._mouseOnArrow = false;
               if(this._openedMapGroupElement)
               {
                  if(this._openedMapGroupElement.opened)
                  {
                     this._openedMapGroupElement.close();
                     this._openedMapGroupElement = null;
                  }
               }
               if(this._elementsByElementTexture[_loc6_.target])
               {
                  Berilia.getInstance().handler.process(new MapElementRollOutMessage(this,this._elementsByElementTexture[_loc6_.target]));
               }
               else if(this._elementTexturesByArrow[_loc6_.target] && this._elementsByElementTexture[this._elementTexturesByArrow[_loc6_.target]])
               {
                  Berilia.getInstance().handler.process(new MapElementRollOutMessage(this,this._elementsByElementTexture[this._elementTexturesByArrow[_loc6_.target]]));
               }
               return _loc2_;
            case param1 is MouseDownMessage:
               _loc8_ = param1 as MouseDownMessage;
               if(ShortcutsFrame.shiftKey)
               {
                  _loc14_ = !!this._elementsByElementTexture[_loc8_.target]?this._elementsByElementTexture[_loc8_.target]:this._elementsByElementTexture[this._elementTexturesByArrow[_loc8_.target]];
                  KernelEventsManager.getInstance().processCallback(BeriliaHookList.MouseShiftClick,{
                     "data":this,
                     "params":{
                        "x":this._lastMx,
                        "y":this._lastMy,
                        "element":_loc14_ as MapIconElement
                     }
                  });
               }
               if(!this.enabledDrag)
               {
                  return false;
               }
               this._dragging = true;
               return false;
            case param1 is MouseClickMessage:
               _loc9_ = param1 as MouseClickMessage;
               if(this._elementTexturesByArrow[_loc9_.target])
               {
                  TooltipManager.hide();
                  _loc15_ = this._elementsByElementTexture[this._elementTexturesByArrow[_loc9_.target]];
                  this.moveTo(_loc15_.x,_loc15_.y);
               }
               break;
            case param1 is MouseReleaseOutsideMessage:
            case param1 is MouseUpMessage:
               this._dragging = false;
               this._lastMouseX = 0;
               this.updateVisibleChunck();
               Berilia.getInstance().handler.process(new MapMoveMessage(this));
               return false;
            case param1 is MouseWheelMessage:
               _loc10_ = param1 as MouseWheelMessage;
               if(getTimer() - this._lastWheelZoom < 100)
               {
                  this._currentZoomStep = this._currentZoomStep + this.zoomStep;
               }
               else
               {
                  this._currentZoomStep = this.zoomStep;
               }
               _loc5_ = _loc10_.target as DisplayObjectContainer;
               while(_loc5_)
               {
                  if(_loc5_ == this._mapContainer)
                  {
                     _loc11_ = new Point(_loc5_.mouseX,_loc5_.mouseY);
                     break;
                  }
                  _loc5_ = _loc5_.parent;
               }
               if(!_loc11_)
               {
                  return true;
               }
               _loc12_ = this._mapContainer.scaleX * 100 + (_loc10_.mouseEvent.delta > 0?100:-100) * this._currentZoomStep;
               this.zoomWithScalePercent(_loc12_,_loc11_);
               Berilia.getInstance().handler.process(new MapMoveMessage(this));
               this._lastWheelZoom = getTimer();
               return true;
            case param1 is MouseRightClickMessage:
               _loc13_ = param1 as MouseRightClickMessage;
               if(this._elementsByElementTexture[_loc13_.target])
               {
                  Berilia.getInstance().handler.process(new MapElementRightClickMessage(this,this._elementsByElementTexture[_loc13_.target]));
               }
               else if(this._elementTexturesByArrow[_loc13_.target] && this._elementsByElementTexture[this._elementTexturesByArrow[_loc13_.target]])
               {
                  Berilia.getInstance().handler.process(new MapElementRightClickMessage(this,this._elementsByElementTexture[this._elementTexturesByArrow[_loc13_.target]]));
               }
               return false;
         }
         return false;
      }
      
      private function onMapEnterFrame(param1:Event) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(!stage && !this._enable3DMode)
         {
            return;
         }
         if(this._mapToClear && this.allChunksLoaded)
         {
            this.clearMap(this._mapToClear);
            this._mapToClear = null;
         }
         var _loc2_:Number = !!this._enable3DMode?Number(StageShareManager.mouseX):Number(stage.mouseX);
         var _loc3_:Number = !!this._enable3DMode?Number(StageShareManager.mouseY):Number(stage.mouseY);
         if(this._dragging && (this._lastMouseX != _loc2_ || this._lastMouseY != _loc3_))
         {
            _loc6_ = this._mapContainer.x + (!!this._enable3DMode?-(_loc2_ - this._lastMouseX):_loc2_ - this._lastMouseX);
            _loc7_ = this._mapContainer.y + (!!this._enable3DMode?-(_loc3_ - this._lastMouseY):_loc3_ - this._lastMouseY);
            if(this._lastMouseX && (this._enable3DMode || _loc6_ <= 0 && Math.round(_loc6_ + this._currentMap.initialWidth * this._mapContainer.scaleX) >= width))
            {
               this._mapContainer.x = _loc6_;
            }
            if(this._lastMouseX && (this._enable3DMode || _loc7_ <= 0 && Math.round(_loc7_ + this._currentMap.initialHeight * this._mapContainer.scaleY) >= height))
            {
               this._mapContainer.y = _loc7_;
            }
            this.updateVisibleChunck();
            this._lastMouseX = _loc2_;
            this._lastMouseY = _loc3_;
         }
         var _loc4_:int = this.mouseX;
         var _loc5_:int = this.mouseY;
         if(_loc4_ > 0 && _loc4_ < __width && _loc5_ > 0 && _loc5_ < __height)
         {
            _loc8_ = Math.floor((this._mapBitmapContainer.mouseX - this.origineX) / this.mapWidth);
            _loc9_ = Math.floor((this._mapBitmapContainer.mouseY - this.origineY) / this.mapHeight);
            if(!this._mouseOnArrow && (_loc8_ != this._lastMx || _loc9_ != this._lastMy))
            {
               this._lastMx = _loc8_;
               this._lastMy = _loc9_;
               this.onRollOverChunk();
            }
         }
         else
         {
            this._lastMx = Number.NaN;
            this._lastMy = Number.NaN;
         }
      }
      
      private function onRollOverChunk() : void
      {
         var _loc1_:MapGroupElement = null;
         this._currentMapIcon.x = this._lastMx * this.mapWidth + this.origineX + this.mapWidth / 2;
         this._currentMapIcon.y = this._lastMy * this.mapHeight + this.origineY + this.mapHeight / 2;
         this._currentMapIcon.scaleX = this._currentMapIcon.scaleY = this.mapWidth / this._currentMapIcon.width;
         if(this._openedMapGroupElement && this._openedMapGroupElement.parent)
         {
            this._openedMapGroupElement.parent.setChildIndex(this._openedMapGroupElement,this._openMapGroupElementIndex);
            this._openedMapGroupElement.close();
            this._openedMapGroupElement = null;
         }
         var _loc2_:Array = this._elementsListsByCoordinates[this._lastMx + "_" + this._lastMy];
         if(_loc2_ && _loc2_.length > 1)
         {
            _loc1_ = this._mapGroupElements[_loc2_[0]];
            if(_loc1_ && !this._openedMapGroupElement)
            {
               this._openMapGroupElementIndex = _loc1_.parent.getChildIndex(_loc1_);
               _loc1_.parent.setChildIndex(_loc1_,_loc1_.parent.numChildren - 1);
               _loc1_.open();
               this._openedMapGroupElement = _loc1_;
            }
         }
         Berilia.getInstance().handler.process(new MapRollOverMessage(this,this._lastMx,this._lastMy));
      }
      
      private function onWindowDeactivate(param1:Event) : void
      {
         if(this._dragging)
         {
            this.process(new MouseUpMessage());
         }
      }
   }
}
