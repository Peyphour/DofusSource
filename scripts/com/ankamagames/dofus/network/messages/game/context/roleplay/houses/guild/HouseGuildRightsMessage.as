package com.ankamagames.dofus.network.messages.game.context.roleplay.houses.guild
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.GuildInformations;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class HouseGuildRightsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5703;
       
      
      private var _isInitialized:Boolean = false;
      
      public var houseId:uint = 0;
      
      public var guildInfo:GuildInformations;
      
      public var rights:uint = 0;
      
      public function HouseGuildRightsMessage()
      {
         this.guildInfo = new GuildInformations();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5703;
      }
      
      public function initHouseGuildRightsMessage(param1:uint = 0, param2:GuildInformations = null, param3:uint = 0) : HouseGuildRightsMessage
      {
         this.houseId = param1;
         this.guildInfo = param2;
         this.rights = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.houseId = 0;
         this.guildInfo = new GuildInformations();
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
         this.serializeAs_HouseGuildRightsMessage(param1);
      }
      
      public function serializeAs_HouseGuildRightsMessage(param1:ICustomDataOutput) : void
      {
         if(this.houseId < 0)
         {
            throw new Error("Forbidden value (" + this.houseId + ") on element houseId.");
         }
         param1.writeVarInt(this.houseId);
         this.guildInfo.serializeAs_GuildInformations(param1);
         if(this.rights < 0)
         {
            throw new Error("Forbidden value (" + this.rights + ") on element rights.");
         }
         param1.writeVarInt(this.rights);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_HouseGuildRightsMessage(param1);
      }
      
      public function deserializeAs_HouseGuildRightsMessage(param1:ICustomDataInput) : void
      {
         this.houseId = param1.readVarUhInt();
         if(this.houseId < 0)
         {
            throw new Error("Forbidden value (" + this.houseId + ") on element of HouseGuildRightsMessage.houseId.");
         }
         this.guildInfo = new GuildInformations();
         this.guildInfo.deserialize(param1);
         this.rights = param1.readVarUhInt();
         if(this.rights < 0)
         {
            throw new Error("Forbidden value (" + this.rights + ") on element of HouseGuildRightsMessage.rights.");
         }
      }
   }
}
