package com.ankamagames.dofus.logic.game.common.actions.alliance
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class SetEnableAVARequestAction implements Action
   {
       
      
      public var enable:Boolean;
      
      public function SetEnableAVARequestAction()
      {
         super();
      }
      
      public static function create(param1:Boolean) : SetEnableAVARequestAction
      {
         var _loc2_:SetEnableAVARequestAction = new SetEnableAVARequestAction();
         _loc2_.enable = param1;
         return _loc2_;
      }
   }
}
