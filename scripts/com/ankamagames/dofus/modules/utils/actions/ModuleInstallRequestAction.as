package com.ankamagames.dofus.modules.utils.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ModuleInstallRequestAction implements Action
   {
       
      
      public var moduleUrl:String;
      
      public function ModuleInstallRequestAction()
      {
         super();
      }
      
      public static function create(param1:String) : ModuleInstallRequestAction
      {
         var _loc2_:ModuleInstallRequestAction = new ModuleInstallRequestAction();
         _loc2_.moduleUrl = param1;
         return _loc2_;
      }
   }
}
