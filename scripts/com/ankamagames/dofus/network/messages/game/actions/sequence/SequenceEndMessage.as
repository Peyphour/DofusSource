package com.ankamagames.dofus.network.messages.game.actions.sequence
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class SequenceEndMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 956;
       
      
      private var _isInitialized:Boolean = false;
      
      public var actionId:uint = 0;
      
      public var authorId:Number = 0;
      
      public var sequenceType:int = 0;
      
      public function SequenceEndMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 956;
      }
      
      public function initSequenceEndMessage(param1:uint = 0, param2:Number = 0, param3:int = 0) : SequenceEndMessage
      {
         this.actionId = param1;
         this.authorId = param2;
         this.sequenceType = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.actionId = 0;
         this.authorId = 0;
         this.sequenceType = 0;
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
         this.serializeAs_SequenceEndMessage(param1);
      }
      
      public function serializeAs_SequenceEndMessage(param1:ICustomDataOutput) : void
      {
         if(this.actionId < 0)
         {
            throw new Error("Forbidden value (" + this.actionId + ") on element actionId.");
         }
         param1.writeVarShort(this.actionId);
         if(this.authorId < -9007199254740990 || this.authorId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.authorId + ") on element authorId.");
         }
         param1.writeDouble(this.authorId);
         param1.writeByte(this.sequenceType);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_SequenceEndMessage(param1);
      }
      
      public function deserializeAs_SequenceEndMessage(param1:ICustomDataInput) : void
      {
         this.actionId = param1.readVarUhShort();
         if(this.actionId < 0)
         {
            throw new Error("Forbidden value (" + this.actionId + ") on element of SequenceEndMessage.actionId.");
         }
         this.authorId = param1.readDouble();
         if(this.authorId < -9007199254740990 || this.authorId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.authorId + ") on element of SequenceEndMessage.authorId.");
         }
         this.sequenceType = param1.readByte();
      }
   }
}
