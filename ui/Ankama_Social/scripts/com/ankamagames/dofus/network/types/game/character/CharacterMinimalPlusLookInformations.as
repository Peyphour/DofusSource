package com.ankamagames.dofus.network.types.game.character
{
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   
   public class CharacterMinimalPlusLookInformations extends CharacterMinimalInformations
   {
       
      
      public function CharacterMinimalPlusLookInformations()
      {
         super();
      }
      
      public function get entityLook() : EntityLook
      {
         return new EntityLook();
      }
   }
}
