package com.ankamagames.dofus.logic.game.common.actions.dare
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class DareRewardRequestAction implements Action
   {
       
      
      public var dareId:Number;
      
      public var dareRewardType:int;
      
      public function DareRewardRequestAction()
      {
         super();
      }
      
      public static function create(param1:Number, param2:int = 0) : DareRewardRequestAction
      {
         var _loc3_:DareRewardRequestAction = new DareRewardRequestAction();
         _loc3_.dareId = param1;
         _loc3_.dareRewardType = param2;
         return _loc3_;
      }
   }
}
