package com.ankamagames.dofus.network.messages.game.idol
{
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   import com.ankamagames.dofus.network.types.game.idol.PartyIdol;
   import com.ankamagames.jerakine.network.CustomDataWrapper;
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.jerakine.network.NetworkMessage;
   import flash.utils.ByteArray;
   
   [Trusted]
   public class IdolListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6585;
       
      
      private var _isInitialized:Boolean = false;
      
      public var chosenIdols:Vector.<uint>;
      
      public var partyChosenIdols:Vector.<uint>;
      
      public var partyIdols:Vector.<PartyIdol>;
      
      public function IdolListMessage()
      {
         this.chosenIdols = new Vector.<uint>();
         this.partyChosenIdols = new Vector.<uint>();
         this.partyIdols = new Vector.<PartyIdol>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6585;
      }
      
      public function initIdolListMessage(param1:Vector.<uint> = null, param2:Vector.<uint> = null, param3:Vector.<PartyIdol> = null) : IdolListMessage
      {
         this.chosenIdols = param1;
         this.partyChosenIdols = param2;
         this.partyIdols = param3;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.chosenIdols = new Vector.<uint>();
         this.partyChosenIdols = new Vector.<uint>();
         this.partyIdols = new Vector.<PartyIdol>();
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
         this.serializeAs_IdolListMessage(param1);
      }
      
      public function serializeAs_IdolListMessage(param1:ICustomDataOutput) : void
      {
         param1.writeShort(this.chosenIdols.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.chosenIdols.length)
         {
            if(this.chosenIdols[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.chosenIdols[_loc2_] + ") on element 1 (starting at 1) of chosenIdols.");
            }
            param1.writeVarShort(this.chosenIdols[_loc2_]);
            _loc2_++;
         }
         param1.writeShort(this.partyChosenIdols.length);
         var _loc3_:uint = 0;
         while(_loc3_ < this.partyChosenIdols.length)
         {
            if(this.partyChosenIdols[_loc3_] < 0)
            {
               throw new Error("Forbidden value (" + this.partyChosenIdols[_loc3_] + ") on element 2 (starting at 1) of partyChosenIdols.");
            }
            param1.writeVarShort(this.partyChosenIdols[_loc3_]);
            _loc3_++;
         }
         param1.writeShort(this.partyIdols.length);
         var _loc4_:uint = 0;
         while(_loc4_ < this.partyIdols.length)
         {
            param1.writeShort((this.partyIdols[_loc4_] as PartyIdol).getTypeId());
            (this.partyIdols[_loc4_] as PartyIdol).serialize(param1);
            _loc4_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_IdolListMessage(param1);
      }
      
      public function deserializeAs_IdolListMessage(param1:ICustomDataInput) : void
      {
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:PartyIdol = null;
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc8_ = param1.readVarUhShort();
            if(_loc8_ < 0)
            {
               throw new Error("Forbidden value (" + _loc8_ + ") on elements of chosenIdols.");
            }
            this.chosenIdols.push(_loc8_);
            _loc3_++;
         }
         var _loc4_:uint = param1.readUnsignedShort();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc9_ = param1.readVarUhShort();
            if(_loc9_ < 0)
            {
               throw new Error("Forbidden value (" + _loc9_ + ") on elements of partyChosenIdols.");
            }
            this.partyChosenIdols.push(_loc9_);
            _loc5_++;
         }
         var _loc6_:uint = param1.readUnsignedShort();
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_)
         {
            _loc10_ = param1.readUnsignedShort();
            _loc11_ = ProtocolTypeManager.getInstance(PartyIdol,_loc10_);
            _loc11_.deserialize(param1);
            this.partyIdols.push(_loc11_);
            _loc7_++;
         }
      }
   }
}
