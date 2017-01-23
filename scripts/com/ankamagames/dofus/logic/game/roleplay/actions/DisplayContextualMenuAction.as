package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class DisplayContextualMenuAction implements Action
   {
       
      
      public var playerId:Number;
      
      public function DisplayContextualMenuAction()
      {
         super();
      }
      
      public static function create(param1:Number) : DisplayContextualMenuAction
      {
         var _loc2_:DisplayContextualMenuAction = new DisplayContextualMenuAction();
         _loc2_.playerId = param1;
         return _loc2_;
      }
   }
}
