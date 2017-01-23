package com.ankamagames.dofus.datacenter.jobs
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   
   public class Recipe
   {
       
      
      public function Recipe()
      {
         super();
      }
      
      public function get resultId() : int
      {
         return new int();
      }
      
      public function get resultNameId() : uint
      {
         return new uint();
      }
      
      public function get resultTypeId() : uint
      {
         return new uint();
      }
      
      public function get resultLevel() : uint
      {
         return new uint();
      }
      
      public function get ingredientIds() : Vector.<int>
      {
         return new Vector.<int>();
      }
      
      public function get quantities() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get jobId() : int
      {
         return new int();
      }
      
      public function get skillId() : int
      {
         return new int();
      }
      
      public function get result() : ItemWrapper
      {
         return null;
      }
      
      public function get resultName() : String
      {
         return null;
      }
      
      public function get ingredients() : Object
      {
         return null;
      }
      
      public function get words() : String
      {
         return null;
      }
      
      public function get job() : Job
      {
         return null;
      }
      
      public function get skill() : Skill
      {
         return null;
      }
   }
}
