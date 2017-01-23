package com.ankamagames.dofus.logic.connection.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AcquaintanceSearchAction implements Action
   {
       
      
      public var friendName:String;
      
      public function AcquaintanceSearchAction()
      {
         super();
      }
      
      public static function create(param1:String) : AcquaintanceSearchAction
      {
         var _loc2_:AcquaintanceSearchAction = new AcquaintanceSearchAction();
         _loc2_.friendName = param1;
         return _loc2_;
      }
   }
}
