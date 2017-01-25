package com.ankamagames.jerakine.network.messages
{
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.ServerConnection;
   
   public class ServerConnectionClosedMessage implements Message
   {
       
      
      private var _closedConnection:ServerConnection;
      
      public function ServerConnectionClosedMessage(param1:ServerConnection)
      {
         super();
         this._closedConnection = param1;
      }
      
      public function get closedConnection() : ServerConnection
      {
         return this._closedConnection;
      }
   }
}
