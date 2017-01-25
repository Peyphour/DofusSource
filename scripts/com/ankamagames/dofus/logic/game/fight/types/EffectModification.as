package com.ankamagames.dofus.logic.game.fight.types
{
   public class EffectModification
   {
       
      
      private var _effectId:int;
      
      public var damagesBonus:int;
      
      public var shieldPoints:int;
      
      public function EffectModification(param1:int)
      {
         super();
         this._effectId = param1;
      }
      
      public function get effectId() : int
      {
         return this._effectId;
      }
   }
}
