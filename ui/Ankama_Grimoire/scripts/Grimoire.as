package
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.dofus.datacenter.almanax.AlmanaxCalendar;
   import com.ankamagames.dofus.datacenter.monsters.MonsterRace;
   import com.ankamagames.dofus.datacenter.monsters.MonsterSuperRace;
   import com.ankamagames.dofus.datacenter.npcs.Npc;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.almanax.AlmanaxEvent;
   import com.ankamagames.dofus.internalDatacenter.almanax.AlmanaxMonth;
   import com.ankamagames.dofus.internalDatacenter.almanax.AlmanaxZodiac;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.NotificationApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2hooks.AchievementFinished;
   import d2hooks.AchievementList;
   import d2hooks.CalendarDate;
   import d2hooks.OpenBook;
   import d2hooks.OpenSpellInterface;
   import d2hooks.SpellListUpdate;
   import enum.EnumTab;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import ui.API;
   import ui.AchievementTab;
   import ui.AlignmentTab;
   import ui.BestiaryTab;
   import ui.Book;
   import ui.CalendarTab;
   import ui.CompanionTab;
   import ui.FinishMoveList;
   import ui.IdolsTab;
   import ui.JobTab;
   import ui.ObjectTab;
   import ui.QuestBase;
   import ui.QuestTab;
   import ui.SpellBase;
   import ui.SpellList;
   import ui.SpellTab;
   import ui.TitleTab;
   import ui.items.GiftXmlItem;
   
   public class Grimoire extends Sprite
   {
      
      private static var _self:Grimoire;
       
      
      protected var grimoire:Book = null;
      
      protected var spellTab:SpellTab = null;
      
      protected var objectTab:ObjectTab = null;
      
      protected var alignmentTab:AlignmentTab = null;
      
      protected var bestiaryTab:BestiaryTab = null;
      
      protected var questTab:QuestTab = null;
      
      protected var jobTab:JobTab = null;
      
      protected var giftXmlItem:GiftXmlItem = null;
      
      protected var calendarTab:CalendarTab = null;
      
      protected var achievementTab:AchievementTab = null;
      
      protected var titleTab:TitleTab = null;
      
      protected var companionTab:CompanionTab = null;
      
      protected var idolsTab:IdolsTab = null;
      
      protected var questsBook:QuestBase = null;
      
      protected var spellBase:SpellBase = null;
      
      protected var spellList:SpellList = null;
      
      protected var finishMoveList:FinishMoveList = null;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var notifApi:NotificationApi;
      
      public var timeApi:TimeApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var questApi:QuestApi;
      
      public var previousUi:String;
      
      public var currentUi:String;
      
      public var tabOpened:String = "";
      
      private var _spellList:Object;
      
      private var _recipeSlotsNumber:int;
      
      private var _dateId:int;
      
      private var _monthInfo:AlmanaxMonth;
      
      private var _zodiacInfo:AlmanaxZodiac;
      
      private var _eventInfo:AlmanaxEvent;
      
      private var _calendar:AlmanaxCalendar;
      
      private var _meryde:Npc;
      
      private var _finishedAchievementsId:Array;
      
      private var _objectivesTextByAchievement:Array;
      
      private var _lastAchievementOpenedId:int;
      
      private var _lastAchievementSearchCriteria:String = "";
      
      private var _lastAchievementCategoryOpenedId:int;
      
      private var _lastAchievementScrollValue:int;
      
      private var _monsterRaces:Array;
      
      private var _monsterAreas:Array;
      
      private var _titleCurrentTab:int;
      
      private var _bestiaryDisplayCriteriaDrop:Boolean = true;
      
      private var _bestiarySearchOnName:Boolean = true;
      
      private var _bestiarySearchOnDrop:Boolean = true;
      
      private var _achievementSearchOnName:Boolean = true;
      
      private var _achievementSearchOnObjective:Boolean = true;
      
      private var _achievementSearchOnReward:Boolean = true;
      
      private var _questSearchOnName:Boolean = true;
      
      private var _questSearchOnCategory:Boolean = true;
      
      private var _jobSearchOptions:Dictionary;
      
      private var _lastJobOpenedId:int;
      
      public function Grimoire()
      {
         this._jobSearchOptions = new Dictionary();
         super();
      }
      
      public static function getInstance() : Grimoire
      {
         return _self;
      }
      
      public function main() : void
      {
         var _loc1_:Object = null;
         var _loc5_:MonsterSuperRace = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Area = null;
         var _loc9_:MonsterRace = null;
         var _loc10_:SubArea = null;
         API.uiApi = this.uiApi;
         this.sysApi.addHook(OpenBook,this.onOpenGrimoire);
         this.sysApi.addHook(SpellListUpdate,this.onSpellsList);
         this.sysApi.addHook(OpenSpellInterface,this.onOpenSpellInterface);
         this.sysApi.addHook(CalendarDate,this.onCalendarDate);
         this.sysApi.addHook(AchievementList,this.onAchievementList);
         this.sysApi.addHook(AchievementFinished,this.onAchievementFinished);
         this._finishedAchievementsId = new Array();
         this._objectivesTextByAchievement = new Array();
         this._monsterRaces = new Array();
         this._monsterAreas = new Array();
         _self = this;
         var _loc2_:Object = this.dataApi.getMonsterSuperRaces();
         var _loc3_:Object = this.dataApi.getMonsterRaces();
         var _loc4_:int = 1;
         for each(_loc5_ in _loc2_)
         {
            this._monsterRaces.push({
               "id":_loc4_,
               "realId":_loc5_.id,
               "name":_loc5_.name,
               "parentId":0,
               "subcats":new Array()
            });
            _loc4_++;
         }
         this._monsterRaces.sortOn("name",Array.CASEINSENSITIVE);
         for each(_loc1_ in this._monsterRaces)
         {
            for each(_loc9_ in _loc3_)
            {
               if(_loc9_.superRaceId == _loc1_.realId && _loc9_.id > -1 && _loc9_.monsters && _loc9_.monsters.length)
               {
                  _loc1_.subcats.push({
                     "id":_loc4_,
                     "realId":_loc9_.id,
                     "name":_loc9_.name,
                     "parentId":_loc1_.id,
                     "monsters":_loc9_.monsters
                  });
                  _loc4_++;
               }
            }
            _loc1_.subcats.sortOn("name",Array.CASEINSENSITIVE);
         }
         _loc6_ = this.dataApi.getAllArea(false,false);
         _loc7_ = this.dataApi.getAllSubAreas();
         for each(_loc8_ in _loc6_)
         {
            this._monsterAreas.push({
               "id":_loc4_,
               "realId":_loc8_.id,
               "name":_loc8_.name,
               "parentId":0,
               "subcats":new Array()
            });
            _loc4_++;
         }
         this._monsterAreas.sortOn("name",Array.CASEINSENSITIVE);
         for each(_loc1_ in this._monsterAreas)
         {
            for each(_loc10_ in _loc7_)
            {
               if(_loc10_.areaId == _loc1_.realId && _loc10_.monsters && _loc10_.monsters.length)
               {
                  _loc1_.subcats.push({
                     "id":_loc4_,
                     "realId":_loc10_.id,
                     "name":_loc10_.name,
                     "parentId":_loc1_.id,
                     "monsters":_loc10_.monsters
                  });
                  _loc4_++;
               }
            }
            _loc1_.subcats.sortOn("name",Array.CASEINSENSITIVE);
         }
      }
      
      public function get recipeSlotsNumber() : int
      {
         return this._recipeSlotsNumber;
      }
      
      public function set recipeSlotsNumber(param1:int) : void
      {
         this._recipeSlotsNumber = param1;
      }
      
      public function get calendarInfos() : Object
      {
         var _loc1_:Object = {
            "month":this._monthInfo,
            "zodiac":this._zodiacInfo,
            "event":this._eventInfo,
            "calendar":this._calendar,
            "meryde":this._meryde
         };
         return _loc1_;
      }
      
      public function isCalendarDisabled() : Boolean
      {
         return this._dateId == -1;
      }
      
      public function get finishedAchievementsIds() : Array
      {
         return this._finishedAchievementsId;
      }
      
      public function get objectivesTextByAchievement() : Array
      {
         return this._objectivesTextByAchievement;
      }
      
      public function set objectivesTextByAchievement(param1:Array) : void
      {
         this._objectivesTextByAchievement = param1;
      }
      
      public function get monsterRaces() : Array
      {
         return this._monsterRaces;
      }
      
      public function set monsterRaces(param1:Array) : void
      {
         this._monsterRaces = param1;
      }
      
      public function get monsterAreas() : Array
      {
         return this._monsterAreas;
      }
      
      public function set monsterAreas(param1:Array) : void
      {
         this._monsterAreas = param1;
      }
      
      public function get lastAchievementOpenedId() : int
      {
         return this._lastAchievementOpenedId;
      }
      
      public function set lastAchievementOpenedId(param1:int) : void
      {
         this._lastAchievementOpenedId = param1;
      }
      
      public function get lastAchievementCategoryOpenedId() : int
      {
         return this._lastAchievementCategoryOpenedId;
      }
      
      public function set lastAchievementCategoryOpenedId(param1:int) : void
      {
         this._lastAchievementCategoryOpenedId = param1;
      }
      
      public function get lastAchievementScrollValue() : int
      {
         return this._lastAchievementScrollValue;
      }
      
      public function set lastAchievementScrollValue(param1:int) : void
      {
         this._lastAchievementScrollValue = param1;
      }
      
      public function get lastAchievementSearchCriteria() : String
      {
         return this._lastAchievementSearchCriteria;
      }
      
      public function set lastAchievementSearchCriteria(param1:String) : void
      {
         this._lastAchievementSearchCriteria = param1;
      }
      
      public function get titleCurrentTab() : int
      {
         return this._titleCurrentTab;
      }
      
      public function set titleCurrentTab(param1:int) : void
      {
         this._titleCurrentTab = param1;
      }
      
      public function get bestiaryDisplayCriteriaDrop() : Boolean
      {
         return this._bestiaryDisplayCriteriaDrop;
      }
      
      public function set bestiaryDisplayCriteriaDrop(param1:Boolean) : void
      {
         this._bestiaryDisplayCriteriaDrop = param1;
      }
      
      public function get bestiarySearchOnDrop() : Boolean
      {
         return this._bestiarySearchOnDrop;
      }
      
      public function set bestiarySearchOnDrop(param1:Boolean) : void
      {
         this._bestiarySearchOnDrop = param1;
      }
      
      public function get bestiarySearchOnName() : Boolean
      {
         return this._bestiarySearchOnName;
      }
      
      public function set bestiarySearchOnName(param1:Boolean) : void
      {
         this._bestiarySearchOnName = param1;
      }
      
      public function get achievementSearchOnName() : Boolean
      {
         return this._achievementSearchOnName;
      }
      
      public function set achievementSearchOnName(param1:Boolean) : void
      {
         this._achievementSearchOnName = param1;
      }
      
      public function get achievementSearchOnObjective() : Boolean
      {
         return this._achievementSearchOnObjective;
      }
      
      public function set achievementSearchOnObjective(param1:Boolean) : void
      {
         this._achievementSearchOnObjective = param1;
      }
      
      public function get achievementSearchOnReward() : Boolean
      {
         return this._achievementSearchOnReward;
      }
      
      public function set achievementSearchOnReward(param1:Boolean) : void
      {
         this._achievementSearchOnReward = param1;
      }
      
      public function get questSearchOnName() : Boolean
      {
         return this._questSearchOnName;
      }
      
      public function set questSearchOnName(param1:Boolean) : void
      {
         this._questSearchOnName = param1;
      }
      
      public function get questSearchOnCategory() : Boolean
      {
         return this._questSearchOnCategory;
      }
      
      public function set questSearchOnCategory(param1:Boolean) : void
      {
         this._questSearchOnCategory = param1;
      }
      
      public function get lastJobOpenedId() : int
      {
         return this._lastJobOpenedId;
      }
      
      public function set lastJobOpenedId(param1:int) : void
      {
         this._lastJobOpenedId = param1;
      }
      
      private function onOpenGrimoire(param1:String = null, param2:Object = null, param3:Boolean = true) : void
      {
         switch(param1)
         {
            case EnumTab.SPELL_TAB:
            case EnumTab.ALIGNMENT_TAB:
            case EnumTab.TITLE_TAB:
            case EnumTab.COMPANION_TAB:
            case EnumTab.JOB_TAB:
            case EnumTab.IDOLS_TAB:
               if(!this.uiApi.getUi(param1))
               {
                  this.uiApi.loadUi(param1,param1,param2);
               }
               else
               {
                  this.uiApi.unloadUi(param1);
               }
               return;
            case EnumTab.BESTIARY_TAB:
               if(!this.uiApi.getUi(param1))
               {
                  if(param2 != null)
                  {
                     this.uiApi.loadUi(param1,param1,param2,1,null,false,false,false);
                  }
                  else
                  {
                     this.uiApi.loadUi(param1);
                  }
               }
               else
               {
                  this.uiApi.unloadUi(param1);
               }
               return;
            case EnumTab.CALENDAR_TAB:
            case EnumTab.QUEST_TAB:
            case EnumTab.ACHIEVEMENT_TAB:
               if(!this.uiApi.getUi(UIEnum.QUEST_BASE))
               {
                  this.uiApi.loadUi(UIEnum.QUEST_BASE,UIEnum.QUEST_BASE,[param1,param2],1,null,false,false,false);
               }
               else
               {
                  this.uiApi.getUi(UIEnum.QUEST_BASE).uiClass.openTab(param1,param2);
               }
               return;
            default:
               if((this.tabOpened == EnumTab.QUEST_TAB && param1 == EnumTab.QUEST_TAB || this.tabOpened == EnumTab.ACHIEVEMENT_TAB && param1 == EnumTab.ACHIEVEMENT_TAB || this.tabOpened == EnumTab.TITLE_TAB && param1 == EnumTab.TITLE_TAB || this.tabOpened == EnumTab.BESTIARY_TAB && param1 == EnumTab.BESTIARY_TAB) && param2 && param2.forceOpen)
               {
                  return;
               }
               if(param1 == EnumTab.CALENDAR_TAB && !this.questApi.getCompletedQuests())
               {
                  return;
               }
               if(param1 == EnumTab.SPELL_TAB && !this.playerApi.characteristics())
               {
                  return;
               }
               if(this.tabOpened == "")
               {
                  if(param1 == EnumTab.CALENDAR_TAB)
                  {
                     if(this._dateId == -1)
                     {
                        return;
                     }
                  }
                  else if(param1 == EnumTab.TITLE_TAB)
                  {
                     if(this.playerApi.isInFight())
                     {
                        return;
                     }
                  }
                  this.tabOpened = param1;
                  if(this.uiApi.getUi(UIEnum.CHARACTER_SHEET_UI))
                  {
                     this.uiApi.unloadUi(UIEnum.CHARACTER_SHEET_UI);
                  }
                  this.uiApi.loadUi(UIEnum.GRIMOIRE,UIEnum.GRIMOIRE,[param1,param2],1,null,false,false,param3);
               }
               else if(this.tabOpened == param1)
               {
                  this.uiApi.unloadUi(UIEnum.GRIMOIRE);
               }
               else
               {
                  if(param1 == EnumTab.CALENDAR_TAB)
                  {
                     if(this._dateId == -1)
                     {
                        return;
                     }
                  }
                  else if(param1 == EnumTab.TITLE_TAB)
                  {
                     if(this.playerApi.isInFight())
                     {
                        return;
                     }
                  }
                  this.tabOpened = param1;
                  this.uiApi.getUi(UIEnum.GRIMOIRE).uiClass.openTab(param1,param2);
               }
               return;
         }
      }
      
      private function onSpellsList(param1:Object) : void
      {
         this._spellList = param1;
      }
      
      private function onOpenSpellInterface(param1:uint) : void
      {
         if(!this.uiApi.getUi(EnumTab.SPELL_TAB))
         {
            this.uiApi.loadUi(EnumTab.SPELL_TAB,EnumTab.SPELL_TAB,param1);
         }
         else
         {
            SpellTab.getInstance().selectSpell(param1);
         }
      }
      
      private function onCalendarDate(param1:int) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         if(param1 != this._dateId)
         {
            _loc3_ = this.uiApi.getUi(EnumTab.CALENDAR_TAB);
            this._dateId = param1;
            if(param1 > -1)
            {
               this._calendar = this.dataApi.getAlmanaxCalendar(param1);
               this._monthInfo = this.dataApi.getAlmanaxMonth();
               this._zodiacInfo = this.dataApi.getAlmanaxZodiac();
               this._eventInfo = this.dataApi.getAlmanaxEvent();
               this._meryde = this.dataApi.getNpc(this._calendar.npcId);
               if(_loc3_ && _loc3_.uiClass)
               {
                  _loc3_.uiClass.updateCalendarInfos();
               }
            }
            else if(_loc3_)
            {
               this.uiApi.unloadUi(UIEnum.GRIMOIRE);
            }
         }
         var _loc2_:* = this.sysApi.getData("hideAlmanaxDailyNotif");
         if(_loc2_ != undefined && !_loc2_)
         {
            _loc4_ = this.sysApi.getData("lastAlmanaxNotif");
            if(_loc4_ != this._dateId)
            {
               _loc5_ = this.notifApi.prepareNotification(this.timeApi.getDofusDate(),this.uiApi.getText("ui.almanax.offeringTo",this._meryde.name),2,"notifAlmanax");
               this.notifApi.addButtonToNotification(_loc5_,this.uiApi.getText("ui.almanax.almanax"),"OpenBook",["calendarTab"],true,130);
               this.notifApi.sendNotification(_loc5_);
               this.sysApi.setData("lastAlmanaxNotif",this._dateId);
            }
         }
      }
      
      private function onAchievementList(param1:Object) : void
      {
         var _loc2_:int = 0;
         for each(_loc2_ in param1)
         {
            this._finishedAchievementsId.push(_loc2_);
         }
      }
      
      private function onAchievementFinished(param1:int) : void
      {
         this._finishedAchievementsId.push(param1);
      }
   }
}
