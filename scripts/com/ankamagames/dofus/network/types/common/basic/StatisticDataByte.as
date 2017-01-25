package com.ankamagames.dofus.network.types.common.basic
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class StatisticDataByte extends StatisticData implements INetworkType
   {
      
      public static const protocolId:uint = 486;
       
      
      public var value:int = 0;
      
      public function StatisticDataByte()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 486;
      }
      
      public function initStatisticDataByte(param1:int = 0) : StatisticDataByte
      {
         this.value = param1;
         return this;
      }
      
      override public function reset() : void
      {
         this.value = 0;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_StatisticDataByte(param1);
      }
      
      public function serializeAs_StatisticDataByte(param1:ICustomDataOutput) : void
      {
         super.serializeAs_StatisticData(param1);
         param1.writeByte(this.value);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_StatisticDataByte(param1);
      }
      
      public function deserializeAs_StatisticDataByte(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.value = param1.readByte();
      }
   }
}
