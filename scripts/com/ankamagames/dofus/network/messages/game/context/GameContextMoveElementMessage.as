package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.dofus.network.types.game.context.EntityMovementInformations;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameContextMoveElementMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 253;
       
      
      private var _isInitialized:Boolean = false;
      
      public var movement:EntityMovementInformations;
      
      public function GameContextMoveElementMessage()
      {
         this.movement = new EntityMovementInformations();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 253;
      }
      
      public function initGameContextMoveElementMessage(param1:EntityMovementInformations = null) : GameContextMoveElementMessage
      {
         this.movement = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.movement = new EntityMovementInformations();
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
         this.serializeAs_GameContextMoveElementMessage(param1);
      }
      
      public function serializeAs_GameContextMoveElementMessage(param1:ICustomDataOutput) : void
      {
         this.movement.serializeAs_EntityMovementInformations(param1);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameContextMoveElementMessage(param1);
      }
      
      public function deserializeAs_GameContextMoveElementMessage(param1:ICustomDataInput) : void
      {
         this.movement = new EntityMovementInformations();
         this.movement.deserialize(param1);
      }
   }
}
