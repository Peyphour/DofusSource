package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChatSmileyRequestAction implements Action
   {
       
      
      public var smileyId:int;
      
      public function ChatSmileyRequestAction()
      {
         super();
      }
      
      public static function create(param1:int) : ChatSmileyRequestAction
      {
         var _loc2_:ChatSmileyRequestAction = new ChatSmileyRequestAction();
         _loc2_.smileyId = param1;
         return _loc2_;
      }
   }
}
