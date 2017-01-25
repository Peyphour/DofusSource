package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
   import com.ankamagames.dofus.network.types.game.mount.MountClientData;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ExchangeMountsStableBornAddMessage extends ExchangeMountsStableAddMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6557;
       
      
      private var _isInitialized:Boolean = false;
      
      public function ExchangeMountsStableBornAddMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6557;
      }
      
      public function initExchangeMountsStableBornAddMessage(param1:Vector.<MountClientData> = null) : ExchangeMountsStableBornAddMessage
      {
         super.initExchangeMountsStableAddMessage(param1);
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
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
         this.serializeAs_ExchangeMountsStableBornAddMessage(param1);
      }
      
      public function serializeAs_ExchangeMountsStableBornAddMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_ExchangeMountsStableAddMessage(param1);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ExchangeMountsStableBornAddMessage(param1);
      }
      
      public function deserializeAs_ExchangeMountsStableBornAddMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
      }
   }
}
