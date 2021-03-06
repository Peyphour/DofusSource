package com.ankamagames.dofus.network.messages.game.basic
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.social.AbstractSocialGroupInfos;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.utils.BooleanByteWrapper;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class BasicWhoIsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 180;
       
      
      private var _isInitialized:Boolean = false;
      
      public var self:Boolean = false;
      
      public var position:int = -1;
      
      public var accountNickname:String = "";
      
      public var accountId:uint = 0;
      
      public var playerName:String = "";
      
      public var playerId:Number = 0;
      
      public var areaId:int = 0;
      
      public var serverId:int = 0;
      
      public var originServerId:int = 0;
      
      public var socialGroups:Vector.<AbstractSocialGroupInfos>;
      
      public var verbose:Boolean = false;
      
      public var playerState:uint = 99;
      
      public function BasicWhoIsMessage()
      {
         this.socialGroups = new Vector.<AbstractSocialGroupInfos>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 180;
      }
      
      public function initBasicWhoIsMessage(param1:Boolean = false, param2:int = -1, param3:String = "", param4:uint = 0, param5:String = "", param6:Number = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:Vector.<AbstractSocialGroupInfos> = null, param11:Boolean = false, param12:uint = 99) : BasicWhoIsMessage
      {
         this.self = param1;
         this.position = param2;
         this.accountNickname = param3;
         this.accountId = param4;
         this.playerName = param5;
         this.playerId = param6;
         this.areaId = param7;
         this.serverId = param8;
         this.originServerId = param9;
         this.socialGroups = param10;
         this.verbose = param11;
         this.playerState = param12;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.self = false;
         this.position = -1;
         this.accountNickname = "";
         this.accountId = 0;
         this.playerName = "";
         this.playerId = 0;
         this.areaId = 0;
         this.serverId = 0;
         this.originServerId = 0;
         this.socialGroups = new Vector.<AbstractSocialGroupInfos>();
         this.verbose = false;
         this.playerState = 99;
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
         this.serializeAs_BasicWhoIsMessage(param1);
      }
      
      public function serializeAs_BasicWhoIsMessage(param1:ICustomDataOutput) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,0,this.self);
         _loc2_ = BooleanByteWrapper.setFlag(_loc2_,1,this.verbose);
         param1.writeByte(_loc2_);
         param1.writeByte(this.position);
         param1.writeUTF(this.accountNickname);
         if(this.accountId < 0)
         {
            throw new Error("Forbidden value (" + this.accountId + ") on element accountId.");
         }
         param1.writeInt(this.accountId);
         param1.writeUTF(this.playerName);
         if(this.playerId < 0 || this.playerId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.playerId + ") on element playerId.");
         }
         param1.writeVarLong(this.playerId);
         param1.writeShort(this.areaId);
         param1.writeShort(this.serverId);
         param1.writeShort(this.originServerId);
         param1.writeShort(this.socialGroups.length);
         var _loc3_:uint = 0;
         while(_loc3_ < this.socialGroups.length)
         {
            param1.writeShort((this.socialGroups[_loc3_] as AbstractSocialGroupInfos).getTypeId());
            (this.socialGroups[_loc3_] as AbstractSocialGroupInfos).serialize(param1);
            _loc3_++;
         }
         param1.writeByte(this.playerState);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_BasicWhoIsMessage(param1);
      }
      
      public function deserializeAs_BasicWhoIsMessage(param1:ICustomDataInput) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:AbstractSocialGroupInfos = null;
         var _loc2_:uint = param1.readByte();
         this.self = BooleanByteWrapper.getFlag(_loc2_,0);
         this.verbose = BooleanByteWrapper.getFlag(_loc2_,1);
         this.position = param1.readByte();
         this.accountNickname = param1.readUTF();
         this.accountId = param1.readInt();
         if(this.accountId < 0)
         {
            throw new Error("Forbidden value (" + this.accountId + ") on element of BasicWhoIsMessage.accountId.");
         }
         this.playerName = param1.readUTF();
         this.playerId = param1.readVarUhLong();
         if(this.playerId < 0 || this.playerId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.playerId + ") on element of BasicWhoIsMessage.playerId.");
         }
         this.areaId = param1.readShort();
         this.serverId = param1.readShort();
         this.originServerId = param1.readShort();
         var _loc3_:uint = param1.readUnsignedShort();
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.readUnsignedShort();
            _loc6_ = ProtocolTypeManager.getInstance(AbstractSocialGroupInfos,_loc5_);
            _loc6_.deserialize(param1);
            this.socialGroups.push(_loc6_);
            _loc4_++;
         }
         this.playerState = param1.readByte();
         if(this.playerState < 0)
         {
            throw new Error("Forbidden value (" + this.playerState + ") on element of BasicWhoIsMessage.playerState.");
         }
      }
   }
}
