package com.ankamagames.dofus.logic.game.common.actions.dare
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class DareCancelRequestAction implements Action
   {
       
      
      public var dareId:Number;
      
      public function DareCancelRequestAction()
      {
         super();
      }
      
      public static function create(param1:Number) : DareCancelRequestAction
      {
         var _loc2_:DareCancelRequestAction = new DareCancelRequestAction();
         _loc2_.dareId = param1;
         return _loc2_;
      }
   }
}
