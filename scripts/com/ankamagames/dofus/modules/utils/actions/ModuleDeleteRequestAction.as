package com.ankamagames.dofus.modules.utils.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ModuleDeleteRequestAction implements Action
   {
       
      
      public var moduleDirectory:String;
      
      public function ModuleDeleteRequestAction()
      {
         super();
      }
      
      public static function create(param1:String) : ModuleDeleteRequestAction
      {
         var _loc2_:ModuleDeleteRequestAction = new ModuleDeleteRequestAction();
         _loc2_.moduleDirectory = param1;
         return _loc2_;
      }
   }
}
