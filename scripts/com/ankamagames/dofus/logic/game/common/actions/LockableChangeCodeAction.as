package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class LockableChangeCodeAction implements Action
   {
       
      
      public var code:String;
      
      public function LockableChangeCodeAction()
      {
         super();
      }
      
      public static function create(param1:String) : LockableChangeCodeAction
      {
         var _loc2_:LockableChangeCodeAction = new LockableChangeCodeAction();
         _loc2_.code = param1;
         return _loc2_;
      }
   }
}
