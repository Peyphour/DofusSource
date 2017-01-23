package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildInvitationByNameAction implements Action
   {
       
      
      public var target:String;
      
      public function GuildInvitationByNameAction()
      {
         super();
      }
      
      public static function create(param1:String) : GuildInvitationByNameAction
      {
         var _loc2_:GuildInvitationByNameAction = new GuildInvitationByNameAction();
         _loc2_.target = param1;
         return _loc2_;
      }
   }
}
