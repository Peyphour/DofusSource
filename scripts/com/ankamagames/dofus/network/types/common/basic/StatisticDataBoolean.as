package com.ankamagames.dofus.network.types.common.basic
{
   import com.ankamagames.jerakine.network.ICustomDataInput;
   import com.ankamagames.jerakine.network.ICustomDataOutput;
   import com.ankamagames.jerakine.network.INetworkType;
   
   [Trusted]
   public class StatisticDataBoolean extends StatisticData implements INetworkType
   {
      
      public static const protocolId:uint = 482;
       
      
      public var value:Boolean = false;
      
      public function StatisticDataBoolean()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 482;
      }
      
      public function initStatisticDataBoolean(param1:Boolean = false) : StatisticDataBoolean
      {
         this.value = param1;
         return this;
      }
      
      override public function reset() : void
      {
         this.value = false;
      }
      
      override public function serialize(param1:ICustomDataOutput) : void
      {
         this.serializeAs_StatisticDataBoolean(param1);
      }
      
      public function serializeAs_StatisticDataBoolean(param1:ICustomDataOutput) : void
      {
         super.serializeAs_StatisticData(param1);
         param1.writeBoolean(this.value);
      }
      
      override public function deserialize(param1:ICustomDataInput) : void
      {
         this.deserializeAs_StatisticDataBoolean(param1);
      }
      
      public function deserializeAs_StatisticDataBoolean(param1:ICustomDataInput) : void
      {
         super.deserialize(param1);
         this.value = param1.readBoolean();
      }
   }
}
