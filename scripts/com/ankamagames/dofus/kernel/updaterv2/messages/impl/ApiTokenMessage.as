package com.ankamagames.dofus.kernel.updaterv2.messages.impl
{
   import com.ankamagames.dofus.kernel.updaterv2.messages.IUpdaterInputMessage;
   
   public class ApiTokenMessage implements IUpdaterInputMessage
   {
       
      
      private var _token:String;
      
      private var _error:int;
      
      public function ApiTokenMessage()
      {
         super();
      }
      
      public function deserialize(param1:Object) : void
      {
         this._token = param1["token"];
         this._error = param1["error"];
      }
      
      public function get error() : int
      {
         return this._error;
      }
      
      public function getToken() : String
      {
         return this._token;
      }
   }
}
