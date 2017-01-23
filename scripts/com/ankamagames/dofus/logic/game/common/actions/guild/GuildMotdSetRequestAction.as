package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildMotdSetRequestAction implements Action
   {
       
      
      public var content:String;
      
      public function GuildMotdSetRequestAction()
      {
         super();
      }
      
      public static function create(param1:String) : GuildMotdSetRequestAction
      {
         var _loc2_:GuildMotdSetRequestAction = new GuildMotdSetRequestAction();
         _loc2_.content = param1;
         return _loc2_;
      }
   }
}
