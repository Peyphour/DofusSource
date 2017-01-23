package com.ankamagames.dofus.logic.connection.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ShowSteamLoginInterfaceAction implements Action
   {
       
      
      public function ShowSteamLoginInterfaceAction()
      {
         super();
      }
      
      public function create() : Action
      {
         return new ShowSteamLoginInterfaceAction();
      }
   }
}
