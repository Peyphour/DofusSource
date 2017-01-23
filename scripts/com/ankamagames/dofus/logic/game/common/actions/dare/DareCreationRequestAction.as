package com.ankamagames.dofus.logic.game.common.actions.dare
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class DareCreationRequestAction implements Action
   {
       
      
      public var jackpot:uint = 0;
      
      public var subscriptionFee:uint = 0;
      
      public var maxCountWinners:uint = 0;
      
      public var delayBeforeStart:Number = 0;
      
      public var duration:Number;
      
      public var isPrivate:Boolean;
      
      public var isForGuild:Boolean;
      
      public var isForAlliance:Boolean;
      
      public var needNotifications:Boolean;
      
      public var criteria:Vector.<Vector.<int>>;
      
      public function DareCreationRequestAction()
      {
         this.criteria = new Vector.<Vector.<int>>();
         super();
      }
      
      public static function create(param1:uint, param2:uint, param3:uint, param4:Number, param5:Number, param6:Boolean, param7:Boolean, param8:Boolean, param9:Boolean, param10:Vector.<Vector.<int>>) : DareCreationRequestAction
      {
         var _loc11_:DareCreationRequestAction = new DareCreationRequestAction();
         _loc11_.jackpot = param1;
         _loc11_.subscriptionFee = param2;
         _loc11_.maxCountWinners = param3;
         _loc11_.delayBeforeStart = param4;
         _loc11_.duration = param5;
         _loc11_.isPrivate = param6;
         _loc11_.isForGuild = param7;
         _loc11_.isForAlliance = param8;
         _loc11_.needNotifications = param9;
         _loc11_.criteria = param10;
         return _loc11_;
      }
   }
}
