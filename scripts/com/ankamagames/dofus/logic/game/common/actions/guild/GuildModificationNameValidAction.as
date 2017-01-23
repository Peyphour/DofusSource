package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildModificationNameValidAction implements Action
   {
       
      
      public var guildName:String;
      
      public function GuildModificationNameValidAction()
      {
         super();
      }
      
      public static function create(param1:String) : GuildModificationNameValidAction
      {
         var _loc2_:GuildModificationNameValidAction = new GuildModificationNameValidAction();
         _loc2_.guildName = param1;
         return _loc2_;
      }
   }
}
