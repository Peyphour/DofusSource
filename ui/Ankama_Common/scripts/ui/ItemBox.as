package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.internalDatacenter.items.MountWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.WeaponWrapper;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2hooks.MapComplementaryInformationsData;
   import d2hooks.ObjectModified;
   import d2hooks.TextureLoadFailed;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public class ItemBox
   {
      
      private static var _itemIconX:Number;
      
      private static var _itemIconY:Number;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var menuApi:ContextMenuApi;
      
      public var playerApi:PlayedCharacterApi;
      
      private var _currentTab:uint = 0;
      
      private var _item:Object;
      
      private var _sameItem:Boolean = false;
      
      private var _showTheoretical:Boolean = false;
      
      private var _ownedItem:Boolean = false;
      
      private var _etherealRes:String;
      
      private var _subareaId:int;
      
      public var lbl_name:Label;
      
      public var lbl_level:Label;
      
      public var lbl_weight:Label;
      
      public var lbl_description:TextArea;
      
      public var tx_item:Texture;
      
      public var tx_etherealGauge:Texture;
      
      public var tx_2hands:Texture;
      
      public var tx_mimicry:Texture;
      
      public var btn_info:ButtonContainer;
      
      public var btn_effects:ButtonContainer;
      
      public var btn_conditions:ButtonContainer;
      
      public var btn_caracteristics:ButtonContainer;
      
      public var gd_lines:Grid;
      
      public function ItemBox()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         this.btn_info.soundId = SoundEnum.GEN_BUTTON;
         this.btn_effects.soundId = SoundEnum.GEN_BUTTON;
         this.btn_conditions.soundId = SoundEnum.GEN_BUTTON;
         this.btn_caracteristics.soundId = SoundEnum.GEN_BUTTON;
         this.sysApi.addHook(ObjectModified,this.onObjectModified);
         this.sysApi.addHook(TextureLoadFailed,this.onTextureLoadFailed);
         this.sysApi.addHook(MapComplementaryInformationsData,this.onMapComplementaryInformationsData);
         this.uiApi.addComponentHook(this.tx_etherealGauge,"onRollOver");
         this.uiApi.addComponentHook(this.tx_etherealGauge,"onRollOut");
         this.uiApi.addComponentHook(this.tx_2hands,"onRollOver");
         this.uiApi.addComponentHook(this.tx_2hands,"onRollOut");
         this.uiApi.addComponentHook(this.tx_mimicry,"onRollOver");
         this.uiApi.addComponentHook(this.tx_mimicry,"onRollOut");
         if(isNaN(_itemIconX))
         {
            _itemIconX = this.tx_item.x;
         }
         if(isNaN(_itemIconY))
         {
            _itemIconY = this.tx_item.y;
         }
         this.tx_item.dispatchMessages = true;
         this.uiApi.addComponentHook(this.tx_item,"onTextureReady");
         this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_effects,this.uiApi.me());
         this.btn_effects.selected = true;
         if(param1.showTheoretical)
         {
            this._showTheoretical = param1.showTheoretical;
         }
         if(param1.ownedItem)
         {
            this._ownedItem = param1.ownedItem;
         }
         this.updateItem(param1.item);
      }
      
      public function unload() : void
      {
      }
      
      private function updateItem(param1:Object = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         if(param1)
         {
            if(this._item && this._item.objectUID == param1.objectUID)
            {
               this._sameItem = true;
            }
            else
            {
               this._sameItem = false;
            }
            this._item = param1;
            this.lbl_name.cssClass = "light";
            if(this._item.etheral)
            {
               this.lbl_name.cssClass = "itemetheral";
            }
            if(this._item.itemSetId != -1)
            {
               this.lbl_name.cssClass = "itemset";
            }
            this.lbl_name.text = this._item.name;
            if(this.sysApi.getPlayerManager().hasRights)
            {
               this.lbl_name.text = this.lbl_name.text + (" (" + this._item.id + ")");
            }
            this.lbl_level.text = this.uiApi.getText("ui.common.short.level") + " " + this._item.level;
            this.lbl_weight.text = this.uiApi.processText(this.uiApi.getText("ui.common.short.weight",this._item.weight),"m",this._item.weight <= 1);
            _loc2_ = "";
            if(this._item.hasOwnProperty("itemSetId") && this._item.itemSetId != -1)
            {
               _loc2_ = _loc2_ + (this.dataApi.getItemSet(this._item.itemSetId).name + " - ");
            }
            if(this._item.type)
            {
               _loc2_ = _loc2_ + (this.uiApi.getText("ui.common.category") + this.uiApi.getText("ui.common.colon") + this._item.type.name);
            }
            _loc2_ = _loc2_ + ("\n" + this._item.description);
            this.lbl_description.text = _loc2_;
            if(!this._sameItem)
            {
               this.tx_item.visible = false;
            }
            this.tx_item.uri = this._item.fullSizeIconUri;
            this.tx_etherealGauge.visible = false;
            if(!this._showTheoretical)
            {
               for each(_loc4_ in this._item.effects)
               {
                  if(_loc4_.effectId == 812)
                  {
                     this._etherealRes = _loc4_.description;
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
                  }
               }
            }
            if(this._item.isWeapon && this._item.twoHanded)
            {
               this.tx_2hands.visible = true;
            }
            else
            {
               this.tx_2hands.visible = false;
            }
            if(this._item.isMimicryObject || this._item.isObjectWrapped)
            {
               this.tx_mimicry.visible = true;
            }
            else
            {
               this.tx_mimicry.visible = false;
            }
            if(!this._item.isWeapon)
            {
               this.btn_caracteristics.visible = false;
               if(this._currentTab == 2)
               {
                  this._currentTab = 0;
                  this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_effects,this.uiApi.me());
                  this.btn_effects.selected = true;
               }
            }
            else
            {
               this.btn_caracteristics.visible = true;
            }
            this.updateGrid();
         }
         else
         {
            this.sysApi.log(2,"item null, rien à afficher dans ItemBox");
         }
      }
      
      private function updateGrid() : void
      {
         var _loc3_:RegExp = null;
         var _loc4_:RegExp = null;
         var _loc5_:WeaponWrapper = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Object = null;
         var _loc9_:uint = 0;
         var _loc10_:Boolean = false;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:String = null;
         var _loc17_:* = null;
         var _loc18_:Object = null;
         var _loc19_:Object = null;
         var _loc20_:uint = 0;
         var _loc21_:String = null;
         var _loc22_:Boolean = false;
         var _loc23_:String = null;
         var _loc24_:Object = null;
         var _loc25_:String = null;
         var _loc26_:String = null;
         var _loc27_:Object = null;
         var _loc28_:Object = null;
         var _loc29_:int = 0;
         var _loc30_:int = 0;
         var _loc31_:int = 0;
         var _loc32_:int = 0;
         var _loc1_:Array = new Array();
         switch(this._currentTab)
         {
            case 0:
               this.showEffect(_loc1_);
               break;
            case 1:
               _loc3_ = /</g;
               _loc4_ = />/g;
               if(this._item.conditions)
               {
                  for each(_loc8_ in this._item.conditions.criteria)
                  {
                     _loc9_ = 0;
                     _loc10_ = _loc8_.isRespected;
                     _loc11_ = "p";
                     _loc12_ = _loc8_.text.indexOf("|");
                     _loc14_ = 0;
                     _loc15_ = 0;
                     _loc13_ = 0;
                     while(_loc13_ < _loc8_.inlineCriteria.length)
                     {
                        _loc17_ = "";
                        _loc18_ = _loc8_.inlineCriteria[_loc13_];
                        if(_loc18_.text != "")
                        {
                           if(_loc9_ > 0)
                           {
                              if(_loc12_ > 0)
                              {
                                 _loc17_ = " " + this.uiApi.getText("ui.common.or") + " ";
                              }
                           }
                           _loc17_ = _loc17_ + _loc18_.text;
                           if(_loc8_.inlineCriteria.length > 1 && _loc13_ == _loc14_)
                           {
                              _loc17_ = "(" + _loc17_;
                           }
                           if(_loc16_ == "|")
                           {
                              _loc17_ = this.uiApi.getText("ui.common.or") + " " + _loc17_;
                              _loc16_ = "null";
                           }
                           else if(_loc16_ == "&")
                           {
                              _loc17_ = this.uiApi.getText("ui.common.and") + " " + _loc17_;
                              _loc16_ = "null";
                           }
                           if(_loc8_.inlineCriteria.length > 1)
                           {
                              if(_loc13_ != _loc14_ && _loc13_ == _loc8_.inlineCriteria.length - 1)
                              {
                                 _loc17_ = _loc17_ + ")";
                                 if(this._item.conditions.operators && this._item.conditions.operators.length > _loc15_)
                                 {
                                    _loc16_ = this._item.conditions.operators[_loc15_];
                                 }
                                 _loc15_++;
                              }
                           }
                           else if(this._item.conditions.criteria.length > 1)
                           {
                              if(this._item.conditions.operators[_loc15_] == "|")
                              {
                                 _loc16_ = this._item.conditions.operators[_loc15_];
                                 _loc15_++;
                              }
                           }
                           _loc9_++;
                        }
                        else if(_loc13_ == 0)
                        {
                           _loc14_++;
                        }
                        _loc17_ = _loc17_.replace(_loc3_,"&lt;");
                        _loc17_ = _loc17_.replace(_loc4_,"&gt;");
                        if(_loc17_)
                        {
                           _loc1_.push({
                              "label":_loc17_,
                              "cssClass":_loc11_
                           });
                        }
                        _loc13_++;
                     }
                  }
               }
               if(this._item.targetConditions)
               {
                  for each(_loc19_ in this._item.targetConditions.criteria)
                  {
                     _loc20_ = 0;
                     _loc21_ = "";
                     _loc22_ = _loc19_.isRespected;
                     _loc23_ = "p";
                     for each(_loc24_ in _loc19_.inlineCriteria)
                     {
                        if(_loc24_.text != "")
                        {
                           if(_loc20_ > 0)
                           {
                              _loc21_ = _loc21_ + (" " + this.uiApi.getText("ui.common.or") + " ");
                           }
                           _loc21_ = _loc21_ + _loc24_.text;
                           _loc20_++;
                        }
                     }
                     _loc21_ = _loc21_.replace(_loc3_,"&lt;");
                     _loc21_ = _loc21_.replace(_loc4_,"&gt;");
                     if(_loc21_)
                     {
                        _loc1_.push({
                           "label":"(" + this.uiApi.getText("ui.item.target") + ") " + _loc21_,
                           "cssClass":_loc23_
                        });
                     }
                  }
               }
               break;
            case 2:
               _loc5_ = this._item as WeaponWrapper;
               _loc6_ = this.uiApi.getText("ui.stats.shortAP") + this.uiApi.getText("ui.common.colon") + _loc5_.apCost;
               if(_loc5_.maxCastPerTurn)
               {
                  _loc6_ = _loc6_ + (" (" + this.uiApi.processText(this.uiApi.getText("ui.item.usePerTurn",_loc5_.maxCastPerTurn),"n",_loc5_.maxCastPerTurn <= 1) + ")");
               }
               _loc1_.push(_loc6_);
               if(_loc5_.range == _loc5_.minRange)
               {
                  _loc7_ = String(_loc5_.range);
               }
               else
               {
                  _loc7_ = _loc5_.minRange + " - " + _loc5_.range;
               }
               _loc1_.push(this.uiApi.getText("ui.common.range") + this.uiApi.getText("ui.common.colon") + _loc7_);
               if(_loc5_.criticalFailureProbability || _loc5_.criticalHitProbability)
               {
                  _loc25_ = "";
                  if(_loc5_.criticalHitProbability)
                  {
                     if(_loc5_.criticalHitBonus > 0)
                     {
                        _loc26_ = "+";
                     }
                     else if(_loc5_.criticalHitBonus < 0)
                     {
                        _loc26_ = "-";
                     }
                     if(_loc26_)
                     {
                        _loc1_.push(this.uiApi.getText("ui.item.critical.bonus",_loc5_.criticalHitBonus));
                     }
                     _loc25_ = _loc25_ + (this.uiApi.getText("ui.common.short.CriticalHit") + this.uiApi.getText("ui.common.colon") + _loc5_.criticalHitProbability + "%");
                     if(this.playerApi.characteristics() != null)
                     {
                        _loc27_ = this.playerApi.characteristics().criticalHit;
                        _loc28_ = this.playerApi.characteristics().agility;
                        _loc29_ = _loc27_.alignGiftBonus + _loc27_.base + _loc27_.contextModif + _loc27_.objectsAndMountBonus;
                        _loc30_ = _loc28_.alignGiftBonus + _loc28_.base + _loc28_.additionnal + _loc28_.contextModif + _loc28_.objectsAndMountBonus;
                        if(_loc30_ < 0)
                        {
                           _loc30_ = 0;
                        }
                        _loc31_ = 55 - _loc5_.criticalHitProbability - _loc29_;
                        if(_loc31_ > 54)
                        {
                           _loc31_ = 54;
                        }
                        _loc32_ = 55 - 1 / (1 / _loc31_);
                        if(_loc32_ > 100)
                        {
                           _loc32_ = 100;
                        }
                        _loc1_.push(this.uiApi.getText("ui.itemtooltip.itemCriticalReal",_loc32_ + "%"));
                     }
                  }
                  _loc1_.push(_loc25_);
               }
               if(_loc5_.castInLine && _loc5_.range > 1)
               {
                  _loc1_.push(this.uiApi.getText("ui.spellInfo.castInLine"));
               }
               if(!_loc5_.castTestLos && _loc5_.range > 1)
               {
                  _loc1_.push(this.uiApi.getText("ui.spellInfo.castWithoutLos"));
               }
         }
         var _loc2_:int = this.gd_lines.verticalScrollValue;
         this.gd_lines.dataProvider = _loc1_;
         if(this._sameItem)
         {
            this.gd_lines.moveTo(_loc2_,true);
         }
      }
      
      public function updateLine(param1:*, param2:*, param3:Boolean) : void
      {
         if(param1)
         {
            if(param1 is String)
            {
               param2.lbl_text.text = param1;
               param2.lbl_text.cssClass = "p";
            }
            else
            {
               param2.lbl_text.text = param1.label;
               param2.lbl_text.cssClass = param1.cssClass;
            }
            param2.tx_picto.visible = false;
         }
         else
         {
            param2.lbl_text.text = "";
            param2.tx_picto.visible = false;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         switch(param1)
         {
            case this.btn_info:
               if(this._item && this._item != MountWrapper)
               {
                  _loc2_ = this.menuApi.create(this._item,null,[{"ownedItem":this._ownedItem},this.uiApi.me()["name"]]);
                  if(_loc2_.content.length > 0)
                  {
                     this.modContextMenu.createContextMenu(_loc2_);
                  }
               }
               break;
            case this.btn_effects:
               this._currentTab = 0;
               this.updateGrid();
               break;
            case this.btn_conditions:
               this._currentTab = 1;
               this.updateGrid();
               break;
            case this.btn_caracteristics:
               this._currentTab = 2;
               this.updateGrid();
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         switch(param1)
         {
            case this.tx_etherealGauge:
               _loc2_ = this._etherealRes;
               break;
            case this.tx_2hands:
               _loc2_ = this.uiApi.getText("ui.common.twoHandsWeapon");
               break;
            case this.tx_mimicry:
               _loc2_ = this.uiApi.getText("ui.mimicry.itemTooltip");
         }
         if(_loc2_)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onTextureLoadFailed(param1:Object, param2:Boolean) : void
      {
         if(param1 == this.tx_item)
         {
            this.tx_item.uri = this._item.fullSizeErrorIconUri;
         }
      }
      
      public function onTextureReady(param1:Object) : void
      {
         var _loc2_:Rectangle = param1.child.getBounds(param1 as DisplayObject);
         if(_loc2_.x != 0 && _loc2_.y != 0)
         {
            param1.x = _itemIconX - _loc2_.x * (param1.width / _loc2_.width);
            param1.y = _itemIconY - _loc2_.y * (param1.height / _loc2_.height);
         }
         else
         {
            param1.x = _itemIconX;
            param1.y = _itemIconY;
         }
         param1.visible = true;
      }
      
      public function onItemSelected(param1:Object, param2:Boolean = false) : void
      {
         this._showTheoretical = param2;
         this.updateItem(param1);
      }
      
      public function onObjectModified(param1:Object) : void
      {
         if(this._item.objectUID == param1.objectUID)
         {
            this.updateItem(param1);
         }
      }
      
      public function onMapComplementaryInformationsData(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Item = null;
         if(this._subareaId != param2)
         {
            if(this._item)
            {
               _loc4_ = this.dataApi.getItem(this._item.objectGID);
               if(_loc4_.favoriteSubAreas && _loc4_.favoriteSubAreas.length > 0)
               {
                  this.updateGrid();
               }
            }
         }
         this._subareaId = param2;
      }
      
      public function showEffect(param1:Array) : void
      {
         var _loc2_:Object = null;
         var _loc3_:EffectInstance = null;
         var _loc4_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Object = null;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         var _loc15_:int = 0;
         var _loc16_:Object = null;
         var _loc17_:Boolean = false;
         var _loc18_:Object = null;
         var _loc5_:Boolean = false;
         if(this._item.typeId == 178)
         {
            _loc14_ = this.dataApi.getIdolByItemId(this._item.objectGID);
            param1.push({
               "label":"{spellPair," + _loc14_.spellPairId + "::[" + _loc14_.spellPair.name + "]}",
               "cssClass":"p"
            });
         }
         if(!this._showTheoretical && (this._item.effects && this._item.effects.length > 0 || this._item.possibleEffects && this._item.possibleEffects.length > 0))
         {
            if(this._item.effects && this._item.effects.length > 0)
            {
               _loc2_ = this._item.effects;
            }
            else if(this._item.objectUID == 0)
            {
               _loc2_ = this._item.possibleEffects;
               _loc5_ = true;
            }
            _loc4_ = new Array();
            for each(_loc3_ in _loc2_)
            {
               _loc4_.push(_loc3_);
            }
            _loc2_ = this._item.favoriteEffect;
            for each(_loc3_ in _loc2_)
            {
               _loc4_.push(_loc3_);
            }
            _loc2_ = _loc4_;
         }
         else if(this._showTheoretical || this._item.objectUID == 0 && this._item.category == 0)
         {
            if(!this._item.hideEffects)
            {
               _loc2_ = this._item.possibleEffects;
               _loc5_ = true;
            }
            else
            {
               param1.push({
                  "label":this.uiApi.getText("ui.set.secretBonus"),
                  "cssClass":"p"
               });
               return;
            }
         }
         else
         {
            _loc2_ = this._item.effects;
            _loc4_ = new Array();
            for each(_loc3_ in _loc2_)
            {
               _loc4_.push(_loc3_);
            }
            _loc2_ = this._item.favoriteEffect;
            for each(_loc3_ in _loc2_)
            {
               _loc4_.push(_loc3_);
            }
            _loc2_ = _loc4_;
         }
         _loc2_.sortOn("order",Array.NUMERIC);
         var _loc6_:Array = new Array();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.category != -1)
            {
               if(_loc3_.effectId != 812)
               {
                  _loc15_ = _loc3_.category;
                  if(!_loc3_.showInSet)
                  {
                     _loc15_ = 3;
                  }
                  if(!_loc6_[_loc15_])
                  {
                     _loc6_[_loc15_] = new Array();
                  }
                  _loc6_[_loc15_].push({
                     "effect":_loc3_,
                     "cat":_loc15_
                  });
               }
            }
         }
         _loc7_ = new Array();
         for each(_loc8_ in _loc6_[2])
         {
            _loc10_ = _loc8_.effect.description;
            if(!(!_loc10_ || _loc10_.length == 0))
            {
               _loc9_ = "p";
               param1.push({
                  "label":_loc10_,
                  "cssClass":_loc9_
               });
            }
         }
         if(_loc6_[0] && _loc6_[1])
         {
            _loc7_ = _loc7_.concat(_loc6_[0],_loc6_[1]);
         }
         else if(_loc6_[0] || _loc6_[1])
         {
            _loc7_ = _loc7_.concat(!!_loc6_[0]?_loc6_[0]:_loc6_[1]);
         }
         if(_loc6_[3])
         {
            _loc7_ = _loc7_.concat(_loc6_[3]);
         }
         var _loc11_:Array = new Array();
         for each(_loc12_ in _loc7_)
         {
            if(_loc5_)
            {
               _loc10_ = _loc12_.effect.theoreticalDescription;
            }
            else
            {
               _loc10_ = _loc12_.effect.description;
            }
            if(!(!_loc10_ || _loc10_.length == 0))
            {
               if(_loc12_.effect.bonusType == -1)
               {
                  _loc9_ = "malus";
               }
               else if(_loc12_.effect.bonusType == 1)
               {
                  _loc9_ = "bonus";
               }
               else
               {
                  _loc9_ = "p";
               }
               _loc16_ = this.dataApi.getItem(this._item.id);
               if(!this._item.hideEffects && _loc12_.effect.showInSet && this._item.enhanceable)
               {
                  _loc17_ = true;
                  for each(_loc18_ in _loc16_.possibleEffects)
                  {
                     if(_loc12_.effect.effectId == _loc18_.effectId)
                     {
                        _loc17_ = false;
                     }
                  }
                  if(_loc17_)
                  {
                     _loc9_ = "exotic";
                     param1.push({
                        "label":_loc10_,
                        "cssClass":_loc9_
                     });
                     continue;
                  }
               }
               _loc11_.push({
                  "label":_loc10_,
                  "cssClass":_loc9_
               });
            }
         }
         for each(_loc13_ in _loc11_)
         {
            param1.push(_loc13_);
         }
      }
   }
}
