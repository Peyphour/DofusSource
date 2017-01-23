package com.ankamagames.jerakine.network.messages
{
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.network.ServerConnection;
   
   public class ServerConnectionFailedMessage implements Message
   {
       
      
      private var _failedConnection:ServerConnection;
      
      private var _errorMessage:String;
      
      public function ServerConnectionFailedMessage(param1:ServerConnection, param2:String)
      {
         super();
         this._errorMessage = param2;
         this._failedConnection = param1;
      }
      
      public function get failedConnection() : ServerConnection
      {
         return this._failedConnection;
      }
      
      public function get errorMessage() : String
      {
         return this._errorMessage;
      }
   }
}
