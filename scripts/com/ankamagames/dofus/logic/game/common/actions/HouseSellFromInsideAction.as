package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseSellFromInsideAction implements Action
   {
       
      
      public var amount:uint;
      
      public var forSale:Boolean;
      
      public function HouseSellFromInsideAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Boolean = true) : HouseSellFromInsideAction
      {
         var _loc3_:HouseSellFromInsideAction = new HouseSellFromInsideAction();
         _loc3_.amount = param1;
         _loc3_.forSale = param2;
         return _loc3_;
      }
   }
}
