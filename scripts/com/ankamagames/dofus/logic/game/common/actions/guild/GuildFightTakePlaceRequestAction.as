package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildFightTakePlaceRequestAction implements Action
   {
       
      
      public var taxCollectorId:uint;
      
      public var replacedCharacterId:Number;
      
      public function GuildFightTakePlaceRequestAction()
      {
         super();
      }
      
      public static function create(param1:uint, param2:Number) : GuildFightTakePlaceRequestAction
      {
         var _loc3_:GuildFightTakePlaceRequestAction = new GuildFightTakePlaceRequestAction();
         _loc3_.taxCollectorId = param1;
         _loc3_.replacedCharacterId = param2;
         return _loc3_;
      }
   }
}
