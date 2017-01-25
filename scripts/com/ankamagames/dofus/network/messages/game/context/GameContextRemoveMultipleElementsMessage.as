package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameContextRemoveMultipleElementsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 252;
       
      
      private var _isInitialized:Boolean = false;
      
      public var id:Vector.<Number>;
      
      public function GameContextRemoveMultipleElementsMessage()
      {
         this.id = new Vector.<Number>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 252;
      }
      
      public function initGameContextRemoveMultipleElementsMessage(param1:Vector.<Number> = null) : GameContextRemoveMultipleElementsMessage
      {
         this.id = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.id = new Vector.<Number>();
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
         this.serializeAs_GameContextRemoveMultipleElementsMessage(param1);
      }
      
      public function serializeAs_GameContextRemoveMultipleElementsMessage(param1:ICustomDataOutput) : void
      {
         param1.writeShort(this.id.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.id.length)
         {
            if(this.id[_loc2_] < -9007199254740990 || this.id[_loc2_] > 9007199254740990)
            {
               throw new Error("Forbidden value (" + this.id[_loc2_] + ") on element 1 (starting at 1) of id.");
            }
            param1.writeDouble(this.id[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameContextRemoveMultipleElementsMessage(param1);
      }
      
      public function deserializeAs_GameContextRemoveMultipleElementsMessage(param1:ICustomDataInput) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readDouble();
            if(_loc4_ < -9007199254740990 || _loc4_ > 9007199254740990)
            {
               throw new Error("Forbidden value (" + _loc4_ + ") on elements of id.");
            }
            this.id.push(_loc4_);
            _loc3_++;
         }
      }
   }
}
