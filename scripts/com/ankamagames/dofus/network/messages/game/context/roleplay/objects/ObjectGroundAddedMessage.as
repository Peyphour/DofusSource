package com.ankamagames.dofus.network.messages.game.context.roleplay.objects
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ObjectGroundAddedMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 3017;
       
      
      private var _isInitialized:Boolean = false;
      
      public var cellId:uint = 0;
      
      public var objectGID:uint = 0;
      
      public function ObjectGroundAddedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 3017;
      }
      
      public function initObjectGroundAddedMessage(param1:uint = 0, param2:uint = 0) : ObjectGroundAddedMessage
      {
         this.cellId = param1;
         this.objectGID = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.cellId = 0;
         this.objectGID = 0;
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
         this.serializeAs_ObjectGroundAddedMessage(param1);
      }
      
      public function serializeAs_ObjectGroundAddedMessage(param1:ICustomDataOutput) : void
      {
         if(this.cellId < 0 || this.cellId > 559)
         {
            throw new Error("Forbidden value (" + this.cellId + ") on element cellId.");
         }
         param1.writeVarShort(this.cellId);
         if(this.objectGID < 0)
         {
            throw new Error("Forbidden value (" + this.objectGID + ") on element objectGID.");
         }
         param1.writeVarShort(this.objectGID);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ObjectGroundAddedMessage(param1);
      }
      
      public function deserializeAs_ObjectGroundAddedMessage(param1:ICustomDataInput) : void
      {
         this.cellId = param1.readVarUhShort();
         if(this.cellId < 0 || this.cellId > 559)
         {
            throw new Error("Forbidden value (" + this.cellId + ") on element of ObjectGroundAddedMessage.cellId.");
         }
         this.objectGID = param1.readVarUhShort();
         if(this.objectGID < 0)
         {
            throw new Error("Forbidden value (" + this.objectGID + ") on element of ObjectGroundAddedMessage.objectGID.");
         }
      }
   }
}
