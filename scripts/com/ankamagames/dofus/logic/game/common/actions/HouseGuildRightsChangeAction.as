package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseGuildRightsChangeAction implements Action
   {
       
      
      public var rights:int;
      
      public function HouseGuildRightsChangeAction()
      {
         super();
      }
      
      public static function create(param1:int) : HouseGuildRightsChangeAction
      {
         var _loc2_:HouseGuildRightsChangeAction = new HouseGuildRightsChangeAction();
         _loc2_.rights = param1;
         return _loc2_;
      }
   }
}
