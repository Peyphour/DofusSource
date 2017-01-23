package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.uiApi.ConfigApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.RoleplayApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.StatsUpgradeRequest;
   import d2enums.BoostableCharacteristicEnum;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.CharacterStatsList;
   import flash.utils.Dictionary;
   
   public class StatBoost
   {
       
      
      public var output:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var rpApi:RoleplayApi;
      
      public var utilApi:UtilApi;
      
      public var configApi:ConfigApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _characterCharacteristics;
      
      private var _statId:uint;
      
      private var _stat:String;
      
      private var _statName:String;
      
      private var _statPointsName:String;
      
      private var _statPointsAdded:uint = 0;
      
      private var _pointsUsed:uint = 0;
      
      private var _capital:uint;
      
      private var _base:uint;
      
      private var _baseFloor:uint;
      
      private var _currentFloor:uint;
      
      private var _rest:uint;
      
      private var _maxScrollPointsBeforeLimit:uint;
      
      private var _statFloorValueAndCostInBoostForOneStatPoint:Array;
      
      private var _hasAdditionalPoints:Boolean = true;
      
      private var _statVariableAssoc:Dictionary;
      
      private var _numStatVariables:uint;
      
      private var _statSpells:Array;
      
      private var _characterSheetUi;
      
      private var _characterSheetUiX:Number = 0;
      
      private var _characterSheetUiY:Number = 0;
      
      public var mainCtr:GraphicContainer;
      
      public var ctr_window:GraphicContainer;
      
      public var ctr_content:GraphicContainer;
      
      public var ctr_block:GraphicContainer;
      
      public var tx_scratch_block:TextureBitmap;
      
      public var tx_scratch_block_name:String;
      
      public var lbl_title:Label;
      
      public var btn_close:ButtonContainer;
      
      public var lbl_capitalStat:Label;
      
      public var lbl_capitalScroll:Label;
      
      public var lbl_statName:Label;
      
      public var lbl_statBase:Label;
      
      public var lbl_statBaseAdd:Label;
      
      public var lbl_statBonus:Label;
      
      public var lbl_statTotal:Label;
      
      public var lbl_currentFloor:Label;
      
      public var tx_floor_info:Texture;
      
      public var lbl_statIncreases:Label;
      
      public var lbl_statIncreases2:Label;
      
      public var lbl_statIncreases3:Label;
      
      public var lbl_statIncreases4:Label;
      
      public var lbl_statIncreases_two:Label;
      
      public var lbl_statIncreases2_two:Label;
      
      public var lbl_statIncreases3_two:Label;
      
      public var lbl_statIncreases4_two:Label;
      
      public var lbl_statIncreases_2:Label;
      
      public var lbl_statIncreases2_2:Label;
      
      public var lbl_statIncreases3_2:Label;
      
      public var lbl_statIncreases4_2:Label;
      
      public var lbl_statIncreases_2_two:Label;
      
      public var lbl_statIncreases2_2_two:Label;
      
      public var lbl_statIncreases3_2_two:Label;
      
      public var lbl_statIncreases4_2_two:Label;
      
      public var lbl_statSpells:Label;
      
      public var lbl_statSpells_2:Label;
      
      public var inp_pointsValue:Input;
      
      public var btn_valid:ButtonContainer;
      
      public var btn_less:ButtonContainer;
      
      public var btn_more:ButtonContainer;
      
      public var btn_radioStat:ButtonContainer;
      
      public var btn_radioScroll:ButtonContainer;
      
      public var ctr_radioStat:GraphicContainer;
      
      public var ctr_radioScroll:GraphicContainer;
      
      public var lbl_availablePoints:Label;
      
      public var ctr_capitalChoice:GraphicContainer;
      
      public var gd_statSpells:Grid;
      
      public var gd_statSpells_2:Grid;
      
      public var gd_statVariables:Grid;
      
      public var gd_statVariables2:Grid;
      
      public var gd_statVariables3:Grid;
      
      public var gd_statVariables4:Grid;
      
      public var gd_statVariables_two:Grid;
      
      public var gd_statVariables2_two:Grid;
      
      public var gd_statVariables3_two:Grid;
      
      public var gd_statVariables4_two:Grid;
      
      public var gd_statVariables_2:Grid;
      
      public var gd_statVariables2_2:Grid;
      
      public var gd_statVariables3_2:Grid;
      
      public var gd_statVariables4_2:Grid;
      
      public var gd_statVariables_2_two:Grid;
      
      public var gd_statVariables2_2_two:Grid;
      
      public var gd_statVariables3_2_two:Grid;
      
      public var gd_statVariables4_2_two:Grid;
      
      public function StatBoost()
      {
         super();
      }
      
      public function main(param1:Array) : void
      {
         var _loc4_:* = null;
         var _loc5_:Vector.<StatVariable> = null;
         var _loc7_:SpellWrapper = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:* = false;
         var _loc12_:Boolean = false;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:String = null;
         var _loc17_:GraphicContainer = null;
         var _loc18_:int = 0;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:int = 0;
         var _loc2_:* = this.uiApi.me();
         var _loc3_:Object = _loc2_.getElements();
         for(_loc4_ in _loc3_)
         {
            _loc17_ = _loc3_[_loc4_];
            if(_loc17_.themeDataId == "block_border_scratch")
            {
               this.tx_scratch_block = _loc17_ as TextureBitmap;
               this.tx_scratch_block_name = _loc4_;
               break;
            }
         }
         this.uiApi.addComponentHook(this.inp_pointsValue,ComponentHookList.ON_CHANGE);
         this.uiApi.addComponentHook(this.ctr_radioStat,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ctr_radioScroll,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ctr_radioScroll,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.ctr_radioScroll,ComponentHookList.ON_ROLL_OUT);
         this.sysApi.addHook(CharacterStatsList,this.onCharacterStatsList);
         this.sysApi.addEventListener(this.onEnterFrame,"StatBoost");
         this._characterSheetUi = this.uiApi.getUi("characterSheetUi");
         this._stat = param1[0];
         this._statId = param1[1];
         this._statName = this.uiApi.getText("ui.stats." + this._stat);
         this._statPointsName = "ui.stats." + this._stat + "Points";
         this._statVariableAssoc = new Dictionary();
         this._characterCharacteristics = this.playerApi.characteristics();
         this._base = this._characterCharacteristics[this._stat].base;
         this.lbl_title.text = this._statName;
         this.inp_pointsValue.restrictChars = "0-9";
         this.inp_pointsValue.text = "0";
         this.tx_floor_info.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_floor_info,"onTextureReady");
         this.tx_floor_info.uri = this.uiApi.createUri(this.sysApi.getConfigEntry("config.ui.skin") + "texture/help_icon_normal.png");
         _loc5_ = new Vector.<StatVariable>();
         switch(this._statId)
         {
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_VITALITY:
               _loc5_.push(new StatVariable("tx_lifePoints",this.uiApi.getText("ui.stats.lifePoints")));
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_WISDOM:
               _loc5_.push(new StatVariable("tx_attackAP",this.uiApi.getText("ui.stats.PAAttack")),new StatVariable("tx_attackMP",this.uiApi.getText("ui.stats.PMAttack")),new StatVariable("tx_dodgeAP",this.uiApi.getText("ui.stats.dodgeAP")),new StatVariable("tx_dodgeMP",this.uiApi.getText("ui.stats.dodgeMP")));
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_STRENGTH:
               _loc5_.push(new StatVariable("tx_strength",this.uiApi.getText("ui.stats.earthDamage")),new StatVariable("tx_neutral",this.uiApi.getText("ui.stats.neutralDamage")),new StatVariable("tx_pods",this.uiApi.getText("ui.common.weight")),new StatVariable("tx_initiative",this.uiApi.getText("ui.stats.initiative")));
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_INTELLIGENCE:
               _loc5_.push(new StatVariable("tx_intelligence",this.uiApi.getText("ui.stats.fireDamage")),new StatVariable("tx_heal",this.uiApi.getText("ui.stats.healBonus")),new StatVariable("tx_initiative",this.uiApi.getText("ui.stats.initiative")));
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_CHANCE:
               _loc5_.push(new StatVariable("tx_chance",this.uiApi.getText("ui.stats.waterDamage")),new StatVariable("tx_prospecting",this.uiApi.getText("ui.stats.prospecting")),new StatVariable("tx_initiative",this.uiApi.getText("ui.stats.initiative")));
               break;
            case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_AGILITY:
               _loc5_.push(new StatVariable("tx_agility",this.uiApi.getText("ui.stats.airDamage")),new StatVariable("tx_tackle",this.uiApi.getText("ui.stats.takleBlock")),new StatVariable("tx_escape",this.uiApi.getText("ui.stats.takleEvade")),new StatVariable("tx_initiative",this.uiApi.getText("ui.stats.initiative")));
         }
         this._numStatVariables = _loc5_.length;
         this._statSpells = new Array();
         var _loc6_:Object = this.playerApi.getSpellInventory();
         for each(_loc7_ in _loc6_)
         {
            if(_loc7_.id != 0 && this.utilApi.isCharacteristicSpell(_loc7_,this._statId))
            {
               this._statSpells.push(this.dataApi.getSpellWrapper(_loc7_.id,_loc7_.spellLevel));
            }
         }
         this.gd_statSpells.dataProvider = this._statSpells;
         this.gd_statSpells_2.dataProvider = this._statSpells;
         this.gd_statSpells.visible = this.lbl_statSpells.visible = this._statSpells.length > 0 && this._hasAdditionalPoints;
         this.gd_statSpells_2.visible = this.lbl_statSpells_2.visible = this._statSpells.length > 0 && !this._hasAdditionalPoints;
         _loc8_ = 0;
         while(_loc8_ < 4)
         {
            _loc9_ = 0;
            while(_loc9_ < 2)
            {
               _loc10_ = 0;
               while(_loc10_ < 2)
               {
                  _loc13_ = _loc8_ > 0?String(_loc8_ + 1):"";
                  _loc14_ = _loc9_ > 0?"_2":"";
                  _loc15_ = _loc10_ > 0?"_two":"";
                  _loc11_ = _loc8_ == this._numStatVariables - 1;
                  _loc12_ = _loc11_ && (this._statSpells.length == 0 && _loc15_ == "_two" || this._statSpells.length > 0 && _loc15_ == "");
                  this["lbl_statIncreases" + _loc13_ + _loc14_ + _loc15_].visible = _loc12_;
                  this["gd_statVariables" + _loc13_ + _loc14_ + _loc15_].visible = _loc12_;
                  _loc10_++;
               }
               _loc9_++;
            }
            _loc8_++;
         }
         this.getComponent("lbl_statIncreases",!this._hasAdditionalPoints).visible = false;
         this.getComponent("gd_statVariables",!this._hasAdditionalPoints).visible = false;
         this.getComponent("gd_statVariables",true).dataProvider = _loc5_;
         this.getComponent("gd_statVariables",false).dataProvider = _loc5_;
         this._statFloorValueAndCostInBoostForOneStatPoint = new Array();
         this.displayFloors();
         var _loc16_:* = !(this._characterCharacteristics.additionnalPoints == 0 || !param1[2]);
         this.lbl_availablePoints.visible = !_loc16_;
         if(!_loc16_)
         {
            this.ctr_capitalChoice.visible = false;
            this._capital = this._characterCharacteristics.statsPoints;
            this.displayPoints();
            this.inp_pointsValue.focus();
            this.inp_pointsValue.setSelection(0,8388607);
         }
         else
         {
            _loc18_ = this._characterCharacteristics[this._stat].additionnal;
            if(CharacterSheet.getInstance().statPointsBoostType == 0 || _loc18_ >= ProtocolConstantsEnum.MAX_ADDITIONNAL_PER_CARAC)
            {
               this.uiApi.setRadioGroupSelectedItem("capitalChoiceGroup",this.btn_radioStat,_loc2_);
            }
            else
            {
               this.uiApi.setRadioGroupSelectedItem("capitalChoiceGroup",this.btn_radioScroll,_loc2_);
            }
            _loc19_ = 0;
            _loc20_ = 0;
            _loc8_ = 0;
            while(_loc8_ < this._statFloorValueAndCostInBoostForOneStatPoint.length)
            {
               if(this._statFloorValueAndCostInBoostForOneStatPoint[_loc8_ + 1] && this._statFloorValueAndCostInBoostForOneStatPoint[_loc8_ + 1][0] > _loc18_ && this._statFloorValueAndCostInBoostForOneStatPoint[_loc8_][0] <= _loc18_ || !this._statFloorValueAndCostInBoostForOneStatPoint[_loc8_ + 1])
               {
                  _loc21_ = _loc8_;
                  break;
               }
               _loc8_++;
            }
            while(_loc19_ + _loc18_ < ProtocolConstantsEnum.MAX_ADDITIONNAL_PER_CARAC)
            {
               _loc20_ = _loc20_ + this._statFloorValueAndCostInBoostForOneStatPoint[_loc21_][1];
               if(this._statFloorValueAndCostInBoostForOneStatPoint[_loc21_].length > 2)
               {
                  _loc19_ = _loc19_ + int(this._statFloorValueAndCostInBoostForOneStatPoint[_loc21_][2]);
               }
               else
               {
                  _loc19_++;
               }
               if(this._statFloorValueAndCostInBoostForOneStatPoint[_loc21_ + 1] && _loc19_ + _loc18_ >= this._statFloorValueAndCostInBoostForOneStatPoint[_loc21_ + 1][0])
               {
                  _loc21_++;
               }
            }
            this._maxScrollPointsBeforeLimit = _loc20_;
            this.updatePointsType();
            if(_loc18_ >= ProtocolConstantsEnum.MAX_ADDITIONNAL_PER_CARAC)
            {
               this.btn_radioScroll.disabled = true;
               this.ctr_radioScroll.softDisabled = true;
               this.lbl_capitalScroll.cssClass = "disabledboldright";
            }
            else
            {
               this.btn_radioScroll.disabled = false;
               this.ctr_radioScroll.softDisabled = false;
               this.lbl_capitalScroll.cssClass = "whiteboldright";
            }
         }
         if(this._hasAdditionalPoints != _loc16_)
         {
            this.switchVisibility(_loc16_);
         }
         this._hasAdditionalPoints = _loc16_;
         if(_loc2_.disableRender)
         {
            this.sysApi.addEventListener(this.resize,"statBoostResize");
         }
         else
         {
            this.resize();
         }
      }
      
      public function set blockWidth(param1:Number) : void
      {
         var _loc2_:* = this.uiApi.me();
         _loc2_["getElement"]("tx_background_block").width = _loc2_["getElement"]("tx_border_frame_block").width = this.tx_scratch_block.width = param1;
      }
      
      public function set blockHeight(param1:Number) : void
      {
         var _loc2_:* = this.uiApi.me();
         _loc2_["getElement"]("tx_background_block").height = _loc2_["getElement"]("tx_border_frame_block").height = this.tx_scratch_block.height = param1;
      }
      
      public function set windowHeight(param1:Number) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:* = null;
         var _loc2_:* = this.uiApi.me();
         this.ctr_window.height = param1;
         var _loc3_:Object = _loc2_.getElements();
         for(_loc6_ in _loc3_)
         {
            _loc5_ = _loc3_[_loc6_];
            if(_loc5_.getParent() == this.ctr_window)
            {
               _loc4_ = _loc2_.getElementById(_loc6_);
               if(_loc4_.size && _loc4_.size.yUnit == 1)
               {
                  _loc5_.height = this.ctr_window.height;
               }
            }
         }
      }
      
      public function get statId() : uint
      {
         return this._statId;
      }
      
      public function unload() : void
      {
         var _loc1_:* = this.uiApi.getUi("characterSheetUi");
         if(_loc1_ && _loc1_.uiClass)
         {
            _loc1_.uiClass.restoreChildIndex();
         }
         this.sysApi.removeEventListener(this.onEnterFrame);
      }
      
      private function onEnterFrame() : void
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         if(this._characterSheetUi)
         {
            _loc1_ = this._characterSheetUi.getStageRect();
            if(_loc1_.x != this._characterSheetUiX || _loc1_.y != this._characterSheetUiY)
            {
               this.resize();
               _loc2_ = this.uiApi.getVisibleStageBounds();
               if(_loc1_.x + 325 + this.mainCtr.width - _loc2_.x < _loc2_.width)
               {
                  this.mainCtr.x = _loc1_.x + 325;
               }
               else
               {
                  this.mainCtr.x = _loc1_.x - this.mainCtr.width + 40;
               }
               this._characterSheetUiX = _loc1_.x;
               this._characterSheetUiY = _loc1_.y;
            }
         }
      }
      
      private function resize() : void
      {
         var _loc1_:* = this.uiApi.me();
         if(_loc1_.disableRender)
         {
            return;
         }
         var _loc2_:int = (4 - this._numStatVariables) * 25;
         var _loc3_:int = this._statSpells.length == 0?131:0;
         var _loc4_:int = !this._hasAdditionalPoints?int(145 - 41):0;
         var _loc5_:int = _loc2_ + _loc3_ + _loc4_;
         var _loc6_:int = 15;
         var _loc7_:Number = 770 - _loc5_;
         this.windowHeight = _loc7_ - _loc6_;
         _loc1_.processLocation(_loc1_.getElementById("tx_border_frame_ctr_window"));
         _loc1_.processLocation(_loc1_.getElementById("tx_background_ctr_window"));
         this.ctr_content.y = -41 - _loc5_ - _loc6_;
         this.blockWidth = this.ctr_window.width - 43;
         this.blockHeight = _loc7_ - 120 - _loc6_;
         var _loc8_:* = this.uiApi.getUi("characterSheetUi");
         var _loc9_:Object = _loc8_.getStageRect();
         this.mainCtr.y = _loc9_.y + _loc9_.height - _loc7_ + _loc6_ - 10;
         _loc1_.processLocation(_loc1_.getElementById("tx_background_block"));
         _loc1_.processLocation(_loc1_.getElementById("tx_border_frame_block"));
         _loc1_.processLocation(_loc1_.getElementById(this.tx_scratch_block_name));
         this.ctr_block.visible = true;
         this.mainCtr.visible = true;
         this.sysApi.removeEventListener(this.resize);
      }
      
      private function getComponent(param1:String, param2:Boolean) : Object
      {
         var _loc3_:String = this._numStatVariables > 1?this._numStatVariables.toString():"";
         var _loc4_:String = "";
         if(param1.indexOf("lbl_statIncreases") != -1 || param1.indexOf("gd_statVariables") != -1)
         {
            _loc4_ = this._statSpells.length == 0?"_two":"";
         }
         return this[param1 + _loc3_ + (!!param2?"":"_2") + _loc4_];
      }
      
      private function updatePointsType() : void
      {
         var _loc1_:int = 0;
         if(this.btn_radioStat.selected)
         {
            CharacterSheet.getInstance().statPointsBoostType = 0;
            this._capital = this._characterCharacteristics.statsPoints;
            this.ctr_radioScroll.bgAlpha = 0;
            this.ctr_radioStat.bgAlpha = 1;
            this.lbl_capitalScroll.text = this._characterCharacteristics.additionnalPoints.toString();
            this._base = this._characterCharacteristics[this._stat].base;
            this.updateBaseFloor();
            if(this._pointsUsed > this._capital)
            {
               this.inp_pointsValue.text = this._capital.toString();
            }
         }
         else
         {
            CharacterSheet.getInstance().statPointsBoostType = 1;
            this._capital = this._characterCharacteristics.additionnalPoints;
            this.ctr_radioScroll.bgAlpha = 1;
            this.ctr_radioStat.bgAlpha = 0;
            this.lbl_capitalStat.text = this._characterCharacteristics.statsPoints.toString();
            this._base = this._characterCharacteristics[this._stat].additionnal;
            this.updateBaseFloor();
            _loc1_ = this._capital;
            if(this.ctr_capitalChoice.visible && this.btn_radioScroll.selected && _loc1_ > this._maxScrollPointsBeforeLimit)
            {
               _loc1_ = this._maxScrollPointsBeforeLimit;
            }
            if(this._pointsUsed > _loc1_)
            {
               this.inp_pointsValue.text = _loc1_.toString();
            }
         }
         this.displayPoints();
         this.inp_pointsValue.focus();
         this.inp_pointsValue.setSelection(0,8388607);
      }
      
      private function validatePointsChoice() : void
      {
         var _loc1_:String = null;
         if(this._pointsUsed > 0)
         {
            if(this._rest != 0)
            {
               _loc1_ = this.uiApi.getText("ui.charaSheet.evolutionWarn",this._pointsUsed,this._pointsUsed - this._rest,this._rest);
               this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),_loc1_,[this.uiApi.getText("ui.common.ok"),this.uiApi.getText("ui.common.cancel")],[this.onPopupSendBoost,this.onPopupClose],this.onPopupSendBoost,this.onPopupClose);
            }
            else
            {
               this.sysApi.sendAction(new StatsUpgradeRequest(this.ctr_capitalChoice.visible && !this.btn_radioStat.selected,this._statId,this._pointsUsed));
               this.uiApi.unloadUi(this.uiApi.me().name);
            }
         }
      }
      
      private function addStatPoint(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         if(param1 > 0)
         {
            _loc3_ = this._statFloorValueAndCostInBoostForOneStatPoint[this._currentFloor + _loc2_][1] - this._rest;
            _loc4_ = this._capital;
            if(this.ctr_capitalChoice.visible && this.btn_radioScroll.selected && _loc4_ > this._maxScrollPointsBeforeLimit)
            {
               _loc4_ = this._maxScrollPointsBeforeLimit;
            }
            if(_loc4_ >= this._pointsUsed + _loc3_)
            {
               this._pointsUsed = this._pointsUsed + _loc3_;
            }
            else
            {
               return;
            }
         }
         else
         {
            _loc3_ = this._rest;
            if(this._pointsUsed == 0)
            {
               _loc4_ = this._capital;
               if(this.ctr_capitalChoice.visible && this.btn_radioScroll.selected && _loc4_ > this._maxScrollPointsBeforeLimit)
               {
                  _loc4_ = this._maxScrollPointsBeforeLimit;
               }
               this._pointsUsed = _loc4_;
               this.inp_pointsValue.text = this._pointsUsed.toString();
            }
            else
            {
               if(this._statFloorValueAndCostInBoostForOneStatPoint[this._currentFloor - 1] && this._statPointsAdded + this._base - 1 < this._statFloorValueAndCostInBoostForOneStatPoint[this._currentFloor][0])
               {
                  _loc2_ = -1;
               }
               if(_loc3_ == 0)
               {
                  _loc3_ = this._statFloorValueAndCostInBoostForOneStatPoint[this._currentFloor + _loc2_][1];
               }
               if(this._pointsUsed >= _loc3_)
               {
                  this._pointsUsed = this._pointsUsed - _loc3_;
               }
               else
               {
                  return;
               }
            }
         }
         this.inp_pointsValue.text = this._pointsUsed.toString();
         this.displayPoints();
      }
      
      private function displayPoints() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = this._pointsUsed;
         this._currentFloor = this._baseFloor;
         while(_loc2_ >= this._statFloorValueAndCostInBoostForOneStatPoint[this._currentFloor][1])
         {
            _loc2_ = _loc2_ - this._statFloorValueAndCostInBoostForOneStatPoint[this._currentFloor][1];
            if(this._statFloorValueAndCostInBoostForOneStatPoint[this._currentFloor].length > 2)
            {
               _loc1_ = _loc1_ + int(this._statFloorValueAndCostInBoostForOneStatPoint[this._currentFloor][2]);
            }
            else
            {
               _loc1_++;
            }
            if(this._statFloorValueAndCostInBoostForOneStatPoint[this._currentFloor + 1] && _loc1_ + this._base >= this._statFloorValueAndCostInBoostForOneStatPoint[this._currentFloor + 1][0])
            {
               this._currentFloor++;
            }
         }
         this._rest = _loc2_;
         if(this.ctr_capitalChoice.visible)
         {
            if(this.btn_radioStat.selected)
            {
               this.lbl_capitalStat.text = String(this._characterCharacteristics.statsPoints - this._pointsUsed);
            }
            else
            {
               this.lbl_capitalScroll.text = String(this._characterCharacteristics.additionnalPoints - this._pointsUsed);
            }
         }
         this._statPointsAdded = _loc1_;
         this.lbl_availablePoints.text = this.uiApi.getText("ui.stat.availablePoints",this._characterCharacteristics.statsPoints - this._pointsUsed);
         this.lbl_statName.text = this._statName;
         this.lbl_statBase.text = this._characterCharacteristics[this._stat].base;
         this.lbl_statBaseAdd.text = "+" + this._statPointsAdded;
         var _loc3_:int = this._characterCharacteristics[this._stat].additionnal + this._characterCharacteristics[this._stat].objectsAndMountBonus;
         this.lbl_statBonus.text = String(_loc3_);
         this.lbl_statTotal.text = String(this._characterCharacteristics[this._stat].base + this._statPointsAdded + _loc3_);
         this.lbl_currentFloor.text = this.uiApi.processText(this.uiApi.getText("ui.stats.floorPointsForStat",this._statFloorValueAndCostInBoostForOneStatPoint[this._currentFloor][1],1,this._statName),"",this._statFloorValueAndCostInBoostForOneStatPoint[this._currentFloor][1] <= 1);
         if(this.tx_floor_info.finalized)
         {
            this.updateTxFloorPosition();
         }
      }
      
      private function displayFloors() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         switch(this._stat)
         {
            case "vitality":
               _loc1_ = this.dataApi.getBreed(this.playerApi.getPlayedCharacterInfo().breed).statsPointsForVitality;
               break;
            case "wisdom":
               _loc1_ = this.dataApi.getBreed(this.playerApi.getPlayedCharacterInfo().breed).statsPointsForWisdom;
               break;
            case "strength":
               _loc1_ = this.dataApi.getBreed(this.playerApi.getPlayedCharacterInfo().breed).statsPointsForStrength;
               break;
            case "intelligence":
               _loc1_ = this.dataApi.getBreed(this.playerApi.getPlayedCharacterInfo().breed).statsPointsForIntelligence;
               break;
            case "chance":
               _loc1_ = this.dataApi.getBreed(this.playerApi.getPlayedCharacterInfo().breed).statsPointsForChance;
               break;
            case "agility":
               _loc1_ = this.dataApi.getBreed(this.playerApi.getPlayedCharacterInfo().breed).statsPointsForAgility;
         }
         for each(_loc2_ in _loc1_)
         {
            this._statFloorValueAndCostInBoostForOneStatPoint.push(_loc2_);
         }
         this.updateBaseFloor();
      }
      
      private function updateBaseFloor() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._statFloorValueAndCostInBoostForOneStatPoint.length)
         {
            if(this._statFloorValueAndCostInBoostForOneStatPoint[_loc1_ + 1] && this._statFloorValueAndCostInBoostForOneStatPoint[_loc1_ + 1][0] > this._base && this._statFloorValueAndCostInBoostForOneStatPoint[_loc1_][0] <= this._base || !this._statFloorValueAndCostInBoostForOneStatPoint[_loc1_ + 1])
            {
               this._baseFloor = _loc1_;
               break;
            }
            _loc1_++;
         }
      }
      
      private function switchVisibility(param1:Boolean) : void
      {
         this.getComponent("lbl_statIncreases",true).visible = param1;
         this.getComponent("lbl_statIncreases",false).visible = !param1;
         this.getComponent("gd_statVariables",true).visible = param1;
         this.getComponent("gd_statVariables",false).visible = !param1;
         this.lbl_statSpells.visible = param1 && this._statSpells.length > 0;
         this.lbl_statSpells_2.visible = !param1 && this._statSpells.length > 0;
         this.gd_statSpells.visible = param1 && this._statSpells.length > 0;
         this.gd_statSpells_2.visible = !param1 && this._statSpells.length > 0;
      }
      
      private function updateTxFloorPosition() : void
      {
         this.tx_floor_info.x = this.lbl_currentFloor.textfield.getLineMetrics(0).x + this.lbl_currentFloor.textfield.textWidth + this.tx_floor_info.width + 5;
      }
      
      public function onCharacterStatsList(param1:Boolean = false) : void
      {
         this._characterCharacteristics = this.playerApi.characteristics();
         this._base = this._characterCharacteristics[this._stat].base;
         this.displayPoints();
      }
      
      public function onTextureReady(param1:Object) : void
      {
         if(param1 == this.tx_floor_info)
         {
            this.updateTxFloorPosition();
         }
      }
      
      public function updateStatVariable(param1:Object, param2:*, param3:Boolean) : void
      {
         var _loc4_:Array = null;
         if(param1)
         {
            param2.tx_variable.uri = this.uiApi.createUri(this.uiApi.me().getConstant("picto_uri") + param1.gfxId);
            param2.lbl_variable.text = param1.text;
            _loc4_ = param2.lbl_variable.customUnicName.split("_");
            this._statVariableAssoc[param2.lbl_variable] = {
               "data":param1,
               "index":parseInt(_loc4_[_loc4_.length - 1])
            };
         }
         else
         {
            param2.tx_variable.uri = null;
            param2.lbl_variable.text = "";
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_valid:
               this.validatePointsChoice();
               break;
            case this.btn_less:
               this.addStatPoint(-1);
               break;
            case this.btn_more:
               this.addStatPoint(1);
               break;
            case this.btn_radioStat:
               this.updatePointsType();
               break;
            case this.ctr_radioStat:
               this.uiApi.setRadioGroupSelectedItem("capitalChoiceGroup",this.btn_radioStat,this.uiApi.me());
               this.updatePointsType();
               break;
            case this.btn_radioScroll:
               this.updatePointsType();
               break;
            case this.ctr_radioScroll:
               this.uiApi.setRadioGroupSelectedItem("capitalChoiceGroup",this.btn_radioScroll,this.uiApi.me());
               this.updatePointsType();
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(param1 == this.tx_floor_info)
         {
            this.uiApi.showTooltip({
               "statName":this._statName,
               "floors":this._statFloorValueAndCostInBoostForOneStatPoint
            },param1,false,"standard",LocationEnum.POINT_BOTTOMLEFT,LocationEnum.POINT_TOP,3,"statFloors");
         }
         else if(param1 == this.ctr_radioScroll && this.ctr_radioScroll.softDisabled)
         {
            _loc2_ = this.uiApi.getText("ui.charaSheet.noBoostIfMaxReached",ProtocolConstantsEnum.MAX_ADDITIONNAL_PER_CARAC);
         }
         else if(param1 == this.lbl_statBonus)
         {
            _loc2_ = this.uiApi.getText("ui.stats.bonuses");
         }
         else if(param1.customUnicName.indexOf("lbl_variable") != -1 && this._statVariableAssoc[param1])
         {
            _loc3_ = this._statVariableAssoc[param1].index;
            _loc6_ = this._characterCharacteristics[this._stat].base + this._characterCharacteristics[this._stat].additionnal + this._characterCharacteristics[this._stat].objectsAndMountBonus;
            switch(this._statId)
            {
               case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_WISDOM:
                  _loc4_ = 10;
                  _loc5_ = 1;
                  break;
               case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_STRENGTH:
                  _loc4_ = 1;
                  if(_loc3_ == 2)
                  {
                     _loc5_ = 10;
                  }
                  else if(_loc3_ == 3)
                  {
                     _loc5_ = 1;
                  }
                  else
                  {
                     return;
                  }
                  break;
               case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_CHANCE:
                  _loc5_ = 1;
                  if(_loc3_ == 1)
                  {
                     _loc4_ = 10;
                  }
                  else if(_loc3_ == 2)
                  {
                     _loc4_ = 1;
                  }
                  else
                  {
                     return;
                  }
                  break;
               case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_AGILITY:
                  _loc5_ = 1;
                  if(_loc3_ == 1 || _loc3_ == 2)
                  {
                     _loc4_ = 10;
                  }
                  else if(_loc3_ == 3)
                  {
                     _loc4_ = 1;
                  }
                  else
                  {
                     return;
                  }
                  break;
               case BoostableCharacteristicEnum.BOOSTABLE_CHARAC_INTELLIGENCE:
                  if(_loc3_ == 2)
                  {
                     _loc4_ = _loc5_ = 1;
                     break;
                  }
                  return;
            }
            if(_loc5_ > 0)
            {
               _loc2_ = this.uiApi.getText("ui.stats.statIncreases.tooltip",this.uiApi.processText(this.uiApi.getText(this._statPointsName,_loc4_),"",_loc4_ <= 1),_loc5_,param1.text,this.uiApi.processText(this.uiApi.getText(this._statPointsName,_loc6_),"",_loc6_ <= 1));
            }
         }
         if(!_loc2_)
         {
            return;
         }
         this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         var _loc3_:SpellWrapper = null;
         if(param2.data)
         {
            _loc3_ = this.playerApi.getSpell(param2.data.id);
            if(_loc3_ == null)
            {
               return;
            }
            this.uiApi.showTooltip(_loc3_,param2.container,false,"standard");
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "validUi":
               this.validatePointsChoice();
               return true;
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      public function onChange(param1:GraphicContainer) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1 == this.inp_pointsValue)
         {
            _loc2_ = this.inp_pointsValue.text;
            if(_loc2_)
            {
               this._pointsUsed = int(_loc2_);
            }
            else
            {
               this._pointsUsed = 0;
            }
            _loc3_ = this._capital;
            if(this.ctr_capitalChoice.visible && this.btn_radioScroll.selected && _loc3_ > this._maxScrollPointsBeforeLimit)
            {
               _loc3_ = this._maxScrollPointsBeforeLimit;
            }
            if(this._pointsUsed > _loc3_)
            {
               this.inp_pointsValue.text = _loc3_.toString();
            }
            else
            {
               this.displayPoints();
            }
         }
      }
      
      public function onPopupClose() : void
      {
      }
      
      public function onPopupSendBoost() : void
      {
         this.sysApi.sendAction(new StatsUpgradeRequest(this.ctr_capitalChoice.visible && !this.btn_radioStat.selected,this._statId,this._pointsUsed - this._rest));
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function isSpellActive(param1:SpellWrapper) : Boolean
      {
         return this.dataApi.getSpellLevelBySpell(param1.spell,1).minPlayerLevel <= this.playerApi.getPlayedCharacterInfo().level;
      }
   }
}

class StatVariable
{
    
   
   public var gfxId:String;
   
   public var text:String;
   
   function StatVariable(param1:String, param2:String)
   {
      super();
      this.gfxId = param1;
      this.text = param2;
   }
}
