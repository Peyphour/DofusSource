package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeStartOkMulticraftCustomerMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5817;
       
      
      private var _isInitialized:Boolean = false;
      
      public var skillId:uint = 0;
      
      public var crafterJobLevel:uint = 0;
      
      public function ExchangeStartOkMulticraftCustomerMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5817;
      }
      
      public function initExchangeStartOkMulticraftCustomerMessage(param1:uint = 0, param2:uint = 0) : ExchangeStartOkMulticraftCustomerMessage
      {
         this.skillId = param1;
         this.crafterJobLevel = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.skillId = 0;
         this.crafterJobLevel = 0;
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
         this.serializeAs_ExchangeStartOkMulticraftCustomerMessage(param1);
      }
      
      public function serializeAs_ExchangeStartOkMulticraftCustomerMessage(param1:ICustomDataOutput) : void
      {
         if(this.skillId < 0)
         {
            throw new Error("Forbidden value (" + this.skillId + ") on element skillId.");
         }
         param1.writeVarInt(this.skillId);
         if(this.crafterJobLevel < 0 || this.crafterJobLevel > 255)
         {
            throw new Error("Forbidden value (" + this.crafterJobLevel + ") on element crafterJobLevel.");
         }
         param1.writeByte(this.crafterJobLevel);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeStartOkMulticraftCustomerMessage(param1);
      }
      
      public function deserializeAs_ExchangeStartOkMulticraftCustomerMessage(param1:ICustomDataInput) : void
      {
         this.skillId = param1.readVarUhInt();
         if(this.skillId < 0)
         {
            throw new Error("Forbidden value (" + this.skillId + ") on element of ExchangeStartOkMulticraftCustomerMessage.skillId.");
         }
         this.crafterJobLevel = param1.readUnsignedByte();
         if(this.crafterJobLevel < 0 || this.crafterJobLevel > 255)
         {
            throw new Error("Forbidden value (" + this.crafterJobLevel + ") on element of ExchangeStartOkMulticraftCustomerMessage.crafterJobLevel.");
         }
      }
   }
}
