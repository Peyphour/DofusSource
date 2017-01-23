package com.ankamagames.dofus.logic.connection.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ServerSelectionAction implements Action
   {
       
      
      public var serverId:int;
      
      public function ServerSelectionAction()
      {
         super();
      }
      
      public static function create(param1:int) : ServerSelectionAction
      {
         var _loc2_:ServerSelectionAction = new ServerSelectionAction();
         _loc2_.serverId = param1;
         return _loc2_;
      }
   }
}
