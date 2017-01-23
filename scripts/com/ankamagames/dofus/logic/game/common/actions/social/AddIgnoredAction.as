package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AddIgnoredAction implements Action
   {
       
      
      public var name:String;
      
      public function AddIgnoredAction()
      {
         super();
      }
      
      public static function create(param1:String) : AddIgnoredAction
      {
         var _loc2_:AddIgnoredAction = new AddIgnoredAction();
         _loc2_.name = param1;
         return _loc2_;
      }
   }
}
