package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class NpcDialogReplyAction implements Action
   {
       
      
      public var replyId:uint;
      
      public function NpcDialogReplyAction()
      {
         super();
      }
      
      public static function create(param1:int) : NpcDialogReplyAction
      {
         var _loc2_:NpcDialogReplyAction = new NpcDialogReplyAction();
         _loc2_.replyId = param1;
         return _loc2_;
      }
   }
}
