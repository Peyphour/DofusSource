package com.ankamagames.dofus.logic.game.common.actions.prism
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PrismInfoJoinLeaveRequestAction implements Action
   {
       
      
      public var join:Boolean;
      
      public function PrismInfoJoinLeaveRequestAction()
      {
         super();
      }
      
      public static function create(param1:Boolean) : PrismInfoJoinLeaveRequestAction
      {
         var _loc2_:PrismInfoJoinLeaveRequestAction = new PrismInfoJoinLeaveRequestAction();
         _loc2_.join = param1;
         return _loc2_;
      }
   }
}
