package com.ankamagames.dofus.datacenter.livingObjects
{
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   
   public class Pet
   {
       
      
      public function Pet()
      {
         super();
      }
      
      public function get id() : int
      {
         return new int();
      }
      
      public function get foodItems() : Vector.<int>
      {
         return new Vector.<int>();
      }
      
      public function get foodTypes() : Vector.<int>
      {
         return new Vector.<int>();
      }
      
      public function get minDurationBeforeMeal() : int
      {
         return new int();
      }
      
      public function get maxDurationBeforeMeal() : int
      {
         return new int();
      }
      
      public function get possibleEffects() : Vector.<EffectInstance>
      {
         return new Vector.<EffectInstance>();
      }
   }
}
