package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class MemberWarningSetAction implements Action
   {
       
      
      public var enable:Boolean;
      
      public function MemberWarningSetAction()
      {
         super();
      }
      
      public static function create(param1:Boolean) : MemberWarningSetAction
      {
         var _loc2_:MemberWarningSetAction = new MemberWarningSetAction();
         _loc2_.enable = param1;
         return _loc2_;
      }
   }
}
