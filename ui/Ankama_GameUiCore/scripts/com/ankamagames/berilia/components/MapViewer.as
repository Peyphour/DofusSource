package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class MapViewer extends GraphicContainer
   {
       
      
      public function MapViewer()
      {
         super();
      }
      
      public function get mapWidth() : Number
      {
         return new Number();
      }
      
      public function set mapWidth(param1:Number) : void
      {
      }
      
      public function get mapHeight() : Number
      {
         return new Number();
      }
      
      public function set mapHeight(param1:Number) : void
      {
      }
      
      public function get origineX() : int
      {
         return new int();
      }
      
      public function set origineX(param1:int) : void
      {
      }
      
      public function get origineY() : int
      {
         return new int();
      }
      
      public function set origineY(param1:int) : void
      {
      }
      
      public function get maxScale() : Number
      {
         return new Number();
      }
      
      public function set maxScale(param1:Number) : void
      {
      }
      
      public function get minScale() : Number
      {
         return new Number();
      }
      
      public function set minScale(param1:Number) : void
      {
      }
      
      public function get startScale() : Number
      {
         return new Number();
      }
      
      public function set startScale(param1:Number) : void
      {
      }
      
      public function get roundCornerRadius() : uint
      {
         return new uint();
      }
      
      public function set roundCornerRadius(param1:uint) : void
      {
      }
      
      public function get enabledDrag() : Boolean
      {
         return new Boolean();
      }
      
      public function set enabledDrag(param1:Boolean) : void
      {
      }
      
      public function get autoSizeIcon() : Boolean
      {
         return new Boolean();
      }
      
      public function set autoSizeIcon(param1:Boolean) : void
      {
      }
      
      public function get gridLineThickness() : Number
      {
         return new Number();
      }
      
      public function set gridLineThickness(param1:Number) : void
      {
      }
      
      public function get needMask() : Boolean
      {
         return new Boolean();
      }
      
      public function set needMask(param1:Boolean) : void
      {
      }
      
      public function set onMapElementsUpdated(param1:Function) : void
      {
      }
      
      public function get mapContainerBounds() : Rectangle
      {
         return null;
      }
      
      public function get showGrid() : Boolean
      {
         return false;
      }
      
      public function set showGrid(param1:Boolean) : void
      {
      }
      
      public function get isDragging() : Boolean
      {
         return false;
      }
      
      public function get visibleMaps() : Rectangle
      {
         return null;
      }
      
      public function get currentMouseMapX() : int
      {
         return 0;
      }
      
      public function get currentMouseMapY() : int
      {
         return 0;
      }
      
      public function get currentMapBounds() : Rectangle
      {
         return null;
      }
      
      public function getMapBounds(param1:int, param2:int) : Rectangle
      {
         return null;
      }
      
      public function get mapBounds() : Rectangle
      {
         return null;
      }
      
      public function set mapAlpha(param1:Number) : void
      {
      }
      
      public function get mapPixelPosition() : Point
      {
         return null;
      }
      
      public function get zoomFactor() : Number
      {
         return 0;
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
      }
      
      public function get zoomStep() : Number
      {
         return 0;
      }
      
      public function get zoomLevels() : Array
      {
         return null;
      }
      
      public function get allLayersVisible() : Boolean
      {
         return false;
      }
      
      public function isLayerVisible(param1:String) : Boolean
      {
         return false;
      }
      
      public function set mapScale(param1:Number) : void
      {
      }
      
      public function get mouseOnArrow() : Boolean
      {
         return false;
      }
      
      public function set currentMapIconVisible(param1:Boolean) : void
      {
      }
      
      public function get currentMapIconVisible() : Boolean
      {
         return false;
      }
      
      public function setupZoomLevels(param1:Number, param2:Number) : void
      {
      }
      
      public function addLayer(param1:String) : void
      {
      }
      
      public function addIcon(param1:String, param2:String, param3:String, param4:int, param5:int, param6:Number = 1, param7:String = null, param8:Boolean = false, param9:int = -1, param10:Boolean = true, param11:Boolean = true, param12:Rectangle = null, param13:Boolean = false, param14:Boolean = false, param15:uint = 0) : Object
      {
         return null;
      }
      
      public function addAreaShape(param1:String, param2:String, param3:Object, param4:uint = 0, param5:Number = 1, param6:uint = 0, param7:Number = 0.4, param8:int = 4) : Object
      {
         return null;
      }
      
      public function areaShapeColorTransform(param1:Object, param2:int, param3:Number = 1, param4:Number = 1, param5:Number = 1, param6:Number = 1, param7:Number = 0, param8:Number = 0, param9:Number = 0, param10:Number = 0) : void
      {
      }
      
      public function getMapElement(param1:String) : Object
      {
         return null;
      }
      
      public function getMapElementsByLayer(param1:String) : Array
      {
         return null;
      }
      
      public function getMapElementsAtCoordinates(param1:int, param2:int) : Array
      {
         return null;
      }
      
      public function removeMapElement(param1:Object) : void
      {
      }
      
      public function updateMapElements() : void
      {
      }
      
      public function updateMapAreaShape(param1:Object) : void
      {
      }
      
      public function showLayer(param1:String, param2:Boolean = true) : void
      {
      }
      
      public function showAllLayers(param1:Boolean = true) : void
      {
      }
      
      public function moveToPixel(param1:int, param2:int, param3:Number) : void
      {
      }
      
      public function moveTo(param1:Number, param2:Number, param3:uint = 1, param4:uint = 1, param5:Boolean = true, param6:Boolean = true) : void
      {
      }
      
      public function zoom(param1:Number, param2:Point = null) : void
      {
      }
      
      public function addMap(param1:Number, param2:String, param3:uint, param4:uint, param5:uint, param6:uint) : void
      {
      }
      
      public function removeAllMap() : void
      {
      }
      
      public function getOrigineFromPos(param1:int, param2:int) : Point
      {
         return null;
      }
      
      public function set useFlagCursor(param1:Boolean) : void
      {
      }
      
      public function get useFlagCursor() : Boolean
      {
         return false;
      }
      
      public function get allChunksLoaded() : Boolean
      {
         return false;
      }
   }
}
