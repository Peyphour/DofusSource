package com.ankamagames.dofus.logic.game.common.actions.craft
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JobBookSubscribeRequestAction implements Action
   {
       
      
      public var jobIds:Vector.<uint>;
      
      public function JobBookSubscribeRequestAction()
      {
         super();
      }
      
      public static function create(param1:Vector.<uint>) : JobBookSubscribeRequestAction
      {
         var _loc2_:JobBookSubscribeRequestAction = new JobBookSubscribeRequestAction();
         _loc2_.jobIds = param1;
         return _loc2_;
      }
   }
}
