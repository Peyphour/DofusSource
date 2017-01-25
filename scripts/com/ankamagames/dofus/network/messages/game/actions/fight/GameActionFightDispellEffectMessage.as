package com.ankamagames.dofus.network.messages.game.actions.fight
{
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class GameActionFightDispellEffectMessage extends GameActionFightDispellMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6113;
       
      
      private var _isInitialized:Boolean = false;
      
      public var boostUID:uint = 0;
      
      public function GameActionFightDispellEffectMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return super.isInitialized && this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6113;
      }
      
      public function initGameActionFightDispellEffectMessage(param1:uint = 0, param2:Number = 0, param3:Number = 0, param4:uint = 0) : GameActionFightDispellEffectMessage
      {
         super.initGameActionFightDispellMessage(param1,param2,param3);
         this.boostUID = param4;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.boostUID = 0;
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
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_GameActionFightDispellEffectMessage(param1);
      }
      
      public function serializeAs_GameActionFightDispellEffectMessage(param1:ICustomDataOutput) : void
      {
         super.serializeAs_GameActionFightDispellMessage(param1);
         if(this.boostUID < 0)
         {
            throw new Error("Forbidden value (" + this.boostUID + ") on element boostUID.");
         }
         param1.writeInt(this.boostUID);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_GameActionFightDispellEffectMessage(param1);
      }
      
      public function deserializeAs_GameActionFightDispellEffectMessage(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.boostUID = param1.readInt();
         if(this.boostUID < 0)
         {
            throw new Error("Forbidden value (" + this.boostUID + ") on element of GameActionFightDispellEffectMessage.boostUID.");
         }
      }
   }
}
