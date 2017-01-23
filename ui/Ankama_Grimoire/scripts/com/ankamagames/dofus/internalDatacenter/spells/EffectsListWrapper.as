package com.ankamagames.dofus.internalDatacenter.spells
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   
   public class EffectsListWrapper
   {
       
      
      public function EffectsListWrapper()
      {
         super();
      }
      
      public function get effects() : Vector.<EffectInstance>
      {
         return new Vector.<EffectInstance>();
      }
      
      public function get categories() : Array
      {
         return null;
      }
      
      public function get buffArray() : Array
      {
         return null;
      }
   }
}
