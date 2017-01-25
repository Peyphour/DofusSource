package com.ankamagames.dofus.logic.game.common.actions.jobs
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JobCrafterDirectoryListRequestAction implements Action
   {
       
      
      public var jobId:uint;
      
      public function JobCrafterDirectoryListRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : JobCrafterDirectoryListRequestAction
      {
         var _loc2_:JobCrafterDirectoryListRequestAction = new JobCrafterDirectoryListRequestAction();
         _loc2_.jobId = param1;
         return _loc2_;
      }
   }
}
