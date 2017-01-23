package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildCharacsUpgradeRequestAction implements Action
   {
       
      
      public var charaTypeTarget:uint;
      
      public function GuildCharacsUpgradeRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : GuildCharacsUpgradeRequestAction
      {
         var _loc2_:GuildCharacsUpgradeRequestAction = new GuildCharacsUpgradeRequestAction();
         _loc2_.charaTypeTarget = param1;
         return _loc2_;
      }
   }
}
