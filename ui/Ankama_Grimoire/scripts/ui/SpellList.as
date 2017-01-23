package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.FightApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.tooltip.LocationEnum;
   import d2actions.SpellVariantActivationRequest;
   import d2enums.ComponentHookList;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.CharacterLevelUp;
   import d2hooks.CharacterStatsList;
   import d2hooks.SpellListUpdate;
   import d2hooks.SpellMovementAllowed;
   import d2hooks.SpellVariantActivated;
   import d2hooks.SwitchBannerTab;
   import flash.utils.Dictionary;
   
   public class SpellList
   {
      
      private static var _self:SpellList;
      
      public static const TOOLTIP_SPELL_TAB:String = "tooltipSpellTab";
      
      private static var _lastSpellIndexSelected:Number;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var fightApi:FightApi;
      
      public var utilApi:UtilApi;
      
      public var soundApi:SoundApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      private var _breedSpellsListMode:Boolean = true;
      
      private var _spells:Array;
      
      private var _scrollPosition:Number;
      
      private var _componentsList:Dictionary;
      
      private var _spellsHash:String;
      
      private var _spellsInventory:Object;
      
      private var _playerLevel:int;
      
      private var _allSpellCache:Dictionary;
      
      public var gd_spell:Grid;
      
      public var tx_help:Texture;
      
      public function SpellList()
      {
         this._spells = new Array();
         this._componentsList = new Dictionary(true);
         this._allSpellCache = new Dictionary();
         super();
      }
      
      public static function getInstance() : SpellList
      {
         if(_self == null)
         {
            throw new Error("SpellList singleton Error");
         }
         return _self;
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:SpellWrapper = null;
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Vector.<int> = null;
         var _loc11_:Object = null;
         var _loc12_:Vector.<int> = null;
         var _loc13_:Array = null;
         var _loc14_:SpellWrapper = null;
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         _self = this;
         this.sysApi.addHook(SpellListUpdate,this.onSpellsList);
         this.sysApi.addHook(CharacterLevelUp,this.onCharacterLevelUp);
         this.sysApi.addHook(CharacterStatsList,this.onCharacterStatsList);
         this.sysApi.addHook(SpellVariantActivated,this.onSpellVariantActivated);
         this.uiApi.addComponentHook(this.tx_help,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_help,ComponentHookList.ON_ROLL_OUT);
         if(param1 != null)
         {
            this._breedSpellsListMode = param1.variantsList;
         }
         this.sysApi.dispatchHook(SwitchBannerTab,"spells");
         if(!this.sysApi.isFightContext() || this.fightApi.getCurrentPlayedFighterId() == this.playerApi.id())
         {
            this.sysApi.dispatchHook(SpellMovementAllowed,true);
         }
         this._playerLevel = this.playerApi.getPlayedCharacterInfo().level;
         this._spellsInventory = this.playerApi.getSpellInventory();
         var _loc3_:Array = new Array();
         var _loc4_:Dictionary = new Dictionary(true);
         var _loc5_:Array = new Array();
         var _loc7_:Boolean = false;
         var _loc10_:int = this.playerApi.getPlayedCharacterInfo().breed;
         for each(_loc2_ in this._spellsInventory)
         {
            if(this._breedSpellsListMode && _loc2_.spell.typeId == _loc10_)
            {
               _loc7_ = true;
            }
            else if(!this._breedSpellsListMode && _loc2_.spell.typeId != _loc10_)
            {
               _loc7_ = true;
            }
            else
            {
               _loc7_ = false;
            }
            if(_loc7_)
            {
               _loc4_[_loc2_.id] = _loc2_;
               if(_loc2_.variantActivated)
               {
                  this.sysApi.log(4," - " + _loc2_.spell.name + " : obtentionLevel " + _loc2_.spell.obtentionLevel + "     ACTIF");
               }
               if(_loc2_.spell.variants && _loc2_.spell.variants.length)
               {
                  _loc6_ = _loc2_.spell.variants[0];
                  if(_loc5_.indexOf(_loc6_) == -1)
                  {
                     _loc5_.push(_loc6_);
                     _loc3_.push(_loc2_.spell.variants);
                  }
               }
               else
               {
                  _loc12_ = new Vector.<int>();
                  _loc12_.push(_loc2_.id);
                  _loc3_.push(_loc12_);
               }
            }
         }
         for each(_loc9_ in _loc3_)
         {
            _loc13_ = new Array();
            for each(_loc8_ in _loc9_)
            {
               _loc13_.push(_loc4_[_loc8_]);
            }
            this._spells.push(_loc13_);
         }
         this._spells.sort(this.sortOnObtentionLevel);
         for each(_loc11_ in this._spells)
         {
            for each(_loc14_ in _loc11_)
            {
               if(_loc14_.variantActivated)
               {
                  this.sysApi.log(4," - " + _loc14_.spell.name + " : obtentionLevel " + _loc14_.spell.obtentionLevel + "     ACTIF");
               }
            }
         }
         this.updateSpellGrid();
      }
      
      public function updateSpellLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.gd_spellButtons.dataProvider = param1;
            param2.gd_spellButtons.width = param1.length * param2.gd_spellButtons.slotWidth + (param1.length - 1) * 30;
            param2.gd_spellButtons.x = (this.gd_spell.slotWidth - param2.gd_spellButtons.width) / 2 - 3;
            param2.gd_spellButtons.finalize;
         }
         else
         {
            param2.gd_spellButtons.dataProvider = null;
         }
      }
      
      public function updateSpellButtonsLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:Boolean = false;
         param2.slot_icon.dropValidator = this.dropValidatorFunction;
         if(!this._componentsList[param2.btn_spell.name])
         {
            this.uiApi.addComponentHook(param2.btn_spell,ComponentHookList.ON_RELEASE);
            this.uiApi.addComponentHook(param2.btn_spell,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.btn_spell,ComponentHookList.ON_ROLL_OUT);
         }
         this._componentsList[param2.btn_spell.name] = param1;
         if(!this._componentsList[param2.ctr_prestige.name])
         {
            this.uiApi.addComponentHook(param2.ctr_prestige,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.ctr_prestige,ComponentHookList.ON_ROLL_OUT);
         }
         if(!this._componentsList[param2.ctr_level.name])
         {
            this.uiApi.addComponentHook(param2.ctr_level,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(param2.ctr_level,ComponentHookList.ON_ROLL_OUT);
         }
         if(param1)
         {
            _loc4_ = this._allSpellCache[param1];
            _loc5_ = 0;
            if(!_loc4_)
            {
               _loc4_ = new Object();
               this._allSpellCache[param1] = _loc4_;
               _loc4_.btn_spell_softDisabled = false;
               _loc4_.lbl_spellName_text = param1.name;
               if(this.sysApi.getPlayerManager().hasRights)
               {
                  _loc4_.lbl_spellName_text = _loc4_.lbl_spellName_text + (" (" + param1.id + ")");
               }
               if(param1.id == 0)
               {
                  _loc5_ = 0;
               }
               else
               {
                  _loc5_ = param1.obtentionLevel;
               }
               _loc6_ = true;
               if(_loc5_ <= this._playerLevel)
               {
                  _loc6_ = false;
               }
               _loc4_.btn_spell_greyedOut = _loc6_;
               if(_loc6_)
               {
                  _loc4_.slot_icon_allowDrag = false;
                  if(_loc5_ > ProtocolConstantsEnum.MAX_LEVEL)
                  {
                     _loc4_.ctr_prestige_visible = true;
                     _loc4_.ctr_level_visible = false;
                     _loc4_.lbl_obtentionPrestige_text = _loc5_ - ProtocolConstantsEnum.MAX_LEVEL;
                  }
                  else
                  {
                     _loc4_.ctr_prestige_visible = false;
                     _loc4_.ctr_level_visible = true;
                     _loc4_.lbl_obtentionLevel_text = _loc5_;
                  }
               }
               else
               {
                  if(param3)
                  {
                     _loc4_.slot_icon_allowDrag = true;
                  }
                  else
                  {
                     _loc4_.slot_icon_allowDrag = false;
                  }
                  _loc4_.ctr_prestige_visible = false;
                  _loc4_.ctr_level_visible = false;
               }
            }
            this._componentsList[param2.ctr_prestige.name] = _loc4_.lbl_obtentionPrestige_text;
            this._componentsList[param2.ctr_level.name] = _loc4_.lbl_obtentionLevel_text;
            param2.btn_spell.softDisabled = _loc4_.btn_spell_softDisabled;
            param2.lbl_spellName.text = _loc4_.lbl_spellName_text;
            param2.btn_spell.greyedOut = _loc4_.btn_spell_greyedOut;
            param2.slot_icon.allowDrag = _loc4_.slot_icon_allowDrag;
            param2.ctr_prestige.visible = _loc4_.ctr_prestige_visible;
            param2.ctr_level.visible = _loc4_.ctr_level_visible;
            param2.lbl_obtentionPrestige.text = _loc4_.lbl_obtentionPrestige_text;
            param2.lbl_obtentionLevel.text = _loc4_.lbl_obtentionLevel_text;
            param2.btn_spell.selected = param1.variantActivated;
            if(!param2.slot_icon.data || param2.slot_icon.data.gfxId != param1.gfxId)
            {
               param2.slot_icon.data = param1;
            }
            param2.slot_icon.selected = false;
         }
         else
         {
            this._componentsList[param2.ctr_prestige.name] = 0;
            this._componentsList[param2.ctr_level.name] = 0;
            param2.btn_spell.selected = false;
            param2.lbl_spellName.text = "";
            param2.ctr_prestige.visible = false;
            param2.ctr_level.visible = false;
            param2.lbl_obtentionPrestige.text = "";
            param2.lbl_obtentionLevel.text = "";
            param2.slot_icon.data = null;
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
         for each(_loc3_ in this.gd_spell.dataProvider)
         {
            if(_loc3_.spellId == param1)
            {
               this.gd_spell.selectedIndex = _loc2_;
            }
            _loc2_++;
         }
      }
      
      private function sortOnObtentionLevel(param1:Object, param2:Object) : Number
      {
         var _loc3_:int = param1[0].spell.obtentionLevel;
         var _loc4_:int = param2[0].spell.obtentionLevel;
         var _loc5_:int = 0;
         if(param1.length > 1)
         {
            _loc5_ = param1[1].spell.obtentionLevel;
         }
         var _loc6_:int = 0;
         if(param2.length > 1)
         {
            _loc6_ = param2[1].spell.obtentionLevel;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc5_ > _loc6_)
         {
            return 1;
         }
         if(_loc5_ < _loc6_)
         {
            return -1;
         }
         if(param1[0].id > param2[0].id)
         {
            return 1;
         }
         if(param1[0].id < param2[0].id)
         {
            return -1;
         }
         return 0;
      }
      
      private function updateSpellGrid() : void
      {
         var _loc3_:SpellWrapper = null;
         var _loc4_:Array = null;
         this._allSpellCache = new Dictionary();
         var _loc1_:Array = new Array();
         var _loc2_:String = "";
         for each(_loc4_ in this._spells)
         {
            _loc1_.push(_loc4_);
            for each(_loc3_ in _loc4_)
            {
               if(_loc3_ && _loc3_.spell)
               {
                  _loc2_ = _loc2_ + (_loc3_.spellLevelInfos.id + "-");
               }
            }
         }
         if(this._spellsHash != _loc2_)
         {
            this.gd_spell.dataProvider = _loc1_;
            if(this._scrollPosition != -1)
            {
               this.gd_spell.moveTo(this._scrollPosition,true);
               this._scrollPosition = -1;
            }
            this._spellsHash = _loc2_;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:SpellWrapper = null;
         var _loc3_:Boolean = false;
         var _loc4_:* = undefined;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         var _loc7_:* = undefined;
         if(param1.name.indexOf("btn_spell") != -1)
         {
            _loc2_ = this._componentsList[param1.name];
            if(_loc2_ == null)
            {
               return;
            }
            _loc3_ = false;
            for each(_loc4_ in this.gd_spell.dataProvider)
            {
               if(!(!_loc4_ || _loc4_.length <= 1))
               {
                  _loc5_ = 0;
                  _loc6_ = false;
                  for each(_loc7_ in _loc4_)
                  {
                     if(_loc7_.id == _loc2_.id)
                     {
                        _loc6_ = true;
                     }
                     if(_loc7_.obtentionLevel <= this._playerLevel)
                     {
                        _loc5_++;
                     }
                  }
                  if(_loc6_)
                  {
                     if(_loc5_ > 1)
                     {
                        _loc3_ = true;
                     }
                     break;
                  }
               }
            }
            if(_loc3_)
            {
               this.sysApi.log(2,"select sort " + _loc2_.spell.name);
               this.sysApi.sendAction(new SpellVariantActivationRequest(_loc2_.id));
            }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc5_:Object = null;
         var _loc6_:SpellWrapper = null;
         var _loc2_:uint = 7;
         var _loc3_:uint = 1;
         var _loc4_:String = "";
         if(param1 == this.tx_help)
         {
            if(this._breedSpellsListMode)
            {
               _loc4_ = this.uiApi.getText("ui.spell.breedSpells.help");
            }
            else
            {
               _loc4_ = this.uiApi.getText("ui.spell.sharedSpells.help");
            }
         }
         else if(param1.name.indexOf("ctr_level") != -1)
         {
            _loc5_ = this._componentsList[param1.name];
            _loc4_ = this.uiApi.getText("ui.spell.requiredLevel") + " " + _loc5_.toString();
         }
         else if(param1.name.indexOf("ctr_prestige") != -1)
         {
            _loc5_ = this._componentsList[param1.name];
            _loc4_ = this.uiApi.getText("ui.spell.requiredPrestige") + " " + _loc5_.toString();
         }
         else if(param1.name.indexOf("btn_spell") != -1)
         {
            _loc6_ = this._componentsList[param1.name];
            if(_loc6_ == null)
            {
               return;
            }
            this.uiApi.showTooltip(_loc6_,param1,false,"standard",LocationEnum.POINT_TOPLEFT,LocationEnum.POINT_TOPRIGHT,3,null,null,{"footer":false});
            return;
         }
         if(_loc4_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc4_),param1,false,"standard",_loc2_,_loc3_,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function unload() : void
      {
         this.uiApi.hideTooltip(TOOLTIP_SPELL_TAB);
         this.sysApi.dispatchHook(SpellMovementAllowed,false);
         _lastSpellIndexSelected = this.gd_spell.selectedIndex;
      }
      
      private function onCharacterStatsList(param1:Boolean = false) : void
      {
         if(!param1)
         {
            this.gd_spell.dataProvider = this._spells;
         }
      }
      
      private function onSpellVariantActivated(param1:uint, param2:uint) : void
      {
         this.sysApi.log(2,"Activation de " + param1 + "    (précédent " + param2 + ")");
         var _loc3_:int = 0;
         var _loc4_:int = this.gd_spell.dataProvider.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            if(this.gd_spell.dataProvider[_loc5_] && (this.gd_spell.dataProvider[_loc5_][0].id == param1 || this.gd_spell.dataProvider[_loc5_][0].id == param2))
            {
               this.gd_spell.updateItem(_loc5_);
               return;
            }
            _loc5_++;
         }
      }
      
      private function onCharacterLevelUp(param1:uint, param2:uint, param3:uint, param4:uint, param5:Object, param6:Boolean, param7:int) : void
      {
         this.updateSpellGrid();
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
