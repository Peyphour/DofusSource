package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ClearChatAction implements Action
   {
       
      
      public var channel:Array;
      
      public function ClearChatAction()
      {
         super();
      }
      
      public static function create(param1:Array) : ClearChatAction
      {
         var _loc2_:ClearChatAction = new ClearChatAction();
         _loc2_.channel = param1;
         return _loc2_;
      }
   }
}
