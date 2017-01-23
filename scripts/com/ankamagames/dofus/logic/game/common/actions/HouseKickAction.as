package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseKickAction implements Action
   {
       
      
      public var id:Number;
      
      public function HouseKickAction()
      {
         super();
      }
      
      public static function create(param1:Number) : HouseKickAction
      {
         var _loc2_:HouseKickAction = new HouseKickAction();
         _loc2_.id = param1;
         return _loc2_;
      }
   }
}
