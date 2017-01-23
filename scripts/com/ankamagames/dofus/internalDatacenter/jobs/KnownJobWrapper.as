package com.ankamagames.dofus.internalDatacenter.jobs
{
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobDescription;
   import com.ankamagames.jerakine.interfaces.IDataCenter;
   
   public class KnownJobWrapper implements IDataCenter
   {
       
      
      public var id:int;
      
      public var jobDescription:JobDescription;
      
      public var name:String;
      
      public var iconId:int;
      
      public var jobLevel:uint = 0;
      
      public var jobXP:Number = 0;
      
      public var jobXpLevelFloor:Number = 0;
      
      public var jobXpNextLevelFloor:Number = 0;
      
      public var jobBookSubscriber:Boolean = false;
      
      public function KnownJobWrapper()
      {
         super();
      }
      
      public static function create(param1:int) : KnownJobWrapper
      {
         var _loc2_:KnownJobWrapper = new KnownJobWrapper();
         _loc2_.id = param1;
         var _loc3_:Job = Job.getJobById(param1);
         if(_loc3_)
         {
            _loc2_.name = _loc3_.name;
            _loc2_.iconId = _loc3_.iconId;
         }
         return _loc2_;
      }
   }
}
