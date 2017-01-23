package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.datacenter.jobs.Recipe;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   
   public class JobsApi
   {
       
      
      public function JobsApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getJobSkills(param1:int) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getJobSkillType(param1:int, param2:Skill) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getJobCollectSkillInfos(param1:int, param2:Skill) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getMaxSlotsByJobId(param1:int) : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getJobExperience(param1:int) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getCraftXp(param1:ItemWrapper, param2:uint) : int
      {
         return 0;
      }
      
      [Untrusted]
      public function getSkillFromId(param1:int) : Skill
      {
         return null;
      }
      
      [Untrusted]
      public function getRecipe(param1:uint) : Recipe
      {
         return null;
      }
      
      [Untrusted]
      public function getRecipesList(param1:uint) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getJobName(param1:uint) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getJob(param1:uint) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getJobCrafterDirectorySettingsById(param1:uint) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getUsableSkillsInMap(param1:Number) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getKnownJobs() : Array
      {
         return null;
      }
      
      [Trusted]
      public function getKnownJob(param1:uint) : KnownJobWrapper
      {
         return null;
      }
      
      [Untrusted]
      public function getRecipesByJob(param1:Object, param2:int = 0, param3:int = 0, param4:Boolean = false, param5:int = 8) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getJobFilteredRecipes(param1:Object, param2:Array, param3:int = 1, param4:int = 1, param5:String = null, param6:int = 0) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getInventoryData(param1:Boolean = false) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function sortRecipesByCriteria(param1:Object, param2:String, param3:Boolean) : Object
      {
         return null;
      }
   }
}
