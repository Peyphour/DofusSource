package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.dofus.datacenter.quest.Achievement;
   
   public class QuestApi
   {
       
      
      public function QuestApi()
      {
         super();
      }
      
      [Trusted]
      public function destroy() : void
      {
      }
      
      [Untrusted]
      public function getQuestInformations(param1:int) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getAllQuests() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getActiveQuests() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getCompletedQuests() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getReinitDoneQuests() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getAllQuestsOrderByCategory(param1:Boolean = false) : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getTutorialReward() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getNotificationList() : Array
      {
         return null;
      }
      
      [Untrusted]
      public function getFinishedAchievementsIds() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function isAchievementFinished(param1:int) : Boolean
      {
         return false;
      }
      
      [Untrusted]
      public function getAchievementKamasReward(param1:Achievement, param2:int = 0) : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getAchievementExperienceReward(param1:Achievement, param2:int = 0) : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getRewardableAchievements() : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getAchievementObjectivesNames(param1:int) : String
      {
         return null;
      }
      
      [Untrusted]
      public function getTreasureHunt(param1:int) : Object
      {
         return null;
      }
      
      [Untrusted]
      public function getAlmanaxQuestXpBonusMultiplier(param1:uint) : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function getAlmanaxQuestKamasBonusMultiplier(param1:uint) : Number
      {
         return 0;
      }
      
      [Untrusted]
      public function toggleWorldMask(param1:String, param2:Boolean) : void
      {
      }
   }
}
