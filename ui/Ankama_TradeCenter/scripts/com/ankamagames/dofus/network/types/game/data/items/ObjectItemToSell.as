package com.ankamagames.dofus.network.types.game.data.items
{
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   
   public class ObjectItemToSell extends Item
   {
       
      
      public function ObjectItemToSell()
      {
         super();
      }
      
      public function get objectGID() : uint
      {
         return new uint();
      }
      
      public function get effects() : Vector.<ObjectEffect>
      {
         return new Vector.<ObjectEffect>();
      }
      
      public function get objectUID() : uint
      {
         return new uint();
      }
      
      public function get quantity() : uint
      {
         return new uint();
      }
      
      public function get objectPrice() : uint
      {
         return new uint();
      }
   }
}
