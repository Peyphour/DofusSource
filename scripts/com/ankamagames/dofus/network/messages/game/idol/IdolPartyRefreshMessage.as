package com.ankamagames.dofus.network.messages.game.idol
{
   import com.ankamagames.dofus.network.types.game.idol.PartyIdol;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class IdolPartyRefreshMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6583;
       
      
      private var _isInitialized:Boolean = false;
      
      public var partyIdol:PartyIdol;
      
      public function IdolPartyRefreshMessage()
      {
         this.partyIdol = new PartyIdol();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6583;
      }
      
      public function initIdolPartyRefreshMessage(param1:PartyIdol = null) : IdolPartyRefreshMessage
      {
         this.partyIdol = param1;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.partyIdol = new PartyIdol();
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
         this.serializeAs_IdolPartyRefreshMessage(param1);
      }
      
      public function serializeAs_IdolPartyRefreshMessage(param1:ICustomDataOutput) : void
      {
         this.partyIdol.serializeAs_PartyIdol(param1);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_IdolPartyRefreshMessage(param1);
      }
      
      public function deserializeAs_IdolPartyRefreshMessage(param1:ICustomDataInput) : void
      {
         this.partyIdol = new PartyIdol();
         this.partyIdol.deserialize(param1);
      }
   }
}
