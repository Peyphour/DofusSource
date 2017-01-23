package com.ankamagames.dofus.misc.utils
{
   public class CharacterIdConverter
   {
       
      
      public function CharacterIdConverter()
      {
         super();
      }
      
      public static function extractServerCharacterIdFromInterserverCharacterId(param1:Number) : int
      {
         if(param1)
         {
            return Math.floor(param1 / 65536);
         }
         return 0;
      }
   }
}
