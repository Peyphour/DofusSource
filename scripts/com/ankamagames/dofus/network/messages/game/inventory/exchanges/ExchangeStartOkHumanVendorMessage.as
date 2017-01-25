package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItemToSellInHumanVendorShop;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeStartOkHumanVendorMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5767;
       
      
      private var _isInitialized:Boolean = false;
      
      public var sellerId:Number = 0;
      
      public var objectsInfos:Vector.<ObjectItemToSellInHumanVendorShop>;
      
      public function ExchangeStartOkHumanVendorMessage()
      {
         this.objectsInfos = new Vector.<ObjectItemToSellInHumanVendorShop>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5767;
      }
      
      public function initExchangeStartOkHumanVendorMessage(param1:Number = 0, param2:Vector.<ObjectItemToSellInHumanVendorShop> = null) : ExchangeStartOkHumanVendorMessage
      {
         this.sellerId = param1;
         this.objectsInfos = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.sellerId = 0;
         this.objectsInfos = new Vector.<ObjectItemToSellInHumanVendorShop>();
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
         this.serializeAs_ExchangeStartOkHumanVendorMessage(param1);
      }
      
      public function serializeAs_ExchangeStartOkHumanVendorMessage(param1:ICustomDataOutput) : void
      {
         if(this.sellerId < -9007199254740990 || this.sellerId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.sellerId + ") on element sellerId.");
         }
         param1.writeDouble(this.sellerId);
         param1.writeShort(this.objectsInfos.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.objectsInfos.length)
         {
            (this.objectsInfos[_loc2_] as ObjectItemToSellInHumanVendorShop).serializeAs_ObjectItemToSellInHumanVendorShop(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeStartOkHumanVendorMessage(param1);
      }
      
      public function deserializeAs_ExchangeStartOkHumanVendorMessage(param1:ICustomDataInput) : void
      {
         var _loc4_:ObjectItemToSellInHumanVendorShop = null;
         this.sellerId = param1.readDouble();
         if(this.sellerId < -9007199254740990 || this.sellerId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.sellerId + ") on element of ExchangeStartOkHumanVendorMessage.sellerId.");
         }
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new ObjectItemToSellInHumanVendorShop();
            _loc4_.deserialize(param1);
            this.objectsInfos.push(_loc4_);
            _loc3_++;
         }
      }
   }
}
