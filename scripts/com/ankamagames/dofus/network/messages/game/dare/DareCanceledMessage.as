package com.ankamagames.dofus.network.messages.game.dare
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class DareCanceledMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6679;
       
      
      private var _isInitialized:Boolean = false;
      
      public var dareId:Number = 0;
      
      public function DareCanceledMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6679;
      }
      
      public function initDareCanceledMessage(param1:Number = 0) : DareCanceledMessage
      {
         this.dareId = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.dareId = 0;
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
         this.serializeAs_DareCanceledMessage(param1);
      }
      
      public function serializeAs_DareCanceledMessage(param1:ICustomDataOutput) : void
      {
         if(this.dareId < 0 || this.dareId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.dareId + ") on element dareId.");
         }
         param1.writeDouble(this.dareId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_DareCanceledMessage(param1);
      }
      
      public function deserializeAs_DareCanceledMessage(param1:ICustomDataInput) : void
      {
         this.dareId = param1.readDouble();
         if(this.dareId < 0 || this.dareId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.dareId + ") on element of DareCanceledMessage.dareId.");
         }
      }
   }
}
