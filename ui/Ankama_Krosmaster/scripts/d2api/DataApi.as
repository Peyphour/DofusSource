package d2api
{
   import d2data.AbuseReasons;
   import d2data.Achievement;
   import d2data.AchievementCategory;
   import d2data.AchievementObjective;
   import d2data.AchievementReward;
   import d2data.ActionDescription;
   import d2data.AlignmentBalance;
   import d2data.AlignmentSide;
   import d2data.AlmanaxCalendar;
   import d2data.AlmanaxEvent;
   import d2data.AlmanaxMonth;
   import d2data.AlmanaxZodiac;
   import d2data.Area;
   import d2data.Bonus;
   import d2data.Breed;
   import d2data.BreedRole;
   import d2data.ButtonWrapper;
   import d2data.Challenge;
   import d2data.ChallengeWrapper;
   import d2data.Characteristic;
   import d2data.CharacteristicCategory;
   import d2data.ChatChannel;
   import d2data.Companion;
   import d2data.CompanionCharacteristic;
   import d2data.CompanionSpell;
   import d2data.DareCriteria;
   import d2data.Dungeon;
   import d2data.Effect;
   import d2data.EmblemSymbol;
   import d2data.EmoteWrapper;
   import d2data.Emoticon;
   import d2data.ExternalNotification;
   import d2data.HavenbagFurnitureWrapper;
   import d2data.HavenbagTheme;
   import d2data.Head;
   import d2data.Hint;
   import d2data.HintCategory;
   import d2data.House;
   import d2data.HouseWrapper;
   import d2data.Idol;
   import d2data.Incarnation;
   import d2data.IncarnationLevel;
   import d2data.InfoMessage;
   import d2data.Interactive;
   import d2data.Item;
   import d2data.ItemSet;
   import d2data.ItemType;
   import d2data.ItemWrapper;
   import d2data.JobWrapper;
   import d2data.LegendaryTreasureHunt;
   import d2data.MapPosition;
   import d2data.Monster;
   import d2data.MonsterMiniBoss;
   import d2data.MonsterRace;
   import d2data.MonsterSuperRace;
   import d2data.Npc;
   import d2data.NpcAction;
   import d2data.OptionalFeature;
   import d2data.Ornament;
   import d2data.OrnamentWrapper;
   import d2data.Pack;
   import d2data.Pet;
   import d2data.PresetIcon;
   import d2data.Quest;
   import d2data.QuestCategory;
   import d2data.QuestObjective;
   import d2data.QuestStep;
   import d2data.RankName;
   import d2data.Server;
   import d2data.ServerPopulation;
   import d2data.Skill;
   import d2data.Smiley;
   import d2data.SmileyCategory;
   import d2data.SmileyPack;
   import d2data.Spell;
   import d2data.SpellBomb;
   import d2data.SpellLevel;
   import d2data.SpellPair;
   import d2data.SpellState;
   import d2data.SpellType;
   import d2data.SpellWrapper;
   import d2data.SubArea;
   import d2data.SuperArea;
   import d2data.TaxCollectorFirstname;
   import d2data.TaxCollectorName;
   import d2data.Title;
   import d2data.TitleCategory;
   import d2data.TitleWrapper;
   import d2data.WorldMap;
   import d2data.WorldPoint;
   
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
      public function getNotifications() : Object
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
      public function getBreeds() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getBreedRole(param1:int) : BreedRole
      {
         return null;
      }
      
      [Untrusted]
      public function getBreedRoles() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getHead(param1:int) : Head
      {
         return null;
      }
      
      [Untrusted]
      public function getHeads() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getCharacteristic(param1:int) : Characteristic
      {
         return null;
      }
      
      [Untrusted]
      public function getCharacteristics() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getCharacteristicCategory(param1:int) : CharacteristicCategory
      {
         return null;
      }
      
      [Untrusted]
      public function getCharacteristicCategories() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getSpell(param1:int) : Spell
      {
         return null;
      }
      
      [Untrusted]
      public function getSpells() : Object
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
      public function getJobs() : Object
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
      public function getAllChatChannels() : Object
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
      public function getAllSubAreas() : Object
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
      public function getAllArea(param1:Boolean = false, param2:Boolean = false) : Object
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
      public function getItems() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getItemsByIds(param1:Object) : Object
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
      public function getSetEffects(param1:Object, param2:Object = null) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getMonsterFromId(param1:uint) : Monster
      {
         return null;
      }
      
      [Untrusted]
      public function getMonsters() : Object
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
      public function getMonsterRaces() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getMonsterSuperRaceFromId(param1:uint) : MonsterSuperRace
      {
         return null;
      }
      
      [Untrusted]
      public function getMonsterSuperRaces() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getCompanion(param1:uint) : Companion
      {
         return null;
      }
      
      [Untrusted]
      public function getAllCompanions() : Object
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
      public function getAllRankNames() : Object
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
      public function getSkills() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getHouseSkills() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getInfoMessage(param1:uint) : InfoMessage
      {
         return null;
      }
      
      [Untrusted]
      public function getAllInfoMessages() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getSmileyWrappers() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getSmiley(param1:uint) : Smiley
      {
         return null;
      }
      
      [Untrusted]
      public function getAllSmiley() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getSmileyCategory(param1:uint) : SmileyCategory
      {
         return null;
      }
      
      [Untrusted]
      public function getAllSmileyCategory() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getSmileyPack(param1:uint) : SmileyPack
      {
         return null;
      }
      
      [Untrusted]
      public function getAllSmileyPack() : Object
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
      public function getChallenges() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getDareCriteria(param1:uint) : DareCriteria
      {
         return null;
      }
      
      [Untrusted]
      public function getAllDareCriteria() : Object
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
      public function getEmblems() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getEmblemSymbol(param1:int) : EmblemSymbol
      {
         return null;
      }
      
      [Untrusted]
      public function getAllEmblemSymbolCategories() : Object
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
      public function getAchievements() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievementCategory(param1:int) : AchievementCategory
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievementCategories() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievementReward(param1:int) : AchievementReward
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievementRewards() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievementObjective(param1:int) : AchievementObjective
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievementObjectives() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getHouse(param1:int) : House
      {
         return null;
      }
      
      [Untrusted]
      public function getLivingObjectSkins(param1:ItemWrapper) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getAbuseReasonName(param1:uint) : AbuseReasons
      {
         return null;
      }
      
      [Untrusted]
      public function getAllAbuseReasons() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getPresetIcons() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getPresetIcon(param1:uint) : PresetIcon
      {
         return null;
      }
      
      [Untrusted]
      public function getIdolsPresetIcons() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getIdolsPresetIcon(param1:uint) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getDungeons() : Object
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
      public function getAllWorldMaps() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getHintCategory(param1:uint) : HintCategory
      {
         return null;
      }
      
      [Untrusted]
      public function getHintCategories() : Object
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
      public function getLegendaryTreasureHunts() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getTitle(param1:uint) : Title
      {
         return null;
      }
      
      [Untrusted]
      public function getTitles() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getTitleCategory(param1:uint) : TitleCategory
      {
         return null;
      }
      
      [Untrusted]
      public function getTitleCategories() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getOrnament(param1:uint) : Ornament
      {
         return null;
      }
      
      [Untrusted]
      public function getOrnaments() : Object
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
      public function getExternalNotifications() : Object
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
      public function getAllZaaps() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getUnknowZaaps(param1:Object) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getAllVeteranRewards() : Object
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
      public function getAllIdols() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getHintById(param1:int) : Hint
      {
         return null;
      }
      
      [Untrusted]
      public function getHints() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getHavenbagFurnitures() : Object
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
   }
}
