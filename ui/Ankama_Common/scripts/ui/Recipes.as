package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.jobs.Recipe;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobExperience;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.PlayedCharacterApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import d2actions.ExchangeObjectTransfertListWithQuantityToInv;
   import d2enums.ComponentHookList;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.SelectMethodEnum;
   import d2hooks.InventoryContent;
   import d2hooks.JobLevelUp;
   import d2hooks.JobSelected;
   import d2hooks.JobsExpOtherPlayerUpdated;
   import d2hooks.KeyUp;
   import d2hooks.RecipeSelected;
   import d2hooks.RecipesListRefreshed;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import ui.items.RecipesFilterWrapper;
   
   public class Recipes
   {
      
      private static var _uriMissingIngredients:Object;
      
      private static var _uriNoIngredients:Object;
      
      private static var _uriBagIngredients:Object;
      
      private static var _uriMissingIngredientsSlot:Object;
      
      private static var _uriNoIngredientsSlot:Object;
      
      private static var _uriBagIngredientsSlot:Object;
      
      public static const MAX_JOB_LEVEL_GAP:int = 100;
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var playerApi:PlayedCharacterApi;
      
      public var storageApi:StorageApi;
      
      public var utilApi:UtilApi;
      
      public var dataApi:DataApi;
      
      public var jobApi:JobsApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var menuApi:ContextMenuApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var mainCtr:GraphicContainer;
      
      public var inp_search:Input;
      
      public var inp_minLevelSearch:Input;
      
      public var inp_maxLevelSearch:Input;
      
      public var cb_type:ComboBox;
      
      public var gd_recipes:Grid;
      
      public var lbl_noRecipe:Label;
      
      public var chk_possibleRecipes:ButtonContainer;
      
      private var _jobs:Array;
      
      private var _recipeResultTypeByJobId:Array;
      
      private var _currentJob:KnownJobWrapper;
      
      private var _currentSkillId:int = 0;
      
      private var _recipeTypes:Array;
      
      private var _jobsLevel:Array;
      
      private var _useJobLevelInsteadOfMaxFilter:Boolean = false;
      
      private var _currentRecipesFilter:RecipesFilterWrapper;
      
      private var _searchCriteria:String;
      
      private var _lockSearchTimer:Timer;
      
      private var _sortCriteria:String = "level";
      
      private var _ingredientsToleranceFilter:int = 8;
      
      private var _inventoryDataByGID:Dictionary;
      
      private var _recipes:Object;
      
      private var _gridComponentsList:Dictionary;
      
      private var _matsCountModeActivated:Boolean = false;
      
      private var _currentRecipe:Recipe;
      
      private var _canTransfertItems:Boolean;
      
      private var _storageType:String;
      
      public function Recipes()
      {
         this._jobs = new Array();
         this._recipeResultTypeByJobId = new Array();
         this._recipeTypes = new Array();
         this._jobsLevel = new Array();
         this._inventoryDataByGID = new Dictionary(true);
         this._gridComponentsList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object) : void
      {
         var _loc3_:* = null;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:Item = null;
         var _loc7_:Object = null;
         var _loc8_:Skill = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.sysApi.addHook(JobSelected,this.onJobSelected);
         this.sysApi.addHook(InventoryContent,this.onInventoryUpdate);
         this.sysApi.addHook(JobLevelUp,this.onJobLevelUp);
         this.sysApi.addHook(JobsExpOtherPlayerUpdated,this.onJobsExpOtherPlayerUpdated);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.inp_search,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.inp_minLevelSearch,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.inp_minLevelSearch,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.inp_maxLevelSearch,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.inp_maxLevelSearch,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.cb_type,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.gd_recipes,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.chk_possibleRecipes,ComponentHookList.ON_RELEASE);
         this.uiApi.addShortcutHook("validUi",this.onShortcut);
         this._lockSearchTimer = new Timer(1000,1);
         this._lockSearchTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
         this.inp_minLevelSearch.restrictChars = "0-9";
         this.inp_maxLevelSearch.restrictChars = "0-9";
         if(!_uriMissingIngredientsSlot)
         {
            _loc9_ = this.uiApi.me().getConstant("slot");
            _uriMissingIngredients = this.uiApi.createUri(_loc9_ + "iconInterrogation.png");
            _uriNoIngredients = this.uiApi.createUri(_loc9_ + "iconFailure.png");
            _uriBagIngredients = this.uiApi.createUri(_loc9_ + "iconValid.png");
            _uriMissingIngredientsSlot = this.uiApi.createUri(_loc9_ + "slotYellow.png");
            _uriNoIngredientsSlot = this.uiApi.createUri(_loc9_ + "slotRed.png");
            _uriBagIngredientsSlot = this.uiApi.createUri(_loc9_ + "slotGreen.png");
         }
         this._storageType = param1.storage;
         this._canTransfertItems = this._storageType == "bankUi";
         if(param1.jobId != 0)
         {
            this._jobsLevel[param1.jobId] = param1.jobLevel;
            if(param1.jobLevel != this.jobApi.getKnownJob(param1.jobId).jobLevel && this.uiApi.me().name == "recipesCraft")
            {
               this._useJobLevelInsteadOfMaxFilter = true;
            }
         }
         var _loc2_:Object = this.jobApi.getInventoryData(this._canTransfertItems);
         for(_loc3_ in _loc2_)
         {
            this._inventoryDataByGID[int(_loc3_)] = _loc2_[_loc3_];
         }
         _loc4_ = this.dataApi.getSkills();
         _loc5_ = new Array();
         for each(_loc8_ in _loc4_)
         {
            if(_loc8_.craftableItemIds && _loc8_.craftableItemIds.length > 0)
            {
               if(_loc5_.indexOf(_loc8_.parentJobId) == -1)
               {
                  _loc5_.push(_loc8_.parentJobId);
                  for each(_loc10_ in _loc8_.craftableItemIds)
                  {
                     if(!this._recipeResultTypeByJobId[_loc8_.parentJobId])
                     {
                        this._recipeResultTypeByJobId[_loc8_.parentJobId] = new Array();
                     }
                     _loc6_ = this.dataApi.getItem(_loc10_);
                     _loc7_ = {
                        "id":_loc6_.typeId,
                        "name":_loc6_.type.name
                     };
                     if(this._recipeResultTypeByJobId[_loc8_.parentJobId].indexOf(_loc7_) == -1)
                     {
                        this._recipeResultTypeByJobId[_loc8_.parentJobId].push(_loc7_);
                     }
                  }
               }
            }
         }
         if(param1.hasOwnProperty("matsCountMode"))
         {
            this._matsCountModeActivated = param1.matsCountMode;
         }
         this.onJobSelected(param1.jobId,param1.skillId,this.uiApi.me().name);
      }
      
      public function unload() : void
      {
         this._lockSearchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTimeOut);
         this._lockSearchTimer.stop();
         this._lockSearchTimer = null;
         this._inventoryDataByGID = null;
         this._recipes = null;
         this._currentJob = null;
         this._currentRecipe = null;
         this._storageType = null;
         if(this.uiApi.getUi("quantityPopup"))
         {
            this.uiApi.unloadUi("quantityPopup");
         }
         this.uiApi.hideTooltip();
      }
      
      public function set disabled(param1:Boolean) : void
      {
         this.gd_recipes.disabled = param1;
      }
      
      public function get disabled() : Boolean
      {
         return this.gd_recipes.disabled;
      }
      
      public function getJobLevel(param1:int = 0) : int
      {
         if(param1 == 0)
         {
            if(this._currentJob)
            {
               param1 = this._currentJob.id;
            }
            else
            {
               this.sysApi.log(16,"Something\'s wrong here, no jobId and no currentJob.");
               return 1;
            }
         }
         if(this._jobsLevel[param1] > 0)
         {
            return this._jobsLevel[param1];
         }
         if(this._currentJob)
         {
            return this._currentJob.jobLevel;
         }
         this._jobsLevel[param1] = this.jobApi.getKnownJob(param1).jobLevel;
         return this._jobsLevel[param1];
      }
      
      public function updateRecipeLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:KnownJobWrapper = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Object = null;
         var _loc4_:uint = getTimer();
         if(param1)
         {
            _loc5_ = 1;
            while(_loc5_ < 9)
            {
               if(!this._gridComponentsList[param2["slot" + _loc5_].name])
               {
                  this.uiApi.addComponentHook(param2["slot" + _loc5_],ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2["slot" + _loc5_],ComponentHookList.ON_ROLL_OUT);
                  this.uiApi.addComponentHook(param2["slot" + _loc5_],ComponentHookList.ON_RELEASE);
                  this.uiApi.addComponentHook(param2["slot" + _loc5_],ComponentHookList.ON_RIGHT_CLICK);
                  this.uiApi.addComponentHook(param2["tx_ingredientStateIcon" + _loc5_],ComponentHookList.ON_ROLL_OVER);
                  this.uiApi.addComponentHook(param2["tx_ingredientStateIcon" + _loc5_],ComponentHookList.ON_ROLL_OUT);
               }
               if(param1 && param1.ingredients && param1.ingredients.length >= _loc5_)
               {
                  _loc16_ = param1.ingredients[_loc5_ - 1];
               }
               this._gridComponentsList[param2["slot" + _loc5_].name] = _loc16_;
               _loc5_++;
            }
            if(!this._gridComponentsList[param2.slot_craftedItem.name])
            {
               this.uiApi.addComponentHook(param2.slot_craftedItem,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.slot_craftedItem,ComponentHookList.ON_ROLL_OUT);
               this.uiApi.addComponentHook(param2.slot_craftedItem,ComponentHookList.ON_RELEASE);
               this.uiApi.addComponentHook(param2.slot_craftedItem,ComponentHookList.ON_RIGHT_CLICK);
            }
            this._gridComponentsList[param2.slot_craftedItem.name] = param1.result;
            if(!this._gridComponentsList[param2.tx_background.name])
            {
               this.uiApi.addComponentHook(param2.tx_background,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.tx_background,ComponentHookList.ON_ROLL_OUT);
            }
            this._gridComponentsList[param2.tx_background.name] = param1;
            if(!this._gridComponentsList[param2.btn_getItems.name])
            {
               this.uiApi.addComponentHook(param2.btn_getItems,ComponentHookList.ON_RELEASE);
               this.uiApi.addComponentHook(param2.btn_getItems,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.btn_getItems,ComponentHookList.ON_ROLL_OUT);
            }
            this._gridComponentsList[param2.btn_getItems.name] = param1;
            param2.lbl_name.text = param1.result.name;
            if(!this._currentJob)
            {
               _loc6_ = this.jobApi.getKnownJob(param1.jobId);
               param2.lbl_job.text = _loc6_.name + " " + this.uiApi.getText("ui.common.short.level").toLocaleLowerCase() + " " + param1.result.level;
            }
            else
            {
               param2.lbl_job.text = this.uiApi.getText("ui.common.short.level") + " " + param1.result.level;
            }
            _loc7_ = param1.ingredients;
            _loc8_ = this.getJobLevel(param1.jobId);
            if(this._currentJob && param1.result.level > _loc8_)
            {
               param2.ctr_main.greyedOut = true;
            }
            else
            {
               param2.ctr_main.greyedOut = false;
            }
            if(_loc8_ < param1.result.level)
            {
               _loc8_ = param1.result.level;
            }
            _loc9_ = this.jobApi.getCraftXp(param1.result,_loc8_);
            param2.lbl_xp.text = this.uiApi.getText("ui.tooltip.monsterXpAlone",_loc9_);
            param2.slot_craftedItem.data = param1.result;
            param2.slot_craftedItem.visible = param2.tx_slot_background.visible = true;
            if(!this._matsCountModeActivated)
            {
               _loc5_ = 1;
               while(_loc5_ <= _loc7_.length)
               {
                  param2["slot" + _loc5_].data = _loc7_[_loc5_ - 1];
                  param2["slot" + _loc5_].mouseEnabled = true;
                  param2["slot" + _loc5_].visible = true;
                  _loc5_++;
               }
               while(_loc5_ < 9)
               {
                  param2["slot" + _loc5_].data = null;
                  param2["slot" + _loc5_].mouseEnabled = false;
                  param2["slot" + _loc5_].visible = false;
                  _loc5_++;
               }
               return;
            }
            _loc10_ = this.getActualMaxOccurence(param1.resultId);
            param2.lbl_maxCraftQuantity.text = "x" + _loc10_;
            _loc5_ = 1;
            _loc12_ = _loc7_.length + 1;
            _loc14_ = false;
            while(_loc5_ < _loc12_)
            {
               _loc11_ = _loc5_ - 1;
               _loc15_ = this.itemIsInBag(param1.ingredientIds[_loc11_]);
               _loc13_ = this.getItemTotalQty(_loc7_[_loc11_].objectGID);
               param2["slot" + _loc5_].data = _loc7_[_loc11_];
               param2["slot" + _loc5_].mouseEnabled = true;
               param2["slot" + _loc5_].visible = true;
               if(!_loc13_)
               {
                  param2["tx_ingredientStateIcon" + _loc5_].uri = _uriNoIngredients;
                  param2["slot" + _loc5_].customTexture = _uriNoIngredientsSlot;
                  param2["slot" + _loc5_].selectedTexture = _uriNoIngredientsSlot;
                  param2["slot" + _loc5_].highlightTexture = _uriNoIngredientsSlot;
               }
               else if(_loc13_ < param1.quantities[_loc11_])
               {
                  param2["tx_ingredientStateIcon" + _loc5_].uri = _uriMissingIngredients;
                  param2["slot" + _loc5_].customTexture = _uriMissingIngredientsSlot;
                  param2["slot" + _loc5_].selectedTexture = _uriMissingIngredientsSlot;
                  param2["slot" + _loc5_].highlightTexture = _uriMissingIngredientsSlot;
                  if(!_loc15_)
                  {
                     _loc14_ = true;
                  }
               }
               else if(_loc15_)
               {
                  param2["tx_ingredientStateIcon" + _loc5_].uri = _uriBagIngredients;
                  param2["slot" + _loc5_].customTexture = _uriBagIngredientsSlot;
                  param2["slot" + _loc5_].selectedTexture = _uriBagIngredientsSlot;
                  param2["slot" + _loc5_].highlightTexture = _uriBagIngredientsSlot;
               }
               else
               {
                  param2["tx_ingredientStateIcon" + _loc5_].uri = null;
                  param2["slot" + _loc5_].customTexture = null;
                  param2["slot" + _loc5_].selectedTexture = null;
                  param2["slot" + _loc5_].highlightTexture = null;
                  _loc14_ = true;
               }
               _loc5_++;
            }
            _loc5_ = _loc12_;
            while(_loc5_ < 9)
            {
               param2["tx_ingredientStateIcon" + _loc5_].uri = null;
               param2["slot" + _loc5_].customTexture = null;
               param2["slot" + _loc5_].selectedTexture = null;
               param2["slot" + _loc5_].highlightTexture = null;
               param2["slot" + _loc5_].data = null;
               param2["slot" + _loc5_].mouseEnabled = false;
               param2["slot" + _loc5_].visible = false;
               _loc5_++;
            }
            param2.btn_getItems.visible = this.canTransfertItems && _loc14_;
         }
         else
         {
            param2.slot_craftedItem.data = null;
            param2.slot_craftedItem.visible = param2.tx_slot_background.visible = false;
            _loc5_ = 1;
            while(_loc5_ < 9)
            {
               param2["tx_ingredientStateIcon" + _loc5_].uri = null;
               param2["slot" + _loc5_].customTexture = null;
               param2["slot" + _loc5_].selectedTexture = null;
               param2["slot" + _loc5_].highlightTexture = null;
               param2["slot" + _loc5_].mouseEnabled = false;
               param2["slot" + _loc5_].visible = false;
               param2["slot" + _loc5_].data = null;
               this._gridComponentsList[param2["slot" + _loc5_].name] = null;
               _loc5_++;
            }
            param2.lbl_xp.text = "";
            param2.lbl_name.text = "";
            param2.lbl_job.text = "";
            param2.lbl_maxCraftQuantity.text = "";
            param2.ctr_main.softDisabled = false;
            param2.ctr_main.greyedOut = false;
            param2.btn_getItems.visible = false;
         }
      }
      
      public function set ingredientsToleranceFilter(param1:int) : void
      {
         this._ingredientsToleranceFilter = param1;
         this.updateRecipes(true);
      }
      
      public function switchSort(param1:String = "level") : void
      {
         this._sortCriteria = param1;
         this.gd_recipes.dataProvider = this.jobApi.sortRecipesByCriteria(this.gd_recipes.dataProvider,this._sortCriteria,false);
      }
      
      public function get canTransfertItems() : Boolean
      {
         return this._canTransfertItems;
      }
      
      public function get storageType() : String
      {
         return this._storageType;
      }
      
      public function itemIsInBag(param1:int) : Boolean
      {
         var _loc2_:Object = this._inventoryDataByGID[param1];
         if(!_loc2_ || !_loc2_.fromBag)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.fromBag.length)
         {
            if(!_loc2_.fromBag[_loc3_])
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      public function getActualMaxOccurence(param1:int) : uint
      {
         var _loc2_:int = 0;
         if(this._inventoryDataByGID[param1])
         {
            _loc2_ = this._inventoryDataByGID[param1].actualMaxOccurence;
         }
         return _loc2_;
      }
      
      public function getPotentialMaxOccurence(param1:int) : uint
      {
         var _loc2_:int = 0;
         if(this._inventoryDataByGID[param1])
         {
            _loc2_ = this._inventoryDataByGID[param1].potentialMaxOccurence;
         }
         return _loc2_;
      }
      
      public function getPossibleMaxOccurence(param1:int) : uint
      {
         var _loc3_:Recipe = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:int = 0;
         if(this._inventoryDataByGID[param1])
         {
            _loc3_ = this.jobApi.getRecipe(param1);
            _loc4_ = new Array();
            _loc5_ = 0;
            _loc7_ = 0;
            while(_loc7_ < _loc3_.ingredientIds.length)
            {
               _loc6_ = this._inventoryDataByGID[_loc3_.ingredientIds[_loc7_]];
               _loc5_ = 0;
               if(_loc6_ && _loc6_.stackQtyList)
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc6_.stackQtyList.length)
                  {
                     if(!_loc6_.fromBag[_loc8_])
                     {
                        _loc5_ = _loc5_ + _loc6_.stackQtyList[_loc8_];
                     }
                     _loc8_++;
                  }
                  _loc4_.push(int(_loc5_ / _loc3_.quantities[_loc7_]));
               }
               else
               {
                  _loc4_.push(0);
               }
               _loc7_++;
            }
            _loc4_.sort(Array.NUMERIC);
            _loc2_ = _loc4_[_loc4_.length - 1];
         }
         if(_loc2_ == 0)
         {
            _loc2_ = 1;
         }
         return _loc2_;
      }
      
      public function getItemTotalQty(param1:int) : int
      {
         var _loc2_:int = 0;
         if(this._inventoryDataByGID[param1])
         {
            _loc2_ = this._inventoryDataByGID[param1].totalQuantity;
         }
         return _loc2_;
      }
      
      public function requestIngredientsTransfert(param1:Recipe) : void
      {
         this._currentRecipe = param1;
         var _loc2_:uint = this.getPossibleMaxOccurence(param1.resultId);
         var _loc3_:uint = this.getPotentialMaxOccurence(param1.resultId);
         this.modCommon.openQuantityPopup(1,_loc2_,_loc3_,this.onValidRecipeMax);
      }
      
      private function updateRecipes(param1:Boolean = true) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:Recipe = null;
         var _loc9_:Boolean = false;
         if(param1)
         {
            this._recipes = this.jobApi.getRecipesByJob(this._inventoryDataByGID,this._currentSkillId,!!this._currentJob?int(this._currentJob.id):0,this._canTransfertItems,this._ingredientsToleranceFilter);
            this._recipeTypes = new Array();
            this._recipes = this.jobApi.getJobFilteredRecipes(this._recipes,this._recipeTypes,this._currentRecipesFilter.minLevel,this._currentRecipesFilter.maxLevel,this._searchCriteria,this._currentRecipesFilter.typeId);
            this.jobApi.sortRecipesByCriteria(this._recipes,this._sortCriteria,false);
            _loc2_ = new Array();
            _loc3_ = new Array();
            _loc4_ = 0;
            _loc5_ = 1;
            _loc2_.push({
               "label":this.uiApi.getText("ui.common.allTypesForObject"),
               "id":0
            });
            this._recipeTypes.sortOn("name",Array.CASEINSENSITIVE);
            for each(_loc6_ in this._recipeTypes)
            {
               if(_loc3_.indexOf(_loc6_.id) == -1)
               {
                  _loc2_.push({
                     "label":_loc6_.name,
                     "id":_loc6_.id
                  });
                  _loc3_.push(_loc6_.id);
                  if(_loc6_.id == this._currentRecipesFilter.typeId)
                  {
                     _loc4_ = _loc5_;
                  }
                  _loc5_++;
               }
            }
            this.cb_type.dataProvider = _loc2_;
            this.cb_type.selectedIndex = _loc4_;
         }
         if(this.chk_possibleRecipes.selected)
         {
            _loc7_ = new Array();
            for each(_loc8_ in this._recipes)
            {
               if((this._currentJob && _loc8_.jobId == this._currentJob.id || !this._currentJob) && _loc8_.resultLevel <= this.getJobLevel(_loc8_.jobId))
               {
                  _loc9_ = true;
                  _loc5_ = 0;
                  while(_loc5_ < _loc8_.ingredientIds.length)
                  {
                     if(!this._inventoryDataByGID[_loc8_.ingredientIds[_loc5_]] || !this._inventoryDataByGID[_loc8_.ingredientIds[_loc5_]].totalQuantity || this._inventoryDataByGID[_loc8_.ingredientIds[_loc5_]].totalQuantity < _loc8_.quantities[_loc5_])
                     {
                        _loc9_ = false;
                        break;
                     }
                     _loc5_++;
                  }
                  if(_loc9_)
                  {
                     _loc7_.push(_loc8_);
                  }
               }
            }
            this.fillRecipesGrid(_loc7_);
         }
         else
         {
            this.fillRecipesGrid(this._recipes);
         }
      }
      
      private function fillRecipesGrid(param1:Object) : void
      {
         this.gd_recipes.dataProvider = param1;
         if(!param1 || param1.length == 0)
         {
            this.lbl_noRecipe.visible = true;
            this.gd_recipes.alpha = 0.2;
         }
         else
         {
            this.lbl_noRecipe.visible = false;
            this.gd_recipes.alpha = 1;
         }
         this.sysApi.dispatchHook(RecipesListRefreshed,param1.length);
      }
      
      private function onValidRecipeMax(param1:Number) : void
      {
         var _loc6_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc2_:Vector.<uint> = new Vector.<uint>();
         var _loc3_:Vector.<uint> = new Vector.<uint>();
         var _loc4_:Vector.<uint> = new Vector.<uint>();
         var _loc5_:int = this._currentRecipe.ingredientIds.length;
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc4_.push(this._currentRecipe.quantities[_loc7_] * param1);
            _loc6_ = this._inventoryDataByGID[this._currentRecipe.ingredientIds[_loc7_]];
            if(!(!_loc6_ || !_loc6_.totalQuantity))
            {
               _loc8_ = 0;
               _loc9_ = 0;
               _loc10_ = _loc6_.stackUidList.length;
               _loc11_ = 0;
               while(_loc11_ < _loc10_)
               {
                  if(!_loc6_.fromBag[_loc11_])
                  {
                     _loc2_.push(_loc6_.stackUidList[_loc11_]);
                     _loc9_ = _loc6_.stackQtyList[_loc11_];
                     if(!_loc8_ && _loc9_ >= _loc4_[_loc7_])
                     {
                        _loc3_.push(_loc4_[_loc7_]);
                        break;
                     }
                     if(_loc8_ < _loc4_[_loc7_])
                     {
                        if(_loc8_ + _loc9_ == _loc4_[_loc7_])
                        {
                           _loc3_.push(_loc9_);
                           _loc8_ = _loc8_ + _loc9_;
                           break;
                        }
                        if(_loc8_ + _loc9_ > _loc4_[_loc7_])
                        {
                           _loc3_.push(_loc4_[_loc7_] - _loc8_);
                           _loc8_ = _loc4_[_loc7_];
                           break;
                        }
                        _loc3_.push(_loc9_);
                        _loc8_ = _loc8_ + _loc9_;
                     }
                  }
                  _loc11_++;
               }
            }
            _loc7_++;
         }
         this.sysApi.sendAction(new ExchangeObjectTransfertListWithQuantityToInv(_loc2_,_loc3_));
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Recipe = null;
         switch(param1)
         {
            case this.inp_search:
               if(this.inp_search.text == this.uiApi.getText("ui.common.search.input"))
               {
                  this.inp_search.text = "";
               }
               break;
            case this.chk_possibleRecipes:
               this.updateRecipes(false);
         }
         if(param1.name.indexOf("btn_getItems") != -1)
         {
            _loc2_ = this._gridComponentsList[param1.name];
            if(_loc2_)
            {
               this.requestIngredientsTransfert(_loc2_);
            }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         switch(param1)
         {
            case this.inp_search:
               _loc2_ = this.uiApi.getText("ui.common.searchFilterTooltip");
               break;
            case this.inp_minLevelSearch:
               _loc2_ = this.uiApi.getText("ui.craft.minRecipeLevel");
               break;
            case this.inp_maxLevelSearch:
               _loc2_ = this.uiApi.getText("ui.craft.maxRecipeLevel");
         }
         if(param1.name.indexOf("tx_background") == 0)
         {
            _loc3_ = this._gridComponentsList[param1.name];
            if(_loc3_)
            {
               if(this.getJobLevel(_loc3_.jobId) < _loc3_.result.level)
               {
                  _loc2_ = this.uiApi.getText("ui.jobs.difficulty3");
               }
               else if(this.getJobLevel(_loc3_.jobId) > _loc3_.result.level + MAX_JOB_LEVEL_GAP)
               {
                  _loc2_ = this.uiApi.getText("ui.jobs.difficulty1");
               }
            }
         }
         else
         {
            if(param1.name.indexOf("slot") == 0)
            {
               _loc3_ = this._gridComponentsList[param1.name];
               if(_loc3_)
               {
                  this.uiApi.showTooltip(_loc3_,param1,false,"standard",6,2,3,"itemName",null,{
                     "showEffects":true,
                     "header":true
                  },"ItemInfo");
               }
               return;
            }
            if(param1.name.indexOf("btn_getItems") == 0)
            {
               _loc3_ = this._gridComponentsList[param1.name];
               if(_loc3_)
               {
                  _loc2_ = this.uiApi.getText("ui.craft.transfertIngredients",this.getPotentialMaxOccurence(_loc3_.resultId));
               }
            }
            else if(param1.name.indexOf("tx_ingredientStateIcon") == 0)
            {
               if(param1.uri)
               {
                  if(param1.uri.fileName == _uriNoIngredients.fileName)
                  {
                     _loc2_ = this.uiApi.getText("ui.craft.noIngredient");
                  }
                  else if(param1.uri.fileName == _uriMissingIngredients.fileName)
                  {
                     _loc2_ = this.uiApi.getText("ui.craft.ingredientNotEnough");
                  }
                  else if(param1.uri.fileName == _uriBagIngredients.fileName)
                  {
                     _loc2_ = this.uiApi.getText("ui.craft.ingredientInBag");
                  }
               }
            }
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
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         switch(param1)
         {
            case this.gd_recipes:
               if(param2 != SelectMethodEnum.AUTO && this._currentJob)
               {
                  _loc4_ = this.gd_recipes.selectedItem;
                  this.sysApi.dispatchHook(RecipeSelected,_loc4_,this._currentJob.id);
               }
               break;
            case this.cb_type:
               if(!param3 || this._currentRecipesFilter.typeId == this.cb_type.selectedItem.id)
               {
                  return;
               }
               this._currentRecipesFilter.typeId = this.cb_type.selectedItem.id;
               Common.getInstance().setJobSearchOptionsByJobId(this._currentRecipesFilter);
               this.updateRecipes();
               break;
         }
      }
      
      public function onRightClick(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Object = this._gridComponentsList[param1.name];
         if(_loc2_)
         {
            _loc3_ = this.menuApi.create(_loc2_);
            if(_loc3_.content.length > 0)
            {
               this.modContextMenu.createContextMenu(_loc3_);
            }
         }
      }
      
      public function onShortcut(param1:String) : Boolean
      {
         if(this.inp_search.haveFocus)
         {
            this._searchCriteria = this.inp_search.text.toLowerCase();
            if(!this._searchCriteria.length)
            {
               this._searchCriteria = null;
            }
            this.updateRecipes();
            return true;
         }
         return false;
      }
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this.inp_search.haveFocus || this.inp_minLevelSearch.haveFocus || this.inp_maxLevelSearch.haveFocus)
         {
            this._lockSearchTimer.reset();
            this._lockSearchTimer.start();
         }
      }
      
      public function onTimeOut(param1:TimerEvent) : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:Boolean = false;
         if(this.inp_search.text != this.uiApi.getText("ui.common.search.input"))
         {
            if(this.inp_search.text.length > 2)
            {
               _loc5_ = this.inp_search.text.toLowerCase();
               if(this._searchCriteria != _loc5_)
               {
                  this._searchCriteria = this.inp_search.text.toLowerCase();
                  _loc2_ = true;
               }
            }
            else
            {
               if(this._searchCriteria)
               {
                  this._searchCriteria = null;
               }
               if(this.inp_search.text == "")
               {
                  _loc2_ = true;
               }
               else
               {
                  this.fillRecipesGrid(new Array());
               }
            }
         }
         var _loc3_:int = int(this.inp_minLevelSearch.text);
         if(this._currentRecipesFilter.minLevel != _loc3_)
         {
            _loc6_ = 1;
            if(!_loc3_ || _loc3_ == 0)
            {
               this.inp_minLevelSearch.text = "1";
               _loc6_ = 1;
            }
            else if(_loc3_ > ProtocolConstantsEnum.MAX_JOB_LEVEL)
            {
               this.inp_minLevelSearch.text = "" + ProtocolConstantsEnum.MAX_JOB_LEVEL;
               _loc6_ = ProtocolConstantsEnum.MAX_JOB_LEVEL;
            }
            else
            {
               _loc6_ = _loc3_;
            }
            if(_loc6_ > this._currentRecipesFilter.maxLevel)
            {
               this.inp_minLevelSearch.text = "" + this._currentRecipesFilter.maxLevel;
               _loc6_ = this._currentRecipesFilter.maxLevel;
            }
            this._currentRecipesFilter.minLevel = _loc6_;
            Common.getInstance().setJobSearchOptionsByJobId(this._currentRecipesFilter);
            _loc2_ = true;
         }
         var _loc4_:int = int(this.inp_maxLevelSearch.text);
         if(this._currentRecipesFilter.maxLevel != _loc4_)
         {
            _loc7_ = 1;
            if(!_loc4_ || _loc4_ == 0)
            {
               this.inp_maxLevelSearch.text = "1";
               _loc7_ = 1;
            }
            else if(_loc4_ > ProtocolConstantsEnum.MAX_JOB_LEVEL)
            {
               this.inp_maxLevelSearch.text = "" + ProtocolConstantsEnum.MAX_JOB_LEVEL;
               _loc7_ = ProtocolConstantsEnum.MAX_JOB_LEVEL;
            }
            else
            {
               _loc7_ = _loc4_;
            }
            if(_loc7_ < this._currentRecipesFilter.minLevel)
            {
               this.inp_maxLevelSearch.text = "" + this._currentRecipesFilter.minLevel;
               _loc7_ = this._currentRecipesFilter.minLevel;
            }
            this._currentRecipesFilter.maxLevel = _loc7_;
            Common.getInstance().setJobSearchOptionsByJobId(this._currentRecipesFilter);
            _loc2_ = true;
         }
         if(_loc2_)
         {
            this.updateRecipes();
         }
      }
      
      private function onInventoryUpdate(param1:Object, param2:uint) : void
      {
         var _loc4_:* = null;
         this._inventoryDataByGID = new Dictionary(true);
         var _loc3_:Object = this.jobApi.getInventoryData(this._canTransfertItems);
         for(_loc4_ in _loc3_)
         {
            this._inventoryDataByGID[int(_loc4_)] = _loc3_[_loc4_];
         }
         this.updateRecipes(true);
      }
      
      private function onJobLevelUp(param1:uint, param2:String, param3:uint) : void
      {
         if(this._jobsLevel[param1])
         {
            this._jobsLevel[param1] = param3;
         }
         if(this._currentJob)
         {
            if(this._currentJob.id == param1)
            {
               this._currentJob = this.jobApi.getKnownJob(param1);
               if(this.inp_maxLevelSearch.text == (param3 - 1).toString())
               {
                  this._currentRecipesFilter.maxLevel = param3;
                  this.inp_maxLevelSearch.text = "" + this._currentRecipesFilter.maxLevel;
               }
               this.updateRecipes(false);
            }
         }
      }
      
      protected function onJobsExpOtherPlayerUpdated(param1:Number, param2:Object) : void
      {
         if(this.uiApi.me().name != "recipesCraft")
         {
            return;
         }
         var _loc3_:JobExperience = param2 as JobExperience;
         this._jobsLevel[_loc3_.jobId] = _loc3_.jobLevel;
         if(this.inp_maxLevelSearch.text == (_loc3_.jobLevel - 1).toString())
         {
            this._currentRecipesFilter.maxLevel = _loc3_.jobLevel;
            this.inp_maxLevelSearch.text = "" + this._currentRecipesFilter.maxLevel;
         }
         this.updateRecipes(false);
      }
      
      private function onJobSelected(param1:int, param2:int, param3:String) : void
      {
         var _loc5_:KnownJobWrapper = null;
         if(param3 != this.uiApi.me().name)
         {
            return;
         }
         var _loc4_:Array = new Array();
         if(param1 == 0 && param2 == 0)
         {
            this._currentJob = null;
            this._currentSkillId = 0;
            for each(_loc5_ in this.jobApi.getKnownJobs())
            {
               _loc4_.push(_loc5_);
            }
            this._currentRecipesFilter = new RecipesFilterWrapper(0,1,ProtocolConstantsEnum.MAX_JOB_LEVEL);
         }
         else
         {
            this._currentJob = this.jobApi.getKnownJob(param1);
            _loc4_.push(this._currentJob);
            this._currentSkillId = param2;
            this._currentRecipesFilter = Common.getInstance().getJobSearchOptionsByJobId(this._currentJob.id);
            if(!this._currentRecipesFilter)
            {
               this._currentRecipesFilter = new RecipesFilterWrapper(this._currentJob.id,1,this.getJobLevel());
            }
         }
         this._searchCriteria = null;
         this.inp_minLevelSearch.text = "" + this._currentRecipesFilter.minLevel;
         if(this._useJobLevelInsteadOfMaxFilter)
         {
            this._currentRecipesFilter.maxLevel = this.getJobLevel();
         }
         this.inp_maxLevelSearch.text = "" + this._currentRecipesFilter.maxLevel;
         this.updateRecipes(true);
      }
   }
}
