package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TimelineEntityOverAction implements Action
   {
       
      
      public var targetId:Number;
      
      public var showRange:Boolean;
      
      public var highlightTimelineFighter:Boolean;
      
      public function TimelineEntityOverAction()
      {
         super();
      }
      
      public static function create(param1:Number, param2:Boolean, param3:Boolean = true) : TimelineEntityOverAction
      {
         var _loc4_:TimelineEntityOverAction = new TimelineEntityOverAction();
         _loc4_.targetId = param1;
         _loc4_.showRange = param2;
         _loc4_.highlightTimelineFighter = param3;
         return _loc4_;
      }
   }
}
