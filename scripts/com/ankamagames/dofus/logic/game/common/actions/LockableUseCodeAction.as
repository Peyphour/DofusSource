package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class LockableUseCodeAction implements Action
   {
       
      
      public var code:String;
      
      public function LockableUseCodeAction()
      {
         super();
      }
      
      public static function create(param1:String) : LockableUseCodeAction
      {
         var _loc2_:LockableUseCodeAction = new LockableUseCodeAction();
         _loc2_.code = param1;
         return _loc2_;
      }
   }
}
