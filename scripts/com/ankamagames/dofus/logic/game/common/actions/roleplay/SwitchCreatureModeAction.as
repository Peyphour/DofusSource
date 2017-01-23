package com.ankamagames.dofus.logic.game.common.actions.roleplay
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class SwitchCreatureModeAction implements Action
   {
       
      
      public var isActivated:Boolean;
      
      public function SwitchCreatureModeAction()
      {
         super();
      }
      
      public static function create(param1:Boolean = false) : SwitchCreatureModeAction
      {
         var _loc2_:SwitchCreatureModeAction = new SwitchCreatureModeAction();
         _loc2_.isActivated = param1;
         return _loc2_;
      }
   }
}
