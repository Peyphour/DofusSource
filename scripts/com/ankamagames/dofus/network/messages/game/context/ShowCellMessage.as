package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class ShowCellMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5612;
       
      
      private var _isInitialized:Boolean = false;
      
      public var sourceId:Number = 0;
      
      public var cellId:uint = 0;
      
      public function ShowCellMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5612;
      }
      
      public function initShowCellMessage(param1:Number = 0, param2:uint = 0) : ShowCellMessage
      {
         this.sourceId = param1;
         this.cellId = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.sourceId = 0;
         this.cellId = 0;
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
         this.serializeAs_ShowCellMessage(param1);
      }
      
      public function serializeAs_ShowCellMessage(param1:ICustomDataOutput) : void
      {
         if(this.sourceId < -9007199254740990 || this.sourceId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.sourceId + ") on element sourceId.");
         }
         param1.writeDouble(this.sourceId);
         if(this.cellId < 0 || this.cellId > 559)
         {
            throw new Error("Forbidden value (" + this.cellId + ") on element cellId.");
         }
         param1.writeVarShort(this.cellId);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_ShowCellMessage(param1);
      }
      
      public function deserializeAs_ShowCellMessage(param1:ICustomDataInput) : void
      {
         this.sourceId = param1.readDouble();
         if(this.sourceId < -9007199254740990 || this.sourceId > 9007199254740990)
         {
            throw new Error("Forbidden value (" + this.sourceId + ") on element of ShowCellMessage.sourceId.");
         }
         this.cellId = param1.readVarUhShort();
         if(this.cellId < 0 || this.cellId > 559)
         {
            throw new Error("Forbidden value (" + this.cellId + ") on element of ShowCellMessage.cellId.");
         }
      }
   }
}
