package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.appearance.Ornament;
   import com.ankamagames.dofus.datacenter.appearance.Title;
   import com.ankamagames.dofus.datacenter.communication.Emoticon;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.quest.Achievement;
   import com.ankamagames.dofus.datacenter.quest.AchievementCategory;
   import com.ankamagames.dofus.datacenter.quest.AchievementObjective;
   import com.ankamagames.dofus.datacenter.quest.AchievementReward;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.internalDatacenter.appearance.OrnamentWrapper;
   import com.ankamagames.dofus.internalDatacenter.appearance.TitleWrapper;
   import com.ankamagames.dofus.internalDatacenter.communication.EmoteWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.network.types.game.achievement.AchievementRewardable;
   import com.ankamagames.dofus.network.types.game.guild.GuildMember;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.QuestApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import d2actions.AchievementDetailedListRequest;
   import d2actions.AchievementDetailsRequest;
   import d2actions.AchievementRewardRequest;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2hooks.AchievementDetailedList;
   import d2hooks.AchievementDetails;
   import d2hooks.AchievementFinished;
   import d2hooks.AchievementList;
   import d2hooks.AchievementRewardSuccess;
   import d2hooks.FocusChange;
   import d2hooks.GuildInformationsMemberUpdate;
   import d2hooks.KeyUp;
   import d2hooks.MouseShiftClick;
   import d2hooks.OpenBook;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   
   public class AchievementTab
   {
      
      private static var CTR_CAT_TYPE_CAT:String = "ctr_cat";
      
      private static var CTR_CAT_TYPE_SUBCAT:String = "ctr_subCat";
      
      private static var CTR_ACH_ACHIEVEMENT:String = "ctr_achievement";
      
      private static var CTR_ACH_OBJECTIVES:String = "ctr_objectives";
      
      private static var CTR_ACH_REWARDS:String = "ctr_rewards";
      
      private static var CTR_ACH_EMPTY:String = "ctr_empty";
      
      private static var GAUGE_WIDTH_OBJECTIVE:int;
      
      private static var GAUGE_WIDTH_CATEGORY:int;
      
      private static var GAUGE_WIDTH_TOTAL:int;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var tooltipApi:TooltipApi;
      
      public var dataApi:DataApi;
      
      public var utilApi:UtilApi;
      
      public var questApi:QuestApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var menuApi:ContextMenuApi;
      
      public var averagePricesApi:AveragePricesApi;
      
      public var socialApi:SocialApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private var _succesPoints:int;
      
      private var _totalSuccesPoints:int;
      
      private var _openCatIndex:int;
      
      private var _currentSelectedCatId:int;
      
      private var _selectedAchievementId:int;
      
      private var _selectedAndOpenedAchievementId:int;
      
      private var _myGuildXp:int;
      
      private var _hideAchievedAchievement:Boolean = true;
      
      private var _lockSearchTimer:Timer;
      
      private var _previousSearchCriteria:String;
      
      private var _categories:Array;
      
      private var _progressCategories:Array;
      
      private var _finishedAchievementsId:Array;
      
      private var _objectivesTextByAchievementId:Array;
      
      private var _searchCriteria:String;
      
      private var _colorTransform:ColorTransform;
      
      private var _textShadow:GlowFilter;
      
      private var _forceOpenAchievement:Boolean;
      
      private var _currentScrollValue:int;
      
      private var _catFinishedAchievements:Dictionary;
      
      private var _catProgressingAchievements:Dictionary;
      
      private var _catIlluBtnList:Dictionary;
      
      private var _catProgressBarList:Dictionary;
      
      private var _ctrAchPointsList:Dictionary;
      
      private var _ctrAchBtnsList:Dictionary;
      
      private var _ctrTxList:Dictionary;
      
      private var _rewardsListList:Dictionary;
      
      private var _btnsAcceptRewardList:Dictionary;
      
      private var _ctrObjectiveMetaList:Dictionary;
      
      private var _dataAchievements:Object;
      
      private var _dataCategories:Object;
      
      private var _progressPopupName:String;
      
      private var _searchSettimoutId:uint;
      
      private var _searchTextByCriteriaList:Dictionary;
      
      private var _searchResultByCriteriaList:Dictionary;
      
      private var _searchOnName:Boolean;
      
      private var _searchOnObjective:Boolean;
      
      private var _searchOnReward:Boolean;
      
      private var _checkedUri:Object;
      
      private var _uncheckedUri:Object;
      
      private var _focusOnSearch:Boolean = false;
      
      private var _opennedColor:int;
      
      private var _opennedAlpha:Number;
      
      private var _closedColor:int;
      
      private var _closedAlpha:Number;
      
      public var ctr_achievements:GraphicContainer;
      
      public var ctr_summary:GraphicContainer;
      
      public var ctr_globalProgress:GraphicContainer;
      
      public var gd_categories:Grid;
      
      public var gd_achievements:Grid;
      
      public var gd_summary:Grid;
      
      public var btn_closeSearch:ButtonContainer;
      
      public var btn_searchFilter:ButtonContainer;
      
      public var btn_hideCompletedAchievements:ButtonContainer;
      
      public var inp_search:Input;
      
      public var tx_inputBg_search:TextureBitmap;
      
      public var ctn_search:GraphicContainer;
      
      public var lbl_noAchievement:Label;
      
      public var lbl_myPoints:Label;
      
      public var lbl_titleProgress:Label;
      
      public var lbl_percent:Label;
      
      public var pb_progress:ProgressBar;
      
      public function AchievementTab()
      {
         this._categories = new Array();
         this._progressCategories = new Array();
         this._finishedAchievementsId = new Array();
         this._objectivesTextByAchievementId = new Array();
         this._colorTransform = new ColorTransform();
         this._catFinishedAchievements = new Dictionary(true);
         this._catProgressingAchievements = new Dictionary(true);
         this._catIlluBtnList = new Dictionary(true);
         this._catProgressBarList = new Dictionary(true);
         this._ctrAchPointsList = new Dictionary(true);
         this._ctrAchBtnsList = new Dictionary(true);
         this._ctrTxList = new Dictionary(true);
         this._rewardsListList = new Dictionary(true);
         this._btnsAcceptRewardList = new Dictionary(true);
         this._ctrObjectiveMetaList = new Dictionary(true);
         this._searchTextByCriteriaList = new Dictionary(true);
         this._searchResultByCriteriaList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:Achievement = null;
         var _loc3_:AchievementCategory = null;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         var _loc11_:GuildMember = null;
         var _loc12_:Number = NaN;
         var _loc13_:GuildMember = null;
         var _loc14_:AchievementCategory = null;
         this.sysApi.addHook(AchievementList,this.onAchievementList);
         this.sysApi.addHook(AchievementDetailedList,this.onAchievementDetailedList);
         this.sysApi.addHook(AchievementDetails,this.onAchievementDetails);
         this.sysApi.addHook(AchievementFinished,this.onAchievementFinished);
         this.sysApi.addHook(OpenBook,this.onOpenAchievement);
         this.sysApi.addHook(AchievementRewardSuccess,this.onAchievementRewardSuccess);
         this.sysApi.addHook(GuildInformationsMemberUpdate,this.onGuildInformationsMemberUpdate);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.sysApi.addHook(FocusChange,this.onFocusChange);
         this.uiApi.addComponentHook(this.gd_categories,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.btn_hideCompletedAchievements,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.lbl_myPoints,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_myPoints,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ctr_globalProgress,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_globalProgress,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_searchFilter,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_searchFilter,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_RELEASE);
         GAUGE_WIDTH_OBJECTIVE = int(this.uiApi.me().getConstant("gauge_width_objective"));
         GAUGE_WIDTH_CATEGORY = int(this.uiApi.me().getConstant("gauge_width_category"));
         GAUGE_WIDTH_TOTAL = int(this.uiApi.me().getConstant("gauge_width_total"));
         this._checkedUri = this.uiApi.createUri(this.uiApi.me().getConstant("tx_checked"));
         this._uncheckedUri = this.uiApi.createUri(this.uiApi.me().getConstant("tx_unchecked"));
         this._lockSearchTimer = new Timer(500,1);
         this._lockSearchTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
         this.btn_hideCompletedAchievements.selected = this._hideAchievedAchievement;
         this._searchOnName = Grimoire.getInstance().achievementSearchOnName;
         this._searchOnObjective = Grimoire.getInstance().achievementSearchOnObjective;
         this._searchOnReward = Grimoire.getInstance().achievementSearchOnReward;
         this.inp_search.text = this.uiApi.getText("ui.common.search.input");
         this._searchTextByCriteriaList["_searchOnName"] = this.uiApi.getText("ui.common.name");
         this._searchTextByCriteriaList["_searchOnObjective"] = this.uiApi.getText("ui.grimoire.quest.objectives");
         this._searchTextByCriteriaList["_searchOnReward"] = this.uiApi.getText("ui.grimoire.quest.rewards");
         this._dataAchievements = this.dataApi.getAchievements();
         for each(_loc2_ in this._dataAchievements)
         {
            this._totalSuccesPoints = this._totalSuccesPoints + _loc2_.points;
         }
         this._dataCategories = this.dataApi.getAchievementCategories();
         for each(_loc3_ in this._dataCategories)
         {
            if(_loc3_.parentId == 0)
            {
               this._categories.push({
                  "id":_loc3_.id,
                  "name":_loc3_.name,
                  "icon":_loc3_.icon,
                  "achievements":_loc3_.achievements,
                  "subcats":new Array(),
                  "color":_loc3_.color,
                  "order":_loc3_.order
               });
            }
         }
         this._categories.sortOn("order",Array.NUMERIC);
         this._categories.splice(0,0,{
            "id":0,
            "name":this.uiApi.getText("ui.achievement.synthesis"),
            "achievements":null,
            "subcats":null
         });
         for each(_loc5_ in this._categories)
         {
            _loc4_ = false;
            for each(_loc3_ in this._dataCategories)
            {
               if(_loc5_.id != 0 && _loc3_.parentId == _loc5_.id)
               {
                  _loc5_.subcats.push({
                     "id":_loc3_.id,
                     "name":_loc3_.name,
                     "parentId":_loc3_.parentId,
                     "achievements":_loc3_.achievements,
                     "order":_loc3_.order
                  });
                  _loc4_ = true;
               }
            }
            if(_loc4_)
            {
               _loc5_.name = _loc5_.name + " (+)";
            }
            if(_loc5_.id != 0)
            {
               _loc5_.subcats.sortOn("order",Array.NUMERIC);
            }
         }
         this.gd_categories.dataProvider = this._categories;
         if(this.socialApi.hasGuild())
         {
            _loc12_ = this.playerApi.id();
            for each(_loc13_ in this.socialApi.getGuildMembers())
            {
               if(_loc13_.id == _loc12_)
               {
                  _loc11_ = _loc13_;
                  break;
               }
            }
            this._myGuildXp = _loc11_.experienceGivenPercent;
         }
         this._hideAchievedAchievement = this.sysApi.getData("hideCompletedAchievements");
         this.btn_hideCompletedAchievements.selected = this._hideAchievedAchievement;
         this._textShadow = new GlowFilter(this.sysApi.getConfigEntry("colors.grid.bg"),1,11,11,4);
         this._finishedAchievementsId = Grimoire.getInstance().finishedAchievementsIds;
         this._objectivesTextByAchievementId = Grimoire.getInstance().objectivesTextByAchievement;
         var _loc6_:int = 0;
         var _loc7_:String = Grimoire.getInstance().lastAchievementSearchCriteria;
         var _loc8_:int = Grimoire.getInstance().lastAchievementOpenedId;
         var _loc9_:int = Grimoire.getInstance().lastAchievementCategoryOpenedId;
         var _loc10_:int = Grimoire.getInstance().lastAchievementScrollValue;
         if(param1 && param1.achievementId)
         {
            _loc6_ = param1.achievementId;
         }
         else if(_loc7_ && _loc7_ != "")
         {
            this._searchCriteria = _loc7_.toLowerCase();
            this.inp_search.text = this._searchCriteria;
            this._currentScrollValue = _loc10_;
            if(_loc8_ > 0)
            {
               this.sysApi.sendAction(new AchievementDetailsRequest(_loc8_));
               this._selectedAchievementId = _loc8_;
            }
            this.updateAchievementGrid(this._currentSelectedCatId);
         }
         else if(_loc8_ > 0)
         {
            _loc6_ = _loc8_;
         }
         else if(_loc9_ > 0)
         {
            this._currentScrollValue = _loc10_;
            _loc14_ = this.dataApi.getAchievementCategory(_loc9_);
            this.updateCategories(_loc14_,true);
         }
         if(_loc6_ > 0)
         {
            this._selectedAchievementId = _loc6_;
            this._forceOpenAchievement = true;
         }
         if(_loc6_ > 0 || _loc9_ > 0 || this._searchCriteria)
         {
            this.ctr_achievements.visible = true;
            this.ctr_summary.visible = false;
            this.ctn_search.y = this.uiApi.me().getConstant("search_y_in_state_1");
         }
         else
         {
            this.gd_categories.selectedIndex = 0;
            this.ctr_achievements.visible = false;
            this.ctr_summary.visible = true;
            this.ctn_search.y = this.uiApi.me().getConstant("search_y_in_state_0");
         }
         this.onAchievementList(this._finishedAchievementsId);
      }
      
      public function unload() : void
      {
         if(this._lockSearchTimer)
         {
            this._lockSearchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
            this._lockSearchTimer.stop();
            this._lockSearchTimer = null;
         }
         this.sysApi.setData("hideCompletedAchievements",this._hideAchievedAchievement);
         Grimoire.getInstance().lastAchievementSearchCriteria = this._searchCriteria;
         Grimoire.getInstance().lastAchievementCategoryOpenedId = this._currentSelectedCatId;
         Grimoire.getInstance().lastAchievementOpenedId = this._selectedAndOpenedAchievementId;
         Grimoire.getInstance().lastAchievementScrollValue = this.gd_achievements.verticalScrollValue;
      }
      
      public function updateSummary(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:String = null;
         if(!this._catIlluBtnList[param2.ctr_illu.name])
         {
            this.uiApi.addComponentHook(param2.ctr_illu,ComponentHookList.ON_RELEASE);
         }
         this._catIlluBtnList[param2.ctr_illu.name] = param1;
         if(!this._catProgressBarList[param2.ctr_progress.name])
         {
            this.uiApi.addComponentHook(param2.ctr_progress,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.ctr_progress,ComponentHookList.ON_ROLL_OUT);
         }
         this._catProgressBarList[param2.ctr_progress.name] = param1;
         if(param1)
         {
            _loc4_ = Math.floor(param1.value / param1.total * 100);
            if(_loc4_ > 100)
            {
               _loc4_ = 100;
            }
            param2.lbl_name.text = param1.name;
            param2.lbl_percent.text = _loc4_ + "%";
            _loc5_ = param1.icon.replace("cat_","");
            if(!_loc5_.length)
            {
               _loc5_ = "7";
            }
            param2.tx_illu.uri = this.uiApi.createUri(this.uiApi.me().getConstant("illusUi") + "success_illu_" + _loc5_ + ".png");
            param2.tx_icon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("success") + "success_" + param1.icon + ".png");
            param2.ctr_illu.handCursor = true;
            param2.pb_progress.value = _loc4_ / 100;
            param2.ctr_summary.visible = true;
         }
         else
         {
            param2.ctr_summary.visible = false;
         }
      }
      
      public function updateCategory(param1:*, param2:*, param3:Boolean, param4:uint) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         if(!this._catProgressBarList[param2.lbl_catPercent.name])
         {
            this.uiApi.addComponentHook(param2.lbl_catPercent,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.lbl_catPercent,ComponentHookList.ON_ROLL_OUT);
            this.uiApi.addComponentHook(param2.lbl_catPercent,ComponentHookList.ON_RELEASE);
         }
         this._catProgressBarList[param2.lbl_catPercent.name] = param1;
         switch(this.getCatLineType(param1,param4))
         {
            case CTR_CAT_TYPE_CAT:
               if(param1.icon)
               {
                  param2.tx_catIcon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("success") + "success_" + param1.icon + ".png");
               }
               else
               {
                  param2.tx_catIcon.uri = null;
               }
            case CTR_CAT_TYPE_SUBCAT:
               param2.lbl_catName.text = param1.name;
               _loc5_ = 0;
               _loc6_ = 0;
               if(param1.id > 0 && param1.achievements && param1.achievements.length > 0)
               {
                  for each(_loc7_ in param1.achievements)
                  {
                     if(_loc7_)
                     {
                        _loc6_++;
                        if(this._finishedAchievementsId.indexOf(_loc7_.id) != -1)
                        {
                           _loc5_++;
                        }
                     }
                  }
                  _loc8_ = Math.floor(_loc5_ / _loc6_ * 100);
                  param2.lbl_catPercent.text = _loc8_ + "%";
               }
               else
               {
                  param2.lbl_catPercent.text = "";
               }
               param2.btn_cat.selected = param3;
         }
      }
      
      public function getCatLineType(param1:*, param2:uint) : String
      {
         if(!param1)
         {
            return "";
         }
         switch(param2)
         {
            case 0:
               if(param1 && param1.hasOwnProperty("subcats"))
               {
                  return CTR_CAT_TYPE_CAT;
               }
               return CTR_CAT_TYPE_SUBCAT;
            default:
               return CTR_CAT_TYPE_SUBCAT;
         }
      }
      
      public function getCatDataLength(param1:*, param2:Boolean) : *
      {
         if(!param2)
         {
         }
         return 2 + (!!param2?param1.subcats.length:0);
      }
      
      public function updateAchievement(param1:*, param2:*, param3:Boolean, param4:uint) : void
      {
         var _loc5_:int = 0;
         var _loc6_:AchievementObjective = null;
         var _loc7_:Monster = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Boolean = false;
         var _loc11_:Object = null;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:Number = NaN;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:uint = 0;
         var _loc18_:ItemWrapper = null;
         var _loc19_:EmoteWrapper = null;
         var _loc20_:SpellWrapper = null;
         var _loc21_:TitleWrapper = null;
         var _loc22_:OrnamentWrapper = null;
         switch(this.getAchievementLineType(param1,param4))
         {
            case CTR_ACH_ACHIEVEMENT:
               if(!this._ctrAchPointsList[param2.ctr_achPoints.name])
               {
                  this.uiApi.addComponentHook(param2.ctr_achPoints,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.ctr_achPoints,ComponentHookList.ON_ROLL_OUT);
               }
               this._ctrAchPointsList[param2.ctr_achPoints.name] = param1;
               if(!this._ctrAchBtnsList[param2.btn_ach.name])
               {
                  this.uiApi.addComponentHook(param2.btn_ach,ComponentHookList.ON_RELEASE);
               }
               this._ctrAchBtnsList[param2.btn_ach.name] = param1;
               if(!this._ctrTxList[param2.tx_incompatibleIdols.name])
               {
                  this.uiApi.addComponentHook(param2.tx_incompatibleIdols,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.tx_incompatibleIdols,ComponentHookList.ON_ROLL_OUT);
               }
               for each(_loc5_ in param1.objectiveIds)
               {
                  _loc6_ = this.dataApi.getAchievementObjective(_loc5_);
                  if(_loc6_ && _loc6_.criterion.indexOf("Ei") != -1)
                  {
                     _loc7_ = this.dataApi.getMonsterFromId(_loc6_.criterion.split(",")[0].split(">")[1]);
                     if(_loc7_ && _loc7_.incompatibleIdols.length > 0)
                     {
                        this._ctrTxList[param2.tx_incompatibleIdols.name] = _loc7_;
                     }
                  }
               }
               param2.tx_incompatibleIdols.visible = _loc7_ && _loc7_.incompatibleIdols.length > 0;
               param2.btn_ach.handCursor = true;
               param2.lbl_name.text = param1.name;
               if(!param2.tx_incompatibleIdols.visible)
               {
                  param2.lbl_name.width = int(this.uiApi.me().getConstant("lbl_name_width"));
               }
               else
               {
                  param2.lbl_name.width = int(this.uiApi.me().getConstant("lbl_name_width_incompatibleIdols"));
               }
               if(this.sysApi.getPlayerManager().hasRights)
               {
                  param2.lbl_name.text = param2.lbl_name.text + (" (" + param1.id + ")");
               }
               param2.lbl_points.text = param1.points;
               param2.lbl_description.text = param1.description;
               param2.tx_icon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("achievementPath") + param1.iconId + ".png");
               if(this._catFinishedAchievements[param1.id] || this._finishedAchievementsId.indexOf(param1.id) != -1)
               {
                  param2.ctr_bg.bgColor = this.sysApi.getConfigEntry("colors.multigrid.selected");
               }
               else
               {
                  param2.ctr_bg.bgColor = this.sysApi.getConfigEntry("colors.multigrid.line");
               }
               break;
            case CTR_ACH_OBJECTIVES:
               this._selectedAndOpenedAchievementId = this._selectedAchievementId;
               if(this._catProgressingAchievements[this._selectedAchievementId])
               {
                  _loc8_ = this._catProgressingAchievements[this._selectedAchievementId];
               }
               else if(this._catFinishedAchievements[this._selectedAchievementId])
               {
                  _loc8_ = this._catFinishedAchievements[this._selectedAchievementId];
               }
               if(!_loc8_)
               {
                  break;
               }
               for each(_loc11_ in _loc8_.finishedObjective)
               {
                  if(_loc11_.id == param1.objectiveData.id)
                  {
                     _loc9_ = _loc11_;
                     _loc10_ = true;
                  }
               }
               if(!_loc10_)
               {
                  for each(_loc11_ in _loc8_.startedObjectives)
                  {
                     if(_loc11_.id == param1.objectiveData.id)
                     {
                        _loc9_ = _loc11_;
                     }
                  }
               }
               if(!_loc9_)
               {
                  break;
               }
               if(_loc9_.maxValue == 1)
               {
                  param2.lbl_objectiveBin.text = param1.objectiveData.name;
                  if(this.sysApi.getPlayerManager().hasRights)
                  {
                     param2.lbl_objectiveBin.text = param2.lbl_objectiveBin.text + (" (" + param1.objectiveData.id + ")");
                  }
                  if(_loc10_ || _loc9_.value == 1)
                  {
                     param2.tx_objectiveBin.uri = this._checkedUri;
                     param2.lbl_objectiveBin.alpha = 0.5;
                  }
                  else
                  {
                     param2.tx_objectiveBin.uri = this._uncheckedUri;
                     param2.lbl_objectiveBin.alpha = 1;
                  }
                  param2.ctr_objectiveBin.visible = true;
                  param2.ctr_objectiveProgress.visible = false;
                  if(param1.objectiveData.criterion.indexOf("OA") == 0)
                  {
                     if(!this._ctrObjectiveMetaList[param2.ctr_objectiveBin.name])
                     {
                        this.uiApi.addComponentHook(param2.ctr_objectiveBin,ComponentHookList.ON_ROLL_OVER);
                        this.uiApi.addComponentHook(param2.ctr_objectiveBin,ComponentHookList.ON_ROLL_OUT);
                        this.uiApi.addComponentHook(param2.ctr_objectiveBin,ComponentHookList.ON_RELEASE);
                     }
                     _loc13_ = int(param1.objectiveData.criterion.substr(3));
                     this._ctrObjectiveMetaList[param2.ctr_objectiveBin.name] = _loc13_;
                     param2.lbl_objectiveBin.text = param2.lbl_objectiveBin.text + (" " + this.uiApi.getText("ui.common.fakeLinkSee"));
                     param2.ctr_objectiveBin.handCursor = true;
                  }
                  else
                  {
                     param2.ctr_objectiveBin.handCursor = false;
                     this._ctrObjectiveMetaList[param2.ctr_objectiveBin.name] = 0;
                  }
               }
               else
               {
                  _loc15_ = _loc9_.maxValue;
                  if(_loc10_)
                  {
                     _loc14_ = _loc15_;
                  }
                  else
                  {
                     _loc14_ = _loc9_.value;
                  }
                  param2.lbl_objectiveProgress.text = _loc14_ + "/" + _loc15_;
                  param2.tx_objectiveProgress.value = _loc14_ / _loc15_;
                  param2.ctr_objectiveBin.visible = false;
                  param2.ctr_objectiveProgress.visible = true;
               }
               break;
            case CTR_ACH_REWARDS:
               param2.lbl_rewardsKama.text = this.utilApi.formateIntToString(param1.kamas);
               param2.lbl_rewardsXp.text = this.utilApi.formateIntToString(param1.xp);
               if(param1.rewardable)
               {
                  param2.btn_accept.visible = true;
               }
               else
               {
                  param2.btn_accept.visible = false;
               }
               _loc12_ = new Array();
               if(param1.rewardData)
               {
                  _loc16_ = 0;
                  while(_loc16_ < param1.rewardData.itemsReward.length)
                  {
                     _loc18_ = this.dataApi.getItemWrapper(param1.rewardData.itemsReward[_loc16_],0,0,param1.rewardData.itemsQuantityReward[_loc16_]);
                     _loc12_.push(_loc18_);
                     _loc16_++;
                  }
                  for each(_loc17_ in param1.rewardData.emotesReward)
                  {
                     _loc19_ = this.dataApi.getEmoteWrapper(_loc17_);
                     _loc12_.push(_loc19_);
                  }
                  for each(_loc17_ in param1.rewardData.spellsReward)
                  {
                     _loc20_ = this.dataApi.getSpellWrapper(_loc17_);
                     _loc12_.push(_loc20_);
                  }
                  for each(_loc17_ in param1.rewardData.titlesReward)
                  {
                     _loc21_ = this.dataApi.getTitleWrapper(_loc17_);
                     _loc12_.push(_loc21_);
                  }
                  for each(_loc17_ in param1.rewardData.ornamentsReward)
                  {
                     _loc22_ = this.dataApi.getOrnamentWrapper(_loc17_);
                     _loc12_.push(_loc22_);
                  }
               }
               param2.gd_rewards.dataProvider = _loc12_;
               if(!this._rewardsListList[param2.gd_rewards.name])
               {
                  this.uiApi.addComponentHook(param2.gd_rewards,ComponentHookList.ON_ITEM_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.gd_rewards,ComponentHookList.ON_ITEM_ROLL_OUT);
               }
               this._rewardsListList[param2.gd_rewards.name] = param1;
               if(!this._btnsAcceptRewardList[param2.btn_accept.name])
               {
                  this.uiApi.addComponentHook(param2.btn_accept,ComponentHookList.ON_RELEASE);
                  this.uiApi.addComponentHook(param2.btn_accept,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.btn_accept,ComponentHookList.ON_ROLL_OUT);
               }
               this._btnsAcceptRewardList[param2.btn_accept.name] = this._selectedAchievementId;
               break;
            case CTR_ACH_EMPTY:
         }
      }
      
      public function getAchievementLineType(param1:*, param2:uint) : String
      {
         if(!param1)
         {
            return "";
         }
         switch(param2)
         {
            case 0:
               if(param1 && param1.hasOwnProperty("rewardData"))
               {
                  return CTR_ACH_REWARDS;
               }
               if(param1 && param1.hasOwnProperty("objectiveData"))
               {
                  return CTR_ACH_OBJECTIVES;
               }
               if(param1 && param1.hasOwnProperty("empty"))
               {
                  return CTR_ACH_EMPTY;
               }
               return CTR_ACH_ACHIEVEMENT;
            default:
               return CTR_ACH_OBJECTIVES;
         }
      }
      
      public function getAchievementDataLength(param1:*, param2:Boolean) : *
      {
         return 1;
      }
      
      private function updateAchievementGrid(param1:int) : void
      {
         var _loc5_:Achievement = null;
         var _loc6_:AchievementCategory = null;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         var _loc9_:Object = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         var _loc15_:Object = null;
         var _loc16_:Object = null;
         var _loc17_:String = null;
         var _loc18_:String = null;
         var _loc19_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = new Array();
         this._selectedAndOpenedAchievementId = 0;
         if(!this._searchCriteria)
         {
            if(param1 == 0)
            {
               this.ctr_achievements.visible = false;
               this.ctr_summary.visible = true;
               this.ctn_search.y = this.uiApi.me().getConstant("search_y_in_state_0");
               this._selectedAchievementId = 0;
            }
            else
            {
               this.ctr_achievements.visible = true;
               this.ctr_summary.visible = false;
               this.ctn_search.y = this.uiApi.me().getConstant("search_y_in_state_1");
               _loc6_ = this.dataApi.getAchievementCategory(param1);
               _loc7_ = new Array();
               for each(_loc5_ in _loc6_.achievements)
               {
                  if(_loc5_)
                  {
                     if(!(this._hideAchievedAchievement && this._finishedAchievementsId.indexOf(_loc5_.id) > -1))
                     {
                        _loc7_.push(_loc5_);
                     }
                  }
               }
               _loc7_.sortOn("order",Array.NUMERIC);
               for each(_loc5_ in _loc7_)
               {
                  _loc4_.push(_loc5_);
                  _loc4_.push(null);
                  _loc4_.push(null);
                  _loc4_.push(null);
                  _loc4_.push(null);
                  _loc4_.push(null);
                  if(_loc5_.id == this._selectedAchievementId)
                  {
                     _loc3_ = _loc2_;
                     _loc4_ = _loc4_.concat(this.addObjectivesAndRewards(_loc5_,_loc6_));
                  }
                  _loc2_++;
                  _loc2_++;
                  _loc2_++;
                  _loc2_++;
                  _loc2_++;
                  _loc2_++;
               }
            }
         }
         else if(this._previousSearchCriteria != this._searchCriteria + "#" + this._searchOnName + "" + this._searchOnObjective + "" + this._searchOnReward)
         {
            _loc8_ = getTimer();
            _loc10_ = this.playerApi.getPlayedCharacterInfo().sex == 0?"nameMale":"nameFemale";
            _loc11_ = !!this._previousSearchCriteria?this._previousSearchCriteria.split("#"):[];
            if(this._searchCriteria != _loc11_[0])
            {
               _loc13_ = this.dataApi.queryUnion(this.dataApi.queryString(Achievement,"description",this._searchCriteria),this.dataApi.queryString(Achievement,"name",this._searchCriteria));
               _loc14_ = this.dataApi.queryEquals(Achievement,"objectiveIds",this.dataApi.queryString(AchievementObjective,"name",this._searchCriteria));
               _loc15_ = this.dataApi.queryEquals(Achievement,"rewardIds",this.dataApi.queryUnion(this.dataApi.queryEquals(AchievementReward,"itemsReward",this.dataApi.queryString(Item,"name",this._searchCriteria)),this.dataApi.queryEquals(AchievementReward,"emotesReward",this.dataApi.queryString(Emoticon,"name",this._searchCriteria)),this.dataApi.queryEquals(AchievementReward,"spellsReward",this.dataApi.queryString(Spell,"name",this._searchCriteria)),this.dataApi.queryEquals(AchievementReward,"titlesReward",this.dataApi.queryString(Title,_loc10_,this._searchCriteria)),this.dataApi.queryEquals(AchievementReward,"ornamentsReward",this.dataApi.queryString(Ornament,"name",this._searchCriteria))));
               this._searchResultByCriteriaList["_searchOnName"] = _loc13_;
               this._searchResultByCriteriaList["_searchOnObjective"] = _loc14_;
               this._searchResultByCriteriaList["_searchOnReward"] = _loc15_;
               if(_loc13_ || _loc14_ || _loc15_)
               {
                  this.sysApi.log(2,"Result : " + ((!!_loc13_?_loc13_.length:0) + (!!_loc14_?_loc14_.length:0) + (!!_loc15_?_loc15_.length:0)) + " in " + (getTimer() - _loc8_) + " ms");
               }
            }
            _loc12_ = "" + this._searchOnName + "" + this._searchOnObjective + "" + this._searchOnReward;
            switch(_loc12_)
            {
               case "truetruetrue":
                  _loc9_ = this.dataApi.queryReturnInstance(Achievement,this.dataApi.queryUnion(this._searchResultByCriteriaList["_searchOnName"],this._searchResultByCriteriaList["_searchOnObjective"],this._searchResultByCriteriaList["_searchOnReward"]));
                  break;
               case "truetruefalse":
                  _loc9_ = this.dataApi.queryReturnInstance(Achievement,this.dataApi.queryUnion(this._searchResultByCriteriaList["_searchOnName"],this._searchResultByCriteriaList["_searchOnObjective"]));
                  break;
               case "truefalsetrue":
                  _loc9_ = this.dataApi.queryReturnInstance(Achievement,this.dataApi.queryUnion(this._searchResultByCriteriaList["_searchOnName"],this._searchResultByCriteriaList["_searchOnReward"]));
                  break;
               case "truefalsefalse":
                  _loc9_ = this.dataApi.queryReturnInstance(Achievement,this._searchResultByCriteriaList["_searchOnName"]);
                  break;
               case "falsetruetrue":
                  _loc9_ = this.dataApi.queryReturnInstance(Achievement,this.dataApi.queryUnion(this._searchResultByCriteriaList["_searchOnObjective"],this._searchResultByCriteriaList["_searchOnReward"]));
                  break;
               case "falsetruefalse":
                  _loc9_ = this.dataApi.queryReturnInstance(Achievement,this._searchResultByCriteriaList["_searchOnObjective"]);
                  break;
               case "falsefalsetrue":
                  _loc9_ = this.dataApi.queryReturnInstance(Achievement,this._searchResultByCriteriaList["_searchOnReward"]);
                  break;
               case "falsefalsefalse":
                  this.gd_achievements.dataProvider = new Array();
                  this.lbl_noAchievement.visible = true;
                  this.lbl_noAchievement.text = this.uiApi.getText("ui.search.needCriterion");
                  this._previousSearchCriteria = this._searchCriteria + "#" + this._searchOnName + "" + this._searchOnObjective + "" + this._searchOnReward;
                  return;
            }
            for each(_loc5_ in _loc9_)
            {
               if(!(this._hideAchievedAchievement && this._finishedAchievementsId.indexOf(_loc5_.id) > -1))
               {
                  _loc4_.push(_loc5_);
                  _loc4_.push(null);
                  _loc4_.push(null);
                  _loc4_.push(null);
                  _loc4_.push(null);
                  _loc4_.push(null);
                  if(_loc5_.id == this._selectedAchievementId)
                  {
                     _loc4_ = _loc4_.concat(this.addObjectivesAndRewards(_loc5_,_loc5_.category));
                  }
               }
            }
         }
         else
         {
            for each(_loc16_ in this.gd_achievements.dataProvider)
            {
               if(_loc16_ && _loc16_ is Achievement)
               {
                  _loc4_.push(_loc16_);
                  _loc4_.push(null);
                  _loc4_.push(null);
                  _loc4_.push(null);
                  _loc4_.push(null);
                  _loc4_.push(null);
                  if(_loc16_.id == this._selectedAchievementId)
                  {
                     _loc3_ = _loc2_;
                     _loc4_ = _loc4_.concat(this.addObjectivesAndRewards(_loc16_ as Achievement,_loc16_.category));
                  }
                  _loc2_++;
                  _loc2_++;
                  _loc2_++;
                  _loc2_++;
                  _loc2_++;
                  _loc2_++;
               }
            }
         }
         this.gd_achievements.dataProvider = _loc4_;
         if(this._forceOpenAchievement)
         {
            this._forceOpenAchievement = false;
            this.gd_achievements.moveTo(_loc3_,true);
         }
         if(this._currentScrollValue != 0)
         {
            this.gd_achievements.verticalScrollValue = this._currentScrollValue;
         }
         if(_loc4_.length > 0)
         {
            this.lbl_noAchievement.visible = false;
         }
         else
         {
            this.lbl_noAchievement.visible = true;
            this.lbl_noAchievement.text = this.uiApi.getText("ui.search.noResult");
            if(this._searchCriteria)
            {
               _loc17_ = "";
               _loc18_ = "";
               for(_loc19_ in this._searchTextByCriteriaList)
               {
                  if(this[_loc19_])
                  {
                     _loc17_ = _loc17_ + (this._searchTextByCriteriaList[_loc19_] + ", ");
                  }
                  else if(this._searchResultByCriteriaList[_loc19_].length > 0)
                  {
                     _loc18_ = _loc18_ + (this._searchTextByCriteriaList[_loc19_] + ", ");
                  }
               }
               if(_loc17_.length > 0)
               {
                  _loc17_ = _loc17_.slice(0,-2);
               }
               if(_loc18_.length > 0)
               {
                  _loc18_ = _loc18_.slice(0,-2);
               }
               if(_loc18_.length == 0)
               {
                  this.lbl_noAchievement.text = this.uiApi.getText("ui.search.noResultFor",this._searchCriteria);
               }
               else
               {
                  this.lbl_noAchievement.text = this.uiApi.getText("ui.search.noResultsBut",_loc17_,_loc18_);
               }
            }
         }
         this._previousSearchCriteria = this._searchCriteria + "#" + this._searchOnName + "" + this._searchOnObjective + "" + this._searchOnReward;
      }
      
      private function addObjectivesAndRewards(param1:Achievement, param2:AchievementCategory) : Array
      {
         var _loc5_:int = 0;
         var _loc6_:AchievementObjective = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:AchievementObjective = null;
         var _loc12_:AchievementReward = null;
         var _loc13_:int = 0;
         var _loc14_:AchievementRewardable = null;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         for each(_loc5_ in param1.objectiveIds)
         {
            _loc11_ = this.dataApi.getAchievementObjective(_loc5_);
            if(_loc11_)
            {
               _loc4_.push(_loc11_);
            }
         }
         _loc4_.sortOn("order",Array.NUMERIC);
         if(_loc4_.length > 0)
         {
            _loc3_.push({"empty":true});
         }
         for each(_loc6_ in _loc4_)
         {
            if(param2.parentId == 0)
            {
               _loc3_.push({
                  "objectiveData":_loc6_,
                  "color":param2.color
               });
            }
            else
            {
               _loc3_.push({
                  "objectiveData":_loc6_,
                  "color":this.dataApi.getAchievementCategory(param2.parentId).color
               });
            }
            _loc3_.push(null);
         }
         if(_loc4_.length > 0)
         {
            _loc3_.push({"empty":true});
         }
         var _loc7_:Object = {
            "rewardData":null,
            "kamas":0,
            "xp":0,
            "rewardable":false
         };
         for each(_loc8_ in param1.rewardIds)
         {
            _loc12_ = this.dataApi.getAchievementReward(_loc8_);
            if(_loc12_)
            {
               _loc13_ = this.playerApi.getPlayedCharacterInfo().level;
               if((_loc12_.levelMin == -1 || _loc12_.levelMin <= _loc13_) && (_loc12_.levelMax >= _loc13_ || _loc12_.levelMax == -1))
               {
                  _loc7_.rewardData = _loc12_;
                  break;
               }
            }
         }
         if(this._finishedAchievementsId.indexOf(param1.id) != -1)
         {
            for each(_loc14_ in this.questApi.getRewardableAchievements())
            {
               if(_loc14_.id == param1.id)
               {
                  _loc9_ = _loc14_.finishedlevel;
                  _loc10_ = true;
                  break;
               }
            }
         }
         _loc7_.kamas = this.questApi.getAchievementKamasReward(param1,_loc9_);
         _loc7_.xp = this.questApi.getAchievementExperienceReward(param1,_loc9_);
         _loc7_.rewardable = _loc10_;
         _loc3_.push(_loc7_);
         _loc3_.push(null);
         _loc3_.push(null);
         _loc3_.push(null);
         _loc3_.push(null);
         _loc3_.push(null);
         return _loc3_;
      }
      
      private function updateCategories(param1:Object, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:Object = null;
         if(!param3)
         {
            if(param1.id > 0 && this._currentSelectedCatId != param1.id)
            {
               this.sysApi.sendAction(new AchievementDetailedListRequest(param1.id));
            }
            else
            {
               _loc4_ = true;
            }
            if(param1.parentId > 0 && this._openCatIndex == param1.parentId || this._openCatIndex == param1.id)
            {
               this._currentSelectedCatId = param1.id;
               for each(_loc11_ in this.gd_categories.dataProvider)
               {
                  if(_loc11_.id == this._currentSelectedCatId)
                  {
                     break;
                  }
                  _loc5_++;
               }
               if(this.gd_categories.selectedIndex != _loc5_)
               {
                  this.gd_categories.silent = true;
                  this.gd_categories.selectedIndex = _loc5_;
                  this.gd_categories.silent = false;
               }
               if(this._forceOpenAchievement && _loc4_)
               {
                  this.updateAchievementGrid(this._currentSelectedCatId);
               }
               if(this._openCatIndex != param1.id)
               {
                  return;
               }
            }
         }
         var _loc6_:int = param1.id;
         if(param1.parentId > 0)
         {
            _loc6_ = param1.parentId;
         }
         var _loc7_:int = -1;
         var _loc8_:Array = new Array();
         var _loc9_:int = -1;
         for each(_loc10_ in this._categories)
         {
            _loc8_.push(_loc10_);
            _loc7_++;
            if(_loc6_ == _loc10_.id)
            {
               _loc5_ = _loc7_;
               if(this._currentSelectedCatId != _loc10_.id || this._openCatIndex == 0 || param2)
               {
                  _loc9_ = _loc10_.id;
                  for each(_loc12_ in _loc10_.subcats)
                  {
                     _loc8_.push(_loc12_);
                     _loc7_++;
                     if(_loc12_.id == param1.id)
                     {
                        _loc5_ = _loc7_;
                     }
                  }
               }
            }
         }
         if(_loc9_ >= 0)
         {
            this._openCatIndex = _loc9_;
         }
         else
         {
            this._openCatIndex = 0;
         }
         if(!param3)
         {
            this._currentSelectedCatId = param1.id;
         }
         this.uiApi.hideTooltip();
         this.gd_categories.dataProvider = _loc8_;
         if(this.gd_categories.selectedIndex != _loc5_)
         {
            this.gd_categories.silent = true;
            this.gd_categories.selectedIndex = _loc5_;
            this.gd_categories.silent = false;
         }
         if(!param3 && this._currentSelectedCatId == 0)
         {
            this.updateAchievementGrid(this._currentSelectedCatId);
         }
      }
      
      private function updateGeneralInfo() : void
      {
         this.lbl_myPoints.text = this.utilApi.kamasToString(this._succesPoints,"");
         var _loc1_:Number = Math.floor(this._finishedAchievementsId.length / this._dataAchievements.length * 100);
         this.lbl_percent.text = _loc1_ + "%";
         this.pb_progress.value = _loc1_ / 100;
      }
      
      private function getMountPercentXp() : int
      {
         var _loc1_:int = 0;
         if(this.playerApi.getMount() != null && this.playerApi.isRidding() && this.playerApi.getMount().xpRatio > 0)
         {
            _loc1_ = this.playerApi.getMount().xpRatio;
         }
         return _loc1_;
      }
      
      private function changeSearchOnName() : void
      {
         this._searchOnName = !this._searchOnName;
         Grimoire.getInstance().achievementSearchOnName = this._searchOnName;
         if(!this._searchOnName && !this._searchOnObjective && !this._searchOnReward)
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
            this.updateAchievementGrid(this.gd_categories.selectedItem);
         }
      }
      
      private function changeSearchOnObjective() : void
      {
         this._searchOnObjective = !this._searchOnObjective;
         Grimoire.getInstance().achievementSearchOnObjective = this._searchOnObjective;
         if(!this._searchOnName && !this._searchOnObjective && !this._searchOnReward)
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
            this.updateAchievementGrid(this.gd_categories.selectedItem);
         }
      }
      
      private function changeSearchOnReward() : void
      {
         this._searchOnReward = !this._searchOnReward;
         Grimoire.getInstance().achievementSearchOnReward = this._searchOnReward;
         if(!this._searchOnName && !this._searchOnObjective && !this._searchOnReward)
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
            this.updateAchievementGrid(this.gd_categories.selectedItem);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.gd_categories)
         {
            if(param2 != GridItemSelectMethodEnum.AUTO)
            {
               this._searchCriteria = null;
               this.inp_search.text = this.uiApi.getText("ui.common.search.input");
               this._currentScrollValue = 0;
               this.updateCategories(param1.selectedItem);
            }
         }
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         if(param2.data && param1.name.indexOf("gd_rewards") != -1)
         {
            _loc3_ = param2.data;
            if(_loc3_ == null || !(_loc3_ is ItemWrapper))
            {
               return;
            }
            _loc4_ = this.menuApi.create(_loc3_);
            if(_loc4_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc4_);
            }
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(param2.data && param1.name.indexOf("gd_rewards") != -1)
         {
            _loc4_ = {
               "point":LocationEnum.POINT_BOTTOM,
               "relativePoint":LocationEnum.POINT_TOP
            };
            if(param2.data is ItemWrapper)
            {
               this.uiApi.showTooltip(param2.data,param1,false,"standard",8,0,0,"itemName",null,{
                  "showEffects":true,
                  "header":true
               },"ItemInfo");
               return;
            }
            if(param2.data is EmoteWrapper)
            {
               _loc3_ = this.uiApi.getText("ui.common.emote",param2.data.emote.name);
            }
            else if(param2.data is SpellWrapper)
            {
               _loc3_ = this.uiApi.getText("ui.common.spell",param2.data.spell.name);
            }
            else if(param2.data is TitleWrapper)
            {
               _loc3_ = this.uiApi.getText("ui.common.title",param2.data.title.name);
            }
            else if(param2.data is OrnamentWrapper)
            {
               _loc3_ = this.uiApi.getText("ui.common.ornament",param2.data.name);
            }
            if(_loc3_)
            {
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc3_),param1,false,"standard",_loc4_.point,_loc4_.relativePoint,3,null,null,null,"TextInfo");
            }
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:Achievement = null;
         var _loc5_:AchievementCategory = null;
         var _loc6_:int = 0;
         this._focusOnSearch = false;
         switch(param1)
         {
            case this.btn_closeSearch:
               this._searchCriteria = null;
               this.inp_search.text = this.uiApi.getText("ui.common.search.input");
               this.updateAchievementGrid(this.gd_categories.selectedItem.id);
               break;
            case this.btn_searchFilter:
               _loc2_ = new Array();
               _loc2_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.search.criteria")));
               _loc2_.push(this.modContextMenu.createContextMenuItemObject(this._searchTextByCriteriaList["_searchOnName"],this.changeSearchOnName,null,false,null,this._searchOnName,false));
               _loc2_.push(this.modContextMenu.createContextMenuItemObject(this._searchTextByCriteriaList["_searchOnObjective"],this.changeSearchOnObjective,null,false,null,this._searchOnObjective,false));
               _loc2_.push(this.modContextMenu.createContextMenuItemObject(this._searchTextByCriteriaList["_searchOnReward"],this.changeSearchOnReward,null,false,null,this._searchOnReward,false));
               this.modContextMenu.createContextMenu(_loc2_);
               break;
            case this.btn_hideCompletedAchievements:
               this._hideAchievedAchievement = this.btn_hideCompletedAchievements.selected;
               this.updateAchievementGrid(this.gd_categories.selectedItem.id);
               break;
            case this.inp_search:
               if(this.uiApi.getText("ui.common.search.input") == this.inp_search.text)
               {
                  this.inp_search.text = "";
               }
               this._focusOnSearch = true;
               break;
            default:
               if(param1)
               {
                  if(param1.name.indexOf("ctr_illu") != -1)
                  {
                     this._searchCriteria = null;
                     this.inp_search.text = "";
                     this.gd_categories.selectedIndex = this._catIlluBtnList[param1.name].order + 1;
                  }
                  else if(param1.name.indexOf("btn_ach") != -1)
                  {
                     if(this.uiApi.keyIsDown(Keyboard.SHIFT))
                     {
                        this.sysApi.dispatchHook(MouseShiftClick,{"data":this._ctrAchBtnsList[param1.name]});
                        break;
                     }
                     _loc3_ = this._ctrAchBtnsList[param1.name];
                     if(this._selectedAchievementId == 0 || this._selectedAchievementId != _loc3_.id)
                     {
                        this.gd_achievements.selectedItem = _loc3_;
                        this._selectedAchievementId = _loc3_.id;
                     }
                     else
                     {
                        this._selectedAchievementId = 0;
                     }
                     if(this._selectedAchievementId > 0 && !this._catProgressingAchievements[this._selectedAchievementId] && !this._catFinishedAchievements[this._selectedAchievementId])
                     {
                        this.sysApi.sendAction(new AchievementDetailsRequest(this._selectedAchievementId));
                     }
                     else
                     {
                        this.updateAchievementGrid(this.gd_categories.selectedItem.id);
                        if(this._searchCriteria != "" && this._searchCriteria != null && this._selectedAchievementId > 0)
                        {
                           _loc4_ = this.dataApi.getAchievement(this._selectedAchievementId);
                           _loc5_ = this.dataApi.getAchievementCategory(_loc4_.categoryId);
                           this.updateCategories(_loc5_,true,true);
                        }
                     }
                  }
                  else if(param1.name.indexOf("ctr_objectiveBin") != -1)
                  {
                     _loc6_ = this._ctrObjectiveMetaList[param1.name];
                     if(_loc6_ > 0)
                     {
                        this.uiApi.hideTooltip();
                        this.onOpenAchievement("achievementTab",{
                           "forceOpen":true,
                           "achievementId":_loc6_
                        });
                     }
                  }
                  else if(param1.name.indexOf("btn_accept") != -1)
                  {
                     this.uiApi.hideTooltip();
                     this.sysApi.sendAction(new AchievementRewardRequest(this._btnsAcceptRewardList[param1.name]));
                  }
               }
         }
         if(param1 != this.inp_search && this.inp_search && this.inp_search.text.length == 0)
         {
            this.inp_search.text = this.uiApi.getText("ui.common.search.input");
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:Achievement = null;
         var _loc7_:int = 0;
         var _loc8_:Monster = null;
         var _loc9_:String = null;
         var _loc10_:uint = 0;
         var _loc11_:Idol = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         switch(param1)
         {
            case this.lbl_myPoints:
               _loc4_ = this.utilApi.kamasToString(this._succesPoints,"") + " / " + this.utilApi.kamasToString(this._totalSuccesPoints,"");
               _loc2_ = this.uiApi.processText(this.uiApi.getText("ui.achievement.successPoints",_loc4_),"n",false);
               break;
            case this.ctr_globalProgress:
               _loc2_ = this._finishedAchievementsId.length + "/" + this._dataAchievements.length;
               break;
            case this.btn_searchFilter:
               _loc2_ = this.uiApi.getText("ui.search.criteria");
               break;
            default:
               if(param1.name.indexOf("ctr_achPoints") != -1)
               {
                  _loc2_ = this.uiApi.getText("ui.achievement.successPointsText");
               }
               else if(param1.name.indexOf("lbl_catPercent") != -1)
               {
                  if(this._catProgressBarList[param1.name] && this._catProgressBarList[param1.name].subcats && this._catProgressBarList[param1.name].subcats.length > 0)
                  {
                     _loc2_ = this.uiApi.getText("ui.achievement.noSubCategoryIncluded");
                  }
               }
               else if(param1.name.indexOf("ctr_objectiveBin") != -1)
               {
                  _loc5_ = this._ctrObjectiveMetaList[param1.name];
                  if(_loc5_ > 0)
                  {
                     _loc6_ = this.dataApi.getAchievement(_loc5_);
                     _loc2_ = _loc6_.description;
                  }
               }
               else if(param1.name.indexOf("ctr_progress") != -1)
               {
                  _loc2_ = this._catProgressBarList[param1.name].value + "/" + this._catProgressBarList[param1.name].total;
               }
               else if(param1.name.indexOf("btn_accept") != -1)
               {
                  _loc2_ = this.uiApi.getText("ui.achievement.rewardsGet");
                  _loc7_ = this.getMountPercentXp();
                  if(_loc7_)
                  {
                     _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.achievement.mountXpPercent",_loc7_));
                  }
                  if(this._myGuildXp)
                  {
                     _loc2_ = _loc2_ + ("\n" + this.uiApi.getText("ui.achievement.guildXpPercent",this._myGuildXp));
                  }
               }
               else if(param1.name.indexOf("tx_incompatibleIdols") != -1)
               {
                  _loc8_ = this._ctrTxList[param1.name];
                  _loc9_ = "";
                  for each(_loc10_ in _loc8_.incompatibleIdols)
                  {
                     _loc11_ = this.dataApi.getIdol(_loc10_);
                     if(_loc11_)
                     {
                        _loc9_ = _loc9_ + ("\n" + _loc11_.item.name);
                     }
                  }
                  _loc2_ = this.uiApi.getText("ui.idol.incompatibleIdols",_loc9_);
               }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onFocusChange(param1:Object) : void
      {
         if(param1 && param1 != this.inp_search && this._focusOnSearch)
         {
            this.onRelease(null);
         }
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
            this._currentScrollValue = 0;
            if(this._openCatIndex == 0)
            {
               this.ctr_achievements.visible = true;
               this.ctr_summary.visible = false;
               this.ctn_search.y = this.uiApi.me().getConstant("search_y_in_state_1");
            }
            this.updateAchievementGrid(this._currentSelectedCatId);
         }
         else
         {
            if(this._searchCriteria)
            {
               this._searchCriteria = null;
            }
            if(this.inp_search.text.length == 0)
            {
               this.updateAchievementGrid(this.gd_categories.selectedItem.id);
            }
         }
      }
      
      public function onParseObjectives(param1:int = 0) : void
      {
         Grimoire.getInstance().objectivesTextByAchievement = this._objectivesTextByAchievementId;
         this.updateAchievementGrid(this.gd_categories.selectedItem.id);
         this.onCancelSearch();
      }
      
      private function onCancelSearch() : void
      {
         clearTimeout(this._searchSettimoutId);
         if(this._progressPopupName)
         {
            this.uiApi.unloadUi(this._progressPopupName);
            this._progressPopupName = null;
         }
      }
      
      private function onAchievementList(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:AchievementCategory = null;
         var _loc6_:Achievement = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Achievement = null;
         this._progressCategories = new Array();
         this._finishedAchievementsId = new Array();
         var _loc4_:Array = new Array();
         this._succesPoints = 0;
         for each(_loc7_ in param1)
         {
            if(this._finishedAchievementsId.indexOf(_loc7_) == -1)
            {
               _loc9_ = this.dataApi.getAchievement(_loc7_);
               if(_loc9_)
               {
                  this._succesPoints = this._succesPoints + _loc9_.points;
               }
               this._finishedAchievementsId.push(_loc7_);
            }
         }
         for each(_loc5_ in this._dataCategories)
         {
            if(_loc5_.parentId > 0)
            {
               if(!_loc4_[_loc5_.parentId])
               {
                  _loc4_[_loc5_.parentId] = {
                     "value":0,
                     "total":0
                  };
               }
               _loc3_ = 0;
               _loc2_ = 0;
               for each(_loc6_ in _loc5_.achievements)
               {
                  if(_loc6_)
                  {
                     if(this._finishedAchievementsId.indexOf(_loc6_.id) != -1)
                     {
                        _loc2_++;
                     }
                     _loc3_++;
                  }
               }
               _loc4_[_loc5_.parentId] = {
                  "value":_loc4_[_loc5_.parentId].value + _loc2_,
                  "total":_loc4_[_loc5_.parentId].total + _loc3_
               };
            }
         }
         for each(_loc5_ in this._dataCategories)
         {
            if(_loc5_.parentId == 0)
            {
               if(!_loc4_[_loc5_.id])
               {
                  _loc4_[_loc5_.id] = {
                     "value":0,
                     "total":0
                  };
               }
               _loc8_ = 0;
               _loc3_ = 0;
               _loc2_ = 0;
               for each(_loc6_ in _loc5_.achievements)
               {
                  if(_loc6_)
                  {
                     if(this._finishedAchievementsId.indexOf(_loc6_.id) != -1)
                     {
                        _loc2_++;
                     }
                     _loc3_++;
                  }
               }
               if(_loc4_[_loc5_.id])
               {
                  _loc2_ = _loc2_ + _loc4_[_loc5_.id].value;
                  _loc8_ = _loc3_ + _loc4_[_loc5_.id].total;
               }
               this._progressCategories.push({
                  "id":_loc5_.id,
                  "name":_loc5_.name,
                  "value":_loc2_,
                  "total":_loc8_,
                  "color":_loc5_.color,
                  "icon":_loc5_.icon,
                  "order":_loc5_.order
               });
            }
         }
         this._progressCategories.sortOn("order",Array.NUMERIC);
         this.gd_summary.dataProvider = this._progressCategories;
         this.updateGeneralInfo();
         if(this._forceOpenAchievement)
         {
            this.onOpenAchievement("achievementTab",{
               "forceOpen":true,
               "achievementId":this._selectedAchievementId
            });
         }
      }
      
      private function onAchievementFinished(param1:int) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Achievement = this.dataApi.getAchievement(param1);
         if(_loc3_)
         {
            this._succesPoints = this._succesPoints + _loc3_.points;
         }
         var _loc4_:AchievementCategory = this.dataApi.getAchievementCategory(_loc3_.categoryId);
         for each(_loc2_ in this._progressCategories)
         {
            if(_loc2_.id == _loc4_.id || _loc2_.id == _loc4_.parentId)
            {
               _loc2_.value = _loc2_.value + 1;
            }
         }
         this.gd_summary.dataProvider = this._progressCategories;
         this._finishedAchievementsId.push(param1);
         this.updateGeneralInfo();
      }
      
      private function onAchievementDetailedList(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = null;
         for each(_loc3_ in param1)
         {
            this._catFinishedAchievements[_loc3_.id] = _loc3_;
            this._catProgressingAchievements[_loc3_.id] = null;
         }
         for each(_loc3_ in param2)
         {
            this._catProgressingAchievements[_loc3_.id] = _loc3_;
            this._catFinishedAchievements[_loc3_.id] = null;
         }
         this.updateAchievementGrid(this._currentSelectedCatId);
      }
      
      private function onAchievementDetails(param1:Object) : void
      {
         if(this._finishedAchievementsId.indexOf(param1.id) == -1)
         {
            this._catProgressingAchievements[param1.id] = param1;
            this._catFinishedAchievements[param1.id] = null;
         }
         else
         {
            this._catFinishedAchievements[param1.id] = param1;
            this._catProgressingAchievements[param1.id] = null;
         }
         this.updateAchievementGrid(this._currentSelectedCatId);
         var _loc2_:Achievement = this.dataApi.getAchievement(param1.id);
         var _loc3_:AchievementCategory = this.dataApi.getAchievementCategory(_loc2_.categoryId);
         this.updateCategories(_loc3_,true,true);
      }
      
      private function onAchievementRewardSuccess(param1:int) : void
      {
         this.updateAchievementGrid(this._currentSelectedCatId);
      }
      
      public function onGuildInformationsMemberUpdate(param1:Object) : void
      {
         if(param1.id == this.playerApi.id())
         {
            this._myGuildXp = param1.experienceGivenPercent;
         }
      }
      
      private function onOpenAchievement(param1:String = null, param2:Object = null) : void
      {
         var _loc3_:Achievement = null;
         var _loc4_:AchievementCategory = null;
         if(param1 == "achievementTab" && param2 && param2.forceOpen)
         {
            this._selectedAchievementId = param2.achievementId;
            this.ctr_achievements.visible = true;
            this.ctr_summary.visible = false;
            this._forceOpenAchievement = true;
            this.ctn_search.y = this.uiApi.me().getConstant("search_y_in_state_1");
            this._searchCriteria = null;
            this.inp_search.text = "";
            if(this._finishedAchievementsId.indexOf(this._selectedAchievementId) != -1 && this._hideAchievedAchievement == true)
            {
               this._hideAchievedAchievement = false;
               this.btn_hideCompletedAchievements.selected = false;
            }
            _loc3_ = this.dataApi.getAchievement(this._selectedAchievementId);
            _loc4_ = this.dataApi.getAchievementCategory(_loc3_.categoryId);
            this.updateCategories(_loc4_,true);
         }
      }
   }
}
