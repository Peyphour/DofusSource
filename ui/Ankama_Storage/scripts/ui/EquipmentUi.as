package ui
{
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.datacenter.livingObjects.Pet;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.MountWrapper;
   import com.ankamagames.dofus.internalDatacenter.items.ShortcutWrapper;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import com.ankamagames.dofusModuleLibrary.enum.interfaces.tooltip.LocationEnum;
   import d2actions.DeleteObject;
   import d2actions.MountToggleRidingRequest;
   import d2actions.ObjectSetPosition;
   import d2actions.ObjectUse;
   import d2actions.OpenBook;
   import d2actions.OpenIdols;
   import d2enums.CharacterInventoryPositionEnum;
   import d2enums.ComponentHookList;
   import d2enums.SelectMethodEnum;
   import d2hooks.DropEnd;
   import d2hooks.DropStart;
   import d2hooks.EquipmentObjectMove;
   import d2hooks.MountRiding;
   import d2hooks.MountSet;
   import d2hooks.ObjectModified;
   import d2hooks.PlayedCharacterLookChange;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import ui.behavior.StorageClassicBehavior;
   
   public class EquipmentUi extends StorageUi
   {
       
      
      private var _slotCollection:Array;
      
      private var _availableEquipmentPositions:Array;
      
      private var _currentCharacterDirection:int = 2;
      
      private var _currentEquipmentItemsByPos:Array;
      
      private var _delayUseObject:Boolean = false;
      
      private var _delayUseObjectTimer:Timer;
      
      private var _delayDoubleClickTimer:Timer;
      
      private var _itemWaitingForPopupDisplay:Object;
      
      private var _itemWaitingForPopupDisplayQty:uint;
      
      private var _slotClickedNoDragAllowed:Slot;
      
      private var _popupName:String;
      
      private var _selectedItem:ItemWrapper;
      
      public var tx_breedSymbol:Texture;
      
      public var tx_cross:Texture;
      
      public var btn_leftArrow:ButtonContainer;
      
      public var btn_rightArrow:ButtonContainer;
      
      public var slot_0:Slot;
      
      public var slot_15:Slot;
      
      public var slot_4:Slot;
      
      public var slot_3:Slot;
      
      public var slot_5:Slot;
      
      public var slot_28:Slot;
      
      public var slot_6:Slot;
      
      public var slot_1:Slot;
      
      public var slot_2:Slot;
      
      public var slot_7:Slot;
      
      public var slot_30:Slot;
      
      public var slot_8:Slot;
      
      public var slot_9:Slot;
      
      public var slot_10:Slot;
      
      public var slot_11:Slot;
      
      public var slot_12:Slot;
      
      public var slot_13:Slot;
      
      public var slot_14:Slot;
      
      public var slot_default:Slot;
      
      public var entityDisplayer:EntityDisplayer;
      
      public var btn_idols:ButtonContainer;
      
      public var ctr_equipment:GraphicContainer;
      
      public var ctr_preset:GraphicContainer;
      
      public function EquipmentUi()
      {
         super();
      }
      
      override public function main(param1:Object) : void
      {
         super.main(param1);
         this._currentEquipmentItemsByPos = new Array();
         soundApi.playSound(SoundTypeEnum.CHARACTER_SHEET_OPEN);
         sysApi.addHook(DropStart,this.onEquipementDropStart);
         sysApi.addHook(DropEnd,this.onEquipementDropEnd);
         sysApi.addHook(PlayedCharacterLookChange,this.updateLook);
         sysApi.addHook(EquipmentObjectMove,this.onEquipmentObjectMove);
         sysApi.addHook(ObjectModified,this.onObjectModified);
         sysApi.addHook(MountRiding,this.onMountRiding);
         sysApi.addHook(MountSet,this.onMountSet);
         uiApi.addComponentHook(btnSet,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(btnSet,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.btn_idols,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.btn_idols,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.btn_idols,ComponentHookList.ON_ROLL_OUT);
         uiApi.addShortcutHook("closeUi",onShortCut);
         presetVisible = true;
         this.equipementSlotInit();
         var _loc2_:Object = playerApi.getPlayedCharacterInfo();
         this.tx_breedSymbol.uri = uiApi.createUri(uiApi.me().getConstant("breedIllus") + _loc2_.breed.toString() + ".png");
         var _loc3_:Object = storageApi.getViewContent("equipment");
         this.fillEquipement(_loc3_);
         this._delayUseObjectTimer = new Timer(500,1);
         this._delayUseObjectTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayUseObjectTimer);
         this._delayDoubleClickTimer = new Timer(500,1);
         this._delayDoubleClickTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayDoubleClickTimer);
         this._currentCharacterDirection = 1;
         var _loc4_:Object = utilApi.getRealTiphonEntityLook(_loc2_.id,true);
         if(_loc4_.getBone() == 2)
         {
            _loc4_.setBone(1);
         }
         this.updateLook(_loc4_);
      }
      
      override public function unload() : void
      {
         this._delayDoubleClickTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onDelayDoubleClickTimer);
         this._delayDoubleClickTimer = null;
         uiApi.unloadUi("itemBox");
         uiApi.unloadUi(this._popupName);
         uiApi.unloadUi("quantityPopup");
         uiApi.unloadUi("preset");
         super.unload();
      }
      
      private function presetVisibleUpdate() : void
      {
         if(!this.ctr_preset.visible)
         {
         }
      }
      
      private function wheelChara(param1:int) : void
      {
         this._currentCharacterDirection = (this._currentCharacterDirection + param1 + 8) % 8;
         this.entityDisplayer.direction = this._currentCharacterDirection;
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case btnAll:
            case btnEquipable:
            case btnConsumables:
            case btnRessources:
            case btnQuest:
               this.ctr_preset.visible = false;
               this.presetVisibleUpdate();
               break;
            case btnSet:
               this.ctr_preset.visible = true;
               if(!uiApi.getUi("preset"))
               {
                  uiApi.loadUiInside("preset",this.ctr_preset,"preset");
               }
               this.presetVisibleUpdate();
               break;
            case this.btn_idols:
               if(!uiApi.getUi("idolsTab"))
               {
                  sysApi.sendAction(new OpenIdols());
               }
               else
               {
                  sysApi.sendAction(new OpenBook("idolsTab"));
               }
               break;
            case this.btn_leftArrow:
               this.wheelChara(1);
               break;
            case this.btn_rightArrow:
               this.wheelChara(-1);
         }
         super.onRelease(param1);
      }
      
      override public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(param2 != SelectMethodEnum.AUTO)
         {
            switch(param1)
            {
               case cb_category:
                  super.onSelectItem(param1,param2,param3);
               default:
                  if(param2 == SelectMethodEnum.DOUBLE_CLICK)
                  {
                     if(_storageBehavior)
                     {
                        Api.ui.hideTooltip();
                        if(!this._delayDoubleClickTimer.running)
                        {
                           (_storageBehavior as StorageClassicBehavior).doubleClickGridItem(grid.selectedItem);
                           if(grid != null)
                           {
                              this.blockDragDropOnSlot(grid.selectedSlot as Slot);
                           }
                        }
                     }
                  }
                  return;
            }
         }
      }
      
      override protected function displayItemTooltip(param1:Object, param2:Object, param3:Object = null) : void
      {
         if(!param3)
         {
            param3 = new Object();
         }
         super.displayItemTooltip(param1,param2,param3);
      }
      
      override public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = {
            "point":LocationEnum.POINT_BOTTOM,
            "relativePoint":LocationEnum.POINT_TOP
         };
         if(param1 is Slot && param1.data)
         {
            if(param1.data is MountWrapper)
            {
               uiApi.showTooltip(param1.data,param1,false,"standard",LocationEnum.POINT_BOTTOMRIGHT,LocationEnum.POINT_TOPLEFT,0,"itemName",null,{
                  "noBg":false,
                  "uiName":uiApi.me().name
               },"ItemInfo");
               return;
            }
            this.displayItemTooltip(param1,param1.data);
            return;
         }
         if(!_loc2_)
         {
            switch(param1)
            {
               case btnSet:
                  _loc2_ = uiApi.getText("ui.common.presets");
                  break;
               case this.btn_idols:
                  _loc2_ = uiApi.getText("ui.shortcuts.openIdols");
                  break;
               case this.slot_0:
                  _loc2_ = uiApi.getText("ui.common.inventoryType1");
                  break;
               case this.slot_15:
                  if(this.tx_cross.visible)
                  {
                     _loc2_ = uiApi.getText("ui.common.inventoryTwoHandsWarning");
                  }
                  else
                  {
                     _loc2_ = uiApi.getText("ui.common.inventoryType7");
                  }
                  break;
               case this.slot_4:
               case this.slot_2:
                  _loc2_ = uiApi.getText("ui.common.inventoryType3");
                  break;
               case this.slot_3:
                  _loc2_ = uiApi.getText("ui.common.inventoryType4");
                  break;
               case this.slot_5:
                  _loc2_ = uiApi.getText("ui.common.inventoryType5");
                  break;
               case this.slot_28:
                  _loc2_ = uiApi.getText("ui.common.inventoryType23");
                  break;
               case this.slot_6:
                  _loc2_ = uiApi.getText("ui.common.inventoryType10");
                  break;
               case this.slot_1:
                  _loc2_ = uiApi.getText("ui.common.inventoryType2");
                  break;
               case this.slot_7:
                  _loc2_ = uiApi.getText("ui.common.inventoryType11");
                  break;
               case this.slot_8:
                  _loc2_ = uiApi.getText("ui.common.inventoryType8");
                  break;
               case this.slot_30:
                  _loc2_ = uiApi.getText("ui.common.inventoryType25");
                  break;
               case this.slot_14:
               case this.slot_13:
               case this.slot_12:
               case this.slot_11:
               case this.slot_10:
               case this.slot_9:
                  _loc2_ = uiApi.getText("ui.common.inventoryType13");
                  break;
               default:
                  super.onRollOver(param1);
                  return;
            }
         }
         if(_loc2_)
         {
            uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",_loc3_.point,_loc3_.relativePoint,3,null,null,null,"TextInfo");
         }
      }
      
      override protected function fillContextMenu(param1:Array, param2:Object, param3:Boolean) : void
      {
         if(param2)
         {
            if(param2.usable && param2.quantity > 1 && param2.isOkForMultiUse)
            {
               param1.unshift(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.common.multipleUse"),this.useItemQuantity,[param2],param3));
            }
            if(param2.usable)
            {
               param1.unshift(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.common.use"),this.useItem,[param2],param3));
            }
            if(param2.targetable && !param2.nonUsableOnAnother)
            {
               param1.unshift(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.common.target"),this.useItemOnCell,[param2],param3));
            }
            if(param2.isEquipment)
            {
               param1.unshift(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.common.equip"),this.equipItem,[param2],param3));
            }
         }
         super.fillContextMenu(param1,param2,param3);
         if(param2)
         {
            param1.push(modContextMenu.createContextMenuSeparatorObject());
            param1.push(modContextMenu.createContextMenuItemObject(uiApi.getText("ui.common.destroyThisItem"),this.askDeleteItem,[param2],param3 || !param2.isDestructible));
         }
      }
      
      private function dropValidatorFunction(param1:Object, param2:Object, param3:Object) : Boolean
      {
         var _loc7_:uint = 0;
         var _loc8_:Pet = null;
         var _loc9_:EffectInstance = null;
         var _loc4_:Number = Number(param1.name.split("slot_")[1]);
         if(param1 == this.slot_default)
         {
            return true;
         }
         if(param1.data && param1.data.type.superTypeId == 12)
         {
            if(param2 && param2.type && param2.type.superTypeId == 24)
            {
               return false;
            }
            if(param2 && param2.type && param2.type.superTypeId == 12)
            {
               return true;
            }
            _loc8_ = dataApi.getPet(param1.data.objectGID);
            if(_loc8_ && (_loc8_.foodTypes.indexOf(param2.typeId) != -1 || _loc8_.foodItems.indexOf(param2.objectGID) != -1))
            {
               return true;
            }
            for each(_loc9_ in param2.effects)
            {
               if(_loc9_.effectId == 1005 || _loc9_.effectId == 1006)
               {
                  return true;
               }
               if(_loc9_.effectId == 939 && _loc9_.parameter2 == param1.data.objectGID)
               {
                  return true;
               }
            }
         }
         var _loc5_:int = this.getItemSuperType(param2);
         if(_loc5_ == 0)
         {
            return false;
         }
         var _loc6_:Object = storageApi.itemSuperTypeToServerPosition(_loc5_);
         for each(_loc7_ in _loc6_)
         {
            if(_loc7_ == _loc4_)
            {
               return true;
            }
         }
         return false;
      }
      
      private function processDropFunction(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:Number = NaN;
         if(param1 == this.slot_default)
         {
            (_storageBehavior as StorageClassicBehavior).doubleClickGridItem(param2);
            return;
         }
         if(this.dropValidatorFunction(param1,param2,param3))
         {
            _loc4_ = Number(param1.name.split("slot_")[1]);
            sysApi.sendAction(new ObjectSetPosition(param2.objectUID,_loc4_,1));
         }
      }
      
      public function onDoubleClick(param1:Object) : void
      {
         var _loc2_:uint = 0;
         if(param1 is Slot && param1.data && !this._delayDoubleClickTimer.running)
         {
            this.blockDragDropOnSlot(param1 as Slot);
            _loc2_ = uint(param1.name.split("slot_")[1]);
            if(_loc2_ == CharacterInventoryPositionEnum.ACCESSORY_POSITION_PETS && param1.data.objectUID == 0 && param1.data.hasOwnProperty("mountId"))
            {
               sysApi.sendAction(new MountToggleRidingRequest());
            }
            else
            {
               sysApi.sendAction(new ObjectSetPosition(param1.data.objectUID,63,1));
            }
         }
      }
      
      private function blockDragDropOnSlot(param1:Slot) : void
      {
         this._slotClickedNoDragAllowed = param1;
         if(this._slotClickedNoDragAllowed != null)
         {
            this._slotClickedNoDragAllowed.allowDrag = false;
            this._delayDoubleClickTimer.start();
         }
      }
      
      private function onDelayDoubleClickTimer(param1:TimerEvent) : void
      {
         this._delayDoubleClickTimer.stop();
         if(this._slotClickedNoDragAllowed != null)
         {
            this._slotClickedNoDragAllowed.allowDrag = true;
            this._slotClickedNoDragAllowed = null;
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         if(param1 is Slot && param1.data)
         {
            _loc2_ = param1.data;
            _loc4_ = Number(param1.name.split("slot_")[1]);
            if(_loc4_ == CharacterInventoryPositionEnum.ACCESSORY_POSITION_PETS && _loc2_.objectUID == 0 && _loc2_.hasOwnProperty("mountId"))
            {
               _loc3_ = menuApi.create(_loc2_,"mount");
            }
            else
            {
               _loc3_ = menuApi.create(_loc2_,"item",[{"ownedItem":true}]);
            }
            if(_loc3_.content.length > 0)
            {
               modContextMenu.createContextMenu(_loc3_);
            }
         }
      }
      
      private function onEquipementDropStart(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(!param1.data || !(param1.data is ItemWrapper))
         {
            return;
         }
         if(param1.getUi() == uiApi.me())
         {
            sysApi.disableWorldInteraction();
         }
         for each(_loc2_ in this._slotCollection)
         {
            if(this.dropValidatorFunction(_loc2_,param1.data,null))
            {
               _loc2_.selected = true;
            }
         }
      }
      
      private function onEquipementDropEnd(param1:Object) : void
      {
         var _loc2_:Object = null;
         if(param1.getUi() == uiApi.me())
         {
            sysApi.enableWorldInteraction();
         }
         for each(_loc2_ in this._slotCollection)
         {
            _loc2_.selected = false;
         }
      }
      
      public function onObjectModified(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         if(this._availableEquipmentPositions.indexOf(param1.position) != -1)
         {
            this._currentEquipmentItemsByPos[param1.position] = param1;
            for each(_loc2_ in this._slotCollection)
            {
               _loc3_ = uint(_loc2_.name.split("_")[1]);
               _loc2_.data = this._currentEquipmentItemsByPos[_loc3_];
            }
         }
      }
      
      public function onEquipmentObjectMove(param1:Object, param2:int) : void
      {
         if(param2 != -1 && (!this._slotCollection[param2] || !this._slotCollection[param2].data))
         {
            return;
         }
         if(param2 != -1 && this._availableEquipmentPositions.indexOf(param2) != -1 && (!param1 || !this._slotCollection[param2].data || param1.objectUID == this._slotCollection[param2].data.objectUID))
         {
            this._slotCollection[param2].data = null;
            this._currentEquipmentItemsByPos[param2] = null;
         }
         if(!param1 && param2 == 1)
         {
            this.tx_cross.visible = false;
            this.slot_15.alpha = 1;
            return;
         }
         if(!param1 || this._availableEquipmentPositions.indexOf(param1.position) == -1)
         {
            return;
         }
         if(param1.position == CharacterInventoryPositionEnum.ACCESSORY_POSITION_PETS && playerApi.isRidding())
         {
            this._slotCollection[param1.position].data = storageApi.getFakeItemMount();
            this._currentEquipmentItemsByPos[param1.position] = storageApi.getFakeItemMount();
         }
         else
         {
            this._slotCollection[param1.position].data = param1;
            this._currentEquipmentItemsByPos[param1.position] = param1;
         }
         if(param1.position == CharacterInventoryPositionEnum.ACCESSORY_POSITION_WEAPON)
         {
            if(param1.twoHanded)
            {
               this.tx_cross.visible = true;
               this.tx_cross.alpha = 0.5;
            }
            else
            {
               this.tx_cross.visible = false;
               this.tx_cross.alpha = 1;
            }
         }
      }
      
      public function onMountRiding(param1:Boolean) : void
      {
         var _loc2_:MountWrapper = null;
         if(param1)
         {
            _loc2_ = storageApi.getFakeItemMount();
            this._slotCollection[CharacterInventoryPositionEnum.ACCESSORY_POSITION_PETS].data = _loc2_;
            this._currentEquipmentItemsByPos[CharacterInventoryPositionEnum.ACCESSORY_POSITION_PETS] = _loc2_;
         }
         else
         {
            this._slotCollection[CharacterInventoryPositionEnum.ACCESSORY_POSITION_PETS].data = null;
            this._currentEquipmentItemsByPos[CharacterInventoryPositionEnum.ACCESSORY_POSITION_PETS] = null;
         }
      }
      
      public function onMountSet() : void
      {
         var _loc1_:MountWrapper = storageApi.getFakeItemMount();
         this._slotCollection[CharacterInventoryPositionEnum.ACCESSORY_POSITION_PETS].data = _loc1_;
         this._currentEquipmentItemsByPos[CharacterInventoryPositionEnum.ACCESSORY_POSITION_PETS] = _loc1_;
      }
      
      public function useItem(param1:Object) : void
      {
         if(!param1.usable && param1.targetable)
         {
            sysApi.sendAction(new ObjectUse(param1.objectUID,1,true));
            uiApi.unloadUi(uiApi.me().name);
         }
         else if(!this._delayUseObject)
         {
            this._delayUseObjectTimer.start();
            sysApi.sendAction(new ObjectUse(param1.objectUID,1,false));
         }
      }
      
      public function useItemQuantity(param1:Object) : void
      {
         if(!this._delayUseObject)
         {
            this._itemWaitingForPopupDisplay = param1;
            modCommon.openQuantityPopup(1,param1.quantity,1,this.onValidItemQuantityUse);
         }
      }
      
      public function onValidItemQuantityUse(param1:Number) : void
      {
         sysApi.sendAction(new ObjectUse(this._itemWaitingForPopupDisplay.objectUID,param1,false));
         this._itemWaitingForPopupDisplay = null;
      }
      
      public function equipItem(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:Object = storageApi.itemSuperTypeToServerPosition(param1.type.superTypeId);
         if(_loc2_ && _loc2_.length)
         {
            _loc3_ = storageApi.getViewContent("equipment");
            _loc4_ = -1;
            for each(_loc5_ in _loc2_)
            {
               if(!_loc3_[_loc5_])
               {
                  _loc4_ = _loc5_;
                  break;
               }
            }
            if(_loc4_ == -1)
            {
               _loc4_ = _loc2_[0];
            }
            sysApi.sendAction(new ObjectSetPosition(param1.objectUID,_loc4_,1));
         }
      }
      
      public function useItemOnCell(param1:Object) : void
      {
         sysApi.sendAction(new ObjectUse(param1.objectUID,1,true));
         uiApi.unloadUi(uiApi.me().name);
      }
      
      public function askDeleteItem(param1:Object) : void
      {
         this._itemWaitingForPopupDisplay = param1;
         if(param1.quantity == 1)
         {
            this.askDeleteConfirm(1);
         }
         else
         {
            modCommon.openQuantityPopup(1,param1.quantity,param1.quantity,this.askDeleteConfirm);
         }
      }
      
      private function equipementSlotInit() : void
      {
         var _loc1_:Slot = null;
         this._slotCollection = new Array();
         this._availableEquipmentPositions = new Array();
         this._slotCollection[0] = this.slot_0;
         this._slotCollection[1] = this.slot_1;
         this._slotCollection[2] = this.slot_2;
         this._slotCollection[3] = this.slot_3;
         this._slotCollection[4] = this.slot_4;
         this._slotCollection[5] = this.slot_5;
         this._slotCollection[6] = this.slot_6;
         this._slotCollection[7] = this.slot_7;
         this._slotCollection[8] = this.slot_8;
         this._slotCollection[9] = this.slot_9;
         this._slotCollection[10] = this.slot_10;
         this._slotCollection[11] = this.slot_11;
         this._slotCollection[12] = this.slot_12;
         this._slotCollection[13] = this.slot_13;
         this._slotCollection[14] = this.slot_14;
         this._slotCollection[15] = this.slot_15;
         this._slotCollection[28] = this.slot_28;
         this._slotCollection[30] = this.slot_30;
         this.slot_default.dropValidator = this.dropValidatorFunction as Function;
         this.slot_default.processDrop = this.processDropFunction as Function;
         for each(_loc1_ in this._slotCollection)
         {
            _loc1_.dropValidator = this.dropValidatorFunction as Function;
            _loc1_.processDrop = this.processDropFunction as Function;
            uiApi.addComponentHook(_loc1_,ComponentHookList.ON_ROLL_OVER);
            uiApi.addComponentHook(_loc1_,ComponentHookList.ON_ROLL_OUT);
            uiApi.addComponentHook(_loc1_,ComponentHookList.ON_DOUBLE_CLICK);
            uiApi.addComponentHook(_loc1_,ComponentHookList.ON_RIGHT_CLICK);
            uiApi.addComponentHook(_loc1_,ComponentHookList.ON_RELEASE);
            this._availableEquipmentPositions.push(int(_loc1_.name.split("_")[1]));
         }
      }
      
      private function getItemSuperType(param1:Object) : int
      {
         var _loc2_:int = 0;
         var _loc3_:ItemType = null;
         if(param1 && (param1.isLivingObject || param1.isWrapperObject))
         {
            _loc2_ = 0;
            if(param1.isLivingObject)
            {
               _loc2_ = param1.livingObjectCategory;
            }
            else
            {
               _loc2_ = param1.wrapperObjectCategory;
            }
            _loc3_ = dataApi.getItemType(_loc2_);
            if(_loc3_)
            {
               return _loc3_.superTypeId;
            }
            return 0;
         }
         if(param1 is ItemWrapper && param1.type != null)
         {
            return (param1 as ItemWrapper).type.superTypeId;
         }
         if(param1 is ShortcutWrapper)
         {
            if((param1 as ShortcutWrapper).type == 0)
            {
               return (param1 as ShortcutWrapper).realItem.type.superTypeId;
            }
         }
         return 0;
      }
      
      private function updateLook(param1:Object) : void
      {
         var _loc2_:Object = utilApi.getRealTiphonEntityLook(playerApi.getPlayedCharacterInfo().id,true);
         if(_loc2_.getBone() == 2)
         {
            _loc2_.setBone(1);
         }
         this.entityDisplayer.direction = this._currentCharacterDirection;
         this.entityDisplayer.look = _loc2_;
      }
      
      private function fillEquipement(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Slot = null;
         var _loc4_:uint = 0;
         this._currentEquipmentItemsByPos = new Array();
         for each(_loc2_ in param1)
         {
            if(_loc2_)
            {
               this._currentEquipmentItemsByPos[_loc2_.position] = _loc2_;
            }
         }
         if((!this._currentEquipmentItemsByPos[CharacterInventoryPositionEnum.ACCESSORY_POSITION_PETS] || this._currentEquipmentItemsByPos[CharacterInventoryPositionEnum.ACCESSORY_POSITION_PETS] == null) && playerApi.isRidding())
         {
            this._currentEquipmentItemsByPos[CharacterInventoryPositionEnum.ACCESSORY_POSITION_PETS] = storageApi.getFakeItemMount();
         }
         if(this._currentEquipmentItemsByPos[CharacterInventoryPositionEnum.ACCESSORY_POSITION_WEAPON] && this._currentEquipmentItemsByPos[CharacterInventoryPositionEnum.ACCESSORY_POSITION_WEAPON].twoHanded)
         {
            this.tx_cross.visible = true;
            this.tx_cross.alpha = 0.5;
         }
         for each(_loc3_ in this._slotCollection)
         {
            _loc4_ = uint(_loc3_.name.split("_")[1]);
            _loc3_.data = this._currentEquipmentItemsByPos[_loc4_];
         }
      }
      
      private function onDelayUseObjectTimer(param1:TimerEvent) : void
      {
         this._delayUseObject = false;
      }
      
      private function askDeleteConfirm(param1:uint) : void
      {
         this._itemWaitingForPopupDisplayQty = param1;
         this._popupName = modCommon.openPopup(uiApi.getText("ui.common.delete.item"),uiApi.getText("ui.common.doYouDestroy",param1,this._itemWaitingForPopupDisplay.name),[uiApi.getText("ui.common.ok"),uiApi.getText("ui.common.cancel")],[this.deleteItem,this.emptyFct],this.deleteItem);
      }
      
      private function deleteItem() : void
      {
         sysApi.sendAction(new DeleteObject(this._itemWaitingForPopupDisplay.objectUID,this._itemWaitingForPopupDisplayQty));
      }
      
      private function goToKrosmasterUi() : void
      {
         sysApi.sendAction(new OpenBook("krosmasterTab"));
      }
      
      private function emptyFct(... rest) : void
      {
      }
   }
}
