package com.ankamagames.dofus.internalDatacenter.spells
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   
   public class SpellWrapper
   {
       
      
      public function SpellWrapper()
      {
         super();
      }
      
      public function get id() : uint
      {
         return new uint();
      }
      
      public function get spellLevel() : int
      {
         return new int();
      }
      
      public function get effects() : Vector.<EffectInstance>
      {
         return new Vector.<EffectInstance>();
      }
      
      public function get criticalEffect() : Vector.<EffectInstance>
      {
         return new Vector.<EffectInstance>();
      }
      
      public function get gfxId() : int
      {
         return new int();
      }
      
      public function get playerId() : Number
      {
         return new Number();
      }
      
      public function get versionNum() : int
      {
         return new int();
      }
      
      public function get actualCooldown() : uint
      {
         return 0;
      }
      
      public function get spellLevelInfos() : SpellLevel
      {
         return null;
      }
      
      public function get variantActivated() : Boolean
      {
         return false;
      }
      
      public function get minimalRange() : uint
      {
         return 0;
      }
      
      public function get maximalRange() : uint
      {
         return 0;
      }
      
      public function get castZoneInLine() : Boolean
      {
         return false;
      }
      
      public function get castZoneInDiagonal() : Boolean
      {
         return false;
      }
      
      public function get spellZoneEffects() : Object
      {
         return null;
      }
      
      public function get hideEffects() : Boolean
      {
         return false;
      }
      
      public function get backGroundIconUri() : Object
      {
         return null;
      }
      
      public function get iconUri() : Object
      {
         return null;
      }
      
      public function get fullSizeIconUri() : Object
      {
         return null;
      }
      
      public function get errorIconUri() : Object
      {
         return null;
      }
      
      public function get info1() : String
      {
         return null;
      }
      
      public function get startTime() : int
      {
         return 0;
      }
      
      public function get endTime() : int
      {
         return 0;
      }
      
      public function get timer() : int
      {
         return 0;
      }
      
      public function get active() : Boolean
      {
         return false;
      }
      
      public function get spell() : Spell
      {
         return null;
      }
      
      public function get spellId() : uint
      {
         return 0;
      }
      
      public function get playerCriticalRate() : int
      {
         return 0;
      }
      
      public function get maximalRangeWithBoosts() : int
      {
         return 0;
      }
      
      public function get canTargetCasterOutOfZone() : Boolean
      {
         return false;
      }
   }
}
