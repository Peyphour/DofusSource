package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.internalDatacenter.fight.FighterInformations;
   import com.ankamagames.dofus.internalDatacenter.spells.EffectsListWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.EffectsWrapper;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   
   public class FightApi
   {
       
      
      public function FightApi()
      {
         super();
      }
      
      [Untrusted]
      public function isSlaveContext() : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getFighterInformations(param1:Number) : FighterInformations
      {
         return null;
      }
      
      [Untrusted]
      public function getFighterName(param1:Number) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getFighterLevel(param1:Number) : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getFighters() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getMonsterId(param1:Number) : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getDeadFighters() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getFightType() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getBuffList(param1:Number) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getBuffById(param1:uint, param2:Number) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function createEffectsWrapper(param1:Spell, param2:Array, param3:String) : EffectsWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getCastingSpellBuffEffects(param1:Number, param2:uint) : EffectsWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getAllBuffEffects(param1:Number) : EffectsListWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function isCastingSpell() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function cancelSpell() : void
      {
      }
      
      [Untrusted]
      public function getChallengeList() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getCurrentPlayedFighterId() : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getPlayingFighterId() : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function isCompanion(param1:Number) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getCurrentPlayedCharacteristicsInformations() : CharacterCharacteristicsInformations
      {
         return null;
      }
      
      [Untrusted]
      public function preFightIsActive() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isWaitingBeforeFight() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isFightLeader() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isSpectator() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isDematerializated() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getTurnsCount() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getFighterStatus(param1:Number) : int
      {
         return 0;
      }
      
      [Untrusted]
      public function isMouseOverFighter(param1:Number) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function updateSwapPositionRequestsIcons() : void
      {
      }
      
      [Untrusted]
      public function setSwapPositionRequestsIconsVisibility(param1:Boolean) : void
      {
      }
   }
}
