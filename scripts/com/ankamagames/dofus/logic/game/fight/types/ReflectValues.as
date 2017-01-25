package com.ankamagames.dofus.logic.game.fight.types
{
   public class ReflectValues
   {
       
      
      private var _reflectValue:uint;
      
      private var _boostedReflectValue:uint;
      
      public function ReflectValues(param1:uint, param2:uint)
      {
         super();
         this._reflectValue = param1;
         this._boostedReflectValue = param2;
      }
      
      public function get reflectValue() : uint
      {
         return this._reflectValue;
      }
      
      public function get boostedReflectValue() : uint
      {
         return this._boostedReflectValue;
      }
   }
}
