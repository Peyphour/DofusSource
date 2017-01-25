package com.ankamagames.dofus.network.messages.game.context.fight
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameFightJoinRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 701;
       
      
      private var _isInitialized:Boolean = false;
      
      public var fighterId:Number = 0;
      
      public var fightId:int = 0;
      
      public function GameFightJoinRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 701;
      }
      
      public function initGameFightJoinRequestMessage(param1:Number = 0, param2:int = 0) : GameFightJoinRequestMessage
      {
         this.fighterId = param1;
         this.fightId = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.fighterId = 0;
         this.fightId = 0;
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
         this.serializeAs_GameFightJoinRequestMessage(param1);
      }
      
      public function serializeAs_GameFightJoinRequestMessage(param1:ICustomDataOutput) : void
      {
         if(this.fighterId < -9007199254740990 || this.fighterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.fighterId + ") on element fighterId.");
         }
         param1.writeDouble(this.fighterId);
         param1.writeInt(this.fightId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameFightJoinRequestMessage(param1);
      }
      
      public function deserializeAs_GameFightJoinRequestMessage(param1:ICustomDataInput) : void
      {
         this.fighterId = param1.readDouble();
         if(this.fighterId < -9007199254740990 || this.fighterId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.fighterId + ") on element of GameFightJoinRequestMessage.fighterId.");
         }
         this.fightId = param1.readInt();
      }
   }
}
