package com.ankamagames.dofus.network.messages.game.context.roleplay.delay
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameRolePlayDelayedActionFinishedMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6150;
       
      
      private var _isInitialized:Boolean = false;
      
      public var delayedCharacterId:Number = 0;
      
      public var delayTypeId:uint = 0;
      
      public function GameRolePlayDelayedActionFinishedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6150;
      }
      
      public function initGameRolePlayDelayedActionFinishedMessage(param1:Number = 0, param2:uint = 0) : GameRolePlayDelayedActionFinishedMessage
      {
         this.delayedCharacterId = param1;
         this.delayTypeId = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.delayedCharacterId = 0;
         this.delayTypeId = 0;
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
         this.serializeAs_GameRolePlayDelayedActionFinishedMessage(param1);
      }
      
      public function serializeAs_GameRolePlayDelayedActionFinishedMessage(param1:ICustomDataOutput) : void
      {
         if(this.delayedCharacterId < -9007199254740990 || this.delayedCharacterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.delayedCharacterId + ") on element delayedCharacterId.");
         }
         param1.writeDouble(this.delayedCharacterId);
         param1.writeByte(this.delayTypeId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameRolePlayDelayedActionFinishedMessage(param1);
      }
      
      public function deserializeAs_GameRolePlayDelayedActionFinishedMessage(param1:ICustomDataInput) : void
      {
         this.delayedCharacterId = param1.readDouble();
         if(this.delayedCharacterId < -9007199254740990 || this.delayedCharacterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.delayedCharacterId + ") on element of GameRolePlayDelayedActionFinishedMessage.delayedCharacterId.");
         }
         this.delayTypeId = param1.readByte();
         if(this.delayTypeId < 0)
         {
            throw new Error("Forbidden value (" + this.delayTypeId + ") on element of GameRolePlayDelayedActionFinishedMessage.delayTypeId.");
         }
      }
   }
}
