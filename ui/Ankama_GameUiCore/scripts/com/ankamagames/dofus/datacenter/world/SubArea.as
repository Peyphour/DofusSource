package com.ankamagames.dofus.datacenter.world
{
   import com.ankamagames.dofus.datacenter.ambientSounds.AmbientSound;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SubArea
   {
       
      
      public function SubArea()
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
      
      public function get areaId() : int
      {
         return new int();
      }
      
      public function get ambientSounds() : Vector.<AmbientSound>
      {
         return new Vector.<AmbientSound>();
      }
      
      public function get playlists() : Vector.<Vector.<int>>
      {
         return new Vector.<Vector.<int>>();
      }
      
      public function get mapIds() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get bounds() : Rectangle
      {
         return new Rectangle();
      }
      
      public function get shape() : Vector.<int>
      {
         return new Vector.<int>();
      }
      
      public function get customWorldMap() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get packId() : int
      {
         return new int();
      }
      
      public function get level() : uint
      {
         return new uint();
      }
      
      public function get isConquestVillage() : Boolean
      {
         return new Boolean();
      }
      
      public function get basicAccountAllowed() : Boolean
      {
         return new Boolean();
      }
      
      public function get displayOnWorldMap() : Boolean
      {
         return new Boolean();
      }
      
      public function get monsters() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get entranceMapIds() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get exitMapIds() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get capturable() : Boolean
      {
         return new Boolean();
      }
      
      public function get achievements() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get quests() : Vector.<Vector.<int>>
      {
         return new Vector.<Vector.<int>>();
      }
      
      public function get npcs() : Vector.<Vector.<int>>
      {
         return new Vector.<Vector.<int>>();
      }
      
      public function get exploreAchievementId() : int
      {
         return new int();
      }
      
      public function get isDiscovered() : Boolean
      {
         return new Boolean();
      }
      
      public function get harvestables() : Vector.<int>
      {
         return new Vector.<int>();
      }
      
      public function get name() : String
      {
         return null;
      }
      
      public function get undiatricalName() : String
      {
         return null;
      }
      
      public function get area() : Area
      {
         return null;
      }
      
      public function get worldmap() : WorldMap
      {
         return null;
      }
      
      public function get hasCustomWorldMap() : Boolean
      {
         return false;
      }
      
      public function get center() : Point
      {
         return null;
      }
   }
}
