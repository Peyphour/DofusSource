package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseBuyAction implements Action
   {
       
      
      public var proposedPrice:uint;
      
      public function HouseBuyAction()
      {
         super();
      }
      
      public static function create(param1:uint) : HouseBuyAction
      {
         var _loc2_:HouseBuyAction = new HouseBuyAction();
         _loc2_.proposedPrice = param1;
         return _loc2_;
      }
   }
}
