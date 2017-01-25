package com.ankamagames.dofus.network.messages.game.context.fight.challenge
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ChallengeResultMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6019;
       
      
      private var _isInitialized:Boolean = false;
      
      public var challengeId:uint = 0;
      
      public var success:Boolean = false;
      
      public function ChallengeResultMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6019;
      }
      
      public function initChallengeResultMessage(param1:uint = 0, param2:Boolean = false) : ChallengeResultMessage
      {
         this.challengeId = param1;
         this.success = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.challengeId = 0;
         this.success = false;
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
         this.serializeAs_ChallengeResultMessage(param1);
      }
      
      public function serializeAs_ChallengeResultMessage(param1:ICustomDataOutput) : void
      {
         if(this.challengeId < 0)
         {
            throw new Error("Forbidden value (" + this.challengeId + ") on element challengeId.");
         }
         param1.writeVarShort(this.challengeId);
         param1.writeBoolean(this.success);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ChallengeResultMessage(param1);
      }
      
      public function deserializeAs_ChallengeResultMessage(param1:ICustomDataInput) : void
      {
         this.challengeId = param1.readVarUhShort();
         if(this.challengeId < 0)
         {
            throw new Error("Forbidden value (" + this.challengeId + ") on element of ChallengeResultMessage.challengeId.");
         }
         this.success = param1.readBoolean();
      }
   }
}
