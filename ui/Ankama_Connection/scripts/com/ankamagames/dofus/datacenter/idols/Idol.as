package com.ankamagames.dofus.datacenter.idols
{
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.spells.SpellPair;
   
   public class Idol
   {
       
      
      public function Idol()
      {
         super();
      }
      
      public function get id() : int
      {
         return new int();
      }
      
      public function get description() : String
      {
         return new String();
      }
      
      public function get categoryId() : int
      {
         return new int();
      }
      
      public function get itemId() : int
      {
         return new int();
      }
      
      public function get groupOnly() : Boolean
      {
         return new Boolean();
      }
      
      public function get spellPairId() : int
      {
         return new int();
      }
      
      public function get score() : int
      {
         return new int();
      }
      
      public function get experienceBonus() : int
      {
         return new int();
      }
      
      public function get dropBonus() : int
      {
         return new int();
      }
      
      public function get synergyIdolsIds() : Vector.<int>
      {
         return new Vector.<int>();
      }
      
      public function get synergyIdolsCoeff() : Vector.<Number>
      {
         return new Vector.<Number>();
      }
      
      public function get incompatibleMonsters() : Vector.<int>
      {
         return new Vector.<int>();
      }
      
      public function get item() : Item
      {
         return null;
      }
      
      public function get name() : String
      {
         return null;
      }
      
      public function get spellPair() : SpellPair
      {
         return null;
      }
   }
}
