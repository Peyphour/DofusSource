package com.ankamagames.dofus.datacenter.world
{
   import flash.geom.Rectangle;
   
   public class Area
   {
       
      
      public function Area()
      {
         super();
      }
      
      public function get id() : int
      {
         return new int();
      }
      
      public function get nameId() : uint
      {
         return new uint();
      }
      
      public function get superAreaId() : int
      {
         return new int();
      }
      
      public function get containHouses() : Boolean
      {
         return new Boolean();
      }
      
      public function get containPaddocks() : Boolean
      {
         return new Boolean();
      }
      
      public function get bounds() : Rectangle
      {
         return new Rectangle();
      }
      
      public function get worldmapId() : uint
      {
         return new uint();
      }
      
      public function get hasWorldMap() : Boolean
      {
         return new Boolean();
      }
      
      public function get name() : String
      {
         return null;
      }
      
      public function get undiatricalName() : String
      {
         return null;
      }
      
      public function get superArea() : SuperArea
      {
         return null;
      }
      
      public function get hasVisibleSubAreas() : Boolean
      {
         return false;
      }
      
      public function get worldmap() : WorldMap
      {
         return null;
      }
   }
}
