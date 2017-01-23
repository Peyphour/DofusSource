package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.datacenter.appearance.Ornament;
   import com.ankamagames.dofus.datacenter.appearance.Title;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.items.WeaponWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterCharacteristicsInformations;
   import com.ankamagames.dofus.network.types.game.character.restriction.ActorRestrictionsInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   
   public class PlayedCharacterApi
   {
       
      
      public function PlayedCharacterApi()
      {
         super();
      }
      
      [Untrusted]
      public function characteristics() : CharacterCharacteristicsInformations
      {
         return null;
      }
      
      [Untrusted]
      public function getPlayedCharacterInfo() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getCurrentEntityLook() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getInventory() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getEquipment() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getSpellInventory() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getJobs() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getMount() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getTitle() : Title
      {
         return null;
      }
      
      [Untrusted]
      public function getOrnament() : Ornament
      {
         return null;
      }
      
      [Untrusted]
      public function getKnownTitles() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getKnownOrnaments() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function titlesOrnamentsAskedBefore() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getEntityInfos() : GameRolePlayCharacterInformations
      {
         return null;
      }
      
      [Untrusted]
      public function getEntityTooltipInfos() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function inventoryWeight() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function inventoryWeightMax() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function isIncarnation() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isMutated() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isInHouse() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isInExchange() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isInFight() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isInPreFight() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isInParty() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isPartyLeader() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isRidding() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isPetsMounting() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function hasCompanion() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function id() : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function restrictions() : ActorRestrictionsInformations
      {
         return null;
      }
      
      [Untrusted]
      public function isMutant() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function publicMode() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function artworkId() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function isCreature() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getBone() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getSkin() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getColors() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getSubentityColors() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getAlignmentSide() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getAlignmentValue() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getAlignmentAggressableStatus() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getAlignmentGrade() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getMaxSummonedCreature() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getCurrentSummonedCreature() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function canSummon() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getSpell(param1:uint) : SpellWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function canCastThisSpell(param1:uint, param2:uint) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function canCastThisSpellWithResult(param1:uint, param2:uint, param3:Number = 0) : String
      {
         return null;
      }
      
      [Untrusted]
      public function canCastThisSpellOnTarget(param1:uint, param2:uint, param3:Number) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getSpellModification(param1:uint, param2:int) : int
      {
         return 0;
      }
      
      [Untrusted]
      public function isInHisHouse() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getPlayerHouses() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function currentMap() : WorldPointWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function currentSubArea() : SubArea
      {
         return null;
      }
      
      [Untrusted]
      public function state() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function isAlive() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getFollowingPlayerIds() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getPlayerSet(param1:uint) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getWeapon() : WeaponWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getExperienceBonusPercent() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getAchievementPoints() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getWaitingGifts() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getSoloIdols() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getPartyIdols() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getIdolsPresets() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function knowSpell(param1:uint) : int
      {
         return 0;
      }
      
      [Untrusted]
      public function isInHisHavenbag() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isInHavenbag() : Boolean
      {
         return false;
      }
   }
}
