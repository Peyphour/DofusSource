package com.ankamagames.dofus.network.messages.game.context.roleplay.houses
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class HouseSellRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5697;
       
      
      private var _isInitialized:Boolean = false;
      
      public var amount:uint = 0;
      
      public var forSale:Boolean = false;
      
      public function HouseSellRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5697;
      }
      
      public function initHouseSellRequestMessage(param1:uint = 0, param2:Boolean = false) : HouseSellRequestMessage
      {
         this.amount = param1;
         this.forSale = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.amount = 0;
         this.forSale = false;
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
         this.serializeAs_HouseSellRequestMessage(param1);
      }
      
      public function serializeAs_HouseSellRequestMessage(param1:ICustomDataOutput) : void
      {
         if(this.amount < 0)
         {
            throw new Error("Forbidden value (" + this.amount + ") on element amount.");
         }
         param1.writeVarInt(this.amount);
         param1.writeBoolean(this.forSale);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_HouseSellRequestMessage(param1);
      }
      
      public function deserializeAs_HouseSellRequestMessage(param1:ICustomDataInput) : void
      {
         this.amount = param1.readVarUhInt();
         if(this.amount < 0)
         {
            throw new Error("Forbidden value (" + this.amount + ") on element of HouseSellRequestMessage.amount.");
         }
         this.forSale = param1.readBoolean();
      }
   }
}
