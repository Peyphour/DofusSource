package com.ankamagames.dofus.network.messages.game.context.roleplay.treasureHunt
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class TreasureHuntDigRequestAnswerFailedMessage extends TreasureHuntDigRequestAnswerMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6509;
       
      
      private var _isInitialized:Boolean = false;
      
      public var wrongFlagCount:uint = 0;
      
      public function TreasureHuntDigRequestAnswerFailedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6509;
      }
      
      public function initTreasureHuntDigRequestAnswerFailedMessage(param1:uint = 0, param2:uint = 0, param3:uint = 0) : TreasureHuntDigRequestAnswerFailedMessage
      {
         super.initTreasureHuntDigRequestAnswerMessage(param1,param2);
         this.wrongFlagCount = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.wrongFlagCount = 0;
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
         this.serializeAs_TreasureHuntDigRequestAnswerFailedMessage(param1);
      }
      
      public function serializeAs_TreasureHuntDigRequestAnswerFailedMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_TreasureHuntDigRequestAnswerMessage(param1);
         if(this.wrongFlagCount < 0)
         {
            throw new Error("Forbidden value (" + this.wrongFlagCount + ") on element wrongFlagCount.");
         }
         param1.writeByte(this.wrongFlagCount);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_TreasureHuntDigRequestAnswerFailedMessage(param1);
      }
      
      public function deserializeAs_TreasureHuntDigRequestAnswerFailedMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.wrongFlagCount = param1.readByte();
         if(this.wrongFlagCount < 0)
         {
            throw new Error("Forbidden value (" + this.wrongFlagCount + ") on element of TreasureHuntDigRequestAnswerFailedMessage.wrongFlagCount.");
         }
      }
   }
}
