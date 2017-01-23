package com.ankamagames.dofus.logic.game.roleplay.actions.estate
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseToSellListRequestAction implements Action
   {
       
      
      public var pageIndex:uint;
      
      public function HouseToSellListRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : HouseToSellListRequestAction
      {
         var _loc2_:HouseToSellListRequestAction = new HouseToSellListRequestAction();
         _loc2_.pageIndex = param1;
         return _loc2_;
      }
   }
}
