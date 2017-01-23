package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.datacenter.abuse.AbuseReasons;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentBalance;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentSide;
   import com.ankamagames.dofus.datacenter.almanax.AlmanaxCalendar;
   import com.ankamagames.dofus.datacenter.appearance.Ornament;
   import com.ankamagames.dofus.datacenter.appearance.Title;
   import com.ankamagames.dofus.datacenter.appearance.TitleCategory;
   import com.ankamagames.dofus.datacenter.bonus.Bonus;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.breeds.BreedRole;
   import com.ankamagames.dofus.datacenter.breeds.Head;
   import com.ankamagames.dofus.datacenter.challenges.Challenge;
   import com.ankamagames.dofus.datacenter.characteristics.Characteristic;
   import com.ankamagames.dofus.datacenter.characteristics.CharacteristicCategory;
   import com.ankamagames.dofus.datacenter.communication.ChatChannel;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.communication.InfoMessage;
   import com.ankamagames.dofus.datacenter.communication.Smiley;
   import com.ankamagames.dofus.datacenter.communication.SmileyCategory;
   import com.ankamagames.dofus.datacenter.communication.SmileyPack;
   import com.ankamagames.dofus.datacenter.dare.DareCriteria;
   import com.ankamagames.dofus.datacenter.effects.Effect;
   import com.ankamagames.dofus.datacenter.externalnotifications.ExternalNotification;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.datacenter.guild.RankName;
   import com.ankamagames.dofus.datacenter.houses.HavenbagTheme;
   import com.ankamagames.dofus.datacenter.houses.House;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.datacenter.interactives.Interactive;
   import com.ankamagames.dofus.datacenter.items.Incarnation;
   import com.ankamagames.dofus.datacenter.items.IncarnationLevel;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.items.ItemSet;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.datacenter.items.PresetIcon;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.datacenter.livingObjects.Pet;
   import com.ankamagames.dofus.datacenter.misc.ActionDescription;
   import com.ankamagames.dofus.datacenter.misc.OptionalFeature;
   import com.ankamagames.dofus.datacenter.misc.Pack;
   import com.ankamagames.dofus.datacenter.monsters.Companion;
   import com.ankamagames.dofus.datacenter.monsters.CompanionCharacteristic;
   import com.ankamagames.dofus.datacenter.monsters.CompanionSpell;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.monsters.MonsterMiniBoss;
   import com.ankamagames.dofus.datacenter.monsters.MonsterRace;
   import com.ankamagames.dofus.datacenter.monsters.MonsterSuperRace;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.datacenter.npcs.NpcAction;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.datacenter.quest.Achievement;
   import com.ankamagames.dofus.datacenter.quest.AchievementCategory;
   import com.ankamagames.dofus.datacenter.quest.AchievementObjective;
   import com.ankamagames.dofus.datacenter.quest.AchievementReward;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.datacenter.quest.QuestCategory;
   import com.ankamagames.dofus.datacenter.quest.QuestObjective;
   import com.ankamagames.dofus.datacenter.quest.QuestStep;
   import com.ankamagames.dofus.datacenter.quest.treasureHunt.LegendaryTreasureHunt;
   import com.ankamagames.dofus.datacenter.servers.Server;
   import com.ankamagames.dofus.datacenter.servers.ServerPopulation;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellBomb;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.datacenter.spells.SpellPair;
   import com.ankamagames.dofus.datacenter.spells.SpellState;
   import com.ankamagames.dofus.datacenter.spells.SpellType;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.datacenter.world.Dungeon;
   import com.ankamagames.dofus.datacenter.world.Hint;
   import com.ankamagames.dofus.datacenter.world.HintCategory;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.datacenter.world.SuperArea;
   import com.ankamagames.dofus.datacenter.world.WorldMap;
   import com.ankamagames.dofus.internalDatacenter.almanax.AlmanaxEvent;
   import com.ankamagames.dofus.internalDatacenter.almanax.AlmanaxMonth;
   import com.ankamagames.dofus.internalDatacenter.almanax.AlmanaxZodiac;
   import com.ankamagames.dofus.internalDatacenter.appearance.OrnamentWrapper;
   import com.ankamagames.dofus.internalDatacenter.appearance.TitleWrapper;
   import com.ankamagames.dofus.internalDatacenter.communication.EmoteWrapper;
   import com.ankamagames.dofus.internalDatacenter.fight.ChallengeWrapper;
   import com.ankamagames.dofus.internalDatacenter.house.HavenbagFurnitureWrapper;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.jobs.JobWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.internalDatacenter.userInterface.ButtonWrapper;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   
   public class DataApi
   {
       
      
      public function DataApi()
      {
         super();
      }
      
      [Trusted]
      public function initStaticCartographyData() : void
      {
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getNotifications() : Array
      {
         return null;
      }
      
      [Trusted]
      public function getServer(param1:int) : Server
      {
         return null;
      }
      
      [Trusted]
      public function getServerPopulation(param1:int) : ServerPopulation
      {
         return null;
      }
      
      [Untrusted]
      public function getBreed(param1:int) : Breed
      {
         return null;
      }
      
      [Untrusted]
      public function getBreeds() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getBreedRole(param1:int) : BreedRole
      {
         return null;
      }
      
      [Untrusted]
      public function getBreedRoles() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getHead(param1:int) : Head
      {
         return null;
      }
      
      [Untrusted]
      public function getHeads() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getCharacteristic(param1:int) : Characteristic
      {
         return null;
      }
      
      [Untrusted]
      public function getCharacteristics() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getCharacteristicCategory(param1:int) : CharacteristicCategory
      {
         return null;
      }
      
      [Untrusted]
      public function getCharacteristicCategories() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getSpell(param1:int) : Spell
      {
         return null;
      }
      
      [Untrusted]
      public function getSpells() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getSpellWrapper(param1:uint, param2:uint = 1) : SpellWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getEmoteWrapper(param1:uint, param2:uint = 0) : EmoteWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getButtonWrapper(param1:uint, param2:int, param3:String, param4:Function, param5:String, param6:String = "", param7:String = "") : ButtonWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getJobs() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getJobWrapper(param1:uint) : JobWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getTitleWrapper(param1:uint) : TitleWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getOrnamentWrapper(param1:uint) : OrnamentWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getSpellLevel(param1:int) : SpellLevel
      {
         return null;
      }
      
      [Untrusted]
      public function getSpellLevelBySpell(param1:Spell, param2:int) : SpellLevel
      {
         return null;
      }
      
      [Untrusted]
      public function getSpellType(param1:int) : SpellType
      {
         return null;
      }
      
      [Untrusted]
      public function getSpellState(param1:int) : SpellState
      {
         return null;
      }
      
      [Untrusted]
      public function getChatChannel(param1:int) : ChatChannel
      {
         return null;
      }
      
      [Untrusted]
      public function getAllChatChannels() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getSubArea(param1:int) : SubArea
      {
         return null;
      }
      
      [Untrusted]
      public function getSubAreaFromMap(param1:int) : SubArea
      {
         return null;
      }
      
      [Untrusted]
      public function getAllSubAreas() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getArea(param1:int) : Area
      {
         return null;
      }
      
      [Untrusted]
      public function getSuperArea(param1:int) : SuperArea
      {
         return null;
      }
      
      [Untrusted]
      public function getAllArea(param1:Boolean = false, param2:Boolean = false) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getWorldPoint(param1:int) : WorldPoint
      {
         return null;
      }
      
      [Untrusted]
      public function getItem(param1:int, param2:Boolean = true) : Item
      {
         return null;
      }
      
      [Untrusted]
      public function getItems() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getItemsByIds(param1:Array) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getIncarnationLevel(param1:int, param2:int) : IncarnationLevel
      {
         return null;
      }
      
      [Untrusted]
      public function getIncarnation(param1:int) : Incarnation
      {
         return null;
      }
      
      [Untrusted]
      public function getNewGenericSlotData() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getItemIconUri(param1:uint) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getItemName(param1:int) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getItemType(param1:int) : ItemType
      {
         return null;
      }
      
      [Untrusted]
      public function getItemSet(param1:int) : ItemSet
      {
         return null;
      }
      
      [Untrusted]
      public function getPet(param1:int) : Pet
      {
         return null;
      }
      
      [Untrusted]
      public function getSetEffects(param1:Array, param2:Array = null) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getMonsterFromId(param1:uint) : Monster
      {
         return null;
      }
      
      [Untrusted]
      public function getMonsters() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getMonsterMiniBossFromId(param1:uint) : MonsterMiniBoss
      {
         return null;
      }
      
      [Untrusted]
      public function getMonsterRaceFromId(param1:uint) : MonsterRace
      {
         return null;
      }
      
      [Untrusted]
      public function getMonsterRaces() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getMonsterSuperRaceFromId(param1:uint) : MonsterSuperRace
      {
         return null;
      }
      
      [Untrusted]
      public function getMonsterSuperRaces() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getCompanion(param1:uint) : Companion
      {
         return null;
      }
      
      [Untrusted]
      public function getAllCompanions() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getCompanionCharacteristic(param1:uint) : CompanionCharacteristic
      {
         return null;
      }
      
      [Untrusted]
      public function getCompanionSpell(param1:uint) : CompanionSpell
      {
         return null;
      }
      
      [Untrusted]
      public function getNpc(param1:uint) : Npc
      {
         return null;
      }
      
      [Untrusted]
      public function getNpcAction(param1:uint) : NpcAction
      {
         return null;
      }
      
      [Untrusted]
      public function getAlignmentSide(param1:uint) : AlignmentSide
      {
         return null;
      }
      
      [Untrusted]
      public function getAlignmentBalance(param1:uint) : AlignmentBalance
      {
         return null;
      }
      
      [Untrusted]
      public function getRankName(param1:uint) : RankName
      {
         return null;
      }
      
      [Untrusted]
      public function getAllRankNames() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getItemWrapper(param1:uint, param2:int = 0, param3:uint = 0, param4:uint = 0, param5:* = null) : ItemWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getItemFromUId(param1:uint) : ItemWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getSkill(param1:uint) : Skill
      {
         return null;
      }
      
      [Untrusted]
      public function getSkills() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getHouseSkills() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getInfoMessage(param1:uint) : InfoMessage
      {
         return null;
      }
      
      [Untrusted]
      public function getAllInfoMessages() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getSmileyWrappers() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getSmiley(param1:uint) : Smiley
      {
         return null;
      }
      
      [Untrusted]
      public function getAllSmiley() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getSmileyCategory(param1:uint) : SmileyCategory
      {
         return null;
      }
      
      [Untrusted]
      public function getAllSmileyCategory() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getSmileyPack(param1:uint) : SmileyPack
      {
         return null;
      }
      
      [Untrusted]
      public function getAllSmileyPack() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getEmoticon(param1:uint) : Emoticon
      {
         return null;
      }
      
      [Untrusted]
      public function getChallenge(param1:uint) : Challenge
      {
         return null;
      }
      
      [Untrusted]
      public function getChallengeWrapper(param1:uint) : ChallengeWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getChallenges() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getDareCriteria(param1:uint) : DareCriteria
      {
         return null;
      }
      
      [Untrusted]
      public function getAllDareCriteria() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getTaxCollectorName(param1:uint) : TaxCollectorName
      {
         return null;
      }
      
      [Untrusted]
      public function getTaxCollectorFirstname(param1:uint) : TaxCollectorFirstname
      {
         return null;
      }
      
      [Untrusted]
      public function getEmblems() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getEmblemSymbol(param1:int) : EmblemSymbol
      {
         return null;
      }
      
      [Untrusted]
      public function getAllEmblemSymbolCategories() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getQuest(param1:int) : Quest
      {
         return null;
      }
      
      [Untrusted]
      public function getQuestCategory(param1:int) : QuestCategory
      {
         return null;
      }
      
      [Untrusted]
      public function getQuestObjective(param1:int) : QuestObjective
      {
         return null;
      }
      
      [Untrusted]
      public function getQuestStep(param1:int) : QuestStep
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievement(param1:int) : Achievement
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievements() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievementCategory(param1:int) : AchievementCategory
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievementCategories() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievementReward(param1:int) : AchievementReward
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievementRewards() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievementObjective(param1:int) : AchievementObjective
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievementObjectives() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getHouse(param1:int) : House
      {
         return null;
      }
      
      [Untrusted]
      public function getLivingObjectSkins(param1:ItemWrapper) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getAbuseReasonName(param1:uint) : AbuseReasons
      {
         return null;
      }
      
      [Untrusted]
      public function getAllAbuseReasons() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getPresetIcons() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getPresetIcon(param1:uint) : PresetIcon
      {
         return null;
      }
      
      [Untrusted]
      public function getIdolsPresetIcons() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getIdolsPresetIcon(param1:uint) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getDungeons() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getDungeon(param1:uint) : Dungeon
      {
         return null;
      }
      
      [Untrusted]
      public function getMapInfo(param1:uint) : MapPosition
      {
         return null;
      }
      
      [Untrusted]
      public function getWorldMap(param1:uint) : WorldMap
      {
         return null;
      }
      
      [Untrusted]
      public function getAllWorldMaps() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getHintCategory(param1:uint) : HintCategory
      {
         return null;
      }
      
      [Untrusted]
      public function getHintCategories() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getHousesInformations() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getHouseInformations(param1:uint) : HouseWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getSpellPair(param1:uint) : SpellPair
      {
         return null;
      }
      
      [Untrusted]
      public function getBomb(param1:uint) : SpellBomb
      {
         return null;
      }
      
      [Untrusted]
      public function getPack(param1:uint) : Pack
      {
         return null;
      }
      
      [Untrusted]
      public function getLegendaryTreasureHunt(param1:uint) : LegendaryTreasureHunt
      {
         return null;
      }
      
      [Untrusted]
      public function getLegendaryTreasureHunts() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getTitle(param1:uint) : Title
      {
         return null;
      }
      
      [Untrusted]
      public function getTitles() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getTitleCategory(param1:uint) : TitleCategory
      {
         return null;
      }
      
      [Untrusted]
      public function getTitleCategories() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getOrnament(param1:uint) : Ornament
      {
         return null;
      }
      
      [Untrusted]
      public function getOrnaments() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getOptionalFeatureByKeyword(param1:String) : OptionalFeature
      {
         return null;
      }
      
      [Untrusted]
      public function getEffect(param1:uint) : Effect
      {
         return null;
      }
      
      [Untrusted]
      public function getAlmanaxEvent() : AlmanaxEvent
      {
         return null;
      }
      
      [Untrusted]
      public function getAlmanaxZodiac() : AlmanaxZodiac
      {
         return null;
      }
      
      [Untrusted]
      public function getAlmanaxMonth() : AlmanaxMonth
      {
         return null;
      }
      
      [Untrusted]
      public function getAlmanaxCalendar(param1:uint) : AlmanaxCalendar
      {
         return null;
      }
      
      [Untrusted]
      public function getExternalNotification(param1:int) : ExternalNotification
      {
         return null;
      }
      
      [Untrusted]
      public function getExternalNotifications() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getActionDescriptionByName(param1:String) : ActionDescription
      {
         return null;
      }
      
      [Untrusted]
      public function queryString(param1:Class, param2:String, param3:String) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function queryEquals(param1:Class, param2:String, param3:*) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function queryUnion(... rest) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function queryIntersection(... rest) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function queryGreaterThan(param1:Class, param2:String, param3:*) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function querySmallerThan(param1:Class, param2:String, param3:*) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function queryReturnInstance(param1:Class, param2:Object) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function querySort(param1:Class, param2:Object, param3:*, param4:* = true) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function querySortI18nId(param1:*, param2:*, param3:* = true) : *
      {
         return null;
      }
      
      [Untrusted]
      public function getAllZaaps() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getUnknowZaaps(param1:Array) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getAllVeteranRewards() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getIdol(param1:uint) : Idol
      {
         return null;
      }
      
      [Untrusted]
      public function getIdolByItemId(param1:int) : Idol
      {
         return null;
      }
      
      [Untrusted]
      public function getAllIdols() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getHintById(param1:int) : Hint
      {
         return null;
      }
      
      [Untrusted]
      public function getHints() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getHavenbagFurnitures() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getHavenbagFurnitureWrapper(param1:int) : HavenbagFurnitureWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getHavenbagTheme(param1:int) : HavenbagTheme
      {
         return null;
      }
      
      [Untrusted]
      public function getInteractive(param1:int) : Interactive
      {
         return null;
      }
      
      [Untrusted]
      public function getNullEffectInstance(param1:*) : *
      {
         return null;
      }
      
      [Untrusted]
      public function getBonusById(param1:int) : Bonus
      {
         return null;
      }
      
      [Untrusted]
      public function getMountFamilyNameById(param1:int) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getFinishMoves() : Array
      {
         return null;
      }
   }
}
