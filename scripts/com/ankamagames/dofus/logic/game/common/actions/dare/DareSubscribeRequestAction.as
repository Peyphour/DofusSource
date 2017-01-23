package com.ankamagames.dofus.logic.game.common.actions.dare
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class DareSubscribeRequestAction implements Action
   {
       
      
      public var dareId:Number;
      
      public var subscribe:Boolean;
      
      public function DareSubscribeRequestAction()
      {
         super();
      }
      
      public static function create(param1:Number, param2:Boolean) : DareSubscribeRequestAction
      {
         var _loc3_:DareSubscribeRequestAction = new DareSubscribeRequestAction();
         _loc3_.dareId = param1;
         _loc3_.subscribe = param2;
         return _loc3_;
      }
   }
}
