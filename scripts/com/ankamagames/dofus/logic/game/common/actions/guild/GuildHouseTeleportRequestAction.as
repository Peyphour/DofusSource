package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildHouseTeleportRequestAction implements Action
   {
       
      
      public var houseId:uint;
      
      public function GuildHouseTeleportRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : GuildHouseTeleportRequestAction
      {
         var _loc2_:GuildHouseTeleportRequestAction = new GuildHouseTeleportRequestAction();
         _loc2_.houseId = param1;
         return _loc2_;
      }
   }
}
