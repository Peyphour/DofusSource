package ui
{
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.Input;
   import com.ankamagames.berilia.components.Label;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   import com.ankamagames.dofus.uiApi.ContextMenuApi;
   import com.ankamagames.dofus.uiApi.JobsApi;
   import com.ankamagames.dofus.uiApi.SoundApi;
   import com.ankamagames.dofus.uiApi.StorageApi;
   import com.ankamagames.dofus.uiApi.SystemApi;
   import com.ankamagames.dofus.uiApi.UtilApi;
   import com.ankamagames.dofusModuleLibrary.enum.SoundTypeEnum;
   import d2actions.JobBookSubscribeRequest;
   import d2actions.JobCrafterDirectoryDefineSettings;
   import d2enums.ComponentHookList;
   import d2enums.ProtocolConstantsEnum;
   import d2enums.SelectMethodEnum;
   import d2hooks.CrafterDirectorySettings;
   import d2hooks.JobBookSubscription;
   import d2hooks.JobLevelUp;
   import d2hooks.JobSelected;
   import d2hooks.JobsExpUpdated;
   import d2hooks.KeyUp;
   import d2hooks.ShowObjectLinked;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class JobTab
   {
       
      
      public var sysApi:SystemApi;
      
      public var uiApi:UiApi;
      
      public var jobsApi:JobsApi;
      
      public var soundApi:SoundApi;
      
      public var utilApi:UtilApi;
      
      [Module(name="Ankama_ContextMenu")]
      public var modContextMenu:Object;
      
      public var menuApi:ContextMenuApi;
      
      public var storageApi:StorageApi;
      
      [Module(name="Ankama_Common")]
      public var modCommon:Object;
      
      private var _jobs:Array;
      
      private var _currentJob:KnownJobWrapper;
      
      private var _bDescendingSort:Boolean = false;
      
      private var _gridComponentsList:Dictionary;
      
      private var _optionsTimer:Timer;
      
      private var _allJobsSubscribed:Boolean = false;
      
      public var gd_jobs:Grid;
      
      public var btn_tabName:ButtonContainer;
      
      public var btn_tabLevel:ButtonContainer;
      
      public var chk_subscribeAll:ButtonContainer;
      
      public var lbl_jobNameOption:Label;
      
      public var chk_freeOption:ButtonContainer;
      
      public var inp_minLevelOption:Input;
      
      public var btn_recipes:ButtonContainer;
      
      public var btn_resources:ButtonContainer;
      
      public var ctr_recipes:GraphicContainer;
      
      public var ctr_resources:GraphicContainer;
      
      public var gd_skills:Grid;
      
      public var btn_close:ButtonContainer;
      
      public function JobTab()
      {
         this._jobs = new Array();
         this._gridComponentsList = new Dictionary(true);
         super();
      }
      
      public function main(param1:Object = null) : void
      {
         var _loc4_:KnownJobWrapper = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this.soundApi.playSound(SoundTypeEnum.OPEN_WINDOW);
         this.sysApi.addHook(JobBookSubscription,this.onJobBookSubscription);
         this.sysApi.addHook(CrafterDirectorySettings,this.onCrafterDirectorySettings);
         this.sysApi.addHook(JobsExpUpdated,this.onJobsExpUpdated);
         this.sysApi.addHook(JobLevelUp,this.onJobLevelUp);
         this.uiApi.addComponentHook(this.gd_jobs,ComponentHookList.ON_SELECT_ITEM);
         this.uiApi.addComponentHook(this.chk_freeOption,ComponentHookList.ON_RELEASE);
         this.uiApi.addComponentHook(this.chk_freeOption,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.chk_freeOption,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.inp_minLevelOption,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.inp_minLevelOption,ComponentHookList.ON_ROLL_OUT);
         this.uiApi.addComponentHook(this.chk_subscribeAll,ComponentHookList.ON_ROLL_OVER);
         this.uiApi.addComponentHook(this.chk_subscribeAll,ComponentHookList.ON_ROLL_OUT);
         this.sysApi.addHook(KeyUp,this.onKeyUp);
         this.uiApi.addComponentHook(this.btn_close,ComponentHookList.ON_RELEASE);
         this.uiApi.addShortcutHook("closeUi",this.onShortcut);
         this._optionsTimer = new Timer(3000,1);
         this._optionsTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onOptionsTimerComplete);
         var _loc2_:Object = this.jobsApi.getKnownJobs();
         var _loc3_:int = Grimoire.getInstance().lastJobOpenedId;
         this._allJobsSubscribed = true;
         for each(_loc4_ in _loc2_)
         {
            this._jobs.push(_loc4_);
            if(!_loc4_.jobBookSubscriber)
            {
               this._allJobsSubscribed = false;
            }
         }
         this._jobs.sortOn(["jobXP","name"],[Array.NUMERIC | Array.DESCENDING,Array.CASEINSENSITIVE]);
         this.gd_jobs.dataProvider = this._jobs;
         _loc5_ = 0;
         _loc6_ = 0;
         while(_loc6_ < this._jobs.length)
         {
            if(this._jobs[_loc6_].id == _loc3_)
            {
               _loc5_ = _loc6_;
            }
            _loc6_++;
         }
         this.gd_jobs.selectedIndex = _loc5_;
         this.onSelectItem(this.gd_jobs,SelectMethodEnum.AUTO,true);
         if(this._allJobsSubscribed)
         {
            this.chk_subscribeAll.selected = true;
         }
         this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_recipes,this.uiApi.me());
         this.btn_recipes.selected = true;
         this.onRelease(this.btn_recipes);
         this.modCommon.createRecipesObject("recipesGrimoire",this.ctr_recipes,this.ctr_recipes,this.gd_jobs.selectedItem.id);
      }
      
      public function unload() : void
      {
         this.uiApi.unloadUi("recipesGrimoire");
         if(this._currentJob)
         {
            Grimoire.getInstance().lastJobOpenedId = this._currentJob.id;
         }
         if(this._optionsTimer.running)
         {
            this.onOptionsTimerComplete(null);
            this._optionsTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onOptionsTimerComplete);
            this._optionsTimer.stop();
            this._optionsTimer = null;
         }
      }
      
      public function get currentJob() : KnownJobWrapper
      {
         return this._currentJob;
      }
      
      public function updateJobLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         if(param1)
         {
            if(!this._gridComponentsList[param2.tx_progressBar.name])
            {
               this.uiApi.addComponentHook(param2.tx_progressBar,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.tx_progressBar,ComponentHookList.ON_ROLL_OUT);
            }
            this._gridComponentsList[param2.tx_progressBar.name] = param1;
            if(!this._gridComponentsList[param2.chk_subscribe.name])
            {
               this.uiApi.addComponentHook(param2.chk_subscribe,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.chk_subscribe,ComponentHookList.ON_ROLL_OUT);
               this.uiApi.addComponentHook(param2.chk_subscribe,ComponentHookList.ON_RELEASE);
            }
            this._gridComponentsList[param2.chk_subscribe.name] = param1;
            if(param1.jobXP == 0)
            {
               param2.lbl_name.cssClass = "p4";
            }
            else
            {
               param2.lbl_name.cssClass = "p";
            }
            param2.lbl_name.text = param1.name;
            if(this.sysApi.getPlayerManager().hasRights)
            {
               param2.lbl_name.text = param2.lbl_name.text + (" (" + param1.id + ")");
            }
            param2.lbl_level.text = this.uiApi.getText("ui.common.short.level") + " " + param1.jobLevel;
            param2.tx_icon.uri = this.uiApi.createUri(this.uiApi.me().getConstant("jobIconPath") + param1.iconId + ".swf");
            param2.tx_progressBar.visible = true;
            _loc4_ = 1;
            if(param1.jobLevel == ProtocolConstantsEnum.MAX_JOB_LEVEL)
            {
               _loc4_ = 100;
            }
            else
            {
               _loc4_ = int((param1.jobXP - param1.jobXpLevelFloor) / (param1.jobXpNextLevelFloor - param1.jobXpLevelFloor) * 100);
               if(_loc4_ == 0)
               {
                  _loc4_ = 1;
               }
            }
            param2.tx_progressBar.value = _loc4_ / 100;
            param2.chk_subscribe.visible = true;
            param2.chk_subscribe.selected = param1.jobBookSubscriber;
            if(param3)
            {
               param2.btn_job.selected = true;
            }
            else
            {
               param2.btn_job.selected = false;
            }
         }
         else
         {
            param2.lbl_name.text = "";
            param2.lbl_level.text = "";
            param2.tx_icon.uri = null;
            param2.tx_progressBar.visible = false;
            param2.chk_subscribe.visible = false;
            param2.btn_job.selected = false;
            param2.btn_job.softDisabled = false;
            param2.tx_progressBar.value = 0;
         }
      }
      
      public function gotoands(param1:Object) : void
      {
         param1[1].value = param1[0];
      }
      
      public function updateSkillLine(param1:*, param2:*, param3:Boolean) : void
      {
         var _loc4_:Object = null;
         if(param1)
         {
            if(!this._gridComponentsList[param2.slot_resource.name])
            {
               this.uiApi.addComponentHook(param2.slot_resource,ComponentHookList.ON_ROLL_OVER);
               this.uiApi.addComponentHook(param2.slot_resource,ComponentHookList.ON_ROLL_OUT);
               this.uiApi.addComponentHook(param2.slot_resource,ComponentHookList.ON_RELEASE);
               this.uiApi.addComponentHook(param2.slot_resource,ComponentHookList.ON_RIGHT_CLICK);
            }
            this._gridComponentsList[param2.slot_resource.name] = param1.gatheredRessource;
            param2.lbl_interactive.text = param1.interactive.name;
            if(this._currentJob.id != 36)
            {
               param2.lbl_xp.text = this.uiApi.getText("ui.tooltip.monsterXpAlone",Math.floor(5 + param1.levelMin / 10));
            }
            else
            {
               param2.lbl_xp.text = "";
            }
            _loc4_ = this.jobsApi.getJobCollectSkillInfos(this._currentJob.id,param1);
            if(_loc4_)
            {
               param2.lbl_info.text = this.uiApi.getText("ui.jobs.collectSkillInfos",_loc4_.minResources,_loc4_.maxResources);
            }
            param2.slot_resource.data = param1.gatheredRessource;
            param2.slot_resource.visible = true;
         }
         else
         {
            param2.slot_resource.visible = false;
            param2.lbl_info.text = "";
            param2.lbl_interactive.text = "";
            param2.lbl_xp.text = "";
         }
      }
      
      private function switchJob() : void
      {
         var _loc4_:Skill = null;
         if(this._currentJob && this.gd_jobs.selectedItem.id == this._currentJob.id)
         {
            return;
         }
         if(this._optionsTimer.running)
         {
            this.onOptionsTimerComplete(null);
         }
         this._currentJob = this.gd_jobs.selectedItem;
         this.lbl_jobNameOption.text = this._currentJob.name + this.uiApi.getText("ui.common.colon");
         var _loc1_:Object = this.jobsApi.getJobCrafterDirectorySettingsById(this._currentJob.id);
         this.chk_freeOption.selected = _loc1_.free;
         this.inp_minLevelOption.text = _loc1_.minLevel;
         this.sysApi.dispatchHook(JobSelected,this._currentJob.id,0,"recipesGrimoire");
         var _loc2_:Object = this.jobsApi.getJobSkills(this._currentJob.id);
         var _loc3_:Array = new Array();
         for each(_loc4_ in _loc2_)
         {
            if(_loc4_.gatheredRessourceItem > -1 && _loc4_.clientDisplay)
            {
               _loc3_.push(_loc4_);
            }
         }
         if(_loc3_.length == 0)
         {
            this.btn_resources.disabled = true;
            if(this.btn_resources.selected)
            {
               this.uiApi.setRadioGroupSelectedItem("tabHGroup",this.btn_recipes,this.uiApi.me());
               this.onRelease(this.btn_recipes);
            }
         }
         else
         {
            _loc3_.sortOn("levelMin",Array.NUMERIC);
            this.btn_resources.disabled = false;
            this.gd_skills.dataProvider = _loc3_;
         }
      }
      
      public function onRelease(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:KnownJobWrapper = null;
         switch(param1)
         {
            case this.btn_tabName:
               if(this._bDescendingSort)
               {
                  this._jobs.sortOn(["name","jobXP"],[Array.CASEINSENSITIVE | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING]);
                  this.gd_jobs.dataProvider = this._jobs;
               }
               else
               {
                  this._jobs.sortOn(["name","jobXP"],[Array.CASEINSENSITIVE,Array.NUMERIC | Array.DESCENDING]);
                  this.gd_jobs.dataProvider = this._jobs;
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_tabLevel:
               if(this._bDescendingSort)
               {
                  this._jobs.sortOn(["jobXP","name"],[Array.NUMERIC | Array.DESCENDING,Array.CASEINSENSITIVE]);
                  this.gd_jobs.dataProvider = this._jobs;
               }
               else
               {
                  this._jobs.sortOn(["jobXP","name"],[Array.NUMERIC,Array.CASEINSENSITIVE]);
                  this.gd_jobs.dataProvider = this._jobs;
               }
               this._bDescendingSort = !this._bDescendingSort;
               break;
            case this.btn_recipes:
               this.ctr_recipes.visible = true;
               this.ctr_resources.visible = false;
               break;
            case this.btn_resources:
               this.ctr_resources.visible = true;
               this.ctr_recipes.visible = false;
               break;
            case this.chk_freeOption:
               this._optionsTimer.reset();
               this._optionsTimer.start();
               break;
            case this.btn_close:
               this.uiApi.unloadUi(this.uiApi.me().name);
               return;
            case this.chk_subscribeAll:
               _loc3_ = new Vector.<uint>();
               if(!this._allJobsSubscribed)
               {
                  for each(_loc4_ in this._jobs)
                  {
                     if(!_loc4_.jobBookSubscriber)
                     {
                        _loc3_.push(_loc4_.id);
                     }
                  }
                  this._allJobsSubscribed = true;
               }
               else
               {
                  for each(_loc4_ in this._jobs)
                  {
                     _loc3_.push(_loc4_.id);
                  }
                  this._allJobsSubscribed = false;
               }
               this.sysApi.sendAction(new JobBookSubscribeRequest(_loc3_));
         }
         if(param1.name.indexOf("slot") == 0)
         {
            _loc2_ = this._gridComponentsList[param1.name];
            if(_loc2_ && !this.sysApi.getOption("displayTooltips","dofus"))
            {
               this.sysApi.dispatchHook(ShowObjectLinked,_loc2_);
            }
         }
         else if(param1.name.indexOf("chk_subscribe") == 0)
         {
            _loc2_ = this._gridComponentsList[param1.name];
            if(_loc2_)
            {
               _loc3_ = new Vector.<uint>();
               _loc3_.push(_loc2_.id);
               this.sysApi.sendAction(new JobBookSubscribeRequest(_loc3_));
            }
         }
      }
      
      public function onRollOver(param1:Object) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         if(param1.name.indexOf("tx_progressBar") == 0)
         {
            _loc3_ = this._gridComponentsList[param1.name];
            if(_loc3_)
            {
               _loc4_ = this.utilApi.formateIntToString(_loc3_.jobXP);
               if(_loc3_.jobLevel == ProtocolConstantsEnum.MAX_JOB_LEVEL)
               {
                  _loc2_ = "100 % (" + _loc4_ + ")";
               }
               else
               {
                  _loc2_ = _loc4_ + " / " + this.utilApi.formateIntToString(_loc3_.jobXpNextLevelFloor);
               }
            }
         }
         else if(param1 == this.chk_subscribeAll)
         {
            if(this.chk_subscribeAll.selected)
            {
               _loc2_ = this.uiApi.getText("ui.craft.removeAllFromCrafterLists");
            }
            else
            {
               _loc2_ = this.uiApi.getText("ui.craft.addAllToCrafterLists");
            }
         }
         else if(param1.name.indexOf("chk_subscribe") == 0)
         {
            _loc3_ = this._gridComponentsList[param1.name];
            if(_loc3_)
            {
               if(_loc3_.jobBookSubscriber)
               {
                  _loc2_ = this.uiApi.getText("ui.craft.removeFromCrafterList");
               }
               else
               {
                  _loc2_ = this.uiApi.getText("ui.craft.addToCrafterList");
               }
            }
         }
         else if(param1 == this.inp_minLevelOption)
         {
            _loc2_ = this.uiApi.getText("ui.jobs.minLevelOptionInfo");
         }
         else if(param1 == this.chk_freeOption)
         {
            _loc2_ = this.uiApi.getText("ui.jobs.freeOptionInfo");
         }
         else
         {
            if(param1.name.indexOf("slot_craftedItem") == 0 || param1.name.indexOf("slot_resource") == 0)
            {
               _loc3_ = this._gridComponentsList[param1.name];
               if(_loc3_)
               {
                  this.uiApi.showTooltip(_loc3_,param1,false,"standard",8,0,0,"itemName",null,{
                     "showEffects":true,
                     "header":true
                  },"ItemInfo");
               }
               return;
            }
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
         if(!param3)
         {
            return;
         }
         switch(param1)
         {
            case this.gd_jobs:
               this.switchJob();
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
      
      public function onKeyUp(param1:Object, param2:uint) : void
      {
         if(this.inp_minLevelOption.haveFocus)
         {
            this._optionsTimer.reset();
            this._optionsTimer.start();
         }
      }
      
      private function onShortcut(param1:String) : Boolean
      {
         switch(param1)
         {
            case "closeUi":
               this.uiApi.unloadUi(this.uiApi.me().name);
               return true;
            default:
               return false;
         }
      }
      
      private function onJobBookSubscription(param1:uint, param2:Boolean) : void
      {
         var _loc6_:KnownJobWrapper = null;
         var _loc3_:int = -1;
         var _loc4_:int = -1;
         var _loc5_:Boolean = true;
         for each(_loc6_ in this.gd_jobs.dataProvider)
         {
            _loc4_++;
            if(_loc6_.id == param1)
            {
               _loc3_ = _loc4_;
            }
            else if(!_loc6_.jobBookSubscriber)
            {
               _loc5_ = false;
            }
         }
         this.gd_jobs.updateItem(_loc3_);
         if(this._allJobsSubscribed && !param2)
         {
            this.chk_subscribeAll.selected = false;
            this._allJobsSubscribed = false;
         }
         else if(!this._allJobsSubscribed && param2 && _loc5_)
         {
            this.chk_subscribeAll.selected = true;
            this._allJobsSubscribed = true;
         }
      }
      
      private function onJobLevelUp(param1:uint, param2:String, param3:uint) : void
      {
         var _loc4_:int = -1;
         var _loc5_:int = this._jobs.length;
         var _loc6_:KnownJobWrapper = this.jobsApi.getKnownJob(param1);
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            if(this._jobs[_loc7_].id == param1)
            {
               this._jobs[_loc7_] = _loc6_;
            }
            if(this.gd_jobs.dataProvider[_loc7_].id == param1)
            {
               this.gd_jobs.dataProvider[_loc7_] = _loc6_;
               _loc4_ = _loc7_;
            }
            _loc7_++;
         }
         if(_loc4_ > -1)
         {
            this.gd_jobs.updateItem(_loc4_);
         }
         if(this._currentJob.id == param1)
         {
            if(this.storageApi.getIsCraftFilterEnabled())
            {
               this.storageApi.enableCraftFilter(_loc6_.jobDescription.skills,param3);
            }
         }
      }
      
      protected function onJobsExpUpdated(param1:uint) : void
      {
         var _loc2_:int = -1;
         var _loc3_:int = this._jobs.length;
         var _loc4_:KnownJobWrapper = this.jobsApi.getKnownJob(param1);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            if(this._jobs[_loc5_].id == param1)
            {
               this._jobs[_loc5_] = _loc4_;
            }
            if(this.gd_jobs.dataProvider[_loc5_].id == param1)
            {
               this.gd_jobs.dataProvider[_loc5_] = _loc4_;
               _loc2_ = _loc5_;
            }
            _loc5_++;
         }
         if(_loc2_ > -1)
         {
            this.gd_jobs.updateItem(_loc2_);
         }
      }
      
      private function onCrafterDirectorySettings(param1:Object) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in param1)
         {
            if(this._currentJob && _loc2_.jobId == this._currentJob.id)
            {
               this.chk_freeOption.selected = _loc2_.free;
               this.inp_minLevelOption.text = _loc2_.minLevel.toString();
            }
         }
      }
      
      private function onOptionsTimerComplete(param1:TimerEvent) : void
      {
         if(!this._currentJob)
         {
            return;
         }
         var _loc2_:int = int(this.inp_minLevelOption.text);
         if(_loc2_ < 1)
         {
            _loc2_ = 1;
         }
         if(_loc2_ > ProtocolConstantsEnum.MAX_JOB_LEVEL)
         {
            _loc2_ = ProtocolConstantsEnum.MAX_JOB_LEVEL;
         }
         this.sysApi.sendAction(new JobCrafterDirectoryDefineSettings(this._currentJob.id,_loc2_,this.chk_freeOption.selected));
      }
   }
}
