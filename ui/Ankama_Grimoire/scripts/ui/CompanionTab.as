package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.characteristics.Characteristic;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.monsters.Companion;
   import com.ankamagames.dofus.datacenter.monsters.CompanionCharacteristic;
   import com.ankamagames.dofus.datacenter.monsters.CompanionSpell;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.TooltipApi;
   import d2actions.ObjectSetPosition;
   import d2enums.CharacterInventoryPositionEnum;
   import d2enums.ComponentHookList;
   import d2enums.LocationEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.ObjectModified;
   import flash.geom.ColorTransform;
   
   public class CompanionTab
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var tooltipApi:TooltipApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var inventoryApi:InventoryApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _colorDisable:ColorTransform;
      
      private var _coloravailable:ColorTransform;
      
      private var _allCompanions:Array;
      
      private var _myCompanions:Array;
      
      private var _selectedCompanion:Companion;
      
      private var _selectedSpell:SpellWrapper;
      
      private var _initialSpellId:uint;
      
      private var _shownTooltipId:int;
      
      private var _currentlyEquipedGID:int;
      
      private var _etherealResText:String;
      
      private var _myLevel:uint;
      
      private var _illusUri:String;
      
      public var gd_companions:Grid;
      
      public var btn_carac:ButtonContainer;
      
      public var btn_spells:ButtonContainer;
      
      public var btn_equip:ButtonContainer;
      
      public var btn_lbl_btn_equip:Label;
      
      public var ctr_carac:GraphicContainer;
      
      public var ctr_spells:GraphicContainer;
      
      public var ctr_spellTooltip:GraphicContainer;
      
      public var tx_spellIcon:Texture;
      
      public var lbl_spellName:Label;
      
      public var lbl_spellInitial:Label;
      
      public var gd_spell:Grid;
      
      public var tx_illu:Texture;
      
      public var tx_etherealGauge:Texture;
      
      public var lbl_name:Label;
      
      public var lbl_level:Label;
      
      public var gd_carac:Grid;
      
      public var lbl_description:TextArea;
      
      public var btn_close:ButtonContainer;
      
      public function CompanionTab()
      {
         this._colorDisable = new ColorTransform(1,1,1,0.4);
         this._coloravailable = new ColorTransform();
         this._allCompanions = new Array();
         this._myCompanions = new Array();
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc4_:int = 0;
         var _loc6_:EffectInstance = null;
         var _loc7_:Companion = null;
         this.sysApi.addHook(ObjectModified,this.onObjectModified);
         this.uiApi.addComponentHook(this.gd_companions,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.tx_etherealGauge,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.tx_etherealGauge,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_RELEASE);
         this._myLevel = this.playerApi.getPlayedCharacterInfo().level;
         if(this._myLevel > ProtocolConstantsEnum.MAX_LEVEL)
         {
            this._myLevel = ProtocolConstantsEnum.MAX_LEVEL;
         }
         this._illusUri = this.uiApi.me().getConstant("illus");
         var _loc2_:ItemWrapper = this.inventoryApi.getEquipementItemByPosition(CharacterInventoryPositionEnum.INVENTORY_POSITION_COMPANION);
         var _loc3_:Array = new Array();
         var _loc5_:Boolean = false;
         if(_loc2_)
         {
            this._currentlyEquipedGID = _loc2_.objectGID;
            _loc3_.push(_loc2_);
         }
         for each(_loc2_ in this.inventoryApi.getStorageObjectsByType(169))
         {
            _loc3_.push(_loc2_);
         }
         for each(_loc2_ in _loc3_)
         {
            _loc5_ = false;
            for each(_loc6_ in _loc2_.effects)
            {
               if(_loc6_.effectId == 1161)
               {
                  _loc4_ = int(_loc6_.parameter0);
               }
               if(_loc6_.effectId == 812)
               {
                  _loc5_ = true;
               }
            }
            if(_loc2_.objectGID == this._currentlyEquipedGID || !this._myCompanions[_loc4_] || this._myCompanions[_loc4_] && this._myCompanions[_loc4_].isEthereal && this._myCompanions[_loc4_].item.objectGID != this._currentlyEquipedGID)
            {
               this._myCompanions[_loc4_] = {
                  "item":_loc2_,
                  "isEthereal":_loc5_
               };
            }
         }
         for each(_loc7_ in this.dataApi.getAllCompanions())
         {
            this._allCompanions.push(_loc7_);
         }
         this.gd_companions.dataProvider = this._allCompanions;
         this.gd_companions.selectedIndex = 0;
         this._selectedCompanion = this.gd_companions.dataProvider[0];
         this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_carac,this.uiApi.me());
         this.btn_carac.selected = true;
         this.onRelease(this.btn_carac);
      }
      
      public function unload() : void
      {
      }
      
      public function updateLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.tx_selected.visible = param3;
            param2.tx_look.uri = this.uiApi.createUri(this._illusUri + "small_" + param1.assetId + ".jpg");
            if(this._myCompanions[param1.id])
            {
               Texture(param2.tx_look).transform.colorTransform = this._coloravailable;
            }
            else
            {
               Texture(param2.tx_look).transform.colorTransform = this._colorDisable;
            }
         }
         else
         {
            param2.tx_selected.visible = false;
            param2.tx_look.uri = null;
         }
      }
      
      public function updateSpellLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.btn_spell.selected = param3;
            param2.btn_spell.softDisabled = false;
            param2.lbl_spellName.text = param1.name;
            param2.slot_icon.allowDrag = false;
            param2.slot_icon.data = param1;
            param2.slot_icon.selected = false;
         }
         else
         {
            param2.btn_spell.selected = false;
            param2.lbl_spellName.text = "";
            param2.slot_icon.data = null;
            param2.btn_spell.softDisabled = true;
            param2.btn_spell.reset();
         }
      }
      
      public function updateCaracLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            param2.lbl_carac.text = param1.text;
         }
         else
         {
            param2.lbl_carac.text = "";
         }
      }
      
      public function onPopupClose() : void
      {
      }
      
      private function displayCompanionCarac() : void
      {
         var _loc2_:CompanionCharacteristic = null;
         var _loc3_:Characteristic = null;
         var _loc5_:int = 0;
         this.ctr_carac.visible = true;
         this.ctr_spells.visible = false;
         this.lbl_name.text = this._selectedCompanion.name;
         this.lbl_level.text = this.uiApi.getText("ui.common.level") + " " + this._myLevel;
         this.tx_illu.uri = this.uiApi.createUri(this._illusUri + "big_" + this._selectedCompanion.assetId + ".jpg");
         var _loc1_:Array = new Array();
         var _loc4_:int = 0;
         for each(_loc5_ in this._selectedCompanion.characteristics)
         {
            _loc2_ = this.dataApi.getCompanionCharacteristic(_loc5_);
            _loc4_ = this.getStatValue(_loc2_.statPerLevelRange,this._myLevel);
            _loc1_.push({
               "text":_loc2_.name + this.uiApi.getText("ui.common.colon") + _loc4_,
               "order":_loc2_.order
            });
         }
         _loc1_.sortOn("order",Array.NUMERIC);
         this.gd_carac.dataProvider = _loc1_;
         this.lbl_description.text = this._selectedCompanion.description;
      }
      
      private function displayCompanionSpells() : void
      {
         var _loc2_:CompanionSpell = null;
         var _loc3_:SpellWrapper = null;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:SpellLevel = null;
         var _loc8_:int = 0;
         this.ctr_spells.visible = true;
         this.ctr_carac.visible = false;
         var _loc1_:Array = new Array();
         var _loc4_:uint = 1;
         this._initialSpellId = 0;
         if(this._selectedCompanion.startingSpellLevelId != 0)
         {
            _loc7_ = this.dataApi.getSpellLevel(this._selectedCompanion.startingSpellLevelId);
            if(_loc7_)
            {
               _loc3_ = this.dataApi.getSpellWrapper(_loc7_.spellId,_loc7_.grade);
               _loc1_.push(_loc3_);
               this._initialSpellId = _loc3_.id;
            }
         }
         for each(_loc6_ in this._selectedCompanion.spells)
         {
            _loc2_ = this.dataApi.getCompanionSpell(_loc6_);
            _loc5_ = _loc2_.gradeByLevel.split(",");
            _loc8_ = 0;
            while(_loc8_ < _loc5_.length)
            {
               if(_loc5_[_loc8_ + 1] <= this._myLevel)
               {
                  _loc4_ = _loc5_[_loc8_];
               }
               _loc8_ = _loc8_ + 2;
            }
            _loc3_ = this.dataApi.getSpellWrapper(_loc2_.spellId,_loc4_);
            _loc1_.push(_loc3_);
         }
         this.gd_spell.dataProvider = _loc1_;
         this.gd_spell.selectedIndex = 0;
      }
      
      private function displayCompanionInfos() : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         this.tx_etherealGauge.visible = false;
         this.btn_equip.disabled = true;
         this.btn_lbl_btn_equip.text = this.uiApi.getText("ui.common.equip");
         var _loc1_:Object = this._myCompanions[this._selectedCompanion.id];
         if(_loc1_)
         {
            _loc2_ = false;
            if(_loc1_.isEthereal)
            {
               for each(_loc4_ in _loc1_.item.effects)
               {
                  if(_loc4_.effectId == 812)
                  {
                     this._etherealResText = _loc4_.description;
                     if(_loc4_.hasOwnProperty("diceNum"))
                     {
                        _loc5_ = _loc4_.diceNum;
                     }
                     else
                     {
                        _loc5_ = 0;
                     }
                     _loc3_ = int(_loc5_ / _loc4_.value * 100);
                     this.tx_etherealGauge.gotoAndStop = _loc3_.toString();
                     this.tx_etherealGauge.visible = true;
                     if(_loc5_ == 0)
                     {
                        _loc2_ = true;
                     }
                  }
               }
            }
            if(!_loc2_)
            {
               this.btn_equip.disabled = false;
               if(this._currentlyEquipedGID == _loc1_.item.objectGID)
               {
                  this.btn_lbl_btn_equip.text = this.uiApi.getText("ui.common.unequip");
               }
            }
         }
      }
      
      private function updateSpellDisplay() : void
      {
         this.lbl_spellName.text = this._selectedSpell.spell.name;
         this.tx_spellIcon.uri = this._selectedSpell.fullSizeIconUri;
         if(this._initialSpellId == this._selectedSpell.id)
         {
            this.lbl_spellInitial.visible = true;
         }
         else
         {
            this.lbl_spellInitial.visible = false;
         }
         this.showSpellTooltip(this._selectedSpell);
      }
      
      private function showSpellTooltip(param1:SpellWrapper) : void
      {
         if(this._shownTooltipId == param1.spellId)
         {
            return;
         }
         this._shownTooltipId = param1.spellId;
         this.uiApi.showTooltip(param1,null,false,"tooltipSpellTab",0,2,3,null,null,{
            "smallSpell":false,
            "description":true,
            "effects":true,
            "contextual":true,
            "noBg":true,
            "currentCC_EC":false,
            "baseCC_EC":true,
            "spellTab":true
         },null,true);
      }
      
      private function getStatValue(param1:Object, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = param1.length;
         var _loc5_:int = parseInt(param1[0][0]) == 1?int(param1[0][1]):0;
         var _loc6_:int = !!_loc5_?1:0;
         _loc3_ = _loc5_;
         while(_loc6_ < _loc4_)
         {
            if(param2 <= param1[_loc6_][0])
            {
               _loc3_ = _loc3_ + param1[_loc6_][1] * (param2 - 1);
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_carac:
               this.displayCompanionCarac();
               break;
            case this.btn_spells:
               this.displayCompanionSpells();
               break;
            case this.btn_equip:
               _loc2_ = this._myCompanions[this._selectedCompanion.id];
               if(_loc2_)
               {
                  if(_loc2_.item.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_COMPANION)
                  {
                     this.sysApi.sendAction(new ObjectSetPosition(_loc2_.item.objectUID,63,1));
                  }
                  else
                  {
                     this.sysApi.sendAction(new ObjectSetPosition(_loc2_.item.objectUID,CharacterInventoryPositionEnum.INVENTORY_POSITION_COMPANION,1));
                  }
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         switch(param1)
         {
            case this.tx_etherealGauge:
               _loc2_ = this._etherealResText;
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
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param1 == this.gd_spell)
         {
            this._selectedSpell = this.gd_spell.dataProvider[param1.selectedIndex];
            if(this._selectedSpell == null)
            {
               return;
            }
            this.updateSpellDisplay();
         }
         else if(param1 == this.gd_companions)
         {
            this._selectedCompanion = this.gd_companions.selectedItem;
            if(this.ctr_spells.visible)
            {
               this.displayCompanionSpells();
            }
            else
            {
               this.displayCompanionCarac();
            }
            this.displayCompanionInfos();
         }
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
      }
      
      public function onObjectModified(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:EffectInstance = null;
         if(param1.position == CharacterInventoryPositionEnum.INVENTORY_POSITION_COMPANION)
         {
            this._currentlyEquipedGID = param1.objectGID;
            _loc2_ = false;
            for each(_loc4_ in param1.effects)
            {
               if(_loc4_.effectId == 1161)
               {
                  _loc3_ = int(_loc4_.parameter0);
               }
               if(_loc4_.effectId == 812)
               {
                  _loc2_ = true;
               }
            }
            this._myCompanions[_loc3_] = {
               "item":param1,
               "isEthereal":_loc2_
            };
            if(this._myCompanions[this._selectedCompanion.id].item.objectGID == this._currentlyEquipedGID)
            {
               this.displayCompanionInfos();
            }
         }
         else if(param1.position == 63 && this._currentlyEquipedGID == param1.objectGID)
         {
            if(this._myCompanions[this._selectedCompanion.id].item.objectGID == this._currentlyEquipedGID)
            {
               this._currentlyEquipedGID = 0;
               this.displayCompanionInfos();
            }
            else
            {
               this._currentlyEquipedGID = 0;
            }
         }
      }
   }
}
