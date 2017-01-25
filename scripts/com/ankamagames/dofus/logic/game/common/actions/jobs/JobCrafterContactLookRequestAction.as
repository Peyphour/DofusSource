package com.ankamagames.dofus.logic.game.common.actions.jobs
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JobCrafterContactLookRequestAction implements Action
   {
       
      
      public var crafterId:Number;
      
      public function JobCrafterContactLookRequestAction()
      {
         super();
      }
      
      public static function create(param1:Number) : JobCrafterContactLookRequestAction
      {
         var _loc2_:JobCrafterContactLookRequestAction = new JobCrafterContactLookRequestAction();
         _loc2_.crafterId = param1;
         return _loc2_;
      }
   }
}
