package com.ankamagames.dofus.network.messages.game.inventory.preset
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class InventoryPresetUseResultMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6163;
       
      
      private var _isInitialized:Boolean = false;
      
      public var presetId:uint = 0;
      
      public var code:uint = 3;
      
      public var unlinkedPosition:Vector.<uint>;
      
      public function InventoryPresetUseResultMessage()
      {
         this.unlinkedPosition = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6163;
      }
      
      public function initInventoryPresetUseResultMessage(param1:uint = 0, param2:uint = 3, param3:Vector.<uint> = null) : InventoryPresetUseResultMessage
      {
         this.presetId = param1;
         this.code = param2;
         this.unlinkedPosition = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.presetId = 0;
         this.code = 3;
         this.unlinkedPosition = new Vector.<uint>();
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
         this.serializeAs_InventoryPresetUseResultMessage(param1);
      }
      
      public function serializeAs_InventoryPresetUseResultMessage(param1:ICustomDataOutput) : void
      {
         if(this.presetId < 0)
         {
            throw new Error("Forbidden value (" + this.presetId + ") on element presetId.");
         }
         param1.writeByte(this.presetId);
         param1.writeByte(this.code);
         param1.writeShort(this.unlinkedPosition.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.unlinkedPosition.length)
         {
            param1.writeByte(this.unlinkedPosition[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_InventoryPresetUseResultMessage(param1);
      }
      
      public function deserializeAs_InventoryPresetUseResultMessage(param1:ICustomDataInput) : void
      {
         var _loc4_:uint = 0;
         this.presetId = param1.readByte();
         if(this.presetId < 0)
         {
            throw new Error("Forbidden value (" + this.presetId + ") on element of InventoryPresetUseResultMessage.presetId.");
         }
         this.code = param1.readByte();
         if(this.code < 0)
         {
            throw new Error("Forbidden value (" + this.code + ") on element of InventoryPresetUseResultMessage.code.");
         }
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readUnsignedByte();
            if(_loc4_ < 0 || _loc4_ > 255)
            {
               throw new Error("Forbidden value (" + _loc4_ + ") on elements of unlinkedPosition.");
            }
            this.unlinkedPosition.push(_loc4_);
            _loc3_++;
         }
      }
   }
}
