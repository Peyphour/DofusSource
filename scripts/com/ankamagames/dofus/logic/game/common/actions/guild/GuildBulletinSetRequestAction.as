package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildBulletinSetRequestAction implements Action
   {
       
      
      public var content:String;
      
      public var notifyMembers:Boolean;
      
      public function GuildBulletinSetRequestAction()
      {
         super();
      }
      
      public static function create(param1:String, param2:Boolean = true) : GuildBulletinSetRequestAction
      {
         var _loc3_:GuildBulletinSetRequestAction = new GuildBulletinSetRequestAction();
         _loc3_.content = param1;
         _loc3_.notifyMembers = param2;
         return _loc3_;
      }
   }
}
