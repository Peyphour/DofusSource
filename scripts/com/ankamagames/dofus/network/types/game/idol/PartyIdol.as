package com.ankamagames.dofus.network.types.game.idol
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class PartyIdol extends Idol implements INetworkType
   {
      
      public static const protocolId:uint = 490;
       
      
      public var ownersIds:Vector.<Number>;
      
      public function PartyIdol()
      {
         this.ownersIds = new Vector.<Number>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 490;
      }
      
      public function initPartyIdol(param1:uint = 0, param2:uint = 0, param3:uint = 0, param4:Vector.<Number> = null) : PartyIdol
      {
         super.initIdol(param1,param2,param3);
         this.ownersIds = param4;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.ownersIds = new Vector.<Number>();
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_PartyIdol(param1);
      }
      
      public function serializeAs_PartyIdol(param1:ICustomDataOutput) : void
      {
         super.serializeAs_Idol(param1);
         param1.writeShort(this.ownersIds.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.ownersIds.length)
         {
            if(this.ownersIds[_loc2_] < 0 || this.ownersIds[_loc2_] > 9007199254740990)
            {
               throw new Error("Forbidden value (" + this.ownersIds[_loc2_] + ") on element 1 (starting at 1) of ownersIds.");
            }
            param1.writeVarLong(this.ownersIds[_loc2_]);
            _loc2_++;
         }
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_PartyIdol(param1);
      }
      
      public function deserializeAs_PartyIdol(param1:ICustomDataInput) : void
      {
         var _loc4_:Number = NaN;
         super.deserialize(param1);
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readVarUhLong();
            if(_loc4_ < 0 || _loc4_ > 9007199254740990)
            {
               throw new Error("Forbidden value (" + _loc4_ + ") on elements of ownersIds.");
            }
            this.ownersIds.push(_loc4_);
            _loc3_++;
         }
      }
   }
}
