package com.ankamagames.dofus.logic.game.common.actions.alliance
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AllianceKickRequestAction implements Action
   {
       
      
      public var guildId:uint;
      
      public function AllianceKickRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint) : AllianceKickRequestAction
      {
         var _loc2_:AllianceKickRequestAction = new AllianceKickRequestAction();
         _loc2_.guildId = param1;
         return _loc2_;
      }
   }
}
