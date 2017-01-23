package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PlayerStatusUpdateRequestAction implements Action
   {
       
      
      public var status:int;
      
      public var message:String;
      
      public function PlayerStatusUpdateRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:String = "") : PlayerStatusUpdateRequestAction
      {
         var _loc3_:PlayerStatusUpdateRequestAction = new PlayerStatusUpdateRequestAction();
         _loc3_.status = param1;
         _loc3_.message = param2;
         return _loc3_;
      }
   }
}
