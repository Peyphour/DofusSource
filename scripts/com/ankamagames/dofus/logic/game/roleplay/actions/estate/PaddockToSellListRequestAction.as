package com.ankamagames.dofus.logic.game.roleplay.actions.estate
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PaddockToSellListRequestAction implements Action
   {
       
      
      public var pageIndex:uint;
      
      public function PaddockToSellListRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : PaddockToSellListRequestAction
      {
         var _loc2_:PaddockToSellListRequestAction = new PaddockToSellListRequestAction();
         _loc2_.pageIndex = param1;
         return _loc2_;
      }
   }
}
