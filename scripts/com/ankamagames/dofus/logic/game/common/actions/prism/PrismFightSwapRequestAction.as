package com.ankamagames.dofus.logic.game.common.actions.prism
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PrismFightSwapRequestAction implements Action
   {
       
      
      public var subAreaId:uint;
      
      public var targetId:Number;
      
      public function PrismFightSwapRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Number) : PrismFightSwapRequestAction
      {
         var _loc3_:PrismFightSwapRequestAction = new PrismFightSwapRequestAction();
         _loc3_.targetId = param2;
         _loc3_.subAreaId = param1;
         return _loc3_;
      }
   }
}
