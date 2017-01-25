package com.ankamagames.dofus.network.messages.game.guild.tax
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GuildFightLeaveRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5715;
       
      
      private var _isInitialized:Boolean = false;
      
      public var taxCollectorId:uint = 0;
      
      public var characterId:Number = 0;
      
      public function GuildFightLeaveRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5715;
      }
      
      public function initGuildFightLeaveRequestMessage(param1:uint = 0, param2:Number = 0) : GuildFightLeaveRequestMessage
      {
         this.taxCollectorId = param1;
         this.characterId = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.taxCollectorId = 0;
         this.characterId = 0;
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
         this.serializeAs_GuildFightLeaveRequestMessage(param1);
      }
      
      public function serializeAs_GuildFightLeaveRequestMessage(param1:ICustomDataOutput) : void
      {
         if(this.taxCollectorId < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorId + ") on element taxCollectorId.");
         }
         param1.writeInt(this.taxCollectorId);
         if(this.characterId < 0 || this.characterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.characterId + ") on element characterId.");
         }
         param1.writeVarLong(this.characterId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GuildFightLeaveRequestMessage(param1);
      }
      
      public function deserializeAs_GuildFightLeaveRequestMessage(param1:ICustomDataInput) : void
      {
         this.taxCollectorId = param1.readInt();
         if(this.taxCollectorId < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorId + ") on element of GuildFightLeaveRequestMessage.taxCollectorId.");
         }
         this.characterId = param1.readVarUhLong();
         if(this.characterId < 0 || this.characterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.characterId + ") on element of GuildFightLeaveRequestMessage.characterId.");
         }
      }
   }
}
