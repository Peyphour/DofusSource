package com.ankamagames.dofus.internalDatacenter.jobs
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobDescription;
   
   public class KnownJobWrapper
   {
       
      
      public function KnownJobWrapper()
      {
         super();
      }
      
      public function get id() : int
      {
         return new int();
      }
      
      public function get jobDescription() : JobDescription
      {
         return new JobDescription();
      }
      
      public function get name() : String
      {
         return new String();
      }
      
      public function get iconId() : int
      {
         return new int();
      }
      
      public function get jobLevel() : uint
      {
         return new uint();
      }
      
      public function get jobXP() : Number
      {
         return new Number();
      }
      
      public function get jobXpLevelFloor() : Number
      {
         return new Number();
      }
      
      public function get jobXpNextLevelFloor() : Number
      {
         return new Number();
      }
      
      public function get jobBookSubscriber() : Boolean
      {
         return new Boolean();
      }
   }
}
