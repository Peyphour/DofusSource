package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeStartedWithPodsMessage extends ExchangeStartedMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6129;
       
      
      private var _isInitialized:Boolean = false;
      
      public var firstCharacterId:Number = 0;
      
      public var firstCharacterCurrentWeight:uint = 0;
      
      public var firstCharacterMaxWeight:uint = 0;
      
      public var secondCharacterId:Number = 0;
      
      public var secondCharacterCurrentWeight:uint = 0;
      
      public var secondCharacterMaxWeight:uint = 0;
      
      public function ExchangeStartedWithPodsMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6129;
      }
      
      public function initExchangeStartedWithPodsMessage(param1:int = 0, param2:Number = 0, param3:uint = 0, param4:uint = 0, param5:Number = 0, param6:uint = 0, param7:uint = 0) : ExchangeStartedWithPodsMessage
      {
         super.initExchangeStartedMessage(param1);
         this.firstCharacterId = param2;
         this.firstCharacterCurrentWeight = param3;
         this.firstCharacterMaxWeight = param4;
         this.secondCharacterId = param5;
         this.secondCharacterCurrentWeight = param6;
         this.secondCharacterMaxWeight = param7;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.firstCharacterId = 0;
         this.firstCharacterCurrentWeight = 0;
         this.firstCharacterMaxWeight = 0;
         this.secondCharacterId = 0;
         this.secondCharacterCurrentWeight = 0;
         this.secondCharacterMaxWeight = 0;
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
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_ExchangeStartedWithPodsMessage(param1);
      }
      
      public function serializeAs_ExchangeStartedWithPodsMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_ExchangeStartedMessage(param1);
         if(this.firstCharacterId < -9007199254740990 || this.firstCharacterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.firstCharacterId + ") on element firstCharacterId.");
         }
         param1.writeDouble(this.firstCharacterId);
         if(this.firstCharacterCurrentWeight < 0)
         {
            throw new Error("Forbidden value (" + this.firstCharacterCurrentWeight + ") on element firstCharacterCurrentWeight.");
         }
         param1.writeVarInt(this.firstCharacterCurrentWeight);
         if(this.firstCharacterMaxWeight < 0)
         {
            throw new Error("Forbidden value (" + this.firstCharacterMaxWeight + ") on element firstCharacterMaxWeight.");
         }
         param1.writeVarInt(this.firstCharacterMaxWeight);
         if(this.secondCharacterId < -9007199254740990 || this.secondCharacterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.secondCharacterId + ") on element secondCharacterId.");
         }
         param1.writeDouble(this.secondCharacterId);
         if(this.secondCharacterCurrentWeight < 0)
         {
            throw new Error("Forbidden value (" + this.secondCharacterCurrentWeight + ") on element secondCharacterCurrentWeight.");
         }
         param1.writeVarInt(this.secondCharacterCurrentWeight);
         if(this.secondCharacterMaxWeight < 0)
         {
            throw new Error("Forbidden value (" + this.secondCharacterMaxWeight + ") on element secondCharacterMaxWeight.");
         }
         param1.writeVarInt(this.secondCharacterMaxWeight);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeStartedWithPodsMessage(param1);
      }
      
      public function deserializeAs_ExchangeStartedWithPodsMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.firstCharacterId = param1.readDouble();
         if(this.firstCharacterId < -9007199254740990 || this.firstCharacterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.firstCharacterId + ") on element of ExchangeStartedWithPodsMessage.firstCharacterId.");
         }
         this.firstCharacterCurrentWeight = param1.readVarUhInt();
         if(this.firstCharacterCurrentWeight < 0)
         {
            throw new Error("Forbidden value (" + this.firstCharacterCurrentWeight + ") on element of ExchangeStartedWithPodsMessage.firstCharacterCurrentWeight.");
         }
         this.firstCharacterMaxWeight = param1.readVarUhInt();
         if(this.firstCharacterMaxWeight < 0)
         {
            throw new Error("Forbidden value (" + this.firstCharacterMaxWeight + ") on element of ExchangeStartedWithPodsMessage.firstCharacterMaxWeight.");
         }
         this.secondCharacterId = param1.readDouble();
         if(this.secondCharacterId < -9007199254740990 || this.secondCharacterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.secondCharacterId + ") on element of ExchangeStartedWithPodsMessage.secondCharacterId.");
         }
         this.secondCharacterCurrentWeight = param1.readVarUhInt();
         if(this.secondCharacterCurrentWeight < 0)
         {
            throw new Error("Forbidden value (" + this.secondCharacterCurrentWeight + ") on element of ExchangeStartedWithPodsMessage.secondCharacterCurrentWeight.");
         }
         this.secondCharacterMaxWeight = param1.readVarUhInt();
         if(this.secondCharacterMaxWeight < 0)
         {
            throw new Error("Forbidden value (" + this.secondCharacterMaxWeight + ") on element of ExchangeStartedWithPodsMessage.secondCharacterMaxWeight.");
         }
      }
   }
}
