package com.ankamagames.dofus.network.messages.game.dare
{
   import com.ankamagames.dofus.network.types.game.dare.DareInformations;
   import com.ankamagames.dofus.network.types.game.dare.DareVersatileInformations;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class DareInformationsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6656;
       
      
      private var _isInitialized:Boolean = false;
      
      public var dareFixedInfos:DareInformations;
      
      public var dareVersatilesInfos:DareVersatileInformations;
      
      public function DareInformationsMessage()
      {
         this.dareFixedInfos = new DareInformations();
         this.dareVersatilesInfos = new DareVersatileInformations();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6656;
      }
      
      public function initDareInformationsMessage(param1:DareInformations = null, param2:DareVersatileInformations = null) : DareInformationsMessage
      {
         this.dareFixedInfos = param1;
         this.dareVersatilesInfos = param2;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.dareFixedInfos = new DareInformations();
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
         this.serializeAs_DareInformationsMessage(param1);
      }
      
      public function serializeAs_DareInformationsMessage(param1:ICustomDataOutput) : void
      {
         this.dareFixedInfos.serializeAs_DareInformations(param1);
         this.dareVersatilesInfos.serializeAs_DareVersatileInformations(param1);
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_DareInformationsMessage(param1);
      }
      
      public function deserializeAs_DareInformationsMessage(param1:ICustomDataInput) : void
      {
         this.dareFixedInfos = new DareInformations();
         this.dareFixedInfos.deserialize(param1);
         this.dareVersatilesInfos = new DareVersatileInformations();
         this.dareVersatilesInfos.deserialize(param1);
      }
   }
}
