package com.ankamagames.arena.dofusmodule.adapter
{
   import d2api.SystemApi;
   import d2api.TimeApi;
   import d2hooks.ChatSendPreInit;
   import d2hooks.TextInformation;
   import flash.events.EventDispatcher;
   import flash.events.TextEvent;
   import flash.utils.describeType;
   
   public class ChatDofusCommnunicator extends EventDispatcher implements IChatCommunicator
   {
      
      public static const EVT_LOG_REQUEST:String = "com.ankamagames.arena.dofusmodule.adapter.ChatDofusCommnunicator.EVT_LOG_REQUEST";
      
      public static const EVT_SEND_MESSAGE_REQUEST:String = "com.ankamagames.arena.dofusmodule.adapter.ChatDofusCommnunicator.EVT_SEND_MESSAGE_REQUEST";
       
      
      private var _timeApi:TimeApi;
      
      private var _sysApi:SystemApi;
      
      public function ChatDofusCommnunicator(param1:SystemApi, param2:TimeApi)
      {
         super();
         this._sysApi = param1;
         this._timeApi = param2;
         this.init();
      }
      
      public function destroy() : void
      {
         this._timeApi = null;
         this._sysApi = null;
      }
      
      public function onChatSendPreInit(param1:String, param2:Object) : void
      {
         if(param1.indexOf("[Arena]") != -1)
         {
            param2["cancel"] = true;
            param1 = param1.substr(7);
            dispatchEvent(new TextEvent(EVT_SEND_MESSAGE_REQUEST,false,false,param1));
            dispatchEvent(new TextEvent(EVT_LOG_REQUEST,false,false,describeType(param2)));
         }
      }
      
      public function addUserMessage(param1:String, param2:String) : void
      {
         this._sysApi.dispatchHook(TextInformation,param1 + " : " + param2,0,this._timeApi.getTimestamp());
      }
      
      public function addInfoMessage(param1:String) : void
      {
         this._sysApi.dispatchHook(TextInformation,param1,0,this._timeApi.getTimestamp());
      }
      
      private function init() : void
      {
         this._sysApi.addHook(ChatSendPreInit,this.onChatSendPreInit);
      }
   }
}
