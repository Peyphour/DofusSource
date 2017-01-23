package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GiftAssignRequestAction implements Action
   {
       
      
      public var giftId:uint;
      
      public var characterId:Number;
      
      public function GiftAssignRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Number) : GiftAssignRequestAction
      {
         var _loc3_:GiftAssignRequestAction = new GiftAssignRequestAction();
         _loc3_.giftId = param1;
         _loc3_.characterId = param2;
         return _loc3_;
      }
   }
}
