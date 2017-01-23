package com.ankamagames.dofus.internalDatacenter.quest
{
   public class TreasureHuntWrapper
   {
       
      
      public function TreasureHuntWrapper()
      {
         super();
      }
      
      public function get questType() : uint
      {
         return new uint();
      }
      
      public function get checkPointCurrent() : uint
      {
         return new uint();
      }
      
      public function get checkPointTotal() : uint
      {
         return new uint();
      }
      
      public function get totalStepCount() : uint
      {
         return new uint();
      }
      
      public function get availableRetryCount() : int
      {
         return new int();
      }
      
      public function get stepList() : Vector.<TreasureHuntStepWrapper>
      {
         return new Vector.<TreasureHuntStepWrapper>();
      }
   }
}
