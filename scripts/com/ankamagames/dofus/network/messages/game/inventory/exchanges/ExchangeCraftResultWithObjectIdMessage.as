package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeCraftResultWithObjectIdMessage extends ExchangeCraftResultMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6000;
       
      
      private var _isInitialized:Boolean = false;
      
      public var objectGenericId:uint = 0;
      
      public function ExchangeCraftResultWithObjectIdMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6000;
      }
      
      public function initExchangeCraftResultWithObjectIdMessage(param1:uint = 0, param2:uint = 0) : ExchangeCraftResultWithObjectIdMessage
      {
         super.initExchangeCraftResultMessage(param1);
         this.objectGenericId = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.objectGenericId = 0;
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
         this.serializeAs_ExchangeCraftResultWithObjectIdMessage(param1);
      }
      
      public function serializeAs_ExchangeCraftResultWithObjectIdMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_ExchangeCraftResultMessage(param1);
         if(this.objectGenericId < 0)
         {
            throw new Error("Forbidden value (" + this.objectGenericId + ") on element objectGenericId.");
         }
         param1.writeVarShort(this.objectGenericId);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeCraftResultWithObjectIdMessage(param1);
      }
      
      public function deserializeAs_ExchangeCraftResultWithObjectIdMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.objectGenericId = param1.readVarUhShort();
         if(this.objectGenericId < 0)
         {
            throw new Error("Forbidden value (" + this.objectGenericId + ") on element of ExchangeCraftResultWithObjectIdMessage.objectGenericId.");
         }
      }
   }
}
