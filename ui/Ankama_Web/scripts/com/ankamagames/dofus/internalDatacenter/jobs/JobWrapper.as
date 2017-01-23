package com.ankamagames.dofus.internalDatacenter.jobs
{
   import com.ankamagames.dofus.datacenter.jobs.Job;
   
   public class JobWrapper
   {
       
      
      public function JobWrapper()
      {
         super();
      }
      
      public function get iconUri() : Object
      {
         return null;
      }
      
      public function get fullSizeIconUri() : Object
      {
         return null;
      }
      
      public function get errorIconUri() : Object
      {
         return null;
      }
      
      public function get info1() : String
      {
         return null;
      }
      
      public function get startTime() : int
      {
         return 0;
      }
      
      public function get endTime() : int
      {
         return 0;
      }
      
      public function get timer() : int
      {
         return 0;
      }
      
      public function get active() : Boolean
      {
         return false;
      }
      
      public function get jobId() : uint
      {
         return 0;
      }
      
      public function get gfxId() : uint
      {
         return 0;
      }
      
      public function get job() : Job
      {
         return null;
      }
   }
}
