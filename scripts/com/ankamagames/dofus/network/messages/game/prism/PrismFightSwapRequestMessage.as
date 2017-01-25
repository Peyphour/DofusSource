package com.ankamagames.dofus.network.messages.game.prism
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class PrismFightSwapRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5901;
       
      
      private var _isInitialized:Boolean = false;
      
      public var subAreaId:uint = 0;
      
      public var targetId:Number = 0;
      
      public function PrismFightSwapRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5901;
      }
      
      public function initPrismFightSwapRequestMessage(param1:uint = 0, param2:Number = 0) : PrismFightSwapRequestMessage
      {
         this.subAreaId = param1;
         this.targetId = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.subAreaId = 0;
         this.targetId = 0;
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
         this.serializeAs_PrismFightSwapRequestMessage(param1);
      }
      
      public function serializeAs_PrismFightSwapRequestMessage(param1:ICustomDataOutput) : void
      {
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element subAreaId.");
         }
         param1.writeVarShort(this.subAreaId);
         if(this.targetId < 0 || this.targetId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.targetId + ") on element targetId.");
         }
         param1.writeVarLong(this.targetId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PrismFightSwapRequestMessage(param1);
      }
      
      public function deserializeAs_PrismFightSwapRequestMessage(param1:ICustomDataInput) : void
      {
         this.subAreaId = param1.readVarUhShort();
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element of PrismFightSwapRequestMessage.subAreaId.");
         }
         this.targetId = param1.readVarUhLong();
         if(this.targetId < 0 || this.targetId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.targetId + ") on element of PrismFightSwapRequestMessage.targetId.");
         }
      }
   }
}
