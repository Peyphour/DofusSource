package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.datacenter.world.WorldMap;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import flash.geom.Point;
   
   public class MapApi
   {
       
      
      public function MapApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getCurrentSubArea() : SubArea
      {
         return null;
      }
      
      [Untrusted]
      public function getCurrentWorldMap() : WorldMap
      {
         return null;
      }
      
      [Untrusted]
      public function getAllSuperArea() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getAllArea() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getAllSubArea() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getSubArea(param1:uint) : SubArea
      {
         return null;
      }
      
      [Untrusted]
      public function getSubAreaMapIds(param1:uint) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getSubAreaCenter(param1:uint) : Point
      {
         return null;
      }
      
      [Untrusted]
      public function getWorldPoint(param1:uint) : WorldPoint
      {
         return null;
      }
      
      [Untrusted]
      public function getMapCoords(param1:uint) : Point
      {
         return null;
      }
      
      [Untrusted]
      public function getSubAreaShape(param1:uint) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getMapShape(param1:int, param2:int) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getHints() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function subAreaByMapId(param1:uint) : SubArea
      {
         return null;
      }
      
      [Untrusted]
      public function getMapIdByCoord(param1:int, param2:int) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getMapPositionById(param1:uint) : MapPosition
      {
         return null;
      }
      
      [Untrusted]
      public function intersects(param1:Object, param2:Object) : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function movePlayer(param1:int, param2:int, param3:int = -1) : void
      {
      }
      
      [Trusted]
      public function movePlayerOnMapId(param1:uint) : void
      {
      }
      
      [Untrusted]
      public function getMapReference(param1:uint) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getPhoenixsMaps() : Array
      {
         return null;
      }
      
      [Trusted]
      public function isInIncarnam() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getSearchAllResults(param1:String) : Object
      {
         return null;
      }
   }
}
