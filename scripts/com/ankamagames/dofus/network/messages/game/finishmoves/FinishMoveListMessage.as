package com.ankamagames.dofus.network.messages.game.finishmoves
{
   import com.ankamagames.dofus.network.types.game.finishmoves.FinishMoveInformations;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class FinishMoveListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6704;
       
      
      private var _isInitialized:Boolean = false;
      
      public var finishMoves:Vector.<FinishMoveInformations>;
      
      public function FinishMoveListMessage()
      {
         this.finishMoves = new Vector.<FinishMoveInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6704;
      }
      
      public function initFinishMoveListMessage(param1:Vector.<FinishMoveInformations> = null) : FinishMoveListMessage
      {
         this.finishMoves = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.finishMoves = new Vector.<FinishMoveInformations>();
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
         this.serializeAs_FinishMoveListMessage(param1);
      }
      
      public function serializeAs_FinishMoveListMessage(param1:ICustomDataOutput) : void
      {
         param1.writeShort(this.finishMoves.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.finishMoves.length)
         {
            (this.finishMoves[_loc2_] as FinishMoveInformations).serializeAs_FinishMoveInformations(param1);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_FinishMoveListMessage(param1);
      }
      
      public function deserializeAs_FinishMoveListMessage(param1:ICustomDataInput) : void
      {
         var _loc4_:FinishMoveInformations = null;
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new FinishMoveInformations();
            _loc4_.deserialize(param1);
            this.finishMoves.push(_loc4_);
            _loc3_++;
         }
      }
   }
}
