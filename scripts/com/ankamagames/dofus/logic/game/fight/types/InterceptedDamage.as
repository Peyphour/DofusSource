package com.ankamagames.dofus.logic.game.fight.types
{
   public class InterceptedDamage
   {
       
      
      private var _buffId:uint;
      
      private var _interceptorEntityId:Number;
      
      private var _interceptedEntityId:Number;
      
      private var _damage:SpellDamage;
      
      public function InterceptedDamage(param1:uint, param2:Number, param3:Number)
      {
         super();
         this._buffId = param1;
         this._interceptorEntityId = param2;
         this._interceptedEntityId = param3;
         this._damage = new SpellDamage();
      }
      
      public function get buffId() : uint
      {
         return this._buffId;
      }
      
      public function get interceptorEntityId() : Number
      {
         return this._interceptorEntityId;
      }
      
      public function get interceptedEntityId() : Number
      {
         return this._interceptedEntityId;
      }
      
      public function get damage() : SpellDamage
      {
         return this._damage;
      }
      
      public function set damage(param1:SpellDamage) : void
      {
         this._damage = param1;
      }
   }
}
