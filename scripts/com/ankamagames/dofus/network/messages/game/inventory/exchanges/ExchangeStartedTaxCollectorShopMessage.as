package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.types.game.data.items.ObjectItem;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeStartedTaxCollectorShopMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6664;
       
      
      private var _isInitialized:Boolean = false;
      
      public var objects:Vector.<ObjectItem>;
      
      public var kamas:uint = 0;
      
      public function ExchangeStartedTaxCollectorShopMessage()
      {
         this.objects = new Vector.<ObjectItem>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6664;
      }
      
      public function initExchangeStartedTaxCollectorShopMessage(param1:Vector.<ObjectItem> = null, param2:uint = 0) : ExchangeStartedTaxCollectorShopMessage
      {
         this.objects = param1;
         this.kamas = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.objects = new Vector.<ObjectItem>();
         this.kamas = 0;
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
         this.serializeAs_ExchangeStartedTaxCollectorShopMessage(param1);
      }
      
      public function serializeAs_ExchangeStartedTaxCollectorShopMessage(param1:ICustomDataOutput) : void
      {
         param1.writeShort(this.objects.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.objects.length)
         {
            (this.objects[_loc2_] as ObjectItem).serializeAs_ObjectItem(param1);
            _loc2_++;
         }
         if(this.kamas < 0)
         {
            throw new Error("Forbidden value (" + this.kamas + ") on element kamas.");
         }
         param1.writeVarInt(this.kamas);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeStartedTaxCollectorShopMessage(param1);
      }
      
      public function deserializeAs_ExchangeStartedTaxCollectorShopMessage(param1:ICustomDataInput) : void
      {
         var _loc4_:ObjectItem = null;
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new ObjectItem();
            _loc4_.deserialize(param1);
            this.objects.push(_loc4_);
            _loc3_++;
         }
         this.kamas = param1.readVarUhInt();
         if(this.kamas < 0)
         {
            throw new Error("Forbidden value (" + this.kamas + ") on element of ExchangeStartedTaxCollectorShopMessage.kamas.");
         }
      }
   }
}
