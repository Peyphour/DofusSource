package com.ankamagames.dofus.logic.game.common.actions.jobs
{
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJobWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobCrafterDirectorySettings;
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JobCrafterDirectoryDefineSettingsAction implements Action
   {
       
      
      public var jobId:uint;
      
      public var minLevel:uint;
      
      public var free:Boolean;
      
      public var settings:JobCrafterDirectorySettings;
      
      public function JobCrafterDirectoryDefineSettingsAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:Boolean) : JobCrafterDirectoryDefineSettingsAction
      {
         var _loc7_:KnownJobWrapper = null;
         var _loc4_:JobCrafterDirectoryDefineSettingsAction = new JobCrafterDirectoryDefineSettingsAction();
         _loc4_.jobId = param1;
         _loc4_.minLevel = param2;
         _loc4_.free = param3;
         _loc4_.settings = new JobCrafterDirectorySettings();
         var _loc5_:Array = PlayedCharacterManager.getInstance().jobs;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = _loc5_[_loc6_];
            if(_loc7_ && _loc7_.id == param1)
            {
               _loc4_.settings.initJobCrafterDirectorySettings(_loc6_,param2,param3);
            }
            _loc6_++;
         }
         return _loc4_;
      }
   }
}
