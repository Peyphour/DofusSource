package com.ankamagames.dofus.network.messages.game.interactive.meeting
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class TeleportBuddiesRequestedMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6302;
       
      
      private var _isInitialized:Boolean = false;
      
      public var dungeonId:uint = 0;
      
      public var inviterId:Number = 0;
      
      public var invalidBuddiesIds:Vector.<Number>;
      
      public function TeleportBuddiesRequestedMessage()
      {
         this.invalidBuddiesIds = new Vector.<Number>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6302;
      }
      
      public function initTeleportBuddiesRequestedMessage(param1:uint = 0, param2:Number = 0, param3:Vector.<Number> = null) : TeleportBuddiesRequestedMessage
      {
         this.dungeonId = param1;
         this.inviterId = param2;
         this.invalidBuddiesIds = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.dungeonId = 0;
         this.inviterId = 0;
         this.invalidBuddiesIds = new Vector.<Number>();
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
         this.serializeAs_TeleportBuddiesRequestedMessage(param1);
      }
      
      public function serializeAs_TeleportBuddiesRequestedMessage(param1:ICustomDataOutput) : void
      {
         if(this.dungeonId < 0)
         {
            throw new Error("Forbidden value (" + this.dungeonId + ") on element dungeonId.");
         }
         param1.writeVarShort(this.dungeonId);
         if(this.inviterId < 0 || this.inviterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.inviterId + ") on element inviterId.");
         }
         param1.writeVarLong(this.inviterId);
         param1.writeShort(this.invalidBuddiesIds.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.invalidBuddiesIds.length)
         {
            if(this.invalidBuddiesIds[_loc2_] < 0 || this.invalidBuddiesIds[_loc2_] > 9007199254740990)
            {
               throw new Error("Forbidden value (" + this.invalidBuddiesIds[_loc2_] + ") on element 3 (starting at 1) of invalidBuddiesIds.");
            }
            param1.writeVarLong(this.invalidBuddiesIds[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_TeleportBuddiesRequestedMessage(param1);
      }
      
      public function deserializeAs_TeleportBuddiesRequestedMessage(param1:ICustomDataInput) : void
      {
         var _loc4_:Number = NaN;
         this.dungeonId = param1.readVarUhShort();
         if(this.dungeonId < 0)
         {
            throw new Error("Forbidden value (" + this.dungeonId + ") on element of TeleportBuddiesRequestedMessage.dungeonId.");
         }
         this.inviterId = param1.readVarUhLong();
         if(this.inviterId < 0 || this.inviterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.inviterId + ") on element of TeleportBuddiesRequestedMessage.inviterId.");
         }
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readVarUhLong();
            if(_loc4_ < 0 || _loc4_ > 9007199254740990)
            {
               throw new Error("Forbidden value (" + _loc4_ + ") on elements of invalidBuddiesIds.");
            }
            this.invalidBuddiesIds.push(_loc4_);
            _loc3_++;
         }
      }
   }
}
