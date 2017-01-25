package com.ankamagames.dofus.network.messages.game.context.roleplay.havenbag
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class HavenBagDailyLoteryMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6644;
       
      
      private var _isInitialized:Boolean = false;
      
      public var returnType:uint = 0;
      
      public var tokenId:String = "";
      
      public function HavenBagDailyLoteryMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6644;
      }
      
      public function initHavenBagDailyLoteryMessage(param1:uint = 0, param2:String = "") : HavenBagDailyLoteryMessage
      {
         this.returnType = param1;
         this.tokenId = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.returnType = 0;
         this.tokenId = "";
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
         this.serializeAs_HavenBagDailyLoteryMessage(param1);
      }
      
      public function serializeAs_HavenBagDailyLoteryMessage(param1:ICustomDataOutput) : void
      {
         param1.writeByte(this.returnType);
         param1.writeUTF(this.tokenId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_HavenBagDailyLoteryMessage(param1);
      }
      
      public function deserializeAs_HavenBagDailyLoteryMessage(param1:ICustomDataInput) : void
      {
         this.returnType = param1.readByte();
         if(this.returnType < 0)
         {
            throw new Error("Forbidden value (" + this.returnType + ") on element of HavenBagDailyLoteryMessage.returnType.");
         }
         this.tokenId = param1.readUTF();
      }
   }
}
