package com.ankamagames.dofus.datacenter.items
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   
   public class ItemSet
   {
       
      
      public function ItemSet()
      {
         super();
      }
      
      public function get id() : uint
      {
         return new uint();
      }
      
      public function get items() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get nameId() : uint
      {
         return new uint();
      }
      
      public function get effects() : Vector.<Vector.<EffectInstance>>
      {
         return new Vector.<Vector.<EffectInstance>>();
      }
      
      public function get bonusIsSecret() : Boolean
      {
         return new Boolean();
      }
      
      public function get name() : String
      {
         return null;
      }
   }
}
