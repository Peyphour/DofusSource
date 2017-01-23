package com.ankamagames.dofus.datacenter.quest
{
   public class AchievementReward
   {
       
      
      public function AchievementReward()
      {
         super();
      }
      
      public function get id() : uint
      {
         return new uint();
      }
      
      public function get achievementId() : uint
      {
         return new uint();
      }
      
      public function get levelMin() : int
      {
         return new int();
      }
      
      public function get levelMax() : int
      {
         return new int();
      }
      
      public function get itemsReward() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get itemsQuantityReward() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get emotesReward() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get spellsReward() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get titlesReward() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
      
      public function get ornamentsReward() : Vector.<uint>
      {
         return new Vector.<uint>();
      }
   }
}
