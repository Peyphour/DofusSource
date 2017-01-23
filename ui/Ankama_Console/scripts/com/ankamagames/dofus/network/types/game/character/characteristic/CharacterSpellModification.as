package com.ankamagames.dofus.network.types.game.character.characteristic
{
   public class CharacterSpellModification
   {
       
      
      public function CharacterSpellModification()
      {
         super();
      }
      
      public function get modificationType() : uint
      {
         return new uint();
      }
      
      public function get spellId() : uint
      {
         return new uint();
      }
      
      public function get value() : CharacterBaseCharacteristic
      {
         return new CharacterBaseCharacteristic();
      }
   }
}
