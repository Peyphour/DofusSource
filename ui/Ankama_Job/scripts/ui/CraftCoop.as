package ui
{
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.components.TextureBitmap;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobExperience;
   import d2actions.DisplayContextualMenu;
   import d2actions.ExchangeCraftPaymentModification;
   import d2actions.ExchangeReady;
   import d2enums.ComponentHookList;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.ExchangeIsReady;
   import d2hooks.JobsExpOtherPlayerUpdated;
   import d2hooks.OtherPlayerListUpdate;
   import d2hooks.PaymentCraftList;
   import d2hooks.PlayerListUpdate;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class CraftCoop extends Craft
   {
      
      public static const EXCHANGE_COLOR_NORMAL:int = 0;
      
      public static const EXCHANGE_COLOR_GREEN:int = 1;
      
      public static const BUTTON_STATE_CANCEL:int = 3;
      
      public static const READY_STEP_NOT_READY:int = 0;
      
      public static const READY_STEP_I_AM_READY:int = 1;
      
      public static const READY_STEP_HE_IS_READY:int = 2;
      
      private static const MAX_SLOT_NUMBER:int = 8;
       
      
      public var slot_ingredient_1_other:Slot;
      
      public var slot_ingredient_2_other:Slot;
      
      public var slot_ingredient_3_other:Slot;
      
      public var slot_ingredient_4_other:Slot;
      
      public var slot_ingredient_5_other:Slot;
      
      public var slot_ingredient_6_other:Slot;
      
      public var slot_ingredient_7_other:Slot;
      
      public var slot_ingredient_8_other:Slot;
      
      public var ed_player_other:EntityDisplayer;
      
      public var lbl_name_other:Label;
      
      public var lbl_job_other:Label;
      
      public var tx_ingredients_selected:Texture;
      
      public var tx_ingredients_selected_other:Texture;
      
      public var tx_bgPayment:TextureBitmap;
      
      public var lbl_payment:Label;
      
      protected var _isPlayerCrafter:Boolean;
      
      protected var _playerInfos:Object;
      
      protected var _crafterInfos:Object;
      
      protected var _customerInfos:Object;
      
      protected var _cancelText:String;
      
      private var _exchangeValidated:Boolean = false;
      
      private var _slotsIngredients_other:Array;
      
      protected var _waitingGrid:Object;
      
      private var _nbSlotsOtherOccupied:int = 0;
      
      private var _nbSlotsOccupied:int = 0;
      
      private var _nbItemOther:int = 0;
      
      private var _nbItem:int = 0;
      
      private var _prevItems:Array;
      
      private var _prevItemsOther:Array;
      
      private var _timeDelay:Number = 2000;
      
      protected var _timerDelay:Timer;
      
      public function CraftCoop()
      {
         this._prevItems = new Array();
         this._prevItemsOther = new Array();
         super();
      }
      
      override public function main(param1:Object) : void
      {
         var _loc2_:Slot = null;
         var _loc3_:JobExperience = null;
         var _loc4_:Number = NaN;
         this._slotsIngredients_other = new Array(this.slot_ingredient_1_other,this.slot_ingredient_2_other,this.slot_ingredient_3_other,this.slot_ingredient_4_other,this.slot_ingredient_5_other,this.slot_ingredient_6_other,this.slot_ingredient_7_other,this.slot_ingredient_8_other);
         this._playerInfos = playerApi.getPlayedCharacterInfo();
         this._crafterInfos = param1.crafterInfos;
         this._customerInfos = param1.customerInfos;
         this._isPlayerCrafter = this._playerInfos.id == this._crafterInfos.id;
         this._cancelText = uiApi.getText("ui.common.cancel");
         this._nbSlotsOtherOccupied = 0;
         this._nbSlotsOccupied = 0;
         this._nbItem = 0;
         this._nbItemOther = 0;
         this._prevItems = new Array();
         this._prevItemsOther = new Array();
         sysApi.addHook(PlayerListUpdate,this.onPlayerListUpdate);
         sysApi.addHook(JobsExpOtherPlayerUpdated,this.onJobsExpOtherPlayerUpdated);
         if(!this._isPlayerCrafter)
         {
            _jobLevel = this._crafterInfos.skillLevel;
            param1.jobLevel = _jobLevel;
         }
         super.main(param1);
         if(!this._isPlayerCrafter && param1.jobExperience)
         {
            _loc3_ = param1.jobExperience as JobExperience;
            if(_loc3_.jobId == _jobId)
            {
               _jobLevel = _loc3_.jobLevel;
               _jobXP = _loc3_.jobXP;
               _jobXpLevelFloor = _loc3_.jobXpLevelFloor;
               _jobXpNextLevelFloor = _loc3_.jobXpNextLevelFloor;
               _loc4_ = (_jobXP - _jobXpLevelFloor) / (_jobXpNextLevelFloor - _jobXpLevelFloor);
               if(_loc4_ > 1 || _jobXpNextLevelFloor == 0)
               {
                  _loc4_ = 1;
               }
               sysApi.log(2,"jauge : " + _loc4_ + " = (" + _jobXP + " - " + _jobXpLevelFloor + ") / (" + _jobXpNextLevelFloor + " - " + _jobXpLevelFloor + ")");
               pb_progressBar_other.value = _loc4_;
            }
         }
         sysApi.addHook(ExchangeIsReady,this.onExchangeIsReady);
         sysApi.addHook(OtherPlayerListUpdate,this.onOtherPlayerListUpdate);
         sysApi.addHook(PaymentCraftList,this.onPaymentCraftList);
         uiApi.addComponentHook(this.ed_player_other,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(this.ed_player_other,ComponentHookList.ON_RIGHT_CLICK);
         uiApi.addComponentHook(this.ed_player_other,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(this.ed_player_other,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(ed_player,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(ed_player,ComponentHookList.ON_ROLL_OUT);
         uiApi.addComponentHook(this.lbl_payment,ComponentHookList.ON_RELEASE);
         uiApi.addComponentHook(pb_progressBar_other,ComponentHookList.ON_ROLL_OVER);
         uiApi.addComponentHook(pb_progressBar_other,ComponentHookList.ON_ROLL_OUT);
         for each(_loc2_ in this._slotsIngredients_other)
         {
            _loc2_.dropValidator = dropValidatorFunction as Function;
            _loc2_.processDrop = processDropFunction as Function;
            uiApi.addComponentHook(_loc2_,ComponentHookList.ON_ROLL_OVER);
            uiApi.addComponentHook(_loc2_,ComponentHookList.ON_ROLL_OUT);
            uiApi.addComponentHook(_loc2_,ComponentHookList.ON_DOUBLE_CLICK);
            uiApi.addComponentHook(_loc2_,ComponentHookList.ON_RIGHT_CLICK);
            uiApi.addComponentHook(_loc2_,ComponentHookList.ON_RELEASE);
            _loc2_.emptyTexture = uiApi.createUri(uiApi.me().getConstant("emptySlot"));
            _loc2_.refresh();
         }
         this.tx_ingredients_selected.gotoAndStop = "green";
         this.tx_ingredients_selected.visible = false;
         this.tx_ingredients_selected_other.gotoAndStop = "green";
         this.tx_ingredients_selected_other.visible = false;
         ed_player.yOffset = 30;
         ed_player.entityScale = 1.5;
         ed_player.direction = 3;
         this.ed_player_other.yOffset = 30;
         this.ed_player_other.entityScale = 1.5;
         this.ed_player_other.direction = 1;
         ed_player.mouseEnabled = true;
         ed_player.handCursor = true;
         this.ed_player_other.mouseEnabled = true;
         this.ed_player_other.handCursor = true;
         if(this._isPlayerCrafter)
         {
            sysApi.log(2,"le joueur est l\'artisan");
            this.tx_bgPayment.disabled = true;
            this.lbl_payment.disabled = true;
            ed_player.look = this._crafterInfos.look;
            this.ed_player_other.look = this._customerInfos.look;
            this.lbl_name_other.text = this._customerInfos.name;
            this.lbl_job_other.text = uiApi.getText("ui.craft.client");
            if(_skill.parentJobId == 1)
            {
               lbl_job.text = uiApi.getText("ui.craft.crafter");
            }
            else
            {
               lbl_job.text = _updatedJob.name + _lvlText + _jobLevel;
            }
            pb_progressBar_other.visible = false;
         }
         else
         {
            sysApi.log(2,"l\'autre est l\'artisan");
            slot_signature.disabled = true;
            ed_player.look = this._customerInfos.look;
            this.ed_player_other.look = this._crafterInfos.look;
            this.lbl_name_other.text = this._crafterInfos.name;
            if(_skill.parentJobId == 1)
            {
               this.lbl_job_other.text = uiApi.getText("ui.craft.crafter");
            }
            else
            {
               this.lbl_job_other.text = _updatedJob.name + _lvlText + _jobLevel;
            }
            lbl_job.text = uiApi.getText("ui.craft.client");
            pb_progressBar.visible = false;
         }
         this._timerDelay = new Timer(this._timeDelay,1);
         this._timerDelay.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerDelayValidateButton);
         this.switchReadyStep(READY_STEP_NOT_READY);
      }
      
      override public function fillAutoSlot(param1:Object, param2:int, param3:Boolean = false) : void
      {
         var _loc4_:int = this.getRealNumberItemForPlayer(this._prevItems.concat(this._prevItemsOther));
         if(param1.id == SIGNATURE_RUNE_ID || _loc4_ < MAX_SLOT_NUMBER || _loc4_ == MAX_SLOT_NUMBER && this.isInOneOfTheGrid(param1.objectGID))
         {
            super.fillAutoSlot(param1,param2,true);
         }
      }
      
      private function getRealNumberItemForPlayer(param1:Array) : int
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = new Vector.<uint>();
         for each(_loc2_ in param1)
         {
            if(_loc2_ != SIGNATURE_RUNE_ID && _loc3_.indexOf(_loc2_) == -1)
            {
               _loc3_.push(_loc2_);
            }
         }
         return _loc3_.length;
      }
      
      override public function containAtLeastOneIngredient() : Boolean
      {
         if(slot_ingredient_1.data || this.slot_ingredient_1_other.data)
         {
            return true;
         }
         return false;
      }
      
      override public function unload() : void
      {
         super.unload();
         _slotsIngredients = new Array();
         this._slotsIngredients_other = new Array();
         this._timerDelay.stop();
         this._timerDelay.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerDelayValidateButton);
         storageApi.removeAllItemMasks("smithMagicBag");
         storageApi.removeAllItemMasks("paymentAlways");
         storageApi.removeAllItemMasks("paymentSuccess");
         storageApi.releaseHooks();
      }
      
      public function formateIngredientsForTheRecipe(param1:Object) : Array
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Boolean = false;
         var _loc7_:Object = null;
         var _loc2_:Array = new Array();
         var _loc3_:int = this.getRealNumberItemForPlayer(this._prevItemsOther);
         for each(_loc4_ in param1.ingredients)
         {
            _loc5_ = new Object();
            _loc5_.objectGID = _loc4_.objectGID;
            if(_loc3_ >= MAX_SLOT_NUMBER)
            {
               return null;
            }
            if(!this.hasItemInGrid(_loc5_.objectGID,this._slotsIngredients_other))
            {
               _loc3_++;
            }
            _loc6_ = false;
            for each(_loc7_ in this._slotsIngredients_other)
            {
               if(_loc7_.data && _loc7_.data.objectGID == _loc4_.objectGID)
               {
                  _loc6_ = true;
                  if(_loc7_.data.quantity <= _loc4_.quantity)
                  {
                     _loc5_.quantity = _loc4_.quantity - _loc7_.data.quantity;
                     _loc2_.push(_loc5_);
                  }
                  break;
               }
            }
            if(!_loc6_)
            {
               _loc5_.quantity = _loc4_.quantity;
               _loc2_.push(_loc5_);
            }
         }
         return _loc2_;
      }
      
      private function onExchangeIsReady(param1:String, param2:Boolean) : void
      {
         if(param2)
         {
            if(this._playerInfos.name == param1)
            {
               this.switchReadyStep(READY_STEP_I_AM_READY);
            }
            else
            {
               this.switchReadyStep(READY_STEP_HE_IS_READY);
            }
         }
         else
         {
            this.switchReadyStep(READY_STEP_NOT_READY);
         }
      }
      
      private function onPlayerListUpdate(param1:Object) : void
      {
         var _loc3_:Array = null;
         var _loc2_:Object = this.updatePlayer(param1.componentList,1);
         if(_loc2_.index != null && _loc2_.index >= 0)
         {
            _loc3_ = _loc2_.player == 1?_slotsIngredients:this._slotsIngredients_other;
            if(_loc2_.type)
            {
               if(_loc2_.type == "block" && _loc2_.player == 2)
               {
                  this._nbSlotsOtherOccupied++;
               }
               else if(_loc2_.type == "normal" && _loc2_.player == 1)
               {
                  this._nbSlotsOccupied--;
               }
               else if(_loc2_.type == "block" && _loc2_.player == 1)
               {
                  this._nbSlotsOccupied++;
               }
               else if(_loc2_.type == "normal" && _loc2_.player == 2)
               {
                  this._nbSlotsOtherOccupied--;
               }
               _loc3_[_loc2_.index].emptyTexture = _loc2_.type == "block"?uiApi.createUri(uiApi.me().getConstant("lockedSlot")):uiApi.createUri(uiApi.me().getConstant("emptySlot"));
            }
            if(_loc2_.updateItemsNumber)
            {
               this._nbItem = this._nbItem + _loc2_.updateItemsNumber;
            }
            if(_loc2_.index < _loc3_.length)
            {
               _loc3_[_loc2_.index].refresh();
            }
         }
         this._prevItems = this.updateTabWithGid(param1.componentList);
      }
      
      public function updatePlayer(param1:Object, param2:uint) : Object
      {
         var _loc4_:ItemWrapper = null;
         var _loc3_:Array = new Array();
         for each(_loc4_ in param1)
         {
            _loc3_.push(_loc4_);
         }
         if(param2 == 1)
         {
            return this.updateLogic(_loc3_,this._nbItem,this._nbSlotsOccupied,this._nbSlotsOtherOccupied,_slotsIngredients,this._slotsIngredients_other,this._prevItems);
         }
         if(param2 == 2)
         {
            return this.updateLogic(_loc3_,this._nbItemOther,this._nbSlotsOtherOccupied,this._nbSlotsOccupied,this._slotsIngredients_other,_slotsIngredients,this._prevItemsOther);
         }
         throw "You have to specify a player !!";
      }
      
      private function updateLogic(param1:Array, param2:int, param3:int, param4:int, param5:Array, param6:Array, param7:Array) : Object
      {
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc8_:Object = new Object();
         if(param1[param1.length - 1] && param1[param1.length - 1].objectGID != SIGNATURE_RUNE_ID || param1.length == 0)
         {
            if(param1.length > param2)
            {
               _loc9_ = param1[param1.length - 1].objectGID;
               if(!this.hasItemInGrid(_loc9_,param5))
               {
                  _loc8_.updateItemsNumber = 1;
                  if(!this.hasItemInGrid(_loc9_,param6))
                  {
                     _loc8_.index = MAX_SLOT_NUMBER - (param4 + 1);
                     _loc8_.player = 2;
                     _loc8_.type = "block";
                  }
                  else if(param3 > 0)
                  {
                     _loc8_.index = MAX_SLOT_NUMBER - param3;
                     _loc8_.player = 1;
                     _loc8_.type = "normal";
                  }
               }
            }
            else if(param1.length < param2)
            {
               _loc10_ = this.getMissingItemGid(param1,param7);
               if(_loc10_ == SIGNATURE_RUNE_ID)
               {
                  return _loc8_;
               }
               _loc8_.updateItemsNumber = -1;
               if(this.hasItemInGrid(_loc10_,param6))
               {
                  _loc8_.index = MAX_SLOT_NUMBER - (param3 + 1);
                  _loc8_.type = "block";
                  _loc8_.player = 1;
               }
               else if(param4 > 0)
               {
                  _loc8_.index = MAX_SLOT_NUMBER - param4;
                  _loc8_.type = "normal";
                  _loc8_.player = 2;
               }
            }
            else
            {
               _loc8_.index = param2 - 1;
               _loc8_.player = 1;
            }
         }
         return _loc8_;
      }
      
      private function onOtherPlayerListUpdate(param1:Object) : void
      {
         var _loc3_:Array = null;
         var _loc2_:Object = this.updatePlayer(param1.componentList,2);
         if(_loc2_.index != null && _loc2_.index >= 0)
         {
            _loc3_ = _loc2_.player == 2?_slotsIngredients:this._slotsIngredients_other;
            if(_loc2_.type)
            {
               if(_loc2_.type == "block" && _loc2_.player == 2)
               {
                  this._nbSlotsOccupied++;
               }
               else if(_loc2_.type == "normal" && _loc2_.player == 1)
               {
                  this._nbSlotsOtherOccupied--;
               }
               else if(_loc2_.type == "block" && _loc2_.player == 1)
               {
                  this._nbSlotsOtherOccupied++;
               }
               else if(_loc2_.type == "normal" && _loc2_.player == 2)
               {
                  this._nbSlotsOccupied--;
               }
               _loc3_[_loc2_.index].emptyTexture = uiApi.createUri(uiApi.me().getConstant(_loc2_.type == "block"?"lockedSlot":"emptySlot"));
            }
            if(_loc2_.updateItemsNumber)
            {
               this._nbItemOther = this._nbItemOther + _loc2_.updateItemsNumber;
            }
            if(_loc2_.index < _loc3_.length)
            {
               _loc3_[_loc2_.index].refresh();
            }
         }
         this._prevItemsOther = this.updateTabWithGid(param1.componentList);
         fillComponents(param1.componentList,this._slotsIngredients_other,slot_signature);
         this.setOkButtonTemporaryDisabled();
      }
      
      public function hasItemInGrid(param1:int, param2:Array) : Boolean
      {
         var _loc3_:Object = null;
         for each(_loc3_ in param2)
         {
            if(_loc3_.data && _loc3_.data.objectGID == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function updateTabWithGid(param1:Object) : Array
      {
         var _loc3_:Object = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            if(_loc2_.indexOf(_loc3_.objectGID) == -1)
            {
               _loc2_.push(_loc3_.objectGID);
            }
         }
         return _loc2_;
      }
      
      public function getMissingItemGid(param1:Object, param2:Array) : int
      {
         var _loc3_:Boolean = false;
         var _loc4_:ItemWrapper = null;
         var _loc5_:int = 0;
         for each(_loc5_ in param2)
         {
            _loc3_ = false;
            for each(_loc4_ in param1)
            {
               if(_loc5_ == _loc4_.objectGID)
               {
                  _loc3_ = true;
               }
            }
            if(!_loc3_)
            {
               return _loc5_;
            }
         }
         return -1;
      }
      
      private function isInOneOfTheGrid(param1:int) : Boolean
      {
         return this.hasItemInGrid(param1,_slotsIngredients.concat(this._slotsIngredients_other));
      }
      
      private function onPaymentCraftList(param1:Object, param2:Boolean) : void
      {
         this.lbl_payment.text = utilApi.kamasToString(param1.kamaPayment,"");
      }
      
      private function onTimerDelayValidateButton(param1:TimerEvent) : void
      {
         if(!this.containAtLeastOneIngredient())
         {
            btn_ok.disabled = true;
         }
         else
         {
            btn_ok.disabled = false;
         }
      }
      
      override protected function onJobsExpUpdated(param1:uint) : void
      {
         if(this._isPlayerCrafter)
         {
            super.onJobsExpUpdated(param1);
         }
      }
      
      protected function onJobsExpOtherPlayerUpdated(param1:Number, param2:Object) : void
      {
         var _loc3_:JobExperience = null;
         var _loc4_:Number = NaN;
         if(!this._isPlayerCrafter && param1 == this._crafterInfos.id)
         {
            _loc3_ = param2 as JobExperience;
            if(_loc3_.jobId == _jobId)
            {
               if(_jobLevel != _loc3_.jobLevel)
               {
                  _jobLevel = _loc3_.jobLevel;
                  this.lbl_job_other.text = _updatedJob.name + _lvlText + _jobLevel;
                  if(_loc3_.jobLevel == ProtocolConstantsEnum.MAX_JOB_LEVEL)
                  {
                     ctr_signature.visible = true;
                  }
               }
               _jobXP = _loc3_.jobXP;
               _jobXpLevelFloor = _loc3_.jobXpLevelFloor;
               _jobXpNextLevelFloor = _loc3_.jobXpNextLevelFloor;
               _loc4_ = (_jobXP - _jobXpLevelFloor) / (_jobXpNextLevelFloor - _jobXpLevelFloor);
               if(_loc4_ > 1 || _jobXpNextLevelFloor == 0)
               {
                  _loc4_ = 1;
               }
               pb_progressBar_other.value = _loc4_;
            }
         }
      }
      
      override protected function disableQuantity(param1:Boolean) : void
      {
         if(this._nbSlotsOtherOccupied > 0 && this._nbSlotsOccupied == 0)
         {
            super.disableQuantity(param1);
         }
         else
         {
            super.disableQuantity(true);
         }
      }
      
      override protected function isValidContent(param1:Object, param2:Object) : Boolean
      {
         switch(param1)
         {
            case this.slot_ingredient_1_other:
            case this.slot_ingredient_2_other:
            case this.slot_ingredient_3_other:
            case this.slot_ingredient_4_other:
            case this.slot_ingredient_5_other:
            case this.slot_ingredient_6_other:
            case this.slot_ingredient_7_other:
            case this.slot_ingredient_8_other:
               if(param2.id == SIGNATURE_RUNE_ID)
               {
                  return false;
               }
               return true;
            default:
               return super.isValidContent(param1,param2);
         }
      }
      
      override protected function getSlotsContent() : Array
      {
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc1_:Array = super.getSlotsContent();
         var _loc2_:int = _loc1_.length;
         for each(_loc3_ in this._slotsIngredients_other)
         {
            if(_loc3_.data)
            {
               _loc4_ = false;
               _loc5_ = 0;
               while(_loc5_ < _loc2_)
               {
                  _loc6_ = _loc1_[_loc5_];
                  if(_loc6_.objectGID == _loc3_.data.objectGID)
                  {
                     _loc6_.quantity = _loc6_.quantity + _loc3_.data.quantity;
                     _loc4_ = true;
                  }
                  _loc5_++;
               }
               if(!_loc4_)
               {
                  _loc1_.push({
                     "objectUID":_loc3_.data.objectUID,
                     "objectGID":_loc3_.data.objectGID,
                     "quantity":_loc3_.data.quantity
                  });
               }
            }
         }
         return _loc1_;
      }
      
      override protected function onConfirmCraftRecipe() : void
      {
         sysApi.sendAction(new ExchangeReady(true));
      }
      
      protected function switchReadyStep(param1:uint) : void
      {
         switch(param1)
         {
            case READY_STEP_I_AM_READY:
               tx_quantity_selected.gotoAndStop = "green";
               tx_quantity_selected.visible = true;
               this.tx_ingredients_selected.visible = true;
               this._exchangeValidated = true;
               btn_lbl_btn_ok.text = uiApi.getText("ui.common.cancel");
               if(!this.containAtLeastOneIngredient())
               {
                  btn_ok.disabled = true;
               }
               else
               {
                  btn_ok.disabled = false;
               }
               break;
            case READY_STEP_HE_IS_READY:
               tx_quantity_selected.gotoAndStop = "green";
               tx_quantity_selected.visible = true;
               this.tx_ingredients_selected_other.visible = true;
               btn_lbl_btn_ok.text = uiApi.getText("ui.common.merge");
               break;
            case READY_STEP_NOT_READY:
            default:
               if(slot_item_crafting.data)
               {
                  tx_quantity_selected.gotoAndStop = "orange";
                  tx_quantity_selected.visible = true;
               }
               else
               {
                  tx_quantity_selected.visible = false;
               }
               this.tx_ingredients_selected.visible = false;
               this.tx_ingredients_selected_other.visible = false;
               this._exchangeValidated = false;
               btn_lbl_btn_ok.text = uiApi.getText("ui.common.merge");
         }
      }
      
      override protected function cleanAllItems() : void
      {
         var _loc1_:Object = null;
         super.cleanAllItems();
         for each(_loc1_ in this._slotsIngredients_other)
         {
            _loc1_.data = null;
         }
      }
      
      override public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case btn_ok:
               if(this._exchangeValidated)
               {
                  sysApi.sendAction(new ExchangeReady(false));
               }
               else
               {
                  super.onRelease(param1);
               }
               break;
            case this.lbl_payment:
               modCommon.openQuantityPopup(0,playerApi.characteristics().kamas,0,this.onPaymentModifiedCallback);
               break;
            case this.ed_player_other:
               if(this._isPlayerCrafter)
               {
                  sysApi.sendAction(new DisplayContextualMenu(this._customerInfos.id));
               }
               else
               {
                  sysApi.sendAction(new DisplayContextualMenu(this._crafterInfos.id));
               }
               break;
            default:
               super.onRelease(param1);
         }
      }
      
      override public function onRightClick(param1:Object) : void
      {
         if(param1 == this.ed_player_other)
         {
            if(this._isPlayerCrafter)
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
         if(param1 == this.ed_player_other)
         {
            if(this._isPlayerCrafter)
            {
               _loc2_ = this._customerInfos.name;
            }
            else
            {
               _loc2_ = this._crafterInfos.name;
            }
         }
         else if(param1 == ed_player)
         {
            if(this._isPlayerCrafter)
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
      
      override protected function isRecipeFull(param1:Object, param2:Array) : Boolean
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc3_:Boolean = true;
         var _loc4_:Boolean = false;
         for each(_loc5_ in param1.ingredients)
         {
            _loc6_ = inventoryApi.getStorageObjectGID(_loc5_.objectGID,_loc5_.quantity);
            if(_loc6_ == null)
            {
               if(!this.isInOneOfTheGrid(_loc5_.objectGID))
               {
                  _loc4_ = true;
               }
               _loc3_ = false;
            }
            else
            {
               param2.push(_loc6_);
            }
         }
         if(_loc4_)
         {
            modCommon.openPopup(uiApi.getText("ui.popup.warning"),uiApi.getText("ui.craft.dontHaveAllIngredient"),[uiApi.getText("ui.common.ok")]);
         }
         return _loc3_;
      }
      
      public function onPaymentModifiedCallback(param1:int) : void
      {
         sysApi.sendAction(new ExchangeCraftPaymentModification(param1));
      }
      
      override protected function onExchangeReplayCountModified(param1:int) : void
      {
         super.onExchangeReplayCountModified(param1);
         this.setOkButtonTemporaryDisabled();
      }
      
      override protected function onExchangeCraftResult(param1:uint, param2:Object) : void
      {
         this.switchReadyStep(READY_STEP_NOT_READY);
         super.onExchangeCraftResult(param1,param2);
      }
      
      override protected function onExchangeItemAutoCraftStoped(param1:uint) : void
      {
         this.switchReadyStep(READY_STEP_NOT_READY);
      }
      
      private function setOkButtonTemporaryDisabled() : void
      {
         btn_ok.disabled = true;
         this._timerDelay.reset();
         this._timerDelay.start();
      }
      
      public function set nbItem(param1:int) : void
      {
         this._nbItem = param1;
      }
      
      public function set nbItemOther(param1:int) : void
      {
         this._nbItemOther = param1;
      }
      
      public function set nbSlotsOtherOccupied(param1:int) : void
      {
         this._nbSlotsOtherOccupied = param1;
      }
      
      public function set nbSlotsOccupied(param1:int) : void
      {
         this._nbSlotsOccupied = param1;
      }
      
      public function set slotsIngredientsOther(param1:Array) : void
      {
         this._slotsIngredients_other = param1;
      }
      
      public function set prevItems(param1:Array) : void
      {
         this._prevItems = param1;
      }
      
      public function set prevItemsOther(param1:Array) : void
      {
         this._prevItemsOther = param1;
      }
   }
}
