package com.ankamagames.dofus.network.types.game.data.items
{
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   
   public class ObjectItem extends Item
   {
       
      
      public function ObjectItem()
      {
         super();
      }
      
      public function get position() : uint
      {
         return new uint();
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
   }
}
