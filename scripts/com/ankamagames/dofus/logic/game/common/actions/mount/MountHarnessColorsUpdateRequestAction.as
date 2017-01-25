package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class MountHarnessColorsUpdateRequestAction implements Action
   {
       
      
      public var useHarnessColors:Boolean;
      
      public function MountHarnessColorsUpdateRequestAction()
      {
         super();
      }
      
      public static function create(param1:Boolean) : MountHarnessColorsUpdateRequestAction
      {
         var _loc2_:MountHarnessColorsUpdateRequestAction = new MountHarnessColorsUpdateRequestAction();
         _loc2_.useHarnessColors = param1;
         return _loc2_;
      }
   }
}
