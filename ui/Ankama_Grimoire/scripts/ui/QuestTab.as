package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.quest.Quest;
   import com.ankamagames.dofus.datacenter.quest.QuestCategory;
   import com.ankamagames.dofus.datacenter.quest.QuestObjective;
   import com.ankamagames.dofus.datacenter.quest.QuestStep;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.communication.EmoteWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.jobs.JobWrapper;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.ChatApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.MapApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.QuestInfosRequest;
   import d2actions.QuestListRequest;
   import d2enums.CompassTypeEnum;
   import d2enums.ComponentHookList;
   import d2enums.SelectMethodEnum;
   import d2hooks.AddMapFlag;
   import d2hooks.FlagRemoved;
   import d2hooks.KeyUp;
   import d2hooks.OpenBook;
   import d2hooks.QuestInfosUpdated;
   import d2hooks.QuestListUpdated;
   import d2hooks.TextureLoadFailed;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class QuestTab
   {
      
      private static var MAX_QUEST_FLAGS:int = 6;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var questApi:QuestApi;
      
      public var dataApi:DataApi;
      
      public var soundApi:SoundApi;
      
      public var utilApi:UtilApi;
      
      public var averagePricesApi:AveragePricesApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var mapApi:MapApi;
      
      public var chatApi:ChatApi;
      
      public var menuApi:ContextMenuApi;
      
      [Module(name="Ankama_Cartography")]
      public var modCartography:Object;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private var _questsToShow:Array;
      
      private var _questActiveList:Array;
      
      private var _questCompletedList:Array;
      
      private var _questStepsList:Array;
      
      private var _iconRewards:Array;
      
      private var _itemRewardsDic:Dictionary;
      
      private var _questInfos:Object;
      
      private var _currentStep:uint;
      
      private var _displayedStep:uint;
      
      private var _currentIndexForStep:uint;
      
      private var _selectedQuest:uint;
      
      private var _closedCategories:Array;
      
      private var _showCompletedQuest:Boolean;
      
      private var _bDescendingSort:Boolean = false;
      
      private var _aSlotsReward:Array;
      
      private var _rewards:Array;
      
      private var _previousRewardSelected:Object;
      
      private var _aSlotsObjective:Dictionary;
      
      private var _aObjectivesDialog:Dictionary;
      
      private var _selectedQuestCategory:int;
      
      private var _forceOpenCategory:Boolean = false;
      
      private var _stepNpcMessage:String;
      
      private var _boostBtnList:Dictionary;
      
      private var _displayTooltip:Boolean;
      
      private var _isInit:Boolean;
      
      private var _currentCategorySelected:Label;
      
      private var _selectedCatId:int = -1;
      
      private var _lockSearchTimer:Timer;
      
      private var _previousSearchCriteria:String;
      
      private var _searchCriteria:String;
      
      private var _searchTextByCriteriaList:Dictionary;
      
      private var _searchResultByCriteriaList:Dictionary;
      
      private var _searchOnName:Boolean;
      
      private var _searchOnCategory:Boolean;
      
      private var _activeUri:Object;
      
      private var _completeUri:Object;
      
      private var _repeatUri:Object;
      
      private var _downArrowUri:Object;
      
      private var _rightArrowUri:Object;
      
      private var _dungeonIconUri:Object;
      
      private var _partyIconUri:Object;
      
      private var _checkedIconUri:Object;
      
      private var _notCheckedIconUri:Object;
      
      public var ctr_itemBlock:GraphicContainer;
      
      public var ctr_item:GraphicContainer;
      
      public var ctn_slots:GraphicContainer;
      
      public var tx_reward_1:Slot;
      
      public var tx_reward_2:Slot;
      
      public var tx_reward_3:Slot;
      
      public var tx_reward_4:Slot;
      
      public var tx_reward_5:Slot;
      
      public var tx_reward_6:Slot;
      
      public var tx_reward_7:Slot;
      
      public var tx_reward_8:Slot;
      
      public var tx_dialog:Texture;
      
      public var tx_achieve:Texture;
      
      public var tx_rewardsXp:Texture;
      
      public var tx_rewardsKama:Texture;
      
      public var tx_inputBg_search:TextureBitmap;
      
      public var ent_npc:Object;
      
      public var txa_description:TextArea;
      
      public var lbl_stepName:Label;
      
      public var lbl_nbQuests:Label;
      
      public var lbl_objectives:Label;
      
      public var lbl_rewardsXp:Label;
      
      public var lbl_rewardsKama:Label;
      
      public var lbl_noQuest:Label;
      
      public var inp_search:Input;
      
      public var cbx_steps:ComboBox;
      
      public var bgcbx_steps:TextureBitmap;
      
      public var tx_bg_step:TextureBitmap;
      
      public var btn_tabComplete:ButtonContainer;
      
      public var btn_tabName:ButtonContainer;
      
      public var btn_showCompletedQuests:ButtonContainer;
      
      public var btn_close_ctr_itemBlock:ButtonContainer;
      
      public var btn_loc:ButtonContainer;
      
      public var btn_resetSearch:ButtonContainer;
      
      public var btn_searchFilter:ButtonContainer;
      
      public var gd_objectives:Grid;
      
      public var gd_quests:Grid;
      
      public function QuestTab()
      {
         this._boostBtnList = new Dictionary(true);
         this._searchTextByCriteriaList = new Dictionary(true);
         this._searchResultByCriteriaList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:Slot = null;
         this.bgcbx_steps.visible = false;
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this.sysApi.addHook(QuestListUpdated,this.onQuestListUpdated);
         this.sysApi.addHook(QuestInfosUpdated,this.onQuestInfosUpdated);
         this.sysApi.addHook(TextureLoadFailed,this.onTextureLoadFailed);
         this.sysApi.addHook(OpenBook,this.onUpdateQuestTab);
         this.sysApi.addHook(FlagRemoved,this.onFlagRemoved);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.uiApi.addComponentHook(this.gd_quests,ComponentHookList.ON_SELECT_ITEM);
         this._lockSearchTimer = new Timer(500,1);
         this._lockSearchTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
         this._isInit = false;
         this._questActiveList = new Array();
         this._questCompletedList = new Array();
         this._questStepsList = new Array();
         this._iconRewards = new Array();
         this._aSlotsReward = new Array(this.tx_reward_1,this.tx_reward_2,this.tx_reward_3,this.tx_reward_4,this.tx_reward_5,this.tx_reward_6,this.tx_reward_7,this.tx_reward_8);
         this._aSlotsObjective = new Dictionary();
         this._aObjectivesDialog = new Dictionary();
         this._itemRewardsDic = new Dictionary();
         this._searchTextByCriteriaList["_searchOnName"] = this.uiApi.getText("ui.common.name");
         this._searchTextByCriteriaList["_searchOnCategory"] = this.uiApi.getText("ui.common.category");
         this._searchOnCategory = Grimoire.getInstance().questSearchOnCategory;
         this._searchOnName = Grimoire.getInstance().questSearchOnName;
         this._activeUri = this.uiApi.createUri(this.uiApi.me().getConstant("active_uri"));
         this._completeUri = this.uiApi.createUri(this.uiApi.me().getConstant("complete_uri"));
         this._repeatUri = this.uiApi.createUri(this.uiApi.me().getConstant("repeat_uri"));
         this._downArrowUri = this.uiApi.createUri(this.uiApi.me().getConstant("flechebas_uri"));
         this._rightArrowUri = this.uiApi.createUri(this.uiApi.me().getConstant("flecheright_uri"));
         this._dungeonIconUri = this.uiApi.createUri(this.uiApi.me().getConstant("dungeon_icon"));
         this._partyIconUri = this.uiApi.createUri(this.uiApi.me().getConstant("party_icon"));
         this._checkedIconUri = this.uiApi.createUri(this.uiApi.me().getConstant("checked"));
         this._notCheckedIconUri = this.uiApi.createUri(this.uiApi.me().getConstant("not_checked"));
         for each(_loc2_ in this._aSlotsReward)
         {
            this.registerSlot(_loc2_);
         }
         this.ctr_itemBlock.visible = false;
         this.sysApi.sendAction(new QuestListRequest());
         this.uiApi.addComponentHook(this.tx_dialog,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_dialog,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.cbx_steps,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addShortcutHook("leftArrow",this.onShortCut);
         this.uiApi.addShortcutHook("rightArrow",this.onShortCut);
         if(param1 && param1.quest)
         {
            this._selectedQuest = param1.quest.id;
            this._forceOpenCategory = true;
         }
         else
         {
            this._selectedQuest = this.sysApi.getData("lastQuestSelected");
            this._forceOpenCategory = true;
         }
         if(this.dataApi.getQuest(this._selectedQuest))
         {
            this._selectedQuestCategory = this.dataApi.getQuest(this._selectedQuest).category.id;
         }
         this._closedCategories = this.sysApi.getData("closedQuestCategories");
         this._showCompletedQuest = this.sysApi.getData("showCompletedQuest");
         this._displayTooltip = this.sysApi.getOption("displayTooltips","dofus");
      }
      
      public function unload() : void
      {
         this.sysApi.log(2,"unload questtab     _lockSearchTimer " + this._lockSearchTimer);
         if(this._lockSearchTimer)
         {
            this.sysApi.log(2,"sparti ");
            this._lockSearchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
            this._lockSearchTimer.stop();
            this._lockSearchTimer = null;
         }
         this.uiApi.unloadUi("itemBox_" + this.uiApi.me().name);
      }
      
      public function updateItem(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         if(param1)
         {
            param2.lbl_questName.visible = true;
            param2.btn_quest.disabled = false;
            if(param1.isCategory)
            {
               _loc4_ = this.dataApi.getQuestCategory(param1.id);
               if(_loc4_ != null)
               {
                  param2.lbl_questName.text = _loc4_.name;
                  param2.lbl_questName.x = 15;
                  param2.lbl_questName.cssClass = "p";
                  param2.lbl_questName.css = this.uiApi.createUri(this.uiApi.me().getConstant("css") + "normal2.css");
                  param2.tx_questIcon.uri = null;
                  param2.tx_questComplete.uri = null;
                  param2.tx_cat_bg.visible = true;
                  if(param1.visible)
                  {
                     param2.tx_cat_open.uri = this._downArrowUri;
                  }
                  else
                  {
                     param2.tx_cat_open.uri = this._rightArrowUri;
                  }
                  param2.btn_quest.selected = !(this._selectedQuest && this._selectedQuest >= 0) && param1.id == this._selectedQuestCategory;
               }
               else
               {
                  this.clearLine(param2);
               }
            }
            else
            {
               _loc4_ = this.dataApi.getQuest(param1.id);
               if(_loc4_ != null)
               {
                  param2.lbl_questName.x = 45;
                  param2.lbl_questName.fullSize(parseInt(this.uiApi.me().getConstant("lbl_questName_width")));
                  if(_loc4_.isDungeonQuest)
                  {
                     param2.tx_questIcon.uri = this._dungeonIconUri;
                     param2.tx_questIcon.visible = true;
                     param2.lbl_questName.x = param2.lbl_questName.x + 33;
                     param2.lbl_questName.width = param2.lbl_questName.width - 33;
                  }
                  else if(_loc4_.isPartyQuest)
                  {
                     param2.tx_questIcon.uri = this._partyIconUri;
                     param2.tx_questIcon.visible = true;
                     param2.lbl_questName.x = param2.lbl_questName.x + 33;
                     param2.lbl_questName.width = param2.lbl_questName.width - 33;
                  }
                  else
                  {
                     param2.tx_questIcon.visible = false;
                  }
                  param2.lbl_questName.text = this.getQuestName(_loc4_);
                  if(param1.status)
                  {
                     param2.tx_questComplete.uri = this._activeUri;
                     param2.lbl_questName.cssClass = "p";
                     param2.lbl_questName.css = this.uiApi.createUri(this.uiApi.me().getConstant("css") + "small2.css");
                  }
                  else
                  {
                     param2.tx_questComplete.uri = this._completeUri;
                     param2.lbl_questName.cssClass = "p4";
                     param2.lbl_questName.css = this.uiApi.createUri(this.uiApi.me().getConstant("css") + "small2.css");
                  }
                  if(_loc4_.repeatType != 0)
                  {
                     param2.tx_questComplete.uri = this._repeatUri;
                  }
                  param2.btn_quest.selected = this._selectedQuest == param1.id;
                  param2.tx_cat_bg.visible = false;
                  param2.tx_cat_open.uri = null;
               }
               else
               {
                  this.clearLine(param2);
               }
            }
         }
         else
         {
            this.clearLine(param2);
         }
      }
      
      private function getQuestName(param1:Object) : String
      {
         var _loc2_:* = "[";
         if(param1.levelMin == param1.levelMax || param1.levelMin > param1.levelMax)
         {
            _loc2_ = _loc2_ + param1.levelMin;
         }
         else
         {
            _loc2_ = _loc2_ + (param1.levelMin + "-" + param1.levelMax);
         }
         _loc2_ = _loc2_ + "]";
         var _loc3_:String = param1.name + (param1.levelMin == param1.levelMax && param1.levelMin == 0?"":" " + _loc2_);
         if(this.sysApi.getPlayerManager().hasRights)
         {
            _loc3_ = _loc3_ + (" (" + param1.id + ")");
         }
         return _loc3_;
      }
      
      private function clearLine(param1:*) : void
      {
         param1.lbl_questName.visible = false;
         param1.tx_questComplete.uri = null;
         param1.tx_questIcon.uri = null;
         if(param1.btn_quest.selected)
         {
            param1.btn_quest.selected = false;
         }
         param1.btn_quest.disabled = true;
         param1.tx_cat_open.uri = null;
         param1.tx_cat_bg.visible = false;
      }
      
      public function updateObjectivesItem(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:QuestObjective = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:* = undefined;
         var _loc8_:Object = null;
         var _loc9_:* = null;
         var _loc10_:String = null;
         if(param1)
         {
            this.uiApi.addComponentHook(param2.btn_loc,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_loc,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_loc,ComponentHookList.ON_ROLL_OUT);
            _loc4_ = this.dataApi.getQuestObjective(param1.id);
            this._aSlotsObjective[param2.btn_loc] = _loc4_;
            _loc5_ = _loc4_.text;
            if(this.sysApi.getPlayerManager().hasRights)
            {
               _loc5_ = _loc5_ + (" (" + param1.id + ")");
            }
            param2.lbl_objective.text = _loc5_;
            if(_loc4_)
            {
               _loc6_ = _loc4_.dialog;
               if(this._questInfos && this._questInfos.objectivesDialogParams[_loc4_.id])
               {
                  _loc6_ = this.utilApi.applyTextParams(_loc6_,this._questInfos.objectivesDialogParams[_loc4_.id],"#");
               }
               this._aObjectivesDialog[param2.tx_infos] = _loc6_;
               if(_loc4_.dialog != "")
               {
                  this.uiApi.addComponentHook(param2.tx_infos,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.tx_infos,ComponentHookList.ON_ROLL_OUT);
                  param2.tx_infos.visible = true;
               }
               else
               {
                  param2.tx_infos.visible = false;
               }
            }
            param2.tx_achieve.visible = true;
            if(!param1.status)
            {
               param2.tx_achieve.uri = this._checkedIconUri;
               param2.btn_loc.visible = false;
               param2.lbl_objective.cssClass = "p4";
            }
            else
            {
               param2.tx_achieve.uri = this._notCheckedIconUri;
               if(_loc4_.coords || _loc4_.mapId)
               {
                  param2.btn_loc.visible = true;
                  param2.btn_loc.selected = false;
                  param2.lbl_objective.cssClass = "p";
                  _loc7_ = this.modCartography.getFlags(this.mapApi.getCurrentWorldMap().id);
                  for each(_loc8_ in _loc7_)
                  {
                     if(_loc8_.id == "flag_srv" + CompassTypeEnum.COMPASS_TYPE_QUEST + "_" + this._selectedQuest + "_" + _loc4_.id)
                     {
                        param2.btn_loc.selected = true;
                     }
                  }
               }
               else
               {
                  param2.btn_loc.visible = false;
                  param2.lbl_objective.cssClass = "p";
               }
               if(param1.currentCompletion != -1 && param1.maxCompletion != -1)
               {
                  _loc9_ = " (" + param1.currentCompletion + "/" + param1.maxCompletion + ")" + "</FONT></P>";
                  _loc10_ = param2.lbl_objective.htmlText;
                  param2.lbl_objective.htmlText = _loc10_.replace("</FONT></P>",_loc9_);
               }
            }
         }
         else
         {
            param2.lbl_objective.text = "";
            param2.tx_achieve.uri = this._notCheckedIconUri;
            param2.tx_achieve.visible = false;
            param2.tx_infos.visible = false;
            param2.btn_loc.visible = false;
         }
      }
      
      private function registerSlot(param1:Slot) : void
      {
         this.uiApi.addComponentHook(param1,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(param1,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(param1,ComponentHookList.ON_RIGHT_CLICK);
      }
      
      private function updateQuestGrid() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:* = false;
         var _loc8_:Object = null;
         var _loc9_:* = undefined;
         var _loc10_:uint = 0;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:Array = null;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Object = null;
         var _loc22_:Object = null;
         var _loc23_:QuestCategory = null;
         var _loc24_:Object = null;
         var _loc25_:String = null;
         var _loc26_:String = null;
         var _loc27_:* = null;
         var _loc3_:Array = new Array();
         if(!this._searchCriteria)
         {
            if(this._showCompletedQuest)
            {
               this.btn_showCompletedQuests.selected = true;
            }
            else if(!this.btn_showCompletedQuests.selected && this._forceOpenCategory && !this._questActiveList.indexOf(this.dataApi.getQuest(this._selectedQuest)) == -1)
            {
               this.btn_showCompletedQuests.selected = true;
               this.sysApi.setData("showCompletedQuest",true);
            }
            this._questsToShow = new Array();
            _loc1_ = this.questApi.getAllQuestsOrderByCategory(this.btn_showCompletedQuests.selected);
            while(_loc4_ < _loc1_.length)
            {
               if(!(_loc1_[_loc4_] == null || _loc1_[_loc4_].data.length == 0))
               {
                  _loc7_ = !this.isCatClosed(_loc1_[_loc4_].id);
                  _loc2_ = {
                     "id":_loc1_[_loc4_].id,
                     "isCategory":true,
                     "visible":_loc7_
                  };
                  this._questsToShow.push(_loc2_);
                  _loc3_.push(_loc2_);
                  for each(_loc8_ in _loc1_[_loc4_].data)
                  {
                     this._questsToShow.push(_loc8_);
                     if(_loc7_)
                     {
                        _loc3_.push(_loc8_);
                     }
                  }
               }
               _loc4_ = _loc4_ + 1;
            }
            _loc5_ = this.uiApi.processText(this.uiApi.getText("ui.grimoire.pendingQuests",this._questActiveList.length),"n",this._questActiveList.length <= 1);
            _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.grimoire.completedQuests",this._questCompletedList.length),"n",this._questCompletedList.length <= 1);
            this.lbl_nbQuests.text = _loc5_ + " - " + _loc6_;
            this.gd_quests.dataProvider = _loc3_;
            if(_loc3_.length > 0)
            {
               this.lbl_noQuest.visible = false;
               for(_loc9_ in _loc3_)
               {
                  if(_loc3_[_loc9_].id == this._selectedQuest && _loc3_[_loc9_].status)
                  {
                     this.gd_quests.selectedIndex = _loc9_;
                  }
               }
               this.selectQuest();
            }
            else
            {
               this.updateEmptyStep();
               this.lbl_noQuest.visible = true;
               this.lbl_noQuest.text = this.uiApi.getText("ui.grimoire.quest.noQuest");
            }
         }
         else if(this._previousSearchCriteria != this._searchCriteria + "#" + this._searchOnName + "" + this._searchOnCategory)
         {
            _loc10_ = getTimer();
            _loc11_ = !!this._previousSearchCriteria?this._previousSearchCriteria.split("#"):[];
            if(this._searchCriteria != _loc11_[0])
            {
               _loc21_ = this.dataApi.queryString(Quest,"name",this._searchCriteria);
               _loc22_ = this.dataApi.queryString(QuestCategory,"name",this._searchCriteria);
               this._searchResultByCriteriaList["_searchOnName"] = _loc21_;
               this._searchResultByCriteriaList["_searchOnCategory"] = _loc22_;
               if(_loc21_ || _loc22_)
               {
                  this.sysApi.log(2,"Result : " + ((!!_loc21_?_loc21_.length:0) + (!!_loc22_?_loc22_.length:0)) + " in " + (getTimer() - _loc10_) + " ms");
               }
            }
            if(!this._searchOnName && !this._searchOnCategory)
            {
               this.gd_quests.dataProvider = new Array();
               this.lbl_noQuest.visible = true;
               this.lbl_noQuest.text = this.uiApi.getText("ui.search.needCriterion");
               this._previousSearchCriteria = this._searchCriteria + "#" + this._searchOnName + "" + this._searchOnCategory;
               return;
            }
            this.lbl_noQuest.visible = false;
            this._questsToShow = new Array();
            _loc12_ = new Array();
            for each(_loc13_ in this.questApi.getActiveQuests())
            {
               _loc12_.push(_loc13_);
            }
            for each(_loc13_ in this.questApi.getCompletedQuests())
            {
               _loc12_.push(_loc13_);
            }
            _loc14_ = new Array();
            _loc15_ = new Array();
            _loc16_ = new Array();
            _loc17_ = new Array();
            for each(_loc18_ in this._searchResultByCriteriaList["_searchOnCategory"])
            {
               _loc16_.push(_loc18_);
               _loc23_ = this.dataApi.getQuestCategory(_loc18_);
               for each(_loc13_ in _loc23_.questIds)
               {
                  _loc17_.push(_loc13_);
               }
            }
            for each(_loc19_ in this._searchResultByCriteriaList["_searchOnName"])
            {
               if(_loc12_.indexOf(_loc19_) != -1)
               {
                  _loc15_.push(_loc19_);
                  _loc14_.push(this.dataApi.getQuest(_loc19_).categoryId);
               }
            }
            _loc1_ = this.questApi.getAllQuestsOrderByCategory(true);
            while(_loc20_ < _loc1_.length)
            {
               if(!(_loc1_[_loc20_] == null || _loc1_[_loc20_].data.length == 0))
               {
                  if(this._searchOnCategory && _loc16_ && _loc16_.indexOf(_loc1_[_loc20_].id) != -1)
                  {
                     _loc2_ = {
                        "id":_loc1_[_loc20_].id,
                        "isCategory":true,
                        "visible":true
                     };
                     this._questsToShow.push(_loc2_);
                     _loc3_.push(_loc2_);
                  }
                  else if(this._searchOnName && _loc14_ && _loc14_.indexOf(_loc1_[_loc20_].id) != -1)
                  {
                     _loc2_ = {
                        "id":_loc1_[_loc20_].id,
                        "isCategory":true,
                        "visible":true
                     };
                     this._questsToShow.push(_loc2_);
                     _loc3_.push(_loc2_);
                  }
                  for each(_loc24_ in _loc1_[_loc20_].data)
                  {
                     if(this._searchOnName && _loc15_ && _loc15_.indexOf(_loc24_.id) != -1)
                     {
                        this._questsToShow.push(_loc24_);
                        _loc3_.push(_loc24_);
                     }
                     else if(this._searchOnCategory && _loc17_ && _loc17_.indexOf(_loc24_.id) != -1)
                     {
                        this._questsToShow.push(_loc24_);
                        _loc3_.push(_loc24_);
                     }
                  }
               }
               _loc20_ = _loc20_ + 1;
            }
            this.gd_quests.dataProvider = _loc3_;
            if(_loc3_.length > 0)
            {
               this.lbl_noQuest.visible = false;
            }
            else
            {
               this.lbl_noQuest.visible = true;
               this.lbl_noQuest.text = this.uiApi.getText("ui.search.noResult");
               _loc25_ = "";
               _loc26_ = "";
               for(_loc27_ in this._searchTextByCriteriaList)
               {
                  if(this[_loc27_])
                  {
                     _loc25_ = _loc25_ + (this._searchTextByCriteriaList[_loc27_] + ", ");
                  }
                  else if(this._searchResultByCriteriaList[_loc27_].length > 0)
                  {
                     _loc26_ = _loc26_ + (this._searchTextByCriteriaList[_loc27_] + ", ");
                  }
               }
               if(_loc25_.length > 0)
               {
                  _loc25_ = _loc25_.slice(0,-2);
               }
               if(_loc26_.length > 0)
               {
                  _loc26_ = _loc26_.slice(0,-2);
               }
               if(_loc26_.length == 0)
               {
                  this.lbl_noQuest.text = this.uiApi.getText("ui.search.noResultFor",this._searchCriteria);
               }
               else
               {
                  this.lbl_noQuest.text = this.uiApi.getText("ui.search.noResultsBut",_loc25_,_loc26_);
               }
            }
         }
      }
      
      private function selectQuest() : void
      {
         if(this.ctr_itemBlock.visible)
         {
            this.ctr_itemBlock.visible = false;
         }
         this.sysApi.sendAction(new QuestInfosRequest(this._selectedQuest));
      }
      
      private function updateStep(param1:Boolean = false) : void
      {
         var _loc2_:Array = null;
         var _loc3_:uint = 0;
         var _loc6_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc12_:Object = null;
         var _loc13_:uint = 0;
         var _loc14_:Quest = null;
         var _loc15_:Array = null;
         var _loc16_:Object = null;
         var _loc17_:ObjectiveWrapper = null;
         var _loc18_:ItemWrapper = null;
         var _loc19_:EmoteWrapper = null;
         var _loc20_:JobWrapper = null;
         var _loc21_:Object = null;
         var _loc4_:uint = this._questStepsList.length;
         if(_loc4_ > 1)
         {
            _loc2_ = new Array();
            _loc3_ = 1;
            while(_loc3_ <= _loc4_)
            {
               _loc2_.push({
                  "label":this.uiApi.getText("ui.grimoire.quest.step") + " " + _loc3_,
                  "value":_loc3_
               });
               _loc3_ = _loc3_ + 1;
            }
            this.cbx_steps.dataProvider = _loc2_;
            this.cbx_steps.selectedIndex = this._currentIndexForStep;
            this.cbx_steps.visible = true;
            this.bgcbx_steps.visible = true;
            this.tx_bg_step.visible = true;
         }
         else
         {
            this.cbx_steps.visible = false;
            this.bgcbx_steps.visible = false;
            this.tx_bg_step.visible = false;
         }
         var _loc5_:QuestStep = this.dataApi.getQuestStep(this._displayedStep) as QuestStep;
         if(_loc5_.name == null || _loc5_.name == "")
         {
            _loc14_ = this.dataApi.getQuest(this._selectedQuest);
            this.lbl_stepName.text = _loc14_.name;
         }
         else
         {
            this.lbl_stepName.text = _loc5_.name;
         }
         if(this._questStepsList.indexOf(this._displayedStep) <= this._questStepsList.indexOf(this._currentStep))
         {
            this.txa_description.text = _loc5_.description;
            this.lbl_objectives.text = "";
            this.tx_dialog.visible = true;
            _loc15_ = new Array();
            for each(_loc16_ in _loc5_.objectives)
            {
               if(!param1)
               {
                  if(this._questInfos && this._questInfos.objectives[_loc16_.id] != undefined)
                  {
                     _loc17_ = ObjectiveWrapper.create(_loc16_.id,this._questInfos.objectives[_loc16_.id]);
                     if(this._questInfos.objectivesData[_loc16_.id] != null)
                     {
                        _loc17_.currentCompletion = this._questInfos.objectivesData[_loc16_.id].current;
                        _loc17_.maxCompletion = this._questInfos.objectivesData[_loc16_.id].max;
                     }
                     _loc15_.push(_loc17_);
                  }
               }
               else
               {
                  _loc15_.push(ObjectiveWrapper.create(_loc16_.id,false));
               }
            }
            this.gd_objectives.dataProvider = _loc15_;
         }
         else
         {
            this.txa_description.text = this.uiApi.getText("ui.grimoire.quest.descriptionNonAvailable");
            this.lbl_objectives.text = this.uiApi.getText("ui.grimoire.quest.objectivesNonAvailable");
            this.tx_dialog.visible = false;
            this.gd_objectives.dataProvider = new Array();
         }
         this._stepNpcMessage = _loc5_.dialog;
         if(this._stepNpcMessage == "")
         {
            this.tx_dialog.visible = false;
         }
         if(this.gd_objectives.dataProvider.length == 0 && this._questActiveList.length > 0)
         {
            this.lbl_objectives.text = this.uiApi.getText("ui.grimoire.quest.objectivesNonAvailable");
         }
         else
         {
            this.lbl_objectives.text = "";
         }
         if(_loc5_.kamasReward != 0)
         {
            _loc6_ = _loc5_.kamasReward + _loc5_.kamasReward * this.questApi.getAlmanaxQuestKamasBonusMultiplier(_loc5_.questId);
         }
         else
         {
            _loc6_ = 0;
         }
         var _loc7_:uint = _loc5_.experienceReward;
         if(_loc7_ != 0)
         {
            _loc8_ = _loc7_ + _loc7_ * this.questApi.getAlmanaxQuestXpBonusMultiplier(_loc5_.questId);
         }
         else
         {
            _loc8_ = 0;
         }
         this.formateRewardsLbl(_loc8_,_loc6_);
         this.clearSlots();
         this._iconRewards = new Array();
         this._rewards = new Array();
         var _loc11_:uint = 0;
         this.ctn_slots.x = _loc8_ > 0 || _loc6_ > 0?Number(this.uiApi.me().getConstant("reward_slot_with_xp_x")):Number(this.uiApi.me().getConstant("reward_slot_without_xp_x"));
         for each(_loc12_ in _loc5_.itemsReward)
         {
            this._rewards[_loc11_] = _loc12_[0];
            _loc18_ = this.dataApi.getItemWrapper(_loc12_[0],0,0,_loc12_[1]);
            this.displaySlot(this._aSlotsReward[_loc11_],_loc18_);
            this._iconRewards.push("item" + _loc18_.objectGID);
            this._itemRewardsDic["item" + _loc18_.objectGID] = _loc18_;
            _loc11_++;
         }
         for each(_loc13_ in _loc5_.emotesReward)
         {
            _loc19_ = this.dataApi.getEmoteWrapper(_loc13_);
            this.displaySlot(this._aSlotsReward[_loc11_],_loc19_);
            this._iconRewards.push(_loc19_.emote.name);
            _loc11_++;
         }
         for each(_loc13_ in _loc5_.jobsReward)
         {
            _loc20_ = this.dataApi.getJobWrapper(_loc13_);
            this.displaySlot(this._aSlotsReward[_loc11_],_loc20_);
            this._iconRewards.push(_loc20_.job.name);
            _loc11_++;
         }
         for each(_loc13_ in _loc5_.spellsReward)
         {
            _loc21_ = this.dataApi.getSpellWrapper(_loc13_);
            this.displaySlot(this._aSlotsReward[_loc11_],_loc21_);
            this._iconRewards.push(_loc21_.spell.name);
            _loc11_++;
         }
      }
      
      private function updateEmptyStep() : void
      {
         this.lbl_stepName.text = "";
         this.txa_description.text = "";
         this.tx_dialog.visible = false;
         this.gd_objectives.dataProvider = new Array();
         if(this._questActiveList.length > 0)
         {
            this.lbl_objectives.text = this.uiApi.getText("ui.grimoire.quest.objectivesNonAvailable");
         }
         this.formateRewardsLbl(0,0);
         this.clearSlots();
      }
      
      private function clearSlots() : void
      {
         var _loc1_:Slot = null;
         for each(_loc1_ in this._aSlotsReward)
         {
            _loc1_.data = null;
            _loc1_.buttonMode = false;
            _loc1_.visible = false;
         }
      }
      
      private function formateRewardsLbl(param1:uint, param2:uint) : void
      {
         var _loc3_:uint = 810;
         if(param2 > 0)
         {
            this.lbl_rewardsKama.visible = this.tx_rewardsKama.visible = true;
            this.lbl_rewardsKama.text = this.utilApi.formateIntToString(param2);
         }
         else
         {
            this.lbl_rewardsKama.visible = this.tx_rewardsKama.visible = false;
         }
         if(param1 > 0)
         {
            this.tx_rewardsXp.visible = this.lbl_rewardsXp.visible = true;
            this.lbl_rewardsXp.text = this.utilApi.formateIntToString(param1);
         }
         else
         {
            this.tx_rewardsXp.visible = this.lbl_rewardsXp.visible = false;
         }
      }
      
      private function displaySlot(param1:Slot, param2:Object) : void
      {
         param1.data = param2;
         param1.buttonMode = true;
         param1.visible = true;
      }
      
      private function showOrHideCategory(param1:uint, param2:uint = 0) : void
      {
         var _loc5_:* = false;
         var _loc6_:Object = null;
         this._closedCategories = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:Boolean = false;
         for each(_loc6_ in this._questsToShow)
         {
            if(_loc6_.isCategory)
            {
               _loc3_.push(_loc6_);
               if(_loc6_.id == param1)
               {
                  switch(param2)
                  {
                     case 0:
                        _loc5_ = !_loc6_.visible;
                        break;
                     case 1:
                        _loc5_ = true;
                        break;
                     case 2:
                        _loc5_ = false;
                  }
                  if(_loc5_ != _loc6_.visible)
                  {
                     _loc6_.visible = _loc5_;
                  }
                  else
                  {
                     return;
                  }
               }
               _loc4_ = _loc6_.visible;
               if(!_loc4_)
               {
                  this._closedCategories.push(_loc6_.id);
               }
            }
            else if(_loc4_)
            {
               _loc3_.push(_loc6_);
            }
         }
         this.sysApi.setData("closedQuestCategories",this._closedCategories);
         this.gd_quests.dataProvider = _loc3_;
      }
      
      private function isCatClosed(param1:int) : Boolean
      {
         if(this._forceOpenCategory && this._selectedQuestCategory == param1)
         {
            this._forceOpenCategory = false;
            return false;
         }
         if(!this._closedCategories || this._closedCategories.length == 0)
         {
            return false;
         }
         return this._closedCategories.indexOf(param1) > -1;
      }
      
      private function changeSearchOnName() : void
      {
         this._searchOnName = !this._searchOnName;
         Grimoire.getInstance().questSearchOnName = this._searchOnName;
         if(!this._searchOnName && !this._searchOnCategory)
         {
            this.inp_search.visible = false;
            this.tx_inputBg_search.disabled = true;
         }
         else
         {
            this.inp_search.visible = true;
            this.tx_inputBg_search.disabled = false;
         }
         if(this._searchCriteria && this._searchCriteria != "")
         {
            this.updateQuestGrid();
         }
      }
      
      private function changeSearchOnCategory() : void
      {
         this._searchOnCategory = !this._searchOnCategory;
         Grimoire.getInstance().questSearchOnCategory = this._searchOnCategory;
         if(!this._searchOnName && !this._searchOnCategory)
         {
            this.inp_search.visible = false;
            this.tx_inputBg_search.disabled = true;
         }
         else
         {
            this.inp_search.visible = true;
            this.tx_inputBg_search.disabled = false;
         }
         if(this._searchCriteria && this._searchCriteria != "")
         {
            this.updateQuestGrid();
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:QuestObjective = null;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         var _loc16_:MapPosition = null;
         var _loc17_:SubArea = null;
         var _loc18_:Array = null;
         if(param1.name.substr(0,7) == "btn_loc")
         {
            _loc3_ = this.modCartography.getFlags(this.mapApi.getCurrentWorldMap().id);
            _loc4_ = 0;
            _loc5_ = new Array();
            for each(_loc6_ in _loc3_)
            {
               if(_loc6_.id.indexOf("flag_srv" + CompassTypeEnum.COMPASS_TYPE_QUEST) == 0)
               {
                  _loc5_.push(_loc6_.id);
                  _loc4_++;
               }
            }
            if(_loc4_ > MAX_QUEST_FLAGS)
            {
               return;
            }
            _loc7_ = this._aSlotsObjective[param1];
            if(_loc7_)
            {
               _loc8_ = "flag_srv" + CompassTypeEnum.COMPASS_TYPE_QUEST + "_" + this._selectedQuest + "_" + _loc7_.id;
               if(_loc5_.indexOf(_loc8_) > -1)
               {
                  param1.selected = false;
               }
               else
               {
                  if(_loc4_ == MAX_QUEST_FLAGS)
                  {
                     return;
                  }
                  param1.selected = true;
               }
               _loc9_ = !!_loc7_.coords?Number(_loc7_.coords.x):Number(NaN);
               _loc10_ = !!_loc7_.coords?Number(_loc7_.coords.y):Number(NaN);
               _loc11_ = this.mapApi.getCurrentWorldMap().id;
               _loc13_ = this.uiApi.getText("ui.common.quests") + "\n" + this.chatApi.getStaticHyperlink(_loc7_.text);
               if(_loc7_.mapId)
               {
                  _loc16_ = this.mapApi.getMapPositionById(_loc7_.mapId);
                  _loc17_ = this.mapApi.getSubArea(_loc16_.subAreaId);
                  _loc14_ = _loc17_.entranceMapIds;
                  _loc15_ = _loc17_.exitMapIds;
                  _loc12_ = _loc17_.worldmap.id;
                  if(_loc11_ != _loc12_)
                  {
                     if(_loc11_ == 1)
                     {
                        if(_loc14_.length > 0)
                        {
                           _loc16_ = this.mapApi.getMapPositionById(_loc14_[0]);
                        }
                        else
                        {
                           _loc11_ = _loc12_;
                        }
                     }
                     else
                     {
                        _loc17_ = this.mapApi.getCurrentSubArea();
                        if(_loc15_.length > 0)
                        {
                           _loc16_ = this.mapApi.getMapPositionById(_loc15_[0]);
                        }
                        else
                        {
                           _loc11_ = _loc12_;
                        }
                     }
                  }
                  _loc9_ = _loc16_.posX;
                  _loc10_ = _loc16_.posY;
               }
               if(!isNaN(_loc9_) && !isNaN(_loc10_))
               {
                  _loc13_ = _loc13_ + (" (" + _loc9_ + "," + _loc10_ + ")");
                  this.sysApi.dispatchHook(AddMapFlag,_loc8_,_loc13_,_loc11_,_loc9_,_loc10_,6736896,true);
               }
            }
         }
         var _loc2_:int = 0;
         switch(param1)
         {
            case this.btn_tabComplete:
               if(this._bDescendingSort)
               {
                  this.gd_quests.sortOn("complete");
               }
               else
               {
                  this.gd_quests.sortOn("complete",Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabName:
               if(this._bDescendingSort)
               {
                  this.gd_quests.sortOn("name",Array.CASEINSENSITIVE);
               }
               else
               {
                  this.gd_quests.sortOn("name",Array.CASEINSENSITIVE | Array.DESCENDING);
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_showCompletedQuests:
               this.sysApi.setData("showCompletedQuest",this.btn_showCompletedQuests.selected);
               this._showCompletedQuest = this.btn_showCompletedQuests.selected;
               this.updateQuestGrid();
               break;
            case this.btn_close_ctr_itemBlock:
               if(this.ctr_itemBlock.visible)
               {
                  this.ctr_itemBlock.visible = false;
               }
               break;
            case this.btn_resetSearch:
               this._searchCriteria = null;
               this.inp_search.text = "";
               this.updateQuestGrid();
               break;
            case this.btn_searchFilter:
               _loc18_ = new Array();
               _loc18_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.search.criteria")));
               _loc18_.push(this.modContextMenu.createContextMenuItemObject(this._searchTextByCriteriaList["_searchOnName"],this.changeSearchOnName,null,false,null,this._searchOnName,false));
               _loc18_.push(this.modContextMenu.createContextMenuItemObject(this._searchTextByCriteriaList["_searchOnCategory"],this.changeSearchOnCategory,null,false,null,this._searchOnCategory,false));
               this.modContextMenu.createContextMenu(_loc18_);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         this.ctr_itemBlock.visible = false;
         switch(param1)
         {
            case this.gd_quests:
               this._isInit = true;
               _loc4_ = this.gd_quests.selectedItem;
               if(_loc4_.id != this._selectedQuest && !_loc4_.isCategory && param2 != SelectMethodEnum.AUTO && param2 != SelectMethodEnum.LEFT_ARROW && param2 != SelectMethodEnum.RIGHT_ARROW)
               {
                  this._selectedQuest = _loc4_.id;
                  this._selectedQuestCategory = this.dataApi.getQuest(this._selectedQuest).category.id;
                  this.selectQuest();
               }
               else if(_loc4_.isCategory && param2 != SelectMethodEnum.AUTO)
               {
                  this._selectedQuestCategory = _loc4_.id;
                  if(param2 == SelectMethodEnum.CLICK || param2 == SelectMethodEnum.DOUBLE_CLICK)
                  {
                     this.showOrHideCategory(_loc4_.id);
                  }
                  else if(_loc4_.isCategory)
                  {
                     this._selectedQuest = NaN;
                  }
               }
               this.gd_quests.dataProvider = this.gd_quests.dataProvider;
               break;
            case this.cbx_steps:
               if(this.cbx_steps.selectedIndex != this._currentIndexForStep)
               {
                  this._currentIndexForStep = this.cbx_steps.selectedIndex;
                  this._displayedStep = this._questStepsList[this.cbx_steps.selectedIndex];
                  this.updateStep(this.questApi.getCompletedQuests().indexOf(this._selectedQuest) != -1);
               }
         }
      }
      
      public function onShortCut(param1:String) : Boolean
      {
         if(!this.gd_quests.selectedItem.isCategory)
         {
            return false;
         }
         switch(param1)
         {
            case "leftArrow":
               this.showOrHideCategory(this.gd_quests.selectedItem.id,2);
               return true;
            case "rightArrow":
               this.showOrHideCategory(this.gd_quests.selectedItem.id,1);
               return true;
            default:
               return false;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Object = null;
         var _loc2_:int = this._aSlotsReward.indexOf(param1);
         if(_loc2_ != -1 && this._aSlotsReward[_loc2_].data != null)
         {
            _loc3_ = parseInt(param1.name.substr(10)) - 1;
            _loc4_ = this._iconRewards[_loc3_];
            if(_loc4_.indexOf("item") == 0)
            {
               this.uiApi.showTooltip(this._itemRewardsDic[_loc4_],param1,false,"standard",8,0,0,"itemName",null,{
                  "showEffects":true,
                  "header":true
               },"ItemInfo");
            }
            else
            {
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc4_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
            }
         }
         else if(param1 == this.tx_dialog)
         {
            if(this._stepNpcMessage != "")
            {
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this._stepNpcMessage),param1,false,"standard",3,5,3,null,null,null,"TextInfo");
            }
         }
         else if(!(param1.name.substr(0,8) == "questCtr" && !this._boostBtnList[param1.name].isCategory))
         {
            if(param1.name.substr(0,12) == "tx_questIcon")
            {
               _loc5_ = param1.uri.fileName;
               if(this.uiApi.me().getConstant("dungeon_icon").indexOf(_loc5_) != -1)
               {
                  _loc6_ = this.uiApi.getText("ui.common.dungeonQuest");
               }
               else if(this.uiApi.me().getConstant("party_icon").indexOf(_loc5_) != -1)
               {
                  _loc6_ = this.uiApi.getText("ui.common.partyQuest");
               }
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc6_),param1,false,"standard",3,5,3,null,null,null,"TextInfo");
            }
            else if(param1.name.indexOf("tx_infos") != -1)
            {
               _loc7_ = this._aObjectivesDialog[param1];
               if(_loc7_ != "")
               {
                  this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc7_),param1,false,"standard",3,5,3,null,null,null,"TextInfo");
               }
            }
            else if(param1.name.substr(0,7) == "btn_loc")
            {
               _loc8_ = 7;
               _loc9_ = 1;
               _loc10_ = this.uiApi.textTooltipInfo(this.uiApi.getText("ui.tooltip.questMarker"));
               this.uiApi.showTooltip(_loc10_,param1,false,"standard",_loc8_,_loc9_,3,null,null,null,"TextInfo");
            }
            else if(param1 == this.btn_searchFilter)
            {
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this.uiApi.getText("ui.search.criteria")),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
            }
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
         if(param1.name.substr(0,8) == "questCtr" && !this._boostBtnList[param1.name].isCategory)
         {
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc6_:Object = null;
         var _loc2_:int = this._aSlotsReward.indexOf(param1);
         if(_loc2_ == -1 || this._aSlotsReward[_loc2_].data == null)
         {
            return;
         }
         var _loc3_:int = parseInt(param1.name.substr(10)) - 1;
         var _loc4_:String = this._iconRewards[_loc3_];
         if(_loc4_.indexOf("item") != 0)
         {
            return;
         }
         var _loc5_:Object = this._itemRewardsDic[_loc4_];
         if(_loc5_)
         {
            _loc6_ = this.menuApi.create(_loc5_);
            if(_loc6_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc6_);
            }
         }
      }
      
      private function onUpdateQuestTab(param1:String = null, param2:Object = null) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Quest = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Object = null;
         if(param1 == "questTab" && param2 && param2.forceOpen)
         {
            _loc4_ = param2.quest as Quest;
            _loc6_ = this.gd_quests.dataProvider.length;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc3_ = this.gd_quests.dataProvider[_loc5_];
               if(!_loc3_.isCategory && _loc3_.id == _loc4_.id)
               {
                  this.gd_quests.selectedIndex = _loc5_;
                  return;
               }
               _loc5_++;
            }
            for each(_loc7_ in this._questsToShow)
            {
               if(!_loc7_.isCategory && _loc7_.id == _loc4_.id)
               {
                  this._selectedQuest = _loc4_.id;
                  this.showOrHideCategory(_loc4_.category.id);
                  return;
               }
            }
         }
      }
      
      public function onQuestListUpdated() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this._questActiveList = new Array();
         this._questCompletedList = new Array();
         var _loc1_:Boolean = false;
         for each(_loc2_ in this.questApi.getActiveQuests())
         {
            if(this._selectedQuest == _loc2_)
            {
               _loc1_ = true;
            }
            this._questActiveList.push({
               "id":_loc2_,
               "status":true
            });
         }
         for each(_loc3_ in this.questApi.getCompletedQuests())
         {
            if(this._selectedQuest == _loc3_)
            {
               _loc1_ = true;
            }
            this._questCompletedList.push({
               "id":_loc3_,
               "status":true
            });
         }
         if(!_loc1_ && this._questActiveList.length > 0)
         {
            this._selectedQuest = this._questActiveList[0].id;
         }
         this.updateQuestGrid();
      }
      
      public function onQuestInfosUpdated(param1:uint, param2:Boolean) : void
      {
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         this.sysApi.setData("lastQuestSelected",param1);
         if(param1 == this._selectedQuest)
         {
            this._questInfos = this.questApi.getQuestInformations(this._selectedQuest);
            this._questStepsList = new Array();
            _loc3_ = this.dataApi.getQuest(param1).stepIds;
            for(_loc4_ in _loc3_)
            {
               this._questStepsList.push(_loc3_[_loc4_]);
               if(param2 && _loc3_[_loc4_] == this._questInfos.stepId)
               {
                  this._currentIndexForStep = _loc4_;
               }
            }
            if(param2)
            {
               this._currentStep = this._displayedStep = this._questInfos.stepId;
            }
            else
            {
               this._currentIndexForStep = 0;
               this._displayedStep = _loc3_[0];
               this._currentStep = _loc3_[_loc3_.length - 1];
            }
            this.updateStep(this.questApi.getCompletedQuests().indexOf(param1) != -1);
         }
         else
         {
            this.updateEmptyStep();
         }
      }
      
      private function onFlagRemoved(param1:String, param2:int) : void
      {
         if(param1.indexOf("flag_srv" + CompassTypeEnum.COMPASS_TYPE_QUEST + "_" + this._selectedQuest) == 0)
         {
            this.updateStep();
         }
      }
      
      public function onTextureLoadFailed(param1:Object, param2:Boolean) : void
      {
         param1.uri = this.uiApi.createUri(this.sysApi.getConfigEntry("config.gfx.path.item.bitmap") + "error.png");
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this.inp_search.haveFocus)
         {
            this._lockSearchTimer.reset();
            this._lockSearchTimer.start();
         }
      }
      
      public function onTimeOut(param1:TimerEvent) : void
      {
         if(this.inp_search.text.length > 2)
         {
            this._searchCriteria = this.inp_search.text.toLowerCase();
            this.updateQuestGrid();
         }
         else
         {
            if(this._searchCriteria)
            {
               this._searchCriteria = null;
            }
            if(this.inp_search.text.length == 0)
            {
               this.updateQuestGrid();
            }
         }
      }
   }
}

class ObjectiveWrapper
{
    
   
   public var id:int;
   
   public var status:Boolean;
   
   public var currentCompletion:int = -1;
   
   public var maxCompletion:int = -1;
   
   function ObjectiveWrapper()
   {
      super();
   }
   
   public static function create(param1:int, param2:Boolean) : ObjectiveWrapper
   {
      var _loc3_:ObjectiveWrapper = new ObjectiveWrapper();
      _loc3_.id = param1;
      _loc3_.status = param2;
      return _loc3_;
   }
   
   public function addCompletion(param1:int, param2:int) : void
   {
      this.currentCompletion = param1;
      this.maxCompletion = param2;
   }
}
