package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.types.graphic.ScrollContainer;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.IncreaseSpellLevel;
   import d2enums.ComponentHookList;
   import d2enums.ShortcutHookListEnum;
   import d2hooks.CharacterLevelUp;
   import d2hooks.CharacterStatsList;
   import d2hooks.SpellListUpdate;
   import d2hooks.SpellModifyFail;
   import d2hooks.SpellModifySuccess;
   import d2hooks.SpellMovementAllowed;
   import d2hooks.SwitchBannerTab;
   import flash.utils.Dictionary;
   
   public class SpellTab
   {
      
      private static var _self:SpellTab;
      
      public static const TOOLTIP_SPELL_TAB:String = "tooltipSpellTab";
      
      private static var _lastSpellIndexSelected:Number;
      
      private static var _lastSpellLevelSelected:Number;
      
      private static var _lastSpellTypeIndexSelected:Number;
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var fightApi:FightApi;
      
      public var utilApi:UtilApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var soundApi:SoundApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private var _selectedSpell:Object;
      
      private var _shownTooltipId:uint;
      
      private var _shownTooltipLevel:uint;
      
      private var _selectedSpellTypeFilter:Object;
      
      private var _spells:Array;
      
      private var _gridSortedByNameDescending:Boolean = true;
      
      private var _gridSortedByLevelDescending:Boolean = true;
      
      private var _btnSpells:Array;
      
      private var _scrollPosition:Number;
      
      private var _boostBtnList:Dictionary;
      
      private var _spellsHash:String;
      
      private var _lifePoints:int;
      
      private var _gridSortByName:Boolean;
      
      private var _gridSortByLevel:Boolean;
      
      private var _spellsInventory:Object;
      
      private var _playerLevel:int;
      
      private var _currentSpellLevelSelected:Number;
      
      public var grid_spell:Grid;
      
      public var cbx_selection_type_spell:ComboBox;
      
      public var toolTipContainer:ScrollContainer;
      
      public var ctr_spell:GraphicContainer;
      
      public var btn_tabName:ButtonContainer;
      
      public var btn_tabLevel:ButtonContainer;
      
      public var btn_tabBoost:ButtonContainer;
      
      public var btn_SpellLevelOne:ButtonContainer;
      
      public var btn_SpellLevelTwo:ButtonContainer;
      
      public var btn_SpellLevelThree:ButtonContainer;
      
      public var btn_SpellLevelFour:ButtonContainer;
      
      public var btn_SpellLevelFive:ButtonContainer;
      
      public var btn_SpellLevelSix:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      public var tx_spell_icon_large:Texture;
      
      public var tx_bgPoints:Texture;
      
      public var lbl_points:Label;
      
      public var lbl_spell_point:Label;
      
      public var lbl_name:Label;
      
      public var lbl_requiredLevel:Label;
      
      public var lbl_requiredLevel_value:Label;
      
      public var btn_finishMoves:ButtonContainer;
      
      private var _allSpellCache:Dictionary;
      
      public function SpellTab()
      {
         this._spells = new Array();
         this._boostBtnList = new Dictionary(true);
         this._allSpellCache = new Dictionary();
         super();
      }
      
      public static function getInstance() : SpellTab
      {
         if(_self == null)
         {
            throw new Error("SpellTab singleton Error");
         }
         return _self;
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         _self = this;
         this.sysApi.addHook(SpellModifySuccess,this.onSpellModifySuccess);
         this.sysApi.addHook(SpellModifyFail,this.onSpellModifyFail);
         this.sysApi.addHook(SpellListUpdate,this.onSpellsList);
         this.sysApi.addHook(CharacterLevelUp,this.onCharacterLevelUp);
         this.sysApi.addHook(CharacterStatsList,this.onCharacterStatsList);
         this.uiApi.addShortcutHook(ShortcutHookListEnum.CLOSE_UI,this.onShortCut);
         this.uiApi.addComponentHook(this.cbx_selection_type_spell,ComponentHookList.ON_SELECT_ITEM);
         this.sysApi.dispatchHook(SwitchBannerTab,"spells");
         if(!this.sysApi.isFightContext() || this.fightApi.getCurrentPlayedFighterId() == this.playerApi.id())
         {
            this.sysApi.dispatchHook(SpellMovementAllowed,true);
         }
         this._btnSpells = new Array(this.btn_SpellLevelOne,this.btn_SpellLevelTwo,this.btn_SpellLevelThree,this.btn_SpellLevelFour,this.btn_SpellLevelFive,this.btn_SpellLevelSix);
         var _loc2_:Array = new Array();
         this._playerLevel = this.playerApi.getPlayedCharacterInfo().level;
         this._spellsInventory = this.playerApi.getSpellInventory();
         for each(_loc4_ in this._spellsInventory)
         {
            _loc2_[_loc4_.id] = _loc4_;
         }
         for each(_loc3_ in _loc2_)
         {
            this._spells.push(_loc3_);
         }
         this._spells.sort(this.sortOnMinPlayerLevel);
         this.cbx_selection_type_spell.dataProvider = this.getComboboxDP();
         _loc5_ = !isNaN(_lastSpellTypeIndexSelected)?int(_lastSpellTypeIndexSelected):0;
         this.cbx_selection_type_spell.selectedIndex = _loc5_;
         this._selectedSpellTypeFilter = this.cbx_selection_type_spell.dataProvider[_loc5_];
         this.lbl_spell_point.text = this.playerApi.characteristics().spellsPoints.toString();
         var _loc6_:Number = this.lbl_points.textWidth + this.lbl_spell_point.textWidth + 2;
         this.lbl_points.x = this.tx_bgPoints.x + this.tx_bgPoints.width / 2 - _loc6_ / 2;
         this.lbl_spell_point.x = this.lbl_points.x + this.lbl_points.textWidth + 2;
         this.updateSpellGrid();
         if(param1 != null)
         {
            this.selectSpell(param1 as uint);
         }
         else
         {
            this.grid_spell.selectedIndex = !isNaN(_lastSpellIndexSelected)?int(_lastSpellIndexSelected):0;
         }
      }
      
      public function updateSpellLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Spell = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:* = undefined;
         var _loc10_:Boolean = false;
         var _loc11_:SpellLevel = null;
         var _loc12_:Boolean = false;
         var _loc13_:* = false;
         var _loc14_:int = 0;
         var _loc15_:Boolean = false;
         var _loc16_:SpellLevel = null;
         param2.slot_icon.dropValidator = this.dropValidatorFunction;
         if(!this._boostBtnList[param2.btn_increase_spell.name])
         {
            this.uiApi.addComponentHook(param2.btn_increase_spell,"onRelease");
            this.uiApi.addComponentHook(param2.btn_increase_spell,"onRollOut");
            this.uiApi.addComponentHook(param2.btn_increase_spell,"onRollOver");
         }
         this._boostBtnList[param2.btn_increase_spell.name] = param1;
         if(param1)
         {
            _loc4_ = this._allSpellCache[param1];
            param2.btn_spell.selected = param3;
            if(!_loc4_)
            {
               _loc4_ = new Object();
               this._allSpellCache[param1] = _loc4_;
               _loc4_.btn_spell_softDisabled = false;
               _loc5_ = param1;
               if(param1.id == 0)
               {
                  _loc7_ = 0;
               }
               else
               {
                  _loc6_ = this.dataApi.getSpell(param1.id);
                  _loc11_ = this.dataApi.getSpellLevelBySpell(_loc6_,1);
                  _loc7_ = _loc11_.minPlayerLevel;
               }
               _loc8_ = 1;
               for each(_loc9_ in this._spellsInventory)
               {
                  if(_loc9_.spellId == param1.id)
                  {
                     _loc8_ = _loc9_.spellLevel;
                  }
               }
               _loc4_.lbl_spellName_text = _loc5_.name;
               if(this.sysApi.getPlayerManager().hasRights)
               {
                  _loc4_.lbl_spellName_text = _loc4_.lbl_spellName_text + (" (" + param1.id + ")");
               }
               _loc10_ = true;
               if(_loc7_ <= this._playerLevel)
               {
                  _loc10_ = false;
               }
               _loc4_.btn_spell_greyedOut = _loc10_;
               if(_loc10_)
               {
                  _loc4_.lbl_spellLevel_text = "-";
                  _loc4_.btn_increase_spell_visible = false;
                  _loc4_.slot_icon_allowDrag = false;
               }
               else
               {
                  _loc4_.slot_icon_allowDrag = true;
                  _loc12_ = true;
                  _loc13_ = _loc8_ > 1;
                  if(param1.id == 0)
                  {
                     _loc4_.lbl_spellLevel_text = "-";
                     _loc12_ = false;
                  }
                  else
                  {
                     _loc4_.lbl_spellLevel_text = _loc8_;
                     if(_loc8_ == 6)
                     {
                        _loc12_ = false;
                     }
                     else
                     {
                        _loc14_ = _loc8_ + 1;
                        _loc15_ = true;
                        while(_loc14_ <= _loc6_.spellLevels.length)
                        {
                           _loc16_ = this.dataApi.getSpellLevelBySpell(_loc6_,_loc14_);
                           if(!_loc16_.hidden)
                           {
                              _loc15_ = false;
                           }
                           _loc14_++;
                        }
                        if(_loc15_)
                        {
                           _loc12_ = false;
                        }
                        if(_loc8_ == 5)
                        {
                           _loc16_ = this.dataApi.getSpellLevelBySpell(_loc6_,_loc8_ + 1);
                           if(_loc16_.minPlayerLevel > this.playerApi.getPlayedCharacterInfo().level)
                           {
                              _loc12_ = false;
                           }
                        }
                     }
                  }
                  if(!_loc12_ && !_loc13_ || this.playerApi.isIncarnation())
                  {
                     _loc4_.btn_increase_spell_visible = false;
                  }
                  else
                  {
                     _loc4_.btn_increase_spell_visible = true;
                     if(_loc8_ <= this.playerApi.characteristics().spellsPoints || _loc13_)
                     {
                        _loc4_.btn_increase_spell_softDisabled = false;
                     }
                     else
                     {
                        _loc4_.btn_increase_spell_softDisabled = true;
                     }
                  }
               }
            }
            param2.btn_spell.softDisabled = _loc4_.btn_spell_softDisabled;
            param2.lbl_spellName.text = _loc4_.lbl_spellName_text;
            param2.btn_spell.greyedOut = _loc4_.btn_spell_greyedOut;
            param2.lbl_spellLevel.text = _loc4_.lbl_spellLevel_text;
            param2.btn_increase_spell.visible = _loc4_.btn_increase_spell_visible;
            param2.slot_icon.allowDrag = _loc4_.slot_icon_allowDrag;
            param2.btn_increase_spell.softDisabled = _loc4_.btn_increase_spell_softDisabled;
            if(!param2.slot_icon.data || param2.slot_icon.data.gfxId != param1.gfxId)
            {
               param2.slot_icon.data = param1;
            }
            param2.slot_icon.selected = false;
         }
         else
         {
            param2.btn_spell.selected = false;
            param2.lbl_spellName.text = "";
            param2.lbl_spellLevel.text = "";
            param2.slot_icon.data = null;
            param2.btn_increase_spell.visible = false;
            param2.btn_spell.softDisabled = true;
            param2.btn_spell.reset();
         }
         if(param2.btn_spell.softDisabled)
         {
            param2.slot_icon.allowDrag = true;
         }
      }
      
      public function selectSpell(param1:uint) : void
      {
         var _loc3_:Object = null;
         var _loc2_:uint = 0;
         for each(_loc3_ in this.grid_spell.dataProvider)
         {
            if(_loc3_.spellId == param1)
            {
               this.grid_spell.selectedIndex = _loc2_;
            }
            _loc2_++;
         }
      }
      
      private function sortOnMinPlayerLevel(param1:Object, param2:Object) : Number
      {
         var _loc3_:Object = this.dataApi.getSpellLevelBySpell(param1.spell,1);
         var _loc4_:Object = this.dataApi.getSpellLevelBySpell(param2.spell,1);
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(param1.id != 0)
         {
            _loc5_ = _loc3_.minPlayerLevel;
         }
         if(param2.id != 0)
         {
            _loc6_ = _loc4_.minPlayerLevel;
         }
         if(_loc5_ > _loc6_)
         {
            return 1;
         }
         if(_loc5_ < _loc6_)
         {
            return -1;
         }
         if(param1.id > param2.id)
         {
            return 1;
         }
         if(param1.id < param2.id)
         {
            return -1;
         }
         return 0;
      }
      
      private function sortOnSpellLevel(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = -1;
         if(this._gridSortedByLevelDescending)
         {
            _loc3_ = 1;
         }
         if(param1.id == 0)
         {
            return -_loc3_;
         }
         if(param2.id == 0)
         {
            return _loc3_;
         }
         if(param1.spellLevel > param2.spellLevel)
         {
            return _loc3_;
         }
         if(param1.spellLevel < param2.spellLevel)
         {
            return -_loc3_;
         }
         if(param1.spellLevel == param2.spellLevel)
         {
            if(param1.id > param2.id)
            {
               return _loc3_;
            }
            if(param1.id < param2.id)
            {
               return -_loc3_;
            }
         }
         return 0;
      }
      
      private function sortOnSpellName(param1:Object, param2:Object) : int
      {
         var _loc3_:String = this.utilApi.noAccent(param1.name);
         var _loc4_:String = this.utilApi.noAccent(param2.name);
         if(this._gridSortedByNameDescending)
         {
            if(_loc3_ > _loc4_)
            {
               return -1;
            }
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         return 1;
      }
      
      private function getComboboxDP() : Array
      {
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Object = null;
         var _loc1_:Array = new Array();
         _loc1_.push({
            "label":this.uiApi.getText("ui.common.allTypes"),
            "value":uint.MAX_VALUE
         });
         for each(_loc2_ in this._spells)
         {
            _loc3_ = false;
            _loc4_ = _loc2_.typeId;
            _loc5_ = 0;
            for each(_loc6_ in _loc1_)
            {
               if(_loc1_[_loc5_].value == _loc4_)
               {
                  _loc3_ = true;
               }
               _loc5_++;
            }
            if(!_loc3_)
            {
               _loc1_.push({
                  "label":this.dataApi.getSpellType(_loc4_).longName,
                  "value":_loc4_
               });
            }
         }
         return _loc1_;
      }
      
      private function updateSpellDisplay() : void
      {
         var _loc1_:int = this._selectedSpell.spellLevel;
         if(_loc1_ <= 0)
         {
            _loc1_ = 1;
         }
         if(!isNaN(_lastSpellLevelSelected))
         {
            _loc1_ = _lastSpellLevelSelected;
            _lastSpellLevelSelected = NaN;
         }
         this._currentSpellLevelSelected = _loc1_;
         this._btnSpells[_loc1_ - 1].selected = true;
         var _loc2_:Object = this.dataApi.getSpellWrapper(this._selectedSpell.id,_loc1_);
         this.lbl_name.text = this._selectedSpell.name;
         var _loc3_:Object = this.dataApi.getSpellLevelBySpell(this._selectedSpell.spell,_loc1_);
         if(!this._selectedSpell.id)
         {
            this.showSpellLevelButtons(1);
            this.lbl_requiredLevel_value.text = "1";
         }
         else
         {
            this.showSpellLevelButtons(this._selectedSpell.spell.spellLevels.length);
            this.lbl_requiredLevel_value.text = _loc3_.minPlayerLevel;
         }
         this.alignLevelLabels();
         this.tx_spell_icon_large.uri = this._selectedSpell.fullSizeIconUri;
         if(!this.tx_spell_icon_large.finalized)
         {
            this.tx_spell_icon_large.finalize();
         }
         this.showSpellTooltip(_loc2_);
      }
      
      private function manageSpellLevelClickButton(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         if(param1 && param1.id && this._selectedSpell && this._selectedSpell.spell && param2 <= this._selectedSpell.spell.spellLevels.length)
         {
            _loc4_ = this.dataApi.getSpellLevelBySpell(this._selectedSpell.spell,param2);
            _loc5_ = this.dataApi.getSpellWrapper(param1.id,param2);
            this.lbl_requiredLevel_value.text = _loc4_.minPlayerLevel;
            this.alignLevelLabels();
            if(_loc5_ != null && param3)
            {
               this.showSpellTooltip(_loc5_);
            }
            this._currentSpellLevelSelected = param2;
         }
      }
      
      private function getRealSpellLevel(param1:uint) : uint
      {
         var _loc3_:* = undefined;
         var _loc2_:uint = 0;
         for each(_loc3_ in this._spellsInventory)
         {
            if(_loc3_.spellId == param1)
            {
               _loc2_ = _loc3_.spellLevel;
            }
         }
         return _loc2_;
      }
      
      private function showSpellLevelButtons(param1:uint) : void
      {
         var _loc4_:Object = null;
         var _loc2_:uint = this._btnSpells.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc3_ >= param1)
            {
               this._btnSpells[_loc3_].visible = false;
            }
            else
            {
               _loc4_ = this.dataApi.getSpellLevelBySpell(this._selectedSpell.spell,_loc3_ + 1);
               this._btnSpells[_loc3_].visible = !_loc4_.hidden;
            }
            _loc3_++;
         }
      }
      
      private function filterSpellByType() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc1_:Array = new Array();
         var _loc2_:Boolean = false;
         for each(_loc3_ in this._spells)
         {
            if(_loc3_.id == 0)
            {
               _loc2_ = true;
            }
         }
         if(!_loc2_)
         {
            this._spells.push(this.dataApi.getSpellWrapper(0,1));
         }
         if(this._selectedSpellTypeFilter.value == uint.MAX_VALUE)
         {
            this.grid_spell.dataProvider = this._spells;
            return;
         }
         for each(_loc4_ in this._spells)
         {
            if(_loc4_.typeId == this._selectedSpellTypeFilter.value)
            {
               _loc1_.push(_loc4_);
            }
         }
         this.grid_spell.dataProvider = _loc1_.sort(this.sortOnMinPlayerLevel);
      }
      
      private function showSpellTooltip(param1:Object) : void
      {
         if(this._shownTooltipId == param1.spellId && this._shownTooltipLevel == param1.spellLevel)
         {
            return;
         }
         this._shownTooltipId = param1.spellId;
         this._shownTooltipLevel = param1.spellLevel;
         this.uiApi.showTooltip(param1,null,false,TOOLTIP_SPELL_TAB,0,2,3,null,null,{
            "smallSpell":false,
            "description":true,
            "effects":true,
            "contextual":true,
            "noBg":true,
            "currentCC_EC":false,
            "baseCC_EC":true,
            "spellTab":true,
            "name":false,
            "width":410
         },null,true);
      }
      
      private function updateSpellGrid() : void
      {
         var _loc3_:Object = null;
         this._allSpellCache = new Dictionary();
         var _loc1_:Array = new Array();
         var _loc2_:String = "";
         for each(_loc3_ in this._spells)
         {
            if(_loc3_ && _loc3_.spell && _loc3_.spell.typeId == this._selectedSpellTypeFilter.value || this._selectedSpellTypeFilter.value == uint.MAX_VALUE)
            {
               _loc1_.push(_loc3_);
               _loc2_ = _loc2_ + (_loc3_.spellLevelInfos.id + "-");
            }
         }
         if(this._gridSortByName)
         {
            _loc1_.sort(this.sortOnSpellName);
            _loc2_ = _loc2_ + ("-sortByName" + this._gridSortedByNameDescending);
         }
         else if(this._gridSortByLevel)
         {
            _loc1_.sort(this.sortOnSpellLevel);
            _loc2_ = _loc2_ + ("-sortByLevel" + this._gridSortedByLevelDescending);
         }
         if(this._spellsHash != _loc2_)
         {
            this.grid_spell.dataProvider = _loc1_;
            if(this._scrollPosition != -1)
            {
               this.grid_spell.moveTo(this._scrollPosition,true);
               this._scrollPosition = -1;
            }
            this._spellsHash = _loc2_;
         }
      }
      
      private function boostToLevel(param1:int, param2:int) : void
      {
         this.sysApi.sendAction(new IncreaseSpellLevel(this._selectedSpell.id,param2));
      }
      
      private function alignLevelLabels() : void
      {
         this.lbl_requiredLevel.fullWidth();
         this.lbl_requiredLevel_value.fullWidth();
         var _loc1_:Number = this.lbl_requiredLevel.width + this.lbl_requiredLevel_value.width;
         this.lbl_requiredLevel.x = this.ctr_spell.width / 2 - _loc1_ / 2 - 10;
         this.lbl_requiredLevel_value.x = this.lbl_requiredLevel.x + this.lbl_requiredLevel.width;
         this.lbl_requiredLevel_value.visible = this.lbl_requiredLevel.visible = true;
      }
      
      private function onShortCut(param1:String) : Boolean
      {
         if(param1 == ShortcutHookListEnum.CLOSE_UI)
         {
            this.uiApi.unloadUi(this.uiApi.me().name);
            return true;
         }
         return false;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:String = null;
         var _loc7_:SpellWrapper = null;
         var _loc8_:Spell = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_finishMoves:
               if(!this.uiApi.getUi("finishMoveList"))
               {
                  this.uiApi.loadUi("finishMoveList");
               }
               break;
            case this.btn_SpellLevelOne:
               this.manageSpellLevelClickButton(this._selectedSpell,1,true);
               break;
            case this.btn_SpellLevelTwo:
               this.manageSpellLevelClickButton(this._selectedSpell,2,true);
               break;
            case this.btn_SpellLevelThree:
               this.manageSpellLevelClickButton(this._selectedSpell,3,true);
               break;
            case this.btn_SpellLevelFour:
               this.manageSpellLevelClickButton(this._selectedSpell,4,true);
               break;
            case this.btn_SpellLevelFive:
               this.manageSpellLevelClickButton(this._selectedSpell,5,true);
               break;
            case this.btn_SpellLevelSix:
               this.manageSpellLevelClickButton(this._selectedSpell,6,true);
               break;
            case this.btn_tabName:
               this._gridSortByName = true;
               this._gridSortByLevel = false;
               if(!this._gridSortedByNameDescending)
               {
                  this._gridSortedByNameDescending = true;
               }
               else
               {
                  this._gridSortedByNameDescending = false;
               }
               this.updateSpellGrid();
               break;
            case this.btn_tabLevel:
            case this.btn_tabBoost:
               this._gridSortByName = false;
               this._gridSortByLevel = true;
               this._gridSortedByLevelDescending = !this._gridSortedByLevelDescending;
               this.updateSpellGrid();
               break;
            default:
               if(param1.name.indexOf("btn_increase") != -1)
               {
                  _loc2_ = new Array();
                  _loc3_ = [1,2,3,4,5,6];
                  _loc7_ = this._boostBtnList[param1.name];
                  _loc8_ = this.dataApi.getSpell(_loc7_.id);
                  _loc9_ = this.getRealSpellLevel(_loc7_.id);
                  _loc10_ = this.playerApi.characteristics().spellsPoints;
                  _loc11_ = this.playerApi.getPlayedCharacterInfo().level;
                  _loc2_.push(this.modContextMenu.createContextMenuTitleObject(this.uiApi.getText("ui.grimoire.spellLevel.increase")));
                  for each(_loc14_ in _loc3_)
                  {
                     _loc4_ = false;
                     _loc5_ = false;
                     _loc6_ = this.uiApi.getText("ui.common.level") + " " + _loc14_;
                     if(_loc14_ == _loc9_)
                     {
                        _loc4_ = true;
                        _loc5_ = true;
                     }
                     _loc13_ = this.dataApi.getSpellLevelBySpell(_loc8_,_loc14_).minPlayerLevel;
                     _loc12_ = _loc14_ * (_loc14_ - 1) / 2 - _loc9_ * (_loc9_ - 1) / 2;
                     if(_loc13_ > _loc11_)
                     {
                        _loc6_ = _loc6_ + ("       " + this.uiApi.getText("ui.spell.requiredLevelShort",_loc13_));
                        _loc4_ = true;
                     }
                     else if(_loc12_ > _loc10_)
                     {
                        _loc6_ = _loc6_ + ("       " + this.uiApi.processText(this.uiApi.getText("ui.spell.requiredPoints",_loc12_),"m",_loc12_ == 1));
                        _loc4_ = true;
                     }
                     if(!_loc4_)
                     {
                        if(_loc12_ > 0)
                        {
                           _loc6_ = _loc6_ + ("       " + _loc12_ + " " + this.uiApi.processText(this.uiApi.getText("ui.common.point"),"m",_loc12_ == 1));
                        }
                        else
                        {
                           _loc6_ = _loc6_ + ("       " + this.uiApi.processText(this.uiApi.getText("ui.spell.returnedPoints",_loc12_ * -1),"m",_loc12_ == 1));
                        }
                     }
                     _loc2_.push(this.modContextMenu.createContextMenuItemObject(_loc6_,this.boostToLevel,[_loc7_.id,_loc14_],_loc4_,null,_loc5_,false,null,true));
                  }
                  this.modContextMenu.createContextMenu(_loc2_);
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         if(param1.name.indexOf("btn_increase") != -1)
         {
            _loc2_ = 7;
            _loc3_ = 1;
            _loc4_ = this.uiApi.getText("ui.grimoire.spellLevel.increase");
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc4_),param1,false,"standard",_loc2_,_loc3_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         switch(param1)
         {
            case this.grid_spell:
               this._selectedSpell = this.grid_spell.dataProvider[param1.selectedIndex];
               if(this._selectedSpell == null)
               {
                  break;
               }
               this.updateSpellDisplay();
               break;
            case this.cbx_selection_type_spell:
               this._selectedSpellTypeFilter = this.cbx_selection_type_spell.dataProvider[param1.selectedIndex];
               switch(param2)
               {
                  case 0:
                  case 3:
                  case 4:
                  case 8:
                     this.updateSpellGrid();
               }
         }
      }
      
      public function unload() : void
      {
         this.uiApi.hideTooltip(TOOLTIP_SPELL_TAB);
         this.sysApi.dispatchHook(SpellMovementAllowed,false);
         _lastSpellIndexSelected = this.grid_spell.selectedIndex;
         _lastSpellTypeIndexSelected = this.cbx_selection_type_spell.selectedIndex;
         _lastSpellLevelSelected = this._currentSpellLevelSelected;
      }
      
      private function onCharacterStatsList(param1:Boolean = false) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         if(!param1)
         {
            this.lbl_spell_point.text = this.playerApi.characteristics().spellsPoints.toString();
            for(_loc2_ in this._allSpellCache)
            {
               _loc3_ = this._allSpellCache[_loc2_];
               if(_loc3_.btn_increase_spell_visible)
               {
                  _loc4_ = this.getRealSpellLevel(_loc2_.id);
                  _loc3_.btn_increase_spell_softDisabled = !(_loc4_ <= this.playerApi.characteristics().spellsPoints || _loc4_ > 1);
               }
            }
            this.grid_spell.dataProvider = this._spells;
         }
      }
      
      private function onCharacterLevelUp(param1:uint, param2:uint, param3:uint, param4:uint, param5:Object, param6:Boolean, param7:int) : void
      {
         this.lbl_spell_point.text = this.playerApi.characteristics().spellsPoints.toString();
         this.updateSpellGrid();
      }
      
      private function onSpellModifySuccess(param1:Object) : void
      {
         var _loc3_:Object = null;
         delete this._allSpellCache[param1];
         var _loc2_:uint = 0;
         for each(_loc3_ in this._spells)
         {
            if(_loc3_.id == param1.id)
            {
               this._spells.splice(_loc2_,1,param1);
               break;
            }
            _loc2_++;
         }
         this.cbx_selection_type_spell.dataProvider = this.getComboboxDP();
         this.manageSpellLevelClickButton(param1,param1.spellLevel,true);
         this._btnSpells[param1.spellLevel - 1].selected = true;
         this.grid_spell.updateItem(_loc2_);
      }
      
      private function onSpellModifyFail() : void
      {
         this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.grimoire.popup.upgradeSpellFailMessage"),[this.uiApi.getText("ui.common.ok")],null,null);
      }
      
      public function onSpellsList(param1:Object) : void
      {
         this._spellsInventory = this.playerApi.getSpellInventory();
      }
      
      public function dropValidatorFunction(param1:Object, param2:Object, param3:Object) : Boolean
      {
         return false;
      }
      
      public function removeDropSourceFunction(param1:Object) : void
      {
      }
      
      public function processDropFunction(param1:Object, param2:Object, param3:Object) : void
      {
         param1.data = param2;
      }
   }
}
