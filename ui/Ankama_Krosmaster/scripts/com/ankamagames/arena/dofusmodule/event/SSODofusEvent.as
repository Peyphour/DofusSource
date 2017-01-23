package com.ankamagames.arena.dofusmodule.event
{
   import flash.events.Event;
   
   public class SSODofusEvent extends Event
   {
       
      
      private var _nick:String = "";
      
      private var _token:String = "";
      
      private var _gameId:int = 0;
      
      public function SSODofusEvent(param1:String, param2:String, param3:String, param4:int)
      {
         super(param1,false,false);
         this._nick = param2;
         this._token = param3;
         this._gameId = param4;
      }
      
      public function get gameId() : int
      {
         return this._gameId;
      }
      
      public function get token() : String
      {
         return this._token;
      }
      
      public function get nick() : String
      {
         return this._nick;
      }
      
      override public function clone() : Event
      {
         return new SSODofusEvent(type,this._nick,this._token,this._gameId);
      }
   }
}
