package com.ankamagames.dofus.network.messages.debug
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class DebugInClientMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6028;
       
      
      private var _isInitialized:Boolean = false;
      
      public var level:uint = 0;
      
      public var message:String = "";
      
      public function DebugInClientMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6028;
      }
      
      public function initDebugInClientMessage(param1:uint = 0, param2:String = "") : DebugInClientMessage
      {
         this.level = param1;
         this.message = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.level = 0;
         this.message = "";
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
         this.serializeAs_DebugInClientMessage(param1);
      }
      
      public function serializeAs_DebugInClientMessage(param1:ICustomDataOutput) : void
      {
         param1.writeByte(this.level);
         param1.writeUTF(this.message);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_DebugInClientMessage(param1);
      }
      
      public function deserializeAs_DebugInClientMessage(param1:ICustomDataInput) : void
      {
         this.level = param1.readByte();
         if(this.level < 0)
         {
            throw new Error("Forbidden value (" + this.level + ") on element of DebugInClientMessage.level.");
         }
         this.message = param1.readUTF();
      }
   }
}
