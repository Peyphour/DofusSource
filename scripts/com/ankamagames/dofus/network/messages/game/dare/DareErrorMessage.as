package com.ankamagames.dofus.network.messages.game.dare
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class DareErrorMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6667;
       
      
      private var _isInitialized:Boolean = false;
      
      public var error:uint = 0;
      
      public function DareErrorMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6667;
      }
      
      public function initDareErrorMessage(param1:uint = 0) : DareErrorMessage
      {
         this.error = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.error = 0;
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
         this.serializeAs_DareErrorMessage(param1);
      }
      
      public function serializeAs_DareErrorMessage(param1:ICustomDataOutput) : void
      {
         param1.writeByte(this.error);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_DareErrorMessage(param1);
      }
      
      public function deserializeAs_DareErrorMessage(param1:ICustomDataInput) : void
      {
         this.error = param1.readByte();
         if(this.error < 0)
         {
            throw new Error("Forbidden value (" + this.error + ") on element of DareErrorMessage.error.");
         }
      }
   }
}
