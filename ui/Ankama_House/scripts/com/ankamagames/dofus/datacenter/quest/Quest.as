package com.ankamagames.dofus.datacenter.quest
{
   public class Quest
   {
       
      
      public function Quest()
      {
         super();
      }
      
      public function get id() : uint
      {
         return new uint();
      }
      
      public function get nameId() : uint
      {
         return new uint();
      }
      
      public function get stepIds() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get categoryId() : uint
      {
         return new uint();
      }
      
      public function get repeatType() : uint
      {
         return new uint();
      }
      
      public function get repeatLimit() : uint
      {
         return new uint();
      }
      
      public function get isDungeonQuest() : Boolean
      {
         return new Boolean();
      }
      
      public function get levelMin() : uint
      {
         return new uint();
      }
      
      public function get levelMax() : uint
      {
         return new uint();
      }
      
      public function get isPartyQuest() : Boolean
      {
         return new Boolean();
      }
      
      public function get startCriterion() : String
      {
         return new String();
      }
      
      public function get name() : String
      {
         return null;
      }
      
      public function get steps() : Object
      {
         return null;
      }
      
      public function get category() : QuestCategory
      {
         return null;
      }
      
      public function get canBeStarted() : Boolean
      {
         return false;
      }
   }
}
