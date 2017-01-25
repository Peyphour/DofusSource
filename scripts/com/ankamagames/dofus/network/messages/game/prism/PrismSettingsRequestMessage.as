package com.ankamagames.dofus.network.messages.game.prism
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class PrismSettingsRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6437;
       
      
      private var _isInitialized:Boolean = false;
      
      public var subAreaId:uint = 0;
      
      public var startDefenseTime:uint = 0;
      
      public function PrismSettingsRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6437;
      }
      
      public function initPrismSettingsRequestMessage(param1:uint = 0, param2:uint = 0) : PrismSettingsRequestMessage
      {
         this.subAreaId = param1;
         this.startDefenseTime = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.subAreaId = 0;
         this.startDefenseTime = 0;
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
         this.serializeAs_PrismSettingsRequestMessage(param1);
      }
      
      public function serializeAs_PrismSettingsRequestMessage(param1:ICustomDataOutput) : void
      {
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element subAreaId.");
         }
         param1.writeVarShort(this.subAreaId);
         if(this.startDefenseTime < 0)
         {
            throw new Error("Forbidden value (" + this.startDefenseTime + ") on element startDefenseTime.");
         }
         param1.writeByte(this.startDefenseTime);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PrismSettingsRequestMessage(param1);
      }
      
      public function deserializeAs_PrismSettingsRequestMessage(param1:ICustomDataInput) : void
      {
         this.subAreaId = param1.readVarUhShort();
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element of PrismSettingsRequestMessage.subAreaId.");
         }
         this.startDefenseTime = param1.readByte();
         if(this.startDefenseTime < 0)
         {
            throw new Error("Forbidden value (" + this.startDefenseTime + ") on element of PrismSettingsRequestMessage.startDefenseTime.");
         }
      }
   }
}
