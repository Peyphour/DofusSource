package com.ankamagames.dofus.network.types.game.dare
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   public class DareCriteria implements INetworkType
   {
      
      public static const protocolId:uint = 501;
       
      
      public var type:uint = 0;
      
      public var params:Vector.<int>;
      
      public function DareCriteria()
      {
         this.params = new Vector.<int>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 501;
      }
      
      public function initDareCriteria(param1:uint = 0, param2:Vector.<int> = null) : DareCriteria
      {
         this.type = param1;
         this.params = param2;
         return this;
      }
      
      public function reset() : void
      {
         this.type = 0;
         this.params = new Vector.<int>();
      }
      
      public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_DareCriteria(param1);
      }
      
      public function serializeAs_DareCriteria(param1:ICustomDataOutput) : void
      {
         param1.writeByte(this.type);
         param1.writeShort(this.params.length);
         var _loc2_:uint = 0;
         while(_loc2_ < this.params.length)
         {
            param1.writeInt(this.params[_loc2_]);
            _loc2_++;
         }
      }
      
      public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_DareCriteria(param1);
      }
      
      public function deserializeAs_DareCriteria(param1:ICustomDataInput) : void
      {
         var _loc4_:int = 0;
         this.type = param1.readByte();
         if(this.type < 0)
         {
            throw new Error("Forbidden value (" + this.type + ") on element of DareCriteria.type.");
         }
         var _loc2_:uint = param1.readUnsignedShort();
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.readInt();
            this.params.push(_loc4_);
            _loc3_++;
         }
      }
   }
}
