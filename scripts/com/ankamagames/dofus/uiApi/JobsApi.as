package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.interfaces.IApi;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.datacenter.jobs.Recipe;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.AveragePricesFrame;
   import com.ankamagames.dofus.logic.game.common.frames.JobsFrame;
   import com.ankamagames.dofus.logic.game.common.managers.InventoryManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.dofus.network.ProtocolConstantsEnum;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobDescription;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElementSkill;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescription;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescriptionCollect;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescriptionCraft;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.jerakine.logger.Log;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.misc.StringUtils;
   import flash.globalization.Collator;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class JobsApi implements IApi
   {
       
      
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      private var _stringSorter:Collator;
      
      public function JobsApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(JobsApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(param1:UiModule) : void
      {
         this._module = param1;
      }
      
      private function get jobsFrame() : JobsFrame
      {
         return Kernel.getWorker().getFrame(JobsFrame) as JobsFrame;
      }
      
      private function get averagePricesFrame() : AveragePricesFrame
      {
         return Kernel.getWorker().getFrame(AveragePricesFrame) as AveragePricesFrame;
      }
      
      [Trusted]
      public function destroy() : void
      {
         this._module = null;
      }
      
      [Untrusted]
      public function getJobSkills(param1:int) : Array
      {
         var _loc5_:SkillActionDescription = null;
         var _loc2_:JobDescription = this.getJobDescription(param1);
         if(!_loc2_)
         {
            return null;
         }
         var _loc3_:Array = new Array(_loc2_.skills.length);
         var _loc4_:uint = 0;
         for each(_loc5_ in _loc2_.skills)
         {
            _loc3_[_loc4_++] = Skill.getSkillById(_loc5_.skillId);
         }
         return _loc3_;
      }
      
      [Untrusted]
      public function getJobSkillType(param1:int, param2:Skill) : String
      {
         var _loc3_:JobDescription = this.getJobDescription(param1);
         if(!_loc3_)
         {
            return "unknown";
         }
         var _loc4_:SkillActionDescription = this.getSkillActionDescription(_loc3_,param2.id);
         if(!_loc4_)
         {
            return "unknown";
         }
         switch(true)
         {
            case _loc4_ is SkillActionDescriptionCollect:
               return "collect";
            case _loc4_ is SkillActionDescriptionCraft:
               return "craft";
            default:
               this._log.warn("Unknown SkillActionDescription type : " + _loc4_);
               return "unknown";
         }
      }
      
      [Untrusted]
      public function getJobCollectSkillInfos(param1:int, param2:Skill) : Object
      {
         var _loc3_:JobDescription = this.getJobDescription(param1);
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:SkillActionDescription = this.getSkillActionDescription(_loc3_,param2.id);
         if(!_loc4_)
         {
            return null;
         }
         if(!(_loc4_ is SkillActionDescriptionCollect))
         {
            return null;
         }
         var _loc5_:SkillActionDescriptionCollect = _loc4_ as SkillActionDescriptionCollect;
         var _loc6_:Object = new Object();
         _loc6_.time = _loc5_.time / 10;
         _loc6_.minResources = _loc5_.min;
         _loc6_.maxResources = _loc5_.max;
         _loc6_.resourceItem = Item.getItemById(param2.gatheredRessourceItem);
         return _loc6_;
      }
      
      [Untrusted]
      public function getMaxSlotsByJobId(param1:int) : int
      {
         return 8;
      }
      
      [Untrusted]
      public function getJobExperience(param1:int) : Object
      {
         if(param1 == 1)
         {
            return null;
         }
         var _loc2_:KnownJobWrapper = PlayedCharacterManager.getInstance().jobs[param1];
         if(!_loc2_)
         {
            return null;
         }
         var _loc3_:Object = new Object();
         _loc3_.currentLevel = _loc2_.jobLevel;
         _loc3_.currentExperience = _loc2_.jobXP;
         _loc3_.levelExperienceFloor = _loc2_.jobXpLevelFloor;
         _loc3_.levelExperienceCeil = _loc2_.jobXpNextLevelFloor;
         return _loc3_;
      }
      
      [Untrusted]
      public function getCraftXp(param1:ItemWrapper, param2:uint) : int
      {
         return param1.getCraftXpByJobLevel(param2);
      }
      
      [Untrusted]
      public function getSkillFromId(param1:int) : Skill
      {
         return Skill.getSkillById(param1);
      }
      
      [Untrusted]
      public function getRecipe(param1:uint) : Recipe
      {
         return Recipe.getRecipeByResultId(param1);
      }
      
      [Untrusted]
      public function getRecipesList(param1:uint) : Array
      {
         var _loc2_:Array = Item.getItemById(param1).recipes;
         if(_loc2_)
         {
            return _loc2_;
         }
         return new Array();
      }
      
      [Untrusted]
      public function getJobName(param1:uint) : String
      {
         var _loc2_:Job = Job.getJobById(param1);
         if(_loc2_)
         {
            return _loc2_.name;
         }
         this._log.error("We want the name of a non-existing job (id : " + param1 + ")");
         return "";
      }
      
      [Untrusted]
      public function getJob(param1:uint) : Object
      {
         return Job.getJobById(param1);
      }
      
      [Untrusted]
      public function getJobCrafterDirectorySettingsById(param1:uint) : Object
      {
         if(!this.jobsFrame || !this.jobsFrame.settings)
         {
            return null;
         }
         return this.jobsFrame.settings[param1];
      }
      
      [Untrusted]
      public function getUsableSkillsInMap(param1:Number) : Array
      {
         var _loc6_:Boolean = false;
         var _loc7_:uint = 0;
         var _loc8_:InteractiveElement = null;
         var _loc9_:InteractiveElementSkill = null;
         var _loc10_:InteractiveElementSkill = null;
         var _loc2_:Array = new Array();
         var _loc3_:RoleplayContextFrame = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
         var _loc4_:Vector.<InteractiveElement> = _loc3_.entitiesFrame.interactiveElements;
         var _loc5_:Vector.<uint> = _loc3_.getMultiCraftSkills(param1);
         for each(_loc7_ in _loc5_)
         {
            _loc6_ = false;
            for each(_loc8_ in _loc4_)
            {
               for each(_loc9_ in _loc8_.enabledSkills)
               {
                  if(_loc7_ == _loc9_.skillId && _loc2_.indexOf(_loc9_.skillId) == -1)
                  {
                     _loc6_ = true;
                     break;
                  }
               }
               for each(_loc10_ in _loc8_.disabledSkills)
               {
                  if(_loc7_ == _loc10_.skillId && _loc2_.indexOf(_loc10_.skillId) == -1)
                  {
                     _loc6_ = true;
                     break;
                  }
               }
               if(_loc6_)
               {
                  break;
               }
            }
            if(_loc6_)
            {
               _loc2_.push(Skill.getSkillById(_loc7_));
            }
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getKnownJobs() : Array
      {
         var _loc2_:KnownJobWrapper = null;
         var _loc1_:Array = new Array();
         for each(_loc2_ in PlayedCharacterManager.getInstance().jobs)
         {
            if(_loc2_ != null)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      [Trusted]
      public function getKnownJob(param1:uint) : KnownJobWrapper
      {
         var _loc2_:KnownJobWrapper = null;
         if(!PlayedCharacterManager.getInstance().jobs)
         {
            return null;
         }
         if(param1 == 1)
         {
            _loc2_ = new KnownJobWrapper();
            _loc2_.id = 1;
            _loc2_.jobLevel = 200;
         }
         else
         {
            _loc2_ = PlayedCharacterManager.getInstance().jobs[param1] as KnownJobWrapper;
         }
         if(!_loc2_)
         {
            return null;
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function getRecipesByJob(param1:Dictionary, param2:int = 0, param3:int = 0, param4:Boolean = false, param5:int = 8) : Vector.<Recipe>
      {
         var _loc7_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:Recipe = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Array = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc6_:Vector.<Recipe> = new Vector.<Recipe>();
         if(param2 > 0)
         {
            _loc7_ = Recipe.getAllRecipesForSkillId(param2,ProtocolConstantsEnum.MAX_JOB_LEVEL);
         }
         else if(param3 > 0)
         {
            _loc7_ = Recipe.getRecipesByJobId(param3);
         }
         else
         {
            _loc7_ = Recipe.getAllRecipes();
         }
         var _loc8_:int = _loc7_.length;
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc10_ = _loc7_[_loc9_];
            _loc11_ = _loc10_.ingredientIds.length;
            if(!(!_loc10_.job || param3 == 0 && _loc10_.jobId == 1))
            {
               _loc12_ = 0;
               _loc13_ = 0;
               _loc14_ = 0;
               _loc15_ = 0;
               _loc16_ = new Array();
               _loc17_ = param5;
               _loc18_ = 0;
               while(_loc18_ < _loc11_)
               {
                  _loc12_ = _loc12_ + _loc10_.quantities[_loc18_];
                  if(param1[_loc10_.ingredientIds[_loc18_]])
                  {
                     _loc13_ = param1[_loc10_.ingredientIds[_loc18_]].totalQuantity;
                  }
                  else
                  {
                     _loc13_ = 0;
                  }
                  if(_loc13_)
                  {
                     if(_loc13_ >= _loc10_.quantities[_loc18_])
                     {
                        _loc16_.push(int(_loc13_ / _loc10_.quantities[_loc18_]));
                        _loc15_ = _loc15_ + _loc10_.quantities[_loc18_];
                        _loc14_++;
                     }
                     else
                     {
                        _loc16_.push(0);
                        _loc17_--;
                     }
                  }
                  else if(_loc17_ > 0)
                  {
                     _loc16_.push(0);
                     _loc17_--;
                  }
                  _loc18_++;
               }
               if(_loc14_ == _loc10_.ingredientIds.length && _loc15_ >= _loc12_ || param5 == 8 || param5 > 0 && _loc14_ > 0 && _loc14_ + param5 >= _loc10_.ingredientIds.length)
               {
                  _loc6_.push(_loc10_);
                  _loc16_.sort(Array.NUMERIC);
                  if(!param1[_loc10_.resultId])
                  {
                     param1[_loc10_.resultId] = {"actualMaxOccurence":_loc16_[0]};
                  }
                  else
                  {
                     param1[_loc10_.resultId].actualMaxOccurence = _loc16_[0];
                  }
                  if(param4)
                  {
                     _loc19_ = 0;
                     for each(_loc20_ in _loc16_)
                     {
                        if(_loc20_ != 0)
                        {
                           _loc19_ = _loc20_;
                           break;
                        }
                     }
                     param1[_loc10_.resultId].potentialMaxOccurence = _loc19_;
                  }
               }
            }
            _loc9_++;
         }
         _loc6_.fixed = true;
         return _loc6_;
      }
      
      [Untrusted]
      public function getJobFilteredRecipes(param1:Object, param2:Array, param3:int = 1, param4:int = 1, param5:String = null, param6:int = 0) : Array
      {
         var _loc8_:Recipe = null;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc7_:Array = new Array();
         if(param5)
         {
            param5 = StringUtils.noAccent(param5).toLowerCase();
         }
         for each(_loc8_ in param1)
         {
            if(_loc8_)
            {
               _loc9_ = false;
               _loc10_ = false;
               _loc11_ = false;
               if(param3 > 1 || param4 < ProtocolConstantsEnum.MAX_JOB_LEVEL)
               {
                  if(_loc8_.resultLevel >= param3 && _loc8_.resultLevel <= param4)
                  {
                     _loc9_ = true;
                  }
                  else
                  {
                     _loc9_ = false;
                  }
               }
               else
               {
                  _loc9_ = true;
               }
               if(param6 > 0)
               {
                  if(_loc8_.resultTypeId == param6)
                  {
                     _loc10_ = true;
                  }
                  else
                  {
                     _loc10_ = false;
                  }
               }
               else
               {
                  _loc10_ = true;
               }
               if(_loc9_ && _loc10_ && param5)
               {
                  if(_loc8_.words.indexOf(param5) != -1)
                  {
                     _loc11_ = true;
                  }
                  else
                  {
                     _loc11_ = false;
                  }
               }
               else
               {
                  _loc11_ = true;
               }
               if(_loc9_ && _loc11_)
               {
                  if(param2.indexOf(_loc8_.result.type) == -1)
                  {
                     param2.push(_loc8_.result.type);
                  }
                  if(_loc10_)
                  {
                     _loc7_.push(_loc8_);
                  }
               }
            }
         }
         return _loc7_;
      }
      
      [Untrusted]
      public function getInventoryData(param1:Boolean = false) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:Vector.<ItemWrapper> = null;
         var _loc7_:ItemWrapper = null;
         var _loc9_:Vector.<ItemWrapper> = null;
         var _loc2_:Array = new Array();
         var _loc3_:Vector.<Recipe> = new Vector.<Recipe>();
         if(param1)
         {
            _loc5_ = InventoryManager.getInstance().bankInventory.getView("bank").content;
         }
         else
         {
            _loc5_ = InventoryManager.getInstance().inventory.getView("storage").content;
         }
         var _loc6_:int = _loc5_.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_)
         {
            _loc7_ = _loc5_[_loc8_];
            if(!_loc7_.linked)
            {
               if(!_loc2_[_loc7_.objectGID])
               {
                  _loc2_[_loc7_.objectGID] = {
                     "totalQuantity":_loc7_.quantity,
                     "stackUidList":[_loc7_.objectUID],
                     "stackQtyList":[_loc7_.quantity],
                     "fromBag":[false],
                     "storageTotalQuantity":_loc7_.quantity
                  };
               }
               else
               {
                  _loc2_[_loc7_.objectGID].totalQuantity = _loc2_[_loc7_.objectGID].totalQuantity + _loc7_.quantity;
                  _loc2_[_loc7_.objectGID].stackUidList.push(_loc7_.objectUID);
                  _loc2_[_loc7_.objectGID].stackQtyList.push(_loc7_.quantity);
                  _loc2_[_loc7_.objectGID].fromBag.push(false);
                  _loc2_[_loc7_.objectGID].storageTotalQuantity = _loc2_[_loc7_.objectGID].storageTotalQuantity + _loc7_.quantity;
               }
            }
            _loc8_++;
         }
         if(param1)
         {
            _loc9_ = InventoryManager.getInstance().inventory.getView("storage").content;
            _loc6_ = _loc9_.length;
            _loc8_ = 0;
            while(_loc8_ < _loc6_)
            {
               _loc7_ = _loc9_[_loc8_];
               if(!_loc7_.linked)
               {
                  if(!_loc2_[_loc7_.objectGID])
                  {
                     _loc2_[_loc7_.objectGID] = {
                        "totalQuantity":_loc7_.quantity,
                        "stackUidList":[_loc7_.objectUID],
                        "stackQtyList":[_loc7_.quantity],
                        "fromBag":[true]
                     };
                  }
                  else
                  {
                     _loc2_[_loc7_.objectGID].totalQuantity = _loc2_[_loc7_.objectGID].totalQuantity + _loc7_.quantity;
                     _loc2_[_loc7_.objectGID].stackUidList.push(_loc7_.objectUID);
                     _loc2_[_loc7_.objectGID].stackQtyList.push(_loc7_.quantity);
                     _loc2_[_loc7_.objectGID].fromBag.push(true);
                  }
               }
               _loc8_++;
            }
         }
         return _loc2_;
      }
      
      [Untrusted]
      public function sortRecipesByCriteria(param1:Object, param2:String, param3:Boolean) : Object
      {
         this.sortRecipes(param1,param2,!!param3?1:-1);
         return param1;
      }
      
      private function sortRecipes(param1:Object, param2:String, param3:int = 1) : void
      {
         if(!this._stringSorter)
         {
            this._stringSorter = new Collator(XmlConfig.getInstance().getEntry("config.lang.current"));
         }
         switch(param2)
         {
            case "level":
               param1.sort(this.compareLevel(param3));
               break;
            case "price":
               param1.sort(this.comparePrice(param3));
         }
      }
      
      private function compareLevel(param1:int = 1) : Function
      {
         var way:int = param1;
         return function(param1:*, param2:*):Number
         {
            if(param1.resultLevel < param2.resultLevel)
            {
               return -way;
            }
            if(param1.resultLevel > param2.resultLevel)
            {
               return way;
            }
            return _stringSorter.compare(param1.resultName,param2.resultName);
         };
      }
      
      private function comparePrice(param1:int = 1) : Function
      {
         var way:int = param1;
         return function(param1:*, param2:*):Number
         {
            var _loc3_:* = averagePricesFrame.pricesData.items["item" + param1.resultId];
            var _loc4_:* = averagePricesFrame.pricesData.items["item" + param2.resultId];
            if(!_loc3_)
            {
               _loc3_ = way == 1?int.MAX_VALUE:0;
            }
            if(!_loc4_)
            {
               _loc4_ = way == 1?int.MAX_VALUE:0;
            }
            if(_loc3_ < _loc4_)
            {
               return -way;
            }
            if(_loc3_ > _loc4_)
            {
               return way;
            }
            return _stringSorter.compare(param1.resultName,param2.resultName);
         };
      }
      
      private function getJobDescription(param1:uint) : JobDescription
      {
         var _loc2_:KnownJobWrapper = this.getKnownJob(param1);
         if(!_loc2_)
         {
            return null;
         }
         return _loc2_.jobDescription;
      }
      
      private function getSkillActionDescription(param1:JobDescription, param2:uint) : SkillActionDescription
      {
         var _loc3_:SkillActionDescription = null;
         for each(_loc3_ in param1.skills)
         {
            if(_loc3_.skillId == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}
