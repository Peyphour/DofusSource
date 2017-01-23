package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.internalDatacenter.communication.BasicChatSentence;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismSubAreaWrapper;
   import com.ankamagames.dofus.internalDatacenter.dare.DareWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildFactSheetWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.SocialEntityInFightWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.SpouseWrapper;
   import com.ankamagames.dofus.network.types.game.prism.PrismInformation;
   
   public class SocialApi
   {
       
      
      public function SocialApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getFriendsList() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function isFriend(param1:String) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getEnemiesList() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function isEnemy(param1:String) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getIgnoredList() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function isIgnored(param1:String, param2:int = 0) : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function getAccountName(param1:String) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getWarnOnFriendConnec() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getWarnOnMemberConnec() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getWarnWhenFriendOrGuildMemberLvlUp() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getWarnWhenFriendOrGuildMemberAchieve() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getWarnOnHardcoreDeath() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getSpouse() : SpouseWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function hasSpouse() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getAllowedGuildEmblemSymbolCategories() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function hasGuild() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getGuild() : GuildWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getGuildMembers() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getGuildRights() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getGuildByid(param1:int) : GuildFactSheetWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function hasGuildRight(param1:Number, param2:String) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function hasGuildRank(param1:Number, param2:int) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getGuildHouses() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function guildHousesUpdateNeeded() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getGuildPaddocks() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getMaxGuildPaddocks() : int
      {
         return 0;
      }
      
      [Untrusted]
      public function isGuildNameInvalid() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getMaxCollectorCount() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getTaxCollectors() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getTaxCollector(param1:int) : TaxCollectorWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getGuildFightingTaxCollectors() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getGuildFightingTaxCollector(param1:uint) : SocialEntityInFightWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getAllFightingTaxCollectors() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getAllFightingTaxCollector(param1:uint) : SocialEntityInFightWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function isPlayerDefender(param1:int, param2:Number, param3:int) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function hasAlliance() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getAlliance() : AllianceWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getAllianceById(param1:int) : AllianceWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getAllianceGuilds() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function isAllianceNameInvalid() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function isAllianceTagInvalid() : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getAllianceNameAndTag(param1:PrismInformation) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getPrismSubAreaById(param1:int) : PrismSubAreaWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getFightingPrisms() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getFightingPrism(param1:uint) : SocialEntityInFightWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function isPlayerPrismDefender(param1:Number, param2:int) : Boolean
      {
         return false;
      }
      
      [Trusted]
      public function getChatSentence(param1:Number, param2:String) : BasicChatSentence
      {
         return null;
      }
      
      [Untrusted]
      public function getDareList() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getDareById(param1:Number) : DareWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getTotalGuildDares() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getTotalAllianceDares() : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getTotalDaresInSubArea(param1:uint) : uint
      {
         return 0;
      }
      
      [Untrusted]
      public function getTargetedMonsterIdsInSubArea(param1:uint) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getFilteredDareList(param1:Boolean = true, param2:Boolean = false, param3:Boolean = false, param4:String = "", param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:Boolean = false, param10:Boolean = false, param11:Boolean = false) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getDareRewards() : Object
      {
         return null;
      }
   }
}
