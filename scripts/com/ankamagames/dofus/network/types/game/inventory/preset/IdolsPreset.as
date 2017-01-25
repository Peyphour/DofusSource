package com.ankamagames.dofus.network.types.game.inventory.preset
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class IdolsPreset implements INetworkType
   {
      
      public static const protocolId:uint = 491;
       
      
      public var presetId:uint = 0;
      
      public var symbolId:uint = 0;
      
      public var idolId:Vector.<uint>;
      
      public function IdolsPreset()
      {
         this.idolId = new Vector.<uint>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 491;
      }
      
      public function initIdolsPreset(param1:uint = 0, param2:uint = 0, param3:Vector.<uint> = null) : IdolsPreset
      {
         this.presetId = param1;
         this.symbolId = param2;
         this.idolId = param3;
         return this;
      }
      
      public function reset() : void
      {
         this.presetId = 0;
         this.symbolId = 0;
         this.idolId = new Vector.<uint>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_IdolsPreset(param1);
      }
      
      public function serializeAs_IdolsPreset(param1:ICustomDataOutput) : void
      {
         if(this.presetId < 0)
         {
            throw new Error("Forbidden value (" + this.presetId + ") on element presetId.");
         }
         param1.writeByte(this.presetId);
         if(this.symbolId < 0)
         {
            throw new Error("Forbidden value (" + this.symbolId + ") on element symbolId.");
         }
         param1.writeByte(this.symbolId);
         param1.writeShort(this.idolId.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.idolId.length)
         {
            if(this.idolId[_loc2_] < 0)
            {
               throw new Error("Forbidden value (" + this.idolId[_loc2_] + ") on element 3 (starting at 1) of idolId.");
            }
            param1.writeVarShort(this.idolId[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_IdolsPreset(param1);
      }
      
      public function deserializeAs_IdolsPreset(param1:ICustomDataInput) : void
      {
         var _loc4_:uint = 0;
         this.presetId = param1.readByte();
         if(this.presetId < 0)
         {
            throw new Error("Forbidden value (" + this.presetId + ") on element of IdolsPreset.presetId.");
         }
         this.symbolId = param1.readByte();
         if(this.symbolId < 0)
         {
            throw new Error("Forbidden value (" + this.symbolId + ") on element of IdolsPreset.symbolId.");
         }
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readVarUhShort();
            if(_loc4_ < 0)
            {
               throw new Error("Forbidden value (" + _loc4_ + ") on elements of idolId.");
            }
            this.idolId.push(_loc4_);
            _loc3_++;
         }
      }
   }
}
