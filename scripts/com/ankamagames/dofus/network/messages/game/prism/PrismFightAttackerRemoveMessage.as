package com.ankamagames.dofus.network.messages.game.prism
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class PrismFightAttackerRemoveMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5897;
       
      
      private var _isInitialized:Boolean = false;
      
      public var subAreaId:uint = 0;
      
      public var fightId:uint = 0;
      
      public var fighterToRemoveId:Number = 0;
      
      public function PrismFightAttackerRemoveMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5897;
      }
      
      public function initPrismFightAttackerRemoveMessage(param1:uint = 0, param2:uint = 0, param3:Number = 0) : PrismFightAttackerRemoveMessage
      {
         this.subAreaId = param1;
         this.fightId = param2;
         this.fighterToRemoveId = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.subAreaId = 0;
         this.fightId = 0;
         this.fighterToRemoveId = 0;
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
         this.serializeAs_PrismFightAttackerRemoveMessage(param1);
      }
      
      public function serializeAs_PrismFightAttackerRemoveMessage(param1:ICustomDataOutput) : void
      {
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element subAreaId.");
         }
         param1.writeVarShort(this.subAreaId);
         if(this.fightId < 0)
         {
            throw new Error("Forbidden value (" + this.fightId + ") on element fightId.");
         }
         param1.writeVarShort(this.fightId);
         if(this.fighterToRemoveId < 0 || this.fighterToRemoveId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.fighterToRemoveId + ") on element fighterToRemoveId.");
         }
         param1.writeVarLong(this.fighterToRemoveId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PrismFightAttackerRemoveMessage(param1);
      }
      
      public function deserializeAs_PrismFightAttackerRemoveMessage(param1:ICustomDataInput) : void
      {
         this.subAreaId = param1.readVarUhShort();
         if(this.subAreaId < 0)
         {
            throw new Error("Forbidden value (" + this.subAreaId + ") on element of PrismFightAttackerRemoveMessage.subAreaId.");
         }
         this.fightId = param1.readVarUhShort();
         if(this.fightId < 0)
         {
            throw new Error("Forbidden value (" + this.fightId + ") on element of PrismFightAttackerRemoveMessage.fightId.");
         }
         this.fighterToRemoveId = param1.readVarUhLong();
         if(this.fighterToRemoveId < 0 || this.fighterToRemoveId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.fighterToRemoveId + ") on element of PrismFightAttackerRemoveMessage.fighterToRemoveId.");
         }
      }
   }
}
