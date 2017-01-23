package com.ankamagames.dofus.network.types.game.look
{
   public class SubEntity
   {
       
      
      public function SubEntity()
      {
         super();
      }
      
      public function get bindingPointCategory() : uint
      {
         return new uint();
      }
      
      public function get bindingPointIndex() : uint
      {
         return new uint();
      }
      
      public function get subEntityLook() : EntityLook
      {
         return new EntityLook();
      }
   }
}
