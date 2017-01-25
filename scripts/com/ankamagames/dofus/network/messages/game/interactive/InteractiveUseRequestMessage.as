package com.ankamagames.dofus.network.messages.game.interactive
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class InteractiveUseRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5001;
       
      
      private var _isInitialized:Boolean = false;
      
      public var elemId:uint = 0;
      
      public var skillInstanceUid:uint = 0;
      
      public function InteractiveUseRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5001;
      }
      
      public function initInteractiveUseRequestMessage(param1:uint = 0, param2:uint = 0) : InteractiveUseRequestMessage
      {
         this.elemId = param1;
         this.skillInstanceUid = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.elemId = 0;
         this.skillInstanceUid = 0;
         this._isInitialized = false;
      }
      
      override public function pack(param1:ICustomDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(new CustomDataWrapper(_loc2_));
         if(HASH_FUNCTION != null)
         {
            HASH_FUNCTION(_loc2_);
         }
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:ICustomDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_InteractiveUseRequestMessage(param1);
      }
      
      public function serializeAs_InteractiveUseRequestMessage(param1:ICustomDataOutput) : void
      {
         if(this.elemId < 0)
         {
            throw new Error("Forbidden value (" + this.elemId + ") on element elemId.");
         }
         param1.writeVarInt(this.elemId);
         if(this.skillInstanceUid < 0)
         {
            throw new Error("Forbidden value (" + this.skillInstanceUid + ") on element skillInstanceUid.");
         }
         param1.writeVarInt(this.skillInstanceUid);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_InteractiveUseRequestMessage(param1);
      }
      
      public function deserializeAs_InteractiveUseRequestMessage(param1:ICustomDataInput) : void
      {
         this.elemId = param1.readVarUhInt();
         if(this.elemId < 0)
         {
            throw new Error("Forbidden value (" + this.elemId + ") on element of InteractiveUseRequestMessage.elemId.");
         }
         this.skillInstanceUid = param1.readVarUhInt();
         if(this.skillInstanceUid < 0)
         {
            throw new Error("Forbidden value (" + this.skillInstanceUid + ") on element of InteractiveUseRequestMessage.skillInstanceUid.");
         }
      }
   }
}
