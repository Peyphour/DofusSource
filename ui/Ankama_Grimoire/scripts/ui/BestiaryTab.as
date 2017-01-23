package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.datacenter.monsters.MonsterDrop;
   import com.ankamagames.dofus.datacenter.monsters.MonsterGrade;
   import com.ankamagames.dofus.datacenter.monsters.MonsterMiniBoss;
   import com.ankamagames.dofus.datacenter.monsters.MonsterRace;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.PartyMemberWrapper;
   import com.ankamagames.dofus.uiApi.AveragePricesApi;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PartyApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.components.GridItemSelectMethodEnum;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.FocusChange;
   import d2hooks.KeyUp;
   import d2hooks.MouseShiftClick;
   import d2hooks.OpenBook;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   
   public class BestiaryTab
   {
      
      private static var CTR_CAT_TYPE_CAT:String = "ctr_cat";
      
      private static var CTR_CAT_TYPE_SUBCAT:String = "ctr_subCat";
      
      private static var CTR_MONSTER_BASE:String = "ctr_monster";
      
      private static var CTR_MONSTER_AREAS:String = "ctr_subareas";
      
      private static var CTR_MONSTER_DETAILS:String = "ctr_details";
      
      private static var CTR_MONSTER_DROPS:String = "ctr_drops";
      
      private static var CAT_TYPE_AREA:int = 0;
      
      private static var CAT_TYPE_RACE:int = 1;
      
      private static var NB_DROP_PER_LINE:int = 12;
      
      private static var AREA_LINE_HEIGHT:int;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var menuApi:ContextMenuApi;
      
      public var averagePricesApi:AveragePricesApi;
      
      public var partyApi:PartyApi;
      
      public var roleplayApi:RoleplayApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      [Module(name="Ankama_Cartography")]
      public var modCartography:Object;
      
      private var _currentCategoryType:int;
      
      private var _openCatIndex:int;
      
      private var _currentSelectedCatId:int;
      
      private var _selectedMonsterId:int;
      
      private var _selectedAndOpenedMonsterId:int;
      
      private var _uriRareDrop:String;
      
      private var _uriOkDrop:String;
      
      private var _uriSpecialSlot:String;
      
      private var _uriEmptySlot:String;
      
      private var _uriStatPicto:String;
      
      private var _uriMonsterSprite:String;
      
      private var _lastRaceSelected:Object;
      
      private var _lastAreaSelected:Object;
      
      private var _categoriesRace:Array;
      
      private var _categoriesArea:Array;
      
      private var _monstersListToDisplay:Array;
      
      private var _monstersDataById:Dictionary;
      
      private var _lockSearchTimer:Timer;
      
      private var _previousSearchCriteria:String;
      
      private var _searchCriteria:String;
      
      private var _forceOpenMonster:Boolean;
      
      private var _currentScrollValue:int;
      
      private var _mapPopup:String;
      
      private var _ctrBtnMonsterLocation:Dictionary;
      
      private var _ctrBtnMonster:Dictionary;
      
      private var _ctrSlotDrop:Dictionary;
      
      private var _ctrTxLink:Dictionary;
      
      private var _progressPopupName:String;
      
      private var _searchSettimoutId:uint;
      
      private var _searchTextByCriteriaList:Dictionary;
      
      private var _searchResultByCriteriaList:Dictionary;
      
      private var _searchOnName:Boolean;
      
      private var _searchOnDrop:Boolean;
      
      private var _currentIdols:Vector.<int>;
      
      private var _btn_searchFilter_flag:Boolean = false;
      
      public var gd_categories:Grid;
      
      public var gd_monsters:Grid;
      
      public var inp_search:Input;
      
      public var tx_inputBg_search:TextureBitmap;
      
      public var btn_resetSearch:ButtonContainer;
      
      public var btn_searchFilter:ButtonContainer;
      
      public var btn_races:ButtonContainer;
      
      public var btn_subareas:ButtonContainer;
      
      public var btn_displayCriteriaDrop:ButtonContainer;
      
      public var lbl_noMonster:Label;
      
      private var _inc_monsterRender:int;
      
      public var btn_close:ButtonContainer;
      
      public function BestiaryTab()
      {
         this._categoriesRace = new Array();
         this._categoriesArea = new Array();
         this._monstersListToDisplay = new Array();
         this._monstersDataById = new Dictionary(true);
         this._ctrBtnMonsterLocation = new Dictionary(true);
         this._ctrBtnMonster = new Dictionary(true);
         this._ctrSlotDrop = new Dictionary(true);
         this._ctrTxLink = new Dictionary(true);
         this._searchTextByCriteriaList = new Dictionary(true);
         this._searchResultByCriteriaList = new Dictionary(true);
         this._currentIdols = new Vector.<int>();
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         this.sysApi.addHook(OpenBook,this.onOpenBestiary);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.uiApi.addComponentHook(this.gd_categories,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.btn_searchFilter,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_searchFilter,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_searchFilter,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.btn_displayCriteriaDrop,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_RELEASE);
         this.uiApi.addShortcutHook("closeUi",this.onShortCut);
         this.sysApi.addHook(FocusChange,this.onFocusChange);
         this._lockSearchTimer = new Timer(500,1);
         this._lockSearchTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
         AREA_LINE_HEIGHT = int(this.uiApi.me().getConstant("area_line_height"));
         this._uriStatPicto = this.uiApi.me().getConstant("picto_uri");
         this._uriMonsterSprite = this.uiApi.me().getConstant("monsterSprite_uri");
         this._uriSpecialSlot = this.uiApi.me().getConstant("slot") + "specialSlot.png";
         this._uriEmptySlot = this.uiApi.me().getConstant("slot") + "emptySlot.png";
         this._uriRareDrop = this.uiApi.me().getConstant("slot") + "rareSlot.png";
         this._uriOkDrop = this.uiApi.me().getConstant("slot") + "averageSlot.png";
         this._searchTextByCriteriaList["_searchOnName"] = this.uiApi.getText("ui.common.name");
         this._searchTextByCriteriaList["_searchOnDrop"] = this.uiApi.getText("ui.common.loot");
         this._categoriesArea = Grimoire.getInstance().monsterAreas;
         this._categoriesRace = Grimoire.getInstance().monsterRaces;
         var _loc2_:SubArea = this.playerApi.currentSubArea();
         var _loc3_:int = _loc2_.areaId;
         for each(_loc5_ in this._categoriesArea)
         {
            if(_loc5_.realId == _loc3_)
            {
               for each(_loc7_ in _loc5_.subcats)
               {
                  if(_loc7_.realId == _loc2_.id)
                  {
                     _loc4_ = _loc7_;
                  }
               }
            }
         }
         this._lastAreaSelected = _loc4_;
         this._lastRaceSelected = this._categoriesRace[0];
         this.btn_displayCriteriaDrop.selected = Grimoire.getInstance().bestiaryDisplayCriteriaDrop;
         this._searchOnDrop = Grimoire.getInstance().bestiarySearchOnDrop;
         this._searchOnName = Grimoire.getInstance().bestiarySearchOnName;
         _loc6_ = 0;
         if(param1 && param1.monsterId)
         {
            _loc6_ = param1.monsterId;
         }
         if(param1 && param1.monsterIdsList)
         {
            if(param1.monsterSearch)
            {
               this.inp_search.text = param1.monsterSearch;
               this._searchOnDrop = true;
               this._searchOnName = false;
            }
            for each(_loc8_ in param1.monsterIdsList)
            {
               this._monstersListToDisplay.push(_loc8_);
            }
         }
         if(_loc6_ > 0)
         {
            this._selectedMonsterId = _loc6_;
            this._forceOpenMonster = true;
            this.onOpenBestiary("bestiaryTab",{
               "forceOpen":true,
               "monsterId":this._selectedMonsterId
            });
         }
         else
         {
            this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_subareas,this.uiApi.me());
            this.btn_subareas.selected = true;
            this.gd_categories.dataProvider = this._categoriesArea;
            this.displayCategories(_loc4_,true);
         }
      }
      
      public function unload() : void
      {
         this._lockSearchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
         this._lockSearchTimer.stop();
         this._lockSearchTimer = null;
         this.uiApi.unloadUi(this._mapPopup);
      }
      
      public function updateCategory(param1:*, param2:*, param3:Boolean, param4:uint) : void
      {
         switch(this.getCatLineType(param1,param4))
         {
            case CTR_CAT_TYPE_CAT:
               if(this._openCatIndex == param1.id)
               {
                  param2.tx_catplusminus.uri = this.uiApi.createUri(this.uiApi.me().getConstant("minusUri"));
               }
               else
               {
                  param2.tx_catplusminus.uri = this.uiApi.createUri(this.uiApi.me().getConstant("plusUri"));
               }
            case CTR_CAT_TYPE_SUBCAT:
               param2.lbl_catName.text = param1.name;
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
               if(param1 && param1.parentId == 0)
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
      
      public function updateMonsterSubarea(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            if(!this._ctrBtnMonsterLocation[param2.btn_loc.name])
            {
               this.uiApi.addComponentHook(param2.btn_loc,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.btn_loc,ComponentHookList.ON_ROLL_OUT);
               this.uiApi.addComponentHook(param2.btn_loc,ComponentHookList.ON_RELEASE);
            }
            this._ctrBtnMonsterLocation[param2.btn_loc.name] = param1;
            param2.lbl_subarea.text = this.dataApi.getArea(param1.areaId).name + " - " + param1.name;
            param2.btn_loc.visible = true;
         }
         else
         {
            param2.lbl_subarea.text = "";
            param2.btn_loc.visible = false;
         }
      }
      
      public function updateMonsterStatLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_text.text = param1.text;
            param2.tx_caracIcon.uri = param1.icon;
            param2.lbl_value.text = param1.value;
         }
         else
         {
            param2.lbl_text.text = "";
            param2.lbl_value.text = "";
            param2.tx_caracIcon.uri = null;
         }
      }
      
      public function updateMonsterResistLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_text.text = param1.element;
            param2.lbl_value.text = param1.text;
            param2.tx_picto.uri = this.uiApi.createUri(this._uriStatPicto + param1.gfxId);
         }
         else
         {
            param2.lbl_text.text = "";
            param2.lbl_value.text = "";
            param2.tx_picto.uri = null;
         }
      }
      
      public function updateMonster(param1:*, param2:*, param3:Boolean, param4:uint) : void
      {
         var _loc5_:Monster = null;
         var _loc6_:MonsterGrade = null;
         var _loc7_:MonsterGrade = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Array = null;
         var _loc22_:Array = null;
         var _loc23_:int = 0;
         var _loc24_:Object = null;
         var _loc25_:Object = null;
         var _loc26_:int = 0;
         var _loc27_:SubArea = null;
         var _loc28_:String = null;
         var _loc29_:String = null;
         var _loc30_:int = 0;
         var _loc31_:Object = null;
         var _loc32_:MonsterDrop = null;
         var _loc33_:ItemWrapper = null;
         var _loc34_:Object = null;
         switch(this.getMonsterLineType(param1,param4))
         {
            case CTR_MONSTER_BASE:
               this.uiApi.addComponentHook(param2.tx_boss,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.tx_boss,ComponentHookList.ON_ROLL_OUT);
               this.uiApi.addComponentHook(param2.tx_archMonster,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.tx_archMonster,ComponentHookList.ON_ROLL_OUT);
               this.uiApi.addComponentHook(param2.tx_questMonster,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.tx_questMonster,ComponentHookList.ON_ROLL_OUT);
               if(!this._ctrTxLink[param2.btn_linkToMonster.name])
               {
                  this.uiApi.addComponentHook(param2.btn_linkToMonster,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.btn_linkToMonster,ComponentHookList.ON_ROLL_OUT);
                  this.uiApi.addComponentHook(param2.btn_linkToMonster,ComponentHookList.ON_RELEASE);
               }
               this._ctrTxLink[param2.btn_linkToMonster.name] = param1;
               if(!this._ctrTxLink[param2.btn_linkToArch.name])
               {
                  this.uiApi.addComponentHook(param2.btn_linkToArch,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.btn_linkToArch,ComponentHookList.ON_ROLL_OUT);
                  this.uiApi.addComponentHook(param2.btn_linkToArch,ComponentHookList.ON_RELEASE);
               }
               this._ctrTxLink[param2.btn_linkToArch.name] = param1;
               if(!this._ctrTxLink[param2.tx_incompatibleIdols.name])
               {
                  this.uiApi.addComponentHook(param2.tx_incompatibleIdols,ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.tx_incompatibleIdols,ComponentHookList.ON_ROLL_OUT);
               }
               this._ctrTxLink[param2.tx_incompatibleIdols.name] = param1;
               _loc5_ = this.getMonster(param1);
               if(!_loc5_)
               {
                  this.sysApi.log(16,"On veut le monstre " + param1 + " mais il ne semble pas exister !");
                  break;
               }
               if(!this._ctrBtnMonster[param2.btn_monster.name])
               {
                  this.uiApi.addComponentHook(param2.btn_monster,ComponentHookList.ON_RELEASE);
               }
               this._ctrBtnMonster[param2.btn_monster.name] = _loc5_;
               param2.btn_monster.handCursor = true;
               param2.lbl_name.text = _loc5_.name;
               if(this.sysApi.getPlayerManager().hasRights)
               {
                  param2.lbl_name.text = param2.lbl_name.text + (" (" + _loc5_.id + ")");
               }
               if(_loc5_.isBoss)
               {
                  param2.tx_boss.visible = true;
               }
               else
               {
                  param2.tx_boss.visible = false;
               }
               if(_loc5_.isMiniBoss)
               {
                  param2.tx_archMonster.visible = true;
               }
               else
               {
                  param2.tx_archMonster.visible = false;
               }
               if(_loc5_.isQuestMonster)
               {
                  param2.tx_questMonster.visible = true;
               }
               else
               {
                  param2.tx_questMonster.visible = false;
               }
               param2.btn_linkToMonster.visible = false;
               param2.btn_linkToArch.visible = false;
               if(_loc5_.isMiniBoss)
               {
                  param2.btn_linkToMonster.visible = true;
               }
               else if(_loc5_.correspondingMiniBossId > 0)
               {
                  param2.btn_linkToArch.visible = true;
               }
               param2.tx_incompatibleIdols.visible = _loc5_.incompatibleIdols.length > 0 || _loc5_.allIdolsDisabled;
               if(_loc5_.favoriteSubareaId > 0)
               {
                  _loc27_ = this.dataApi.getSubArea(_loc5_.favoriteSubareaId);
                  _loc28_ = this.dataApi.getArea(_loc27_.areaId).name;
                  _loc29_ = _loc27_.name;
                  if(_loc29_.indexOf(_loc28_) != -1)
                  {
                     param2.lbl_bestSubarea.text = _loc29_;
                  }
                  else
                  {
                     param2.lbl_bestSubarea.text = _loc29_ + " (" + _loc28_ + ")";
                  }
                  param2.btn_loc.x = param2.lbl_bestSubarea.textWidth + param2.lbl_bestSubarea.x + 10;
                  param2.btn_loc.y = 40;
                  if(!this._ctrBtnMonsterLocation[param2.btn_loc.name])
                  {
                     this.uiApi.addComponentHook(param2.btn_loc,ComponentHookList.ON_ROLL_OVER);
                     this.uiApi.addComponentHook(param2.btn_loc,ComponentHookList.ON_ROLL_OUT);
                     this.uiApi.addComponentHook(param2.btn_loc,ComponentHookList.ON_RELEASE);
                  }
                  this._ctrBtnMonsterLocation[param2.btn_loc.name] = _loc5_;
                  param2.btn_loc.visible = true;
                  if(!_loc27_.hasCustomWorldMap && !_loc27_.area.superArea.hasWorldMap)
                  {
                     param2.btn_loc.softDisabled = true;
                  }
                  else
                  {
                     param2.btn_loc.softDisabled = false;
                  }
               }
               else
               {
                  param2.lbl_bestSubarea.text = this.uiApi.getText("ui.monster.noFavoriteZone");
                  param2.btn_loc.visible = false;
               }
               _loc6_ = _loc5_.grades[0];
               _loc7_ = _loc5_.grades[_loc5_.grades.length - 1];
               param2.lbl_level.text = this.uiApi.getText("ui.common.short.level") + " " + this.getStringFromValues(_loc6_.level,_loc7_.level);
               param2.tx_sprite.uri = this.uiApi.createUri(this._uriMonsterSprite + param1 + ".png");
               this._inc_monsterRender++;
               break;
            case CTR_MONSTER_AREAS:
               _loc8_ = new Array();
               for each(_loc30_ in param1.subareasList)
               {
                  _loc8_.push(this.dataApi.getSubArea(_loc30_));
               }
               if(_loc8_.length <= 2)
               {
                  param2.gd_subareas.height = AREA_LINE_HEIGHT * 2;
               }
               else
               {
                  param2.gd_subareas.height = AREA_LINE_HEIGHT * 5;
               }
               param2.gd_subareas.dataProvider = _loc8_;
               break;
            case CTR_MONSTER_DETAILS:
               this._selectedAndOpenedMonsterId = this._selectedMonsterId;
               _loc9_ = param1.grades.length - 1;
               _loc10_ = new Array();
               _loc10_.push({
                  "text":this.uiApi.getText("ui.common.lifePoints") + this.uiApi.getText("ui.common.colon"),
                  "value":this.getStringFromValues(param1.grades[0].lifePoints + param1.grades[0].vitality,param1.grades[_loc9_].lifePoints + param1.grades[_loc9_].vitality),
                  "icon":this.uiApi.createUri(this.uiApi.me().getConstant("hpIconUri"))
               });
               _loc10_.push({
                  "text":this.uiApi.getText("ui.stats.actionPoints") + this.uiApi.getText("ui.common.colon"),
                  "value":this.getStringFromValues(param1.grades[0].actionPoints,param1.grades[_loc9_].actionPoints),
                  "icon":this.uiApi.createUri(this.uiApi.me().getConstant("apIconUri"))
               });
               _loc10_.push({
                  "text":this.uiApi.getText("ui.stats.movementPoints") + this.uiApi.getText("ui.common.colon"),
                  "value":this.getStringFromValues(param1.grades[0].movementPoints,param1.grades[_loc9_].movementPoints),
                  "icon":this.uiApi.createUri(this.uiApi.me().getConstant("mpIconUri"))
               });
               param2.gd_stats.dataProvider = _loc10_;
               _loc11_ = -1;
               _loc12_ = -1;
               _loc13_ = -1;
               _loc14_ = -1;
               _loc15_ = -1;
               _loc16_ = -1;
               _loc17_ = -1;
               _loc18_ = -1;
               _loc19_ = -1;
               _loc20_ = -1;
               for each(_loc31_ in param1.grades)
               {
                  if(_loc11_ == -1 || _loc31_.neutralResistance < _loc11_)
                  {
                     _loc11_ = _loc31_.neutralResistance;
                  }
                  if(_loc16_ == -1 || _loc31_.neutralResistance > _loc16_)
                  {
                     _loc16_ = _loc31_.neutralResistance;
                  }
                  if(_loc12_ == -1 || _loc31_.earthResistance < _loc12_)
                  {
                     _loc12_ = _loc31_.earthResistance;
                  }
                  if(_loc17_ == -1 || _loc31_.earthResistance > _loc17_)
                  {
                     _loc17_ = _loc31_.earthResistance;
                  }
                  if(_loc13_ == -1 || _loc31_.fireResistance < _loc13_)
                  {
                     _loc13_ = _loc31_.fireResistance;
                  }
                  if(_loc18_ == -1 || _loc31_.fireResistance > _loc18_)
                  {
                     _loc18_ = _loc31_.fireResistance;
                  }
                  if(_loc14_ == -1 || _loc31_.waterResistance < _loc14_)
                  {
                     _loc14_ = _loc31_.waterResistance;
                  }
                  if(_loc19_ == -1 || _loc31_.waterResistance > _loc19_)
                  {
                     _loc19_ = _loc31_.waterResistance;
                  }
                  if(_loc15_ == -1 || _loc31_.airResistance < _loc15_)
                  {
                     _loc15_ = _loc31_.airResistance;
                  }
                  if(_loc20_ == -1 || _loc31_.airResistance > _loc20_)
                  {
                     _loc20_ = _loc31_.airResistance;
                  }
               }
               _loc21_ = new Array();
               _loc21_.push({
                  "text":this.getStringFromValues(_loc11_,_loc16_),
                  "gfxId":"neutral",
                  "element":this.uiApi.getText("ui.stats.neutralReduction")
               });
               _loc21_.push({
                  "text":this.getStringFromValues(_loc12_,_loc17_),
                  "gfxId":"strength",
                  "element":this.uiApi.getText("ui.stats.earthReduction")
               });
               _loc21_.push({
                  "text":this.getStringFromValues(_loc13_,_loc18_),
                  "gfxId":"intelligence",
                  "element":this.uiApi.getText("ui.stats.fireReduction")
               });
               _loc21_.push({
                  "text":this.getStringFromValues(_loc14_,_loc19_),
                  "gfxId":"chance",
                  "element":this.uiApi.getText("ui.stats.waterReduction")
               });
               _loc21_.push({
                  "text":this.getStringFromValues(_loc15_,_loc20_),
                  "gfxId":"agility",
                  "element":this.uiApi.getText("ui.stats.airReduction")
               });
               param2.gd_resists.dataProvider = _loc21_;
               if(param1.hasDrops)
               {
                  param2.lbl_drops.text = this.uiApi.getText("ui.common.loot");
               }
               else
               {
                  param2.lbl_drops.text = "";
               }
               break;
            case CTR_MONSTER_DROPS:
               _loc22_ = new Array();
               _loc23_ = 0;
               for each(_loc32_ in param1.dropsList)
               {
                  _loc33_ = this.dataApi.getItemWrapper(_loc32_.objectId,_loc23_,0,1);
                  _loc23_++;
                  _loc22_.push(_loc33_);
               }
               _loc24_ = this.uiApi.createUri(this._uriRareDrop);
               _loc25_ = this.uiApi.createUri(this._uriOkDrop);
               param2.gd_drops.dataProvider = _loc22_;
               _loc26_ = 0;
               for each(_loc34_ in param2.gd_drops.slots)
               {
                  if(param1.dropsList[_loc26_] && param1.dropsList[_loc26_].hasCriteria)
                  {
                     _loc34_.forcedBackGroundIconUri = this.uiApi.createUri(this._uriSpecialSlot);
                  }
                  else if(param1.dropsList[_loc26_])
                  {
                     _loc34_.forcedBackGroundIconUri = this.uiApi.createUri(this._uriEmptySlot);
                  }
                  else
                  {
                     _loc34_.forcedBackGroundIconUri = null;
                  }
                  if(param1.dropsList[_loc26_] && param1.dropsList[_loc26_].percentDropForGrade1 < 2)
                  {
                     _loc34_.customTexture = _loc24_;
                  }
                  else if(param1.dropsList[_loc26_] && param1.dropsList[_loc26_].percentDropForGrade1 < 10)
                  {
                     _loc34_.customTexture = _loc25_;
                  }
                  else
                  {
                     _loc34_.customTexture = null;
                  }
                  _loc26_++;
               }
               if(!this._ctrSlotDrop[param2.gd_drops.name])
               {
                  this.uiApi.addComponentHook(param2.gd_drops,ComponentHookList.ON_ITEM_ROLL_OVER);
                  this.uiApi.addComponentHook(param2.gd_drops,ComponentHookList.ON_ITEM_ROLL_OUT);
                  this.uiApi.addComponentHook(param2.gd_drops,ComponentHookList.ON_ITEM_RIGHT_CLICK);
               }
               this._ctrSlotDrop[param2.gd_drops.name] = param1;
         }
      }
      
      public function getMonsterLineType(param1:*, param2:uint) : String
      {
         if(!param1)
         {
            return "";
         }
         switch(param2)
         {
            case 0:
               if(param1.hasOwnProperty("dropsList"))
               {
                  return CTR_MONSTER_DROPS;
               }
               if(param1.hasOwnProperty("grades"))
               {
                  return CTR_MONSTER_DETAILS;
               }
               if(param1.hasOwnProperty("subareasList"))
               {
                  return CTR_MONSTER_AREAS;
               }
               return CTR_MONSTER_BASE;
            default:
               return CTR_MONSTER_BASE;
         }
      }
      
      public function getMonsterDataLength(param1:*, param2:Boolean) : *
      {
         return 1;
      }
      
      private function getMonster(param1:int) : Monster
      {
         if(!this._monstersDataById[param1])
         {
            this._monstersDataById[param1] = this.dataApi.getMonsterFromId(param1);
         }
         return this._monstersDataById[param1];
      }
      
      private function pushEmptyLine(param1:Array, param2:int) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2)
         {
            param1.push(null);
            _loc3_++;
         }
      }
      
      private function updateMonsterGrid(param1:Object) : void
      {
         var _loc5_:Object = null;
         var _loc7_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Object = null;
         var _loc11_:Array = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:* = undefined;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:* = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = new Array();
         this._selectedAndOpenedMonsterId = 0;
         var _loc6_:Vector.<uint> = new Vector.<uint>();
         var _loc8_:int = 0;
         if(!this._monstersListToDisplay || this._monstersListToDisplay.length == 0)
         {
            if(!this._searchCriteria)
            {
               if(param1.parentId > 0)
               {
                  for each(_loc7_ in param1.monsters)
                  {
                     if(_loc7_)
                     {
                        _loc6_.push(_loc7_);
                     }
                  }
                  _loc5_ = this.dataApi.querySort(Monster,_loc6_,["isBoss","isMiniBoss","name"],[false,true,true]);
                  for each(_loc7_ in _loc5_)
                  {
                     _loc2_ = _loc4_.length;
                     _loc4_.push(_loc7_);
                     this.pushEmptyLine(_loc4_,this.uiApi.me().getConstant("monsterInfoLineCount") - 1);
                     if(_loc7_ == this._selectedMonsterId)
                     {
                        _loc4_ = _loc4_.concat(this.addDetails(_loc7_,param1));
                        _loc3_ = _loc2_;
                     }
                  }
               }
            }
            else if(this._previousSearchCriteria != this._searchCriteria + "#" + this.btn_displayCriteriaDrop.selected + "#" + this._searchOnName + "" + this._searchOnDrop)
            {
               _loc9_ = getTimer();
               _loc11_ = !!this._previousSearchCriteria?this._previousSearchCriteria.split("#"):[];
               if(this._searchCriteria != _loc11_[0] || this.btn_displayCriteriaDrop.selected.toString() != _loc11_[1])
               {
                  _loc12_ = this.dataApi.queryString(Monster,"name",this._searchCriteria);
                  if(this.btn_displayCriteriaDrop.selected)
                  {
                     _loc13_ = this.dataApi.queryEquals(Monster,"drops.objectId",this.dataApi.queryString(Item,"name",this._searchCriteria));
                  }
                  else
                  {
                     _loc13_ = this.dataApi.queryIntersection(this.dataApi.queryEquals(Monster,"drops.objectId",this.dataApi.queryString(Item,"name",this._searchCriteria)),this.dataApi.queryEquals(Monster,"drops.hasCriteria",false));
                  }
                  this._searchResultByCriteriaList["_searchOnName"] = _loc12_;
                  this._searchResultByCriteriaList["_searchOnDrop"] = _loc13_;
                  if(_loc12_ || _loc13_)
                  {
                     this.sysApi.log(2,"Result : " + ((!!_loc12_?_loc12_.length:0) + (!!_loc13_?_loc13_.length:0)) + " in " + (getTimer() - _loc9_) + " ms");
                  }
               }
               if(this._searchOnName && this._searchOnDrop)
               {
                  _loc10_ = this.dataApi.queryUnion(this._searchResultByCriteriaList["_searchOnName"],this._searchResultByCriteriaList["_searchOnDrop"]);
               }
               else if(this._searchOnName)
               {
                  _loc10_ = this._searchResultByCriteriaList["_searchOnName"];
               }
               else if(this._searchOnDrop)
               {
                  _loc10_ = this._searchResultByCriteriaList["_searchOnDrop"];
               }
               else
               {
                  this.gd_monsters.dataProvider = new Array();
                  this.lbl_noMonster.visible = true;
                  this.lbl_noMonster.text = this.uiApi.getText("ui.search.needCriterion");
                  this._previousSearchCriteria = this._searchCriteria + "#" + this.btn_displayCriteriaDrop.selected + "#" + this._searchOnName + "" + this._searchOnDrop;
                  return;
               }
               for each(_loc7_ in _loc10_)
               {
                  _loc6_.push(_loc7_);
               }
               _loc5_ = this.dataApi.querySort(Monster,_loc6_,["isBoss","isMiniBoss","name"],[false,true,true]);
               for each(_loc7_ in _loc5_)
               {
                  _loc2_ = _loc4_.length;
                  _loc4_.push(_loc7_);
                  this.pushEmptyLine(_loc4_,this.uiApi.me().getConstant("monsterInfoLineCount") - 1);
                  if(_loc7_ == this._selectedMonsterId)
                  {
                     _loc3_ = _loc4_.length;
                     _loc4_ = _loc4_.concat(this.addDetails(_loc7_,param1));
                  }
               }
            }
            else
            {
               for each(_loc14_ in this.gd_monsters.dataProvider)
               {
                  if(_loc14_ && _loc14_ is int)
                  {
                     _loc2_ = _loc4_.length;
                     _loc4_.push(_loc14_);
                     this.pushEmptyLine(_loc4_,this.uiApi.me().getConstant("monsterInfoLineCount") - 1);
                     if(_loc14_ == this._selectedMonsterId)
                     {
                        _loc3_ = _loc4_.length;
                        _loc4_ = _loc4_.concat(this.addDetails(int(_loc14_),param1));
                     }
                  }
               }
            }
         }
         else
         {
            for each(_loc7_ in this._monstersListToDisplay)
            {
               _loc6_.push(_loc7_);
            }
            _loc5_ = this.dataApi.querySort(Monster,_loc6_,["isBoss","isMiniBoss","name"],[false,true,true]);
            for each(_loc7_ in _loc5_)
            {
               _loc4_.push(_loc7_);
               this.pushEmptyLine(_loc4_,this.uiApi.me().getConstant("monsterInfoLineCount") - 1);
               if(_loc7_ == this._selectedMonsterId)
               {
                  _loc3_ = _loc2_;
                  _loc4_ = _loc4_.concat(this.addDetails(_loc7_,param1));
               }
               _loc2_++;
               _loc2_++;
            }
         }
         if(_loc4_.length)
         {
            this.gd_monsters.dataProvider = _loc4_;
            this.lbl_noMonster.visible = false;
         }
         else
         {
            this.gd_monsters.dataProvider = new Array();
            this.lbl_noMonster.visible = true;
            this.lbl_noMonster.text = this.uiApi.getText("ui.search.noResult");
            if(this._searchCriteria)
            {
               _loc15_ = "";
               _loc16_ = "";
               for(_loc17_ in this._searchTextByCriteriaList)
               {
                  if(this[_loc17_])
                  {
                     _loc15_ = _loc15_ + (this._searchTextByCriteriaList[_loc17_] + ", ");
                  }
                  else if(this._searchResultByCriteriaList[_loc17_].length > 0)
                  {
                     _loc16_ = _loc16_ + (this._searchTextByCriteriaList[_loc17_] + ", ");
                  }
               }
               if(_loc15_.length > 0)
               {
                  _loc15_ = _loc15_.slice(0,-2);
               }
               if(_loc16_.length > 0)
               {
                  _loc16_ = _loc16_.slice(0,-2);
               }
               if(_loc16_.length == 0)
               {
                  this.lbl_noMonster.text = this.uiApi.getText("ui.search.noResultFor",this._searchCriteria);
               }
               else
               {
                  this.lbl_noMonster.text = this.uiApi.getText("ui.search.noResultsBut",_loc15_,_loc16_);
               }
            }
         }
         if(this._forceOpenMonster)
         {
            this._forceOpenMonster = false;
            this.gd_monsters.moveTo(_loc3_,true);
         }
         if(this._currentScrollValue != 0)
         {
            this.gd_monsters.verticalScrollValue = this._currentScrollValue;
         }
         this._previousSearchCriteria = this._searchCriteria + "#" + this.btn_displayCriteriaDrop.selected + "#" + this._searchOnName + "" + this._searchOnDrop;
      }
      
      private function addDetails(param1:int, param2:Object) : Array
      {
         var _loc7_:MonsterDrop = null;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc3_:Array = new Array();
         var _loc4_:Monster = this.getMonster(param1);
         var _loc5_:Object = {
            "grades":_loc4_.grades,
            "spells":_loc4_.spells,
            "subareas":_loc4_.subareas,
            "hasDrops":true
         };
         var _loc6_:Array = new Array();
         for each(_loc7_ in _loc4_.drops)
         {
            if(this.btn_displayCriteriaDrop.selected || !_loc7_.hasCriteria)
            {
               _loc6_.push(_loc7_);
            }
         }
         if(!_loc6_.length)
         {
            _loc5_.hasDrops = false;
         }
         _loc3_.push(_loc5_);
         this.pushEmptyLine(_loc3_,this.uiApi.me().getConstant("monsterDetailLineCount") - 1);
         if(_loc6_.length)
         {
            _loc8_ = Math.ceil(_loc6_.length / NB_DROP_PER_LINE);
            _loc11_ = 0;
            while(_loc11_ < _loc8_)
            {
               _loc10_ = (_loc11_ + 1) * NB_DROP_PER_LINE;
               if(_loc10_ >= _loc6_.length)
               {
                  _loc9_ = _loc6_.slice(_loc11_ * NB_DROP_PER_LINE);
               }
               else
               {
                  _loc9_ = _loc6_.slice(_loc11_ * NB_DROP_PER_LINE,_loc10_);
               }
               _loc3_.push({"dropsList":_loc9_});
               this.pushEmptyLine(_loc3_,this.uiApi.me().getConstant("monsterSlotLineCount") - 1);
               _loc11_++;
            }
         }
         return _loc3_;
      }
      
      private function displayCategories(param1:Object = null, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         if(!param1)
         {
            param1 = this.gd_categories.selectedItem;
         }
         if(param1.parentId > 0 && this._openCatIndex == param1.parentId || this._openCatIndex == param1.id)
         {
            this._currentSelectedCatId = param1.id;
            for each(_loc10_ in this.gd_categories.dataProvider)
            {
               if(_loc10_.id == this._currentSelectedCatId)
               {
                  break;
               }
               _loc3_++;
            }
            if(this.gd_categories.selectedIndex != _loc3_)
            {
               this.gd_categories.silent = true;
               this.gd_categories.selectedIndex = _loc3_;
               this.gd_categories.silent = false;
            }
            this.updateMonsterGrid(param1);
            if(this._openCatIndex != param1.id)
            {
               return;
            }
         }
         var _loc4_:int = param1.id;
         if(param1.parentId > 0)
         {
            _loc4_ = param1.parentId;
         }
         var _loc5_:int = -1;
         var _loc6_:Array = new Array();
         var _loc7_:int = -1;
         if(this._currentCategoryType == CAT_TYPE_AREA)
         {
            _loc8_ = this._categoriesArea;
         }
         else
         {
            _loc8_ = this._categoriesRace;
         }
         for each(_loc9_ in _loc8_)
         {
            _loc6_.push(_loc9_);
            _loc5_++;
            if(_loc4_ == _loc9_.id)
            {
               _loc3_ = _loc5_;
               if(this._currentSelectedCatId != _loc9_.id || this._openCatIndex == 0)
               {
                  _loc7_ = _loc9_.id;
                  for each(_loc11_ in _loc9_.subcats)
                  {
                     _loc6_.push(_loc11_);
                     _loc5_++;
                     if(_loc11_.id == param1.id)
                     {
                        _loc3_ = _loc5_;
                     }
                  }
               }
            }
         }
         if(_loc7_ >= 0)
         {
            this._openCatIndex = _loc7_;
         }
         else
         {
            this._openCatIndex = 0;
         }
         this._currentSelectedCatId = param1.id;
         this.gd_categories.dataProvider = _loc6_;
         if(this.gd_categories.selectedIndex != _loc3_)
         {
            this.gd_categories.silent = true;
            this.gd_categories.selectedIndex = _loc3_;
            this.gd_categories.silent = false;
         }
         this.updateMonsterGrid(this.gd_categories.selectedItem);
      }
      
      private function changeSearchOnName() : void
      {
         this._searchOnName = !this._searchOnName;
         Grimoire.getInstance().bestiarySearchOnName = this._searchOnName;
         if(!this._searchOnName && !this._searchOnDrop)
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
            this.updateMonsterGrid(this.gd_categories.selectedItem);
         }
      }
      
      private function changeSearchOnDrop() : void
      {
         this._searchOnDrop = !this._searchOnDrop;
         Grimoire.getInstance().bestiarySearchOnDrop = this._searchOnDrop;
         if(!this._searchOnName && !this._searchOnDrop)
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
            this.updateMonsterGrid(this.gd_categories.selectedItem);
         }
      }
      
      private function getIdolCoeff(param1:Idol) : Number
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:Number = 1;
         var _loc3_:Object = param1.synergyIdolsIds;
         var _loc4_:Object = param1.synergyIdolsCoeff;
         var _loc5_:uint = _loc3_.length;
         var _loc8_:uint = this._currentIdols.length;
         _loc6_ = 0;
         while(_loc6_ < _loc8_)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               if(_loc3_[_loc7_] == this._currentIdols[_loc6_])
               {
                  _loc2_ = _loc2_ * _loc4_[_loc7_];
               }
               _loc7_++;
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.gd_categories)
         {
            if(param2 != GridItemSelectMethodEnum.AUTO)
            {
               this._searchCriteria = null;
               this.inp_search.text = "";
               this._currentScrollValue = 0;
               this._monstersListToDisplay = new Array();
               if(this._currentCategoryType == CAT_TYPE_AREA)
               {
                  this._lastAreaSelected = param1.selectedItem;
               }
               else
               {
                  this._lastRaceSelected = param1.selectedItem;
               }
               this.displayCategories(param1.selectedItem);
            }
         }
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         if(param2.data && param1.name.indexOf("gd_drops") != -1)
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
         var _loc3_:* = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Monster = null;
         var _loc7_:* = false;
         var _loc8_:Object = null;
         var _loc9_:Idol = null;
         var _loc10_:Number = NaN;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc34_:Object = null;
         var _loc35_:PartyMemberWrapper = null;
         if(param2.data && param1.name.indexOf("gd_drops") != -1)
         {
            _loc4_ = {
               "point":LocationEnum.POINT_BOTTOM,
               "relativePoint":LocationEnum.POINT_TOP
            };
            _loc5_ = this._ctrSlotDrop[param1.name].dropsList[param2.data.position];
            if(param2.data is ItemWrapper)
            {
               _loc6_ = this.getMonster(_loc5_.monsterId);
               _loc7_ = this.partyApi.getPartyMembers().length > 0;
               _loc8_ = !!_loc7_?this.playerApi.getPartyIdols():this.playerApi.getSoloIdols();
               _loc11_ = _loc8_.length;
               this._currentIdols.length = 0;
               _loc13_ = 0;
               while(_loc13_ < _loc11_)
               {
                  _loc9_ = this.dataApi.getIdol(_loc8_[_loc13_]);
                  if(_loc6_.incompatibleIdols.indexOf(_loc9_.id) == -1)
                  {
                     this._currentIdols.push(_loc9_.id);
                  }
                  _loc13_++;
               }
               _loc11_ = this._currentIdols.length;
               _loc13_ = 0;
               while(_loc13_ < _loc11_)
               {
                  _loc9_ = this.dataApi.getIdol(this._currentIdols[_loc13_]);
                  _loc10_ = this.getIdolCoeff(_loc9_);
                  _loc12_ = _loc12_ + _loc9_.dropBonus * _loc10_;
                  _loc13_++;
               }
               _loc3_ = "<b>" + param2.data.name + "</b>";
               if(_loc5_.hasCriteria)
               {
                  _loc3_ = _loc3_ + (" (" + this.uiApi.getText("ui.common.conditions") + ")");
               }
               _loc3_ = _loc3_ + this.averagePricesApi.getItemAveragePriceString(param2.data,true);
               _loc14_ = _loc6_.grades.length;
               if(_loc14_ > 5)
               {
                  _loc14_ = 5;
               }
               _loc15_ = this.getRound(_loc5_.percentDropForGrade1);
               _loc16_ = this.getRound(_loc5_["percentDropForGrade" + _loc14_]);
               _loc18_ = this.playerApi.characteristics().prospecting.alignGiftBonus + this.playerApi.characteristics().prospecting.base + this.playerApi.characteristics().prospecting.contextModif + this.playerApi.characteristics().prospecting.objectsAndMountBonus;
               _loc17_ = _loc18_;
               if(_loc18_ < 100)
               {
                  _loc17_ = 100;
               }
               if(!_loc7_)
               {
                  _loc19_ = this.playerApi.getPlayedCharacterInfo().level;
               }
               else
               {
                  _loc34_ = this.partyApi.getPartyMembers();
                  for each(_loc35_ in _loc34_)
                  {
                     if(_loc35_.level > _loc19_)
                     {
                        _loc19_ = _loc35_.level;
                     }
                  }
               }
               if(_loc19_ > ProtocolConstantsEnum.MAX_LEVEL)
               {
                  _loc19_ = ProtocolConstantsEnum.MAX_LEVEL;
               }
               _loc20_ = _loc6_.grades[0].hiddenLevel > 0?uint(_loc6_.grades[0].hiddenLevel):uint(_loc6_.grades[0].level);
               _loc21_ = _loc6_.grades[_loc14_ - 1].hiddenLevel > 0?uint(_loc6_.grades[_loc14_ - 1].hiddenLevel):uint(_loc6_.grades[_loc14_ - 1].level);
               _loc22_ = _loc20_ / _loc19_;
               _loc22_ = _loc22_ * _loc22_;
               _loc23_ = _loc21_ / _loc19_;
               _loc23_ = _loc23_ * _loc23_;
               _loc24_ = this.roleplayApi.getMonsterDropBoostMultiplier(_loc6_.id);
               _loc25_ = this.roleplayApi.getAlmanaxMonsterDropChanceBonusMultiplier(_loc6_.id);
               _loc26_ = _loc15_ * _loc24_ * _loc25_;
               _loc27_ = _loc16_ * _loc24_ * _loc25_;
               _loc28_ = this.getRound(_loc26_ * _loc17_ / 100);
               _loc29_ = this.getRound(_loc26_ * _loc12_ * _loc22_ / 100);
               _loc30_ = this.getRound(_loc27_ * _loc17_ / 100);
               _loc31_ = this.getRound(_loc27_ * _loc12_ * _loc23_ / 100);
               _loc32_ = this.getRound(_loc28_ + _loc29_);
               _loc33_ = this.getRound(_loc30_ + _loc31_);
               if(_loc32_ > 100)
               {
                  _loc32_ = 100;
               }
               if(_loc33_ > 100)
               {
                  _loc33_ = 100;
               }
               _loc3_ = _loc3_ + ("\n" + this.uiApi.getText("ui.monster.obtaining.withBonuses",this.getStringFromValues(_loc32_,_loc33_)));
               _loc3_ = _loc3_ + ("\n" + this.uiApi.getText("ui.monster.obtaining.base",this.getStringFromValues(_loc15_,_loc16_)));
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
         var _loc3_:Point = null;
         var _loc4_:Object = null;
         var _loc5_:Monster = null;
         var _loc6_:String = null;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:SubArea = null;
         var _loc9_:uint = 0;
         var _loc10_:MonsterMiniBoss = null;
         var _loc11_:Monster = null;
         switch(param1)
         {
            case this.btn_resetSearch:
               this._searchCriteria = null;
               this.inp_search.text = "";
               this.updateMonsterGrid(this.gd_categories.selectedItem);
               break;
            case this.btn_races:
               if(this._currentCategoryType != CAT_TYPE_RACE)
               {
                  this._currentCategoryType = CAT_TYPE_RACE;
                  this.displayCategories(this._lastRaceSelected);
               }
               break;
            case this.btn_subareas:
               if(this._currentCategoryType != CAT_TYPE_AREA)
               {
                  this._currentCategoryType = CAT_TYPE_AREA;
                  this.displayCategories(this._lastAreaSelected);
               }
               break;
            case this.btn_searchFilter:
               if(this.btn_searchFilter.selected && !this._btn_searchFilter_flag)
               {
                  _loc2_ = new Array();
                  _loc2_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.search.criteria")));
                  _loc2_.push(this.modContextMenu.createContextMenuItemObject(this._searchTextByCriteriaList["_searchOnName"],this.changeSearchOnName,null,false,null,this._searchOnName,false));
                  _loc2_.push(this.modContextMenu.createContextMenuItemObject(this._searchTextByCriteriaList["_searchOnDrop"],this.changeSearchOnDrop,null,false,null,this._searchOnDrop,false));
                  _loc3_ = (this.btn_searchFilter as Object).localToGlobal(new Point(this.btn_searchFilter.x + this.btn_searchFilter.width,this.btn_searchFilter.y + this.btn_searchFilter.height));
                  this.modContextMenu.createContextMenu(_loc2_,_loc3_,this.onContextMenuClose);
               }
               else
               {
                  this.btn_searchFilter.selected = false;
               }
               break;
            case this.btn_displayCriteriaDrop:
               Grimoire.getInstance().bestiaryDisplayCriteriaDrop = this.btn_displayCriteriaDrop.selected;
               this.updateMonsterGrid(this.gd_categories.selectedItem);
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            default:
               if(param1.name.indexOf("btn_monster") != -1)
               {
                  if(this.uiApi.keyIsDown(Keyboard.SHIFT))
                  {
                     this.sysApi.dispatchHook(MouseShiftClick,{"data":this._ctrBtnMonster[param1.name]});
                     break;
                  }
                  _loc4_ = this._ctrBtnMonster[param1.name];
                  if(this._selectedMonsterId != _loc4_.id)
                  {
                     this.gd_monsters.selectedItem = _loc4_;
                     this._selectedMonsterId = _loc4_.id;
                  }
                  else
                  {
                     this._selectedMonsterId = 0;
                  }
                  this.updateMonsterGrid(this.gd_categories.selectedItem);
                  if(this._searchCriteria != "")
                  {
                  }
               }
               else if(param1.name.indexOf("btn_loc") != -1)
               {
                  _loc5_ = this._ctrBtnMonsterLocation[param1.name];
                  _loc6_ = this.uiApi.processText(this.uiApi.getText("ui.monster.presentInAreas",_loc5_.subareas.length),"m",_loc5_.subareas.length == 1);
                  _loc7_ = new Vector.<uint>(0);
                  for each(_loc9_ in _loc5_.subareas)
                  {
                     _loc8_ = this.dataApi.getSubArea(_loc9_);
                     if(_loc8_.hasCustomWorldMap || _loc8_.area.superArea.hasWorldMap)
                     {
                        _loc7_.push(_loc9_);
                     }
                  }
                  this._mapPopup = this.modCartography.openCartographyPopup(_loc5_.name,_loc5_.favoriteSubareaId,_loc7_,_loc6_);
               }
               else if(param1.name.indexOf("btn_linkToMonster") != -1)
               {
                  _loc10_ = this.dataApi.getMonsterMiniBossFromId(this._ctrTxLink[param1.name]);
                  this.onOpenBestiary("bestiaryTab",{
                     "forceOpen":true,
                     "monsterId":_loc10_.monsterReplacingId
                  });
               }
               else if(param1.name.indexOf("btn_linkToArch") != -1)
               {
                  _loc11_ = this.getMonster(this._ctrTxLink[param1.name]);
                  this.onOpenBestiary("bestiaryTab",{
                     "forceOpen":true,
                     "monsterId":_loc11_.correspondingMiniBossId
                  });
               }
         }
      }
      
      public function onFocusChange(param1:Object) : void
      {
         this._btn_searchFilter_flag = false;
      }
      
      public function onContextMenuClose() : void
      {
         this.btn_searchFilter.selected = false;
         this._btn_searchFilter_flag = true;
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc4_:Monster = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:Idol = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         if(param1.name.indexOf("tx_boss") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.item.boss");
         }
         else if(param1.name.indexOf("tx_archMonster") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.item.miniboss");
         }
         else if(param1.name.indexOf("tx_questMonster") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.monster.questMonster");
         }
         else if(param1.name.indexOf("btn_linkToArch") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.monster.goToArchMonster");
         }
         else if(param1.name.indexOf("btn_linkToMonster") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.monster.goToMonster");
         }
         else if(param1.name.indexOf("btn_searchFilter") != -1)
         {
            _loc2_ = this.uiApi.getText("ui.search.criteria");
         }
         else if(param1.name.indexOf("btn_loc") != -1)
         {
            if((param1 as ButtonContainer).softDisabled)
            {
               return;
            }
            _loc2_ = this.uiApi.getText("ui.monster.showAreas");
         }
         else if(param1.name.indexOf("tx_incompatibleIdols") != -1)
         {
            _loc4_ = this.getMonster(this._ctrTxLink[param1.name]);
            if(_loc4_.allIdolsDisabled)
            {
               _loc2_ = this.uiApi.getText("ui.idol.allIdolsDisabled");
            }
            else
            {
               _loc5_ = "";
               for each(_loc6_ in _loc4_.incompatibleIdols)
               {
                  _loc7_ = this.dataApi.getIdol(_loc6_);
                  if(_loc7_)
                  {
                     _loc5_ = _loc5_ + ("\n" + _loc7_.item.name);
                  }
               }
               _loc2_ = this.uiApi.getText("ui.idol.incompatibleIdols",_loc5_);
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
            this._monstersListToDisplay = new Array();
            this.updateMonsterGrid(this.gd_categories.selectedItem);
         }
         else
         {
            if(this._searchCriteria)
            {
               this._searchCriteria = null;
            }
            if(this.inp_search.text.length == 0)
            {
               this.updateMonsterGrid(this.gd_categories.selectedItem);
            }
         }
      }
      
      protected function onShortCut(param1:String) : Boolean
      {
         if(param1 == "closeUi")
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         return false;
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
      
      private function onOpenBestiary(param1:String = null, param2:Object = null) : void
      {
         var _loc3_:Monster = null;
         var _loc4_:MonsterRace = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         if(param1 == "bestiaryTab" && param2 && param2.forceOpen)
         {
            this.uiApi.hideTooltip();
            this._monstersListToDisplay = new Array();
            if(param2.monsterId)
            {
               this._selectedMonsterId = param2.monsterId;
               this._forceOpenMonster = true;
               this._searchCriteria = null;
               this.inp_search.text = "";
               _loc3_ = this.getMonster(this._selectedMonsterId);
               this.btn_races.selected = true;
               this._currentCategoryType = CAT_TYPE_RACE;
               _loc4_ = _loc3_.type;
               for each(_loc6_ in this._categoriesRace)
               {
                  if(_loc6_.realId == _loc4_.superRaceId)
                  {
                     for each(_loc7_ in _loc6_.subcats)
                     {
                        if(_loc7_.realId == _loc4_.id)
                        {
                           _loc5_ = _loc7_;
                        }
                     }
                  }
               }
               this._lastRaceSelected = _loc5_;
               this.displayCategories(_loc5_,true);
            }
            if(param2.monsterIdsList)
            {
               if(param2.monsterSearch)
               {
                  this.inp_search.text = param2.monsterSearch;
                  this._searchOnDrop = true;
                  this._searchOnName = false;
               }
               for each(_loc8_ in param2.monsterIdsList)
               {
                  this._monstersListToDisplay.push(_loc8_);
               }
               this.updateMonsterGrid(this.gd_categories.selectedItem);
            }
         }
      }
      
      private function getStringFromValues(param1:Number, param2:Number) : String
      {
         if(param1 == param2)
         {
            return "" + param1;
         }
         return "" + param1 + " " + this.uiApi.getText("ui.chat.to") + " " + param2;
      }
      
      private function getRound(param1:Number) : Number
      {
         return Math.round(param1 * 1000) / 1000;
      }
   }
}
