package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseLockFromInsideAction implements Action
   {
       
      
      public var code:String;
      
      public function HouseLockFromInsideAction()
      {
         super();
      }
      
      public static function create(param1:String) : HouseLockFromInsideAction
      {
         var _loc2_:HouseLockFromInsideAction = new HouseLockFromInsideAction();
         _loc2_.code = param1;
         return _loc2_;
      }
   }
}
