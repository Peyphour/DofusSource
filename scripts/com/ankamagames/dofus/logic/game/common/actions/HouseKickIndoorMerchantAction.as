package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseKickIndoorMerchantAction implements Action
   {
       
      
      public var cellId:uint;
      
      public function HouseKickIndoorMerchantAction()
      {
         super();
      }
      
      public static function create(param1:uint) : HouseKickIndoorMerchantAction
      {
         var _loc2_:HouseKickIndoorMerchantAction = new HouseKickIndoorMerchantAction();
         _loc2_.cellId = param1;
         return _loc2_;
      }
   }
}
