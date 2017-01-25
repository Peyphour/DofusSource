package com.ankamagames.dofus.network.messages.game.interactive.meeting
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class TeleportToBuddyAnswerMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6293;
       
      
      private var _isInitialized:Boolean = false;
      
      public var dungeonId:uint = 0;
      
      public var buddyId:Number = 0;
      
      public var accept:Boolean = false;
      
      public function TeleportToBuddyAnswerMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6293;
      }
      
      public function initTeleportToBuddyAnswerMessage(param1:uint = 0, param2:Number = 0, param3:Boolean = false) : TeleportToBuddyAnswerMessage
      {
         this.dungeonId = param1;
         this.buddyId = param2;
         this.accept = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.dungeonId = 0;
         this.buddyId = 0;
         this.accept = false;
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
         this.serializeAs_TeleportToBuddyAnswerMessage(param1);
      }
      
      public function serializeAs_TeleportToBuddyAnswerMessage(param1:ICustomDataOutput) : void
      {
         if(this.dungeonId < 0)
         {
            throw new Error("Forbidden value (" + this.dungeonId + ") on element dungeonId.");
         }
         param1.writeVarShort(this.dungeonId);
         if(this.buddyId < 0 || this.buddyId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.buddyId + ") on element buddyId.");
         }
         param1.writeVarLong(this.buddyId);
         param1.writeBoolean(this.accept);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_TeleportToBuddyAnswerMessage(param1);
      }
      
      public function deserializeAs_TeleportToBuddyAnswerMessage(param1:ICustomDataInput) : void
      {
         this.dungeonId = param1.readVarUhShort();
         if(this.dungeonId < 0)
         {
            throw new Error("Forbidden value (" + this.dungeonId + ") on element of TeleportToBuddyAnswerMessage.dungeonId.");
         }
         this.buddyId = param1.readVarUhLong();
         if(this.buddyId < 0 || this.buddyId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.buddyId + ") on element of TeleportToBuddyAnswerMessage.buddyId.");
         }
         this.accept = param1.readBoolean();
      }
   }
}
