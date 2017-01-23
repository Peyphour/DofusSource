package com.ankamagames.dofus.logic.game.common.actions.humanVendor
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ExchangeOnHumanVendorRequestAction implements Action
   {
       
      
      public var humanVendorId:Number;
      
      public var humanVendorCell:int;
      
      public function ExchangeOnHumanVendorRequestAction()
      {
         super();
      }
      
      public static function create(param1:Number, param2:uint) : ExchangeOnHumanVendorRequestAction
      {
         var _loc3_:ExchangeOnHumanVendorRequestAction = new ExchangeOnHumanVendorRequestAction();
         _loc3_.humanVendorId = param1;
         _loc3_.humanVendorCell = param2;
         return _loc3_;
      }
   }
}
