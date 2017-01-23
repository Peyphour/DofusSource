package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.ComboBox;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   import com.ankamagames.dofus.uiApi.DataApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundEnum;
   import d2enums.ComponentHookList;
   import d2hooks.JobSelected;
   import d2hooks.RecipesListRefreshed;
   
   public class CheckCraft
   {
      
      public static const SORT_CRITERIA_LEVEL:String = "level";
      
      public static const SORT_CRITERIA_PRICE:String = "price";
      
      private static const MISSING_INGREDIENTS_TOLERANCE:Array = ["0","1","2","3","4","5","6","7"];
      
      private static var _jobs:Vector.<KnownJobWrapper>;
      
      private static var _jobNames:Array;
       
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var dataApi:DataApi;
      
      public var jobsApi:JobsApi;
      
      public var utilApi:UtilApi;
      
      public var btn_close:ButtonContainer;
      
      public var combo_job:ComboBox;
      
      public var btn_sortByLvl:ButtonContainer;
      
      public var btn_sortByPrice:ButtonContainer;
      
      public var combo_ingredientsTolerance:ComboBox;
      
      public var ctr_recipes:GraphicContainer;
      
      public var lbl_totalRecipes:Label;
      
      public var lbl_tolerance:Label;
      
      private var _currentJob:KnownJobWrapper;
      
      private var _sortCriteria:String;
      
      private var _storage:String;
      
      private var _recipeUi:Object;
      
      public function CheckCraft()
      {
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:KnownJobWrapper = null;
         var _loc5_:Skill = null;
         this.btn_close.soundId = SoundEnum.CANCEL_BUTTON;
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.combo_job,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.combo_ingredientsTolerance,ComponentHookList.ON_SELECT_ITEM);
         this.sysApi.addHook(RecipesListRefreshed,this.onRecipesListRefreshed);
         this._sortCriteria = SORT_CRITERIA_LEVEL;
         this._storage = param1.storage;
         this._recipeUi = this.modCommon.createRecipesObject("recipesCheckcraft",this.ctr_recipes,this.ctr_recipes,0,0,true,this._storage);
         if(!_jobs)
         {
            _jobs = new Vector.<KnownJobWrapper>();
            _jobNames = new Array();
            _loc2_ = this.dataApi.getSkills();
            _loc3_ = new Array();
            for each(_loc5_ in _loc2_)
            {
               if(_loc5_.parentJobId > 1 && _loc5_.craftableItemIds && _loc5_.craftableItemIds.length > 0)
               {
                  if(_loc3_.indexOf(_loc5_.parentJobId) == -1)
                  {
                     _loc3_.push(_loc5_.parentJobId);
                     _loc4_ = this.jobsApi.getKnownJob(_loc5_.parentJobId);
                     _jobs.push(_loc4_);
                     _jobNames.push(_loc4_.name);
                  }
               }
            }
            _jobs.fixed = true;
            this.utilApi.sortOnString(_jobNames);
            _jobNames.unshift(this.uiApi.getText("ui.craft.allJobs"));
         }
         this.combo_job.dataProvider = _jobNames;
         this.combo_job.value = this.combo_job.dataProvider[0];
         this.combo_ingredientsTolerance.dataProvider = MISSING_INGREDIENTS_TOLERANCE;
         this.combo_ingredientsTolerance.value = MISSING_INGREDIENTS_TOLERANCE[0];
         if(this._recipeUi && Object(this._recipeUi.uiClass).hasOwnProperty("ingredientsToleranceFilter"))
         {
            this._recipeUi.uiClass.ingredientsToleranceFilter = int(this.combo_ingredientsTolerance.selectedItem);
         }
      }
      
      public function unload() : void
      {
         this._currentJob = null;
         this._storage = null;
         this.uiApi.unloadUi("recipesCheckcraft");
         this.uiApi.hideTooltip();
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1 == this.lbl_tolerance)
         {
            _loc2_ = this.uiApi.getText("ui.craft.missingIngredientsTolerance.tooltip");
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
      
      public function onRelease(param1:Object) : void
      {
         switch(param1)
         {
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               break;
            case this.btn_sortByLvl:
               this._sortCriteria = SORT_CRITERIA_LEVEL;
               this.btn_sortByLvl.selected = true;
               this.btn_sortByPrice.selected = false;
               if(this._recipeUi && Object(this._recipeUi.uiClass).hasOwnProperty("switchSort"))
               {
                  this._recipeUi.uiClass.switchSort(this._sortCriteria);
               }
               break;
            case this.btn_sortByPrice:
               this._sortCriteria = SORT_CRITERIA_PRICE;
               this.btn_sortByLvl.selected = false;
               this.btn_sortByPrice.selected = true;
               if(this._recipeUi && Object(this._recipeUi.uiClass).hasOwnProperty("switchSort"))
               {
                  this._recipeUi.uiClass.switchSort(this._sortCriteria);
               }
         }
      }
      
      public function onSelectItem(param1:Object, param2:uint, param3:Boolean) : void
      {
         var _loc4_:KnownJobWrapper = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:* = undefined;
         if(!param3)
         {
            return;
         }
         switch(param1)
         {
            case this.combo_job:
               _loc4_ = this._currentJob;
               if(this.combo_job.selectedIndex > 0)
               {
                  this._currentJob = null;
                  _loc5_ = 0;
                  while(_loc5_ < _jobs.length)
                  {
                     _loc6_ = _jobs[_loc5_].name;
                     _loc7_ = this.combo_job.selectedItem;
                     if(_loc6_ == _loc7_)
                     {
                        this._currentJob = _jobs[_loc5_];
                        break;
                     }
                     _loc5_++;
                  }
               }
               else
               {
                  this._currentJob = null;
               }
               if(_loc4_ != this._currentJob)
               {
                  if(this._currentJob)
                  {
                     this.sysApi.dispatchHook(JobSelected,this._currentJob.id,0,"recipesCheckcraft");
                  }
                  else
                  {
                     this.sysApi.dispatchHook(JobSelected,0,0,"recipesCheckcraft");
                  }
               }
               break;
            case this.combo_ingredientsTolerance:
               if(this._recipeUi && Object(this._recipeUi.uiClass).hasOwnProperty("ingredientsToleranceFilter"))
               {
                  this._recipeUi.uiClass.ingredientsToleranceFilter = int(this.combo_ingredientsTolerance.selectedItem);
               }
         }
      }
      
      public function get storage() : String
      {
         return this._storage;
      }
      
      private function onRecipesListRefreshed(param1:int) : void
      {
         if(param1 < 2)
         {
            this.lbl_totalRecipes.text = this.uiApi.getText("ui.craft.oneRecipeFound",param1);
         }
         else
         {
            this.lbl_totalRecipes.text = this.uiApi.getText("ui.craft.recipesFound",param1);
         }
      }
   }
}
