package com.ankamagames.dofus.logic.game.common.actions.prism
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PrismUseRequestAction implements Action
   {
       
      
      public var moduleType:int;
      
      public function PrismUseRequestAction()
      {
         super();
      }
      
      public static function create(param1:int) : PrismUseRequestAction
      {
         var _loc2_:PrismUseRequestAction = new PrismUseRequestAction();
         _loc2_.moduleType = param1;
         return _loc2_;
      }
   }
}
