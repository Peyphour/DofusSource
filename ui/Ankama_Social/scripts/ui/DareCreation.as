package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.datacenter.challenges.Challenge;
   import com.ankamagames.dofus.datacenter.dare.DareCriteria;
   import com.ankamagames.dofus.datacenter.guild.EmblemSymbol;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.internalDatacenter.fight.ChallengeWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.AllianceWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.EmblemWrapper;
   import com.ankamagames.dofus.internalDatacenter.guild.GuildWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.tooltip.LocationEnum;
   import d2actions.DareCreationRequest;
   import d2enums.ComponentHookList;
   import d2enums.DareCriteriaTypeEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.SelectMethodEnum;
   import d2enums.StatesEnum;
   import d2hooks.AllianceMembershipUpdated;
   import d2hooks.DareCreated;
   import d2hooks.GuildMembershipUpdated;
   import d2hooks.KeyDown;
   import d2hooks.KeyUp;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class DareCreation
   {
      
      private static var GRID_CTR_SEARCH:String = "ctr_search";
      
      private static var GRID_CTR_INPUT:String = "ctr_input";
      
      private static var GRID_CTR_GRID:String = "ctr_searchGrid";
      
      private static var GRID_CTR_SLOTS:String = "ctr_searchSlots";
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var tooltipApi:TooltipApi;
      
      public var dataApi:DataApi;
      
      public var socialApi:SocialApi;
      
      public var utilApi:UtilApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private const INT_LIMIT:int = 999999999;
      
      private const DAYS_TO_SECONDS:int = 86400;
      
      private const HOURS_TO_SECONDS:int = 3600;
      
      private const SEARCH_MODE_FILTERED_LIST:uint = 0;
      
      private const SEARCH_MODE_FULL_LIST:uint = 1;
      
      private const MONSTERS_INCOMPATIBLE_WITH_MAX_FIGHT_TURNS:Array = [3826,3824,3823,3828,3827,3822,3825,4263,3835];
      
      private const MONSTERS_INCOMPATIBLE_WITH_GROUP_IDOLS:Array = [3137,605,267,268,265,266,800,804,808,423];
      
      private const MONSTERS_INCOMPATIBLE_WITH_MIN_MONSTER_COUNT:Array = [780,675,677,673,681];
      
      private var INPUT_SEARCH_TEXT:String;
      
      private var _jackpot:uint = 0;
      
      private var _subscriptionFee:uint = 0;
      
      private var _maxCountWinners:uint = 0;
      
      private var _delayBeforeStart:uint = 0;
      
      private var _delayBeforeStartH:uint = 0;
      
      private var _duration:uint = 14;
      
      private var _durationH:uint = 0;
      
      private var _isPrivate:Boolean;
      
      private var _isForGuild:Boolean;
      
      private var _isForAlliance:Boolean;
      
      private var _needNotifications:Boolean = true;
      
      private var _criteria:Array;
      
      private var _criteriaToDisplay:Array;
      
      private var _criteriaTypeData:Object;
      
      private var _incompatibleIdolsForThisMonster:Array;
      
      private var _chosenIdolIds:Array;
      
      private var _chosenBreedIds:Array;
      
      private var _chosenChallengeIds:Array;
      
      private var _chosenMonsterName:String;
      
      private var _notEnoughMoney:Boolean;
      
      private var _noMonsterSelected:Boolean = true;
      
      private var _wrongJackpot:Boolean;
      
      private var _criteriaOk:Boolean = true;
      
      private var _gridComponents:Dictionary;
      
      private var _searchCriteria:String;
      
      private var _searchTimeoutId:uint;
      
      private var _addEntryHighlight:Boolean;
      
      private var _removeEntryHighlight:Boolean;
      
      private var _ctrMaxHeight:uint;
      
      private var _searchMaxHeight:uint;
      
      private var _searchSlotHeight:uint;
      
      private var _lastSearch:String;
      
      private var _searchMode:uint;
      
      private var _breedUri:String;
      
      private var _breedGfxIdById:Array;
      
      private var _emblemsPath:String;
      
      private var _criteriaTypePath:String;
      
      private var _monsterSpritesPath:String;
      
      private var _currentSearchCriteriaType:int = -1;
      
      private var _currentSearchInput:Input;
      
      private var _currentCritLineIndex:int = 0;
      
      private var _criteriaDataProviderIndexByCriteriaIndex:Array;
      
      private var _saveOnUnload:Boolean;
      
      public var mainCtr:GraphicContainer;
      
      public var inp_jackpot:Input;
      
      public var inp_fee:Input;
      
      public var inp_maxCountWinners:Input;
      
      public var inp_duration:Input;
      
      public var inp_durationH:Input;
      
      public var inp_delayBeforeStart:Input;
      
      public var inp_delayBeforeStartH:Input;
      
      public var lbl_feeInfo:Label;
      
      public var lbl_maxCountWinnersInfo:Label;
      
      public var lbl_durationInfo:Label;
      
      public var lbl_delayBeforeStartInfo:Label;
      
      public var btn_isPrivate:ButtonContainer;
      
      public var cb_restriction:ComboBox;
      
      public var ctr_guildalliance:GraphicContainer;
      
      public var tx_emblemBack:Texture;
      
      public var tx_emblemUp:Texture;
      
      public var btn_needNotifications:ButtonContainer;
      
      public var inp_monster:Input;
      
      public var tx_monsterUnknown:Texture;
      
      public var ed_monster:EntityDisplayer;
      
      public var btn_closeMonster:ButtonContainer;
      
      public var lbl_criteriaTitle:Label;
      
      public var gd_criteriaType:Grid;
      
      public var gd_criteria:Grid;
      
      public var ctr_search:GraphicContainer;
      
      public var ctr_searchBg:Texture;
      
      public var gd_searchResult:Grid;
      
      public var lbl_searchResult:Label;
      
      public var btn_valid:ButtonContainer;
      
      public var lbl_creationCost:Label;
      
      public function DareCreation()
      {
         this._criteria = new Array();
         this._criteriaToDisplay = new Array();
         this._gridComponents = new Dictionary(true);
         super();
      }
      
      public function main(... rest) : void
      {
         var _loc3_:Breed = null;
         this.sysApi.addHook(DareCreated,this.onDareCreated);
         this.sysApi.addHook(GuildMembershipUpdated,this.onGuildAllianceMembershipUpdated);
         this.sysApi.addHook(AllianceMembershipUpdated,this.onGuildAllianceMembershipUpdated);
         this.uiApi.addComponentHook(this.mainCtr,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.inp_jackpot,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.inp_jackpot,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.inp_jackpot,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.inp_fee,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.inp_maxCountWinners,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.inp_duration,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.inp_delayBeforeStart,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.inp_durationH,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.inp_delayBeforeStartH,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.inp_monster,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.inp_monster,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.inp_monster,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.inp_monster,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_isPrivate,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_isPrivate,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_isPrivate,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.cb_restriction,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.cb_restriction,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.cb_restriction,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_searchResult,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.lbl_feeInfo,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_feeInfo,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_maxCountWinnersInfo,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_maxCountWinnersInfo,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_durationInfo,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_durationInfo,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_delayBeforeStartInfo,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_delayBeforeStartInfo,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ctr_guildalliance,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_guildalliance,ComponentHookList.ON_ROLL_OUT);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.sysApi.addHook(KeyDown,this.onKeyDown);
         this._searchMaxHeight = this.uiApi.me().getConstant("searchMaxHeight");
         this._ctrMaxHeight = this.uiApi.me().getConstant("ctrMaxHeight");
         this._searchSlotHeight = this.uiApi.me().getConstant("searchSlotHeight");
         this._breedUri = this.uiApi.me().getConstant("heads_uri");
         this._emblemsPath = this.uiApi.me().getConstant("emblems_uri");
         this._criteriaTypePath = this.uiApi.me().getConstant("criteriaType_uri");
         this._monsterSpritesPath = this.uiApi.me().getConstant("monsterSprite_uri");
         this._criteriaTypeData = this.dataApi.getAllDareCriteria();
         this.inp_jackpot.restrictChars = "0-9";
         this.inp_fee.restrictChars = "0-9";
         this.inp_maxCountWinners.restrictChars = "0-9";
         this.inp_duration.restrictChars = "0-9";
         this.inp_durationH.restrictChars = "0-9";
         this.inp_delayBeforeStart.restrictChars = "0-9";
         this.inp_delayBeforeStartH.restrictChars = "0-9";
         this.inp_duration.numberMax = ProtocolConstantsEnum.MAX_DARE_DURATION;
         this.inp_delayBeforeStart.numberMax = ProtocolConstantsEnum.MAX_DARE_DURATION;
         this.inp_durationH.numberMax = 23;
         this.inp_delayBeforeStartH.numberMax = 23;
         this.INPUT_SEARCH_TEXT = this.uiApi.getText("ui.common.search.input");
         this.inp_monster.text = this.INPUT_SEARCH_TEXT;
         this.lbl_criteriaTitle.text = this.uiApi.getText("ui.dare.criteria") + " " + this.uiApi.getText("ui.dare.maxCriteria.short",ProtocolConstantsEnum.MAX_CRITERION_BY_DARE - 1);
         this.onGuildAllianceMembershipUpdated(true);
         this._breedGfxIdById = new Array();
         var _loc2_:Object = this.dataApi.getBreeds();
         for each(_loc3_ in _loc2_)
         {
            this._breedGfxIdById[_loc3_.id] = _loc3_.id + "" + _loc3_.id % 2;
         }
         this.initUI();
      }
      
      public function unload() : void
      {
         var _loc1_:Object = null;
         clearTimeout(this._searchTimeoutId);
         if(this._saveOnUnload)
         {
            _loc1_ = new Object();
            _loc1_.jackpot = this._jackpot;
            _loc1_.subscriptionFee = this._subscriptionFee;
            _loc1_.maxCountWinners = this._maxCountWinners;
            _loc1_.delayBeforeStart = this._delayBeforeStart;
            _loc1_.duration = this._duration;
            _loc1_.delayBeforeStartH = this._delayBeforeStartH;
            _loc1_.durationH = this._durationH;
            _loc1_.isPrivate = this._isPrivate;
            _loc1_.isForGuild = this._isForGuild;
            _loc1_.isForAlliance = this._isForAlliance;
            _loc1_.needNotifications = this._needNotifications;
            _loc1_.criteria = !!this._criteria?this._criteria:new Array();
            Social.getInstance().dareCreationStatus = _loc1_;
         }
      }
      
      public function initUI() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         this.ctr_search.visible = false;
         if(Social.getInstance().dareCreationStatus)
         {
            _loc1_ = Social.getInstance().dareCreationStatus;
            this._jackpot = _loc1_.jackpot;
            this._subscriptionFee = _loc1_.subscriptionFee;
            this._maxCountWinners = _loc1_.maxCountWinners;
            this._delayBeforeStart = _loc1_.delayBeforeStart;
            this._duration = _loc1_.duration;
            this._delayBeforeStartH = _loc1_.delayBeforeStartH;
            this._durationH = _loc1_.durationH;
            this._isPrivate = _loc1_.isPrivate;
            this._isForGuild = _loc1_.isForGuild;
            this._isForAlliance = _loc1_.isForAlliance;
            this._needNotifications = _loc1_.needNotifications;
            this._criteria = _loc1_.criteria;
            _loc2_ = 0;
            if(this._isForAlliance)
            {
               if(this.socialApi.hasAlliance())
               {
                  _loc2_ = 1;
               }
               else
               {
                  this._isForAlliance = false;
               }
            }
            else if(this._isForGuild)
            {
               if(this.socialApi.hasGuild())
               {
                  if(this.socialApi.hasAlliance())
                  {
                     _loc2_ = 2;
                  }
                  else
                  {
                     _loc2_ = 1;
                  }
               }
               else
               {
                  this._isForGuild = false;
               }
            }
            this.cb_restriction.value = this.cb_restriction.dataProvider[_loc2_];
         }
         else
         {
            this._jackpot = 0;
            this._subscriptionFee = 0;
            this._maxCountWinners = 0;
            this._delayBeforeStart = 0;
            this._duration = ProtocolConstantsEnum.MAX_DARE_DURATION;
            this._delayBeforeStartH = 0;
            this._durationH = 0;
            this._isPrivate = false;
            this._isForGuild = false;
            this._isForAlliance = false;
            this._needNotifications = true;
            this.cb_restriction.value = this.cb_restriction.dataProvider[0];
            this._criteria = new Array();
            this.addDareCriteria(0,DareCriteriaTypeEnum.MONSTER_ID);
         }
         this._saveOnUnload = true;
         this.inp_jackpot.text = "" + this._jackpot;
         this.inp_fee.text = "" + this._subscriptionFee;
         this.inp_maxCountWinners.text = "" + this._maxCountWinners;
         this.inp_duration.text = "" + this._duration;
         this.inp_delayBeforeStart.text = "" + this._delayBeforeStart;
         this.inp_durationH.text = "" + this._durationH;
         this.inp_delayBeforeStartH.text = "" + this._delayBeforeStartH;
         this.btn_needNotifications.selected = this._needNotifications;
         this.btn_isPrivate.selected = this._isPrivate;
         this.lbl_creationCost.text = this.utilApi.kamasToString(ProtocolConstantsEnum.DARE_CREATION_TAX + this._jackpot,"");
         this.clearSearchResults();
         if(this._criteria && this._criteria.length && this._criteria[0] && this._criteria[0].params.length && this._criteria[0].params[0])
         {
            this.selectMonster(this._criteria[0].params[0]);
         }
         else
         {
            this.selectMonster(0);
         }
         this._currentCritLineIndex = 0;
         this._currentSearchCriteriaType = -1;
         this._currentSearchInput = null;
         this.updateValidationButton();
         this.updateCriteriaTypeList();
         this.updateCriteriaGrid();
      }
      
      public function updateSearchEntryLine(param1:Object, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         param2.btn_result.y = 1;
         if(param1)
         {
            if(this._removeEntryHighlight)
            {
               param2.btn_result.state = !!param1.selected?StatesEnum.STATE_SELECTED:StatesEnum.STATE_NORMAL;
               this._removeEntryHighlight = false;
               return;
            }
            if(this._addEntryHighlight)
            {
               param2.btn_result.state = !!param1.selected?StatesEnum.STATE_SELECTED_OVER:StatesEnum.STATE_OVER;
               this._addEntryHighlight = false;
               return;
            }
            param2.btn_result.state = !!param1.selected?StatesEnum.STATE_SELECTED:StatesEnum.STATE_NORMAL;
            _loc4_ = !!param1.hasOwnProperty("tooltipData")?param1.tooltipData:param1.data;
            param2.btn_result.selected = param1.selected;
            if(_loc4_)
            {
               if(_loc4_.hasOwnProperty("iconUri"))
               {
                  param2.tx_result.uri = _loc4_.iconUri;
               }
               else if(param1.type == DareCriteriaTypeEnum.MONSTER_ID)
               {
                  param2.tx_result.uri = this.uiApi.createUri(this._monsterSpritesPath + _loc4_.id + ".png");
               }
               else if(param1.type == DareCriteriaTypeEnum.FORBIDDEN_BREEDS || param1.type == DareCriteriaTypeEnum.MANDATORY_BREEDS)
               {
                  param2.tx_result.uri = this.uiApi.createUri(this._breedUri + "" + this._breedGfxIdById[_loc4_.id] + ".png");
               }
            }
            param2.lbl_result.text = param1.label;
            this.uiApi.addComponentHook(param2.btn_result,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_result,ComponentHookList.ON_ROLL_OUT);
            this._gridComponents[param2.btn_result.name] = param1;
         }
         else
         {
            param2.btn_result.state = StatesEnum.STATE_NORMAL;
            param2.btn_result.selected = false;
            param2.tx_result.uri = null;
            param2.lbl_result.text = "";
            this.uiApi.removeComponentHook(param2.btn_result,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.removeComponentHook(param2.btn_result,ComponentHookList.ON_ROLL_OUT);
            delete this._gridComponents[param2.btn_result.name];
         }
      }
      
      public function updateCriteria(param1:*, param2:*, param3:Boolean, param4:uint) : void
      {
         if(!param1)
         {
            return;
         }
         if(!this._gridComponents[param2.tx_warning.name])
         {
            this.uiApi.addComponentHook(param2.tx_warning,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_warning,ComponentHookList.ON_ROLL_OUT);
         }
         this._gridComponents[param2.tx_warning.name] = param1;
         if(param1.warning != "")
         {
            param2.lbl_name.cssClass = "red";
            param2.tx_warning.x = param2.lbl_name.x + param2.lbl_name.textWidth + 15;
            param2.tx_warning.visible = true;
         }
         else
         {
            param2.lbl_name.cssClass = "p";
            param2.tx_warning.visible = false;
         }
         param2.tx_icon.uri = this.uiApi.createUri(this._criteriaTypePath + "" + param1.criteria.id + "_normal.png");
         var _loc5_:String = param1.criteria.name;
         if(param1.criteria.maxParameters > 1)
         {
            _loc5_ = _loc5_ + (" " + this.uiApi.getText("ui.dare.maxCriteria.short",param1.criteria.maxParameters));
         }
         param2.lbl_name.text = _loc5_;
         switch(this.getCriteriaLineType(param1,param4))
         {
            case GRID_CTR_SEARCH:
               if(!this._gridComponents[param2.inp_search.name])
               {
                  this.uiApi.addComponentHook(param2.inp_search,ComponentHookList.ON_RELEASE);
               }
               this._gridComponents[param2.inp_search.name] = param1;
               if(!param1.params[param1.selectedParamIndex] && !this.ctr_search.visible)
               {
                  param2.inp_search.text = this.INPUT_SEARCH_TEXT;
               }
               break;
            case GRID_CTR_INPUT:
               if(!this._gridComponents[param2.inp_value.name])
               {
                  this.uiApi.addComponentHook(param2.inp_value,ComponentHookList.ON_CHANGE);
               }
               this._gridComponents[param2.inp_value.name] = param1;
               param2.inp_value.numberMax = param1.criteria.maxParameterBound;
               param2.inp_value.restrictChars = "0-9";
               if(param1.params[0])
               {
                  param2.inp_value.text = param1.params[0];
               }
               else
               {
                  param2.inp_value.text = "";
               }
               break;
            case GRID_CTR_GRID:
               if(!this._gridComponents[param2.inp_search.name])
               {
                  this.uiApi.addComponentHook(param2.inp_search,ComponentHookList.ON_RELEASE);
               }
               this._gridComponents[param2.inp_search.name] = param1;
               if(!this._gridComponents[param2.gd_data.name])
               {
                  this.uiApi.addComponentHook(param2.gd_data,ComponentHookList.ON_SELECT_ITEM);
               }
               this._gridComponents[param2.gd_data.name] = param1;
               param2.gd_data.dataProvider = param1.params;
               if(!param1.params[param1.selectedParamIndex] && !this.ctr_search.visible)
               {
                  param2.inp_search.text = this.INPUT_SEARCH_TEXT;
               }
               break;
            case GRID_CTR_SLOTS:
               if(!this._gridComponents[param2.inp_search.name])
               {
                  this.uiApi.addComponentHook(param2.inp_search,ComponentHookList.ON_RELEASE);
               }
               this._gridComponents[param2.inp_search.name] = param1;
               if(!this._gridComponents[param2.gd_slots.name])
               {
                  this.uiApi.addComponentHook(param2.gd_slots,ComponentHookList.ON_ITEM_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.gd_slots,ComponentHookList.ON_ITEM_ROLL_OUT);
                  this.uiApi.addComponentHook(param2.gd_slots,ComponentHookList.ON_SELECT_ITEM);
               }
               this._gridComponents[param2.gd_slots.name] = param1;
               param2.gd_slots.dataProvider = param1.params;
               if(!param1.params[param1.selectedParamIndex] && !this.ctr_search.visible)
               {
                  param2.inp_search.text = this.INPUT_SEARCH_TEXT;
               }
         }
      }
      
      public function getCriteriaLineType(param1:*, param2:uint) : String
      {
         if(!param1)
         {
            return "";
         }
         switch(param2)
         {
            case 0:
               if(param1.criteria.id == DareCriteriaTypeEnum.CHALLENGE_ID)
               {
                  return GRID_CTR_SEARCH;
               }
               if(param1.criteria.id == DareCriteriaTypeEnum.FORBIDDEN_BREEDS || param1.criteria.id == DareCriteriaTypeEnum.MANDATORY_BREEDS)
               {
                  return GRID_CTR_GRID;
               }
               if(param1.criteria.id == DareCriteriaTypeEnum.IDOLS)
               {
                  return GRID_CTR_SLOTS;
               }
               return GRID_CTR_INPUT;
            default:
               return GRID_CTR_INPUT;
         }
      }
      
      public function getCriteriaDataLength(param1:*, param2:Boolean) : *
      {
         return 1;
      }
      
      public function updateBreed(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         if(!this._gridComponents[param2.ctr_breed.name])
         {
            this.uiApi.addComponentHook(param2.ctr_breed,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.ctr_breed,ComponentHookList.ON_ROLL_OUT);
         }
         this._gridComponents[param2.ctr_breed.name] = param1;
         if(param1)
         {
            if(param1.id > 0)
            {
               _loc4_ = Math.round(Math.random());
               param2.tx_breed.uri = this.uiApi.createUri(this._breedUri + "" + this._breedGfxIdById[param1.id] + ".png");
            }
            else
            {
               param2.tx_breed.uri = null;
            }
         }
         else
         {
            param2.tx_breed.uri = null;
         }
      }
      
      public function updateCriteriaType(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:* = null;
         if(!this._gridComponents[param2.tx_type.name])
         {
            this.uiApi.addComponentHook(param2.tx_type,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.tx_type,ComponentHookList.ON_ROLL_OUT);
            this.uiApi.addComponentHook(param2.tx_type,ComponentHookList.ON_RELEASE);
         }
         this._gridComponents[param2.tx_type.name] = param1;
         if(param1)
         {
            _loc4_ = this._criteriaTypePath + param1.id;
            if(param1.selected)
            {
               _loc4_ = _loc4_ + "_selected.png";
            }
            else
            {
               _loc4_ = _loc4_ + "_disabled.png";
            }
            param2.tx_type.uri = this.uiApi.createUri(_loc4_);
         }
         else
         {
            param2.tx_type.uri = null;
         }
      }
      
      private function getCriteriaParams(param1:int) : Array
      {
         var _loc5_:int = 0;
         var _loc2_:Array = new Array();
         var _loc3_:int = this._criteria.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this._criteria[_loc4_].type == param1)
            {
               for each(_loc5_ in this._criteria[_loc4_].params)
               {
                  _loc2_.push(_loc5_);
               }
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function getCriteriaMonster() : Monster
      {
         var _loc1_:Monster = null;
         var _loc2_:Array = this.getCriteriaParams(DareCriteriaTypeEnum.MONSTER_ID);
         if(_loc2_.length)
         {
            _loc1_ = this.dataApi.getMonsterFromId(_loc2_[0]);
         }
         return _loc1_;
      }
      
      private function addDareCriteria(param1:int, param2:int) : void
      {
         if(this._criteria[param1])
         {
            this.sysApi.log(2,"Un critere de type " + this._criteria[param1].type + " existe deja à l\'index " + param1);
            return;
         }
         var _loc3_:Object = {
            "type":param2,
            "params":new Vector.<int>(),
            "warning":"",
            "lastModifiedParamIndex":0
         };
         this._criteria[param1] = _loc3_;
         this.updateCriteriaTypeList();
         this.updateCriteriaGrid();
      }
      
      private function removeDareCriteria(param1:int) : void
      {
         if(this._criteria[param1] && param1 > 0)
         {
            this._criteria[param1] = null;
            this._criteria.splice(param1,1);
            this.checkCriteria();
            this.updateCriteriaTypeList();
            this.updateCriteriaGrid();
         }
      }
      
      private function selectMonster(param1:int) : void
      {
         var _loc2_:Monster = null;
         var _loc3_:int = 0;
         if(param1 > 0)
         {
            this._noMonsterSelected = false;
            this._incompatibleIdolsForThisMonster = new Array();
            _loc2_ = this.dataApi.getMonsterFromId(param1);
            if(_loc2_)
            {
               if(_loc2_.allIdolsDisabled)
               {
                  this._incompatibleIdolsForThisMonster.push(-1);
               }
               else
               {
                  for each(_loc3_ in _loc2_.incompatibleIdols)
                  {
                     this._incompatibleIdolsForThisMonster.push(_loc3_);
                  }
               }
               this._chosenMonsterName = _loc2_.name;
            }
            this.tx_monsterUnknown.visible = false;
            this.ed_monster.look = _loc2_.look;
            this.ed_monster.visible = true;
            this.inp_monster.text = _loc2_.name;
         }
         else
         {
            this._noMonsterSelected = true;
            this._incompatibleIdolsForThisMonster = new Array();
            this._chosenMonsterName = "";
            this.tx_monsterUnknown.visible = true;
            this.ed_monster.visible = false;
            this.inp_monster.text = this.INPUT_SEARCH_TEXT;
         }
      }
      
      private function modifyDareCriteriaParam(param1:int, param2:int, param3:int = 0, param4:int = -1) : void
      {
         if(!this._criteria[param1] || this._criteria[param1].type != param2)
         {
            this.sysApi.log(2,"Le critère n\'existe pas ou n\'est pas du bon type, ajout du parametre " + param3 + " impossible.");
            return;
         }
         var _loc5_:DareCriteria = this.dataApi.getDareCriteria(param2);
         if(param4 >= _loc5_.maxParameters)
         {
            this.sysApi.log(2,"Le critere " + _loc5_.name + " est limité à " + _loc5_.maxParameters + " parametres, impossible d\'en ajouter un à l\'index " + param4);
            return;
         }
         if(param3 == 0)
         {
            if(param4 == -1)
            {
               this._criteria[param1].params.pop();
               this._criteria[param1].lastModifiedParamIndex = this._criteria[param1].params.length;
            }
            else if(param4 < this._criteria[param1].params.length)
            {
               this._criteria[param1].params.splice(param4,1);
               this._criteria[param1].lastModifiedParamIndex = param4;
            }
            else
            {
               return;
            }
         }
         else if(param4 == -1)
         {
            if(this._criteria[param1].params.length < _loc5_.maxParameters)
            {
               this._criteria[param1].params.push(param3);
            }
            else
            {
               this._criteria[param1].params[_loc5_.maxParameters - 1] = param3;
            }
            this._criteria[param1].lastModifiedParamIndex = this._criteria[param1].params.length - 1;
         }
         else
         {
            this._criteria[param1].params[param4] = param3;
            this._criteria[param1].lastModifiedParamIndex = param4;
         }
         if(param2 == DareCriteriaTypeEnum.MONSTER_ID)
         {
            this.selectMonster(param3);
         }
         this.checkCriteria();
         this.updateCriteriaGrid();
         var _loc6_:int = this._criteria.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            this.sysApi.log(32," - critere [" + _loc7_ + "] : " + this.dataApi.getDareCriteria(this._criteria[_loc7_].type).name + "     " + this._criteria[_loc7_].params);
            _loc7_++;
         }
      }
      
      private function updateCriteriaTypeList() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc1_:Array = new Array();
         var _loc2_:Boolean = false;
         for each(_loc3_ in this._criteriaTypeData)
         {
            _loc2_ = false;
            for each(_loc4_ in this._criteria)
            {
               if(_loc3_.id == _loc4_.type)
               {
                  _loc2_ = true;
                  break;
               }
            }
            if(_loc3_.id != DareCriteriaTypeEnum.MONSTER_ID)
            {
               _loc1_.push({
                  "id":_loc3_.id,
                  "label":_loc3_.name,
                  "selected":_loc2_
               });
            }
         }
         this.gd_criteriaType.dataProvider = _loc1_;
      }
      
      private function updateCriteriaGrid() : void
      {
         var _loc1_:Array = null;
         var _loc2_:DareCriteria = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         this._criteriaToDisplay = new Array();
         var _loc7_:int = this._criteria.length;
         this._criteriaDataProviderIndexByCriteriaIndex = [];
         _loc3_ = 0;
         while(_loc3_ < _loc7_)
         {
            _loc8_ = this._criteria[_loc3_];
            if(_loc8_.type != DareCriteriaTypeEnum.MONSTER_ID)
            {
               _loc2_ = this.dataApi.getDareCriteria(_loc8_.type);
               _loc1_ = new Array();
               _loc5_ = _loc2_.maxParameters;
               if(_loc8_.params && _loc8_.params.length > 0)
               {
                  if(_loc8_.type == DareCriteriaTypeEnum.CHALLENGE_ID)
                  {
                     _loc1_.push(this.dataApi.getChallenge(_loc8_.params[0]));
                  }
                  else if(_loc8_.type == DareCriteriaTypeEnum.IDOLS)
                  {
                     _loc4_ = 0;
                     while(_loc4_ < _loc5_)
                     {
                        if(_loc8_.params.length > _loc4_)
                        {
                           _loc6_ = _loc8_.params[_loc4_];
                           if(_loc6_ > 0)
                           {
                              _loc1_.push(this.dataApi.getItemWrapper(this.dataApi.getIdol(_loc6_).itemId));
                           }
                           else
                           {
                              _loc1_.push(new Object());
                           }
                        }
                        else
                        {
                           _loc1_.push(new Object());
                        }
                        _loc4_++;
                     }
                  }
                  else if(_loc8_.type == DareCriteriaTypeEnum.FORBIDDEN_BREEDS || _loc8_.type == DareCriteriaTypeEnum.MANDATORY_BREEDS)
                  {
                     _loc4_ = 0;
                     while(_loc4_ < _loc5_)
                     {
                        if(_loc8_.params.length > _loc4_)
                        {
                           _loc6_ = _loc8_.params[_loc4_];
                           _loc1_.push(this.dataApi.getBreed(_loc6_));
                        }
                        else
                        {
                           _loc1_.push(new Object());
                        }
                        _loc4_++;
                     }
                  }
                  else
                  {
                     _loc1_.push(_loc8_.params[0]);
                  }
               }
               _loc9_ = _loc8_.lastModifiedParamIndex;
               if(_loc1_[_loc9_])
               {
                  _loc9_++;
               }
               if(_loc2_.maxParameters <= _loc9_)
               {
                  _loc9_ = _loc2_.maxParameters - 1;
               }
               this._criteriaDataProviderIndexByCriteriaIndex[_loc3_] = this._criteriaToDisplay.length;
               _loc10_ = {
                  "criteria":_loc2_,
                  "params":_loc1_,
                  "index":_loc3_,
                  "warning":_loc8_.warning,
                  "selectedParamIndex":_loc9_
               };
               this._criteriaToDisplay.push(_loc10_);
            }
            _loc3_++;
         }
         this.gd_criteria.dataProvider = this._criteriaToDisplay;
      }
      
      private function buildInputList(param1:int) : void
      {
      }
      
      private function searchAll(param1:String, param2:int = -1) : void
      {
         var _loc4_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         if(param2 == DareCriteriaTypeEnum.MONSTER_ID && (!param1 || param1.length == 0))
         {
            this.ctr_search.visible = false;
            return;
         }
         if(param1 == null)
         {
            param1 = "";
         }
         param1 = this.utilApi.noAccent(param1).toLowerCase();
         if(param2 == -1)
         {
            this.sysApi.log(8,"Search impossible with no data type selected");
            return;
         }
         if(param2 == DareCriteriaTypeEnum.MONSTER_ID)
         {
            this._searchMode = this.SEARCH_MODE_FILTERED_LIST;
         }
         else
         {
            this._searchMode = this.SEARCH_MODE_FULL_LIST;
         }
         var _loc3_:Array = this.getSearchAllResults(param1,param2);
         var _loc5_:Point = (this.mainCtr as Object).globalToLocal((this._currentSearchInput as Object).localToGlobal(new Point(this._currentSearchInput.x,this._currentSearchInput.y)));
         this.ctr_search.x = _loc5_.x - 7;
         this.ctr_search.y = _loc5_.y + this._currentSearchInput.height + 4;
         var _loc6_:int = this._ctrMaxHeight - this.ctr_search.y;
         if(_loc6_ > this._searchMaxHeight)
         {
            _loc6_ = this._searchMaxHeight;
         }
         var _loc7_:Number = _loc3_.length * this._searchSlotHeight;
         this.gd_searchResult.height = _loc7_ > _loc6_?Number(_loc6_):Number(_loc7_);
         this.gd_searchResult.dataProvider = _loc3_;
         if(this._searchMode == this.SEARCH_MODE_FULL_LIST && param1.length)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc3_.length)
            {
               if(_loc3_[_loc8_].selectString.indexOf(param1) == 0)
               {
                  this.gd_searchResult.selectedIndex = _loc8_;
                  break;
               }
               _loc8_++;
            }
         }
         else
         {
            this.gd_searchResult.selectedIndex = 0;
         }
         this.ctr_searchBg.height = this.gd_searchResult.height + this.gd_searchResult.slotHeight;
         this.ctr_searchBg.width = this.gd_searchResult.width + this.gd_searchResult.x;
         if(this._searchMode == this.SEARCH_MODE_FILTERED_LIST)
         {
            if(_loc3_.length == 0)
            {
               this.lbl_searchResult.text = this.uiApi.getText("ui.search.noResult");
               this.gd_searchResult.visible = false;
            }
            else
            {
               this.gd_searchResult.visible = true;
               _loc9_ = this.uiApi.processText(this.uiApi.getText("ui.search.results",_loc3_.length),"n",_loc3_.length <= 1);
               this.lbl_searchResult.text = _loc9_;
            }
         }
         else
         {
            this.gd_searchResult.visible = true;
            this.ctr_searchBg.height = this.ctr_searchBg.height - this.lbl_searchResult.height;
            this.lbl_searchResult.text = "";
         }
         this.lbl_searchResult.y = this.ctr_searchBg.height - this.lbl_searchResult.textHeight - (this.gd_searchResult.slotHeight / 2 - this.lbl_searchResult.textHeight / 2) - 4;
         this.ctr_search.visible = true;
         this._lastSearch = param1;
      }
      
      private function getSearchAllResults(param1:String, param2:int) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:Class = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Array = null;
         var _loc12_:* = false;
         var _loc13_:ItemWrapper = null;
         var _loc3_:Array = new Array();
         var _loc6_:String = "name";
         if(this._searchMode == this.SEARCH_MODE_FILTERED_LIST)
         {
            if(param2 == DareCriteriaTypeEnum.MONSTER_ID)
            {
               _loc5_ = Monster;
               _loc7_ = this.dataApi.queryString(_loc5_,_loc6_,param1);
               for each(_loc8_ in _loc7_)
               {
                  _loc4_ = this.getSearchResultEntry(_loc8_,param2,param1);
                  if(_loc4_)
                  {
                     _loc3_.push(_loc4_);
                  }
               }
            }
            else
            {
               this.sysApi.log(16,"This criteria type is not supported for this searchMode yet!");
            }
         }
         else
         {
            _loc11_ = this.getCriteriaParams(param2);
            _loc12_ = false;
            switch(param2)
            {
               case DareCriteriaTypeEnum.FORBIDDEN_BREEDS:
               case DareCriteriaTypeEnum.MANDATORY_BREEDS:
                  _loc9_ = this.dataApi.getBreeds();
                  for each(_loc10_ in _loc9_)
                  {
                     _loc12_ = _loc11_.indexOf(_loc10_.id) != -1;
                     _loc3_.push({
                        "data":_loc10_,
                        "name":_loc10_.shortName,
                        "type":param2,
                        "label":_loc10_.shortName,
                        "selected":_loc12_,
                        "selectString":this.utilApi.noAccent(_loc10_.shortName).toLowerCase()
                     });
                  }
                  break;
               case DareCriteriaTypeEnum.IDOLS:
                  _loc9_ = this.dataApi.getAllIdols();
                  for each(_loc10_ in _loc9_)
                  {
                     _loc13_ = this.dataApi.getItemWrapper(_loc10_.itemId);
                     _loc12_ = _loc11_.indexOf(_loc10_.id) != -1;
                     _loc3_.push({
                        "data":_loc10_,
                        "tooltipData":_loc13_,
                        "name":_loc10_.name,
                        "type":param2,
                        "label":_loc10_.name,
                        "selected":_loc12_,
                        "selectString":_loc13_.undiatricalName
                     });
                  }
                  break;
               case DareCriteriaTypeEnum.CHALLENGE_ID:
                  _loc9_ = this.dataApi.getChallenges();
                  for each(_loc10_ in _loc9_)
                  {
                     if(_loc10_.dareAvailable)
                     {
                        _loc12_ = _loc11_.indexOf(_loc10_.id) != -1;
                        _loc3_.push({
                           "data":_loc10_,
                           "tooltipData":this.dataApi.getChallengeWrapper(_loc10_.id),
                           "name":_loc10_.name,
                           "type":param2,
                           "label":_loc10_.name,
                           "selected":_loc12_,
                           "selectString":this.utilApi.noAccent(_loc10_.name).toLowerCase()
                        });
                     }
                  }
                  break;
               default:
                  this.sysApi.log(16,"This criteria type is not supported for this searchMode yet!");
            }
         }
         if(_loc3_ && _loc3_.length)
         {
            this.utilApi.sortOnString(_loc3_,"name");
         }
         return _loc3_;
      }
      
      private function getSearchResultEntry(param1:int, param2:uint, param3:String) : Object
      {
         var _loc4_:Object = null;
         var _loc6_:int = 0;
         var _loc9_:int = 0;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Monster = null;
         var _loc16_:Array = null;
         var _loc17_:Challenge = null;
         var _loc18_:Array = null;
         var _loc19_:Array = null;
         var _loc20_:Array = null;
         var _loc5_:String = "";
         switch(param2)
         {
            case DareCriteriaTypeEnum.MONSTER_ID:
               _loc15_ = this.dataApi.getMonsterFromId(param1);
               if(!_loc15_.dareAvailable)
               {
                  return null;
               }
               _loc4_ = new Object();
               _loc4_.data = _loc15_;
               _loc4_.name = _loc4_.data.name;
               break;
            case DareCriteriaTypeEnum.CHALLENGE_ID:
               _loc16_ = this.getCriteriaParams(DareCriteriaTypeEnum.CHALLENGE_ID);
               if(_loc16_.indexOf(param1) != -1)
               {
                  return null;
               }
               _loc17_ = this.dataApi.getChallenge(param1);
               if(!_loc17_.dareAvailable)
               {
                  return null;
               }
               _loc4_ = new Object();
               _loc4_.data = _loc17_;
               _loc4_.name = _loc4_.data.name;
               break;
            case DareCriteriaTypeEnum.IDOLS:
               _loc18_ = this.getCriteriaParams(DareCriteriaTypeEnum.IDOLS);
               if(_loc18_.indexOf(param1) != -1)
               {
                  return null;
               }
               _loc4_ = new Object();
               _loc4_.data = this.dataApi.getIdol(param1);
               _loc4_.name = _loc4_.data.name;
               break;
            case DareCriteriaTypeEnum.FORBIDDEN_BREEDS:
               _loc19_ = this.getCriteriaParams(DareCriteriaTypeEnum.FORBIDDEN_BREEDS);
               if(_loc19_.indexOf(param1) != -1)
               {
                  return null;
               }
               _loc4_ = new Object();
               _loc4_.data = this.dataApi.getBreed(param1);
               _loc4_.name = _loc4_.data.name;
               break;
            case DareCriteriaTypeEnum.MANDATORY_BREEDS:
               _loc20_ = this.getCriteriaParams(DareCriteriaTypeEnum.MANDATORY_BREEDS);
               if(_loc20_.indexOf(param1) != -1)
               {
                  return null;
               }
               _loc4_ = new Object();
               _loc4_.data = this.dataApi.getBreed(param1);
               _loc4_.name = _loc4_.data.name;
               break;
         }
         _loc4_.type = param2;
         _loc4_.selected = false;
         var _loc7_:String = _loc4_.name.toLowerCase();
         var _loc8_:String = _loc4_.name;
         var _loc10_:int = _loc8_.length;
         var _loc11_:int = param3.length;
         _loc6_ = 0;
         while(_loc6_ < _loc10_)
         {
            _loc12_ = this.utilApi.noAccent(_loc7_.substring(_loc6_,_loc6_ + _loc11_));
            if(_loc12_ == param3)
            {
               _loc13_ = _loc6_ + _loc14_ * 7;
               _loc9_ = _loc13_ + _loc11_;
               _loc8_ = _loc8_.substring(0,_loc13_) + "<b>" + _loc8_.substring(_loc13_,_loc9_) + "</b>" + _loc8_.substring(_loc9_);
               _loc14_++;
            }
            _loc6_++;
         }
         _loc4_.label = _loc8_ + _loc5_;
         return _loc4_;
      }
      
      private function checkCriteria() : void
      {
         var _loc2_:Array = null;
         var _loc3_:DareCriteria = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:Challenge = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:Idol = null;
         var _loc14_:* = null;
         var _loc15_:Array = null;
         var _loc16_:Array = null;
         var _loc17_:Array = null;
         var _loc18_:int = 0;
         var _loc19_:Array = null;
         var _loc20_:Array = null;
         var _loc21_:Array = null;
         var _loc22_:Array = null;
         var _loc1_:* = "";
         this._criteriaOk = true;
         var _loc4_:Monster = this.getCriteriaMonster();
         for each(_loc5_ in this._criteria)
         {
            _loc1_ = "";
            if(_loc5_.params.length == 0)
            {
               _loc5_.warning = _loc1_;
            }
            else
            {
               this.sysApi.log(2," - " + _loc5_.type + " : " + _loc5_.params);
               if(_loc5_.type == DareCriteriaTypeEnum.CHALLENGE_ID)
               {
                  if(_loc5_.params[0] != 0)
                  {
                     if(_loc4_ && _loc4_.incompatibleChallenges.indexOf(_loc5_.params[0]) != -1)
                     {
                        _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.challengeMonster");
                        this._criteriaOk = false;
                     }
                     _loc7_ = this.dataApi.getChallenge(_loc5_.params[0]);
                     _loc8_ = this.getCriteriaParams(DareCriteriaTypeEnum.CHALLENGE_ID);
                     for each(_loc6_ in _loc8_)
                     {
                        if(_loc7_.incompatibleChallenges.indexOf(_loc6_) != -1)
                        {
                           if(_loc1_ != "")
                           {
                              _loc1_ = _loc1_ + "\n";
                           }
                           _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.challengesTogether");
                           this._criteriaOk = false;
                        }
                     }
                     _loc5_.warning = _loc1_;
                  }
               }
               else if(_loc5_.type == DareCriteriaTypeEnum.FORBIDDEN_BREEDS)
               {
                  if(_loc5_.params.length)
                  {
                     _loc9_ = this.getCriteriaParams(DareCriteriaTypeEnum.MANDATORY_BREEDS);
                     for each(_loc10_ in _loc5_.params)
                     {
                        if(_loc10_ > 0 && _loc9_.indexOf(_loc10_) != -1)
                        {
                           _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.classMandatoryForbidden");
                           this._criteriaOk = false;
                           break;
                        }
                     }
                     _loc5_.warning = _loc1_;
                  }
               }
               else if(_loc5_.type == DareCriteriaTypeEnum.MANDATORY_BREEDS)
               {
                  if(_loc5_.params.length)
                  {
                     _loc11_ = this.getCriteriaParams(DareCriteriaTypeEnum.FORBIDDEN_BREEDS);
                     for each(_loc10_ in _loc5_.params)
                     {
                        if(_loc10_ > 0 && _loc11_.indexOf(_loc10_) != -1)
                        {
                           _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.classMandatoryForbidden");
                           this._criteriaOk = false;
                           break;
                        }
                     }
                     _loc12_ = this.getCriteriaParams(DareCriteriaTypeEnum.MAX_COUNT_CHAR);
                     if(_loc12_.length && _loc5_.params.length > _loc12_[0])
                     {
                        if(_loc1_ != "")
                        {
                           _loc1_ = _loc1_ + "\n";
                        }
                        _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.countCharMaxMandatory");
                        this._criteriaOk = false;
                     }
                     _loc5_.warning = _loc1_;
                  }
               }
               else if(_loc5_.type == DareCriteriaTypeEnum.IDOLS)
               {
                  _loc14_ = "";
                  _loc15_ = new Array();
                  if(_loc5_.params.length)
                  {
                     for each(_loc18_ in _loc5_.params)
                     {
                        if(_loc18_ > 0)
                        {
                           _loc15_.push(this.dataApi.getIdol(_loc18_));
                        }
                     }
                  }
                  _loc2_ = this.getCriteriaParams(DareCriteriaTypeEnum.MAX_COUNT_CHAR);
                  if(_loc2_ && _loc2_.length && _loc2_[0] <= ProtocolConstantsEnum.MIN_PLAYERS_FOR_GROUP_IDOLS)
                  {
                     _loc14_ = "";
                     for each(_loc13_ in _loc15_)
                     {
                        if(_loc13_.groupOnly)
                        {
                           _loc14_ = _loc14_ + _loc13_.name;
                           _loc14_ = _loc14_ + ", ";
                        }
                     }
                     if(_loc14_ != "")
                     {
                        _loc14_ = _loc14_.slice(0,_loc14_.length - 2);
                        _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.groupIdol",_loc14_);
                        this._criteriaOk = false;
                     }
                  }
                  if(_loc4_ && this.MONSTERS_INCOMPATIBLE_WITH_GROUP_IDOLS.indexOf(_loc4_.id) != -1)
                  {
                     _loc14_ = "";
                     for each(_loc13_ in _loc15_)
                     {
                        if(_loc13_.groupOnly)
                        {
                           _loc14_ = _loc14_ + _loc13_.name;
                           _loc14_ = _loc14_ + ", ";
                        }
                     }
                     if(_loc14_ != "")
                     {
                        _loc14_ = _loc14_.slice(0,_loc14_.length - 2);
                        if(_loc1_ != "")
                        {
                           _loc1_ = _loc1_ + "\n";
                        }
                        _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.monsterIdol",_loc14_);
                        this._criteriaOk = false;
                     }
                  }
                  if(this._incompatibleIdolsForThisMonster.indexOf(-1) != -1)
                  {
                     if(_loc1_ != "")
                     {
                        _loc1_ = _loc1_ + "\n";
                     }
                     _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.monsterNoIdol");
                     this._criteriaOk = false;
                  }
                  _loc14_ = "";
                  for each(_loc13_ in _loc15_)
                  {
                     if(this._incompatibleIdolsForThisMonster.indexOf(_loc13_.id) != -1)
                     {
                        _loc14_ = _loc14_ + _loc13_.name;
                        _loc14_ = _loc14_ + ", ";
                     }
                  }
                  if(_loc14_ != "")
                  {
                     if(_loc1_ != "")
                     {
                        _loc1_ = _loc1_ + "\n";
                     }
                     _loc14_ = _loc14_.slice(0,_loc14_.length - 2);
                     _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.monsterIdol",_loc14_);
                     this._criteriaOk = false;
                  }
                  _loc16_ = this.getCriteriaParams(DareCriteriaTypeEnum.MAX_CHAR_LVL);
                  if(_loc16_ && _loc16_.length && _loc16_[0] > 0 && _loc16_[0] < 200)
                  {
                     _loc14_ = "";
                     for each(_loc13_ in _loc15_)
                     {
                        if(_loc13_.item.level > _loc16_[0])
                        {
                           _loc14_ = _loc14_ + _loc13_.name;
                           _loc14_ = _loc14_ + ", ";
                        }
                     }
                     if(_loc14_ != "")
                     {
                        _loc14_ = _loc14_.slice(0,_loc14_.length - 2);
                        if(_loc1_ != "")
                        {
                           _loc1_ = _loc1_ + "\n";
                        }
                        _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.idolMaxLevel",_loc14_);
                        this._criteriaOk = false;
                     }
                  }
                  _loc17_ = this.getCriteriaParams(DareCriteriaTypeEnum.IDOLS_SCORE);
                  if(_loc17_ && _loc17_.length && _loc17_[0] > 0)
                  {
                     if(_loc1_ != "")
                     {
                        _loc1_ = _loc1_ + "\n";
                     }
                     _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.idolsScore");
                     this._criteriaOk = false;
                  }
                  _loc5_.warning = _loc1_;
               }
               else if(_loc5_.type == DareCriteriaTypeEnum.IDOLS_SCORE)
               {
                  if(_loc5_.params[0] != 0)
                  {
                     for each(_loc3_ in this._criteriaTypeData)
                     {
                        if(_loc3_.id == _loc5_.type)
                        {
                           if(_loc3_.minParameterBound > _loc5_.params[0] || _loc3_.maxParameterBound < _loc5_.params[0])
                           {
                              _loc1_ = _loc1_ + (_loc3_.name + this.uiApi.getText("ui.common.colon") + this.uiApi.getText("ui.jobs.collectSkillInfos",_loc3_.minParameterBound,_loc3_.maxParameterBound));
                              this._criteriaOk = false;
                           }
                           break;
                        }
                     }
                     _loc19_ = this.getCriteriaParams(DareCriteriaTypeEnum.IDOLS);
                     if(_loc19_ && _loc19_.length)
                     {
                        if(_loc1_ != "")
                        {
                           _loc1_ = _loc1_ + "\n";
                        }
                        _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.idolsScore");
                        this._criteriaOk = false;
                     }
                     _loc5_.warning = _loc1_;
                  }
               }
               else if(_loc5_.type == DareCriteriaTypeEnum.MAX_COUNT_CHAR)
               {
                  if(_loc5_.params[0] != 0)
                  {
                     for each(_loc3_ in this._criteriaTypeData)
                     {
                        if(_loc3_.id == _loc5_.type)
                        {
                           if(_loc3_.minParameterBound > _loc5_.params[0] || _loc3_.maxParameterBound < _loc5_.params[0])
                           {
                              _loc1_ = _loc1_ + (_loc3_.name + this.uiApi.getText("ui.common.colon") + this.uiApi.getText("ui.jobs.collectSkillInfos",_loc3_.minParameterBound,_loc3_.maxParameterBound));
                              this._criteriaOk = false;
                           }
                           break;
                        }
                     }
                     _loc20_ = this.getCriteriaParams(DareCriteriaTypeEnum.MIN_COUNT_CHAR);
                     if(_loc20_ && _loc20_.length && _loc20_[0] > 0 && _loc20_[0] > _loc5_.params[0])
                     {
                        if(_loc1_ != "")
                        {
                           _loc1_ = _loc1_ + "\n";
                        }
                        _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.countCharMaxToMin");
                        this._criteriaOk = false;
                     }
                     _loc21_ = this.getCriteriaParams(DareCriteriaTypeEnum.MANDATORY_BREEDS);
                     if(_loc21_ && _loc5_.params[0] < _loc21_.length)
                     {
                        if(_loc1_ != "")
                        {
                           _loc1_ = _loc1_ + "\n";
                        }
                        _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.countCharMaxMandatory");
                        this._criteriaOk = false;
                     }
                     _loc22_ = this.getCriteriaParams(DareCriteriaTypeEnum.MIN_COUNT_MONSTERS);
                     if(_loc22_ && _loc22_.length && _loc22_[0] > 0 && _loc22_[0] > _loc5_.params[0])
                     {
                        if(_loc1_ != "")
                        {
                           _loc1_ = _loc1_ + "\n";
                        }
                        _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.countCharMonster");
                        this._criteriaOk = false;
                     }
                     _loc5_.warning = _loc1_;
                  }
               }
               else if(_loc5_.type == DareCriteriaTypeEnum.MIN_COUNT_CHAR)
               {
                  if(_loc5_.params[0] != 0)
                  {
                     for each(_loc3_ in this._criteriaTypeData)
                     {
                        if(_loc3_.id == _loc5_.type)
                        {
                           if(_loc3_.minParameterBound > _loc5_.params[0] || _loc3_.maxParameterBound < _loc5_.params[0])
                           {
                              _loc1_ = _loc1_ + (_loc3_.name + this.uiApi.getText("ui.common.colon") + this.uiApi.getText("ui.jobs.collectSkillInfos",_loc3_.minParameterBound,_loc3_.maxParameterBound));
                              this._criteriaOk = false;
                           }
                           break;
                        }
                     }
                     _loc2_ = this.getCriteriaParams(DareCriteriaTypeEnum.MAX_COUNT_CHAR);
                     if(_loc2_ && _loc2_.length && _loc2_[0] > 0 && _loc2_[0] < _loc5_.params[0])
                     {
                        if(_loc1_ != "")
                        {
                           _loc1_ = _loc1_ + "\n";
                        }
                        _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.countCharMaxToMin");
                        this._criteriaOk = false;
                     }
                     _loc5_.warning = _loc1_;
                  }
               }
               else if(_loc5_.type == DareCriteriaTypeEnum.MIN_COUNT_MONSTERS)
               {
                  if(_loc5_.params[0] != 0)
                  {
                     for each(_loc3_ in this._criteriaTypeData)
                     {
                        if(_loc3_.id == _loc5_.type)
                        {
                           if(_loc3_.minParameterBound > _loc5_.params[0] || _loc3_.maxParameterBound < _loc5_.params[0])
                           {
                              _loc1_ = _loc1_ + (_loc3_.name + this.uiApi.getText("ui.common.colon") + this.uiApi.getText("ui.jobs.collectSkillInfos",_loc3_.minParameterBound,_loc3_.maxParameterBound));
                              this._criteriaOk = false;
                           }
                           break;
                        }
                     }
                     _loc2_ = this.getCriteriaParams(DareCriteriaTypeEnum.MAX_COUNT_CHAR);
                     if(_loc2_ && _loc2_.length && _loc2_[0] > 0 && _loc2_[0] < _loc5_.params[0])
                     {
                        if(_loc1_ != "")
                        {
                           _loc1_ = _loc1_ + "\n";
                        }
                        _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.countCharMonster");
                        this._criteriaOk = false;
                     }
                     if(_loc4_ && (_loc4_.isBoss || this.MONSTERS_INCOMPATIBLE_WITH_MIN_MONSTER_COUNT.indexOf(_loc4_.id) != -1))
                     {
                        if(_loc1_ != "")
                        {
                           _loc1_ = _loc1_ + "\n";
                        }
                        _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.monsterNoMinMonsterCount");
                        this._criteriaOk = false;
                     }
                     _loc5_.warning = _loc1_;
                  }
               }
               else if(_loc5_.type == DareCriteriaTypeEnum.MAX_CHAR_LVL || _loc5_.type == DareCriteriaTypeEnum.MAX_FIGHT_TURNS)
               {
                  if(_loc5_.params[0] != 0)
                  {
                     for each(_loc3_ in this._criteriaTypeData)
                     {
                        if(_loc3_.id == _loc5_.type)
                        {
                           if(_loc3_.minParameterBound > _loc5_.params[0] || _loc3_.maxParameterBound < _loc5_.params[0])
                           {
                              _loc1_ = _loc1_ + (_loc3_.name + this.uiApi.getText("ui.common.colon") + this.uiApi.getText("ui.jobs.collectSkillInfos",_loc3_.minParameterBound,_loc3_.maxParameterBound));
                              this._criteriaOk = false;
                           }
                           break;
                        }
                     }
                     if(_loc5_.type == DareCriteriaTypeEnum.MAX_FIGHT_TURNS && (_loc4_ && this.MONSTERS_INCOMPATIBLE_WITH_MAX_FIGHT_TURNS.indexOf(_loc4_.id) != -1))
                     {
                        if(_loc1_ != "")
                        {
                           _loc1_ = _loc1_ + "\n";
                        }
                        _loc1_ = _loc1_ + this.uiApi.getText("ui.dare.criteria.error.monsterNoMaxTurn");
                        this._criteriaOk = false;
                     }
                     _loc5_.warning = _loc1_;
                  }
               }
            }
         }
         this.updateValidationButton();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:EmblemWrapper = null;
         var _loc7_:EmblemWrapper = null;
         var _loc8_:EmblemSymbol = null;
         var _loc9_:AllianceWrapper = null;
         var _loc10_:GuildWrapper = null;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         if(param1 != this.gd_searchResult && (param2 == SelectMethodEnum.DOUBLE_CLICK || param2 == SelectMethodEnum.CLICK))
         {
            this.clearSearchResults();
         }
         if(param1 == this.cb_restriction)
         {
            _loc5_ = this.cb_restriction.selectedItem.id;
            if(_loc5_ == 0)
            {
               this._isForGuild = false;
               this._isForAlliance = false;
            }
            else if(_loc5_ == 1)
            {
               this._isForGuild = false;
               this._isForAlliance = true;
            }
            else if(_loc5_ == 2)
            {
               this._isForGuild = true;
               this._isForAlliance = false;
            }
            if(_loc5_ == 1 || _loc5_ == 2)
            {
               if(_loc5_ == 1)
               {
                  _loc9_ = this.socialApi.getAlliance();
                  _loc6_ = _loc9_.backEmblem;
                  _loc7_ = _loc9_.upEmblem;
               }
               else
               {
                  _loc10_ = this.socialApi.getGuild();
                  _loc6_ = _loc10_.backEmblem;
                  _loc7_ = _loc10_.upEmblem;
               }
               this.tx_emblemBack.uri = _loc6_.iconUri;
               this.tx_emblemUp.uri = _loc7_.iconUri;
               this.utilApi.changeColor(this.tx_emblemBack,_loc6_.color,1);
               _loc8_ = this.dataApi.getEmblemSymbol(_loc7_.idEmblem);
               if(_loc8_.colorizable)
               {
                  this.utilApi.changeColor(this.tx_emblemUp,_loc7_.color,0);
               }
               else
               {
                  this.utilApi.changeColor(this.tx_emblemUp,_loc7_.color,0,true);
               }
               this.ctr_guildalliance.visible = true;
            }
            else
            {
               this.ctr_guildalliance.visible = false;
            }
            return;
         }
         if(param1 == this.gd_searchResult)
         {
            _loc11_ = param1.selectedItem;
            if(param2 == SelectMethodEnum.DOUBLE_CLICK || param2 == SelectMethodEnum.CLICK)
            {
               this.clearSearchResults();
               this.sysApi.log(2,"click sur " + _loc11_.name + " : index " + this._currentCritLineIndex + ", type " + this._currentSearchCriteriaType + ", id " + _loc11_.data.id + ", dernier param " + this._criteria[this._currentCritLineIndex].lastModifiedParam);
               _loc12_ = -1;
               if(_loc11_.selected)
               {
                  _loc13_ = 0;
                  while(_loc13_ < this._criteria[this._currentCritLineIndex].params.length)
                  {
                     _loc12_ = this._criteria[this._currentCritLineIndex].params.indexOf(_loc11_.data.id);
                     if(_loc12_ != -1)
                     {
                        break;
                     }
                     _loc13_++;
                  }
               }
               this.modifyDareCriteriaParam(this._currentCritLineIndex,this._currentSearchCriteriaType,_loc12_ == -1?int(_loc11_.data.id):0,_loc12_);
               if(this._currentSearchCriteriaType == DareCriteriaTypeEnum.CHALLENGE_ID)
               {
                  this._currentSearchInput.text = _loc11_.data.name;
               }
               else if(this._currentSearchCriteriaType != DareCriteriaTypeEnum.MONSTER_ID)
               {
                  _loc14_ = this._criteriaDataProviderIndexByCriteriaIndex[this._currentCritLineIndex];
                  _loc15_ = this.gd_criteria.dataProvider[_loc14_].params.length;
                  if(_loc15_ != this._criteria[this._currentCritLineIndex].lastModifiedParamIndex + 1)
                  {
                     this._currentSearchInput.text = "";
                     this._currentSearchInput.focus();
                  }
                  else if(_loc15_ > 1)
                  {
                     this._currentSearchInput.text = this.INPUT_SEARCH_TEXT;
                     this._currentSearchInput.caretIndex = -1;
                     param1.focus();
                  }
               }
            }
            else if(param2 == SelectMethodEnum.MANUAL || param2 == SelectMethodEnum.AUTO)
            {
               this._addEntryHighlight = true;
               this.gd_searchResult.updateItem(param1.selectedIndex);
            }
         }
         else if(param1.name.indexOf("gd_data") != -1)
         {
            _loc4_ = this._gridComponents[param1.name];
            if(this._criteria[_loc4_.index])
            {
               this._criteria[_loc4_.index].lastModifiedParamIndex = param1.selectedIndex;
            }
            this.sysApi.log(32,"clic sur " + param1.name + " sur la case " + param1.selectedIndex);
            if(param2 == SelectMethodEnum.DOUBLE_CLICK || param2 == SelectMethodEnum.CLICK)
            {
               this.modifyDareCriteriaParam(_loc4_.index,_loc4_.criteria.id,0,param1.selectedIndex);
            }
         }
         else if(param1.name.indexOf("gd_slots") != -1)
         {
            _loc4_ = this._gridComponents[param1.name];
            if(this._criteria[_loc4_.index])
            {
               this._criteria[_loc4_.index].lastModifiedParamIndex = param1.selectedIndex;
            }
            this.sysApi.log(32,"clic sur " + param1.name + " sur la case " + param1.selectedIndex);
            if(param2 == SelectMethodEnum.DOUBLE_CLICK || param2 == SelectMethodEnum.CLICK)
            {
               this.modifyDareCriteriaParam(_loc4_.index,_loc4_.criteria.id,0,param1.selectedIndex);
            }
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Vector.<Vector.<int>> = null;
         var _loc4_:Object = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         if(param1 != this._currentSearchInput)
         {
            this.clearSearchResults();
         }
         if(param1 == this.btn_valid)
         {
            this.sysApi.log(2,"Validation de la création d\'un défi !");
            this.sysApi.log(2,"  Cagnotte " + this._jackpot + ", frais " + this._subscriptionFee + ", gagnants " + this._maxCountWinners + ", durée " + this._duration + ", début dans " + this._delayBeforeStart + " jours, privé " + this._isPrivate + ", reservé guilde " + this._isForGuild + ", reservé alliance " + this._isForAlliance + ",  notif " + this._needNotifications);
            _loc3_ = new Vector.<Vector.<int>>();
            for each(_loc4_ in this._criteria)
            {
               _loc5_ = new Vector.<int>();
               this.sysApi.log(2,"     - Critere " + _loc4_.type + " : " + _loc4_.params);
               _loc5_.push(_loc4_.type);
               for each(_loc6_ in _loc4_.params)
               {
                  _loc5_.push(_loc6_);
               }
               _loc3_.push(_loc5_);
            }
            this.sysApi.sendAction(new DareCreationRequest(this._jackpot,this._subscriptionFee,this._maxCountWinners,this._delayBeforeStart * this.DAYS_TO_SECONDS + this._delayBeforeStartH * this.HOURS_TO_SECONDS,this._duration * this.DAYS_TO_SECONDS + this._durationH * this.HOURS_TO_SECONDS,this._isPrivate,this._isForGuild,this._isForAlliance,this._needNotifications,_loc3_));
         }
         else if(param1 == this.btn_isPrivate)
         {
            this._isPrivate = this.btn_isPrivate.selected;
         }
         else if(param1 == this.btn_needNotifications)
         {
            this._needNotifications = this.btn_needNotifications.selected;
         }
         else if(param1 == this.inp_monster)
         {
            this.updateInputStates(this.inp_monster);
         }
         else if(param1 == this.btn_closeMonster)
         {
            this.inp_monster.text = this.INPUT_SEARCH_TEXT;
            this._currentCritLineIndex = 0;
            this.clearSearchResults();
            this.modifyDareCriteriaParam(0,DareCriteriaTypeEnum.MONSTER_ID,0);
         }
         else if(param1.name.indexOf("inp_search") != -1)
         {
            this.updateInputStates(param1 as Input);
            this.searchAll(param1.text,this._currentSearchCriteriaType);
         }
         else if(param1.name.indexOf("tx_type") != -1)
         {
            _loc2_ = this._gridComponents[param1.name];
            if(!_loc2_)
            {
               return;
            }
            if(_loc2_.id == 0)
            {
               return;
            }
            if(!_loc2_.selected)
            {
               if(this._criteria.length < ProtocolConstantsEnum.MAX_CRITERION_BY_DARE)
               {
                  this.addDareCriteria(this._criteria.length,_loc2_.id);
               }
            }
            else
            {
               if(this.ctr_search.visible)
               {
                  this.ctr_search.visible = false;
                  clearTimeout(this._searchTimeoutId);
               }
               _loc7_ = 0;
               for each(_loc8_ in this._criteria)
               {
                  if(_loc8_.type == _loc2_.id)
                  {
                     break;
                  }
                  _loc7_++;
               }
               this.removeDareCriteria(_loc7_);
            }
         }
      }
      
      private function updateInputStates(param1:Input) : void
      {
         var _loc2_:Boolean = true;
         var _loc3_:Object = this._gridComponents[param1.name];
         if(this._currentSearchInput)
         {
            if(this._currentSearchInput == this.inp_monster)
            {
               if(this._chosenMonsterName)
               {
                  _loc2_ = false;
                  this._currentSearchInput.text = this._chosenMonsterName;
               }
            }
            else if(this._currentSearchCriteriaType == DareCriteriaTypeEnum.CHALLENGE_ID)
            {
               if(this._criteria[this._currentCritLineIndex] && this._criteria[this._currentCritLineIndex].params.length)
               {
                  if(this._gridComponents[this._currentSearchInput.name] && this._gridComponents[this._currentSearchInput.name].params && this._gridComponents[this._currentSearchInput.name].params.length && this._gridComponents[this._currentSearchInput.name].params[0])
                  {
                     _loc2_ = false;
                     this._currentSearchInput.text = this._gridComponents[this._currentSearchInput.name].params[0].name;
                  }
               }
            }
            if(this._currentSearchInput != param1)
            {
               if(_loc2_)
               {
                  this._currentSearchInput.text = this.INPUT_SEARCH_TEXT;
                  this.clearSearchResults();
               }
            }
         }
         this._currentSearchInput = param1;
         if(this._currentSearchInput.text == this.INPUT_SEARCH_TEXT)
         {
            this._currentSearchInput.text = "";
         }
         if(_loc3_)
         {
            this._currentCritLineIndex = _loc3_.index;
            this._currentSearchCriteriaType = _loc3_.criteria.id;
         }
         else
         {
            this._currentCritLineIndex = 0;
            this._currentSearchCriteriaType = DareCriteriaTypeEnum.MONSTER_ID;
         }
      }
      
      private function clearSearchResults() : void
      {
         if(this.ctr_search.visible)
         {
            clearTimeout(this._searchTimeoutId);
            this._searchCriteria = "";
            this._lastSearch = "";
            this.ctr_search.visible = false;
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:String = "";
         var _loc5_:String = "TextInfo";
         var _loc6_:Object = null;
         if(param1 == this.inp_jackpot)
         {
            if(this._notEnoughMoney)
            {
               _loc4_ = this.uiApi.getText("ui.dare.jackpot.notEnoughMoney");
            }
            else if(this._wrongJackpot)
            {
               _loc4_ = this.uiApi.getText("ui.dare.jackpot.wrongTotal",ProtocolConstantsEnum.MIN_DARE_JACKPOT_VALUE);
            }
            else
            {
               _loc4_ = this.uiApi.getText("ui.dare.info.jackpot");
            }
         }
         if(param1 == this.btn_isPrivate)
         {
            _loc4_ = this.uiApi.getText("ui.dare.info.privateCreation");
         }
         if(param1 == this.lbl_feeInfo)
         {
            _loc4_ = this.uiApi.getText("ui.dare.info.fees");
         }
         if(param1 == this.lbl_maxCountWinnersInfo)
         {
            _loc4_ = this.uiApi.getText("ui.dare.info.maxWinners");
         }
         if(param1 == this.lbl_durationInfo)
         {
            _loc4_ = this.uiApi.getText("ui.dare.info.duration");
         }
         if(param1 == this.lbl_delayBeforeStartInfo)
         {
            _loc4_ = this.uiApi.getText("ui.dare.info.timeBeforeStart");
         }
         if(param1 == this.cb_restriction && this.cb_restriction.softDisabled)
         {
            _loc4_ = this.uiApi.getText("ui.dare.info.restriction");
         }
         if(param1 == this.ctr_guildalliance)
         {
            if(this._isForGuild)
            {
               _loc4_ = this.socialApi.getGuild().guildName;
            }
            else if(this._isForAlliance)
            {
               _loc4_ = this.socialApi.getAlliance().allianceName;
            }
         }
         else if(param1.name.indexOf("ctr_breed") != -1)
         {
            _loc2_ = this._gridComponents[param1.name];
            if(_loc2_ && _loc2_.id > 0)
            {
               _loc4_ = _loc2_.name;
            }
         }
         else if(param1.name.indexOf("tx_warning") != -1)
         {
            _loc2_ = this._gridComponents[param1.name];
            if(_loc2_ && _loc2_.warning != "")
            {
               _loc4_ = _loc2_.warning;
            }
         }
         else if(param1.name.indexOf("tx_type") != -1)
         {
            _loc2_ = this._gridComponents[param1.name];
            if(_loc2_ && _loc2_.label != "")
            {
               _loc4_ = _loc2_.label;
               if(_loc2_.selected)
               {
                  _loc4_ = _loc4_ + ("\n" + this.uiApi.getText("ui.dare.deleteCriteria"));
               }
            }
         }
         else if(param1.name.indexOf("btn_result_m_gd_searchResult") == 0)
         {
            _loc2_ = this._gridComponents[param1.name];
            if(_loc2_ && _loc2_.hasOwnProperty("tooltipData"))
            {
               if(_loc2_.tooltipData is ItemWrapper)
               {
                  _loc6_ = this.tooltipApi.createItemSettings();
                  _loc6_.header = false;
                  _loc6_.averagePrice = false;
                  _loc6_.description = false;
                  _loc3_ = _loc2_.tooltipData;
                  _loc5_ = null;
               }
               else if(_loc2_.tooltipData is ChallengeWrapper)
               {
                  _loc6_ = {"effects":false};
                  _loc3_ = _loc2_.tooltipData;
                  _loc5_ = null;
               }
            }
         }
         if(_loc4_ != "" || _loc3_)
         {
            this.uiApi.showTooltip(!!_loc4_?this.uiApi.textTooltipInfo(_loc4_):_loc3_,param1,false,"standard",6,0,3,null,null,_loc6_,_loc5_);
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this._currentSearchInput && this._currentSearchInput.haveFocus && param2 != Keyboard.ENTER && param2 != Keyboard.UP && param2 != Keyboard.DOWN)
         {
            this._searchCriteria = param1.text;
            clearTimeout(this._searchTimeoutId);
            this._searchTimeoutId = setTimeout(this.searchAll,500,this._searchCriteria,this._currentSearchCriteriaType);
         }
      }
      
      public function onKeyDown(param1:Object, param2:uint) : void
      {
         var _loc3_:int = 0;
         if(this.ctr_search.visible && this._currentSearchInput && this._currentSearchInput.haveFocus && this.gd_searchResult.dataProvider.length > 0)
         {
            _loc3_ = this.gd_searchResult.selectedIndex;
            if(param2 == Keyboard.UP)
            {
               this._removeEntryHighlight = true;
               this.gd_searchResult.updateItem(_loc3_);
               _loc3_--;
               if(_loc3_ < 0)
               {
                  _loc3_ = 0;
               }
               this.gd_searchResult.selectedIndex = _loc3_;
            }
            else if(param2 == Keyboard.DOWN)
            {
               this._removeEntryHighlight = true;
               this.gd_searchResult.updateItem(_loc3_);
               _loc3_++;
               if(_loc3_ > this.gd_searchResult.dataProvider.length - 1)
               {
                  _loc3_ = this.gd_searchResult.dataProvider.length - 1;
               }
               this.gd_searchResult.selectedIndex = _loc3_;
            }
            else if(param2 == Keyboard.ENTER)
            {
               this.onSelectItem(this.gd_searchResult,SelectMethodEnum.CLICK,false);
            }
         }
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
         }
         else if(param1.name.indexOf("gd_data") != -1)
         {
            _loc3_ = this.uiApi.getText(param2.data.name);
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
      
      public function onChange(param1:GraphicContainer) : void
      {
         var _loc3_:Object = null;
         if(!(param1 as Input))
         {
            return;
         }
         var _loc2_:Number = this.utilApi.stringToKamas((param1 as Input).text,"");
         if(param1 == this.inp_jackpot)
         {
            if(_loc2_ > ProtocolConstantsEnum.MAX_KAMA || _loc2_ < 0)
            {
               _loc2_ = ProtocolConstantsEnum.MAX_KAMA;
               (param1 as Input).text = this.utilApi.kamasToString(_loc2_,"");
            }
            if(_loc2_ != this._jackpot)
            {
               this.checkPlayerFund(_loc2_);
            }
            this._jackpot = _loc2_;
         }
         else if(param1 == this.inp_fee)
         {
            if(_loc2_ > ProtocolConstantsEnum.MAX_KAMA || _loc2_ < 0)
            {
               _loc2_ = ProtocolConstantsEnum.MAX_KAMA;
               (param1 as Input).text = this.utilApi.kamasToString(_loc2_,"");
            }
            this._subscriptionFee = _loc2_;
         }
         else if(param1 == this.inp_maxCountWinners)
         {
            if(_loc2_ > ProtocolConstantsEnum.MAX_DARE_WINNERS || _loc2_ < 0)
            {
               _loc2_ = ProtocolConstantsEnum.MAX_DARE_WINNERS;
               (param1 as Input).text = this.utilApi.kamasToString(_loc2_,"");
            }
            this._maxCountWinners = _loc2_;
         }
         else if(param1 == this.inp_duration)
         {
            if(_loc2_ > ProtocolConstantsEnum.MAX_DARE_DURATION - 1 && this._durationH > 0)
            {
               _loc2_ = ProtocolConstantsEnum.MAX_DARE_DURATION - 1;
               (param1 as Input).text = "" + _loc2_;
            }
            else if(_loc2_ > ProtocolConstantsEnum.MAX_DARE_DURATION)
            {
               _loc2_ = ProtocolConstantsEnum.MAX_DARE_DURATION;
               (param1 as Input).text = "" + _loc2_;
            }
            this._duration = _loc2_;
            if(this._duration == 0 && this._durationH == 0)
            {
               this.inp_durationH.text = "1";
               this._durationH = 1;
            }
         }
         else if(param1 == this.inp_durationH)
         {
            if(_loc2_ > 23)
            {
               _loc2_ = 23;
               (param1 as Input).text = "" + _loc2_;
            }
            this._durationH = _loc2_;
            if(_loc2_ > 0 && this._duration == ProtocolConstantsEnum.MAX_DARE_DURATION)
            {
               this._duration = ProtocolConstantsEnum.MAX_DARE_DURATION - 1;
               this.inp_duration.text = "" + this._duration;
            }
            if(this._duration == 0 && this._durationH == 0)
            {
               this.inp_duration.text = "1";
               this._duration = 1;
            }
         }
         else if(param1 == this.inp_delayBeforeStart)
         {
            if(_loc2_ > ProtocolConstantsEnum.MAX_DARE_DURATION)
            {
               _loc2_ = ProtocolConstantsEnum.MAX_DARE_DURATION;
               (param1 as Input).text = "" + _loc2_;
            }
            this._delayBeforeStart = _loc2_;
         }
         else if(param1 == this.inp_delayBeforeStartH)
         {
            if(_loc2_ > 23)
            {
               _loc2_ = 23;
               (param1 as Input).text = "" + _loc2_;
            }
            this._delayBeforeStartH = _loc2_;
         }
         else if(param1.name.indexOf("inp_value") != -1)
         {
            _loc3_ = this._gridComponents[param1.name];
            if(_loc3_)
            {
               if(!this._criteria[_loc3_.index])
               {
                  return;
               }
               if(this._criteria[_loc3_.index].params.length == 0 && _loc2_ > 0 || this._criteria[_loc3_.index].params.length > 0 && _loc2_ != this._criteria[_loc3_.index].params[0])
               {
                  this._currentCritLineIndex = _loc3_.index;
                  this.modifyDareCriteriaParam(this._currentCritLineIndex,_loc3_.criteria.id,_loc2_);
               }
            }
         }
      }
      
      protected function checkPlayerFund(param1:int) : void
      {
         var _loc2_:int = this.playerApi.characteristics().kamas;
         var _loc3_:String = this.inp_jackpot.text;
         this._wrongJackpot = false;
         if(param1 < ProtocolConstantsEnum.MIN_DARE_JACKPOT_VALUE && param1 != 0)
         {
            if(this.inp_jackpot.cssClass != "redright")
            {
               this.inp_jackpot.cssClass = "redright";
               this.inp_jackpot.text = _loc3_;
            }
            this._wrongJackpot = true;
         }
         else if(param1 + ProtocolConstantsEnum.DARE_CREATION_TAX > _loc2_)
         {
            if(this.inp_jackpot.cssClass != "redright")
            {
               this.inp_jackpot.cssClass = "redright";
               this.inp_jackpot.text = _loc3_;
            }
            this._notEnoughMoney = true;
         }
         else
         {
            if(this.inp_jackpot.cssClass != "right")
            {
               this.inp_jackpot.cssClass = "right";
               this.inp_jackpot.text = _loc3_;
            }
            this._notEnoughMoney = false;
         }
         this.lbl_creationCost.text = this.utilApi.kamasToString(param1 + ProtocolConstantsEnum.DARE_CREATION_TAX,"");
         this.updateValidationButton();
      }
      
      protected function updateValidationButton() : void
      {
         if(this._notEnoughMoney || this._noMonsterSelected || !this._criteriaOk || this._wrongJackpot)
         {
            this.btn_valid.disabled = true;
         }
         else
         {
            this.btn_valid.disabled = false;
         }
      }
      
      public function onDareCreated(param1:Boolean, param2:Number = 0) : void
      {
         if(param1)
         {
            this._saveOnUnload = false;
            Social.getInstance().dareCreationStatus = null;
            Dare.getInstance().openSelectedTab(2,[param2.toString(),"searchFilterId"]);
         }
      }
      
      private function onGuildAllianceMembershipUpdated(param1:Boolean) : void
      {
         this._isForGuild = false;
         this._isForAlliance = false;
         var _loc2_:Boolean = this.socialApi.hasGuild();
         var _loc3_:Boolean = this.socialApi.hasAlliance();
         var _loc4_:Array = new Array();
         _loc4_.push({
            "id":0,
            "label":this.uiApi.getText("ui.dare.restriction.everyoneAllowed")
         });
         if(_loc3_)
         {
            _loc4_.push({
               "id":1,
               "label":this.uiApi.getText("ui.dare.restriction.alliance")
            });
         }
         if(_loc2_)
         {
            _loc4_.push({
               "id":2,
               "label":this.uiApi.getText("ui.dare.restriction.guild")
            });
         }
         this.cb_restriction.dataProvider = _loc4_;
         this.cb_restriction.value = this.cb_restriction.dataProvider[0];
         if(!_loc2_ && !_loc3_)
         {
            this.cb_restriction.softDisabled = true;
         }
         else
         {
            this.cb_restriction.softDisabled = false;
         }
      }
   }
}
