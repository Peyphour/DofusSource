package com.ankamagames.dofus.logic.game.fight.types
{
   public class SpellDamageList
   {
       
      
      private var _spellDamages:Vector.<SpellDamage>;
      
      private var _finalStr:String;
      
      public var effectIcons:Array;
      
      public function SpellDamageList(param1:Vector.<SpellDamage>)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         super();
         this._spellDamages = param1;
         this.effectIcons = new Array();
         var _loc4_:int = this._spellDamages.length;
         this._finalStr = "";
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            this._finalStr = this._finalStr + this._spellDamages[_loc2_].toString();
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc5_ = this._spellDamages[_loc2_].effectIcons.length;
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               this.effectIcons.push(this._spellDamages[_loc2_].effectIcons[_loc3_]);
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public function toString() : String
      {
         return this._finalStr;
      }
   }
}
