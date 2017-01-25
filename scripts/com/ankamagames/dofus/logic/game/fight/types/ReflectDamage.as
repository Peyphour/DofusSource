package com.ankamagames.dofus.logic.game.fight.types
{
   public class ReflectDamage
   {
       
      
      private var _effects:Vector.<EffectDamage>;
      
      private var _sourceId:Number;
      
      private var _reflectValue:uint;
      
      private var _boosted:Boolean;
      
      public function ReflectDamage(param1:Number, param2:uint, param3:Boolean)
      {
         super();
         this._sourceId = param1;
         this._reflectValue = param2;
         this._boosted = param3;
      }
      
      public function get sourceId() : Number
      {
         return this._sourceId;
      }
      
      public function get effects() : Vector.<EffectDamage>
      {
         return this._effects;
      }
      
      public function get reflectValue() : uint
      {
         return this._reflectValue;
      }
      
      public function get boosted() : Boolean
      {
         return this._boosted;
      }
      
      public function addEffect(param1:EffectDamage) : void
      {
         if(!this._effects)
         {
            this._effects = new Vector.<EffectDamage>(0);
         }
         this._effects.push(param1);
      }
   }
}
