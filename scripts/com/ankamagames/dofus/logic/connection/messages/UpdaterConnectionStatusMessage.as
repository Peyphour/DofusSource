package com.ankamagames.dofus.logic.connection.messages
{
   import com.ankamagames.jerakine.messages.Message;
   
   public class UpdaterConnectionStatusMessage implements Message
   {
       
      
      private var _success:Boolean;
      
      public function UpdaterConnectionStatusMessage(param1:Boolean)
      {
         super();
         this._success = param1;
      }
      
      public function get success() : Boolean
      {
         return this._success;
      }
   }
}
