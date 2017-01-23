package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildChangeMemberParametersAction implements Action
   {
       
      
      public var memberId:Number;
      
      public var rank:uint;
      
      public var experienceGivenPercent:uint;
      
      public var rights:Array;
      
      public function GuildChangeMemberParametersAction()
      {
         super();
      }
      
      public static function create(param1:Number, param2:uint, param3:uint, param4:Array) : GuildChangeMemberParametersAction
      {
         var _loc5_:GuildChangeMemberParametersAction = new GuildChangeMemberParametersAction();
         _loc5_.memberId = param1;
         _loc5_.rank = param2;
         _loc5_.experienceGivenPercent = param3;
         _loc5_.rights = param4;
         return _loc5_;
      }
   }
}
