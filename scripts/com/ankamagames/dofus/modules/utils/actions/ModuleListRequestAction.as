package com.ankamagames.dofus.modules.utils.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ModuleListRequestAction implements Action
   {
       
      
      public var moduleListUrl:String;
      
      public function ModuleListRequestAction()
      {
         super();
      }
      
      public static function create(param1:String) : ModuleListRequestAction
      {
         var _loc2_:ModuleListRequestAction = new ModuleListRequestAction();
         _loc2_.moduleListUrl = param1;
         return _loc2_;
      }
   }
}
