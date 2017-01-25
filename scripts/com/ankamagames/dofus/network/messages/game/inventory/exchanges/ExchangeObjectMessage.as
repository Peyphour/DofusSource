package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeObjectMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5515;
       
      
      private var _isInitialized:Boolean = false;
      
      public var remote:Boolean = false;
      
      public function ExchangeObjectMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5515;
      }
      
      public function initExchangeObjectMessage(param1:Boolean = false) : ExchangeObjectMessage
      {
         this.remote = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.remote = false;
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
         this.serializeAs_ExchangeObjectMessage(param1);
      }
      
      public function serializeAs_ExchangeObjectMessage(param1:ICustomDataOutput) : void
      {
         param1.writeBoolean(this.remote);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeObjectMessage(param1);
      }
      
      public function deserializeAs_ExchangeObjectMessage(param1:ICustomDataInput) : void
      {
         this.remote = param1.readBoolean();
      }
   }
}
