package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.TextArea;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceDice;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceInteger;
   import com.ankamagames.dofus.datacenter.effects.instances.EffectInstanceMinMax;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.SocialApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.CloseInventory;
   import d2actions.DisplayContextualMenu;
   import d2actions.ExchangeObjectMove;
   import d2actions.ExchangeReady;
   import d2actions.ExchangeReplay;
   import d2actions.ExchangeReplayStop;
   import d2actions.LeaveDialogRequest;
   import d2enums.ComponentHookList;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.DoubleClickItemInventory;
   import d2hooks.DropEnd;
   import d2hooks.DropStart;
   import d2hooks.ExchangeCraftResult;
   import d2hooks.ExchangeItemAutoCraftStoped;
   import d2hooks.ExchangeLeave;
   import d2hooks.ExchangeObjectAdded;
   import d2hooks.ExchangeObjectModified;
   import d2hooks.ExchangeObjectRemoved;
   import d2hooks.ItemMagedResult;
   import d2hooks.MouseAltDoubleClick;
   import d2hooks.MouseCtrlDoubleClick;
   import d2hooks.ObjectDeleted;
   import d2hooks.ObjectQuantity;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.text.AntiAliasType;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class SmithMagic
   {
      
      public static const TOOLTIP_SMITH_MAGIC:String = "tooltipSmithMagic";
      
      public static const CRAFT_IMPOSSIBLE:int = 0;
      
      public static const CRAFT_FAILED:int = 1;
      
      public static const CRAFT_SUCCESS:int = 2;
      
      public static const CRAFT_NEARLY_SUCCESS:int = 3;
      
      private static const SMITHMAGIC_RUNE_ID:int = 78;
      
      private static const SMITHMAGIC_POTION_ID:int = 26;
      
      private static const SMITHMAGIC_ORB_ID:int = 189;
      
      private static const SIGNATURE_RUNE_ID:int = 7508;
      
      private static const SKILL_TYPE_AMULET:int = 169;
      
      private static const SKILL_TYPE_RING:int = 168;
      
      private static const SKILL_TYPE_BELT:int = 164;
      
      private static const SKILL_TYPE_BOOTS:int = 163;
      
      private static const SKILL_TYPE_HAT:int = 166;
      
      private static const SKILL_TYPE_CLOAK:int = 165;
      
      private static const SKILL_TYPE_BAG:int = 167;
      
      private static const EFFECT_DURABILITY:int = 812;
      
      protected static const ICON_CT:ColorTransform = new ColorTransform(1,1,1,0.3,179,179,177);
      
      protected static const DEFAULT_CT:ColorTransform = new ColorTransform();
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var socialApi:SocialApi;
      
      public var dataApi:DataApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var jobsApi:JobsApi;
      
      public var menuApi:ContextMenuApi;
      
      public var soundApi:SoundApi;
      
      public var storageApi:StorageApi;
      
      public var inventoryApi:InventoryApi;
      
      public var utilApi:UtilApi;
      
      protected var _skill:Object;
      
      protected var _job;
      
      protected var _skillLevel:int;
      
      protected var _itemToMage:Object;
      
      protected var _itemEffects:Array;
      
      protected var _newItem:Boolean;
      
      protected var _effectsDeltas:Object;
      
      protected var _refill_item:Object = null;
      
      protected var _refill_qty:int;
      
      protected var _lastScrollbarValue:int;
      
      protected var _waitingObject:Object;
      
      protected var _waitingSlot:Object;
      
      protected var _altClickedSlot:Object;
      
      protected var _bagSlotTexture:Object;
      
      protected var _multiCraft:Boolean;
      
      protected var _runesFromInventoryByEffectId:Array;
      
      protected var _effectIdForRunesUpdate:int = -1;
      
      protected var _runeTypeUpdate:int = -1;
      
      protected var _keepScrollbar:Boolean;
      
      private var _mergeButtonTimer:Timer;
      
      private var _mergeButtonTimerOut:Boolean;
      
      private var _mergeResultGot:Boolean;
      
      protected var _moveRequestedItemUid:int;
      
      public var ed_rightCharacter:EntityDisplayer;
      
      public var lbl_job:Label;
      
      public var gd_itemEffects:Grid;
      
      public var lbl_title:Label;
      
      public var texta_log:TextArea;
      
      public var slot_item:Slot;
      
      public var slot_rune:Slot;
      
      public var slot_sign:Slot;
      
      public var tx_slot_sign:Texture;
      
      public var btn_mergeAll:ButtonContainer;
      
      public var btn_lbl_btn_mergeAll:Label;
      
      public var btn_mergeOnce:ButtonContainer;
      
      public var btn_close:ButtonContainer;
      
      protected var timer:int;
      
      public function SmithMagic()
      {
         this._itemEffects = new Array();
         this._runesFromInventoryByEffectId = new Array();
         this.timer = getTimer();
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc2_:Slot = null;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         this.btn_mergeAll.soundId = SoundEnum.OK_BUTTON;
         this.btn_mergeOnce.soundId = SoundEnum.OK_BUTTON;
         this.sysApi.disableWorldInteraction();
         this.sysApi.addHook(d2hooks.JobLevelUp,this.onJobLevelUp);
         this.sysApi.addHook(ExchangeObjectModified,this.onExchangeObjectModified);
         this.sysApi.addHook(ExchangeObjectAdded,this.onExchangeObjectAdded);
         this.sysApi.addHook(ExchangeObjectRemoved,this.onExchangeObjectRemoved);
         this.sysApi.addHook(ExchangeLeave,this.onExchangeLeave);
         this.sysApi.addHook(DropStart,this.onDropStart);
         this.sysApi.addHook(DropEnd,this.onDropEnd);
         this.sysApi.addHook(ExchangeCraftResult,this.onExchangeCraftResult);
         this.sysApi.addHook(ExchangeItemAutoCraftStoped,this.onExchangeItemAutoCraftStoped);
         this.sysApi.addHook(ItemMagedResult,this.onItemMagedResult);
         this.sysApi.addHook(DoubleClickItemInventory,this.onDoubleClickItemInventory);
         this.sysApi.addHook(MouseCtrlDoubleClick,this.onMouseCtrlDoubleClick);
         this.sysApi.addHook(MouseAltDoubleClick,this.onMouseAltDoubleClick);
         this.sysApi.addHook(ObjectDeleted,this.onObjectDeleted);
         this.sysApi.addHook(ObjectQuantity,this.onObjectQuantity);
         this.uiApi.addComponentHook(this.ed_rightCharacter,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ed_rightCharacter,ComponentHookList.ON_RIGHT_CLICK);
         this.texta_log.antialias = AntiAliasType.ADVANCED;
         this._bagSlotTexture = this.uiApi.createUri(this.uiApi.me().getConstant("bagSlot_uri"));
         this._skill = this.jobsApi.getSkillFromId(param1.skillId);
         this._job = this._skill.parentJob;
         if(param1.crafterInfos && param1.crafterInfos.id != this.playerApi.id())
         {
            this._skillLevel = param1.crafterInfos.skillLevel;
         }
         else
         {
            _loc4_ = this.jobsApi.getJobExperience(this._job.id);
            this._skillLevel = _loc4_.currentLevel;
         }
         this.lbl_title.text = this._skill.name;
         this.setMergeButtonDisabled(true);
         this.slot_item.emptyTexture = this.uiApi.createUri(this.uiApi.me().getConstant(this.pictoNameFromSkillId(this._skill.id)));
         this.slot_item.iconColorTransform = ICON_CT;
         this.slot_rune.emptyTexture = this.uiApi.createUri(this.uiApi.me().getConstant("rune_slot_uri"));
         this.slot_rune.iconColorTransform = ICON_CT;
         if(this._skillLevel < ProtocolConstantsEnum.MAX_JOB_LEVEL)
         {
            _loc5_ = this.uiApi.getColor(this.sysApi.getConfigEntry("colors.smithmagic.fail"));
            this.tx_slot_sign.colorTransform = new ColorTransform(1,1,1,1,_loc5_.red,_loc5_.green,_loc5_.blue);
            this.slot_sign.highlightTexture = null;
         }
         this.slot_sign.emptyTexture = this.uiApi.createUri(this.uiApi.me().getConstant("signature_slot_uri"));
         this.slot_sign.iconColorTransform = ICON_CT;
         this.slot_item.refresh();
         this.slot_rune.refresh();
         this.slot_sign.refresh();
         for each(_loc2_ in [this.slot_item,this.slot_rune,this.slot_sign])
         {
            _loc2_.dropValidator = this.dropValidatorFunction as Function;
            _loc2_.processDrop = this.processDropFunction as Function;
            this.uiApi.addComponentHook(_loc2_,"onRollOver");
            this.uiApi.addComponentHook(_loc2_,"onRollOut");
            this.uiApi.addComponentHook(_loc2_,"onDoubleClick");
            this.uiApi.addComponentHook(_loc2_,"onRightClick");
            this.uiApi.addComponentHook(_loc2_,"onRelease");
         }
         this.ed_rightCharacter.direction = 3;
         this.ed_rightCharacter.look = this.playerApi.getPlayedCharacterInfo().entityLook;
         this.lbl_job.text = this._job.name + " " + this.uiApi.getText("ui.common.short.level") + " " + this._skillLevel;
         this._mergeButtonTimer = new Timer(400,1);
         this._mergeButtonTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onMergeButtonTimer);
         this._mergeButtonTimerOut = false;
         this._mergeResultGot = false;
         this.gd_itemEffects.dataProvider = new Array();
         _loc3_ = Job.getInstance().mageLog;
         if(_loc3_ && _loc3_.length)
         {
            for each(_loc6_ in _loc3_)
            {
               this.texta_log.appendText(_loc6_.text,_loc6_.cssClass);
            }
         }
         this.texta_log.scrollV = this.texta_log.maxScrollV;
         this.getRunesFromInventory();
      }
      
      public function unload() : void
      {
         this.sysApi.enableWorldInteraction();
         this._mergeButtonTimer.stop();
         this._mergeButtonTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onMergeButtonTimer);
         this.uiApi.unloadUi("itemBoxSmith");
         this.storageApi.removeAllItemMasks("smithMagic");
         this.storageApi.releaseHooks();
         this.sysApi.sendAction(new LeaveDialogRequest());
         this.sysApi.sendAction(new CloseInventory());
      }
      
      public function get skill() : Object
      {
         return this._skill;
      }
      
      public function updateEffectLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         if(param1)
         {
            if(!param1.effect)
            {
               param2.lbl_effect.cssClass = "p4";
            }
            else if(param1.descZero == "")
            {
               param2.lbl_effect.cssClass = "smithmagicexo";
            }
            else if(param1.effect.bonusType == -1)
            {
               param2.lbl_effect.cssClass = "smithmagicfail";
            }
            else if(param1.effect.bonusType == 1)
            {
               param2.lbl_effect.cssClass = "smithmagicsuccess";
            }
            else
            {
               param2.lbl_effect.cssClass = "p";
            }
            if(param1.min == int.MIN_VALUE)
            {
               param2.lbl_min.text = "-";
            }
            else
            {
               param2.lbl_min.text = param1.min;
            }
            if(param1.max == int.MAX_VALUE)
            {
               param2.lbl_max.text = "-";
            }
            else
            {
               param2.lbl_max.text = param1.max;
            }
            if(param1.effect)
            {
               param2.lbl_effect.text = param1.effect.description;
            }
            else
            {
               param2.lbl_effect.text = param1.descZero;
            }
            if(param1.delta > 0)
            {
               param2.lbl_change.text = "+" + param1.delta;
               param2.ctr_effectLine.bgColor = this.sysApi.getConfigEntry("colors.smithmagic.success");
               param2.ctr_effectLine.bgAlpha = 0.8;
            }
            else if(param1.delta < 0)
            {
               param2.lbl_change.text = "" + param1.delta;
               param2.ctr_effectLine.bgColor = this.sysApi.getConfigEntry("colors.smithmagic.fail");
               param2.ctr_effectLine.bgAlpha = 0.8;
            }
            else
            {
               param2.lbl_change.text = "";
               param2.ctr_effectLine.bgAlpha = 0;
            }
            _loc4_ = this.getRunesByEffectId(param1.id);
            if(_loc4_)
            {
               _loc5_ = 0;
               while(_loc5_ < 3)
               {
                  param2["slot_rune" + _loc5_].data = _loc4_[_loc5_].rune;
                  if(_loc4_[_loc5_].rune && _loc4_[_loc5_].fromBag)
                  {
                     param2["slot_rune" + _loc5_].customTexture = this._bagSlotTexture;
                  }
                  else
                  {
                     param2["slot_rune" + _loc5_].customTexture = null;
                  }
                  param2["slot_rune" + _loc5_].dropValidator = this.dropValidatorFunction as Function;
                  param2["slot_rune" + _loc5_].processDrop = this.processDropFunction as Function;
                  this.uiApi.addComponentHook(param2["slot_rune" + _loc5_],"onRollOver");
                  this.uiApi.addComponentHook(param2["slot_rune" + _loc5_],"onRollOut");
                  this.uiApi.addComponentHook(param2["slot_rune" + _loc5_],"onDoubleClick");
                  this.uiApi.addComponentHook(param2["slot_rune" + _loc5_],"onRightClick");
                  this.uiApi.addComponentHook(param2["slot_rune" + _loc5_],"onRelease");
                  _loc5_++;
               }
            }
            else
            {
               if(param2.slot_rune0.data)
               {
                  param2.slot_rune0.data = null;
               }
               if(param2.slot_rune1.data)
               {
                  param2.slot_rune1.data = null;
               }
               if(param2.slot_rune2.data)
               {
                  param2.slot_rune2.data = null;
               }
            }
         }
         else
         {
            param2.lbl_min.text = "";
            param2.lbl_max.text = "";
            param2.lbl_effect.text = "";
            param2.lbl_change.text = "";
            param2.slot_rune0.data = null;
            param2.slot_rune1.data = null;
            param2.slot_rune2.data = null;
            param2.slot_rune0.customTexture = null;
            param2.slot_rune1.customTexture = null;
            param2.slot_rune2.customTexture = null;
            param2.lbl_cheat.text = "";
            param2.ctr_effectLine.bgAlpha = 0;
         }
      }
      
      public function unfillSelectedSlot(param1:int) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in [this.slot_item,this.slot_rune,this.slot_sign])
         {
            if(_loc2_.selected && _loc2_.data)
            {
               this.unfillSlot(this._waitingSlot,param1);
            }
         }
      }
      
      public function fillDefaultSlot(param1:Object, param2:int = -1) : void
      {
         var _loc3_:Object = null;
         for each(_loc3_ in [this.slot_item,this.slot_rune,this.slot_sign])
         {
            if(this.dropValidatorFunction(_loc3_,param1,null))
            {
               if(param2 == -1)
               {
                  switch(_loc3_)
                  {
                     case this.slot_item:
                     case this.slot_sign:
                        param2 = 1;
                        break;
                     case this.slot_rune:
                        param2 = param1.quantity;
                  }
               }
               this.fillSlot(_loc3_,param1,param2);
               return;
            }
         }
      }
      
      public function getMatchingSlot(param1:Object) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in [this.slot_item,this.slot_rune,this.slot_sign])
         {
            if(this.isValidSlot(_loc2_,param1))
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getMatchingSlotFromUID(param1:int) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in [this.slot_item,this.slot_rune,this.slot_sign])
         {
            if(_loc2_.data && _loc2_.data.objectUID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      protected function getRunesFromInventory() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:EffectInstance = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc1_:Object = this.storageApi.getViewContent("storageResources");
         for each(_loc3_ in _loc1_)
         {
            if(_loc3_ && _loc3_.typeId == SMITHMAGIC_RUNE_ID)
            {
               for each(_loc4_ in _loc3_.effects)
               {
                  if(!this._runesFromInventoryByEffectId[_loc4_.effectId])
                  {
                     this._runesFromInventoryByEffectId[_loc4_.effectId] = [{
                        "rune":null,
                        "fromBag":false
                     },{
                        "rune":null,
                        "fromBag":false
                     },{
                        "rune":null,
                        "fromBag":false
                     }];
                  }
                  _loc5_ = 1;
                  _loc6_ = 3;
                  _loc7_ = 10;
                  if(_loc4_.effectId == 174 || _loc4_.effectId == 158)
                  {
                     _loc5_ = 10;
                     _loc6_ = 30;
                     _loc7_ = 100;
                  }
                  else if(_loc4_.effectId == 125)
                  {
                     _loc5_ = 5;
                     _loc6_ = 15;
                     _loc7_ = 50;
                  }
                  _loc2_ = int(_loc4_.parameter0);
                  if(_loc2_ == _loc5_)
                  {
                     this._runesFromInventoryByEffectId[_loc4_.effectId][0].rune = _loc3_;
                  }
                  else if(_loc2_ == _loc6_)
                  {
                     this._runesFromInventoryByEffectId[_loc4_.effectId][1].rune = _loc3_;
                  }
                  else if(_loc2_ == _loc7_)
                  {
                     this._runesFromInventoryByEffectId[_loc4_.effectId][2].rune = _loc3_;
                  }
               }
            }
         }
      }
      
      protected function getRunesByEffectId(param1:int, param2:int = -1) : Object
      {
         if(param2 == -1)
         {
            return this._runesFromInventoryByEffectId[param1];
         }
         return this._runesFromInventoryByEffectId[param1][param2];
      }
      
      protected function getKnownRunes() : Array
      {
         return this._runesFromInventoryByEffectId;
      }
      
      protected function displayItem(param1:Object, param2:Boolean = false) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc9_:EffectInstance = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:Item = null;
         var _loc13_:EffectInstance = null;
         var _loc14_:EffectInstance = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         if(!param1)
         {
            this.gd_itemEffects.dataProvider = new Array();
            this._itemToMage = param1;
            return;
         }
         if(!this._itemToMage || this._itemToMage.objectUID != param1.objectUID)
         {
            this._newItem = true;
            this._effectsDeltas = null;
         }
         if(!this._itemToMage || this._itemToMage.objectGID != param1.objectGID)
         {
            _loc12_ = this.dataApi.getItem(param1.objectGID);
            this._itemEffects = new Array();
            for each(_loc13_ in _loc12_.possibleEffects)
            {
               if(_loc13_)
               {
                  if(!(_loc13_.bonusType == 0 && _loc13_.category != 2))
                  {
                     if(_loc13_.bonusType == -1 && _loc13_.oppositeId != -1)
                     {
                        _loc5_ = _loc13_.oppositeId;
                     }
                     else
                     {
                        _loc5_ = _loc13_.effectId;
                     }
                     _loc14_ = this.dataApi.getNullEffectInstance(_loc13_);
                     _loc3_ = {
                        "id":_loc5_,
                        "min":int.MIN_VALUE,
                        "max":int.MAX_VALUE,
                        "descZero":_loc14_.description,
                        "effect":null,
                        "delta":0
                     };
                     if(_loc13_ is EffectInstanceDice)
                     {
                        _loc3_.min = (_loc13_ as EffectInstanceDice).diceNum;
                        if((_loc13_ as EffectInstanceDice).diceSide == 0)
                        {
                           _loc3_.max = (_loc13_ as EffectInstanceDice).diceNum;
                        }
                        else
                        {
                           _loc3_.max = (_loc13_ as EffectInstanceDice).diceSide;
                        }
                     }
                     else if(_loc13_ is EffectInstanceInteger)
                     {
                        _loc3_.min = (_loc13_ as EffectInstanceInteger).value;
                        _loc3_.max = (_loc13_ as EffectInstanceInteger).value;
                     }
                     else if(_loc13_ is EffectInstanceMinMax)
                     {
                        _loc3_.min = (_loc13_ as EffectInstanceMinMax).min;
                        _loc3_.max = (_loc13_ as EffectInstanceMinMax).max;
                     }
                     if(_loc13_.bonusType < 0)
                     {
                        _loc15_ = _loc3_.min;
                        _loc3_.min = -1 * _loc3_.max;
                        _loc3_.max = -1 * _loc15_;
                     }
                     this._itemEffects.push(_loc3_);
                  }
               }
            }
         }
         var _loc6_:Array = new Array();
         var _loc7_:Array = new Array();
         var _loc8_:Array = new Array();
         for each(_loc9_ in param1.effects)
         {
            if(_loc9_.bonusType == -1 && _loc9_.oppositeId != -1)
            {
               _loc5_ = _loc9_.oppositeId;
            }
            else
            {
               _loc5_ = _loc9_.effectId;
            }
            _loc8_.push(_loc5_);
         }
         for each(_loc10_ in this._itemEffects)
         {
            _loc10_.delta = 0;
            for each(_loc9_ in param1.effects)
            {
               if(_loc9_.bonusType == -1 && _loc9_.oppositeId != -1)
               {
                  _loc5_ = _loc9_.oppositeId;
               }
               else
               {
                  _loc5_ = _loc9_.effectId;
               }
               if(_loc9_ && _loc10_.id == _loc5_)
               {
                  _loc6_.push(_loc10_.id);
                  _loc10_.effect = _loc9_;
                  if(this._effectsDeltas)
                  {
                     _loc10_.delta = 0;
                     for each(_loc4_ in this._effectsDeltas)
                     {
                        if(_loc10_.id == _loc4_.id)
                        {
                           _loc10_.delta = _loc4_.value;
                        }
                     }
                  }
               }
            }
            _loc16_ = _loc8_.indexOf(_loc5_);
            _loc8_.splice(_loc16_,1);
         }
         for each(_loc9_ in param1.effects)
         {
            if(_loc9_.bonusType == -1 && _loc9_.oppositeId != -1)
            {
               _loc5_ = _loc9_.oppositeId;
            }
            else
            {
               _loc5_ = _loc9_.effectId;
            }
            if(_loc9_ && _loc6_.indexOf(_loc5_) == -1)
            {
               if(_loc9_.bonusType == 0 && _loc9_.category != 2)
               {
                  continue;
               }
               _loc3_ = {
                  "id":_loc5_,
                  "min":int.MIN_VALUE,
                  "max":int.MAX_VALUE,
                  "descZero":"",
                  "effect":_loc9_,
                  "delta":0
               };
               if(_loc5_ == this._effectIdForRunesUpdate)
               {
                  this._runeTypeUpdate = -1;
               }
               if(this._effectsDeltas)
               {
                  for each(_loc4_ in this._effectsDeltas)
                  {
                     if(_loc3_.id == _loc4_.id)
                     {
                        _loc3_.delta = _loc4_.value;
                     }
                  }
               }
               else
               {
                  _loc3_.delta = 0;
               }
               this._itemEffects.push(_loc3_);
            }
            _loc7_.push(_loc5_);
         }
         _loc11_ = 0;
         _loc11_ = this._itemEffects.length - 1;
         while(_loc11_ >= 0)
         {
            if(this._itemEffects[_loc11_] && _loc7_.indexOf(this._itemEffects[_loc11_].id) == -1)
            {
               if(this._itemEffects[_loc11_].descZero == "")
               {
                  this._itemEffects.splice(_loc11_,1);
               }
               else
               {
                  this._itemEffects[_loc11_].effect = null;
                  if(this._effectsDeltas)
                  {
                     for each(_loc4_ in this._effectsDeltas)
                     {
                        if(this._itemEffects[_loc11_].id == _loc4_.id)
                        {
                           this._itemEffects[_loc11_].delta = _loc4_.value;
                        }
                     }
                  }
                  else
                  {
                     this._itemEffects[_loc11_].delta = 0;
                  }
               }
            }
            _loc11_--;
         }
         this.gd_itemEffects.dataProvider = this._itemEffects;
         this._itemToMage = param1;
      }
      
      protected function dropValidatorFunction(param1:Object, param2:Object, param3:Object) : Boolean
      {
         return this.isValidSlot(param1,param2);
      }
      
      protected function isValidSlot(param1:Object, param2:Object) : Boolean
      {
         if(!this._skill)
         {
            return false;
         }
         switch(param1)
         {
            case this.slot_item:
               if(this._skill.modifiableItemTypeIds.indexOf(param2.typeId) == -1)
               {
                  return false;
               }
               return true;
            case this.slot_rune:
               if((!this._skill.isForgemagus || param2.typeId != SMITHMAGIC_RUNE_ID) && param2.typeId != SMITHMAGIC_POTION_ID && param2.typeId != SMITHMAGIC_ORB_ID)
               {
                  return false;
               }
               return true;
            case this.slot_sign:
               if(param2.objectGID != SIGNATURE_RUNE_ID)
               {
                  return false;
               }
               return true;
            default:
               return false;
         }
      }
      
      protected function processDropFunction(param1:Object, param2:Object, param3:Object) : void
      {
         if(this.dropValidatorFunction(param1,param2,param3))
         {
            switch(param1)
            {
               case this.slot_item:
               case this.slot_sign:
                  this.fillSlot(param1,param2,1);
                  break;
               case this.slot_rune:
                  if(param2.info1 > 1)
                  {
                     this._waitingObject = param2;
                     this.modCommon.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQtyDropToSlot);
                  }
                  else
                  {
                     this.fillSlot(this.slot_rune,param2,1);
                  }
            }
         }
      }
      
      protected function fillSlot(param1:Object, param2:Object, param3:int) : void
      {
         if(param1.data != null && (param1 == this.slot_item || param1 == this.slot_sign || param1 == this.slot_rune && param1.data.objectGID != param2.objectGID))
         {
            this.unfillSlot(param1,-1);
            this._refill_item = param2;
            this._refill_qty = param3;
         }
         else
         {
            this._moveRequestedItemUid = param2.objectUID;
            this.sysApi.sendAction(new ExchangeObjectMove(param2.objectUID,param3));
         }
      }
      
      protected function unfillSlot(param1:Object, param2:int = -1) : void
      {
         if(param2 == -1)
         {
            param2 = param1.data.quantity;
         }
         this._moveRequestedItemUid = param1.data.objectUID;
         this.sysApi.sendAction(new ExchangeObjectMove(param1.data.objectUID,-param2));
      }
      
      protected function setMergeButtonDisabled(param1:Boolean) : void
      {
         if(this._mergeButtonTimer)
         {
            this._mergeButtonTimer.stop();
         }
         if(!param1 && (!this.slot_item.data || !this.slot_rune.data))
         {
            param1 = true;
         }
         this.btn_mergeOnce.disabled = param1;
         if(this._multiCraft)
         {
            this.btn_lbl_btn_mergeAll.text = this.uiApi.getText("ui.common.stop");
            this.btn_mergeAll.disabled = false;
         }
         else
         {
            this.btn_lbl_btn_mergeAll.text = this.uiApi.getText("ui.common.mergeAll");
            this.btn_mergeAll.disabled = param1;
         }
      }
      
      protected function addLogLine(param1:String, param2:String) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         this.texta_log.appendText(param1,param2);
         Job.getInstance().addToMageLog({
            "text":param1,
            "cssClass":param2
         });
         if(Job.getInstance().mageLog.length > 100)
         {
            _loc4_ = this.texta_log.htmlText;
            _loc5_ = _loc4_.indexOf("</TEXTFORMAT>") + 13;
            this.texta_log.htmlText = _loc4_.substr(_loc5_);
            Job.getInstance().removeMageLogFirstLine();
         }
      }
      
      protected function pictoNameFromSkillId(param1:int) : String
      {
         switch(param1)
         {
            case SKILL_TYPE_AMULET:
               return "amulet_slot_uri";
            case SKILL_TYPE_RING:
               return "ring_slot_uri";
            case SKILL_TYPE_BELT:
               return "belt_slot_uri";
            case SKILL_TYPE_BOOTS:
               return "boots_slot_uri";
            case SKILL_TYPE_HAT:
               return "helmet_slot_uri";
            case SKILL_TYPE_CLOAK:
            case SKILL_TYPE_BAG:
               return "cloak_slot_uri";
            default:
               return "weapon_slot_uri";
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_mergeAll:
               this._multiCraft = !this._multiCraft;
               if(this._multiCraft)
               {
                  this.setMergeButtonDisabled(true);
                  this.sysApi.sendAction(new ExchangeReplay(-1));
                  this.sysApi.sendAction(new ExchangeReady(true));
               }
               else
               {
                  this.sysApi.sendAction(new ExchangeReplayStop());
               }
               break;
            case this.btn_mergeOnce:
               this._multiCraft = false;
               this.setMergeButtonDisabled(true);
               this._mergeButtonTimer.start();
               this._mergeButtonTimerOut = false;
               this._mergeResultGot = false;
               this.sysApi.sendAction(new ExchangeReady(true));
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.ed_rightCharacter:
               this.sysApi.sendAction(new DisplayContextualMenu(this.playerApi.id()));
         }
      }
      
      public function onDoubleClick(param1:Object) : void
      {
         if(param1.data && !this.uiApi.keyIsDown(Keyboard.CONTROL) && !this.uiApi.keyIsDown(15))
         {
            if(param1 == this.slot_item || param1 == this.slot_rune || param1 == this.slot_sign)
            {
               this.unfillSlot(param1,1);
            }
            else
            {
               this.sysApi.dispatchHook(DoubleClickItemInventory,param1.data,1);
            }
         }
      }
      
      public function onMouseCtrlDoubleClick(param1:Object) : void
      {
         var _loc2_:ItemWrapper = null;
         var _loc3_:uint = 0;
         if(param1.data && (this.uiApi.keyIsDown(Keyboard.CONTROL) || this.uiApi.keyIsDown(15)))
         {
            if(param1 == this.slot_item || param1 == this.slot_rune || param1 == this.slot_sign)
            {
               this.unfillSlot(param1,-1);
            }
            else
            {
               _loc2_ = this.inventoryApi.getItem(param1.data.objectUID);
               if(_loc2_)
               {
                  _loc3_ = 0;
                  if(this.slot_rune.data && this.isValidSlot(this.slot_rune,_loc2_) && this.slot_rune.data.objectGID == _loc2_.objectGID)
                  {
                     _loc3_ = this.slot_rune.data.quantity;
                  }
                  this.sysApi.dispatchHook(DoubleClickItemInventory,param1.data,_loc2_.quantity - _loc3_);
               }
               else
               {
                  this.sysApi.dispatchHook(DoubleClickItemInventory,param1.data,param1.data.quantity);
               }
            }
         }
      }
      
      public function onMouseAltDoubleClick(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         if(param1.data)
         {
            _loc2_ = false;
            if(param1 == this.slot_item || param1 == this.slot_rune || param1 == this.slot_sign)
            {
               _loc2_ = true;
            }
            if(!_loc2_)
            {
               return;
            }
            this._altClickedSlot = param1;
            this.modCommon.openQuantityPopup(1,param1.data.quantity,param1.data.quantity,this.onValidQty);
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(param1 == this.slot_item)
         {
            _loc2_ = "";
            for each(_loc3_ in this._skill.modifiableItemTypeIds)
            {
               _loc2_ = _loc2_ + (this.dataApi.getItemType(_loc3_).name + "/");
            }
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_.substr(0,_loc2_.length - 1)),param1,false,"standard",1,7,3,null,null,null,"TextInfo");
         }
         else if(param1 == this.slot_rune)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this.dataApi.getItemType(78).name),param1,false,"standard",1,7,3,null,null,null,"TextInfo");
         }
         else if(param1 == this.slot_sign)
         {
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(this._skillLevel < ProtocolConstantsEnum.MAX_JOB_LEVEL?this.uiApi.getText("ui.craft.jobLevelLowForSignatureClient"):this.dataApi.getItem(7508).name),param1,false,"standard",1,7,3,null,null,null,"TextInfo");
         }
         else if(param1.data)
         {
            this.uiApi.showTooltip(param1.data,param1,false,"standard",0,0,0,"itemName",null,{
               "showEffects":true,
               "header":true
            },"ItemInfo");
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1 == this.ed_rightCharacter)
         {
            this.sysApi.sendAction(new DisplayContextualMenu(this.playerApi.id()));
         }
         else if(param1.data)
         {
            _loc2_ = param1.data;
            _loc3_ = this.menuApi.create(_loc2_);
            if(_loc3_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc3_);
            }
         }
      }
      
      private function onDropStart(param1:Object) : void
      {
         var _loc2_:Object = null;
         this._waitingSlot = param1;
         for each(_loc2_ in [this.slot_item,this.slot_rune,this.slot_sign])
         {
            if(this.dropValidatorFunction(_loc2_,param1.data,null))
            {
               _loc2_.selected = true;
            }
         }
      }
      
      private function onDropEnd(param1:Object) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in [this.slot_item,this.slot_rune,this.slot_sign])
         {
            _loc2_.selected = false;
         }
      }
      
      protected function onExchangeObjectModified(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = this.getMatchingSlot(param1);
         this.storageApi.addItemMask(param1.objectUID,"smithMagic",param1.quantity);
         this.storageApi.releaseHooks();
         var _loc4_:int = !!_loc3_.data?int(_loc3_.data.quantity):0;
         _loc3_.data = param1;
         switch(_loc3_)
         {
            case this.slot_item:
               this.displayItem(param1,true);
         }
         this._moveRequestedItemUid = 0;
      }
      
      protected function onExchangeObjectAdded(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = this.getMatchingSlot(param1);
         if(_loc3_.data && _loc3_.data.objectUID != param1.objectUID)
         {
            this.storageApi.removeItemMask(_loc3_.data.objectUID,"smithMagic");
         }
         _loc3_.colorTransform = DEFAULT_CT;
         _loc3_.iconColorTransform = DEFAULT_CT;
         _loc3_.data = param1;
         this.storageApi.addItemMask(param1.objectUID,"smithMagic",param1.quantity);
         this.storageApi.releaseHooks();
         this.soundApi.playSound(SoundTypeEnum.SWITCH_RIGHT_TO_LEFT);
         switch(_loc3_)
         {
            case this.slot_item:
               this.displayItem(param1,false);
         }
         if(this.slot_item.data && this.slot_rune.data)
         {
            this.setMergeButtonDisabled(false);
         }
         this._moveRequestedItemUid = 0;
      }
      
      protected function onExchangeObjectRemoved(param1:int, param2:Boolean) : void
      {
         this.storageApi.removeItemMask(param1,"smithMagic");
         this.storageApi.releaseHooks();
         var _loc3_:Object = this.getMatchingSlotFromUID(param1);
         if(_loc3_)
         {
            _loc3_.iconColorTransform = ICON_CT;
            _loc3_.data = null;
            if(_loc3_ == this.slot_item)
            {
               this.displayItem(null,false);
            }
            this.soundApi.playSound(SoundTypeEnum.SWITCH_LEFT_TO_RIGHT);
            if(this._refill_item != null)
            {
               this.fillSlot(_loc3_,this._refill_item,this._refill_qty);
               this._refill_item = null;
            }
            if(this.slot_item.data == null || this.slot_rune.data == null)
            {
               this.setMergeButtonDisabled(true);
            }
         }
         this._moveRequestedItemUid = 0;
      }
      
      protected function onObjectDeleted(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:* = null;
         var _loc4_:int = 0;
         if(param1 && param1.typeId == SMITHMAGIC_RUNE_ID && param1.objectUID != this._moveRequestedItemUid)
         {
            _loc2_ = this.getKnownRunes();
            for(_loc3_ in _loc2_)
            {
               _loc4_ = int(_loc3_);
               if(this.getRunesByEffectId(_loc4_,0) && this.getRunesByEffectId(_loc4_,0).rune && this.getRunesByEffectId(_loc4_,0).rune.objectUID == param1.objectUID)
               {
                  this.getRunesByEffectId(_loc4_,0).rune = null;
                  this._effectIdForRunesUpdate = _loc4_;
                  this._runeTypeUpdate = 0;
                  break;
               }
               if(this.getRunesByEffectId(_loc4_,1) && this.getRunesByEffectId(_loc4_,1).rune && this.getRunesByEffectId(_loc4_,1).rune.objectUID == param1.objectUID)
               {
                  this.getRunesByEffectId(_loc4_,1).rune = null;
                  this._effectIdForRunesUpdate = int(_loc4_);
                  this._runeTypeUpdate = 1;
                  break;
               }
               if(this.getRunesByEffectId(_loc4_,2) && this.getRunesByEffectId(_loc4_,2).rune && this.getRunesByEffectId(_loc4_,2).rune.objectUID == param1.objectUID)
               {
                  this.getRunesByEffectId(_loc4_,2).rune = null;
                  this._effectIdForRunesUpdate = int(_loc4_);
                  this._runeTypeUpdate = 2;
                  break;
               }
            }
         }
      }
      
      protected function onObjectQuantity(param1:ItemWrapper, param2:int, param3:int) : void
      {
         var _loc4_:EffectInstance = null;
         if(param1 && param1.typeId == SMITHMAGIC_RUNE_ID && param1.objectUID != this._moveRequestedItemUid)
         {
            for each(_loc4_ in param1.effects)
            {
               if(this.getRunesByEffectId(_loc4_.effectId))
               {
                  if(this.getRunesByEffectId(_loc4_.effectId,0) && this.getRunesByEffectId(_loc4_.effectId,0).rune != null && this.getRunesByEffectId(_loc4_.effectId,0).rune.objectUID == param1.objectUID)
                  {
                     this.getRunesByEffectId(_loc4_.effectId,0).rune = param1;
                     this._effectIdForRunesUpdate = _loc4_.effectId;
                     this._runeTypeUpdate = 0;
                     return;
                  }
                  if(this.getRunesByEffectId(_loc4_.effectId,1) && this.getRunesByEffectId(_loc4_.effectId,1).rune != null && this.getRunesByEffectId(_loc4_.effectId,1).rune.objectUID == param1.objectUID)
                  {
                     this.getRunesByEffectId(_loc4_.effectId,1).rune = param1;
                     this._effectIdForRunesUpdate = _loc4_.effectId;
                     this._runeTypeUpdate = 1;
                     return;
                  }
                  if(this.getRunesByEffectId(_loc4_.effectId,2) && this.getRunesByEffectId(_loc4_.effectId,2).rune != null && this.getRunesByEffectId(_loc4_.effectId,2).rune.objectUID == param1.objectUID)
                  {
                     this.getRunesByEffectId(_loc4_.effectId,2).rune = param1;
                     this._effectIdForRunesUpdate = _loc4_.effectId;
                     this._runeTypeUpdate = 2;
                     return;
                  }
               }
            }
         }
      }
      
      public function onExchangeCraftResult(param1:int, param2:Object) : void
      {
         switch(param1)
         {
            case CRAFT_IMPOSSIBLE:
               this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.craft.noResult"),[this.uiApi.getText("ui.common.ok")]);
               this.sysApi.sendAction(new ExchangeReady(false));
            case CRAFT_FAILED:
            case CRAFT_SUCCESS:
            case CRAFT_NEARLY_SUCCESS:
               if(param2)
               {
                  if(this.slot_item.data)
                  {
                     this.slot_item.data = this.dataApi.getItemWrapper(param2.objectGID,param2.position,this.slot_item.data.objectUID,param2.quantity,param2.effectsList);
                  }
                  this.displayItem(param2,true);
               }
         }
         if(!this._multiCraft)
         {
            this._mergeResultGot = true;
            if(this._mergeButtonTimerOut)
            {
               this.setMergeButtonDisabled(false);
            }
         }
      }
      
      public function onMergeButtonTimer(param1:TimerEvent) : void
      {
         this._mergeButtonTimerOut = true;
         if(this._mergeResultGot)
         {
            this.setMergeButtonDisabled(false);
         }
      }
      
      public function processDropToInventory(param1:Object, param2:Object, param3:Object) : void
      {
         if(param2.info1 > 1)
         {
            this._waitingObject = param2;
            this.modCommon.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQtyDropToInventory);
         }
         else
         {
            this.unfillSelectedSlot(1);
         }
      }
      
      public function onDoubleClickItemInventory(param1:Object, param2:int = 1) : void
      {
         if(param1.id == SIGNATURE_RUNE_ID || param1.id == SMITHMAGIC_RUNE_ID)
         {
            param2 = 1;
         }
         this.fillDefaultSlot(param1,param2);
      }
      
      private function onJobLevelUp(param1:uint, param2:String, param3:uint) : void
      {
         if(param1 == this._job.id)
         {
            this.lbl_job.text = this._job.name + " " + this.uiApi.getText("ui.common.short.level") + " " + param3;
         }
      }
      
      public function onExchangeItemAutoCraftStoped(param1:int) : void
      {
         this.btn_mergeAll.soundId = SoundEnum.OK_BUTTON;
         this._multiCraft = false;
         this.setMergeButtonDisabled(false);
      }
      
      public function onItemMagedResult(param1:Boolean, param2:String, param3:Object) : void
      {
         var _loc4_:String = "normal";
         if(this._newItem && this._itemToMage)
         {
            this.addLogLine(this._itemToMage.name,_loc4_);
            this._newItem = false;
         }
         if(param1)
         {
            _loc4_ = "success";
         }
         else
         {
            _loc4_ = "fail";
         }
         this.addLogLine(param2,_loc4_);
         this.texta_log.scrollV = this.texta_log.maxScrollV;
         this._effectsDeltas = param3;
      }
      
      public function onExchangeLeave(param1:Boolean) : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      public function getIsAvailableItem(param1:Object) : Boolean
      {
         if(!this.dataApi)
         {
            return true;
         }
         return this.getMatchingSlot(param1) != null;
      }
      
      private function onValidQty(param1:Number) : void
      {
         this.unfillSlot(this._altClickedSlot,param1);
      }
      
      private function onValidQtyDropToSlot(param1:Number) : void
      {
         this.fillDefaultSlot(this._waitingObject,param1);
      }
      
      protected function onValidQtyDropToInventory(param1:Number) : void
      {
         this.unfillSelectedSlot(param1);
      }
   }
}
