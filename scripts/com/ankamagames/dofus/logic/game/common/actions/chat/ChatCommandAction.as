package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChatCommandAction implements Action
   {
       
      
      public var command:String;
      
      public function ChatCommandAction()
      {
         super();
      }
      
      public static function create(param1:String) : ChatCommandAction
      {
         var _loc2_:ChatCommandAction = new ChatCommandAction();
         _loc2_.command = param1;
         return _loc2_;
      }
   }
}
