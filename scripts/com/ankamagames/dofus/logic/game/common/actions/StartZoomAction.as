package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class StartZoomAction implements Action
   {
       
      
      public var playerId:Number;
      
      public var value:Number;
      
      public function StartZoomAction()
      {
         super();
      }
      
      public static function create(param1:Number, param2:Number) : StartZoomAction
      {
         var _loc3_:StartZoomAction = new StartZoomAction();
         _loc3_.playerId = param1;
         _loc3_.value = param2;
         return _loc3_;
      }
   }
}
