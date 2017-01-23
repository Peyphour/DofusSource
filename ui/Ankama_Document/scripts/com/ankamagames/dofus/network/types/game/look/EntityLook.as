package com.ankamagames.dofus.network.types.game.look
{
   public class EntityLook
   {
       
      
      public function EntityLook()
      {
         super();
      }
      
      public function get bonesId() : uint
      {
         return new uint();
      }
      
      public function get skins() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get indexedColors() : Vector.<int>
      {
         return new Vector.<int>();
      }
      
      public function get scales() : Vector.<int>
      {
         return new Vector.<int>();
      }
      
      public function get subentities() : Vector.<SubEntity>
      {
         return new Vector.<SubEntity>();
      }
   }
}
