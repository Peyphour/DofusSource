package com.ankamagames.dofus.logic.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AuthorizedCommandAction implements Action
   {
       
      
      public var command:String;
      
      public function AuthorizedCommandAction()
      {
         super();
      }
      
      public static function create(param1:String) : AuthorizedCommandAction
      {
         var _loc2_:AuthorizedCommandAction = new AuthorizedCommandAction();
         _loc2_.command = param1;
         return _loc2_;
      }
   }
}
