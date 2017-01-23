package com.ankamagames.dofus.logic.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AddBehaviorToStackAction implements Action
   {
       
      
      public var behavior:Array;
      
      public function AddBehaviorToStackAction(param1:Array = null)
      {
         super();
         this.behavior = param1 != null?param1:new Array();
      }
      
      public static function create() : AddBehaviorToStackAction
      {
         var _loc1_:AddBehaviorToStackAction = new AddBehaviorToStackAction(new Array());
         return _loc1_;
      }
   }
}
