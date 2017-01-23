package com.ankamagames.dofus.modules.utils.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class InstalledModuleInfoRequestAction implements Action
   {
       
      
      public var moduleId:String;
      
      public function InstalledModuleInfoRequestAction()
      {
         super();
      }
      
      public static function create(param1:String) : InstalledModuleInfoRequestAction
      {
         var _loc2_:InstalledModuleInfoRequestAction = new InstalledModuleInfoRequestAction();
         _loc2_.moduleId = param1;
         return _loc2_;
      }
   }
}
