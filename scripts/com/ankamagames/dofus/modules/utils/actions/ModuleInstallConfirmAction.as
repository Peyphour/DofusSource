package com.ankamagames.dofus.modules.utils.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ModuleInstallConfirmAction implements Action
   {
       
      
      public var isUpdate:Boolean;
      
      public function ModuleInstallConfirmAction()
      {
         super();
      }
      
      public static function create(param1:Boolean = false) : ModuleInstallConfirmAction
      {
         var _loc2_:ModuleInstallConfirmAction = new ModuleInstallConfirmAction();
         _loc2_.isUpdate = param1;
         return _loc2_;
      }
   }
}
