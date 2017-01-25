package com.ankamagames.dofus.network.messages.game.finishmoves
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class FinishMoveSetRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6703;
       
      
      private var _isInitialized:Boolean = false;
      
      public var finishMoveId:uint = 0;
      
      public var finishMoveState:Boolean = false;
      
      public function FinishMoveSetRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6703;
      }
      
      public function initFinishMoveSetRequestMessage(param1:uint = 0, param2:Boolean = false) : FinishMoveSetRequestMessage
      {
         this.finishMoveId = param1;
         this.finishMoveState = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.finishMoveId = 0;
         this.finishMoveState = false;
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
         this.serializeAs_FinishMoveSetRequestMessage(param1);
      }
      
      public function serializeAs_FinishMoveSetRequestMessage(param1:ICustomDataOutput) : void
      {
         if(this.finishMoveId < 0)
         {
            throw new Error("Forbidden value (" + this.finishMoveId + ") on element finishMoveId.");
         }
         param1.writeInt(this.finishMoveId);
         param1.writeBoolean(this.finishMoveState);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_FinishMoveSetRequestMessage(param1);
      }
      
      public function deserializeAs_FinishMoveSetRequestMessage(param1:ICustomDataInput) : void
      {
         this.finishMoveId = param1.readInt();
         if(this.finishMoveId < 0)
         {
            throw new Error("Forbidden value (" + this.finishMoveId + ") on element of FinishMoveSetRequestMessage.finishMoveId.");
         }
         this.finishMoveState = param1.readBoolean();
      }
   }
}
