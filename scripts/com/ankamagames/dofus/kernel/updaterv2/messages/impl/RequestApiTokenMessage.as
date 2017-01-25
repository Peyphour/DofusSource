package com.ankamagames.dofus.kernel.updaterv2.messages.impl
{
   import com.ankamagames.dofus.kernel.updaterv2.messages.IUpdaterOutputMessage;
   import com.ankamagames.dofus.kernel.updaterv2.messages.UpdaterMessageIDEnum;
   
   public class RequestApiTokenMessage implements IUpdaterOutputMessage
   {
       
      
      private var _user:String;
      
      private var _gameId:int;
      
      public function RequestApiTokenMessage(param1:String, param2:int)
      {
         super();
         this._user = param1;
         this._gameId = param2;
      }
      
      public function serialize() : String
      {
         return by.blooddy.crypto.serialization.JSON.encode({
            "_msg_id":UpdaterMessageIDEnum.REQUEST_API_TOKEN,
            "user":this._user,
            "game_id":this._gameId
         });
      }
   }
}
