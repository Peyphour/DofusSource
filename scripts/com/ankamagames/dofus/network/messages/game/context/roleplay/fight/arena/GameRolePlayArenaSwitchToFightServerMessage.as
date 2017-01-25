package com.ankamagames.dofus.network.messages.game.context.roleplay.fight.arena
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameRolePlayArenaSwitchToFightServerMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6575;
       
      
      private var _isInitialized:Boolean = false;
      
      public var address:String = "";
      
      public var port:uint = 0;
      
      public var ticket:Vector.<int>;
      
      public function GameRolePlayArenaSwitchToFightServerMessage()
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
         return 6575;
      }
      
      public function initGameRolePlayArenaSwitchToFightServerMessage(param1:String = "", param2:uint = 0, param3:Vector.<int> = null) : GameRolePlayArenaSwitchToFightServerMessage
      {
         this.address = param1;
         this.port = param2;
         this.ticket = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.address = "";
         this.port = 0;
         this.ticket = new Vector.<int>();
         this._isInitialized = false;
      }
      
      override public function pack(param1:ICustomDataOutput) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         this.serialize(new CustomDataWrapper(_loc2_));
         if(HASH_FUNCTION != null)
         {
            HASH_FUNCTION(_loc2_);
         }
         writePacket(param1,this.getMessageId(),_loc2_);
      }
      
      override public function unpack(param1:ICustomDataInput, param2:uint) : void
      {
         this.deserialize(param1);
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameRolePlayArenaSwitchToFightServerMessage(param1);
      }
      
      public function serializeAs_GameRolePlayArenaSwitchToFightServerMessage(param1:ICustomDataOutput) : void
      {
         param1.writeUTF(this.address);
         if(this.port < 0 || this.port > 65535)
         {
            throw new Error("Forbidden value (" + this.port + ") on element port.");
         }
         param1.writeShort(this.port);
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
         this.deserializeAs_GameRolePlayArenaSwitchToFightServerMessage(param1);
      }
      
      public function deserializeAs_GameRolePlayArenaSwitchToFightServerMessage(param1:ICustomDataInput) : void
      {
         var _loc4_:int = 0;
         this.address = param1.readUTF();
         this.port = param1.readUnsignedShort();
         if(this.port < 0 || this.port > 65535)
         {
            throw new Error("Forbidden value (" + this.port + ") on element of GameRolePlayArenaSwitchToFightServerMessage.port.");
         }
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
