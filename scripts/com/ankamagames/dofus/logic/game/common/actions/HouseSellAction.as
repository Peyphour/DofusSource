package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseSellAction implements Action
   {
       
      
      public var amount:uint;
      
      public var forSale:Boolean;
      
      public function HouseSellAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Boolean = true) : HouseSellAction
      {
         var _loc3_:HouseSellAction = new HouseSellAction();
         _loc3_.amount = param1;
         _loc3_.forSale = param2;
         return _loc3_;
      }
   }
}
