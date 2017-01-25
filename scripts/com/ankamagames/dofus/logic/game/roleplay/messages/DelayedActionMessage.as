package com.ankamagames.dofus.logic.game.roleplay.messages
{
   import com.ankamagames.jerakine.messages.Message;
   
   public class DelayedActionMessage implements Message
   {
       
      
      private var _playerId:Number;
      
      private var _itemId:uint;
      
      private var _endTime:Number;
      
      public function DelayedActionMessage(param1:Number, param2:uint, param3:Number)
      {
         super();
         this._playerId = param1;
         this._itemId = param2;
         this._endTime = param3;
      }
      
      public function get playerId() : Number
      {
         return this._playerId;
      }
      
      public function get itemId() : uint
      {
         return this._itemId;
      }
      
      public function get endTime() : Number
      {
         return this._endTime;
      }
   }
}
