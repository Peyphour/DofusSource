package com.ankamagames.dofus.network.messages.connection
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class SelectedServerDataMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 42;
       
      
      private var _isInitialized:Boolean = false;
      
      public var serverId:uint = 0;
      
      public var address:String = "";
      
      public var port:uint = 0;
      
      public var canCreateNewCharacter:Boolean = false;
      
      public var ticket:Vector.<int>;
      
      public function SelectedServerDataMessage()
      {
         this.ticket = new Vector.<int>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 42;
      }
      
      public function initSelectedServerDataMessage(param1:uint = 0, param2:String = "", param3:uint = 0, param4:Boolean = false, param5:Vector.<int> = null) : SelectedServerDataMessage
      {
         this.serverId = param1;
         this.address = param2;
         this.port = param3;
         this.canCreateNewCharacter = param4;
         this.ticket = param5;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.serverId = 0;
         this.address = "";
         this.port = 0;
         this.canCreateNewCharacter = false;
         this.ticket = new Vector.<int>();
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
         this.serializeAs_SelectedServerDataMessage(param1);
      }
      
      public function serializeAs_SelectedServerDataMessage(param1:ICustomDataOutput) : void
      {
         if(this.serverId < 0)
         {
            throw new Error("Forbidden value (" + this.serverId + ") on element serverId.");
         }
         param1.writeVarShort(this.serverId);
         param1.writeUTF(this.address);
         if(this.port < 0 || this.port > 65535)
         {
            throw new Error("Forbidden value (" + this.port + ") on element port.");
         }
         param1.writeShort(this.port);
         param1.writeBoolean(this.canCreateNewCharacter);
         param1.writeVarInt(this.ticket.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.ticket.length)
         {
            param1.writeByte(this.ticket[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_SelectedServerDataMessage(param1);
      }
      
      public function deserializeAs_SelectedServerDataMessage(param1:ICustomDataInput) : void
      {
         var _loc4_:int = 0;
         this.serverId = param1.readVarUhShort();
         if(this.serverId < 0)
         {
            throw new Error("Forbidden value (" + this.serverId + ") on element of SelectedServerDataMessage.serverId.");
         }
         this.address = param1.readUTF();
         this.port = param1.readUnsignedShort();
         if(this.port < 0 || this.port > 65535)
         {
            throw new Error("Forbidden value (" + this.port + ") on element of SelectedServerDataMessage.port.");
         }
         this.canCreateNewCharacter = param1.readBoolean();
         var _loc2_:uint = param1.readVarInt();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readByte();
            this.ticket.push(_loc4_);
            _loc3_++;
         }
      }
   }
}
