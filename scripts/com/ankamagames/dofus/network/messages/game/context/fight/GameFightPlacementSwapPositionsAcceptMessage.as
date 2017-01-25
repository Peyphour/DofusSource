package com.ankamagames.dofus.network.messages.game.context.fight
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameFightPlacementSwapPositionsAcceptMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6547;
       
      
      private var _isInitialized:Boolean = false;
      
      public var requestId:uint = 0;
      
      public function GameFightPlacementSwapPositionsAcceptMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6547;
      }
      
      public function initGameFightPlacementSwapPositionsAcceptMessage(param1:uint = 0) : GameFightPlacementSwapPositionsAcceptMessage
      {
         this.requestId = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.requestId = 0;
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
         this.serializeAs_GameFightPlacementSwapPositionsAcceptMessage(param1);
      }
      
      public function serializeAs_GameFightPlacementSwapPositionsAcceptMessage(param1:ICustomDataOutput) : void
      {
         if(this.requestId < 0)
         {
            throw new Error("Forbidden value (" + this.requestId + ") on element requestId.");
         }
         param1.writeInt(this.requestId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameFightPlacementSwapPositionsAcceptMessage(param1);
      }
      
      public function deserializeAs_GameFightPlacementSwapPositionsAcceptMessage(param1:ICustomDataInput) : void
      {
         this.requestId = param1.readInt();
         if(this.requestId < 0)
         {
            throw new Error("Forbidden value (" + this.requestId + ") on element of GameFightPlacementSwapPositionsAcceptMessage.requestId.");
         }
      }
   }
}
