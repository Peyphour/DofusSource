package managers
{
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.internalDatacenter.world.WorldPointWrapper;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.UIEnum;
   import d2actions.QuestInfosRequest;
   import d2hooks.AchievementRewardSuccess;
   import d2hooks.CurrentMap;
   import d2hooks.ExchangeObjectAdded;
   import d2hooks.GameFightEnd;
   import d2hooks.GameFightJoin;
   import d2hooks.GameFightLeave;
   import d2hooks.GameFightStart;
   import d2hooks.GiftsWaitingAllocation;
   import d2hooks.IdolSelected;
   import d2hooks.JobsExpUpdated;
   import d2hooks.LeaveDialog;
   import d2hooks.MapComplementaryInformationsData;
   import d2hooks.NpcDialogCreation;
   import d2hooks.QuestInfosUpdated;
   import d2hooks.QuestObjectiveValidated;
   import d2hooks.QuestStarted;
   import d2hooks.QuestValidated;
   import d2hooks.RewardableAchievementsVisible;
   import d2hooks.UiLoaded;
   import d2hooks.UiUnloaded;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class AdvancedTutorialStepManager
   {
      
      private static var _instance:AdvancedTutorialStepManager;
       
      
      private const DEFAULT_STEP:int = -1;
      
      private var _quest:Quest;
      
      private var _questInfo:Object;
      
      private var _currentStepNumber:int = -1;
      
      private var _currentSubtepNumber:int = -1;
      
      private var _mapId:uint = 4.294967295E9;
      
      private var _inDialog:Boolean = false;
      
      private var _questActionTimer:Timer;
      
      private var _questRequested:Array;
      
      public function AdvancedTutorialStepManager()
      {
         this._questActionTimer = new Timer(50,1);
         this._questRequested = [];
         super();
      }
      
      public static function getInstance(param1:Boolean = true) : AdvancedTutorialStepManager
      {
         if(!_instance && param1)
         {
            _instance = new AdvancedTutorialStepManager();
            _instance.init();
         }
         return _instance;
      }
      
      public function set currentMapId(param1:uint) : void
      {
         this._mapId = param1;
      }
      
      private function init() : void
      {
         Api.system.addHook(UiLoaded,this.onUiLoaded);
         Api.system.addHook(UiUnloaded,this.onUnloaded);
         Api.system.addHook(CurrentMap,this.onCurrentMap);
         Api.system.addHook(LeaveDialog,this.onLeaveDialog);
         Api.system.addHook(IdolSelected,this.onIdolSelected);
         Api.system.addHook(QuestStarted,this.onQuestStarted);
         Api.system.addHook(GameFightEnd,this.onGameFightEnd);
         Api.system.addHook(GameFightJoin,this.onGameFightJoin);
         Api.system.addHook(GameFightStart,this.onGameFightStart);
         Api.system.addHook(GameFightLeave,this.onGameFightLeave);
         Api.system.addHook(QuestValidated,this.onQuestValidated);
         Api.system.addHook(JobsExpUpdated,this.onJobExperienceUpdate);
         Api.system.addHook(NpcDialogCreation,this.onNpcDialogCreation);
         Api.system.addHook(QuestInfosUpdated,this.onQuestInfosUpdated);
         Api.system.addHook(ExchangeObjectAdded,this.onExchangeObjectAdded);
         Api.system.addHook(GiftsWaitingAllocation,this.onGiftsWaitingAllocation);
         Api.system.addHook(QuestObjectiveValidated,this.onQuestObjectiveValidated);
         Api.system.addHook(AchievementRewardSuccess,this.onAchievementRewardSuccess);
         Api.system.addHook(RewardableAchievementsVisible,this.onRewardableAchievementsVisible);
         Api.system.addHook(MapComplementaryInformationsData,this.onMapComplementaryInformationsData);
         this._questActionTimer.addEventListener(TimerEvent.TIMER,this.onQuestTimerTick);
         this.askQuestInfo();
      }
      
      public function destroy() : void
      {
         _instance = null;
         if(Api.highlight)
         {
            Api.highlight.stop();
         }
         if(this._questActionTimer)
         {
            this._questActionTimer.stop();
            this._questActionTimer.removeEventListener(TimerEvent.TIMER,this.onQuestTimerTick);
         }
      }
      
      private function askQuestInfo(param1:int = -1) : Boolean
      {
         if(param1 != -1)
         {
            this.sendQuestAction(param1);
            return true;
         }
         var _loc2_:Object = Api.quest.getActiveQuests();
         for each(param1 in _loc2_)
         {
            if(TutorialAdvancedConstants.QUEST_IDS.indexOf(param1) != -1)
            {
               this.sendQuestAction(param1);
               return true;
            }
         }
         if(this._currentStepNumber != -1)
         {
            this.prepareStep(this._currentStepNumber,this._currentSubtepNumber);
            return true;
         }
         return false;
      }
      
      private function sendQuestAction(param1:uint) : void
      {
         if(this._questRequested.indexOf(param1) == -1)
         {
            this._questRequested.push(param1);
         }
         this._questActionTimer.reset();
         this._questActionTimer.start();
      }
      
      protected function onQuestTimerTick(param1:TimerEvent) : void
      {
         var _loc2_:uint = 0;
         for each(_loc2_ in this._questRequested)
         {
            Api.system.sendAction(new QuestInfosRequest(_loc2_));
         }
         this._questRequested = [];
      }
      
      private function prepareStep(param1:int, param2:int = 0) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:* = undefined;
         var _loc7_:uint = 0;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         Api.highlight.stop();
         this._currentStepNumber = param1;
         this._currentSubtepNumber = param2;
         if(this._inDialog)
         {
            return;
         }
         if(this.waitingForRewards())
         {
            if(Api.ui.getUi("rewardsAndGiftsUi") != null)
            {
               Api.highlight.highlightUi("rewardsAndGiftsUi","btn_acceptAll",1,1,6,true);
            }
            else
            {
               Api.highlight.highlightUi(UIEnum.MAP_INFO_UI,"btn_rewardsAndGifts",1,0,5,true);
            }
            return;
         }
         switch(true)
         {
            case param1 == TutorialAdvancedConstants.JOB_STEP_GOTO_MAP:
               this.hightlightPath(TutorialAdvancedConstants.JOB_MAP_ID);
               break;
            case param1 == TutorialAdvancedConstants.JOB_STEP_FIRST_NPC_DIALOG:
               if(this.hightlightPath(TutorialAdvancedConstants.JOB_MAP_ID))
               {
                  return;
               }
               Api.highlight.highlightNpc(TutorialAdvancedConstants.NPC_HOBOULO,true);
               break;
            case TutorialAdvancedConstants.JOB_STEP_HARVEST.indexOf(param1) != -1:
               if(this.hightlightPath(TutorialAdvancedConstants.JOB_MAP_ID))
               {
                  return;
               }
               _loc3_ = [];
               for(_loc6_ in this._questInfo.objectives)
               {
                  if(this._questInfo.objectives[_loc6_] && TutorialAdvancedConstants.HARVEST_CELL_BY_OBJECTIVE[_loc6_] != undefined)
                  {
                     _loc3_.push(TutorialAdvancedConstants.HARVEST_CELL_BY_OBJECTIVE[_loc6_]);
                  }
               }
               Api.highlight.highlightCell(_loc3_,true);
               break;
            case param1 == TutorialAdvancedConstants.JOB_STEP_CRAFT:
               if(this.hightlightPath(TutorialAdvancedConstants.JOB_MAP_ID))
               {
                  return;
               }
               switch(param2)
               {
                  case TutorialAdvancedConstants.JOB_STEP_CRAFT__OPEN_UI:
                     Api.highlight.highlightAbsolute(new Rectangle(TutorialAdvancedConstants.JOB_TOOL_X,TutorialAdvancedConstants.JOB_TOOL_Y),0,0,0,true);
                     break;
                  case TutorialAdvancedConstants.JOB_STEP_CRAFT__ADD_INGREDIENT:
                     Api.highlight.highlightAbsolute(new Rectangle(50,185),1,1,5,true);
                     break;
                  case TutorialAdvancedConstants.JOB_STEP_CRAFT__FUSION:
                     Api.highlight.highlightUi(UIEnum.CRAFT,"btn_ok",7,0,5,true);
                     break;
                  case TutorialAdvancedConstants.JOB_STEP_CRAFT__QUIT:
                     Api.highlight.highlightUi(UIEnum.STORAGE_UI,"btn_close",7,0,5,true);
               }
               break;
            case param1 == TutorialAdvancedConstants.JOB_STEP_SHOW_CRAFT:
               if(this.hightlightPath(TutorialAdvancedConstants.JOB_MAP_ID))
               {
                  return;
               }
               Api.highlight.highlightNpc(TutorialAdvancedConstants.NPC_HOBOULO,true);
               break;
            case param1 == TutorialAdvancedConstants.JOB_STEP_GO_JORIS:
               if(this.hightlightPath(TutorialAdvancedConstants.HUB_MAP_ID))
               {
                  return;
               }
               Api.highlight.highlightNpc(TutorialAdvancedConstants.NPC_JORIS,true);
               break;
            case param1 == TutorialAdvancedConstants.FIGHT_STEP_GOTO_MAP:
               if(this.hightlightPath(TutorialAdvancedConstants.FIGHT_MAP_ID))
               {
                  return;
               }
               break;
            case param1 == TutorialAdvancedConstants.FIGHT_STEP_NPC_DIALOG_1:
            case param1 == TutorialAdvancedConstants.FIGHT_STEP_NPC_DIALOG_2:
            case param1 == TutorialAdvancedConstants.FIGHT_STEP_NPC_DIALOG_3:
            case param1 == TutorialAdvancedConstants.FIGHT_STEP_NPC_DIALOG_4:
               if(this.hightlightPath(TutorialAdvancedConstants.FIGHT_MAP_ID))
               {
                  return;
               }
               Api.highlight.highlightNpc(TutorialAdvancedConstants.NPC_DARM,true);
               break;
            case param1 == TutorialAdvancedConstants.FIGHT_STEP_FIGHT_SIMPLE:
               if(this.hightlightPath(TutorialAdvancedConstants.FIGHT_MAP_ID))
               {
                  return;
               }
               Api.highlight.highlightNpc(TutorialAdvancedConstants.NPC_MONSTER,true);
               break;
            case TutorialAdvancedConstants.FIGHT_STEP_WITH_IDOLE_LIST.indexOf(param1) != -1:
               if(this.hightlightPath(TutorialAdvancedConstants.FIGHT_MAP_ID))
               {
                  return;
               }
               this._currentSubtepNumber = TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__OPEN_UI;
               _loc4_ = Api.player.getSoloIdols();
               for each(_loc7_ in _loc4_)
               {
                  if(_loc7_ == TutorialAdvancedConstants.FIGHT_IDOL_ID)
                  {
                     if(Api.ui.getUi("idolsTab") != null)
                     {
                        this._currentSubtepNumber = TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__CLOSE_UI;
                     }
                     else
                     {
                        this._currentSubtepNumber = TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__START;
                     }
                     break;
                  }
               }
               if(this._currentSubtepNumber == TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__OPEN_UI && Api.ui.getUi("idolsTab") != null)
               {
                  this._currentSubtepNumber = TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__ACTIVE;
               }
               if(this._currentSubtepNumber == TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__START && Api.player.isInPreFight())
               {
                  this._currentSubtepNumber = TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__READY;
               }
               switch(this._currentSubtepNumber)
               {
                  case TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__OPEN_UI:
                     _loc8_ = Object(Api.ui.getUi("bannerMenu")).uiClass;
                     _loc9_ = _loc8_.getSlotByBtnId(_loc8_.ID_BTN_IDOLS).getStageRect();
                     Api.highlight.highlightAbsolute(new Rectangle(_loc9_.x,_loc9_.y,_loc9_.width,_loc9_.height),1,0,5,true);
                     break;
                  case TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__ACTIVE:
                     Api.highlight.highlightAbsolute(new Rectangle(215,366),2,0,5,true);
                     break;
                  case TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__CLOSE_UI:
                     Api.highlight.highlightUi(UIEnum.GRIMOIRE,"btn_close",7,0,5,true);
                     break;
                  case TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__START:
                     Api.highlight.highlightNpc(TutorialAdvancedConstants.NPC_MONSTER,true);
                     break;
                  case TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__READY:
                     Api.highlight.highlightUi(UIEnum.BANNER,"btn_readyOrSkip",1,0,5,true);
                     break;
                  case TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__FINISH:
                     Api.highlight.highlightUi("fightResult","btn_close",7,0,5,true);
               }
               break;
            case this._currentStepNumber == TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE_2:
               if(this.hightlightPath(TutorialAdvancedConstants.FIGHT_MAP_ID))
               {
                  return;
               }
               Api.highlight.highlightNpc(TutorialAdvancedConstants.NPC_MONSTER,true);
               break;
            case this._currentStepNumber == TutorialAdvancedConstants.FIGHT_STEP_GO_JORIS:
               if(this.hightlightPath(TutorialAdvancedConstants.HUB_MAP_ID))
               {
                  return;
               }
               Api.highlight.highlightNpc(TutorialAdvancedConstants.NPC_JORIS,true);
               break;
            default:
               _loc5_ = Api.quest.getCompletedQuests();
               if(param1 == this.DEFAULT_STEP && _loc5_.indexOf(TutorialAdvancedConstants.QUEST_FIGHT_ID) == -1 && _loc5_.indexOf(TutorialAdvancedConstants.QUEST_JOB_ID) == -1 && this._mapId == TutorialAdvancedConstants.HUB_MAP_ID)
               {
                  Api.highlight.highlightNpc(TutorialAdvancedConstants.NPC_JORIS,true);
               }
         }
      }
      
      private function waitingForRewards() : Boolean
      {
         var _loc1_:* = Api.quest.getRewardableAchievements();
         var _loc2_:* = Api.player.getWaitingGifts();
         return _loc1_ && _loc1_.length > 0 || _loc2_ && _loc2_.length > 0;
      }
      
      private function hightlightPath(param1:uint) : Boolean
      {
         var targetMapId:uint = param1;
         if(targetMapId == this._mapId)
         {
            return false;
         }
         var genericStatueMapId:uint = 1;
         var path:Dictionary = new Dictionary();
         path[TutorialAdvancedConstants.FIGHT_MAP_ID + ">" + TutorialAdvancedConstants.HUB_MAP_ID] = path[TutorialAdvancedConstants.JOB_MAP_ID + ">" + TutorialAdvancedConstants.HUB_MAP_ID] = function():void
         {
            Api.highlight.highlightAbsolute(new Rectangle(400,700),1,0,1,true);
         };
         path[TutorialAdvancedConstants.HUB_MAP_ID + ">" + TutorialAdvancedConstants.FIGHT_MAP_ID] = function():void
         {
            Api.highlight.highlightAbsolute(new Rectangle(760,280),1,1,1,true);
         };
         path[TutorialAdvancedConstants.HUB_MAP_ID + ">" + TutorialAdvancedConstants.JOB_MAP_ID] = function():void
         {
            Api.highlight.highlightAbsolute(new Rectangle(1000,425),1,1,1,true);
         };
         path[TutorialAdvancedConstants.HUB_MAP_ID + ">" + genericStatueMapId] = function():void
         {
            Api.highlight.highlightAbsolute(new Rectangle(400,700),1,0,1,true);
         };
         path[genericStatueMapId + ">" + TutorialAdvancedConstants.HUB_MAP_ID] = function():void
         {
            Api.highlight.highlightAbsolute(new Rectangle(1000,325),1,1,1,true);
         };
         path[TutorialAdvancedConstants.EXIT_MAP_ID + ">" + genericStatueMapId] = function():void
         {
            Api.highlight.highlightAbsolute(new Rectangle(256,300),1,1,1,true);
         };
         var intermediateMapTarged:Dictionary = new Dictionary();
         intermediateMapTarged[genericStatueMapId + ">" + TutorialAdvancedConstants.FIGHT_MAP_ID] = TutorialAdvancedConstants.HUB_MAP_ID;
         intermediateMapTarged[genericStatueMapId + ">" + TutorialAdvancedConstants.JOB_MAP_ID] = TutorialAdvancedConstants.HUB_MAP_ID;
         intermediateMapTarged[TutorialAdvancedConstants.FIGHT_MAP_ID + ">" + genericStatueMapId] = TutorialAdvancedConstants.HUB_MAP_ID;
         intermediateMapTarged[TutorialAdvancedConstants.JOB_MAP_ID + ">" + genericStatueMapId] = TutorialAdvancedConstants.HUB_MAP_ID;
         intermediateMapTarged[TutorialAdvancedConstants.EXIT_MAP_ID + ">" + TutorialAdvancedConstants.FIGHT_MAP_ID] = genericStatueMapId;
         intermediateMapTarged[TutorialAdvancedConstants.EXIT_MAP_ID + ">" + TutorialAdvancedConstants.JOB_MAP_ID] = genericStatueMapId;
         intermediateMapTarged[TutorialAdvancedConstants.EXIT_MAP_ID + ">" + TutorialAdvancedConstants.HUB_MAP_ID] = genericStatueMapId;
         if(TutorialAdvancedConstants.STATUE_MAP_ID.indexOf(targetMapId) != -1)
         {
            targetMapId = genericStatueMapId;
         }
         var mapId:uint = this._mapId;
         if(TutorialAdvancedConstants.STATUE_MAP_ID.indexOf(mapId) != -1)
         {
            mapId = genericStatueMapId;
         }
         if(intermediateMapTarged[mapId + ">" + targetMapId])
         {
            targetMapId = intermediateMapTarged[mapId + ">" + targetMapId];
         }
         if(path[mapId + ">" + targetMapId])
         {
            path[mapId + ">" + targetMapId]();
            return true;
         }
         Api.system.log(16,targetMapId + " : map de destination inconnue.");
         return false;
      }
      
      private function onCurrentMap(param1:uint) : void
      {
         Api.highlight.stop();
         this.currentMapId = param1;
      }
      
      private function onUiLoaded(param1:String) : void
      {
         if(_instance == null)
         {
            return;
         }
         if(param1 == "rewardsAndGiftsUi")
         {
            this.prepareStep(this._currentStepNumber,this._currentSubtepNumber);
            return;
         }
         switch(true)
         {
            case TutorialAdvancedConstants.JOB_STEP_CRAFT == this._currentStepNumber:
               if(param1 == UIEnum.CRAFT)
               {
                  this.prepareStep(TutorialAdvancedConstants.JOB_STEP_CRAFT,TutorialAdvancedConstants.JOB_STEP_CRAFT__ADD_INGREDIENT);
               }
               break;
            case TutorialAdvancedConstants.FIGHT_STEP_WITH_IDOLE_LIST.indexOf(this._currentStepNumber) != -1:
               if(param1 == "idolsTab" && this._currentSubtepNumber == TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__OPEN_UI)
               {
                  this.prepareStep(this._currentStepNumber,TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__ACTIVE);
               }
               break;
            case TutorialAdvancedConstants.FIGHT_STEP_WITH_IDOLE_LIST.indexOf(this._currentStepNumber) != -1:
               if(param1 == "fightResult")
               {
                  this.prepareStep(this._currentStepNumber,TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__FINISH);
               }
         }
      }
      
      private function onUnloaded(param1:String) : void
      {
         if(_instance == null)
         {
            return;
         }
         if(param1 == "rewardsAndGiftsUi" && this.waitingForRewards())
         {
            this.prepareStep(this._currentStepNumber,this._currentSubtepNumber);
            return;
         }
         switch(true)
         {
            case TutorialAdvancedConstants.JOB_STEP_CRAFT == this._currentStepNumber:
               if(param1 == UIEnum.CRAFT && (this._currentSubtepNumber == TutorialAdvancedConstants.JOB_STEP_CRAFT__ADD_INGREDIENT || this._currentSubtepNumber == TutorialAdvancedConstants.JOB_STEP_CRAFT__FUSION))
               {
                  this.prepareStep(TutorialAdvancedConstants.JOB_STEP_CRAFT,TutorialAdvancedConstants.JOB_STEP_CRAFT__OPEN_UI);
               }
               break;
            case TutorialAdvancedConstants.FIGHT_STEP_WITH_IDOLE_LIST.indexOf(this._currentStepNumber) != -1:
               if(param1 == "idolsTab")
               {
                  if(this._currentSubtepNumber == TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__OPEN_UI || this._currentSubtepNumber == TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__ACTIVE)
                  {
                     this.prepareStep(this._currentStepNumber,TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__OPEN_UI);
                  }
                  if(this._currentSubtepNumber == TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__CLOSE_UI)
                  {
                     this.prepareStep(this._currentStepNumber,TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__START);
                  }
               }
         }
      }
      
      private function onQuestStarted(param1:uint) : void
      {
         if(_instance == null)
         {
            return;
         }
         if(TutorialAdvancedConstants.QUEST_IDS.indexOf(param1) != -1)
         {
            this.askQuestInfo(param1);
         }
      }
      
      private function onQuestValidated(param1:uint) : void
      {
         if(_instance == null)
         {
            return;
         }
         if(param1 == TutorialAdvancedConstants.QUEST_FIGHT_ID)
         {
            this._currentStepNumber = -1;
            this._currentSubtepNumber = -1;
         }
      }
      
      private function onQuestInfosUpdated(param1:uint, param2:Boolean) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Boolean = false;
         if(_instance == null)
         {
            return;
         }
         if(TutorialAdvancedConstants.QUEST_IDS.indexOf(param1) != -1 && param2)
         {
            this._questInfo = Api.quest.getQuestInformations(param1);
            for(_loc3_ in this._questInfo.objectives)
            {
               _loc4_ = this._questInfo.objectives[_loc3_];
               if(this._questInfo.objectives[_loc3_] == true)
               {
                  this.prepareStep(_loc3_);
                  break;
               }
            }
         }
      }
      
      private function onQuestObjectiveValidated(param1:uint, ... rest) : void
      {
         if(_instance == null)
         {
            return;
         }
         if(TutorialAdvancedConstants.QUEST_IDS.indexOf(param1) != -1)
         {
            this.askQuestInfo(param1);
         }
      }
      
      public function onNpcDialogCreation(... rest) : void
      {
         if(_instance == null)
         {
            return;
         }
         Api.highlight.stop();
         this._inDialog = true;
      }
      
      public function onLeaveDialog(... rest) : void
      {
         if(_instance == null)
         {
            return;
         }
         this._inDialog = false;
         this.prepareStep(this._currentStepNumber,this._currentSubtepNumber);
      }
      
      private function onExchangeObjectAdded(... rest) : void
      {
         if(_instance == null)
         {
            return;
         }
         if(this._currentStepNumber == TutorialAdvancedConstants.JOB_STEP_CRAFT && this._currentSubtepNumber == TutorialAdvancedConstants.JOB_STEP_CRAFT__ADD_INGREDIENT)
         {
            this.prepareStep(TutorialAdvancedConstants.JOB_STEP_CRAFT,TutorialAdvancedConstants.JOB_STEP_CRAFT__FUSION);
         }
      }
      
      private function onJobExperienceUpdate(... rest) : void
      {
         if(_instance == null)
         {
            return;
         }
         if(this._currentStepNumber == TutorialAdvancedConstants.JOB_STEP_CRAFT)
         {
            this.prepareStep(TutorialAdvancedConstants.JOB_STEP_CRAFT,TutorialAdvancedConstants.JOB_STEP_CRAFT__QUIT);
         }
      }
      
      private function onMapComplementaryInformationsData(param1:WorldPointWrapper, ... rest) : void
      {
         if(_instance == null)
         {
            return;
         }
         this.currentMapId = param1.mapId;
         if(!this.askQuestInfo())
         {
            this.prepareStep(this._currentStepNumber,this._currentSubtepNumber);
         }
      }
      
      private function onGameFightJoin(... rest) : void
      {
         if(_instance == null)
         {
            return;
         }
         Api.highlight.stop();
         if(TutorialAdvancedConstants.FIGHT_STEP_WITH_IDOLE_LIST.indexOf(this._currentStepNumber) != -1 && this._currentSubtepNumber == TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__START)
         {
            this.prepareStep(this._currentStepNumber,TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__READY);
         }
      }
      
      private function onGameFightStart(... rest) : void
      {
         if(_instance == null)
         {
            return;
         }
         Api.highlight.stop();
      }
      
      private function onIdolSelected(param1:uint, param2:Boolean, ... rest) : void
      {
         if(_instance == null)
         {
            return;
         }
         if(TutorialAdvancedConstants.FIGHT_STEP_WITH_IDOLE_LIST.indexOf(this._currentStepNumber) != -1 && this._currentSubtepNumber == TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__ACTIVE && param1 == TutorialAdvancedConstants.FIGHT_IDOL_ID && param2)
         {
            this.prepareStep(this._currentStepNumber,TutorialAdvancedConstants.FIGHT_STEP_FIGHT_IDOLE__START);
         }
         else
         {
            this.prepareStep(this._currentStepNumber,this._currentSubtepNumber);
         }
      }
      
      public function onGameFightEnd(... rest) : void
      {
         if(_instance == null)
         {
            return;
         }
         this.prepareStep(this._currentStepNumber,this._currentSubtepNumber);
      }
      
      public function onGameFightLeave(param1:Number) : void
      {
         if(_instance == null)
         {
            return;
         }
         this.prepareStep(this._currentStepNumber,this._currentSubtepNumber);
      }
      
      private function onRewardableAchievementsVisible(param1:Boolean) : void
      {
         if(_instance == null)
         {
            return;
         }
         this.prepareStep(this._currentStepNumber,this._currentSubtepNumber);
      }
      
      private function onAchievementRewardSuccess(... rest) : void
      {
         if(_instance == null)
         {
            return;
         }
         this.prepareStep(this._currentStepNumber,this._currentSubtepNumber);
      }
      
      private function onGiftsWaitingAllocation(param1:Boolean) : void
      {
         if(_instance == null)
         {
            return;
         }
         this.prepareStep(this._currentStepNumber,this._currentSubtepNumber);
      }
   }
}
