package com.ankamagames.dofus.network.messages.game.approach
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class AccountLoggingKickedMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6029;
       
      
      private var _isInitialized:Boolean = false;
      
      public var days:uint = 0;
      
      public var hours:uint = 0;
      
      public var minutes:uint = 0;
      
      public function AccountLoggingKickedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6029;
      }
      
      public function initAccountLoggingKickedMessage(param1:uint = 0, param2:uint = 0, param3:uint = 0) : AccountLoggingKickedMessage
      {
         this.days = param1;
         this.hours = param2;
         this.minutes = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.days = 0;
         this.hours = 0;
         this.minutes = 0;
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
         this.serializeAs_AccountLoggingKickedMessage(param1);
      }
      
      public function serializeAs_AccountLoggingKickedMessage(param1:ICustomDataOutput) : void
      {
         if(this.days < 0)
         {
            throw new Error("Forbidden value (" + this.days + ") on element days.");
         }
         param1.writeVarShort(this.days);
         if(this.hours < 0)
         {
            throw new Error("Forbidden value (" + this.hours + ") on element hours.");
         }
         param1.writeByte(this.hours);
         if(this.minutes < 0)
         {
            throw new Error("Forbidden value (" + this.minutes + ") on element minutes.");
         }
         param1.writeByte(this.minutes);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_AccountLoggingKickedMessage(param1);
      }
      
      public function deserializeAs_AccountLoggingKickedMessage(param1:ICustomDataInput) : void
      {
         this.days = param1.readVarUhShort();
         if(this.days < 0)
         {
            throw new Error("Forbidden value (" + this.days + ") on element of AccountLoggingKickedMessage.days.");
         }
         this.hours = param1.readByte();
         if(this.hours < 0)
         {
            throw new Error("Forbidden value (" + this.hours + ") on element of AccountLoggingKickedMessage.hours.");
         }
         this.minutes = param1.readByte();
         if(this.minutes < 0)
         {
            throw new Error("Forbidden value (" + this.minutes + ") on element of AccountLoggingKickedMessage.minutes.");
         }
      }
   }
}
