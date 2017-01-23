package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.internalDatacenter.dare.DareWrapper;
   import com.ankamagames.dofus.internalDatacenter.fight.ChallengeWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TimeApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.tooltip.LocationEnum;
   import d2actions.DareCancelRequest;
   import d2actions.DareInformationsRequest;
   import d2actions.DareSubscribeRequest;
   import d2enums.ComponentHookList;
   import d2enums.DareCriteriaTypeEnum;
   import d2enums.DareSubscribeErrorEnum;
   import d2hooks.DareListUpdated;
   import d2hooks.DareUpdated;
   import d2hooks.KeyUp;
   import d2hooks.MouseShiftClick;
   import d2hooks.OpenDareSearch;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class DareList
   {
      
      private static var _onlyShowIfSubscribable:Boolean = true;
      
      private static var _onlyShowIfFightable:Boolean = true;
      
      private static var CTR_GRID_DARE:String = "ctr_dare";
      
      private static var CTR_GRID_DETAILS:String = "ctr_details";
      
      public static const SEARCH_FILTER_ID:String = "searchFilterId";
      
      public static const SEARCH_FILTER_CREATOR:String = "searchFilterCreator";
      
      public static const SEARCH_FILTER_MONSTER:String = "searchFilterMonster";
      
      public static const SEARCH_FILTER_CRITERIA:String = "searchFilterCriteria";
      
      public static const SEARCH_FILTER_SUBAREA:String = "searchFilterSubArea";
      
      public static const SEARCH_FILTER_GUILD:String = "searchFilterGuild";
      
      public static const SEARCH_FILTER_ALLIANCE:String = "searchFilterAlliance";
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var utilApi:UtilApi;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var timeApi:TimeApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private const DARE_COMPLETE_LIST:int = 0;
      
      private const DARE_CREATION_LIST:int = 2;
      
      private const DARE_SUBSCRIBE_LIST:int = 3;
      
      private var _emblemsPath:String;
      
      private var _criteriaTypePath:String;
      
      private var _monsterSpritePath:String;
      
      private var _breedUri:String;
      
      private var _criteriaCtrY:int;
      
      private var _criteriaListLineX:int;
      
      private var _detailsRightCtrMinY:int;
      
      private var _propertyNameSort:String = "";
      
      private var _bDescendingSort:Boolean = false;
      
      private var _lockSearchTimer:Timer;
      
      private var _previousSearchCriteria:String;
      
      private var _searchCriteria:String;
      
      private var _searchFilterTexts:Dictionary;
      
      private var _searchFilterStates:Dictionary;
      
      private var _searchFilterStatesForced:Dictionary;
      
      private var _componentsList:Dictionary;
      
      private var _currentListType:int;
      
      private var _selectedDare:DareWrapper;
      
      private var _popupDareId:Number;
      
      private var _currentScrollValue:int;
      
      private var _currentDaresList:Array;
      
      private var _hiddenDaresIds:Dictionary;
      
      private var _breedGfxIdById:Array;
      
      public var lbl_noResult:Label;
      
      public var gd_list:Grid;
      
      public var btn_onlyShowIfSubscribable:ButtonContainer;
      
      public var btn_onlyShowIfFightable:ButtonContainer;
      
      public var lbl_daresCount:Label;
      
      public var inp_search:Input;
      
      public var tx_inputBg:Texture;
      
      public var btn_resetSearch:ButtonContainer;
      
      public var btn_searchFilter:ButtonContainer;
      
      public var btn_tabMonster:ButtonContainer;
      
      public var btn_tabJackpot:ButtonContainer;
      
      public var btn_tabFee:ButtonContainer;
      
      public var btn_tabWinners:ButtonContainer;
      
      public var btn_tabDuration:ButtonContainer;
      
      public function DareList()
      {
         this._searchFilterTexts = new Dictionary(true);
         this._componentsList = new Dictionary(true);
         this._hiddenDaresIds = new Dictionary(true);
         super();
      }
      
      public function main(... rest) : void
      {
         var _loc3_:Breed = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Number = NaN;
         this.sysApi.addHook(DareListUpdated,this.onDareListUpdated);
         this.sysApi.addHook(DareUpdated,this.onDareUpdated);
         this.sysApi.addHook(OpenDareSearch,this.onOpenDareSearch);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.uiApi.addComponentHook(this.btn_onlyShowIfSubscribable,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_onlyShowIfFightable,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.gd_list,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.btn_searchFilter,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_searchFilter,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_onlyShowIfSubscribable,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_onlyShowIfSubscribable,ComponentHookList.ON_ROLL_OUT);
         this._emblemsPath = this.uiApi.me().getConstant("emblems_uri");
         this._criteriaTypePath = this.uiApi.me().getConstant("criteriaType_uri");
         this._monsterSpritePath = this.uiApi.me().getConstant("monsterSprite_uri");
         this._breedUri = this.uiApi.me().getConstant("heads_uri");
         this._criteriaCtrY = this.uiApi.me().getConstant("criteriaCtrY");
         this._criteriaListLineX = this.uiApi.me().getConstant("criteriaListLineX");
         this._detailsRightCtrMinY = this.uiApi.me().getConstant("detailsRightCtrY");
         this._lockSearchTimer = new Timer(500,1);
         this._lockSearchTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
         this._searchFilterTexts[SEARCH_FILTER_ID] = this.uiApi.getText("ui.dare.id");
         this._searchFilterTexts[SEARCH_FILTER_CREATOR] = this.uiApi.getText("ui.dare.creator");
         this._searchFilterTexts[SEARCH_FILTER_MONSTER] = this.uiApi.getText("ui.dare.target");
         this._searchFilterTexts[SEARCH_FILTER_CRITERIA] = this.uiApi.getText("ui.dare.criteria");
         this._searchFilterTexts[SEARCH_FILTER_SUBAREA] = this.uiApi.getText("ui.map.subarea");
         this._searchFilterTexts[SEARCH_FILTER_GUILD] = this.uiApi.getText("ui.common.guild");
         this._searchFilterTexts[SEARCH_FILTER_ALLIANCE] = this.uiApi.getText("ui.common.alliance");
         this._searchFilterStates = Dare.getInstance().searchFilterStates;
         this._propertyNameSort = "jackpot";
         this.btn_onlyShowIfSubscribable.selected = _onlyShowIfSubscribable;
         this.btn_onlyShowIfFightable.selected = _onlyShowIfFightable;
         this._breedGfxIdById = new Array();
         var _loc2_:Object = this.dataApi.getBreeds();
         for each(_loc3_ in _loc2_)
         {
            this._breedGfxIdById[_loc3_.id] = _loc3_.id + "" + _loc3_.id % 2;
         }
         this._currentListType = rest[0][0];
         _loc4_ = this.sysApi.getData("HiddenDaresIds");
         for each(_loc5_ in _loc4_)
         {
            _loc6_ = Number(_loc5_.split("_")[0]);
            this._hiddenDaresIds[_loc6_] = true;
         }
         if(rest[0][1])
         {
            this.onOpenDareSearch(rest[0][1][0],rest[0][1][1],false);
         }
         this.onDareListUpdated();
      }
      
      public function unload() : void
      {
         if(this._lockSearchTimer)
         {
            this._lockSearchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
            this._lockSearchTimer.stop();
            this._lockSearchTimer = null;
         }
      }
      
      public function updateDareLine(param1:*, param2:*, param3:Boolean, param4:uint) : void
      {
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:Date = null;
         var _loc8_:EmblemWrapper = null;
         var _loc9_:EmblemWrapper = null;
         var _loc10_:EmblemSymbol = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         _loc7_ = new Date();
         if(!this._componentsList[param2.lbl_duration.name])
         {
            this.uiApi.addComponentHook(param2.lbl_duration,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.lbl_duration,ComponentHookList.ON_ROLL_OUT);
         }
         this._componentsList[param2.lbl_duration.name] = param1;
         if(!this._componentsList[param2.ctr_guildalliance.name])
         {
            this.uiApi.addComponentHook(param2.ctr_guildalliance,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.ctr_guildalliance,ComponentHookList.ON_ROLL_OUT);
            this.uiApi.addComponentHook(param2.ctr_guildalliance,ComponentHookList.ON_RELEASE);
         }
         this._componentsList[param2.ctr_guildalliance.name] = param1;
         if(!this._componentsList[param2.btn_visible.name])
         {
            this.uiApi.addComponentHook(param2.btn_visible,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_visible,ComponentHookList.ON_ROLL_OUT);
            this.uiApi.addComponentHook(param2.btn_visible,ComponentHookList.ON_RELEASE);
         }
         this._componentsList[param2.btn_visible.name] = param1;
         if(!this._componentsList[param2.ctr_dareLine.name])
         {
            this.uiApi.addComponentHook(param2.ctr_dareLine,ComponentHookList.ON_RELEASE);
         }
         this._componentsList[param2.ctr_dareLine.name] = param1;
         if(!this._componentsList[param2.gd_criteriaTxList.name])
         {
            this.uiApi.addComponentHook(param2.gd_criteriaTxList,ComponentHookList.ON_RELEASE);
         }
         this._componentsList[param2.gd_criteriaTxList.name] = param1;
         param2.ctr_dareLine.handCursor = true;
         param2.tx_sprite.uri = this.uiApi.createUri(this._monsterSpritePath + param1.monster.id + ".png");
         param2.lbl_monster.text = param1.monster.name;
         param2.lbl_jackpot.text = param1.jackpotString;
         param2.lbl_fee.text = param1.subscriptionFeeString;
         param2.tx_k1.visible = true;
         param2.tx_k2.visible = true;
         if(param1.won)
         {
            param2.ctr_bg.bgColor = this.sysApi.getConfigEntry("colors.multigrid.selected");
         }
         else
         {
            param2.ctr_bg.bgColor = this.sysApi.getConfigEntry("colors.multigrid.line");
         }
         if(param1.maxCountWinners > 0)
         {
            param2.lbl_winners.text = param1.countWinners + " / " + param1.maxCountWinners;
         }
         else
         {
            param2.lbl_winners.text = param1.countWinners;
         }
         if(param1.endDate > _loc7_.time)
         {
            param2.lbl_duration.text = this.timeApi.getShortDuration(param1.endDate - (param1.startDate > _loc7_.time?param1.startDate:_loc7_.time));
         }
         else
         {
            param2.lbl_duration.text = this.uiApi.getText("ui.dare.time.over");
         }
         if(!this._hiddenDaresIds[param1.dareId])
         {
            param2.btn_visible.selected = false;
         }
         else
         {
            param2.btn_visible.selected = true;
         }
         if(param1.alliance || param1.guild)
         {
            if(param1.allianceId > 0)
            {
               _loc8_ = param1.alliance.backEmblem;
               _loc9_ = param1.alliance.upEmblem;
            }
            else
            {
               _loc8_ = param1.guild.backEmblem;
               _loc9_ = param1.guild.upEmblem;
            }
            param2.tx_emblemBack.uri = _loc8_.iconUri;
            param2.tx_emblemUp.uri = _loc9_.iconUri;
            this.utilApi.changeColor(param2.tx_emblemBack,_loc8_.color,1);
            _loc10_ = this.dataApi.getEmblemSymbol(_loc9_.idEmblem);
            if(_loc10_.colorizable)
            {
               this.utilApi.changeColor(param2.tx_emblemUp,_loc9_.color,0);
            }
            else
            {
               this.utilApi.changeColor(param2.tx_emblemUp,_loc9_.color,0,true);
            }
            param2.ctr_guildalliance.x = this._criteriaListLineX;
            param2.ctr_guildalliance.visible = true;
            param2.gd_criteriaTxList.x = this._criteriaListLineX + param2.ctr_guildalliance.width;
         }
         else
         {
            param2.ctr_guildalliance.visible = false;
            param2.gd_criteriaTxList.x = this._criteriaListLineX;
         }
         _loc5_ = new Array();
         for each(_loc6_ in param1.criteria)
         {
            _loc5_.push(_loc6_);
         }
         if(_loc5_.length > 1)
         {
            param2.gd_criteriaTxList.dataProvider = _loc5_.slice(1);
            param2.gd_criteriaTxList.visible = true;
         }
         else
         {
            param2.gd_criteriaTxList.visible = false;
         }
         switch(this.getDareLineType(param1,param4))
         {
            case CTR_GRID_DETAILS:
               if(!this._componentsList[param2.tx_private.name])
               {
                  this.uiApi.addComponentHook(param2.tx_private,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.tx_private,ComponentHookList.ON_ROLL_OUT);
               }
               this._componentsList[param2.tx_private.name] = param1;
               if(!this._componentsList[param2.btn_subscribe.name])
               {
                  this.uiApi.addComponentHook(param2.btn_subscribe,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.btn_subscribe,ComponentHookList.ON_ROLL_OUT);
               }
               this._componentsList[param2.btn_subscribe.name] = param1;
               if(!this._componentsList[param2.btn_web.name])
               {
                  this.uiApi.addComponentHook(param2.btn_web,ComponentHookList.ON_RELEASE);
                  this.uiApi.addComponentHook(param2.btn_web,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.btn_web,ComponentHookList.ON_ROLL_OUT);
               }
               this._componentsList[param2.btn_web.name] = param1;
               if(!this._componentsList[param2.lbl_realDuration.name])
               {
                  this.uiApi.addComponentHook(param2.lbl_realDuration,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.lbl_realDuration,ComponentHookList.ON_ROLL_OUT);
               }
               this._componentsList[param2.lbl_realDuration.name] = param1;
               param2.lbl_creator.text = this.uiApi.getText("ui.dare.createdBy","{player," + param1.creatorName + "," + param1.creatorId + "::" + param1.creatorName + "}");
               if(param1.isPrivate)
               {
                  param2.tx_private.visible = true;
               }
               else
               {
                  param2.tx_private.visible = false;
               }
               if(param1.isMyCreation)
               {
                  param2.btn_lbl_btn_subscribe.text = this.uiApi.getText("ui.popup.delete");
                  if(param1.countEntrants == 0)
                  {
                     param2.btn_subscribe.softDisabled = false;
                  }
                  else
                  {
                     param2.btn_subscribe.softDisabled = true;
                  }
               }
               else if(param1.subscribed)
               {
                  param2.btn_lbl_btn_subscribe.text = this.uiApi.getText("ui.dare.unregister");
                  if(!param1.won)
                  {
                     param2.btn_subscribe.softDisabled = false;
                  }
                  else
                  {
                     param2.btn_subscribe.softDisabled = true;
                  }
               }
               else
               {
                  param2.btn_lbl_btn_subscribe.text = this.uiApi.getText("ui.dare.register");
                  if(param1.subscribable)
                  {
                     param2.btn_subscribe.softDisabled = false;
                  }
                  else
                  {
                     param2.btn_subscribe.softDisabled = true;
                  }
               }
               if(param1.endDate - _loc7_.time < 0)
               {
                  param2.btn_subscribe.softDisabled = true;
               }
               param2.btn_subscribe.visible = true;
               param2.lbl_entrants.text = this.uiApi.processText(this.uiApi.getText("ui.dare.currentEntrants",param1.countEntrants),"n",param1.countEntrants <= 1);
               param2.lbl_realDuration.text = this.uiApi.getText("ui.fightend.duration") + this.uiApi.getText("ui.common.colon") + this.timeApi.getDuration(param1.endDate - param1.startDate);
               _loc11_ = param1.endDate - _loc7_.time;
               if(_loc11_ < 0)
               {
                  param2.lbl_remainingTime.text = this.uiApi.getText("ui.dare.time.over");
               }
               else
               {
                  _loc12_ = param1.startDate - _loc7_.time;
                  if(_loc12_ > 0)
                  {
                     param2.lbl_remainingTime.text = this.uiApi.getText("ui.dare.time.beginIn",this.timeApi.getDuration(_loc12_));
                  }
                  else
                  {
                     param2.lbl_remainingTime.text = this.uiApi.getText("ui.dare.time.endIn",this.timeApi.getDuration(_loc11_));
                  }
               }
               _loc5_ = new Array();
               for each(_loc6_ in param1.criteria)
               {
                  _loc5_.push(_loc6_);
               }
               if(_loc5_.length > 1)
               {
                  param2.lbl_noCriteria.visible = false;
                  param2.gd_listCrit.height = (param1.criteria.length - 1) * param2.gd_listCrit.slotHeight;
                  param2.gd_listCrit.dataProvider = _loc5_.slice(1);
               }
               else
               {
                  param2.gd_listCrit.height = 1 * param2.gd_listCrit.slotHeight;
                  param2.gd_listCrit.dataProvider = new Array();
                  param2.lbl_noCriteria.visible = true;
               }
               break;
            case CTR_GRID_DARE:
         }
      }
      
      public function getDareLineType(param1:*, param2:uint) : String
      {
         if(!param1)
         {
            return "";
         }
         switch(param2)
         {
            case 0:
               if(param1 && this._selectedDare && param1.dareId == this._selectedDare.dareId)
               {
                  return CTR_GRID_DETAILS;
               }
               return CTR_GRID_DARE;
            default:
               return CTR_GRID_DARE;
         }
      }
      
      public function getDareDataLength(param1:*, param2:Boolean) : *
      {
         if(param2)
         {
            return 9;
         }
         return 3;
      }
      
      public function updateCritLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1 != null)
         {
            param2.tx_iconCrit.uri = this.uiApi.createUri(this._criteriaTypePath + "" + param1.type + "_normal.png");
            param2.lbl_nameCrit.text = param1.name + this.uiApi.getText("ui.common.colon");
            if(param1.type == DareCriteriaTypeEnum.CHALLENGE_ID)
            {
               param2.gd_slotsCrit.visible = true;
               param2.gd_dataCrit.visible = false;
               param2.lbl_valueCrit.visible = false;
               param2.gd_slotsCrit.width = param2.gd_slotsCrit.slotWidth * param1.paramsData.length + (param1.paramsData.length - 1) * 5;
               param2.gd_slotsCrit.dataProvider = param1.paramsData;
            }
            else if(param1.type == DareCriteriaTypeEnum.IDOLS)
            {
               param2.gd_slotsCrit.visible = true;
               param2.gd_dataCrit.visible = false;
               param2.lbl_valueCrit.visible = false;
               param2.gd_slotsCrit.width = param2.gd_slotsCrit.slotWidth * param1.paramsData.length + (param1.paramsData.length - 1) * 5;
               param2.gd_slotsCrit.dataProvider = param1.paramsData;
            }
            else if(param1.type == DareCriteriaTypeEnum.FORBIDDEN_BREEDS || param1.type == DareCriteriaTypeEnum.MANDATORY_BREEDS)
            {
               param2.gd_slotsCrit.visible = false;
               param2.gd_dataCrit.visible = true;
               param2.lbl_valueCrit.visible = false;
               param2.gd_dataCrit.dataProvider = param1.paramsData;
            }
            else
            {
               param2.gd_slotsCrit.visible = false;
               param2.gd_dataCrit.visible = false;
               param2.lbl_valueCrit.visible = true;
               param2.lbl_valueCrit.text = param1.params[0];
            }
         }
         else
         {
            param2.tx_iconCrit.uri = null;
            param2.lbl_nameCrit.text = "";
            param2.lbl_valueCrit.text = "";
            param2.gd_slotsCrit.visible = false;
            param2.gd_dataCrit.visible = false;
         }
      }
      
      public function updateDareCriteriaTxLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(!this._componentsList[param2.tx_criteria.name])
         {
            this.uiApi.addComponentHook(param2.tx_criteria,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_criteria,ComponentHookList.ON_ROLL_OUT);
         }
         this._componentsList[param2.tx_criteria.name] = param1;
         if(param1 != null)
         {
            param2.tx_criteria.uri = this.uiApi.createUri(this._criteriaTypePath + "" + param1.type + "_normal.png");
         }
         else
         {
            param2.tx_criteria.uri = null;
         }
      }
      
      public function updateBreed(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         if(!this._componentsList[param2.ctr_breed.name])
         {
            this.uiApi.addComponentHook(param2.ctr_breed,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.ctr_breed,ComponentHookList.ON_ROLL_OUT);
         }
         this._componentsList[param2.ctr_breed.name] = param1;
         if(param1)
         {
            if(param1.id > 0)
            {
               _loc4_ = Math.round(Math.random());
               param2.tx_breed.uri = this.uiApi.createUri(this._breedUri + "" + this._breedGfxIdById[param1.id] + ".png");
               param2.ctr_breed.visible = true;
            }
            else
            {
               param2.ctr_breed.visible = false;
            }
         }
         else
         {
            param2.ctr_breed.visible = false;
         }
      }
      
      private function updateDareGrid() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         if(this._currentListType == this.DARE_SUBSCRIBE_LIST)
         {
            _loc2_ = _onlyShowIfFightable;
         }
         else
         {
            _loc2_ = _onlyShowIfSubscribable;
         }
         if(this._searchFilterStatesForced)
         {
            _loc1_ = this.socialApi.getFilteredDareList(_loc2_,this._currentListType == this.DARE_CREATION_LIST,this._currentListType == this.DARE_SUBSCRIBE_LIST,this._searchCriteria,this._searchFilterStatesForced[SEARCH_FILTER_ID],this._searchFilterStatesForced[SEARCH_FILTER_CREATOR],this._searchFilterStatesForced[SEARCH_FILTER_MONSTER],this._searchFilterStatesForced[SEARCH_FILTER_CRITERIA],this._searchFilterStatesForced[SEARCH_FILTER_SUBAREA],this._searchFilterStatesForced[SEARCH_FILTER_GUILD],this._searchFilterStatesForced[SEARCH_FILTER_ALLIANCE]);
         }
         else
         {
            _loc1_ = this.socialApi.getFilteredDareList(_loc2_,this._currentListType == this.DARE_CREATION_LIST,this._currentListType == this.DARE_SUBSCRIBE_LIST,this._searchCriteria,this._searchFilterStates[SEARCH_FILTER_ID],this._searchFilterStates[SEARCH_FILTER_CREATOR],this._searchFilterStates[SEARCH_FILTER_MONSTER],this._searchFilterStates[SEARCH_FILTER_CRITERIA],this._searchFilterStates[SEARCH_FILTER_SUBAREA],this._searchFilterStates[SEARCH_FILTER_GUILD],this._searchFilterStates[SEARCH_FILTER_ALLIANCE]);
         }
         this._currentDaresList = new Array();
         for each(_loc3_ in _loc1_)
         {
            this._currentDaresList.push(_loc3_);
         }
         if(_loc1_.length > 0)
         {
            this.prepareDareList();
            this.lbl_noResult.visible = false;
            this.gd_list.visible = true;
            this.lbl_daresCount.text = this.uiApi.processText(this.uiApi.getText("ui.dare.dareCount",_loc1_.length),"",_loc1_.length == 1);
         }
         else
         {
            this.lbl_noResult.visible = true;
            this.gd_list.visible = false;
            this.lbl_noResult.text = this.uiApi.getText("ui.search.noResult");
            this.lbl_daresCount.text = "";
         }
      }
      
      private function prepareDareList() : void
      {
         var _loc1_:DareWrapper = null;
         var _loc2_:Array = new Array();
         if(this._propertyNameSort == "monsterName")
         {
            if(this._bDescendingSort)
            {
               this._currentDaresList.sortOn([this._propertyNameSort,"dareId"],[Array.CASEINSENSITIVE,Array.NUMERIC]);
            }
            else
            {
               this._currentDaresList.sortOn([this._propertyNameSort,"dareId"],[Array.CASEINSENSITIVE | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING]);
            }
         }
         else if(this._propertyNameSort == "jackpot" || this._propertyNameSort == "subscriptionFee" || this._propertyNameSort == "countWinners" || this._propertyNameSort == "endDate")
         {
            if(this._bDescendingSort)
            {
               this._currentDaresList.sortOn([this._propertyNameSort,"dareId"],[Array.NUMERIC,Array.NUMERIC]);
            }
            else
            {
               this._currentDaresList.sortOn([this._propertyNameSort,"dareId"],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING]);
            }
         }
         for each(_loc1_ in this._currentDaresList)
         {
            _loc2_.push(_loc1_);
            _loc2_.push(null);
            _loc2_.push(null);
            if(this._selectedDare && _loc1_ && _loc1_.dareId == this._selectedDare.dareId)
            {
               _loc2_.push(null);
               _loc2_.push(null);
               _loc2_.push(null);
               _loc2_.push(null);
               _loc2_.push(null);
               _loc2_.push(null);
            }
         }
         this.gd_list.dataProvider = _loc2_;
         this.gd_list.verticalScrollValue = this._currentScrollValue;
      }
      
      private function onConfirmCancelDare() : void
      {
         this.sysApi.sendAction(new DareCancelRequest(this._popupDareId));
      }
      
      private function onConfirmSubscribeDare() : void
      {
         this.sysApi.sendAction(new DareSubscribeRequest(this._popupDareId,true));
      }
      
      private function onConfirmUnsubscribeDare() : void
      {
         this.sysApi.sendAction(new DareSubscribeRequest(this._popupDareId,false));
      }
      
      private function onCancel() : void
      {
      }
      
      private function changeSearchFilter(param1:String) : void
      {
         this._searchFilterStates[param1] = !this._searchFilterStates[param1];
         this.toggleInputSearch();
         if(this._searchCriteria && this._searchCriteria != "")
         {
            this.updateDareGrid();
         }
      }
      
      private function toggleInputSearch() : void
      {
         if(!this._searchFilterStates[SEARCH_FILTER_ID] && !this._searchFilterStates[SEARCH_FILTER_CREATOR] && !this._searchFilterStates[SEARCH_FILTER_MONSTER] && !this._searchFilterStates[SEARCH_FILTER_CRITERIA] && !this._searchFilterStates[SEARCH_FILTER_SUBAREA] && !this._searchFilterStates[SEARCH_FILTER_GUILD] && !this._searchFilterStates[SEARCH_FILTER_ALLIANCE])
         {
            this.inp_search.visible = false;
            this.tx_inputBg.disabled = true;
         }
         else
         {
            this.inp_search.visible = true;
            this.tx_inputBg.disabled = false;
         }
      }
      
      private function hideDares(param1:Array, param2:Boolean = true) : void
      {
         var _loc4_:DareWrapper = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc3_:Array = this.sysApi.getData("HiddenDaresIds");
         if(param2)
         {
            if(!_loc3_)
            {
               _loc3_ = new Array();
            }
            for each(_loc4_ in param1)
            {
               this._hiddenDaresIds[_loc4_.dareId] = true;
               _loc3_.push(_loc4_.dareId + "_" + _loc4_.endDate);
            }
         }
         else
         {
            _loc5_ = new Array();
            for each(_loc6_ in _loc3_)
            {
               _loc5_.push(Number(_loc6_.split("_")[0]));
            }
            for each(_loc4_ in param1)
            {
               delete this._hiddenDaresIds[_loc4_.dareId];
               _loc7_ = _loc5_.indexOf(_loc4_.dareId);
               if(_loc7_ > -1)
               {
                  _loc3_.splice(_loc7_,1);
               }
            }
         }
         this.sysApi.setData("HiddenDaresIds",_loc3_);
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:DareWrapper = null;
         var _loc4_:DareWrapper = null;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc7_:int = 0;
         if(param1 == this.btn_onlyShowIfSubscribable)
         {
            _onlyShowIfSubscribable = this.btn_onlyShowIfSubscribable.selected;
            this.updateDareGrid();
         }
         else if(param1 == this.btn_onlyShowIfFightable)
         {
            _onlyShowIfFightable = this.btn_onlyShowIfFightable.selected;
            this.updateDareGrid();
         }
         else if(param1 == this.btn_tabMonster)
         {
            if(this._propertyNameSort == "monsterName")
            {
               this._bDescendingSort = !this._bDescendingSort;
            }
            else
            {
               this._propertyNameSort = "monsterName";
            }
            this.prepareDareList();
         }
         else if(param1 == this.btn_tabJackpot)
         {
            if(this._propertyNameSort == "jackpot")
            {
               this._bDescendingSort = !this._bDescendingSort;
            }
            else
            {
               this._propertyNameSort = "jackpot";
            }
            this.prepareDareList();
         }
         else if(param1 == this.btn_tabFee)
         {
            if(this._propertyNameSort == "subscriptionFee")
            {
               this._bDescendingSort = !this._bDescendingSort;
            }
            else
            {
               this._propertyNameSort = "subscriptionFee";
            }
            this.prepareDareList();
         }
         else if(param1 == this.btn_tabWinners)
         {
            if(this._propertyNameSort == "countWinners")
            {
               this._bDescendingSort = !this._bDescendingSort;
            }
            else
            {
               this._propertyNameSort = "countWinners";
            }
            this.prepareDareList();
         }
         else if(param1 == this.btn_tabDuration)
         {
            if(this._propertyNameSort == "endDate")
            {
               this._bDescendingSort = !this._bDescendingSort;
            }
            else
            {
               this._propertyNameSort = "endDate";
            }
            this.prepareDareList();
         }
         else if(param1 == this.btn_resetSearch)
         {
            this._searchCriteria = null;
            this.inp_search.text = "";
            this._searchFilterStatesForced = null;
            this.updateDareGrid();
         }
         else if(param1 == this.btn_searchFilter)
         {
            _loc2_ = new Array();
            _loc2_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.search.criteria")));
            _loc2_.push(this.modContextMenu.createContextMenuItemObject(this._searchFilterTexts[SEARCH_FILTER_ID],this.changeSearchFilter,[SEARCH_FILTER_ID],false,null,this._searchFilterStates[SEARCH_FILTER_ID],false));
            _loc2_.push(this.modContextMenu.createContextMenuItemObject(this._searchFilterTexts[SEARCH_FILTER_CREATOR],this.changeSearchFilter,[SEARCH_FILTER_CREATOR],false,null,this._searchFilterStates[SEARCH_FILTER_CREATOR],false));
            _loc2_.push(this.modContextMenu.createContextMenuItemObject(this._searchFilterTexts[SEARCH_FILTER_MONSTER],this.changeSearchFilter,[SEARCH_FILTER_MONSTER],false,null,this._searchFilterStates[SEARCH_FILTER_MONSTER],false));
            _loc2_.push(this.modContextMenu.createContextMenuItemObject(this._searchFilterTexts[SEARCH_FILTER_CRITERIA],this.changeSearchFilter,[SEARCH_FILTER_CRITERIA],false,null,this._searchFilterStates[SEARCH_FILTER_CRITERIA],false));
            _loc2_.push(this.modContextMenu.createContextMenuItemObject(this._searchFilterTexts[SEARCH_FILTER_SUBAREA],this.changeSearchFilter,[SEARCH_FILTER_SUBAREA],false,null,this._searchFilterStates[SEARCH_FILTER_SUBAREA],false));
            _loc2_.push(this.modContextMenu.createContextMenuItemObject(this._searchFilterTexts[SEARCH_FILTER_GUILD],this.changeSearchFilter,[SEARCH_FILTER_GUILD],false,null,this._searchFilterStates[SEARCH_FILTER_GUILD],false));
            _loc2_.push(this.modContextMenu.createContextMenuItemObject(this._searchFilterTexts[SEARCH_FILTER_ALLIANCE],this.changeSearchFilter,[SEARCH_FILTER_ALLIANCE],false,null,this._searchFilterStates[SEARCH_FILTER_ALLIANCE],false));
            this.modContextMenu.createContextMenu(_loc2_);
         }
         else if(param1.name.indexOf("btn_web") != -1)
         {
            this.sysApi.goToDare(this._selectedDare);
         }
         else if(param1.name.indexOf("ctr_dareLine") != -1 || param1.name.indexOf("gd_criteriaTxList") != -1 || param1.name.indexOf("ctr_guildalliance") != -1)
         {
            _loc3_ = this._componentsList[param1.name];
            if(this.uiApi.keyIsDown(Keyboard.SHIFT))
            {
               this.sysApi.dispatchHook(MouseShiftClick,{"data":_loc3_});
               return;
            }
            if(!this._selectedDare || _loc3_ && this._selectedDare.dareId != _loc3_.dareId)
            {
               this._currentScrollValue = this.gd_list.verticalScrollValue;
               this._selectedDare = _loc3_;
               this.sysApi.sendAction(new DareInformationsRequest(_loc3_.dareId));
               this.prepareDareList();
            }
            else
            {
               this._currentScrollValue = this.gd_list.verticalScrollValue;
               this._selectedDare = null;
               this.prepareDareList();
            }
         }
         else if(param1.name.indexOf("btn_visible") != -1)
         {
            _loc4_ = this._componentsList[param1.name];
            if(!this._hiddenDaresIds[_loc4_.dareId])
            {
               this.hideDares([_loc4_]);
               if(_onlyShowIfSubscribable && this._currentListType == this.DARE_COMPLETE_LIST)
               {
                  _loc7_ = this.gd_list.verticalScrollValue;
                  this.updateDareGrid();
                  this.gd_list.verticalScrollValue = _loc7_;
                  return;
               }
            }
            else
            {
               this.hideDares([_loc4_],false);
            }
            this.uiApi.hideTooltip();
            _loc5_ = 0;
            for(_loc6_ in this.gd_list.dataProvider)
            {
               if(this.gd_list.dataProvider[_loc6_] && this.gd_list.dataProvider[_loc6_].dareId == _loc4_.dareId)
               {
                  _loc5_ = _loc6_;
               }
            }
            this.gd_list.updateItem(_loc5_);
         }
         else if(param1.name.indexOf("btn_subscribe") != -1)
         {
            if(this._selectedDare.isMyCreation)
            {
               this._popupDareId = this._selectedDare.dareId;
               this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.dare.cancelConfirm"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmCancelDare,this.onCancel],this.onConfirmCancelDare,this.onCancel);
            }
            else if(!this._selectedDare.subscribed)
            {
               this._popupDareId = this._selectedDare.dareId;
               if(this._selectedDare.subscriptionFee > 0)
               {
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.dare.subscribeConfirm",this._selectedDare.subscriptionFeeString),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmSubscribeDare,this.onCancel],this.onConfirmSubscribeDare,this.onCancel);
               }
               else
               {
                  this.onConfirmSubscribeDare();
               }
            }
            else
            {
               this._popupDareId = this._selectedDare.dareId;
               this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.dare.unsubscribeConfirm"),[this.uiApi.getText("ui.common.yes"),this.uiApi.getText("ui.common.no")],[this.onConfirmUnsubscribeDare,this.onCancel],this.onConfirmUnsubscribeDare,this.onCancel);
            }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:* = null;
         var _loc5_:Object = null;
         var _loc6_:Date = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Date = null;
         var _loc10_:int = 0;
         var _loc3_:uint = 6;
         var _loc4_:uint = 0;
         if(param1 == this.btn_searchFilter)
         {
            _loc2_ = this.uiApi.getText("ui.search.criteria");
         }
         if(param1 == this.btn_onlyShowIfSubscribable)
         {
            _loc2_ = this.uiApi.getText("ui.dare.info.subscribable");
         }
         else if(param1.name.indexOf("lbl_duration") != -1)
         {
            _loc5_ = this._componentsList[param1.name];
            if(!_loc5_)
            {
               return;
            }
            _loc6_ = new Date();
            _loc7_ = _loc5_.endDate - _loc6_.time;
            if(_loc7_ > 0)
            {
               _loc8_ = _loc5_.startDate - _loc6_.time;
               if(_loc8_ > 0)
               {
                  _loc2_ = this.uiApi.getText("ui.dare.time.beginIn",this.timeApi.getDuration(_loc8_));
                  _loc2_ = _loc2_ + "\n";
                  _loc2_ = _loc2_ + (this.uiApi.getText("ui.fightend.duration") + this.uiApi.getText("ui.common.colon") + this.timeApi.getDuration(_loc5_.endDate - _loc5_.startDate));
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.dare.time.endIn",this.timeApi.getDuration(_loc7_));
               }
            }
         }
         else if(param1.name.indexOf("lbl_realDuration") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.dare.info.realduration");
         }
         else if(param1.name.indexOf("ctr_guildalliance") != -1)
         {
            _loc5_ = this._componentsList[param1.name];
            if(!_loc5_)
            {
               return;
            }
            if(_loc5_.allianceId > 0)
            {
               _loc2_ = this.uiApi.getText("ui.dare.info.alliance",_loc5_.alliance.allianceName);
            }
            else if(_loc5_.guildId > 0)
            {
               _loc2_ = this.uiApi.getText("ui.dare.info.guild",_loc5_.guild.guildName);
            }
         }
         else if(param1.name.indexOf("btn_visible") != -1)
         {
            _loc5_ = this._componentsList[param1.name];
            if(!_loc5_)
            {
               return;
            }
            if(this._hiddenDaresIds[_loc5_.dareId])
            {
               _loc2_ = this.uiApi.getText("ui.dare.hiddenDare");
            }
            else
            {
               _loc2_ = this.uiApi.getText("ui.dare.visibleDare");
            }
         }
         else if(param1.name.indexOf("tx_private") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.dare.info.private");
         }
         else if(param1.name.indexOf("btn_subscribe") != -1)
         {
            if(!this._selectedDare)
            {
               return;
            }
            _loc9_ = new Date();
            if(this._selectedDare.endDate < _loc9_.time)
            {
               _loc2_ = this.uiApi.getText("ui.dare.info.dareTimeOver");
            }
            else if(this._selectedDare.isMyCreation)
            {
               if(this._selectedDare.countEntrants == 0)
               {
                  _loc2_ = this.uiApi.getText("ui.dare.info.cancelOk");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.dare.info.cancelImpossible");
               }
            }
            else if(this._selectedDare.subscribed)
            {
               if(this._selectedDare.won)
               {
                  _loc2_ = this.uiApi.getText("ui.dare.info.unsubscribeAlreadyWon");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.dare.info.unsubscribeOk");
               }
            }
            else if(!param1.softDisabled)
            {
               _loc2_ = this.uiApi.getText("ui.dare.info.subscribeOk");
            }
            else
            {
               _loc2_ = this.uiApi.getText("ui.dare.info.subscribeImpossible") + "\n";
               for each(_loc10_ in this._selectedDare.subscribableErrors)
               {
                  if(_loc10_ == DareSubscribeErrorEnum.NO_MORE_WINNERS)
                  {
                     _loc2_ = _loc2_ + (this.uiApi.getText("ui.dare.info.subscribeNoMoreWinners") + "\n");
                  }
                  if(_loc10_ == DareSubscribeErrorEnum.GUILD_LIMITED)
                  {
                     _loc2_ = _loc2_ + (this.uiApi.getText("ui.dare.info.subscribeGuildLimited") + "\n");
                  }
                  if(_loc10_ == DareSubscribeErrorEnum.ALLIANCE_LIMITED)
                  {
                     _loc2_ = _loc2_ + (this.uiApi.getText("ui.dare.info.subscribeAllianceLimited") + "\n");
                  }
                  if(_loc10_ == DareSubscribeErrorEnum.NOT_ENOUGH_MONEY)
                  {
                     _loc2_ = _loc2_ + (this.uiApi.getText("ui.dare.info.subscribeNotEnoughMoney") + "\n");
                  }
                  if(_loc10_ == DareSubscribeErrorEnum.BREED_LIMITED)
                  {
                     _loc2_ = _loc2_ + (this.uiApi.getText("ui.dare.info.subscribeBreedLimited") + "\n");
                  }
                  if(_loc10_ == DareSubscribeErrorEnum.LEVEL_TOO_HIGH)
                  {
                     _loc2_ = _loc2_ + (this.uiApi.getText("ui.dare.info.subscribeLevelTooHigh") + "\n");
                  }
               }
               _loc2_ = _loc2_.slice(0,_loc2_.length - 2);
            }
         }
         else if(param1.name.indexOf("btn_web") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.dare.share");
         }
         else if(param1.name.indexOf("tx_criteria") != -1)
         {
            _loc5_ = this._componentsList[param1.name];
            if(!_loc5_)
            {
               return;
            }
            _loc2_ = _loc5_.label;
         }
         else if(param1.name.indexOf("ctr_breed") != -1)
         {
            _loc5_ = this._componentsList[param1.name];
            if(_loc5_ && _loc5_.id > 0)
            {
               _loc2_ = _loc5_.name;
            }
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_,_loc4_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(!param2 || !param2.data)
         {
            return;
         }
         if(param1.name.indexOf("gd_slots") != -1)
         {
            _loc4_ = {
               "point":LocationEnum.POINT_BOTTOMRIGHT,
               "relativePoint":LocationEnum.POINT_TOPLEFT
            };
            if(param2.data is ItemWrapper)
            {
               this.uiApi.showTooltip(param2.data,param1,false,"standard",_loc4_.point,_loc4_.relativePoint,0,"itemName",null,{
                  "showEffects":true,
                  "header":true
               },"ItemInfo");
               return;
            }
            if(param2.data is ChallengeWrapper)
            {
               this.uiApi.showTooltip(param2.data,param1,false,"standard",_loc4_.point,_loc4_.relativePoint,0,null,null,{"effects":false});
            }
         }
         if(_loc3_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc3_),param1,false,"standard",_loc4_.point,_loc4_.relativePoint,0,null,null,null,"TextInfo");
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
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
            this._searchFilterStatesForced = null;
            this.updateDareGrid();
         }
         else
         {
            if(this._searchCriteria)
            {
               this._searchCriteria = null;
            }
            if(this.inp_search.text.length == 0)
            {
               this._searchFilterStatesForced = null;
               this.updateDareGrid();
            }
         }
      }
      
      private function onDareListUpdated() : void
      {
         this._currentListType = Dare.getInstance().currentTab;
         if(this._currentListType == this.DARE_COMPLETE_LIST)
         {
            this.btn_onlyShowIfSubscribable.visible = true;
         }
         else
         {
            this.btn_onlyShowIfSubscribable.visible = false;
         }
         if(this._currentListType == this.DARE_SUBSCRIBE_LIST)
         {
            this.btn_onlyShowIfFightable.visible = true;
         }
         else
         {
            this.btn_onlyShowIfFightable.visible = false;
         }
         this.updateDareGrid();
      }
      
      private function onDareUpdated(param1:Number) : void
      {
         var _loc4_:int = 0;
         var _loc2_:DareWrapper = this.socialApi.getDareById(param1);
         var _loc3_:Boolean = false;
         var _loc5_:int = 0;
         _loc4_ = this._currentDaresList.length;
         while(_loc5_ < _loc4_)
         {
            if(this._currentDaresList[_loc5_] && this._currentDaresList[_loc5_].dareId == param1)
            {
               this._currentDaresList[_loc5_] = _loc2_;
               _loc3_ = true;
               break;
            }
            _loc5_++;
         }
         if(_loc3_)
         {
            _loc4_ = this.gd_list.dataProvider.length;
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               if(this.gd_list.dataProvider[_loc5_] && this.gd_list.dataProvider[_loc5_].dareId == param1)
               {
                  this.gd_list.dataProvider[_loc5_] = _loc2_;
                  this.gd_list.updateItem(_loc5_);
                  break;
               }
               _loc5_++;
            }
         }
         else if(this._searchCriteria == "" + param1)
         {
            this.updateDareGrid();
         }
      }
      
      private function onOpenDareSearch(param1:String, param2:String = null, param3:Boolean = true) : void
      {
         this._searchCriteria = param1;
         this.inp_search.text = param1;
         this.btn_onlyShowIfSubscribable.selected = false;
         this.btn_onlyShowIfFightable.selected = false;
         _onlyShowIfSubscribable = false;
         _onlyShowIfFightable = false;
         if(param2)
         {
            this._searchFilterStatesForced = new Dictionary(true);
            this._searchFilterStatesForced[SEARCH_FILTER_ID] = false;
            this._searchFilterStatesForced[SEARCH_FILTER_CREATOR] = false;
            this._searchFilterStatesForced[SEARCH_FILTER_MONSTER] = false;
            this._searchFilterStatesForced[SEARCH_FILTER_CRITERIA] = false;
            this._searchFilterStatesForced[SEARCH_FILTER_SUBAREA] = false;
            this._searchFilterStatesForced[SEARCH_FILTER_GUILD] = false;
            this._searchFilterStatesForced[SEARCH_FILTER_ALLIANCE] = false;
            this._searchFilterStatesForced[param2] = true;
         }
         if(param3)
         {
            this.updateDareGrid();
         }
      }
   }
}
