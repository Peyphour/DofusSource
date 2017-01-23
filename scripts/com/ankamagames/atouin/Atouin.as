package com.ankamagames.atouin
{
   import com.ankamagames.atouin.data.elements.Elements;
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.managers.FrustumManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.messages.MapContainerRollOutMessage;
   import com.ankamagames.atouin.messages.MapContainerRollOverMessage;
   import com.ankamagames.atouin.messages.MapZoomMessage;
   import com.ankamagames.atouin.resources.adapters.ElementsAdapter;
   import com.ankamagames.atouin.resources.adapters.MapsAdapter;
   import com.ankamagames.atouin.types.AtouinOptions;
   import com.ankamagames.atouin.types.Frustum;
   import com.ankamagames.atouin.utils.errors.AtouinError;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.interfaces.ISoundPositionListener;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import com.ankamagames.jerakine.pathfinding.Pathfinding;
   import com.ankamagames.jerakine.resources.adapters.AdapterFactory;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.getQualifiedClassName;
   
   public class Atouin
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Atouin));
      
      private static var _self:Atouin;
       
      
      private var _worldContainer:DisplayObjectContainer;
      
      private var _overlayContainer:Sprite;
      
      private var _spMapContainer:Sprite;
      
      private var _spGfxContainer:Sprite;
      
      private var _spChgMapContainer:Sprite;
      
      private var _worldMask:Sprite;
      
      private var _currentZoom:Number = 1;
      
      private var _zoomPosX:int;
      
      private var _zoomPosY:int;
      
      private var _movementListeners:Array;
      
      private var _handler:MessageHandler;
      
      private var _aSprites:Array;
      
      private var _aoOptions:AtouinOptions;
      
      private var _cursorUpdateSprite:Sprite;
      
      private var _worldVisible:Boolean = true;
      
      public function Atouin()
      {
         super();
         if(_self)
         {
            throw new AtouinError("Atouin is a singleton class. Please acces it through getInstance()");
         }
         AdapterFactory.addAdapter("ele",ElementsAdapter);
         AdapterFactory.addAdapter("dlm",MapsAdapter);
         this._cursorUpdateSprite = new Sprite();
         this._cursorUpdateSprite.graphics.beginFill(65280,0);
         this._cursorUpdateSprite.graphics.drawRect(0,0,6,6);
         this._cursorUpdateSprite.graphics.endFill();
         this._cursorUpdateSprite.useHandCursor = true;
      }
      
      public static function getInstance() : Atouin
      {
         if(!_self)
         {
            _self = new Atouin();
         }
         return _self;
      }
      
      public function get worldVisible() : Boolean
      {
         return this._worldVisible;
      }
      
      public function get movementListeners() : Array
      {
         return this._movementListeners;
      }
      
      public function get worldContainer() : DisplayObjectContainer
      {
         return this._spMapContainer;
      }
      
      public function get selectionContainer() : DisplayObjectContainer
      {
         var _loc2_:DisplayObjectContainer = null;
         var _loc3_:int = 0;
         if(this._spMapContainer == null)
         {
            return null;
         }
         var _loc1_:Number = this._spMapContainer.numChildren;
         if(_loc1_ > 1)
         {
            _loc3_ = 1;
            while(!_loc2_ && _loc3_ < _loc1_)
            {
               _loc2_ = this._spMapContainer.getChildAt(_loc3_) as DisplayObjectContainer;
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function get chgMapContainer() : DisplayObjectContainer
      {
         return this._spChgMapContainer;
      }
      
      public function get gfxContainer() : DisplayObjectContainer
      {
         return this._spGfxContainer;
      }
      
      public function get overlayContainer() : DisplayObjectContainer
      {
         return this._overlayContainer;
      }
      
      public function get worldMask() : DisplayObjectContainer
      {
         return this._worldMask;
      }
      
      public function get handler() : MessageHandler
      {
         return this._handler;
      }
      
      public function set handler(param1:MessageHandler) : void
      {
         this._handler = param1;
      }
      
      public function get options() : AtouinOptions
      {
         return this._aoOptions;
      }
      
      public function get currentZoom() : Number
      {
         return this._currentZoom;
      }
      
      public function set currentZoom(param1:Number) : void
      {
         this._currentZoom = param1;
      }
      
      public function get cellOverEnabled() : Boolean
      {
         return InteractiveCellManager.getInstance().cellOverEnabled;
      }
      
      public function set cellOverEnabled(param1:Boolean) : void
      {
         InteractiveCellManager.getInstance().cellOverEnabled = param1;
      }
      
      public function get rootContainer() : DisplayObjectContainer
      {
         return this._worldContainer;
      }
      
      public function get worldIsVisible() : Boolean
      {
         return this._worldContainer.contains(this._spMapContainer);
      }
      
      public function setDisplayOptions(param1:AtouinOptions) : void
      {
         var _loc4_:Sprite = null;
         this._aoOptions = param1;
         this._worldContainer = param1.container;
         this._handler = param1.handler;
         this._aoOptions.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChange);
         var _loc2_:uint = 0;
         while(_loc2_ < this._worldContainer.numChildren)
         {
            this._worldContainer.removeChildAt(_loc2_);
            _loc2_++;
         }
         this._overlayContainer = new Sprite();
         this._spMapContainer = new Sprite();
         this._spChgMapContainer = new Sprite();
         this._spGfxContainer = new Sprite();
         this._worldMask = new Sprite();
         this._worldContainer.mouseEnabled = false;
         this._spMapContainer.addEventListener(MouseEvent.ROLL_OUT,this.onRollOutMapContainer);
         this._spMapContainer.addEventListener(MouseEvent.ROLL_OVER,this.onRollOverMapContainer);
         this._spMapContainer.tabChildren = false;
         this._spMapContainer.mouseEnabled = false;
         this._spChgMapContainer.tabChildren = false;
         this._spChgMapContainer.mouseEnabled = false;
         this._spGfxContainer.tabChildren = false;
         this._spGfxContainer.mouseEnabled = false;
         this._spGfxContainer.mouseChildren = false;
         this._overlayContainer.tabChildren = false;
         this._overlayContainer.mouseEnabled = false;
         this._worldMask.mouseEnabled = false;
         this._worldContainer.addChild(this._spMapContainer);
         this._worldContainer.addChild(this._spChgMapContainer);
         this._worldContainer.addChild(this._worldMask);
         this._worldContainer.addChild(this._spGfxContainer);
         this._worldContainer.addChild(this._overlayContainer);
         FrustumManager.getInstance().init(this._spChgMapContainer);
         this._worldContainer.name = "worldContainer";
         this._spMapContainer.name = "mapContainer";
         this._worldMask.name = "worldMask";
         this._spChgMapContainer.name = "chgMapContainer";
         this._spGfxContainer.name = "gfxContainer";
         this._overlayContainer.name = "overlayContainer";
         this.computeWideScreenBitmapWidth(param1.frustum);
         this.setWorldMaskDimensions(AtouinConstants.WIDESCREEN_BITMAP_WIDTH);
         var _loc3_:Boolean = this._aoOptions.hideBlackBorder;
         if(!_loc3_)
         {
            this.setWorldMaskDimensions(StageShareManager.startWidth,0,0,1,"blackBorder");
            this.getWorldMask("blackBorder",false).mouseEnabled = true;
         }
         else
         {
            _loc4_ = this.getWorldMask("blackBorder",false);
            if(_loc4_)
            {
               _loc4_.parent.removeChild(_loc4_);
            }
         }
         this.setFrustrum(param1.frustum);
         this.init();
      }
      
      protected function onPropertyChange(param1:PropertyChangeEvent) : void
      {
         var _loc2_:Sprite = null;
         switch(param1.propertyName)
         {
            case "hideBlackBorder":
               if(!param1.propertyValue)
               {
                  this.setWorldMaskDimensions(StageShareManager.startWidth,0,0,1,"blackBorder");
                  this.getWorldMask("blackBorder",false).mouseEnabled = true;
               }
               else
               {
                  _loc2_ = this.getWorldMask("blackBorder",false);
                  if(_loc2_)
                  {
                     _loc2_.parent.removeChild(_loc2_);
                  }
               }
         }
      }
      
      private function computeWideScreenBitmapWidth(param1:Frustum) : void
      {
         var _loc2_:int = (AtouinConstants.ADJACENT_CELL_LEFT_MARGIN - 1) * AtouinConstants.CELL_WIDTH;
         var _loc3_:int = (AtouinConstants.ADJACENT_CELL_RIGHT_MARGIN - 1) * AtouinConstants.CELL_WIDTH;
         var _loc4_:uint = AtouinConstants.CELL_WIDTH * AtouinConstants.MAP_WIDTH + AtouinConstants.CELL_WIDTH;
         AtouinConstants.WIDESCREEN_BITMAP_WIDTH = _loc4_ + _loc2_ + _loc3_;
         StageShareManager.stageLogicalBounds = new Rectangle(-(AtouinConstants.WIDESCREEN_BITMAP_WIDTH - StageShareManager.startWidth) / 2,0,AtouinConstants.WIDESCREEN_BITMAP_WIDTH,StageShareManager.startHeight);
      }
      
      public function setWorldMaskDimensions(param1:uint, param2:uint = 0, param3:uint = 0, param4:Number = 1.0, param5:String = "default") : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc6_:Sprite = this.getWorldMask(param5);
         if(_loc6_)
         {
            _loc6_.graphics.clear();
            _loc6_.graphics.beginFill(param3,param4);
            _loc7_ = param1;
            _loc8_ = StageShareManager.startHeight - param2;
            _loc9_ = StageShareManager.startWidth - _loc7_;
            if(_loc9_)
            {
               _loc9_ = _loc9_ / 2;
            }
            _loc6_.graphics.drawRect(-2000,-2000,4000 + _loc7_,4000 + _loc8_);
            _loc6_.graphics.drawRect(_loc9_,0,_loc7_,_loc8_);
            _loc6_.graphics.endFill();
         }
      }
      
      public function toggleWorldMask(param1:String = "default", param2:* = null) : void
      {
         var _loc3_:Sprite = this.getWorldMask(param1);
         if(_loc3_)
         {
            _loc3_.visible = param2 === null?!_loc3_.visible:Boolean(param2);
         }
      }
      
      public function getWorldMask(param1:String, param2:Boolean = true) : Sprite
      {
         var _loc3_:uint = 0;
         while(_loc3_ < this._worldMask.numChildren)
         {
            if(this._worldMask.getChildAt(_loc3_).name == param1)
            {
               return this._worldMask.getChildAt(_loc3_) as Sprite;
            }
            _loc3_++;
         }
         if(!param2)
         {
            return null;
         }
         var _loc4_:Sprite = new Sprite();
         this._worldMask.addChild(_loc4_);
         _loc4_.name = param1;
         _loc4_.mouseEnabled = false;
         _loc4_.mouseChildren = false;
         return _loc4_;
      }
      
      public function onRollOverMapContainer(param1:Event) : void
      {
         var _loc2_:MapContainerRollOverMessage = new MapContainerRollOverMessage();
         Atouin.getInstance().handler.process(_loc2_);
      }
      
      private function onRollOutMapContainer(param1:Event) : void
      {
         var _loc2_:MapContainerRollOutMessage = new MapContainerRollOutMessage();
         Atouin.getInstance().handler.process(_loc2_);
      }
      
      public function updateCursor() : void
      {
         this._cursorUpdateSprite.x = StageShareManager.stage.mouseX - 3;
         this._cursorUpdateSprite.y = StageShareManager.stage.mouseY - 3;
         StageShareManager.stage.addChild(this._cursorUpdateSprite);
         EnterFrameDispatcher.addEventListener(this.removeUpdateCursorSprite,"UpdateCursorSprite",50);
      }
      
      public function showWorld(param1:Boolean) : void
      {
         this._spMapContainer.visible = param1;
         this._spChgMapContainer.visible = param1;
         this._spGfxContainer.visible = param1;
         this._overlayContainer.visible = param1;
         this._worldVisible = param1;
      }
      
      public function setFrustrum(param1:Frustum) : void
      {
         if(!this._aoOptions)
         {
            _log.error("Please call setDisplayOptions once before calling setFrustrum");
            return;
         }
         this._aoOptions.frustum = param1;
         this.worldContainer.scaleX = this._aoOptions.frustum.scale;
         this.worldContainer.scaleY = this._aoOptions.frustum.scale;
         this.worldContainer.x = this._aoOptions.frustum.x;
         this.worldContainer.y = this._aoOptions.frustum.y;
         this.gfxContainer.scaleX = this._aoOptions.frustum.scale;
         this.gfxContainer.scaleY = this._aoOptions.frustum.scale;
         this.gfxContainer.x = this._aoOptions.frustum.x;
         this.gfxContainer.y = this._aoOptions.frustum.y;
         this.overlayContainer.x = this._aoOptions.frustum.x;
         this.overlayContainer.y = this._aoOptions.frustum.y;
         this.overlayContainer.scaleX = this._aoOptions.frustum.scale;
         this.overlayContainer.scaleY = this._aoOptions.frustum.scale;
         FrustumManager.getInstance().frustum = param1;
      }
      
      public function initPreDisplay(param1:WorldPoint) : void
      {
         if(param1 && MapDisplayManager.getInstance() && MapDisplayManager.getInstance().currentMapPoint && MapDisplayManager.getInstance().currentMapPoint.mapId == param1.mapId)
         {
            return;
         }
         MapDisplayManager.getInstance().capture();
      }
      
      public function display(param1:WorldPoint, param2:ByteArray = null, param3:Boolean = true) : uint
      {
         return MapDisplayManager.getInstance().display(param1,false,param2,true,param3);
      }
      
      public function getEntity(param1:Number) : IEntity
      {
         return EntitiesManager.getInstance().getEntity(param1);
      }
      
      public function getEntityOnCell(param1:uint, param2:* = null) : IEntity
      {
         return EntitiesManager.getInstance().getEntityOnCell(param1,param2);
      }
      
      public function clearEntities() : void
      {
         EntitiesManager.getInstance().clearEntities();
      }
      
      public function reset() : void
      {
         InteractiveCellManager.getInstance().clean();
         MapDisplayManager.getInstance().reset();
         EntitiesManager.getInstance().clearEntities();
         this.cancelZoom();
         if(this._spMapContainer.parent)
         {
            this._worldContainer.removeChild(this._spMapContainer);
         }
         if(this._spChgMapContainer.parent)
         {
            this._worldContainer.removeChild(this._spChgMapContainer);
         }
         if(this._spGfxContainer.parent)
         {
            this._worldContainer.removeChild(this._spGfxContainer);
         }
         if(this._overlayContainer.parent)
         {
            this._worldContainer.removeChild(this._overlayContainer);
         }
      }
      
      public function displayGrid(param1:Boolean, param2:Boolean = false) : void
      {
         InteractiveCellManager.getInstance().show(param1 || this.options.alwaysShowGrid,param2);
      }
      
      public function getIdentifiedElement(param1:uint) : InteractiveObject
      {
         return MapDisplayManager.getInstance().getIdentifiedElement(param1);
      }
      
      public function getIdentifiedElementPosition(param1:uint) : MapPoint
      {
         return MapDisplayManager.getInstance().getIdentifiedElementPosition(param1);
      }
      
      public function addListener(param1:ISoundPositionListener) : void
      {
         if(this._movementListeners == null)
         {
            this._movementListeners = new Array();
         }
         this._movementListeners.push(param1);
      }
      
      public function removeListener(param1:ISoundPositionListener) : void
      {
         var _loc2_:int = Atouin.getInstance()._movementListeners.indexOf(param1);
         if(_loc2_)
         {
            Atouin.getInstance()._movementListeners.splice(_loc2_,1);
         }
      }
      
      public function zoom(param1:Number, param2:int = 0, param3:int = 0) : void
      {
         var _loc5_:Number = NaN;
         if(param1 == 1)
         {
            this._worldContainer.scaleX = 1;
            this._worldContainer.scaleY = 1;
            this._worldContainer.x = 0;
            this._worldContainer.y = 0;
            this._currentZoom = 1;
            MapDisplayManager.getInstance().cacheAsBitmapEnabled(true);
         }
         else
         {
            if(param1 < 1)
            {
               param1 = 1;
            }
            else if(param1 > AtouinConstants.MAX_ZOOM)
            {
               param1 = AtouinConstants.MAX_ZOOM;
            }
            _loc5_ = this._currentZoom;
            this._currentZoom = param1;
            if(_loc5_ == this._currentZoom)
            {
               return;
            }
            if(this._currentZoom != 1)
            {
               MapDisplayManager.getInstance().cacheAsBitmapEnabled(false);
            }
            if(param2)
            {
               this._zoomPosX = param2;
            }
            else
            {
               param2 = this._zoomPosX;
            }
            if(param3)
            {
               this._zoomPosY = param3;
            }
            else
            {
               param3 = this._zoomPosY;
            }
            this._worldContainer.x = this._worldContainer.x - (param2 * this._currentZoom - param2 * this._worldContainer.scaleX);
            this._worldContainer.y = this._worldContainer.y - (param3 * this._currentZoom - param3 * this._worldContainer.scaleY);
            this._worldContainer.scaleX = this._currentZoom;
            this._worldContainer.scaleY = this._currentZoom;
            if(this._worldContainer.x > 0)
            {
               this._worldContainer.x = 0;
            }
            else if(this._worldContainer.x < 1276 - 1276 * this._currentZoom)
            {
               this._worldContainer.x = 1276 - 1276 * this._currentZoom;
            }
            if(this._worldContainer.y > 0)
            {
               this._worldContainer.y = 0;
            }
            else if(this._worldContainer.y < 876 - 876 * this._currentZoom)
            {
               this._worldContainer.y = 876 - 876 * this._currentZoom;
            }
         }
         var _loc4_:MapZoomMessage = new MapZoomMessage(param1,param2,param3);
         Atouin.getInstance().handler.process(_loc4_);
      }
      
      public function cancelZoom() : void
      {
         if(this._currentZoom != 1)
         {
            this.zoom(1);
         }
      }
      
      public function applyMapZoomScale(param1:Map) : void
      {
         if(param1.zoomScale != 1 && this._aoOptions.useInsideAutoZoom)
         {
            this._currentZoom = param1.zoomScale;
            this._worldContainer.x = param1.zoomOffsetX;
            this._worldContainer.y = param1.zoomOffsetY;
            this._worldContainer.scaleX = param1.zoomScale;
            this._worldContainer.scaleY = param1.zoomScale;
         }
         else
         {
            this.zoom(1);
         }
      }
      
      public function loadElementsFile() : void
      {
         var _loc1_:IResourceLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
         _loc1_.addEventListener(ResourceErrorEvent.ERROR,this.onElementsError,false,0,true);
         _loc1_.load(new Uri(Atouin.getInstance().options.elementsIndexPath));
      }
      
      private function removeUpdateCursorSprite(param1:Event) : void
      {
         EnterFrameDispatcher.removeEventListener(this.removeUpdateCursorSprite);
         if(this._cursorUpdateSprite.parent)
         {
            this._cursorUpdateSprite.parent.removeChild(this._cursorUpdateSprite);
         }
      }
      
      private function init() : void
      {
         this._aSprites = new Array();
         if(!Elements.getInstance().parsed)
         {
            this.loadElementsFile();
         }
         Pathfinding.init(AtouinConstants.PATHFINDER_MIN_X,AtouinConstants.PATHFINDER_MAX_X,AtouinConstants.PATHFINDER_MIN_Y,AtouinConstants.PATHFINDER_MAX_Y);
      }
      
      private function onElementsError(param1:ResourceErrorEvent) : void
      {
         _log.error("Atouin was unable to retrieve the elements directory (" + param1.errorMsg + ")");
      }
   }
}
