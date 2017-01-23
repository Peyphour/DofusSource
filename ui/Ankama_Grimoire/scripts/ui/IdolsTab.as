package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.idols.Idol;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.people.PartyMemberWrapper;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.PartyApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2actions.CloseIdols;
   import d2actions.IdolSelectRequest;
   import d2actions.IdolsPresetSave;
   import d2actions.IdolsPresetUse;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.SelectMethodEnum;
   import d2enums.StatesEnum;
   import d2hooks.CharacterStatsList;
   import d2hooks.GameFightEnd;
   import d2hooks.GameFightStart;
   import d2hooks.IdolAdded;
   import d2hooks.IdolPartyLost;
   import d2hooks.IdolPartyRefresh;
   import d2hooks.IdolRemoved;
   import d2hooks.IdolSelectError;
   import d2hooks.IdolSelected;
   import d2hooks.IdolsList;
   import d2hooks.IdolsPresetDelete;
   import d2hooks.IdolsPresetEquipped;
   import d2hooks.IdolsPresetSaved;
   import d2hooks.IdolsPresetsUpdate;
   import d2hooks.PartyLeave;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class IdolsTab
   {
      
      private static const MAX_ACTIVE_IDOLS:int = 6;
      
      private static const IDOLS_ITEM_TYPE:int = 178;
      
      private static const IDOLS_LAST_SORT:String = "idolsLastSort";
      
      private static const IDOLS_LAST_SORT_ORDER:String = "idolsLastSortOrder";
      
      private static const IDOLS_SHOW_ALL:String = "idolsShowAll";
      
      private static const IDOLS_SHOW_SYNERGY_SCORE:String = "idolsShowSynergyScore";
      
      private static const ALL_IDOLS_FILTER:uint = 0;
      
      private static const PARTY_IDOLS_FILTER:uint = 1;
      
      private static const SOLO_IDOLS_FILTER:uint = 2;
      
      private static const IDOLS_SCORE_20:uint = 3;
      
      private static const IDOLS_SCORE_40:uint = 4;
      
      private static const IDOLS_SCORE_60:uint = 5;
      
      private static const SEARCH_DELAY:uint = 200;
      
      private static const IDOLS_PRESET_LAST_SORT:String = "idolsPresetLastSort";
      
      private static const IDOLS_PRESET_LAST_SORT_ORDER:String = "idolsPresetLastSortOrder";
       
      
      public var sysApi:SystemApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var partyApi:PartyApi;
      
      public var dataApi:DataApi;
      
      public var uiApi:UiApi;
      
      public var inventoryApi:InventoryApi;
      
      public var utilApi:UtilApi;
      
      public var menuApi:ContextMenuApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _soloIdols:Array;
      
      private var _groupIdols:Array;
      
      private var _presetsIdols:Array;
      
      private var _currentActiveSoloIdols:Vector.<ItemWrapper>;
      
      private var _currentActiveGroupIdols:Vector.<ItemWrapper>;
      
      private var _activeIdolsIds:Vector.<int>;
      
      private var _txMemberIdolAssoc:Dictionary;
      
      private var _playerIdolsIds:Array;
      
      private var _idolsSelections:Vector.<IdolSelection>;
      
      private var _totalScore:uint;
      
      private var _totalExp:uint;
      
      private var _totalLoot:uint;
      
      private var _globalSynergy:Number;
      
      private var _isPartyLeader:Boolean;
      
      private var _isInFight:Boolean;
      
      private var _sortFieldAssoc:Dictionary;
      
      private var _ascendingSort:Boolean;
      
      private var _lastSortType:String;
      
      private var _presetAscendingSort:Boolean;
      
      private var _lastPresetSortType:String;
      
      private var _positiveSynergies:Dictionary;
      
      private var _negativeSynergies:Dictionary;
      
      private var _tmpPositiveSynergies:Dictionary;
      
      private var _tmpNegativeSynergies:Dictionary;
      
      private var _filters:Array;
      
      private var _currentFilter:uint;
      
      private var _currentDataProvider:Object;
      
      private var _filteredDataProvider:Object;
      
      private var _searchDataProvider:Array;
      
      private var _searchTimeoutId:uint;
      
      private var _searchText:String = "";
      
      private var _currentPresetsDataProvider:Object;
      
      private var _currentIcon:uint;
      
      private var _btnDeleteAssoc:Dictionary;
      
      private var _presetToDelete:Object;
      
      private var _forceLineRollOver:Boolean;
      
      private var _forceLineRollOut:Boolean;
      
      private var _txIncompatibleMonstersAssoc:Dictionary;
      
      public var btn_close:ButtonContainer;
      
      public var btn_solo:ButtonContainer;
      
      public var btn_showAll:ButtonContainer;
      
      public var btn_showSynergyScore:ButtonContainer;
      
      public var btn_group:ButtonContainer;
      
      public var btn_presets:ButtonContainer;
      
      public var btn_savePreset:ButtonContainer;
      
      public var gd_activeIdols:Grid;
      
      public var ctr_idols:GraphicContainer;
      
      public var gd_idols:Grid;
      
      public var gd_icons:Grid;
      
      public var ctr_presets:GraphicContainer;
      
      public var gd_presets:Grid;
      
      public var btn_label_btn_showAll:Label;
      
      public var btn_label_btn_showSynergyScore:Label;
      
      public var lbl_score:Label;
      
      public var lbl_exp:Label;
      
      public var lbl_loot:Label;
      
      public var btn_sortIdolByName:ButtonContainer;
      
      public var btn_sortIdolByScore:ButtonContainer;
      
      public var btn_sortPresetsByScore:ButtonContainer;
      
      public var tx_synergy:Texture;
      
      public var cb_filter:ComboBox;
      
      public var btn_closeSearch:ButtonContainer;
      
      public var inp_search:Input;
      
      public var tx_allIncompatibleMonsters:Texture;
      
      public function IdolsTab()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Idol = null;
         this.sysApi.addHook(GameFightStart,this.onGameFightStart);
         this.sysApi.addHook(GameFightEnd,this.onGameFightEnd);
         this.sysApi.addHook(IdolSelectError,this.onIdolSelectError);
         this.sysApi.addHook(IdolSelected,this.onIdolSelected);
         this.sysApi.addHook(IdolAdded,this.onIdolAdded);
         this.sysApi.addHook(IdolRemoved,this.onIdolRemoved);
         this.sysApi.addHook(IdolPartyRefresh,this.onIdolPartyRefresh);
         this.sysApi.addHook(IdolPartyLost,this.onIdolPartyLost);
         this.sysApi.addHook(IdolsList,this.onIdolsList);
         this.sysApi.addHook(CharacterStatsList,this.onCharacterStatsList);
         this.sysApi.addHook(PartyLeave,this.onPartyLeave);
         this.sysApi.addHook(IdolsPresetsUpdate,this.onIdolsPresetsUpdate);
         this.sysApi.addHook(d2hooks.IdolsPresetDelete,this.onIdolsPresetDelete);
         this.sysApi.addHook(IdolsPresetEquipped,this.onIdolsPresetEquipped);
         this.sysApi.addHook(IdolsPresetSaved,this.onIdolsPresetSaved);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.tx_allIncompatibleMonsters,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_allIncompatibleMonsters,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.gd_activeIdols,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_activeIdols,ComponentHookList.ON_ITEM_ROLL_OVER);
         this.uiApi.addComponentHook(this.gd_activeIdols,ComponentHookList.ON_ITEM_ROLL_OUT);
         this.uiApi.addComponentHook(this.gd_activeIdols,ComponentHookList.ON_ITEM_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.tx_synergy,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_synergy,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_loot,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_loot,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.lbl_exp,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.lbl_exp,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.gd_idols,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_icons,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.cb_filter,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_RELEASE);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this.btn_close.soundId = SoundEnum.CANCEL_BUTTON;
         this.btn_label_btn_showAll.textfield.autoSize = TextFieldAutoSize.LEFT;
         this.btn_label_btn_showSynergyScore.textfield.autoSize = TextFieldAutoSize.LEFT;
         this.btn_showSynergyScore.x = this.btn_showAll.x + this.btn_showAll.width + 30;
         this._searchText = this.uiApi.getText("ui.common.search.input");
         this.inp_search.text = this._searchText;
         this._activeIdolsIds = new Vector.<int>(0);
         this._txMemberIdolAssoc = new Dictionary();
         this._idolsSelections = new Vector.<IdolSelection>(0);
         this._sortFieldAssoc = new Dictionary();
         this._positiveSynergies = new Dictionary();
         this._negativeSynergies = new Dictionary();
         this._txIncompatibleMonstersAssoc = new Dictionary();
         this._sortFieldAssoc[this.btn_sortIdolByName] = "name";
         this._sortFieldAssoc[this.btn_sortIdolByScore] = "score";
         this._ascendingSort = this._presetAscendingSort = true;
         this._isInFight = this.playerApi.isInFight() && !this.playerApi.isInPreFight();
         this.initButtonValue(IDOLS_SHOW_ALL,this.btn_showAll,false);
         this.initButtonValue(IDOLS_SHOW_SYNERGY_SCORE,this.btn_showSynergyScore,true);
         var _loc2_:Object = param1.chosenIdols;
         this._soloIdols = new Array();
         var _loc6_:Object = this.inventoryApi.getStorageObjectsByType(IDOLS_ITEM_TYPE);
         var _loc7_:uint = _loc2_.length;
         var _loc8_:uint = _loc6_.length;
         this._playerIdolsIds = new Array();
         this._currentActiveSoloIdols = new Vector.<ItemWrapper>(0);
         _loc3_ = 0;
         while(_loc3_ < _loc7_)
         {
            _loc5_ = this.dataApi.getIdol(_loc2_[_loc3_]);
            this._currentActiveSoloIdols.push(this.dataApi.getItemWrapper(_loc5_.itemId));
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc8_)
         {
            _loc4_ = _loc6_[_loc3_];
            _loc5_ = this.dataApi.getIdolByItemId(_loc4_.objectGID);
            this._playerIdolsIds.push(_loc5_.id);
            this._soloIdols.push(this.getIdolData(_loc5_,null,_loc2_.indexOf(_loc5_.id) != -1,false));
            _loc3_++;
         }
         this._isPartyLeader = this.playerApi.isPartyLeader();
         this.updateGroupIdols(param1.partyChosenIdols,param1.partyIdols);
         if(!this.partyApi.isInParty(this.playerApi.id()))
         {
            this.openSoloTab();
            this.btn_group.softDisabled = true;
         }
         else
         {
            this.openGroupTab();
         }
         this._filters = new Array();
         this._filters.push({
            "label":this.uiApi.getText("ui.common.allTypesForObject"),
            "id":ALL_IDOLS_FILTER
         });
         this._filters.push({
            "label":this.uiApi.getText("ui.idol.partyIdols"),
            "id":PARTY_IDOLS_FILTER
         });
         this._filters.push({
            "label":this.uiApi.getText("ui.idol.soloIdols"),
            "id":SOLO_IDOLS_FILTER
         });
         this._filters.push({
            "label":this.uiApi.getText("ui.common.score") + " > 20",
            "id":IDOLS_SCORE_20
         });
         this._filters.push({
            "label":this.uiApi.getText("ui.common.score") + " > 40",
            "id":IDOLS_SCORE_40
         });
         this._filters.push({
            "label":this.uiApi.getText("ui.common.score") + " > 60",
            "id":IDOLS_SCORE_60
         });
         this.cb_filter.dataProvider = this._filters;
         this.cb_filter.selectedIndex = 0;
         this.gd_icons.dataProvider = this.dataApi.getIdolsPresetIcons();
         this._presetsIdols = new Array();
         this.onIdolsPresetsUpdate(param1.presets);
      }
      
      public function unload() : void
      {
         clearTimeout(this._searchTimeoutId);
         this.uiApi.hideTooltip("IdolsInfo");
         this.sysApi.sendAction(new CloseIdols());
      }
      
      public function updateIdolLine(param1:Object, param2:*, param3:Boolean) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Array = null;
         var _loc6_:Idol = null;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:Vector.<String> = null;
         var _loc10_:Monster = null;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:Number = NaN;
         var _loc14_:PartyMemberWrapper = null;
         var _loc15_:Object = null;
         if(this._forceLineRollOver)
         {
            param2.btn_line.state = StatesEnum.STATE_NORMAL;
            if(param1 && this._activeIdolsIds.indexOf(param1.idolId) != -1)
            {
               param2.btn_line.state = StatesEnum.STATE_SELECTED_OVER;
            }
            else if(param1 && !param1.readOnly && (this._activeIdolsIds.length < MAX_ACTIVE_IDOLS || this._activeIdolsIds.indexOf(param1.idolId) != -1))
            {
               param2.btn_line.state = StatesEnum.STATE_OVER;
            }
            this._forceLineRollOver = false;
            return;
         }
         if(this._forceLineRollOut)
         {
            if(param1 && this._activeIdolsIds.indexOf(param1.idolId) != -1)
            {
               param2.btn_line.state = StatesEnum.STATE_SELECTED;
            }
            else
            {
               param2.btn_line.state = StatesEnum.STATE_NORMAL;
            }
            this._forceLineRollOut = false;
            return;
         }
         param2.btn_line.y = 1;
         param2.btn_line.state = StatesEnum.STATE_NORMAL;
         if(param1)
         {
            if(param1.readOnly || this._activeIdolsIds.length == MAX_ACTIVE_IDOLS && this._activeIdolsIds.indexOf(param1.idolId) == -1)
            {
               param2.btn_line.mouseEnabled = false;
               _loc4_ = this.btn_solo.selected && this._playerIdolsIds.indexOf(param1.idolId) == -1;
            }
            else
            {
               param2.btn_line.mouseEnabled = true;
               _loc4_ = false;
            }
            if(_loc4_)
            {
               param2.lbl_idol_name.cssClass = "bolddisabled";
               param2.lbl_idol_desc.cssClass = "disabled";
               param2.lbl_idol_score.cssClass = "disabledboldright";
            }
            else
            {
               param2.lbl_idol_name.cssClass = "bold";
               param2.lbl_idol_desc.cssClass = "p";
               param2.lbl_idol_score.cssClass = "boldright";
            }
            param2.slot_idol.data = param1.item;
            param2.slot_idol.visible = true;
            param2.lbl_idol_name.text = param1.name;
            param2.lbl_idol_desc.text = param1.description;
            param2.lbl_idol_score.text = param1.score;
            _loc5_ = new Array();
            _loc6_ = this.dataApi.getIdol(param1.idolId);
            if(_loc6_.incompatibleMonsters.length > 0)
            {
               param2.tx_incompatibleMonsters.visible = true;
               for each(_loc11_ in _loc6_.incompatibleMonsters)
               {
                  _loc10_ = this.dataApi.getMonsterFromId(_loc11_);
                  if(_loc10_)
                  {
                     if(!_loc9_)
                     {
                        _loc9_ = new Vector.<String>(0);
                     }
                     _loc9_.push(_loc10_.name);
                  }
               }
               this._txIncompatibleMonstersAssoc[param2.tx_incompatibleMonsters] = _loc9_;
               _loc5_.push(param2.tx_incompatibleMonsters);
            }
            else
            {
               this._txIncompatibleMonstersAssoc[param2.tx_incompatibleMonsters] = null;
               param2.tx_incompatibleMonsters.visible = false;
            }
            param2.tx_partyOnly.visible = param1.partyOnlyIdol;
            if(param2.tx_partyOnly.visible)
            {
               _loc5_.push(param2.tx_partyOnly);
            }
            if(this.btn_group.selected)
            {
               param2.tx_memberIdol.visible = param1.ownersIds.length > 0 && param1.ownersIds.indexOf(this.playerApi.id()) == -1;
               if(param2.tx_memberIdol.visible)
               {
                  _loc5_.push(param2.tx_memberIdol);
               }
               _loc12_ = "";
               if(param1.ownersIds.length > 0)
               {
                  _loc15_ = this.partyApi.getPartyMembers();
                  for each(_loc13_ in param1.ownersIds)
                  {
                     for each(_loc14_ in _loc15_)
                     {
                        if(_loc14_.id == _loc13_)
                        {
                           _loc12_ = _loc12_ + ("\n" + _loc14_.name);
                           break;
                        }
                     }
                  }
               }
               this._txMemberIdolAssoc[param2.tx_memberIdol] = _loc12_;
            }
            else
            {
               param2.tx_memberIdol.visible = false;
            }
            _loc7_ = _loc5_.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc5_[_loc8_].y = (this.gd_idols.slotHeight / _loc7_ - _loc5_[_loc8_].height) / 2 + _loc8_ * this.gd_idols.slotHeight / _loc7_;
               _loc8_++;
            }
            param2.btn_line.selected = this._activeIdolsIds.indexOf(param1.idolId) != -1;
            if(param2.btn_line.selected)
            {
               param2.btn_line.state = StatesEnum.STATE_SELECTED;
            }
         }
         else
         {
            param2.btn_line.mouseEnabled = false;
            param2.slot_idol.data = null;
            param2.slot_idol.visible = false;
            param2.lbl_idol_name.text = "";
            param2.lbl_idol_desc.text = "";
            param2.lbl_idol_score.text = "";
            param2.tx_partyOnly.visible = false;
            param2.tx_memberIdol.visible = false;
            param2.tx_incompatibleMonsters.visible = false;
         }
      }
      
      public function updateIcon(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.tx_icon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("iconsUri") + "small_" + param1.id);
            param2.tx_selected.visible = param3;
         }
         else
         {
            param2.tx_icon.uri = null;
            param2.tx_selected.visible = false;
         }
      }
      
      public function updatePresetLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Vector.<int> = null;
         var _loc5_:Vector.<String> = null;
         var _loc6_:int = 0;
         var _loc7_:Idol = null;
         var _loc8_:int = 0;
         var _loc9_:Monster = null;
         if(param1)
         {
            param2.slot_icon.data = param1.icon;
            param2.gd_presets_idols.dataProvider = param1.idols;
            param2.gd_presets_idols.visible = true;
            param2.lbl_preset_score.text = param1.score;
            param2.lbl_preset_score.visible = true;
            this._btnDeleteAssoc[param2.btn_delete] = param1;
            param2.btn_delete.visible = true;
            for each(_loc8_ in param1.idolsIds)
            {
               _loc7_ = this.dataApi.getIdol(_loc8_);
               if(_loc7_.incompatibleMonsters.length > 0)
               {
                  if(!_loc4_)
                  {
                     _loc4_ = new Vector.<int>(0);
                     _loc5_ = new Vector.<String>(0);
                  }
                  for each(_loc6_ in _loc7_.incompatibleMonsters)
                  {
                     if(_loc4_.indexOf(_loc6_) == -1)
                     {
                        _loc4_.push(_loc6_);
                     }
                  }
               }
            }
            for each(_loc6_ in _loc4_)
            {
               _loc9_ = this.dataApi.getMonsterFromId(_loc6_);
               if(_loc9_)
               {
                  _loc5_.push(_loc9_.name);
               }
            }
            this._txIncompatibleMonstersAssoc[param2.tx_preset_incompatibleMonsters] = _loc5_;
            param2.tx_preset_incompatibleMonsters.visible = !!_loc5_?true:false;
         }
         else
         {
            param2.slot_icon.data = null;
            param2.gd_presets_idols.dataProvider = new Array();
            param2.gd_presets_idols.visible = false;
            param2.lbl_preset_score.visible = false;
            param2.btn_delete.visible = false;
            param2.tx_preset_incompatibleMonsters.visible = false;
         }
      }
      
      private function openSoloTab() : void
      {
         var _loc1_:ItemWrapper = null;
         this.btn_solo.selected = true;
         this.btn_showSynergyScore.x = this.btn_showAll.x + this.btn_showAll.width + 30;
         this.switchTab();
         this._activeIdolsIds.length = 0;
         for each(_loc1_ in this._currentActiveSoloIdols)
         {
            this._activeIdolsIds.push(this.dataApi.getIdolByItemId(_loc1_.objectGID).id);
         }
         this.gd_activeIdols.dataProvider = this._currentActiveSoloIdols;
         this.updateIdolsScores();
         this.refreshSoloIdolsList();
         this.updateTotals();
         this.updateList();
      }
      
      private function openGroupTab() : void
      {
         var _loc1_:ItemWrapper = null;
         this.btn_group.selected = true;
         this.btn_showSynergyScore.x = this.btn_showAll.x;
         this.switchTab();
         this._activeIdolsIds.length = 0;
         for each(_loc1_ in this._currentActiveGroupIdols)
         {
            this._activeIdolsIds.push(this.dataApi.getIdolByItemId(_loc1_.objectGID).id);
         }
         this.gd_activeIdols.dataProvider = this._currentActiveGroupIdols;
         this.updateIdolsScores();
         this.gd_idols.dataProvider = this._groupIdols;
         this.updateTotals();
         this.updateList();
      }
      
      private function openPresetsTab() : void
      {
         this.btn_presets.selected = true;
         this.switchTab(true);
         this._btnDeleteAssoc = new Dictionary();
         this.gd_activeIdols.dataProvider = this._currentActiveSoloIdols;
         this.gd_presets.dataProvider = this._presetsIdols;
         this.applyPresetSort();
      }
      
      private function switchTab(param1:Boolean = false) : void
      {
         this.lbl_exp.visible = this.lbl_loot.visible = !param1;
         this.tx_synergy.visible = !param1;
         this.ctr_idols.visible = !param1;
         this.btn_showAll.visible = this.btn_solo.selected;
         this.btn_showSynergyScore.visible = this.btn_solo.selected || this.btn_group.selected;
         this.ctr_presets.visible = param1;
      }
      
      private function updateGroupIdols(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Idol = null;
         var _loc5_:Object = null;
         this._groupIdols = new Array();
         this._currentActiveGroupIdols = new Vector.<ItemWrapper>(0);
         var _loc6_:uint = param1.length;
         var _loc7_:uint = param2.length;
         _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc4_ = this.dataApi.getIdol(param1[_loc3_]);
            this._currentActiveGroupIdols.push(this.dataApi.getItemWrapper(_loc4_.itemId));
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc7_)
         {
            _loc5_ = param2[_loc3_];
            _loc4_ = this.dataApi.getIdol(_loc5_.id);
            this._groupIdols.push(this.getIdolData(_loc4_,_loc5_.ownersIds,param1.indexOf(_loc4_.id) != -1,!this._isPartyLeader));
            _loc3_++;
         }
      }
      
      private function getIdolData(param1:Object, param2:Object, param3:Boolean = false, param4:Boolean = false) : Object
      {
         if(param3 && this._activeIdolsIds.indexOf(param1.id) == -1)
         {
            this._activeIdolsIds.push(param1.id);
         }
         var _loc5_:Object = this.dataApi.getItemWrapper(param1.itemId);
         return {
            "idol":param1,
            "idolId":param1.id,
            "item":_loc5_,
            "name":_loc5_.name,
            "description":param1.spellPair.description,
            "score":param1.score,
            "bonusXp":param1.experienceBonus,
            "bonusDrop":param1.dropBonus,
            "ownersIds":param2,
            "partyOnlyIdol":param1.groupOnly,
            "active":param3,
            "readOnly":param4
         };
      }
      
      private function selectIdol(param1:uint, param2:Boolean, param3:Grid) : void
      {
         if(param2 && this._activeIdolsIds.length == MAX_ACTIVE_IDOLS)
         {
            return;
         }
         this._idolsSelections.push(new IdolSelection(param1,this.dataApi.getIdol(param1).itemId,param2,param3,param3.selectedIndex));
         this.sysApi.sendAction(new IdolSelectRequest(param1,param2,!this.btn_solo.selected));
      }
      
      private function enableIdol(param1:uint, param2:Boolean) : void
      {
         var _loc4_:ItemWrapper = null;
         var _loc3_:Vector.<ItemWrapper> = !param2?this._currentActiveSoloIdols:this._currentActiveGroupIdols;
         if(_loc3_.length < MAX_ACTIVE_IDOLS)
         {
            _loc4_ = this.dataApi.getItemWrapper(this.dataApi.getIdol(param1).itemId);
            _loc3_.push(_loc4_);
            if(!param2 && this.btn_solo.selected || param2 && this.btn_group.selected)
            {
               this._activeIdolsIds.push(param1);
               this.gd_activeIdols.dataProvider = _loc3_;
               this.updateTotals();
            }
         }
      }
      
      private function disableIdol(param1:uint, param2:Boolean) : void
      {
         var _loc4_:ItemWrapper = null;
         var _loc6_:int = 0;
         var _loc3_:Vector.<ItemWrapper> = !param2?this._currentActiveSoloIdols:this._currentActiveGroupIdols;
         var _loc5_:uint = this.dataApi.getIdol(param1).itemId;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.objectGID == _loc5_)
            {
               _loc6_ = _loc3_.indexOf(_loc4_);
               if(_loc6_ != -1)
               {
                  _loc3_.splice(_loc6_,1);
               }
               break;
            }
         }
         if(!param2 && (this.btn_solo.selected || this.btn_presets.selected) || param2 && this.btn_group.selected)
         {
            _loc6_ = this._activeIdolsIds.indexOf(param1);
            if(_loc6_ != -1)
            {
               this._activeIdolsIds.splice(_loc6_,1);
            }
            this.gd_activeIdols.dataProvider = _loc3_;
            this.updateTotals();
         }
      }
      
      private function showIdolTooltip(param1:Object, param2:Object) : void
      {
         if(param1)
         {
            this.uiApi.showTooltip(param1,param2,false,"IdolsInfo",LocationEnum.POINT_BOTTOMLEFT,LocationEnum.POINT_BOTTOMRIGHT,3,null,null);
         }
      }
      
      private function showItemMenu(param1:Object) : void
      {
         var _loc2_:Object = this.menuApi.create(param1);
         if(_loc2_ && _loc2_.content.length > 0)
         {
            this.uiApi.hideTooltip("IdolsInfo");
            this.modContextMenu.createContextMenu(_loc2_);
         }
      }
      
      private function updateTotals() : void
      {
         var _loc1_:int = 0;
         var _loc3_:Idol = null;
         var _loc4_:Number = NaN;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<int> = null;
         var _loc7_:Vector.<String> = null;
         var _loc8_:int = 0;
         var _loc9_:Monster = null;
         var _loc2_:uint = this._activeIdolsIds.length;
         this._totalScore = this._totalExp = this._totalLoot = 0;
         this._positiveSynergies = new Dictionary();
         this._negativeSynergies = new Dictionary();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.dataApi.getIdol(this._activeIdolsIds[_loc1_]);
            _loc4_ = this.getIdolCoeff(_loc3_,this._activeIdolsIds);
            this._totalScore = this._totalScore + _loc3_.score * _loc4_;
            this._totalExp = this._totalExp + _loc3_.experienceBonus * _loc4_;
            this._totalLoot = this._totalLoot + _loc3_.dropBonus * _loc4_;
            _loc5_ = _loc5_ + _loc3_.score;
            if(_loc3_.incompatibleMonsters.length > 0)
            {
               if(!_loc6_)
               {
                  _loc6_ = new Vector.<int>(0);
                  _loc7_ = new Vector.<String>(0);
               }
               for each(_loc8_ in _loc3_.incompatibleMonsters)
               {
                  if(_loc6_.indexOf(_loc8_) == -1)
                  {
                     _loc6_.push(_loc8_);
                  }
               }
            }
            _loc1_++;
         }
         this._totalExp = this.computeExpBonusWithWisdom(this._totalExp);
         this._totalLoot = this.computeLootBonusWithProspecting(this._totalLoot);
         this.lbl_score.text = this._totalScore.toString();
         this.lbl_exp.text = this.uiApi.getText("ui.idol.bonusXp",this._totalExp) + " %";
         this.lbl_loot.text = this.uiApi.getText("ui.idol.bonusLoot",this._totalLoot) + " %";
         this._globalSynergy = this._totalScore / _loc5_;
         this.tx_synergy.visible = !this.btn_presets.selected?this.hasSynergies(true) || this.hasSynergies(false):Boolean(null);
         for each(_loc8_ in _loc6_)
         {
            _loc9_ = this.dataApi.getMonsterFromId(_loc8_);
            if(_loc9_)
            {
               _loc7_.push(_loc9_.name);
            }
         }
         this._txIncompatibleMonstersAssoc[this.tx_allIncompatibleMonsters] = _loc7_;
         this.tx_allIncompatibleMonsters.visible = !!_loc7_?true:false;
      }
      
      private function getIdolCoeff(param1:Idol, param2:Object, param3:Boolean = true) : Number
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc4_:Number = 1;
         var _loc5_:Object = param1.synergyIdolsIds;
         var _loc6_:Object = param1.synergyIdolsCoeff;
         var _loc7_:uint = _loc5_.length;
         var _loc10_:uint = param2.length;
         _loc8_ = 0;
         while(_loc8_ < _loc10_)
         {
            _loc9_ = 0;
            while(_loc9_ < _loc7_)
            {
               if(_loc5_[_loc9_] == param2[_loc8_])
               {
                  if(_loc6_[_loc9_] > 1)
                  {
                     this.addSynergy(!!param3?this._positiveSynergies:this._tmpPositiveSynergies,param1.id,_loc5_[_loc9_],_loc6_[_loc9_]);
                  }
                  else if(_loc6_[_loc9_] < 1)
                  {
                     this.addSynergy(!!param3?this._negativeSynergies:this._tmpNegativeSynergies,param1.id,_loc5_[_loc9_],_loc6_[_loc9_]);
                  }
                  _loc4_ = _loc4_ * _loc6_[_loc9_];
               }
               _loc9_++;
            }
            _loc8_++;
         }
         return _loc4_;
      }
      
      private function computeExpBonusWithWisdom(param1:uint) : uint
      {
         var _loc2_:int = this.playerApi.characteristics().wisdom.base + this.playerApi.characteristics().wisdom.additionnal + this.playerApi.characteristics().wisdom.objectsAndMountBonus + this.playerApi.characteristics().wisdom.alignGiftBonus + this.playerApi.characteristics().wisdom.contextModif;
         var _loc3_:int = this.playerApi.getPlayedCharacterInfo().level;
         if(_loc3_ > ProtocolConstantsEnum.MAX_LEVEL)
         {
            _loc3_ = ProtocolConstantsEnum.MAX_LEVEL;
         }
         return Math.max((2.5 * _loc3_ + 100) * param1 / (_loc2_ + 100),0);
      }
      
      private function computeLootBonusWithProspecting(param1:uint) : uint
      {
         var _loc2_:int = this.playerApi.characteristics().prospecting.base + this.playerApi.characteristics().prospecting.additionnal + this.playerApi.characteristics().prospecting.objectsAndMountBonus + this.playerApi.characteristics().prospecting.alignGiftBonus + this.playerApi.characteristics().prospecting.contextModif;
         var _loc3_:int = this.playerApi.getPlayedCharacterInfo().level;
         if(_loc3_ > ProtocolConstantsEnum.MAX_LEVEL)
         {
            _loc3_ = ProtocolConstantsEnum.MAX_LEVEL;
         }
         return Math.max((0.5 * _loc3_ + 100) * param1 / (_loc2_ + 100),0);
      }
      
      private function addSynergy(param1:Dictionary, param2:uint, param3:uint, param4:Number) : void
      {
         var _loc5_:IdolSynergy = null;
         if(!param1[param2])
         {
            param1[param2] = new Vector.<IdolSynergy>(0);
         }
         for each(_loc5_ in param1[param2])
         {
            if(_loc5_.idolId == param3)
            {
               return;
            }
         }
         param1[param2].push(new IdolSynergy(param3,param4));
      }
      
      private function getSynergiesText(param1:Dictionary, param2:Boolean) : String
      {
         var _loc4_:* = undefined;
         var _loc5_:Idol = null;
         var _loc7_:Vector.<IdolSynergy> = null;
         var _loc8_:String = null;
         var _loc3_:String = "<ul>";
         var _loc6_:Vector.<int> = new Vector.<int>(0);
         for(_loc4_ in param1)
         {
            _loc5_ = this.dataApi.getIdol(_loc4_);
            _loc7_ = param1[_loc4_];
            _loc8_ = this.getSynergyText(_loc4_,_loc7_,_loc6_);
            if(_loc8_.length > 0)
            {
               _loc3_ = _loc3_ + ("<li><b>" + _loc5_.item.name + "</b>" + this.uiApi.getText("ui.common.colon") + _loc8_ + "</li>");
               _loc6_.push(_loc4_);
            }
         }
         return _loc3_ + "</ul>";
      }
      
      private function getSynergyText(param1:int, param2:Vector.<IdolSynergy>, param3:Vector.<int> = null, param4:Boolean = false) : String
      {
         var _loc6_:IdolSynergy = null;
         var _loc7_:Idol = null;
         var _loc5_:String = "";
         var _loc8_:Boolean = true;
         for each(_loc6_ in param2)
         {
            if((!param4 || this._activeIdolsIds.indexOf(_loc6_.idolId) != -1) && (!param3 || param3.indexOf(_loc6_.idolId) == -1))
            {
               _loc7_ = this.dataApi.getIdol(_loc6_.idolId);
               _loc5_ = _loc5_ + ((!!_loc8_?"":", ") + _loc7_.item.name + " (x" + "<font color=\'" + (_loc6_.synergyCoeff > 1?"#009900":"#c10000") + "\'>" + _loc6_.synergyCoeff.toFixed(2) + "</font>" + ")");
               _loc8_ = false;
            }
         }
         return _loc5_;
      }
      
      private function refreshSoloIdolsList() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         if(this.btn_showAll.selected)
         {
            _loc1_ = this.dataApi.getAllIdols();
            _loc3_ = _loc1_.length;
            _loc4_ = this._soloIdols.concat();
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc5_ = _loc1_[_loc2_];
               if(this._playerIdolsIds.indexOf(_loc5_.id) == -1)
               {
                  _loc4_.push(this.getIdolData(_loc5_,null,false,true));
               }
               _loc2_++;
            }
            this.gd_idols.dataProvider = _loc4_;
         }
         else
         {
            this.gd_idols.dataProvider = this._soloIdols;
         }
      }
      
      private function applySort() : void
      {
         var _loc1_:String = this.sysApi.getData(IDOLS_LAST_SORT);
         var _loc2_:* = this.sysApi.getData(IDOLS_LAST_SORT_ORDER);
         if(!this._lastSortType && !_loc1_)
         {
            this.onRelease(this.btn_sortIdolByName);
            return;
         }
         var _loc3_:String = !!this._lastSortType?this._lastSortType:_loc1_;
         if(_loc3_)
         {
            this._lastSortType = _loc3_;
            this._ascendingSort = _loc2_ != null?!_loc2_:false;
            if(_loc3_ == "name")
            {
               this.onRelease(this.btn_sortIdolByName);
            }
            else if(_loc3_ == "score")
            {
               this.onRelease(this.btn_sortIdolByScore);
            }
         }
      }
      
      private function sort(param1:Object, param2:String, param3:Boolean, param4:Boolean) : Object
      {
         var _loc5_:Object = null;
         if(param4)
         {
            this.utilApi.sortOnString(param1,param2,param3);
            _loc5_ = param1;
         }
         else
         {
            _loc5_ = this.utilApi.sort(param1,param2,param3,true);
         }
         return _loc5_;
      }
      
      private function applyFilter(param1:uint) : void
      {
         switch(param1)
         {
            case ALL_IDOLS_FILTER:
               this.gd_idols.dataProvider = this._currentDataProvider;
               break;
            case PARTY_IDOLS_FILTER:
               this.filter("partyOnlyIdol",true);
               break;
            case SOLO_IDOLS_FILTER:
               this.filter("partyOnlyIdol",false);
               break;
            case IDOLS_SCORE_20:
               this.filter("score",20,">");
               break;
            case IDOLS_SCORE_40:
               this.filter("score",40,">");
               break;
            case IDOLS_SCORE_60:
               this.filter("score",60,">");
         }
         this._currentFilter = param1;
         this._filteredDataProvider = this.gd_idols.dataProvider;
      }
      
      private function filter(param1:String, param2:*, param3:String = "==") : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         this._currentDataProvider = this.gd_idols.dataProvider;
         var _loc4_:uint = !!this._currentDataProvider?uint(this._currentDataProvider.length):uint(0);
         if(_loc4_ > 0)
         {
            _loc5_ = new Array();
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc7_ = this._currentDataProvider[_loc6_];
               if(param3 == "==")
               {
                  if(_loc7_[param1] == param2)
                  {
                     _loc5_.push(_loc7_);
                  }
               }
               else if(param3 == ">")
               {
                  if(_loc7_[param1] > param2)
                  {
                     _loc5_.push(_loc7_);
                  }
               }
               _loc6_++;
            }
            this.gd_idols.dataProvider = _loc5_;
         }
      }
      
      private function stopSearch() : void
      {
         clearTimeout(this._searchTimeoutId);
         this.inp_search.text = this._searchText;
         this.gd_idols.dataProvider = this._filteredDataProvider;
         this._filteredDataProvider = null;
      }
      
      private function getSearchText() : String
      {
         if(this.inp_search.text != this._searchText)
         {
            return this.inp_search.text;
         }
         return "";
      }
      
      private function updateList() : void
      {
         this.applySort();
         this.applyFilter(this._currentFilter);
         clearTimeout(this._searchTimeoutId);
         this.onSearch();
      }
      
      private function deletePreset() : void
      {
         this.sysApi.sendAction(new d2actions.IdolsPresetDelete(this._presetToDelete.presetId));
      }
      
      private function doNothing() : void
      {
         this._presetToDelete = null;
      }
      
      private function savePreset(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:Idol = null;
         var _loc6_:Number = NaN;
         _loc2_ = new Object();
         _loc2_.presetId = param1.id;
         _loc2_.iconId = param1.gfxId;
         _loc2_.icon = param1;
         _loc2_.idolsIds = param1.idolsIds;
         _loc2_.idols = new Array();
         _loc3_ = 0;
         _loc4_ = 0;
         while(_loc4_ < param1.idolsIds.length)
         {
            _loc5_ = this.dataApi.getIdol(param1.idolsIds[_loc4_]);
            _loc6_ = this.getIdolCoeff(_loc5_,param1.idolsIds);
            _loc3_ = _loc3_ + _loc5_.score * _loc6_;
            _loc2_.idols.push(this.dataApi.getItemWrapper(_loc5_.itemId));
            _loc4_++;
         }
         _loc2_.score = _loc3_;
         this._presetsIdols.push(_loc2_);
      }
      
      private function applyPresetSort() : void
      {
         var _loc1_:String = this.sysApi.getData(IDOLS_PRESET_LAST_SORT);
         var _loc2_:* = this.sysApi.getData(IDOLS_PRESET_LAST_SORT_ORDER);
         if(!this._lastPresetSortType && !_loc1_)
         {
            this._lastPresetSortType = "presetId";
            this.gd_presets.dataProvider = this.utilApi.sort(this._presetsIdols,this._lastPresetSortType,this._presetAscendingSort,true);
            this.sysApi.setData(IDOLS_LAST_SORT,this._lastPresetSortType);
            this.sysApi.setData(IDOLS_LAST_SORT_ORDER,this._presetAscendingSort);
            return;
         }
         var _loc3_:String = !!this._lastPresetSortType?this._lastPresetSortType:_loc1_;
         if(_loc3_)
         {
            this._lastPresetSortType = _loc3_;
            this._presetAscendingSort = _loc2_ != null?!_loc2_:false;
            if(_loc3_ == "presetId")
            {
               this.gd_presets.dataProvider = this.utilApi.sort(this._presetsIdols,_loc3_,true,true);
               this.sysApi.setData(IDOLS_PRESET_LAST_SORT,this._lastPresetSortType);
               this.sysApi.setData(IDOLS_PRESET_LAST_SORT_ORDER,this._presetAscendingSort);
            }
            else if(_loc3_ == "score")
            {
               this.onRelease(this.btn_sortPresetsByScore);
            }
         }
      }
      
      private function getFreePresetId() : uint
      {
         var _loc1_:uint = 0;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:Boolean = false;
         var _loc2_:uint = this.gd_icons.dataProvider.length;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = false;
            for each(_loc3_ in this._presetsIdols)
            {
               if(_loc3_.presetId == _loc4_)
               {
                  _loc5_ = true;
                  break;
               }
            }
            if(!_loc5_)
            {
               _loc1_ = _loc4_;
               break;
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      private function initButtonValue(param1:String, param2:ButtonContainer, param3:Boolean) : void
      {
         var _loc4_:* = this.sysApi.getData(param1);
         param2.selected = _loc4_ != null?Boolean(_loc4_):Boolean(param3);
         this.sysApi.setData(param1,param2.selected);
      }
      
      private function updateIdolsScores(param1:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc9_:* = undefined;
         var _loc2_:Array = !!this.btn_solo.selected?this._soloIdols:this._groupIdols;
         var _loc6_:Dictionary = new Dictionary();
         var _loc7_:Array = new Array();
         var _loc8_:Vector.<int> = new Vector.<int>();
         this._tmpPositiveSynergies = new Dictionary();
         this._tmpNegativeSynergies = new Dictionary();
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.idol.score;
            if(this.btn_showSynergyScore.selected)
            {
               if(this._activeIdolsIds.indexOf(_loc3_.idolId) != -1)
               {
                  _loc8_.length = 0;
                  _loc5_ = 0;
                  for(_loc9_ in _loc6_)
                  {
                     _loc5_ = _loc5_ + _loc6_[_loc9_];
                     _loc8_.push(_loc9_);
                  }
                  _loc8_.push(_loc3_.idolId);
                  _loc4_ = this.getTotalScore(_loc8_) - _loc5_;
                  _loc6_[_loc3_.idolId] = _loc4_;
               }
               else
               {
                  _loc7_.push(_loc3_);
               }
            }
            _loc3_.score = _loc4_;
         }
         for each(_loc3_ in _loc7_)
         {
            _loc8_.length = 0;
            _loc5_ = 0;
            for(_loc9_ in _loc6_)
            {
               _loc5_ = _loc5_ + _loc6_[_loc9_];
               _loc8_.push(_loc9_);
            }
            _loc8_.push(_loc3_.idolId);
            _loc3_.score = this.getTotalScore(_loc8_) - _loc5_;
         }
         if(param1)
         {
            if(this.btn_solo.selected)
            {
               this.refreshSoloIdolsList();
            }
            else if(this.btn_group.selected)
            {
               this.gd_idols.dataProvider = this._groupIdols;
            }
            this.updateList();
         }
      }
      
      private function getTotalScore(param1:Vector.<int>) : uint
      {
         var _loc3_:Idol = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc2_:uint = 0;
         var _loc6_:uint = param1.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc3_ = this.dataApi.getIdol(param1[_loc5_]);
            _loc4_ = this.getIdolCoeff(_loc3_,param1,false);
            _loc2_ = _loc2_ + _loc3_.score * _loc4_;
            _loc5_++;
         }
         return _loc2_;
      }
      
      private function getIndexFromComponent(param1:Object) : int
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.gd_idols.slots)
         {
            if(_loc2_.contains(param1))
            {
               return this.gd_idols.getIndex() + _loc2_.y / this.gd_idols.slotHeight;
            }
         }
         return -1;
      }
      
      private function hasSynergies(param1:Boolean) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc2_:Dictionary = !!param1?this._positiveSynergies:this._negativeSynergies;
         for(_loc3_ in _loc2_)
         {
            return true;
         }
         return false;
      }
      
      public function onIdolSelected(param1:uint, param2:Boolean, param3:Boolean) : void
      {
         var _loc6_:int = 0;
         var _loc7_:* = false;
         var _loc8_:int = 0;
         var _loc9_:uint = 0;
         var _loc10_:* = false;
         var _loc11_:uint = 0;
         var _loc4_:Boolean = param3 && !this.btn_group.softDisabled && (!this._isPartyLeader || this._idolsSelections.length == 0);
         var _loc5_:IdolSelection = !_loc4_ && this._idolsSelections.length > 0?this._idolsSelections.shift():null;
         if(_loc4_ || _loc5_ && _loc5_.idolId == param1 && _loc5_.activate == param2)
         {
            if(param2)
            {
               this.enableIdol(param1,param3);
               _loc7_ = this._activeIdolsIds.length == MAX_ACTIVE_IDOLS;
            }
            else
            {
               this.disableIdol(param1,param3);
               _loc7_ = this._activeIdolsIds.length == MAX_ACTIVE_IDOLS - 1;
            }
            _loc9_ = this.gd_idols.dataProvider.length;
            if(_loc4_)
            {
               _loc11_ = this.dataApi.getIdol(param1).itemId;
               _loc8_ = 0;
               while(_loc8_ < _loc9_)
               {
                  if(this.gd_idols.dataProvider[_loc8_].item.objectGID == _loc11_)
                  {
                     _loc6_ = _loc8_;
                     break;
                  }
                  _loc8_++;
               }
            }
            else if(_loc5_)
            {
               if(_loc5_.target == this.gd_activeIdols)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc9_)
                  {
                     if(this.gd_idols.dataProvider[_loc8_].item.objectGID == _loc5_.itemId)
                     {
                        _loc6_ = _loc8_;
                        break;
                     }
                     _loc8_++;
                  }
                  this.uiApi.hideTooltip("IdolsInfo");
               }
               else if(_loc5_.target == this.gd_idols)
               {
                  _loc10_ = !param2;
                  _loc6_ = _loc5_.selectedIndex;
               }
            }
            if(!this.btn_showSynergyScore.selected)
            {
               if(!_loc7_)
               {
                  this.gd_idols.updateItem(_loc6_);
               }
               else
               {
                  this.gd_idols.dataProvider = this.gd_idols.dataProvider;
               }
            }
            else
            {
               this.updateIdolsScores(true);
            }
            if(_loc10_)
            {
               _loc6_ = this.gd_idols.getIndex() + Math.floor(this.gd_idols.mouseY / this.gd_idols.slotHeight);
               this._forceLineRollOver = true;
               this.gd_idols.updateItem(_loc6_);
            }
         }
      }
      
      public function onIdolSelectError(param1:uint, param2:uint, param3:Boolean, param4:Boolean) : void
      {
         var _loc5_:IdolSelection = this._idolsSelections.length > 0?this._idolsSelections.shift():null;
      }
      
      public function onCharacterStatsList(param1:Boolean = false) : void
      {
         if(!param1)
         {
            this.updateTotals();
         }
      }
      
      public function onPartyLeave(param1:int, param2:Boolean) : void
      {
         if(this.btn_group.selected)
         {
            this.openSoloTab();
         }
         this.btn_group.softDisabled = true;
      }
      
      public function onIdolAdded(param1:uint) : void
      {
         if(this._playerIdolsIds.indexOf(param1) == -1)
         {
            this._playerIdolsIds.push(param1);
            this._soloIdols.unshift(this.getIdolData(this.dataApi.getIdol(param1),null));
            if(this.btn_solo.selected)
            {
               this.updateIdolsScores();
               this.refreshSoloIdolsList();
               this.updateList();
            }
         }
      }
      
      public function onIdolRemoved(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = this._soloIdols.length;
         var _loc4_:int = -1;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this._soloIdols[_loc2_].idolId == param1)
            {
               _loc4_ = _loc2_;
               break;
            }
            _loc2_++;
         }
         if(_loc4_ != -1)
         {
            this._playerIdolsIds.splice(this._playerIdolsIds.indexOf(param1),1);
            this._soloIdols.splice(_loc4_,1);
            if(!this.btn_group.selected)
            {
               this.disableIdol(param1,false);
               this.updateIdolsScores();
               this.refreshSoloIdolsList();
               this.updateList();
            }
         }
      }
      
      public function onIdolsList(param1:Object, param2:Object, param3:Object) : void
      {
         this.updateGroupIdols(param2,param3);
         if(param3.length > 0 && this.btn_group.softDisabled)
         {
            this.btn_group.softDisabled = false;
         }
      }
      
      public function onIdolPartyRefresh(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:Idol = null;
         for each(_loc2_ in this._groupIdols)
         {
            if(_loc2_.idolId == param1.id)
            {
               _loc3_ = true;
               break;
            }
         }
         if(!_loc3_)
         {
            _loc4_ = this.dataApi.getIdol(param1.id);
            this._groupIdols.unshift(this.getIdolData(_loc4_,param1.ownersIds,false,!this._isPartyLeader));
         }
         else if(_loc2_)
         {
            _loc2_.ownersIds = param1.ownersIds;
            _loc2_.bonusXp = param1.xpBonusPercent;
            _loc2_.bonusDrop = param1.dropBonusPercent;
         }
         if(this.btn_group.selected)
         {
            this.updateIdolsScores();
            this.gd_idols.dataProvider = this._groupIdols;
            this.updateList();
         }
      }
      
      public function onIdolPartyLost(param1:uint) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = -1;
         for each(_loc2_ in this._groupIdols)
         {
            if(_loc2_.idolId == param1)
            {
               _loc3_ = this._groupIdols.indexOf(_loc2_);
               break;
            }
         }
         if(_loc3_ != -1)
         {
            this._groupIdols.splice(_loc3_,1);
         }
         if(this.btn_group.selected)
         {
            this.disableIdol(param1,true);
            this.updateIdolsScores();
            this.gd_idols.dataProvider = this._groupIdols;
            this.updateList();
         }
      }
      
      public function onIdolsPresetsUpdate(param1:Object) : void
      {
         var _loc2_:Object = null;
         this._presetsIdols.length = 0;
         for each(_loc2_ in param1)
         {
            this.savePreset(_loc2_);
         }
      }
      
      public function onIdolsPresetDelete(param1:uint) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         for each(_loc2_ in this._presetsIdols)
         {
            if(_loc2_.presetId == param1)
            {
               _loc3_ = this._presetsIdols.indexOf(_loc2_);
               break;
            }
         }
         this._presetsIdols.splice(_loc3_,1);
         this.gd_presets.dataProvider = this._presetsIdols;
         this.applyPresetSort();
         this._presetToDelete = null;
      }
      
      public function onIdolsPresetEquipped(param1:uint) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Idol = null;
         var _loc4_:ItemWrapper = null;
         var _loc5_:Boolean = this.btn_solo.selected || this.btn_presets.selected;
         this._currentActiveSoloIdols.length = 0;
         if(_loc5_)
         {
            this._activeIdolsIds.length = 0;
         }
         for each(_loc2_ in this._presetsIdols)
         {
            if(_loc2_.presetId == param1)
            {
               for each(_loc4_ in _loc2_.idols)
               {
                  _loc3_ = this.dataApi.getIdolByItemId(_loc4_.objectGID);
                  if(this._playerIdolsIds.indexOf(_loc3_.id) != -1)
                  {
                     this._currentActiveSoloIdols.push(this.dataApi.getItemWrapper(_loc3_.itemId));
                     if(_loc5_)
                     {
                        this._activeIdolsIds.push(_loc3_.id);
                     }
                  }
               }
               break;
            }
         }
         if(_loc5_)
         {
            this.updateTotals();
         }
         if(!this.btn_group.selected)
         {
            this.gd_activeIdols.dataProvider = this._currentActiveSoloIdols;
            if(this.btn_solo.selected)
            {
               this.gd_idols.dataProvider = this.gd_idols.dataProvider;
            }
         }
      }
      
      public function onIdolsPresetSaved(param1:Object) : void
      {
         this.savePreset(param1);
         this.gd_presets.dataProvider = this._presetsIdols;
         this.applyPresetSort();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         switch(param1)
         {
            case this.gd_activeIdols:
               if(!this._isInFight && (!this.btn_group.selected || this._isPartyLeader) && param2 == SelectMethodEnum.DOUBLE_CLICK)
               {
                  this.selectIdol(this.dataApi.getIdolByItemId(param1.selectedItem.objectGID).id,false,this.gd_activeIdols);
               }
               break;
            case this.gd_idols:
               if(!this._isInFight && param2 == SelectMethodEnum.CLICK)
               {
                  _loc4_ = param1.selectedItem;
                  if(_loc4_ && !_loc4_.readOnly)
                  {
                     this.selectIdol(_loc4_.idolId,this._activeIdolsIds.indexOf(_loc4_.idolId) == -1,this.gd_idols);
                  }
               }
               break;
            case this.cb_filter:
               this.applyFilter(param1.selectedItem.id);
               break;
            case this.gd_icons:
               this._currentIcon = param1.selectedItem.id;
         }
      }
      
      public function onGameFightStart() : void
      {
         this._isInFight = true;
      }
      
      public function onGameFightEnd(param1:Object) : void
      {
         this._isInFight = false;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:int = 0;
         var _loc6_:Idol = null;
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               return;
            case this.btn_solo:
               this.openSoloTab();
               break;
            case this.btn_group:
               this.openGroupTab();
               break;
            case this.btn_presets:
               this.openPresetsTab();
               break;
            case this.btn_showAll:
               this.refreshSoloIdolsList();
               this.sysApi.setData(IDOLS_SHOW_ALL,this.btn_showAll.selected);
               this.updateList();
               break;
            case this.btn_showSynergyScore:
               this.updateIdolsScores(true);
               this.sysApi.setData(IDOLS_SHOW_SYNERGY_SCORE,this.btn_showSynergyScore.selected);
               break;
            case this.btn_sortIdolByName:
            case this.btn_sortIdolByScore:
               _loc2_ = this._sortFieldAssoc[param1];
               this._ascendingSort = _loc2_ != this._lastSortType?true:!this._ascendingSort;
               this._lastSortType = _loc2_;
               this.sysApi.setData(IDOLS_LAST_SORT,this._lastSortType);
               this.sysApi.setData(IDOLS_LAST_SORT_ORDER,this._ascendingSort);
               this.gd_idols.dataProvider = this.sort(this.gd_idols.dataProvider,_loc2_,this._ascendingSort,_loc2_ == "name");
               this._currentDataProvider = this.gd_idols.dataProvider;
               if(this._filteredDataProvider)
               {
                  this._filteredDataProvider = this.sort(this._filteredDataProvider,_loc2_,this._ascendingSort,_loc2_ == "name");
               }
               break;
            case this.inp_search:
               if(this.inp_search.text == this._searchText)
               {
                  this.inp_search.text = "";
               }
               break;
            case this.btn_closeSearch:
               this.stopSearch();
               break;
            case this.btn_savePreset:
               for each(_loc3_ in this._presetsIdols)
               {
                  if(_loc3_.iconId == this._currentIcon)
                  {
                     this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.idol.presets.iconUsed"),[this.uiApi.getText("ui.common.ok")]);
                     return;
                  }
               }
               _loc4_ = new Vector.<uint>(0);
               _loc5_ = 0;
               while(_loc5_ < this._currentActiveSoloIdols.length)
               {
                  _loc6_ = this.dataApi.getIdolByItemId(this._currentActiveSoloIdols[_loc5_].objectGID);
                  _loc4_.push(_loc6_.id);
                  _loc5_++;
               }
               this.sysApi.sendAction(new IdolsPresetSave(this.getFreePresetId(),this._currentIcon,_loc4_));
               break;
            case this.btn_sortPresetsByScore:
               this._presetAscendingSort = !this._presetAscendingSort;
               this.gd_presets.dataProvider = this.utilApi.sort(this._presetsIdols,"score",this._presetAscendingSort,true);
               this._lastPresetSortType = "score";
               this.sysApi.setData(IDOLS_PRESET_LAST_SORT,this._lastPresetSortType);
               this.sysApi.setData(IDOLS_PRESET_LAST_SORT_ORDER,this._presetAscendingSort);
               break;
            default:
               if(param1.name.indexOf("btn_delete") != -1 && this._btnDeleteAssoc[param1])
               {
                  this._presetToDelete = this._btnDeleteAssoc[param1];
                  this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.idol.presets.delete"),[this.uiApi.getText("ui.common.ok"),this.uiApi.getText("ui.common.cancel")],[this.deletePreset,this.doNothing],this.deletePreset,this.doNothing);
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc3_:* = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Idol = null;
         var _loc12_:Number = NaN;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:* = false;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc2_:int = this.getIndexFromComponent(param1);
         if(param1.name.indexOf("gd_idols") != -1)
         {
            if(!this.gd_idols.dataProvider[_loc2_])
            {
               return;
            }
            this._forceLineRollOver = true;
            this.gd_idols.updateItem(_loc2_);
         }
         if(param1.name.indexOf("slot_idol") != -1)
         {
            this.showIdolTooltip(param1.data,param1);
         }
         else
         {
            if(param1.name.indexOf("tx_partyOnly") != -1)
            {
               _loc3_ = this.uiApi.getText("ui.idol.partyOnlyIdol");
            }
            else if(param1.name.indexOf("tx_memberIdol") != -1)
            {
               _loc4_ = this._txMemberIdolAssoc[param1];
               _loc3_ = this.uiApi.getText("ui.idol.idolOwner",_loc4_);
            }
            else if(param1.name.toLowerCase().indexOf("incompatiblemonsters") != -1)
            {
               if(this._txIncompatibleMonstersAssoc[param1])
               {
                  _loc3_ = this.uiApi.getText("ui.idol.incompatibleMonsters",this._txIncompatibleMonstersAssoc[param1].join("\n"));
               }
            }
            else if(param1.name.indexOf("lbl_exp") != -1)
            {
               _loc3_ = this.uiApi.getText("ui.idol.tooltip.bonusExp");
            }
            else if(param1.name.indexOf("lbl_loot") != -1)
            {
               _loc3_ = this.uiApi.getText("ui.idol.tooltip.bonusLoot");
            }
            else if(param1.name.indexOf("tx_synergy") != -1)
            {
               if(this._globalSynergy < 1)
               {
                  _loc5_ = "#c10000";
               }
               else if(this._globalSynergy > 1)
               {
                  _loc5_ = "#009900";
               }
               _loc6_ = "x" + (!!_loc5_?"<font color=\'" + _loc5_ + "\'>" + this._globalSynergy.toFixed(2) + "</font>":this._globalSynergy);
               _loc3_ = this.uiApi.getText("ui.idol.synergyTooltip",_loc6_);
               _loc7_ = this.hasSynergies(true);
               if(_loc7_)
               {
                  _loc3_ = _loc3_ + ("\n\n" + this.uiApi.getText("ui.idol.positiveSynergies",this.getSynergiesText(this._positiveSynergies,true)));
               }
               if(this.hasSynergies(false))
               {
                  _loc3_ = _loc3_ + ((!!_loc7_?"\n":"\n\n") + this.uiApi.getText("ui.idol.negativeSynergies",this.getSynergiesText(this._negativeSynergies,false)));
               }
            }
            else if(param1.name.indexOf("slot_icon_m_gd_presets") != -1)
            {
               _loc10_ = param1.data.idolsIds.length;
               _loc13_ = 0;
               while(_loc13_ < _loc10_)
               {
                  _loc11_ = this.dataApi.getIdol(param1.data.idolsIds[_loc13_]);
                  _loc12_ = this.getIdolCoeff(_loc11_,param1.data.idolsIds);
                  _loc8_ = _loc8_ + _loc11_.experienceBonus * _loc12_;
                  _loc9_ = _loc9_ + _loc11_.dropBonus * _loc12_;
                  _loc13_++;
               }
               _loc3_ = this.uiApi.getText("ui.idol.bonusXp",this.computeExpBonusWithWisdom(_loc8_)) + " %" + "\n" + this.uiApi.getText("ui.idol.bonusLoot",this.computeLootBonusWithProspecting(_loc9_)) + " %" + "\n<i>" + this.uiApi.getText("ui.idol.preset.tip") + "</i>";
            }
            else if(param1.name.indexOf("lbl_idol_score") != -1 && this.btn_showSynergyScore.selected)
            {
               _loc14_ = this.gd_idols.dataProvider[_loc2_].idolId;
               _loc15_ = this._activeIdolsIds.indexOf(_loc14_) != -1;
               _loc16_ = this.getSynergyText(_loc14_,this._tmpPositiveSynergies[_loc14_],null,_loc15_);
               if(_loc16_.length > 0)
               {
                  _loc3_ = this.uiApi.getText("ui.idol.positiveSynergies","<li><b>" + this.gd_idols.dataProvider[_loc2_].name + "</b>" + this.uiApi.getText("ui.common.colon") + _loc16_ + "</li>");
               }
               _loc17_ = this.getSynergyText(_loc14_,this._tmpNegativeSynergies[_loc14_],null,_loc15_);
               if(_loc17_.length > 0)
               {
                  _loc3_ = (!!_loc3_?_loc3_ + "\n":"") + this.uiApi.getText("ui.idol.negativeSynergies","<li><b>" + this.gd_idols.dataProvider[_loc2_].name + "</b>" + this.uiApi.getText("ui.common.colon") + _loc17_ + "</li>");
               }
            }
            if(_loc3_)
            {
               this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc3_),param1,false,"IdolsInfo",LocationEnum.POINT_BOTTOMLEFT,LocationEnum.POINT_TOPRIGHT,3,null,null,null,"TextInfo");
            }
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip("IdolsInfo");
         if(param1.name.indexOf("gd_idols") != -1)
         {
            this._forceLineRollOut = true;
            this.gd_idols.updateItem(this.getIndexFromComponent(param1));
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         if(param1.name.indexOf("slot_idol") != -1)
         {
            this.showItemMenu(param1.data);
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         this.showIdolTooltip(param2.data,param2.container);
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip("IdolsInfo");
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         this.showItemMenu(param2.data);
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      public function onChange(param1:Input) : void
      {
         switch(param1)
         {
            case this.inp_search:
               clearTimeout(this._searchTimeoutId);
               if(this.getSearchText() != "")
               {
                  this._searchTimeoutId = setTimeout(this.onSearch,SEARCH_DELAY);
               }
               else if(this.gd_idols.dataProvider != this._filteredDataProvider)
               {
                  this.gd_idols.dataProvider = this._filteredDataProvider;
               }
         }
      }
      
      public function onDoubleClick(param1:Object) : void
      {
         this.sysApi.sendAction(new IdolsPresetUse(param1.data.id));
      }
      
      private function onSearch() : void
      {
         this.gd_idols.dataProvider = this.utilApi.filter(this._filteredDataProvider,this.getSearchText(),"name");
      }
   }
}

class IdolSelection
{
    
   
   public var idolId:uint;
   
   public var itemId:uint;
   
   public var activate:Boolean;
   
   public var target:Object;
   
   public var selectedIndex:int;
   
   function IdolSelection(param1:uint, param2:uint, param3:Boolean, param4:Object, param5:int)
   {
      super();
      this.idolId = param1;
      this.itemId = param2;
      this.activate = param3;
      this.target = param4;
      this.selectedIndex = param5;
   }
}

class IdolSynergy
{
    
   
   public var idolId:int;
   
   public var synergyCoeff:Number;
   
   function IdolSynergy(param1:uint, param2:Number)
   {
      super();
      this.idolId = param1;
      this.synergyCoeff = param2;
   }
}
