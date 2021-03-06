package com.ankamagames.dofus.datacenter.world
{
   import com.ankamagames.dofus.datacenter.ambientSounds.AmbientSound;
   
   public class MapPosition
   {
       
      
      public function MapPosition()
      {
         super();
      }
      
      public function get id() : int
      {
         return new int();
      }
      
      public function get posX() : int
      {
         return new int();
      }
      
      public function get posY() : int
      {
         return new int();
      }
      
      public function get outdoor() : Boolean
      {
         return new Boolean();
      }
      
      public function get capabilities() : int
      {
         return new int();
      }
      
      public function get nameId() : int
      {
         return new int();
      }
      
      public function get showNameOnFingerpost() : Boolean
      {
         return new Boolean();
      }
      
      public function get sounds() : Vector.<AmbientSound>
      {
         return new Vector.<AmbientSound>();
      }
      
      public function get playlists() : Vector.<Vector.<int>>
      {
         return new Vector.<Vector.<int>>();
      }
      
      public function get subAreaId() : int
      {
         return new int();
      }
      
      public function get worldMap() : int
      {
         return new int();
      }
      
      public function get hasPriorityOnWorldmap() : Boolean
      {
         return new Boolean();
      }
      
      public function get isUnderWater() : Boolean
      {
         return new Boolean();
      }
      
      public function get name() : String
      {
         return null;
      }
      
      public function get subArea() : SubArea
      {
         return null;
      }
      
      public function get allowChallenge() : Boolean
      {
         return false;
      }
      
      public function get allowAggression() : Boolean
      {
         return false;
      }
      
      public function get allowTeleportTo() : Boolean
      {
         return false;
      }
      
      public function get allowTeleportFrom() : Boolean
      {
         return false;
      }
      
      public function get allowExchanges() : Boolean
      {
         return false;
      }
      
      public function get allowHumanVendor() : Boolean
      {
         return false;
      }
      
      public function get allowTaxCollector() : Boolean
      {
         return false;
      }
      
      public function get allowSoulCapture() : Boolean
      {
         return false;
      }
      
      public function get allowSoulSummon() : Boolean
      {
         return false;
      }
      
      public function get allowTavernRegen() : Boolean
      {
         return false;
      }
      
      public function get allowTombMode() : Boolean
      {
         return false;
      }
      
      public function get allowTeleportEverywhere() : Boolean
      {
         return false;
      }
      
      public function get allowFightChallenges() : Boolean
      {
         return false;
      }
   }
}
