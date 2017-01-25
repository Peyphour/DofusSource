package com.ankamagames.dofus.network.messages.game.context.fight
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameFightReadyMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 708;
       
      
      private var _isInitialized:Boolean = false;
      
      public var isReady:Boolean = false;
      
      public function GameFightReadyMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 708;
      }
      
      public function initGameFightReadyMessage(param1:Boolean = false) : GameFightReadyMessage
      {
         this.isReady = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.isReady = false;
         this._isInitialized = false;
      }
      
      override public function pack(param1:ICustomDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(new CustomDataWrapper(_loc2_));
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:ICustomDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameFightReadyMessage(param1);
      }
      
      public function serializeAs_GameFightReadyMessage(param1:ICustomDataOutput) : void
      {
         param1.writeBoolean(this.isReady);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameFightReadyMessage(param1);
      }
      
      public function deserializeAs_GameFightReadyMessage(param1:ICustomDataInput) : void
      {
         this.isReady = param1.readBoolean();
      }
   }
}
