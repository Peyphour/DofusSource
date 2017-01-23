package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.EntityDisplayer;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.components.ProgressBar;
   import com.ankamagames.berilia.components.Slot;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.jobs.Recipe;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.InventoryApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
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
   import d2actions.ExchangeSetCraftRecipe;
   import d2actions.LeaveDialogRequest;
   import d2enums.ComponentHookList;
   import d2enums.CraftResultEnum;
   import d2enums.ExchangeReplayStopReasonEnum;
   import d2enums.ProtocolConstantsEnum;
   import d2hooks.DropEnd;
   import d2hooks.DropStart;
   import d2hooks.ExchangeCraftResult;
   import d2hooks.ExchangeItemAutoCraftStoped;
   import d2hooks.ExchangeLeave;
   import d2hooks.ExchangeObjectAdded;
   import d2hooks.ExchangeReplayCountModified;
   import d2hooks.JobsExpUpdated;
   import d2hooks.MouseAltDoubleClick;
   import d2hooks.MouseCtrlDoubleClick;
   import d2hooks.ObjectSelected;
   import d2hooks.PlayerListUpdate;
   import d2hooks.RecipeSelected;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class Craft
   {
      
      public static const SIGNATURE_RUNE_ID:int = 7508;
      
      public static const STEP_READY_TO_CRAFT:int = 0;
      
      public static const STEP_RECIPE_KNOWN:int = 1;
      
      public static const STEP_RECIPE_UNKNOWN:int = 2;
      
      public static const STEP_CRAFTING:int = 3;
      
      public static const STEP_CRAFT_ENDED:int = 4;
      
      public static const STEP_CRAFT_STOPPED:int = 5;
       
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var jobsApi:JobsApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var menuApi:ContextMenuApi;
      
      public var inventoryApi:InventoryApi;
      
      public var soundApi:SoundApi;
      
      public var storageApi:StorageApi;
      
      public var utilApi:UtilApi;
      
      public var ctr_recipes:GraphicContainer;
      
      public var ctr_itemResult:GraphicContainer;
      
      public var slot_item_result:Slot;
      
      public var lbl_item_result:Label;
      
      public var ctr_signature:GraphicContainer;
      
      public var tx_quantity_selected:Texture;
      
      public var slot_ingredient_1:Slot;
      
      public var slot_ingredient_2:Slot;
      
      public var slot_ingredient_3:Slot;
      
      public var slot_ingredient_4:Slot;
      
      public var slot_ingredient_5:Slot;
      
      public var slot_ingredient_6:Slot;
      
      public var slot_ingredient_7:Slot;
      
      public var slot_ingredient_8:Slot;
      
      public var slot_signature:Slot;
      
      public var slot_item_crafting:Slot;
      
      public var lbl_title:Label;
      
      public var lbl_name:Label;
      
      public var lbl_job:Label;
      
      public var lbl_item:Label;
      
      public var lbl_quantity:Label;
      
      public var btn_quantity_up:ButtonContainer;
      
      public var btn_quantity_down:ButtonContainer;
      
      public var pb_progressBar:ProgressBar;
      
      public var pb_progressBar_other:ProgressBar;
      
      public var btn_ok:ButtonContainer;
      
      public var btn_lbl_btn_ok:Label;
      
      public var btn_close:ButtonContainer;
      
      public var ed_player:EntityDisplayer;
      
      protected var _step:uint;
      
      protected var _skill:Skill;
      
      protected var _jobLevel:int;
      
      protected var _jobXP:int;
      
      protected var _jobXpLevelFloor:int;
      
      protected var _jobXpNextLevelFloor:int;
      
      protected var _jobId:uint;
      
      protected var _updatedJob:KnownJobWrapper;
      
      protected var _recipesUi:Object;
      
      protected var _recipes:Array;
      
      protected var _itemToCraft:Object = null;
      
      protected var _textItemToCraft:String;
      
      protected var _slotsIngredients:Array;
      
      protected var _waitingData:Object;
      
      protected var _waitingSlot:Object;
      
      protected var _isRecipeKnown:Boolean;
      
      private var _updateTimer:Timer;
      
      private var _disableRecipiesTimer:Timer;
      
      private var _timerBuffer_componentList:Object;
      
      private var _timerBuffer_slotsIngredients:Object;
      
      private var _timerBuffer_slotSignature:Object;
      
      protected var showRecipes:Boolean = true;
      
      protected var _lvlText:String;
      
      public function Craft()
      {
         this._recipes = new Array();
         super();
      }
      
      public function get skill() : Object
      {
         return this._skill;
      }
      
      public function get jobLevel() : uint
      {
         return this._jobLevel;
      }
      
      public function main(param1:Object) : void
      {
         var _loc3_:* = undefined;
         this.sysApi.disableWorldInteraction();
         this.btn_close.soundId = SoundEnum.CANCEL_BUTTON;
         this.btn_ok.soundId = SoundEnum.OK_BUTTON;
         this.btn_quantity_down.soundId = SoundEnum.SCROLL_DOWN;
         this.btn_quantity_up.soundId = SoundEnum.SCROLL_UP;
         this.sysApi.addHook(d2hooks.JobLevelUp,this.onJobLevelUp);
         this.sysApi.addHook(PlayerListUpdate,this.onPlayerListUpdate);
         this.sysApi.addHook(ExchangeCraftResult,this.onExchangeCraftResult);
         this.sysApi.addHook(ExchangeItemAutoCraftStoped,this.onExchangeItemAutoCraftStoped);
         this.sysApi.addHook(DropStart,this.onDropStart);
         this.sysApi.addHook(DropEnd,this.onDropEnd);
         this.sysApi.addHook(ExchangeReplayCountModified,this.onExchangeReplayCountModified);
         this.sysApi.addHook(ExchangeLeave,this.onExchangeLeave);
         this.sysApi.addHook(RecipeSelected,this.onRecipeSelected);
         this.sysApi.addHook(MouseAltDoubleClick,this.onMouseAltDoubleClick);
         this.sysApi.addHook(MouseCtrlDoubleClick,this.onMouseCtrlDoubleClick);
         this.sysApi.addHook(ObjectSelected,this.onObjectSelected);
         this.sysApi.addHook(ExchangeObjectAdded,this.onExchangeObjectAdded);
         this.sysApi.addHook(JobsExpUpdated,this.onJobsExpUpdated);
         this.uiApi.addComponentHook(this.lbl_quantity,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_quantity_up,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_quantity_down,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_ok,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.slot_item_crafting,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.slot_item_crafting,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.slot_item_crafting,ComponentHookList.ON_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.slot_item_result,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.slot_item_result,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.slot_item_result,ComponentHookList.ON_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.pb_progressBar,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.pb_progressBar,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.ed_player,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.ed_player,ComponentHookList.ON_RIGHT_CLICK);
         this._updateTimer = new Timer(150,1);
         this._updateTimer.addEventListener(TimerEvent.TIMER,this.onTimerEvent);
         this._disableRecipiesTimer = new Timer(300,1);
         this._disableRecipiesTimer.addEventListener(TimerEvent.TIMER,this.onDisableRecipiesTimer);
         this._lvlText = " " + this.uiApi.getText("ui.common.level").toLocaleLowerCase() + " ";
         this._skill = this.jobsApi.getSkillFromId(param1.skillId);
         this._updatedJob = this.jobsApi.getKnownJob(this._skill.parentJobId);
         this._jobLevel = this._updatedJob.jobLevel;
         this._jobId = this._updatedJob.id;
         this._jobXP = this._updatedJob.jobXP;
         this._jobXpLevelFloor = this._updatedJob.jobXpLevelFloor;
         this._jobXpNextLevelFloor = this._updatedJob.jobXpNextLevelFloor;
         if(param1.hasOwnProperty("jobLevel"))
         {
            this._jobLevel = param1.jobLevel;
         }
         if(this._skill.parentJobId != 1)
         {
            this.lbl_title.text = this.uiApi.getText("ui.craft.crafter");
            if(this.lbl_job)
            {
               this.lbl_job.text = this._updatedJob.name + this._lvlText + this._jobLevel;
            }
         }
         else
         {
            this.lbl_title.text = this._skill.name;
            if(this.lbl_job)
            {
               this.lbl_job.text = "";
            }
            this.pb_progressBar.visible = false;
         }
         this.lbl_name.text = this.playerApi.getEntityInfos().name;
         var _loc2_:Number = (this._jobXP - this._jobXpLevelFloor) / (this._jobXpNextLevelFloor - this._jobXpLevelFloor);
         if(_loc2_ > 1 || this._jobXpNextLevelFloor == 0)
         {
            _loc2_ = 1;
         }
         this.pb_progressBar.value = _loc2_;
         this._slotsIngredients = new Array(this.slot_ingredient_1,this.slot_ingredient_2,this.slot_ingredient_3,this.slot_ingredient_4,this.slot_ingredient_5,this.slot_ingredient_6,this.slot_ingredient_7,this.slot_ingredient_8);
         for each(_loc3_ in this._slotsIngredients)
         {
            _loc3_.dropValidator = this.dropValidatorFunction as Function;
            _loc3_.processDrop = this.processDropFunction as Function;
            this.uiApi.addComponentHook(_loc3_,ComponentHookList.ON_ROLL_OVER);
            this.uiApi.addComponentHook(_loc3_,ComponentHookList.ON_ROLL_OUT);
            this.uiApi.addComponentHook(_loc3_,ComponentHookList.ON_DOUBLE_CLICK);
            this.uiApi.addComponentHook(_loc3_,ComponentHookList.ON_RIGHT_CLICK);
            this.uiApi.addComponentHook(_loc3_,ComponentHookList.ON_RELEASE);
            _loc3_.emptyTexture = this.uiApi.createUri(this.uiApi.me().getConstant("emptySlot"));
         }
         this.slot_signature.dropValidator = this.dropValidatorFunction as Function;
         this.slot_signature.processDrop = this.processDropFunction as Function;
         this.uiApi.addComponentHook(this.slot_signature,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.slot_signature,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.slot_signature,ComponentHookList.ON_DOUBLE_CLICK);
         this.uiApi.addComponentHook(this.slot_signature,ComponentHookList.ON_RIGHT_CLICK);
         this.uiApi.addComponentHook(this.slot_signature,ComponentHookList.ON_RELEASE);
         if(this.showRecipes)
         {
            this._recipesUi = this.modCommon.createRecipesObject("recipesCraft",this.ctr_recipes,this.ctr_recipes,this._skill.parentJobId,this._skill.id,true,"",this._jobLevel);
         }
         if(this._jobLevel < ProtocolConstantsEnum.MAX_JOB_LEVEL)
         {
            this.ctr_signature.visible = false;
         }
         else
         {
            this.ctr_signature.visible = true;
         }
         this.switchUI(STEP_READY_TO_CRAFT,true);
         this.ed_player.yOffset = 30;
         this.ed_player.entityScale = 1.5;
         this.ed_player.direction = 1;
         this.ed_player.look = this.playerApi.getPlayedCharacterInfo().entityLook;
      }
      
      public function unload() : void
      {
         this.uiApi.unloadUi("recipesCraft");
         this.uiApi.unloadUi("itemBoxCraft");
         this.storageApi.removeAllItemMasks("craft");
         this.storageApi.releaseHooks();
         this.sysApi.sendAction(new LeaveDialogRequest());
         this.sysApi.sendAction(new CloseInventory());
         this.sysApi.enableWorldInteraction();
      }
      
      public function get itemQuantity() : int
      {
         return parseInt(this.lbl_quantity.text);
      }
      
      public function containAtLeastOneIngredient() : Boolean
      {
         if(this.slot_ingredient_1.data)
         {
            return true;
         }
         return false;
      }
      
      protected function setQuantity(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:Slot = null;
         if(param1 == this.itemQuantity)
         {
            return;
         }
         this.storageApi.removeAllItemMasks("craft");
         for each(_loc3_ in this._slotsIngredients)
         {
            if(_loc3_.data)
            {
               this.storageApi.addItemMask(_loc3_.data.objectUID,"craft",_loc3_.data.quantity * param1);
            }
         }
         this.storageApi.releaseHooks();
         this.lbl_quantity.text = param1.toString();
      }
      
      protected function displayPreviewItem(param1:Object) : void
      {
         if(param1)
         {
            this.tx_quantity_selected.visible = true;
            this.lbl_item.text = param1.name;
            this.slot_item_crafting.data = param1;
         }
         else
         {
            this.tx_quantity_selected.visible = false;
            this.lbl_item.text = "";
            this.slot_item_crafting.data = null;
         }
      }
      
      protected function displayResultItem(param1:Object) : void
      {
         if(param1)
         {
            this.ctr_itemResult.visible = true;
            this.slot_item_result.data = param1;
            this.slot_item_result.visible = true;
            this.lbl_item_result.text = param1.name + (this.itemQuantity > 1?" x " + this.itemQuantity:"");
         }
         else
         {
            this.ctr_itemResult.visible = false;
            this.slot_item_result.visible = false;
            this.slot_item_result.data = null;
            this.lbl_item_result.text = null;
         }
      }
      
      protected function disableQuantity(param1:Boolean) : void
      {
         this.lbl_quantity.disabled = param1;
         this.btn_quantity_up.disabled = param1;
         this.btn_quantity_down.disabled = param1;
      }
      
      public function processDropToInventory(param1:Object, param2:Object, param3:Object) : void
      {
         if(param2.info1 > 1)
         {
            this.modCommon.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQtyDropToInventory);
         }
         else
         {
            this.unfillSlot(this._waitingSlot,-1);
         }
      }
      
      protected function onValidQtyDropToInventory(param1:Number) : void
      {
         this.unfillSlot(this._waitingSlot,param1);
      }
      
      public function fillAutoSlot(param1:Object, param2:int, param3:Boolean = false) : void
      {
         var _loc4_:Object = null;
         if(param1.id == SIGNATURE_RUNE_ID)
         {
            if(this.dropValidatorFunction(this.slot_signature,param1,null))
            {
               if(this._jobLevel < ProtocolConstantsEnum.MAX_JOB_LEVEL)
               {
                  this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.craft.jobLevelLowForSignature"),[this.uiApi.getText("ui.common.ok")]);
                  return;
               }
               this.fillSlot(this.slot_signature,param1,1);
            }
         }
         else
         {
            _loc4_ = null;
            for each(_loc4_ in this._slotsIngredients)
            {
               if(_loc4_.data && _loc4_.data.objectGID == param1.objectGID)
               {
                  this.fillSlot(null,param1,param2);
                  return;
               }
               if(_loc4_.data == null)
               {
                  this.fillSlot(_loc4_,param1,param2);
                  return;
               }
            }
            if(param3)
            {
               this.fillSlot(null,param1,param2);
            }
         }
      }
      
      protected function switchUI(param1:uint, param2:Boolean = false) : void
      {
         if(this._step == param1 && !param2)
         {
            return;
         }
         this._step = param1;
         switch(param1)
         {
            case STEP_READY_TO_CRAFT:
               this.sysApi.log(2,"STEP_READY_TO_CRAFT");
               this.displayPreviewItem(null);
               this.disableQuantity(true);
               this.setQuantity(1);
               this.displayResultItem(null);
               this.btn_ok.disabled = true;
               break;
            case STEP_RECIPE_KNOWN:
               this.sysApi.log(2,"STEP_RECIPE_KNOWN");
               this.soundApi.playSound(SoundTypeEnum.RECIPE_MATCH);
               this.displayPreviewItem(this._itemToCraft);
               this.disableQuantity(false);
               this.setQuantity(1);
               this.displayResultItem(null);
               this.btn_ok.disabled = false;
               break;
            case STEP_RECIPE_UNKNOWN:
               this.sysApi.log(2,"STEP_RECIPE_UNKNOWN");
               this.displayPreviewItem(null);
               this.disableQuantity(false);
               if(!this.containAtLeastOneIngredient())
               {
                  this.btn_ok.disabled = true;
               }
               else
               {
                  this.btn_ok.disabled = false;
               }
               break;
            case STEP_CRAFTING:
               this.sysApi.log(2,"STEP_CRAFTING");
               this.disableQuantity(true);
               this.btn_ok.disabled = true;
               break;
            case STEP_CRAFT_ENDED:
               this.sysApi.log(2,"STEP_CRAFT_ENDED");
               if(this._skill.id != 209)
               {
                  this.cleanAllItems();
               }
               this.displayPreviewItem(null);
               this.disableQuantity(false);
               this.displayResultItem(this._itemToCraft);
               this.btn_ok.disabled = true;
               break;
            case STEP_CRAFT_STOPPED:
               this.sysApi.log(2,"STEP_CRAFT_STOPPED");
               this.disableQuantity(false);
               this.displayResultItem(this._itemToCraft);
               if(!this.containAtLeastOneIngredient())
               {
                  this.btn_ok.disabled = true;
               }
               else
               {
                  this.btn_ok.disabled = false;
               }
         }
      }
      
      protected function isValidContent(param1:Object, param2:Object) : Boolean
      {
         switch(param1)
         {
            case this.slot_signature:
               if(param2.id == SIGNATURE_RUNE_ID)
               {
                  return true;
               }
               return false;
            case this.slot_ingredient_1:
            case this.slot_ingredient_2:
            case this.slot_ingredient_3:
            case this.slot_ingredient_4:
            case this.slot_ingredient_5:
            case this.slot_ingredient_6:
            case this.slot_ingredient_7:
            case this.slot_ingredient_8:
               if(param2.id == SIGNATURE_RUNE_ID)
               {
                  return false;
               }
               return true;
            default:
               return false;
         }
      }
      
      protected function dropValidatorFunction(param1:Object, param2:Object, param3:Object) : Boolean
      {
         return this.isValidContent(param1,param2);
      }
      
      protected function processDropFunction(param1:Object, param2:Object, param3:Object) : void
      {
         if(this.dropValidatorFunction(param1,param2,param3))
         {
            switch(param1)
            {
               case this.slot_signature:
                  this.fillAutoSlot(param2,1);
                  break;
               default:
                  if(param2.quantity > 1)
                  {
                     this._waitingData = param2;
                     this.modCommon.openQuantityPopup(1,param2.quantity,param2.quantity,this.onValidQtyDrop);
                  }
                  else
                  {
                     this.fillAutoSlot(param2,1);
                  }
            }
         }
      }
      
      private function onValidQtyDrop(param1:Number) : void
      {
         this.fillAutoSlot(this._waitingData,param1);
      }
      
      private function onValidCraftItemQty(param1:Number) : void
      {
         this.sysApi.sendAction(new ExchangeReplay(param1));
      }
      
      private function fillSlot(param1:Object, param2:Object, param3:int) : void
      {
         if(param1 != null && param1.data != null)
         {
            this.unfillSlot(param1,-1);
         }
         this.sysApi.sendAction(new ExchangeObjectMove(param2.objectUID,param3));
      }
      
      private function unfillSlot(param1:Object, param2:int) : void
      {
         if(param1 == null || param1.data == null)
         {
            return;
         }
         if(param2 == -1)
         {
            param2 = param1.data.quantity;
         }
         this.sysApi.sendAction(new ExchangeObjectMove(param1.data.objectUID,-param2));
      }
      
      protected function cleanAllItems() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this._slotsIngredients)
         {
            _loc1_.data = null;
         }
         this.slot_signature.data = null;
      }
      
      protected function removeAllItems() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this._slotsIngredients)
         {
            if(_loc1_.data)
            {
               this.sysApi.sendAction(new ExchangeObjectMove(_loc1_.data.objectUID,-_loc1_.data.quantity));
            }
         }
         if(this.slot_signature.data)
         {
            this.sysApi.sendAction(new ExchangeObjectMove(this.slot_signature.data.objectUID,-this.slot_signature.data.quantity));
         }
      }
      
      private function getFirstEmptySlot(param1:Object) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_.data == null)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      protected function getSlotsContent() : Array
      {
         var _loc2_:Object = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in this._slotsIngredients)
         {
            if(_loc2_.data != null)
            {
               _loc1_.push({
                  "objectUID":_loc2_.data.objectUID,
                  "objectGID":_loc2_.data.objectGID,
                  "quantity":_loc2_.data.quantity
               });
            }
         }
         return _loc1_;
      }
      
      protected function checkRecipe() : Boolean
      {
         this._isRecipeKnown = false;
         if(this._skill.id == 209)
         {
            this._isRecipeKnown = true;
            return this._isRecipeKnown;
         }
         var _loc1_:Array = this.getSlotsContent();
         var _loc2_:Recipe = this.getRecipeWithItems(_loc1_);
         if(_loc2_)
         {
            this._itemToCraft = _loc2_.result;
            this._isRecipeKnown = true;
         }
         else
         {
            this._itemToCraft = null;
         }
         return this._isRecipeKnown;
      }
      
      private function getRecipeWithItems(param1:Array) : Recipe
      {
         var _loc3_:Recipe = null;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         var _loc6_:Boolean = false;
         var _loc7_:ItemWrapper = null;
         if(param1.length == 0)
         {
            return null;
         }
         var _loc2_:Object = this.jobsApi.getRecipesList(param1[0].objectGID);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.skillId == this._skill.id)
            {
               if(_loc3_.ingredientIds.length == param1.length)
               {
                  _loc4_ = true;
                  for each(_loc5_ in param1)
                  {
                     _loc6_ = true;
                     for each(_loc7_ in _loc3_.ingredients)
                     {
                        if(_loc5_.objectGID == _loc7_.objectGID && _loc5_.quantity == _loc7_.quantity)
                        {
                           _loc6_ = true;
                           break;
                        }
                        _loc6_ = false;
                     }
                     if(!_loc6_)
                     {
                        _loc4_ = false;
                     }
                  }
                  if(_loc4_)
                  {
                     return _loc3_;
                  }
               }
            }
         }
         return null;
      }
      
      private function getMaxQuantity() : uint
      {
         var _loc4_:ItemWrapper = null;
         var _loc5_:Object = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = this.getSlotsContent();
         var _loc3_:Object = this.storageApi.getViewContent("storage");
         for each(_loc4_ in _loc3_)
         {
            for each(_loc5_ in _loc2_)
            {
               if(_loc4_.objectUID == _loc5_.objectUID)
               {
                  _loc1_.push(Math.floor((_loc4_.quantity + this.storageApi.getItemMaskCount(_loc4_.objectUID,"craft")) / _loc5_.quantity));
               }
            }
         }
         if(_loc1_.length < _loc2_.length)
         {
            return 1;
         }
         _loc1_.sort(Array.DESCENDING | Array.NUMERIC);
         return _loc1_[_loc1_.length - 1];
      }
      
      protected function onConfirmCraftRecipe() : void
      {
         this.switchUI(STEP_CRAFTING);
         this.sysApi.sendAction(new ExchangeReady(true));
      }
      
      protected function onCancelCraftRecipe() : void
      {
      }
      
      private function onPlayerListUpdate(param1:Object) : void
      {
         var _loc2_:Object = param1.componentList;
         this.fillComponents(_loc2_,this._slotsIngredients,this.slot_signature,true);
      }
      
      protected function fillComponents(param1:Object, param2:Object, param3:Object, param4:Boolean = false) : void
      {
         this._updateTimer.reset();
         this._timerBuffer_componentList = param1;
         this._timerBuffer_slotsIngredients = param2;
         this._timerBuffer_slotSignature = param3;
         this.onTimerEvent(null);
      }
      
      protected function onTimerEvent(param1:TimerEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         for each(_loc3_ in this._timerBuffer_slotsIngredients)
         {
            if(_loc3_.data)
            {
               _loc2_ = false;
               for each(_loc4_ in this._timerBuffer_componentList)
               {
                  if(_loc3_.data.objectUID == _loc4_.objectUID)
                  {
                     _loc2_ = true;
                     break;
                  }
               }
               if(!_loc2_)
               {
                  this.storageApi.removeItemMask(_loc3_.data.objectUID,"craft");
               }
               _loc3_.data = null;
            }
         }
         if(this._timerBuffer_slotSignature.data)
         {
            _loc2_ = false;
            for each(_loc4_ in this._timerBuffer_componentList)
            {
               if(this._timerBuffer_slotSignature.data.objectUID == _loc4_.objectUID)
               {
                  _loc2_ = true;
                  break;
               }
            }
            if(!_loc2_)
            {
               this.storageApi.removeItemMask(this._timerBuffer_slotSignature.data.objectUID,"craft");
               this._timerBuffer_slotSignature.data = null;
            }
         }
         for each(_loc4_ in this._timerBuffer_componentList)
         {
            this.storageApi.addItemMask(_loc4_.objectUID,"craft",_loc4_.quantity);
            if(this.isValidContent(this._timerBuffer_slotSignature,_loc4_))
            {
               this._timerBuffer_slotSignature.data = _loc4_;
            }
            else
            {
               this.getFirstEmptySlot(this._timerBuffer_slotsIngredients).data = _loc4_;
            }
         }
         this.storageApi.releaseHooks();
         if(this.checkRecipe())
         {
            this.switchUI(STEP_RECIPE_KNOWN,true);
         }
         else
         {
            this.switchUI(STEP_RECIPE_UNKNOWN,true);
         }
      }
      
      protected function onExchangeCraftResult(param1:uint, param2:Object) : void
      {
         switch(param1)
         {
            case CraftResultEnum.CRAFT_IMPOSSIBLE:
               if(!param2)
               {
                  this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.craft.noResult"),[this.uiApi.getText("ui.common.ok")]);
               }
               else
               {
                  this.modCommon.openPopup(this.uiApi.getText("ui.common.error"),this.uiApi.getText("ui.skill.levelLow",this._jobLevel),[this.uiApi.getText("ui.common.ok")]);
               }
               this.switchUI(STEP_CRAFT_STOPPED);
               break;
            case CraftResultEnum.CRAFT_SUCCESS:
               this._itemToCraft = param2;
               this.switchUI(STEP_CRAFT_ENDED);
         }
      }
      
      protected function onExchangeItemAutoCraftStoped(param1:uint) : void
      {
         switch(param1)
         {
            case ExchangeReplayStopReasonEnum.STOPPED_REASON_OK:
               this.switchUI(STEP_CRAFT_ENDED);
               break;
            case ExchangeReplayStopReasonEnum.STOPPED_REASON_MISSING_RESSOURCE:
               this.switchUI(STEP_CRAFT_ENDED);
               break;
            case ExchangeReplayStopReasonEnum.STOPPED_REASON_IMPOSSIBLE_MODIFICATION:
               this.switchUI(STEP_CRAFT_STOPPED);
         }
      }
      
      protected function onExchangeReplayCountModified(param1:int) : void
      {
         this.setQuantity(param1,true);
      }
      
      private function onExchangeLeave(param1:Boolean) : void
      {
         this.uiApi.unloadUi(this.uiApi.me().name);
      }
      
      protected function onRecipeSelected(param1:Recipe, param2:int) : void
      {
         if(param2 == this._jobId)
         {
            this.fillRecipeIngredients(param1);
         }
      }
      
      protected function fillRecipeIngredients(param1:Recipe) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc2_:Array = new Array();
         var _loc3_:Boolean = this.isRecipeFull(param1,_loc2_);
         this._recipesUi.uiClass.disabled = true;
         this._disableRecipiesTimer.delay = 300 * _loc2_.length;
         this._disableRecipiesTimer.start();
         this.removeAllItems();
         if(!_loc3_)
         {
            for each(_loc4_ in _loc2_)
            {
               for each(_loc5_ in _loc4_)
               {
                  this.sysApi.sendAction(new ExchangeObjectMove(_loc5_.objectUID,_loc5_.quantity));
               }
            }
         }
         else
         {
            this.sysApi.sendAction(new ExchangeSetCraftRecipe(param1.resultId));
         }
      }
      
      protected function isRecipeFull(param1:Object, param2:Array) : Boolean
      {
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc3_:Boolean = true;
         for each(_loc4_ in param1.ingredients)
         {
            _loc5_ = this.inventoryApi.getStorageObjectGID(_loc4_.objectGID,_loc4_.quantity);
            if(_loc5_ == null)
            {
               _loc3_ = false;
            }
            else
            {
               param2.push(_loc5_);
            }
         }
         if(!_loc3_)
         {
            this.modCommon.openPopup(this.uiApi.getText("ui.popup.warning"),this.uiApi.getText("ui.craft.dontHaveAllIngredient"),[this.uiApi.getText("ui.common.ok")]);
         }
         return _loc3_;
      }
      
      private function onDisableRecipiesTimer(param1:TimerEvent) : void
      {
         this._recipesUi.uiClass.disabled = false;
      }
      
      private function onExchangeObjectAdded(param1:Object, param2:Object) : void
      {
         if(this.checkRecipe())
         {
            this.switchUI(STEP_RECIPE_KNOWN,true);
         }
         else
         {
            this.switchUI(STEP_RECIPE_UNKNOWN,true);
         }
      }
      
      private function onJobLevelUp(param1:uint, param2:String, param3:uint) : void
      {
         if(param1 == this._jobId)
         {
            this.lbl_job.text = param2 + this._lvlText + param3;
            if(param3 == ProtocolConstantsEnum.MAX_JOB_LEVEL)
            {
               this.ctr_signature.visible = true;
            }
            this._jobLevel = param3;
            if(this.storageApi.getIsCraftFilterEnabled())
            {
               this.storageApi.enableCraftFilter(this._skill,this._jobLevel);
            }
         }
      }
      
      protected function onJobsExpUpdated(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         if(param1 == this._jobId)
         {
            this._updatedJob = this.jobsApi.getKnownJob(this._jobId);
            this._jobXP = this._updatedJob.jobXP;
            this._jobXpLevelFloor = this._updatedJob.jobXpLevelFloor;
            this._jobXpNextLevelFloor = this._updatedJob.jobXpNextLevelFloor;
            _loc2_ = (this._jobXP - this._jobXpLevelFloor) / (this._jobXpNextLevelFloor - this._jobXpLevelFloor);
            if(_loc2_ > 1 || this._jobXpNextLevelFloor == 0)
            {
               _loc2_ = 1;
            }
            this.pb_progressBar.value = _loc2_;
         }
      }
      
      public function onObjectSelected(param1:Object) : void
      {
      }
      
      private function onValidQty(param1:Number) : void
      {
         this.unfillSlot(this._waitingSlot,param1);
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         switch(param1)
         {
            case this.lbl_quantity:
               _loc3_ = this.getMaxQuantity();
               this.modCommon.openQuantityPopup(1,_loc3_,_loc3_,this.onValidCraftItemQty);
               break;
            case this.btn_quantity_up:
               _loc3_ = this.getMaxQuantity();
               _loc2_ = this.itemQuantity;
               if(_loc2_ < _loc3_ || _loc3_ == 0)
               {
                  this.sysApi.sendAction(new ExchangeReplay(_loc2_ + 1));
               }
               break;
            case this.btn_quantity_down:
               _loc2_ = this.itemQuantity;
               if(_loc2_ > 1)
               {
                  this.sysApi.sendAction(new ExchangeReplay(_loc2_ - 1));
               }
               break;
            case this.btn_ok:
               if(this.getSlotsContent().length > 0)
               {
                  this.onConfirmCraftRecipe();
               }
               break;
            case this.btn_close:
               this.sysApi.sendAction(new LeaveDialogRequest());
               break;
            case this.ed_player:
               this.sysApi.sendAction(new DisplayContextualMenu(this.playerApi.id()));
               break;
            default:
               if(param1.name.indexOf("slot") != -1 && param1.data)
               {
                  this.onObjectSelected(param1);
               }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 == this.pb_progressBar || param1 == this.pb_progressBar_other)
         {
            if(this._jobXpNextLevelFloor == 0)
            {
               _loc2_ = this.uiApi.getText("ui.craft.crafterExperience") + this.uiApi.getText("ui.common.colon") + this.utilApi.kamasToString(this._jobXP,"");
            }
            else
            {
               _loc2_ = this.uiApi.getText("ui.craft.crafterExperience") + this.uiApi.getText("ui.common.colon") + this.utilApi.kamasToString(this._jobXP,"") + " / " + this.utilApi.kamasToString(this._jobXpNextLevelFloor,"");
            }
            this.uiApi.showTooltip(this.uiApi.textTooltipInfo(_loc2_),param1,false,"standard",7,1,3,null,null,null,"TextInfo");
         }
         else if(param1.data)
         {
            this.uiApi.showTooltip(param1.data,param1,false,"standard",8,0,0,"itemName",null,{
               "showEffects":true,
               "header":true
            },"ItemInfo");
         }
      }
      
      public function onRollOut(param1:Object) : void
      {
         this.uiApi.hideTooltip();
      }
      
      public function onDoubleClick(param1:Object) : void
      {
         if(param1.data)
         {
            this.unfillSlot(param1,1);
         }
      }
      
      private function onMouseCtrlDoubleClick(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         if(param1.data)
         {
            _loc2_ = false;
            for each(_loc3_ in this._slotsIngredients)
            {
               if(_loc3_ == param1)
               {
                  _loc2_ = true;
               }
            }
            if(!_loc2_)
            {
               return;
            }
            this.unfillSlot(param1,-1);
         }
      }
      
      private function onMouseAltDoubleClick(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Object = null;
         if(param1.data)
         {
            _loc2_ = false;
            for each(_loc3_ in this._slotsIngredients)
            {
               if(_loc3_ == param1)
               {
                  _loc2_ = true;
               }
            }
            if(!_loc2_)
            {
               return;
            }
            this._waitingSlot = param1;
            this.modCommon.openQuantityPopup(1,param1.data.quantity,param1.data.quantity,this.onValidQty);
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(param1 == this.ed_player)
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
         if(this.dropValidatorFunction(this.slot_signature,param1.data,null))
         {
            this.slot_signature.selected = true;
         }
         else
         {
            for each(_loc2_ in this._slotsIngredients)
            {
               if(this.dropValidatorFunction(_loc2_,param1.data,null))
               {
                  _loc2_.selected = true;
               }
            }
         }
      }
      
      private function onDropEnd(param1:Object) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._slotsIngredients)
         {
            _loc2_.selected = false;
         }
         this.slot_signature.selected = false;
      }
      
      public function set slotsIngredients(param1:Array) : void
      {
         this._slotsIngredients = param1;
      }
   }
}
