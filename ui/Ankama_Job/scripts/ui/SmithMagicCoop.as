package ui
{
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import d2actions.DisplayContextualMenu;
   import d2actions.ExchangeCraftPaymentModification;
   import d2actions.ExchangeObjectMove;
   import d2actions.ExchangeObjectUseInWorkshop;
   import d2actions.ExchangeReady;
   import d2actions.LeaveDialogRequest;
   import d2enums.ComponentHookList;
   import d2enums.SelectMethodEnum;
   import d2enums.SoundTypeEnum;
   import d2hooks.BagItemAdded;
   import d2hooks.BagItemDeleted;
   import d2hooks.BagItemModified;
   import d2hooks.ExchangeIsReady;
   import d2hooks.PaymentCraftList;
   
   public class SmithMagicCoop extends SmithMagic
   {
      
      public static const TOOLTIP_SMITH_MAGIC:String = "tooltipSmithMagic";
      
      public static const CRAFT_IMPOSSIBLE:int = 0;
      
      public static const CRAFT_FAILED:int = 1;
      
      public static const CRAFT_SUCCESS:int = 2;
      
      private static const SMITHMAGIC_RUNE_ID:int = 78;
      
      private static const SMITHMAGIC_POTION_ID:int = 26;
      
      private static const SMITHMAGIC_ORB_ID:int = 189;
      
      private static const SIGNATURE_RUNE_ID:int = 7508;
       
      
      protected var _isCrafter:Boolean;
      
      protected var _isReady:Boolean;
      
      private var _altClickedItem:Object;
      
      protected var _waitingGrid:Object;
      
      protected var _crafterInfos:Object;
      
      protected var _customerInfos:Object;
      
      protected var _bagItems:Array;
      
      protected var _runesFromBagByEffectId:Array;
      
      protected var _slot_item_owner:Boolean = true;
      
      protected var _slot_rune_owner:Boolean = true;
      
      protected var _slot_sign_owner:Boolean = true;
      
      public var gd_bag:Grid;
      
      public var tx_bgPayment:TextureBitmap;
      
      public var lbl_payment:Label;
      
      public var btn_validBag:ButtonContainer;
      
      public var btn_lbl_btn_validBag:Label;
      
      public var lbl_bagStatus:Label;
      
      public var ed_leftCharacter:EntityDisplayer;
      
      public var ctr_slots:GraphicContainer;
      
      public var ctr_crafterButtons:GraphicContainer;
      
      public var tx_bagBorder:Object;
      
      public var tx_bagBackground:GraphicContainer;
      
      public function SmithMagicCoop()
      {
         this._bagItems = new Array();
         this._runesFromBagByEffectId = new Array();
         super();
      }
      
      public function get isCrafter() : Boolean
      {
         return this._isCrafter;
      }
      
      override public function main(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Object = playerApi.getPlayedCharacterInfo();
         if(param1.crafterInfos.id == _loc2_.id)
         {
            this._isCrafter = true;
         }
         else
         {
            this._isCrafter = false;
         }
         super.main(param1);
         sysApi.addHook(BagItemAdded,this.onBagItemAdded);
         sysApi.addHook(BagItemModified,this.onBagItemModified);
         sysApi.addHook(BagItemDeleted,this.onBagItemDeleted);
         sysApi.addHook(PaymentCraftList,this.onPaymentCraftList);
         sysApi.addHook(ExchangeIsReady,this.onExchangeIsReady);
         uiApi.addComponentHook(this.gd_bag,ComponentHookList.ON_ITEM_RIGHT_CLICK);
         uiApi.addComponentHook(this.gd_bag,ComponentHookList.ON_ITEM_ROLL_OVER);
         uiApi.addComponentHook(this.gd_bag,ComponentHookList.ON_ITEM_ROLL_OUT);
         uiApi.addComponentHook(this.gd_bag,ComponentHookList.ON_SELECT_ITEM);
         uiApi.addComponentHook(this.lbl_payment,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.ed_leftCharacter,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.ed_leftCharacter,ComponentHookList.ON_RIGHT_CLICK);
         uiApi.addComponentHook(this.ed_leftCharacter,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.ed_leftCharacter,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(ed_rightCharacter,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(ed_rightCharacter,ComponentHookList.ON_ROLL_OUT);
         this.ed_leftCharacter.mouseEnabled = true;
         this.ed_leftCharacter.handCursor = true;
         ed_rightCharacter.mouseEnabled = true;
         ed_rightCharacter.handCursor = true;
         if(this._isCrafter)
         {
            this.btn_validBag.visible = false;
            this.lbl_bagStatus.visible = true;
            this.ctr_crafterButtons.visible = true;
            this.tx_bgPayment.disabled = true;
            this.lbl_payment.disabled = true;
            for each(_loc3_ in [slot_item,slot_rune,slot_sign])
            {
               _loc3_.allowDrag = true;
               _loc3_.dropValidator = this.dropValidatorFunction as Function;
               _loc3_.processDrop = this.processDropFunction as Function;
            }
            this.ctr_slots.y = uiApi.me().getConstant("y_slots_crafter");
            this.ctr_slots.x = uiApi.me().getConstant("x_slots");
            uiApi.me().render();
         }
         else
         {
            this.btn_validBag.visible = true;
            this.lbl_bagStatus.visible = false;
            this.btn_validBag.disabled = true;
            this.ctr_crafterButtons.visible = false;
            slot_item.allowDrag = false;
            slot_rune.allowDrag = false;
            slot_sign.allowDrag = false;
            slot_item.highlightTexture = slot_rune.highlightTexture = slot_sign.highlightTexture = null;
            slot_item.selectedTexture = slot_rune.selectedTexture = slot_sign.selectedTexture = null;
            slot_item.acceptDragTexture = slot_rune.acceptDragTexture = slot_sign.acceptDragTexture = null;
            slot_item.refuseDragTexture = slot_rune.refuseDragTexture = slot_sign.refuseDragTexture = null;
            this.ctr_slots.y = uiApi.me().getConstant("y_slots_customer");
            this.ctr_slots.x = uiApi.me().getConstant("x_slots");
            uiApi.me().render();
         }
         this.gd_bag.dataProvider = new Array();
         this.gd_bag.renderer.dropValidatorFunction = this.bagDropValidatorFunction;
         this.gd_bag.renderer.processDropFunction = this.bagProcessDropFunction;
         lbl_job.text = _job.name + " " + uiApi.getText("ui.common.short.level") + " " + _skillLevel;
         this._crafterInfos = param1.crafterInfos;
         this._customerInfos = param1.customerInfos;
         ed_rightCharacter.direction = 3;
         this.ed_leftCharacter.direction = 1;
         if(this._isCrafter)
         {
            ed_rightCharacter.look = this._crafterInfos.look;
            this.ed_leftCharacter.look = this._customerInfos.look;
         }
         else
         {
            ed_rightCharacter.look = this._customerInfos.look;
            this.ed_leftCharacter.look = this._crafterInfos.look;
         }
         this.setIsReady(false);
      }
      
      override public function unload() : void
      {
         super.unload();
         storageApi.removeAllItemMasks("smithMagicBag");
         storageApi.releaseHooks();
      }
      
      override protected function getRunesFromInventory() : void
      {
         if(this._isCrafter && _runesFromInventoryByEffectId.length == 0)
         {
            super.getRunesFromInventory();
         }
      }
      
      override protected function getRunesByEffectId(param1:int, param2:int = -1) : Object
      {
         var _loc3_:Array = null;
         if(param2 == -1)
         {
            _loc3_ = new Array();
            if(!this._runesFromBagByEffectId[param1])
            {
               this._runesFromBagByEffectId[param1] = [{
                  "rune":null,
                  "fromBag":true
               },{
                  "rune":null,
                  "fromBag":true
               },{
                  "rune":null,
                  "fromBag":true
               }];
            }
            if(this._isCrafter && !this._runesFromBagByEffectId[param1][0].rune)
            {
               _loc3_[0] = !!_runesFromInventoryByEffectId[param1]?_runesFromInventoryByEffectId[param1][0]:{
                  "rune":null,
                  "fromBag":false
               };
            }
            else
            {
               _loc3_[0] = this._runesFromBagByEffectId[param1][0];
            }
            if(this._isCrafter && !this._runesFromBagByEffectId[param1][1].rune)
            {
               _loc3_[1] = !!_runesFromInventoryByEffectId[param1]?_runesFromInventoryByEffectId[param1][1]:{
                  "rune":null,
                  "fromBag":false
               };
            }
            else
            {
               _loc3_[1] = this._runesFromBagByEffectId[param1][1];
            }
            if(this._isCrafter && !this._runesFromBagByEffectId[param1][2].rune)
            {
               _loc3_[2] = !!_runesFromInventoryByEffectId[param1]?_runesFromInventoryByEffectId[param1][2]:{
                  "rune":null,
                  "fromBag":false
               };
            }
            else
            {
               _loc3_[2] = this._runesFromBagByEffectId[param1][2];
            }
            return _loc3_;
         }
         if(this._isCrafter && (!this._runesFromBagByEffectId[param1] || !this._runesFromBagByEffectId[param1][param2].rune))
         {
            if(_runesFromInventoryByEffectId[param1])
            {
               return _runesFromInventoryByEffectId[param1][param2];
            }
            return null;
         }
         if(this._runesFromBagByEffectId[param1])
         {
            return this._runesFromBagByEffectId[param1][param2];
         }
         return null;
      }
      
      override protected function getKnownRunes() : Array
      {
         var _loc2_:Object = null;
         var _loc3_:* = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc6_:int = 0;
         if(!this._isCrafter)
         {
            return this._runesFromBagByEffectId;
         }
         var _loc1_:Array = new Array();
         for(_loc3_ in this._runesFromBagByEffectId)
         {
            _loc1_[_loc3_] = [{
               "rune":null,
               "fromBag":true
            },{
               "rune":null,
               "fromBag":true
            },{
               "rune":null,
               "fromBag":true
            }];
            for(_loc5_ in this._runesFromBagByEffectId[_loc3_])
            {
               if(this._runesFromBagByEffectId[_loc3_][_loc5_].rune)
               {
                  _loc1_[_loc3_][_loc5_].rune = this._runesFromBagByEffectId[_loc3_][_loc5_].rune;
               }
            }
         }
         for(_loc4_ in _runesFromInventoryByEffectId)
         {
            _loc6_ = int(_loc4_);
            if(!_loc1_[_loc6_])
            {
               _loc1_[_loc6_] = _runesFromInventoryByEffectId[_loc6_];
            }
            else
            {
               if(!_loc1_[_loc6_][0].rune)
               {
                  _loc1_[_loc6_][0].rune = _runesFromInventoryByEffectId[_loc6_][0].rune;
               }
               if(!_loc1_[_loc6_][1].rune)
               {
                  _loc1_[_loc6_][1].rune = _runesFromInventoryByEffectId[_loc6_][1].rune;
               }
               if(!_loc1_[_loc6_][2].rune)
               {
                  _loc1_[_loc6_][2].rune = _runesFromInventoryByEffectId[_loc6_][2].rune;
               }
            }
         }
         return _loc1_;
      }
      
      private function setIsReady(param1:Boolean) : void
      {
         this._isReady = param1;
         if(this._isReady)
         {
            if(this._isCrafter)
            {
               this.setBagDisabled(false);
               this.lbl_bagStatus.text = uiApi.getText("ui.craft.bagShared");
               this.setSlotsDisabled(false,false);
            }
            else
            {
               this.setBagDisabled(true);
               this.setSlotsDisabled(false,true);
               this.btn_lbl_btn_validBag.text = uiApi.getText("ui.common.stop");
               this.tx_bgPayment.disabled = true;
               this.lbl_payment.disabled = true;
            }
         }
         else if(this._isCrafter)
         {
            this.setBagDisabled(true);
            this.lbl_bagStatus.text = uiApi.getText("ui.craft.bagFilling");
            this.setSlotsDisabled(true,false);
            btn_mergeOnce.disabled = true;
            btn_mergeAll.disabled = true;
         }
         else
         {
            this.setBagDisabled(false);
            this.setSlotsDisabled(true,false);
            this.btn_lbl_btn_validBag.text = uiApi.getText("ui.craft.bagShare");
            this.tx_bgPayment.disabled = false;
            this.lbl_payment.disabled = false;
         }
      }
      
      private function setBagDisabled(param1:Boolean = true) : void
      {
         this.gd_bag.softDisabled = param1;
         this.tx_bagBackground.visible = param1;
      }
      
      private function setSlotsDisabled(param1:Boolean, param2:Boolean) : void
      {
         slot_item.softDisabled = param2;
         if(!param2)
         {
            slot_item.iconColorTransform = ICON_CT;
         }
         slot_rune.softDisabled = param2;
         if(!param2)
         {
            slot_rune.iconColorTransform = ICON_CT;
         }
         slot_sign.softDisabled = param2;
         if(!param2)
         {
            slot_sign.iconColorTransform = ICON_CT;
         }
      }
      
      private function setItemOwner(param1:Object, param2:Boolean) : void
      {
         var _loc3_:Object = null;
         for each(_loc3_ in [slot_item,slot_rune,slot_sign])
         {
            if(this.dropValidatorFunction(_loc3_,param1,null))
            {
               switch(_loc3_)
               {
                  case slot_item:
                     this._slot_item_owner = param2;
                     continue;
                  case slot_rune:
                     this._slot_rune_owner = param2;
                     continue;
                  case slot_sign:
                     this._slot_sign_owner = param2;
                     continue;
                  default:
                     continue;
               }
            }
            else
            {
               continue;
            }
         }
      }
      
      private function isItemOwner(param1:Object) : Boolean
      {
         switch(param1)
         {
            case slot_item:
               return this._slot_item_owner;
            case slot_rune:
               return this._slot_rune_owner;
            case slot_sign:
               return this._slot_sign_owner;
            default:
               return false;
         }
      }
      
      private function isItemFromBag(param1:Object) : ItemWrapper
      {
         var _loc2_:ItemWrapper = null;
         for each(_loc2_ in this._bagItems)
         {
            if(_loc2_ && param1 && _loc2_.objectUID == param1.objectUID)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function fillBag(param1:Object, param2:int) : void
      {
         _moveRequestedItemUid = param1.objectUID;
         sysApi.sendAction(new ExchangeObjectMove(param1.objectUID,param2));
      }
      
      private function unfillBag(param1:Object, param2:int) : void
      {
         _moveRequestedItemUid = param1.objectUID;
         sysApi.sendAction(new ExchangeObjectMove(param1.objectUID,-param2));
      }
      
      private function refreshAcceptButton() : void
      {
         if(this._isReady)
         {
            return;
         }
         if(this.gd_bag.dataProvider.length > 0)
         {
            this.btn_validBag.disabled = false;
         }
         else
         {
            this.btn_validBag.disabled = true;
         }
      }
      
      override protected function fillSlot(param1:Object, param2:Object, param3:int) : void
      {
         if(param1.data != null && (param1 == slot_item || param1 == slot_sign || param1.data.objectGID != param2.objectGID))
         {
            this.unfillSlot(param1,-1);
            _refill_item = param2;
            _refill_qty = param3;
         }
         else
         {
            _moveRequestedItemUid = param2.objectUID;
            if(this.isItemFromBag(param2))
            {
               sysApi.sendAction(new ExchangeObjectUseInWorkshop(param2.objectUID,param3));
            }
            else
            {
               sysApi.sendAction(new ExchangeObjectMove(param2.objectUID,param3));
            }
         }
      }
      
      override protected function unfillSlot(param1:Object, param2:int = -1) : void
      {
         if(!param1.data)
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = param1.data.quantity;
         }
         _moveRequestedItemUid = param1.data.objectUID;
         if(this.isItemOwner(param1))
         {
            sysApi.sendAction(new ExchangeObjectMove(param1.data.objectUID,-param2));
         }
         else
         {
            sysApi.sendAction(new ExchangeObjectUseInWorkshop(param1.data.objectUID,-param2));
         }
      }
      
      override protected function dropValidatorFunction(param1:Object, param2:Object, param3:Object) : Boolean
      {
         var _loc4_:Object = null;
         if(!this._isCrafter)
         {
            return false;
         }
         if(!this._isReady)
         {
            return false;
         }
         if(!this.isItemFromBag(param2))
         {
            _loc4_ = dataApi.getItem(param2.objectGID);
            if(_loc4_.typeId != SMITHMAGIC_POTION_ID && _loc4_.typeId != SMITHMAGIC_ORB_ID && _loc4_.typeId != SMITHMAGIC_RUNE_ID && _loc4_.id != SIGNATURE_RUNE_ID)
            {
               return false;
            }
         }
         return super.dropValidatorFunction(param1,param2,param3);
      }
      
      override protected function processDropFunction(param1:Object, param2:Object, param3:Object) : void
      {
         this.setItemOwner(param2,this.isItemFromBag(param2) == null);
         super.processDropFunction(param1,param2,param3);
      }
      
      override public function processDropToInventory(param1:Object, param2:Object, param3:Object) : void
      {
         if(this._isCrafter)
         {
            super.processDropToInventory(param1,param2,param3);
         }
         else if(param2.info1 > 1)
         {
            _waitingObject = param2;
            modCommon.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQtyDropToInventory);
         }
         else
         {
            this.unfillBag(param2,1);
         }
      }
      
      override protected function onValidQtyDropToInventory(param1:Number) : void
      {
         if(this._isCrafter)
         {
            unfillSelectedSlot(param1);
         }
         else
         {
            this.unfillBag(_waitingObject,param1);
         }
      }
      
      override public function getMatchingSlot(param1:Object) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in [slot_item,slot_rune,slot_sign])
         {
            if(super.isValidSlot(_loc2_,param1))
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function bagDropValidatorFunction(param1:Object, param2:Object, param3:Object) : Boolean
      {
         var _loc4_:Object = null;
         if(param1 && param3 && param1.name.indexOf("gd_bag") != -1 && param3.name.indexOf("gd_bag") != -1)
         {
            return false;
         }
         if(this._isCrafter)
         {
            _loc4_ = this.getMatchingSlot(param2);
            return _loc4_ != null && !this.isItemOwner(_loc4_);
         }
         return isValidSlot(slot_item,param2) || isValidSlot(slot_rune,param2) || isValidSlot(slot_sign,param2);
      }
      
      public function bagProcessDropFunction(param1:Object, param2:Object, param3:Object) : void
      {
         if(!this.bagDropValidatorFunction(param1,param2,param3))
         {
            return;
         }
         if(this._isCrafter)
         {
            if(param2.info1 > 1)
            {
               _waitingObject = this.getMatchingSlot(param2);
               modCommon.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQtySlotToBag);
            }
            else
            {
               this.unfillSlot(this.getMatchingSlot(param2),1);
            }
         }
         else if(param2.info1 > 1)
         {
            _waitingObject = param2;
            modCommon.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQtyInventoryToBag);
         }
         else
         {
            this.fillBag(param2,1);
         }
      }
      
      public function onValidQtyInventoryToBag(param1:int) : void
      {
         this.fillBag(_waitingObject,param1);
      }
      
      public function onValidQtySlotToBag(param1:int) : void
      {
         this.unfillSlot(_waitingObject,param1);
      }
      
      public function onPaymentModifiedCallback(param1:int) : void
      {
         sysApi.sendAction(new ExchangeCraftPaymentModification(param1));
      }
      
      private function onValidQtyBag(param1:Number) : void
      {
         fillDefaultSlot(this._altClickedItem,param1);
      }
      
      override protected function onExchangeObjectRemoved(param1:int, param2:Boolean) : void
      {
         var _loc4_:ItemWrapper = null;
         var _loc5_:Boolean = false;
         var _loc6_:ItemWrapper = null;
         var _loc7_:Boolean = false;
         var _loc8_:ItemWrapper = null;
         var _loc9_:ItemWrapper = null;
         storageApi.removeItemMask(param1,"smithMagic");
         storageApi.releaseHooks();
         var _loc3_:Object = getMatchingSlotFromUID(param1);
         if(_loc3_)
         {
            _loc4_ = _loc3_.data;
            _loc5_ = _loc3_.softDisabled;
            _loc3_.softDisabled = false;
            if(_loc5_)
            {
               _loc3_.softDisabled = _loc5_;
            }
            _loc3_.iconColorTransform = ICON_CT;
            _loc3_.data = null;
            _loc6_ = this.isItemFromBag(_loc4_);
            if(_loc4_ && _loc6_)
            {
               onObjectQuantity(_loc6_,_loc6_.quantity,_loc6_.quantity + _loc4_.quantity);
            }
            if(_loc3_ == slot_item)
            {
               displayItem(null,false);
            }
            else if(_loc3_ == slot_rune)
            {
               _loc7_ = false;
               if(this._isCrafter)
               {
                  _loc8_ = inventoryApi.getItem(_loc4_.objectUID);
                  if(_loc8_ && _loc8_.quantity > 0)
                  {
                     _loc7_ = true;
                  }
               }
               if(!_loc6_ && !_loc7_)
               {
                  _loc9_ = dataApi.getItemWrapper(_loc4_.objectGID,_loc4_.position,_loc4_.objectUID,0,_loc4_.effectsList);
                  onObjectDeleted(_loc9_);
               }
            }
            soundApi.playSound(SoundTypeEnum.SWITCH_LEFT_TO_RIGHT);
            if(_refill_item != null)
            {
               this.fillSlot(_loc3_,_refill_item,_refill_qty);
               _refill_item = null;
            }
            if(slot_item.data == null || slot_rune.data == null)
            {
               setMergeButtonDisabled(true);
            }
         }
         _moveRequestedItemUid = 0;
      }
      
      override protected function onExchangeObjectModified(param1:Object, param2:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:ItemWrapper = null;
         super.onExchangeObjectModified(param1,param2);
         var _loc3_:Object = this.getMatchingSlot(param1);
         if(_loc3_ == slot_rune && !this._slot_rune_owner)
         {
            _loc4_ = 0;
            for each(_loc5_ in this._bagItems)
            {
               if(_loc5_.objectUID == param1.objectUID)
               {
                  _loc4_ = _loc5_.quantity;
               }
            }
            _loc6_ = dataApi.getItemWrapper(param1.objectGID,param1.position,param1.objectUID,param1.quantity + _loc4_,param1.effectsList);
            onObjectQuantity(_loc6_,param1.quantity,0);
         }
      }
      
      public function onBagItemAdded(param1:Object, param2:Boolean) : void
      {
         var _loc3_:EffectInstance = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(!this._isCrafter && !param2)
         {
            storageApi.addItemMask(param1.objectUID,"smithMagicBag",param1.quantity);
            storageApi.releaseHooks();
         }
         this._bagItems.push(param1);
         if(param1.typeId == SMITHMAGIC_RUNE_ID)
         {
            for each(_loc3_ in param1.effects)
            {
               if(!this._runesFromBagByEffectId[_loc3_.effectId])
               {
                  this._runesFromBagByEffectId[_loc3_.effectId] = [{
                     "rune":null,
                     "fromBag":true
                  },{
                     "rune":null,
                     "fromBag":true
                  },{
                     "rune":null,
                     "fromBag":true
                  }];
               }
               _loc4_ = 1;
               _loc5_ = 3;
               _loc6_ = 10;
               if(_loc3_.effectId == 174 || _loc3_.effectId == 158)
               {
                  _loc4_ = 10;
                  _loc5_ = 30;
                  _loc6_ = 100;
               }
               else if(_loc3_.effectId == 125)
               {
                  _loc4_ = 5;
                  _loc5_ = 15;
                  _loc6_ = 50;
               }
               if(int(_loc3_.parameter0) == _loc4_)
               {
                  this._runesFromBagByEffectId[_loc3_.effectId][0].rune = param1;
               }
               else if(int(_loc3_.parameter0) == _loc5_)
               {
                  this._runesFromBagByEffectId[_loc3_.effectId][1].rune = param1;
               }
               else if(int(_loc3_.parameter0) == _loc6_)
               {
                  this._runesFromBagByEffectId[_loc3_.effectId][2].rune = param1;
               }
            }
         }
         this.gd_bag.dataProvider = this._bagItems;
         this.refreshAcceptButton();
      }
      
      public function onBagItemModified(param1:Object, param2:Boolean) : void
      {
         var _loc3_:* = null;
         var _loc4_:EffectInstance = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         for(_loc3_ in this._bagItems)
         {
            if(this._bagItems[_loc3_].objectUID == param1.objectUID)
            {
               this._bagItems.splice(_loc3_,1,param1);
            }
         }
         if(param1.typeId == SMITHMAGIC_RUNE_ID)
         {
            for each(_loc4_ in param1.effects)
            {
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
               if(int(_loc4_.parameter0) == _loc5_)
               {
                  this._runesFromBagByEffectId[_loc4_.effectId][0].rune = param1;
               }
               else if(int(_loc4_.parameter0) == _loc6_)
               {
                  this._runesFromBagByEffectId[_loc4_.effectId][1].rune = param1;
               }
               else if(int(_loc4_.parameter0) == _loc7_)
               {
                  this._runesFromBagByEffectId[_loc4_.effectId][2].rune = param1;
               }
            }
         }
         this.gd_bag.dataProvider = this._bagItems;
         this.refreshAcceptButton();
      }
      
      public function onBagItemDeleted(param1:int, param2:Boolean) : void
      {
         var _loc4_:ItemWrapper = null;
         var _loc5_:EffectInstance = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(!this._isCrafter && !param2)
         {
            storageApi.removeItemMask(param1,"smithMagicBag");
            storageApi.releaseHooks();
         }
         var _loc3_:uint = 0;
         for each(_loc4_ in this._bagItems)
         {
            if(_loc4_.objectUID == param1)
            {
               if(this._isCrafter && param2 || !this._isCrafter && !param2)
               {
                  if(_loc4_.typeId == SMITHMAGIC_RUNE_ID)
                  {
                     for each(_loc5_ in _loc4_.effects)
                     {
                        _loc6_ = 1;
                        _loc7_ = 3;
                        _loc8_ = 10;
                        if(_loc5_.effectId == 174 || _loc5_.effectId == 158)
                        {
                           _loc6_ = 10;
                           _loc7_ = 30;
                           _loc8_ = 100;
                        }
                        else if(_loc5_.effectId == 125)
                        {
                           _loc6_ = 5;
                           _loc7_ = 15;
                           _loc8_ = 50;
                        }
                        if(int(_loc5_.parameter0) == _loc6_)
                        {
                           this._runesFromBagByEffectId[_loc5_.effectId][0].rune = null;
                        }
                        else if(int(_loc5_.parameter0) == _loc7_)
                        {
                           this._runesFromBagByEffectId[_loc5_.effectId][1].rune = null;
                        }
                        else if(int(_loc5_.parameter0) == _loc8_)
                        {
                           this._runesFromBagByEffectId[_loc5_.effectId][2].rune = null;
                        }
                     }
                  }
               }
               this._bagItems.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
         this.gd_bag.dataProvider = this._bagItems;
         this.refreshAcceptButton();
      }
      
      private function onPaymentCraftList(param1:Object, param2:Boolean) : void
      {
         this.lbl_payment.text = utilApi.kamasToString(param1.kamaPayment,"");
      }
      
      public function onExchangeIsReady(param1:String, param2:Boolean) : void
      {
         if(param2 != this._isReady)
         {
            if(!param2 && this._isCrafter)
            {
               addLogLine(uiApi.getText("ui.craft.setNotReadyByClient"),"normal");
            }
            this.setIsReady(param2);
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         switch(param1)
         {
            case this.gd_bag:
               _loc4_ = -1;
               switch(param2)
               {
                  case SelectMethodEnum.CLICK:
                     break;
                  case SelectMethodEnum.CTRL_DOUBLE_CLICK:
                     _loc4_ = param1.selectedItem.quantity;
                     break;
                  case SelectMethodEnum.DOUBLE_CLICK:
                     _loc4_ = 1;
                     break;
                  case SelectMethodEnum.ALT_DOUBLE_CLICK:
                     this._altClickedItem = param1.selectedItem;
                     modCommon.openQuantityPopup(1,param1.selectedItem.quantity,param1.selectedItem.quantity,this.onValidQtyBag);
               }
               if(_loc4_ != -1)
               {
                  if(this._isCrafter)
                  {
                     fillDefaultSlot(param1.selectedItem,_loc4_);
                     this.setItemOwner(param1.selectedItem,false);
                     break;
                  }
                  this.unfillBag(param1.selectedItem,_loc4_);
                  this.setItemOwner(param1.selectedItem,false);
                  break;
               }
            default:
               _loc4_ = -1;
               switch(param2)
               {
                  case SelectMethodEnum.CLICK:
                     break;
                  case SelectMethodEnum.CTRL_DOUBLE_CLICK:
                     _loc4_ = param1.selectedItem.quantity;
                     break;
                  case SelectMethodEnum.DOUBLE_CLICK:
                     _loc4_ = 1;
                     break;
                  case SelectMethodEnum.ALT_DOUBLE_CLICK:
                     this._altClickedItem = param1.selectedItem;
                     modCommon.openQuantityPopup(1,param1.selectedItem.quantity,param1.selectedItem.quantity,this.onValidQtyBag);
               }
               if(_loc4_ != -1)
               {
                  if(this._isCrafter)
                  {
                     fillDefaultSlot(param1.selectedItem,_loc4_);
                     this.setItemOwner(param1.selectedItem,false);
                     break;
                  }
                  this.unfillBag(param1.selectedItem,_loc4_);
                  this.setItemOwner(param1.selectedItem,false);
                  break;
               }
         }
      }
      
      override public function onDoubleClickItemInventory(param1:Object, param2:int = 1) : void
      {
         var _loc3_:ItemWrapper = this.isItemFromBag(param1);
         if(this._isCrafter)
         {
            if(param1.objectGID == SIGNATURE_RUNE_ID || param1.id == SMITHMAGIC_RUNE_ID)
            {
               param2 = 1;
            }
            fillDefaultSlot(param1,param2);
            this.setItemOwner(param1,_loc3_ == null);
         }
         else
         {
            this.setItemOwner(param1,_loc3_ == null);
            this.fillBag(param1,param2);
         }
      }
      
      override public function onRelease(param1:Object) : void
      {
         super.onRelease(param1);
         switch(param1)
         {
            case btn_close:
               sysApi.sendAction(new LeaveDialogRequest());
               break;
            case this.lbl_payment:
               modCommon.openQuantityPopup(0,playerApi.characteristics().kamas,0,this.onPaymentModifiedCallback);
               break;
            case this.btn_validBag:
               if(!this._isReady)
               {
                  sysApi.sendAction(new ExchangeReady(true));
               }
               else
               {
                  sysApi.sendAction(new ExchangeReady(false));
               }
               break;
            case this.ed_leftCharacter:
               if(this._isCrafter)
               {
                  sysApi.sendAction(new DisplayContextualMenu(this._customerInfos.id));
               }
               else
               {
                  sysApi.sendAction(new DisplayContextualMenu(this._crafterInfos.id));
               }
         }
      }
      
      override public function onRightClick(param1:Object) : void
      {
         if(param1 == this.ed_leftCharacter)
         {
            if(this._isCrafter)
            {
               sysApi.sendAction(new DisplayContextualMenu(this._customerInfos.id));
            }
            else
            {
               sysApi.sendAction(new DisplayContextualMenu(this._crafterInfos.id));
            }
         }
         else
         {
            super.onRightClick(param1);
         }
      }
      
      override public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 == this.ed_leftCharacter)
         {
            if(this._isCrafter)
            {
               _loc2_ = this._customerInfos.name;
            }
            else
            {
               _loc2_ = this._crafterInfos.name;
            }
         }
         else if(param1 == ed_rightCharacter)
         {
            if(this._isCrafter)
            {
               _loc2_ = this._crafterInfos.name;
            }
            else
            {
               _loc2_ = this._customerInfos.name;
            }
         }
         if(_loc2_)
         {
            uiApi.showTooltip(uiApi.textTooltipInfo(_loc2_),param1,false,"standard",1,7,3,null,null,null,"TextInfo");
         }
         else
         {
            super.onRollOver(param1);
         }
      }
      
      override public function onRollOut(param1:Object) : void
      {
         uiApi.hideTooltip();
      }
      
      public function onItemRollOver(param1:Object, param2:Object) : void
      {
         if(param2.data)
         {
            uiApi.showTooltip(param2.data,param2.container,false,"standard",8,0,0,"itemName",null,{
               "showEffects":true,
               "header":true
            },"ItemInfo");
         }
      }
      
      public function onItemRollOut(param1:Object, param2:Object) : void
      {
         uiApi.hideTooltip();
      }
      
      public function onItemRightClick(param1:Object, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         if(param2.data)
         {
            _loc3_ = param2.data;
            _loc4_ = menuApi.create(_loc3_);
            if(_loc4_.content.length > 0)
            {
               modContextMenu.createContextMenu(_loc4_);
            }
         }
      }
   }
}
