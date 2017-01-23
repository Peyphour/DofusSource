package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildInvitationAction implements Action
   {
       
      
      public var targetId:Number;
      
      public function GuildInvitationAction()
      {
         super();
      }
      
      public static function create(param1:Number) : GuildInvitationAction
      {
         var _loc2_:GuildInvitationAction = new GuildInvitationAction();
         _loc2_.targetId = param1;
         return _loc2_;
      }
   }
}
