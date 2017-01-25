package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameMapNoMovementMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 954;
       
      
      private var _isInitialized:Boolean = false;
      
      public var cellX:int = 0;
      
      public var cellY:int = 0;
      
      public function GameMapNoMovementMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 954;
      }
      
      public function initGameMapNoMovementMessage(param1:int = 0, param2:int = 0) : GameMapNoMovementMessage
      {
         this.cellX = param1;
         this.cellY = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.cellX = 0;
         this.cellY = 0;
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
         this.serializeAs_GameMapNoMovementMessage(param1);
      }
      
      public function serializeAs_GameMapNoMovementMessage(param1:ICustomDataOutput) : void
      {
         param1.writeShort(this.cellX);
         param1.writeShort(this.cellY);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameMapNoMovementMessage(param1);
      }
      
      public function deserializeAs_GameMapNoMovementMessage(param1:ICustomDataInput) : void
      {
         this.cellX = param1.readShort();
         this.cellY = param1.readShort();
      }
   }
}
